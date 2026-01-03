unit frFrameNavEv;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Actions,
  System.Math,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ControlList,
  Vcl.Themes, Vcl.Styles, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.WinXCtrls,  Vcl.ActnList, Vcl.Menus, Vcl.WinXPanels,

  SVGIconImage,
  Data.DB,

  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  uUtility, uDefines,

  dmIMG, dmSCM2, dmCORE, frFrameNavEvItem;

type

//  TNavEvItemSelected = procedure(Sender: TObject; EventID: Integer; EvItem:
//      TFrameNavEvItem) of object;

  TFrameNavEv = class(TFrame)
    rpnlBody: TRelativePanel;
    scrBox: TScrollBox;
    spbtnNavLeft: TSpeedButton;
    spbtnNavRight: TSpeedButton;
    procedure spbtnNavLeftClick(Sender: TObject);
    procedure spbtnNavRightClick(Sender: TObject);
  private
    FCustomHorz: TScrollBar; // CUSTOM HORZSCROLLBAR
    { CUSTOM HORZSCROLLBAR - CODE READY - FOR THIN SCROLLBAR...}
    procedure CreateCustomHorz;
    procedure CustomHorzChange(Sender: TObject);
//    procedure SelectNone();
    procedure UpdateCustomHorz;
    function UpdateSelect(EventID: integer): TFrameNavEvItem;
  protected
    procedure Msg_SCM_Frame_Reset(var Msg: TMessage); message SCM_FRAME_RESET;
    procedure Msg_SCM_Frame_Selected(var Msg: TMessage); message SCM_FRAME_SELECTED;
    procedure Msg_SCM_Scroll_Event(var Msg: TMessage); message SCM_SCROLL_EVENT;
  public
//    FOnNavEvItemSelected: TNavEvItemSelected; // MainForm proc for selection.
    procedure FillNavEvItems;
    procedure InitialiseDB;
    procedure InitialiseUI;
  end;

var
  ScrollLockEvItem: boolean = true;


implementation

{$R *.dfm}

uses
  uSession, uEvent;

{ HELPER ROUTINES...}

function GetRectRelativeToAncestor(ACtrl, AAncestor: TControl): TRect;
var
  R: TRect;
  C: TControl;
begin
  R := ACtrl.BoundsRect;
  C := ACtrl.Parent;
  while (C <> nil) and (C <> AAncestor) do
  begin
    OffsetRect(R, C.Left, C.Top);
    C := C.Parent;
  end;
  Result := R;
end;

procedure RecalcScrollBoxContentSize(AScrollBox: TScrollBox; out ContentWidth, ContentHeight: Integer);
var
  I: Integer;
  R: TRect;
  C: TControl;
begin
  ContentWidth := 0;
  ContentHeight := 0;
  for I := 0 to AScrollBox.ControlCount - 1 do
  begin
    C := AScrollBox.Controls[I];
    R := GetRectRelativeToAncestor(C, AScrollBox);
    if R.Right > ContentWidth then ContentWidth := R.Right;
    if R.Bottom > ContentHeight then ContentHeight := R.Bottom;
  end;
end;

procedure UpdateBuiltInHorzRange(AScrollBox: TScrollBox);
var
  ContentW, ContentH, MaxPos: Integer;
begin
  RecalcScrollBoxContentSize(AScrollBox, ContentW, ContentH);
  // Set the range so VCL/Windows knows content extent
  AScrollBox.HorzScrollBar.Range := ContentW;
  // Ensure Position is valid
  MaxPos := Max(0, ContentW - AScrollBox.ClientWidth);
  if AScrollBox.HorzScrollBar.Position > MaxPos then
    AScrollBox.HorzScrollBar.Position := MaxPos;
  // Show or hide the native scrollbar
  ShowScrollBar(AScrollBox.Handle, SB_HORZ, ContentW > AScrollBox.ClientWidth);
end;

procedure CenterControlInScrollBox(AScrollBox: TScrollBox; ACtrl: TControl);
var
  TargetX, TargetY, MaxX, MaxY, clw, clh: Integer;
begin
  if ACtrl = nil then exit;

//  AScrollBox.Realign; // ensure child positions are final

  if AScrollBox.AlignWithMargins then
  begin
    clw := (AScrollBox.ClientWidth - AScrollBox.Margins.Left - AScrollBox.Margins.Right);
    clh := (AScrollBox.ClientHeight - AScrollBox.Margins.top - AScrollBox.Margins.bottom);
  end
  else
  begin
    clw := AScrollBox.ClientWidth div 2;
    clh := AScrollBox.ClientHeight div 2;
  end;

  TargetX := ACtrl.Left + (ACtrl.Width div 2) - (clw div 2);
  TargetY := ACtrl.Top  + (ACtrl.Height div 2) - (clh div 2);

  MaxX := AScrollBox.HorzScrollBar.Range - clw;
  MaxY := AScrollBox.VertScrollBar.Range - clh;

  if MaxX < 0 then MaxX := 0;
  if MaxY < 0 then MaxY := 0;

  if TargetX < 0 then TargetX := 0 else if TargetX > MaxX then TargetX := MaxX;
  if TargetY < 0 then TargetY := 0 else if TargetY > MaxY then TargetY := MaxY;

  AScrollBox.HorzScrollBar.Position := TargetX;
  AScrollBox.VertScrollBar.Position := TargetY;
end;

function IsControlFullyVisibleInScrollBox(AScrollBox: TScrollBox; ACtrl: TControl): Boolean;
var
  R, ClientR: TRect;
begin
  if (AScrollBox = nil) or (ACtrl = nil) then Exit(False);
  R := GetRectRelativeToAncestor(ACtrl, AScrollBox);
  OffsetRect(R, -AScrollBox.HorzScrollBar.Position, -AScrollBox.VertScrollBar.Position);
  ClientR := Rect(0, 0, AScrollBox.ClientWidth, AScrollBox.ClientHeight);
  Result := (R.Left >= ClientR.Left) {and (R.Top >= ClientR.Top) } and
            (R.Right <= ClientR.Right) {and (R.Bottom <= ClientR.Bottom)};
end;

{ TFrameNavEvent }

procedure TFrameNavEv.CreateCustomHorz;
begin
{ CUSTOM HORZSCROLLBAR - CODE READY - FOR THIN SCROLLBAR...}
  FCustomHorz := TScrollBar.Create(Self);
  FCustomHorz.Parent := Self;         // keep it on the frame (not inside scrBox)
  FCustomHorz.Kind := sbHorizontal;
  FCustomHorz.Align := alBottom;
  FCustomHorz.Height := Max(8, scrBox.HorzScrollBar.Size - 4); // desired thinner height
  FCustomHorz.Visible := False;
  FCustomHorz.OnChange := CustomHorzChange;
end;

procedure TFrameNavEv.CustomHorzChange(Sender: TObject);
begin
{ CUSTOM HORZSCROLLBAR - CODE READY - FOR THIN SCROLLBAR...}
  // user moved custom scrollbar => scroll the scrollbox
  scrBox.HorzScrollBar.Position := FCustomHorz.Position;
end;

procedure TFrameNavEv.FillNavEvItems;
var
  Frame: TFrameNavEvItem;
  Q: TFDQuery;
  PK: integer;
  found: boolean;
begin
  // exception traps.
  if not Assigned(SCM2) or not SCM2.scmConnection.connected then exit;
  if not Assigned(CORE) or not CORE.IsActive then exit;
  PK := 0;
  found := false;
  // 1. Performance: Disable UI updates
  LockDrawing;
  scrBox.DisableAlign;
  Q := CORE.qryEvent; // improves readability.
  Q.DisableControls;
  uEvent.DetailTBLs_DisableCNTRLs;
  try
    // 2. Clear existing frames
    while scrBox.ControlCount > 0 do
      scrBox.Controls[0].Free;

    if Q.IsEmpty then exit;   // nothing to display

    PK := uEvent.PK; // store record position.

    // 3. Loop through FireDAC / MS SQL Query
    Q.First;
    while not Q.Eof do
    begin
      Frame := TFrameNavEvItem.Create(nil);
      Frame.Parent := scrBox;
      Frame.ParentFrame := Self;
      Frame.ParentFont := false;
      Frame.StyleElements := Frame.StyleElements - [seFont];

      // 4. Horizontal Alignment
      Frame.Align := alLeft;
      Frame.Margins.Right := 10; // Space between items
      Frame.AlignWithMargins := True;

      // Force it to the end of the list (important for alLeft)
      Frame.Left := MaxInt;

      // 5. Fill Data
      Frame.FillFromQuery(Q);

      // 6. Handle Clicks (Optional)
      // Capture the PK so we know which record was clicked.
      Frame.Tag := Q.FieldByName('EventID').AsInteger;

      Q.Next;
    end;
  finally
    if PK <> 0 then
      found := uEvent.Locate(PK); // relocate to stored record ID.

    Q.EnableControls;
    if not found then uEvent.DetailTBLs_ApplyMaster; // precautionary trap.
    uEvent.DetailTBLs_EnableCNTRLs;
    scrBox.EnableAlign;
    scrBox.Realign; // Calcs range - ensures scrollbar is displayed.
    UnlockDrawing;
  end;
end;

procedure TFrameNavEv.InitialiseDB;
begin
    FillNavEvItems();
end;

procedure TFrameNavEv.InitialiseUI;
begin
  rpnlBody.Visible := false;
  if not Assigned(SCM2) or not SCM2.scmConnection.connected then exit;
  if not Assigned(CORE) or not CORE.IsActive then exit;
  rpnlBody.Visible := not CORE.qryEvent.IsEmpty();
  // if CORE.IsWorkingOnConnection = true, then safe to call here...
  // without the DB 'frame AfterScoll' messages.
  if CORE.IsWorkingOnConnection then
    InitialiseDB;
end;

procedure TFrameNavEv.Msg_SCM_Frame_Reset(var Msg: TMessage);
begin
  FillNavEvItems();
end;

procedure TFrameNavEv.Msg_SCM_Frame_Selected(var Msg: TMessage);
var
  PK: integer;
begin
    // exception traps.
    if Msg.WParam = 0 then exit;   // will hold an EventID.
    if not Assigned(SCM2) or not SCM2.scmConnection.connected then exit;
    if not Assigned(CORE) or not CORE.IsActive then exit;
    if (CORE.qryEvent.State in [dsOpening]) then exit;

    PK := Msg.WParam;
    if (uEvent.PK() <> PK) then
      // locate event record..
      // This triggers a scroll event which intern triggers a
      // TFrameNavEv.Msg_SCM_Scroll_Event...
      uEvent.Locate(PK);
end;

procedure TFrameNavEv.Msg_SCM_Scroll_Event(var Msg: TMessage);
var
  NavEvItem: TFrameNavEvItem;
begin
  if Msg.WParam <> 0 then
  begin
    NavEvItem := UpdateSelect(Msg.WParam);
    if NavEvItem <> nil then
    begin
      LockDrawing;
      if not IsControlFullyVisibleInScrollBox(scrBox, NavEvItem) then
        CenterControlInScrollBox(scrBox, NavEvItem);
      // scrBox.ScrollInView(NavEvItem); // note: doesn't center control...
      UnlockDrawing;
    end;
  end;
end;

procedure TFrameNavEv.spbtnNavLeftClick(Sender: TObject);
var
  metric: integer;
begin
  if scrBox.ControlCount = 0 then exit;
  if ScrollLockEvItem and ((GetKeyState(VK_CONTROL) and 128) = 128) then
  begin
    CORE.qryEvent.Prior; // ctrl ovverides - triggers scroll event
  end
  else if ScrollLockEvItem then
  begin
    metric := Round(scrBox.Controls[0].Width / 2);
    if scrBox.HorzScrollBar.Position - Metric  > 0 then
      scrBox.HorzScrollBar.Position := scrBox.HorzScrollBar.Position - Metric
    else scrBox.HorzScrollBar.Position := 0;
  end
  else
  begin
    CORE.qryEvent.Prior;
  end;
end;

procedure TFrameNavEv.spbtnNavRightClick(Sender: TObject);
var
  metric: integer;
begin
  if scrBox.ControlCount = 0 then exit;

  if ScrollLockEvItem and ((GetKeyState(VK_CONTROL) and 128) = 128) then
  begin
    CORE.qryEvent.Next; // ctrl ovverides - triggers scroll event
  end
  else if ScrollLockEvItem then
  begin
    metric := Round(scrBox.Controls[0].Width / 2);
    if scrBox.HorzScrollBar.Position + Metric < scrBox.HorzScrollBar.Range then
      scrBox.HorzScrollBar.Position := scrBox.HorzScrollBar.Position + Metric
    else
      scrBox.HorzScrollBar.Position := scrBox.HorzScrollBar.Range;
  end
  else
  begin
    CORE.qryEvent.Next; // triggers scroll event
  end;

end;

procedure TFrameNavEv.UpdateCustomHorz;
begin
{ CUSTOM HORZSCROLLBAR - CODE READY - FOR THIN SCROLLBAR...}
  if not Assigned(FCustomHorz) then Exit;
  // ensure scrBox handle exists
  if not scrBox.HandleAllocated then scrBox.HandleNeeded;
  // hide the built-in horizontal bar (visual only)
  ShowScrollBar(scrBox.Handle, SB_HORZ, False);

  if scrBox.HorzScrollBar.Range > scrBox.ClientWidth then
  begin
    FCustomHorz.Visible := True;
    FCustomHorz.Min := 0;
    FCustomHorz.Max := scrBox.HorzScrollBar.Range - scrBox.ClientWidth;
    FCustomHorz.PageSize := scrBox.ClientWidth;
    FCustomHorz.Position := scrBox.HorzScrollBar.Position;
  end
  else
    FCustomHorz.Visible := False;
end;

function TFrameNavEv.UpdateSelect(EventID: integer): TFrameNavEvItem;
var
  I: integer;
  NavEvItem: TFrameNavEvItem;
begin
  result := nil;
  LockDrawing;
  try
    begin
      for I := 0 to scrBox.ControlCount - 1 do
      begin
        NavEvItem := TFrameNavEvItem(scrBox.Controls[I]);
        if (scrBox.Controls[I].Tag = EventID) then
        begin
          NavEvItem.Select(true);
          result := NavEvItem;
        end
        else
          NavEvItem.Select(false);
      end;
    end;
  finally
    UnlockDrawing;
  end;
end;

end.
