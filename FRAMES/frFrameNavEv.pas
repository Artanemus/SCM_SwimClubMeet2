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
  TNavEvItemSelected = procedure(Sender: TObject; EventID: Integer; EvItem:
      TFrameNavEvItem) of object;

  TFrameNavEv = class(TFrame)
    rpnlBody: TRelativePanel;
    spbtnNavLeft: TSpeedButton;
    spbtnNavRight: TSpeedButton;
    scrBox: TScrollBox;
    procedure spbtnNavLeftClick(Sender: TObject);
    procedure spbtnNavRightClick(Sender: TObject);
  private
    FCustomHorz: TScrollBar; // CUSTOM HORZSCROLLBAR

    procedure SelectNone();
    procedure UpdateSelect(EventID: integer);

    { CUSTOM HORZSCROLLBAR - CODE READY - FOR THIN SCROLLBAR...}
    procedure CreateCustomHorz;
    procedure UpdateCustomHorz;
    procedure CustomHorzChange(Sender: TObject);

  public

    FOnNavEvItemSelected: TNavEvItemSelected; // MainForm proc for selection.

//    procedure ClearNavEvItems;
    procedure FillNavEvItems;
//    function LocateNavEvItem(EventID: integer): Integer;

  protected
    procedure Msg_SCM_Frame_Selected(var Msg: TMessage); message SCM_FRAME_SELECTED;
    procedure Msg_SCM_Scroll_Event(var Msg: TMessage); message SCM_SCROLL_EVENT;
    procedure Msg_SCM_Frame_Reset(var Msg: TMessage); message SCM_FRAME_RESET;
  end;

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
  TargetX, TargetY, MaxX, MaxY: Integer;
begin
//  AScrollBox.Realign; // ensure child positions are final
  TargetX := ACtrl.Left + (ACtrl.Width div 2) - (AScrollBox.ClientWidth div 2);
  TargetY := ACtrl.Top  + (ACtrl.Height div 2) - (AScrollBox.ClientHeight div 2);

  MaxX := AScrollBox.HorzScrollBar.Range - AScrollBox.ClientWidth;
  MaxY := AScrollBox.VertScrollBar.Range - AScrollBox.ClientHeight;
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

{
procedure TFrameNavEv.ClearNavEvItems;
begin
  while scrBox.ControlCount > 0 do  // Clear existing frames.
    scrBox.Controls[0].Free;
end;
}

procedure TFrameNavEv.FillNavEvItems;
var
  Frame: TFrameNavEvItem;
  Q: TFDQuery;
begin
  // exception traps.
  if not Assigned(SCM2) or not SCM2.scmConnection.connected then exit;
  if not Assigned(CORE) or not CORE.IsActive then exit;

  // 1. Performance: Disable UI updates
  LockDrawing;
  scrBox.DisableAlign;
  Q := CORE.qryEvent; // improves readability.
  Q.DisableControls;
  try
    // 2. Clear existing frames
    while scrBox.ControlCount > 0 do
      scrBox.Controls[0].Free;

    if Q.IsEmpty then exit;   // nothing to display

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
    Q.EnableControls;
    scrBox.Realign; // ensures AutoScroll - scrollbar is displayed.
    scrBox.EnableAlign;
    UnlockDrawing;
  end;
end;

{
function TFrameNavEv.LocateNavEvItem(EventID: integer): Integer;
var
  I: integer;
begin
  result := 0;
  for I := 0 to scrBox.ControlCount - 1 do
  begin
    // assigned Item's Selected param and paint colors
    if (scrBox.Controls[I].Tag = EventID) then
    begin
      result := i;
      break;
    end;
  end;
end;
}

procedure TFrameNavEv.Msg_SCM_Frame_Reset(var Msg: TMessage);
begin
  FillNavEvItems();
end;

procedure TFrameNavEv.Msg_SCM_Frame_Selected(var Msg: TMessage);
begin
  if Msg.LParam <> 0 then
  begin
    // check - is the control visible within the scroll box
    if not IsControlFullyVisibleInScrollBox(scrBox, TFrameNavEvItem(Msg.LParam)) then
      CenterControlInScrollBox(scrBox, TFrameNavEvItem(Msg.LParam));
//        scrBox.ScrollInView(NavEvItem); // note: doesn't center control...

    // locateing DB to NavEvItem..EventID
    // This results in SCM_Scroll_Event message and
    // TFrameNavEv.Msg_SCM_Scroll_Event is called ...
    if Assigned(FOnNavEvItemSelected) then
      FOnNavEvItemSelected(TObject(Self), integer(Msg.WParam),
        TFrameNavEvItem(Msg.LParam));
  end;
end;

procedure TFrameNavEv.Msg_SCM_Scroll_Event(var Msg: TMessage);
begin
  if Msg.WParam <> 0 then
      UpdateSelect(Msg.WParam);
end;

procedure TFrameNavEv.SelectNone;
var
  I: integer;
begin
  for I := 0 to scrBox.ControlCount - 1 do
    TFrameNavEvItem(scrBox.Controls[I]).Select(false);
end;

procedure TFrameNavEv.UpdateSelect(EventID: integer);
var
  I: integer;
  NavEvItem: TFrameNavEvItem;
begin
  LockDrawing;
  try
    for I := 0 to scrBox.ControlCount - 1 do
    begin
      if (scrBox.Controls[I].Tag = EventID) then
      begin
        NavEvItem := TFrameNavEvItem(scrBox.Controls[I]);
        SelectNone();
        NavEvItem.Select(true);
        break;
      end
    end;
  finally
    UnlockDrawing;
  end;
end;


{ CUSTOM HORZSCROLLBAR - CODE READY - FOR THIN SCROLLBAR...}

procedure TFrameNavEv.CreateCustomHorz;
begin
  FCustomHorz := TScrollBar.Create(Self);
  FCustomHorz.Parent := Self;         // keep it on the frame (not inside scrBox)
  FCustomHorz.Kind := sbHorizontal;
  FCustomHorz.Align := alBottom;
  FCustomHorz.Height := Max(8, scrBox.HorzScrollBar.Size - 4); // desired thinner height
  FCustomHorz.Visible := False;
  FCustomHorz.OnChange := CustomHorzChange;
end;

procedure TFrameNavEv.UpdateCustomHorz;
begin
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

procedure TFrameNavEv.CustomHorzChange(Sender: TObject);
begin
  // user moved custom scrollbar => scroll the scrollbox
  scrBox.HorzScrollBar.Position := FCustomHorz.Position;
end;

procedure TFrameNavEv.spbtnNavLeftClick(Sender: TObject);
var
  metric: integer;
begin
  if scrBox.ControlCount = 0 then exit;
  metric := Round(scrBox.Controls[0].Width / 2);
  if scrBox.HorzScrollBar.Position - Metric  > 0 then
    scrBox.HorzScrollBar.Position := scrBox.HorzScrollBar.Position - Metric
  else scrBox.HorzScrollBar.Position := 0;
end;

procedure TFrameNavEv.spbtnNavRightClick(Sender: TObject);
var
  metric: integer;
begin
  if scrBox.ControlCount = 0 then exit;
  metric := Round(scrBox.Controls[0].Width / 2);
  if scrBox.HorzScrollBar.Position + Metric < scrBox.HorzScrollBar.Range then
    scrBox.HorzScrollBar.Position := scrBox.HorzScrollBar.Position + Metric
  else scrBox.HorzScrollBar.Position := scrBox.HorzScrollBar.Range;

end;

end.
