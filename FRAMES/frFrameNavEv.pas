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

  TFrameNavEv = class(TFrame)
    rpnlBody: TRelativePanel;
    scrBox: TScrollBox;
    spbtnNavLeft: TSpeedButton;
    spbtnNavRight: TSpeedButton;
    procedure scrBoxResize(Sender: TObject);
    procedure spbtnNavLeftClick(Sender: TObject);
    procedure spbtnNavRightClick(Sender: TObject);
  private

    function SelectNavEvItem(NavEvItem: TFrameNavEvItem): Integer; overload;
//    procedure SelectNoneNavEvItems;
    procedure FillNavEvItems;
    procedure CenterNavEvItem(IndexOfControl: integer);
  protected
    // user selects a navigation event item.
    procedure NavEvItemClicked(Sender: TObject; EventID: Integer);
  public
    procedure UpdateUI(DoFullUpdate: boolean = false);
    function SelectNavEvItem(EventID: integer): Integer; overload;
  end;

var
  ScrollLockEvItem: boolean = true;


implementation

{$R *.dfm}

uses
  uSession, uEvent;


{ TFrameNavEvent }

procedure TFrameNavEv.CenterNavEvItem(IndexOfControl: integer);
var
  metric: Integer;
  pos: Integer;
  cntrl: TControl;
begin

  if (IndexOfControl < 0) or (IndexOfControl >= scrBox.ControlCount) then exit;
  try
    cntrl := scrBox.Controls[IndexOfControl]; // precautionary trap.
  except on E: Exception do
    exit;
  end;

  // rudementary adjustment to scroll position...
  // doesn't center control. does nothing if already in view.
  scrBox.ScrollInView(cntrl);
//  pos := scrBox.HorzScrollBar.Position;

  // ASSERT : DELPHI VCL BUG ... reverts to inherited.
  scrBox.HorzScrollBar.Increment :=
    TFrameNavEvItem.Designwidth + TFrameNavEvItem.DesignSpacing;

  if (IndexOfControl >= 0) then
  begin
    // This works because only 1 control type, all of equal width.
    pos := (scrBox.HorzScrollBar.Increment * (IndexOfControl+1));
    // compute : half the width of scrBox's 'display view', less margin of error.
    // can't use TScrollBox.ClientWidth... doesn't work here!
    metric := ( (rpnlBody.ClientWidth
      - (spbtnNavLeft.Width + spbtnNavRight.Width) ) div 2);

    if (pos > metric) and
      (pos < (scrBox.HorzScrollBar.Range - metric)) then
        // GO center TFrameNavEvItem in scrBox display view.
        scrBox.HorzScrollBar.Position := pos - metric
    else if (pos >= (scrBox.HorzScrollBar.Range - metric)) then
      scrBox.HorzScrollBar.Position := scrBox.HorzScrollBar.Range;
  end;

end;

procedure TFrameNavEv.FillNavEvItems;
var
  Frame: TFrameNavEvItem;
  Q: TFDQuery;
  PK: integer;
  found: boolean;
begin
  // exception traps.

  if (not Assigned(SCM2)) or (not SCM2.scmConnection.connected) or
      (not Assigned(CORE)) or (not CORE.IsActive) then
    exit;

  PK := 0;
  found := false;
  // 1. Performance: Disable UI updates
  scrBox.LockDrawing;
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
      // Hook for user selecting a NavEvItem.
      frame.FOnNavEvItemSelected := NavEvItemClicked;

      // 4. Horizontal Alignment
      Frame.Align := alLeft;
      Frame.Margins.Right := TFrameNavEvItem.DesignSpacing; // Space between items
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
    scrBox.UnlockDrawing;

    // DELPHI BUG : reverts to inherited.
    scrBox.HorzScrollBar.Increment :=
      TFrameNavEvItem.DesignWidth + TFrameNavEvItem.DesignSpacing;
  end;
end;

procedure TFrameNavEv.NavEvItemClicked(Sender: TObject; EventID: Integer);
var
  ANavEvItem: TFrameNavEvItem;
begin
  // origin is TFrameNavEvItem...
  ANavEvItem := TFrameNavEvItem(Sender);
  SelectNavEvItem(ANavEvItem); // also unselects (toggles)..

  // assert DB state?
  if not Assigned(CORE) or not CORE.IsActive then exit;
  if (CORE.qryEvent.State in [dsOpening]) then exit;
  if (uEvent.PK() <> EventID) then
    uEvent.Locate(EventID); // Triggers a qryEvent.OnScroll event.

end;

procedure TFrameNavEv.scrBoxResize(Sender: TObject);
begin
  // DELPHI VCL BUG ... reverts to inherited.
  scrBox.HorzScrollBar.Increment :=
    TFrameNavEvItem.Designwidth + TFrameNavEvItem.DesignSpacing;

end;

function TFrameNavEv.SelectNavEvItem(EventID: integer): Integer;
var
  I, indx: integer;
  Current: TFrameNavEvItem;
begin
  result := -1;
  indx := -1;
  scrBox.LockDrawing;
  scrBox.DisableAlign;
  try
  begin
    for I := 0 to scrBox.ControlCount - 1 do
    begin
      Current := TFrameNavEvItem(scrBox.Controls[I]);
      // return the index of the control.
      if (Current.Tag = EventID) then indx := I;
      // Only update if state is changing to minimize visual updates
      if (Current.Tag = EventID) and not Current.Selected then
        Current.Selected := true
      else if (Current.Tag <> EventID) and Current.Selected then
        Current.Selected := false;
    end;
  end;
  finally
    scrBox.EnableAlign;
    scrBox.Realign; // Calcs range - ensures scrollbar is displayed.
    scrBox.UnlockDrawing;
  end;

  if (indx >= 0) then
  begin
    result := indx;
    CenterNavEvItem(indx);
  end;

  if scrBox.CanFocus() then
    scrBox.SetFocus;

end;

function TFrameNavEv.SelectNavEvItem(NavEvItem: TFrameNavEvItem): Integer;
var
  I, indx: integer;
  Current: TFrameNavEvItem;
begin
  result := -1;
  indx := -1;
  scrBox.LockDrawing;
  scrBox.DisableAlign;
  try
  begin
    for I := 0 to scrBox.ControlCount - 1 do
    begin
      Current := TFrameNavEvItem(scrBox.Controls[I]);

      // return the index of the control.
      if (Current = NavEvItem) then indx := I;

      // Only update if state is changing to minimize visual updates
      if (Current = NavEvItem) and not Current.Selected then
        Current.Selected := true
      else if (Current <> NavEvItem) and Current.Selected then
        Current.Selected := false;
    end;
  end
  finally
    scrBox.EnableAlign;
    scrBox.Realign; // Calcs range - ensures scrollbar is displayed.
    scrBox.UnlockDrawing;
  end;

  if (indx >= 0) then
  begin
    result := indx;
    CenterNavEvItem(indx);
  end;

  if scrBox.CanFocus() then
    scrBox.SetFocus;

end;

{
procedure TFrameNavEv.SelectNoneNavEvItems;
var
  I: integer;
  NavEvItem: TFrameNavEvItem;
begin
  for I := 0 to scrBox.ControlCount - 1 do
  begin
    NavEvItem := TFrameNavEvItem(scrBox.Controls[I]);
    NavEvItem.Selected := false;
  end;
end;
}


procedure TFrameNavEv.spbtnNavLeftClick(Sender: TObject);
var
  metric: integer;
begin
  if scrBox.ControlCount = 0 then exit;
  if ((GetKeyState(VK_CONTROL) and 128) = 128) then
  begin
    // DELPHI VCL BUG ... reverts to inherited.
    scrBox.HorzScrollBar.Increment := TFrameNavEvItem.DesignWidth +
      TFrameNavEvItem.DesignSpacing;

    metric := scrBox.HorzScrollBar.Increment;

    if scrBox.HorzScrollBar.Position - Metric > 0 then
      scrBox.HorzScrollBar.Position := scrBox.HorzScrollBar.Position - Metric
    else
      scrBox.HorzScrollBar.Position := 0;
  end
  else
  begin
    CORE.qryEvent.Prior;
    SelectNavEvItem(uEvent.PK);
  end;
end;

procedure TFrameNavEv.spbtnNavRightClick(Sender: TObject);
var
  metric: integer;
begin
  if scrBox.ControlCount = 0 then exit;
  if ((GetKeyState(VK_CONTROL) and 128) = 128) then
  begin
    // DELPHI VCL BUG ... reverts to inherited.
    scrBox.HorzScrollBar.Increment :=
      TFrameNavEvItem.DesignWidth + TFrameNavEvItem.DesignSpacing;
    metric := scrBox.HorzScrollBar.Increment;

    if scrBox.HorzScrollBar.Position + Metric < scrBox.HorzScrollBar.Range then
      scrBox.HorzScrollBar.Position := scrBox.HorzScrollBar.Position + Metric
    else
      scrBox.HorzScrollBar.Position := scrBox.HorzScrollBar.Range;
  end
  else
  begin
    CORE.qryEvent.Next; // triggers scroll event
    SelectNavEvItem(uEvent.PK);
  end;
end;

procedure TFrameNavEv.UpdateUI(DoFullUpdate: boolean = false);
begin

  if DoFullUpdate then
  begin
    { NOTE: never make TMG TDBAdvGrid Invisible. It won't draw correctly.}
    if (not Assigned(SCM2)) or (not SCM2.scmConnection.connected) or
        (not Assigned(CORE)) or (not CORE.IsActive) or (CORE.qrySession.IsEmpty) then
    begin
      Self.Visible := false; // hide everthing - move on.
      exit;
    end;
  end;

  LockDrawing;

  try

    if CORE.qrySession.IsEmpty then
    begin
      Self.Visible := false; // hide everthing - move on.
      exit;
    end;

    if not Self.Visible then Self.Visible := true;

    if CORE.qryEvent.IsEmpty() then
    begin
      // CNTRL panel is displayed but not the grid.
      rpnlBody.Visible := true;
      scrBox.Visible := false;
      spbtnNavLeft.Enabled := false;
      spbtnNavRight.Enabled := false;
    end
    else
    begin
      rpnlBody.Visible := true;
      scrBox.Visible := true;
      spbtnNavLeft.Enabled := true;
      spbtnNavRight.Enabled := true;
      FillNavEvItems;
    end;

  finally
    UnlockDrawing;
  end;


end;

end.
