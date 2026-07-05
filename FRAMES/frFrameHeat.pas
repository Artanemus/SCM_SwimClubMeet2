unit frFrameHeat;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.UITypes,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.Grids, Vcl.ImgList,
  Vcl.ActnMan,

  Data.DB,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmIMG, dmSCM2, dmCORE, System.Actions, Vcl.ActnList, Vcl.Menus, Vcl.Buttons,

  uSession, uEvent, uHeat, uDefines, Vcl.StdCtrls, uSettings;

type
{
  // 1. THE INTERCEPTER MUST GO HERE (Before the TFrame declaration)
  TSpeedButton = class(Vcl.Buttons.TSpeedButton)
  protected
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
  end;
}

  TFrameHeat = class(TFrame)
    actnHt_AllMarshallSheets: TAction;
    actnHt_AllTimeKeeperSheets: TAction;
    actnHt_AutoBuild: TAction;
    actnHt_AutoBuildAll: TAction;
    actnHt_Delete: TAction;
    actnHt_MarshallSheet: TAction;
    actnHt_MoveDown: TAction;
    actnHt_MoveUp: TAction;
    actnHt_New: TAction;
    actnHt_Renumber: TAction;
    actnHt_Report: TAction;
    actnHt_SheetSet: TAction;
    actnHt_TimeKeeperSheets: TAction;
    actnHt_ToggleStatus: TAction;
    actnlist: TActionList;
    ALLTimeKeeperSets1: TMenuItem;
    AutoBuild1: TMenuItem;
    Delete1: TMenuItem;
    grid: TDBAdvGrid;
    HeatReport1: TMenuItem;
    lblMsgEmpty: TLabel;
    MarshallSheet1: TMenuItem;
    MoveDown1: TMenuItem;
    MoveUp1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    New1: TMenuItem;
    oggleStatus1: TMenuItem;
    pnlBody: TPanel;
    pnlG: TPanel;
    pumenuHeat: TPopupMenu;
    rpnlCntrl: TRelativePanel;
    ShapeHtBar1: TShape;
    ShapeHtBar2: TShape;
    ShapeHtBar3: TShape;
    SheetSet1: TMenuItem;
    spbtnAllLogs: TSpeedButton;
    spbtnAutoBuild: TSpeedButton;
    spbtnDelete: TSpeedButton;
    spbtnMarshall: TSpeedButton;
    spbtnMoveDown: TSpeedButton;
    spbtnMoveUp: TSpeedButton;
    spbtnNew: TSpeedButton;
    spbtnReport: TSpeedButton;
    spbtnTimeKeeper: TSpeedButton;
    spbtnToggleStatus: TSpeedButton;
    actnHT_RefreshStats: TAction;
    RefreshStats1: TMenuItem;
    pnlDebug: TPanel;
    procedure actnHt_AutoBuildExecute(Sender: TObject);
    procedure actnHt_AutoBuildUpdate(Sender: TObject);
    procedure actnHt_DeleteExecute(Sender: TObject);
    procedure actnHt_GenericUpdate(Sender: TObject);
    procedure actnHt_NewExecute(Sender: TObject);
    procedure actnHT_RefreshStatsExecute(Sender: TObject);
    procedure actnHt_ToggleStatusExecute(Sender: TObject);
    procedure gridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
    procedure gridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure gridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState:
        TGridDrawState; ABrush: TBrush; AFont: TFont);

  private
    fVerbose: boolean;
  protected
    procedure Loaded; override;


  public
    procedure LinkActionsToMenu(AParentMenuItem: TActionClientItem);
    procedure UpdateUI(DoFullUpdate: boolean = false);

    procedure OnPreferenceChange(); // Tools preferences calls here, via main form.
    procedure OnAfterScroll(); // handles debug panel.
  end;

implementation

{$R *.dfm}

uses uNominee, uABINDV, dlgABSettings;

procedure TFrameHeat.actnHt_AutoBuildExecute(Sender: TObject);
var
  AB: TABINDV;
  success: boolean;
  rtn: TModalResult;
  dlg: TABSettings;
begin
  AB := nil;
  success := false;
  grid.HideInplaceEdit;
  CORE.qryHeat.CheckBrowseMode;

  // open up the auto-build preference dialogue.
  dlg := TABSettings.Create(Self);
  rtn := dlg.ShowModal();
  dlg.Free;

  if rtn = mrYes then
  begin
    LockDrawing;
    grid.BeginUpdate;
    uEvent.DetailTBLs_DisableCNTRLs;
    try
      AB := TABINDV.Create(Self);
      AB.Prepare(SCM2.scmConnection, uEvent.PK, fVerbose);
      success := AB.AutoBuildExec;
    finally
      if Assigned(AB) then AB.free;
      uEvent.DetailTBLs_ApplyMaster;
      uEvent.DetailTBLs_EnableCNTRLs;
      CORE.qryHeat.Refresh;
      grid.EndUpdate;
      UnlockDrawing;
      if fVerbose then
      begin
        if success then
          MessageDlg('Auto-Build done.', TMsgDlgType.mtInformation, [mbOK], 0, mbOK);
      end;
    end;
  end;
end;

procedure TFrameHeat.actnHt_AutoBuildUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then
  begin
    if not uSession.IsLocked then
      DoEnable := true;
  end;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameHeat.actnHt_DeleteExecute(Sender: TObject);
begin
  // delete current selected heat (including lanes);
  uHeat.DeleteHeat();
end;

procedure TFrameHeat.actnHt_GenericUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryHeat.IsEmpty then
  begin
    if not uSession.IsLocked then
      DoEnable := true;
  end;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameHeat.actnHt_NewExecute(Sender: TObject);
begin
  // create a new heat (including lanes);
  uHeat.NewHeat;
end;

procedure TFrameHeat.actnHT_RefreshStatsExecute(Sender: TObject);
begin
  if not (Assigned(CORE) and CORE.IsActive) then exit;
  LockDrawing;
  grid.beginUpdate;
  CORE.qryLane.DisableControls;
  try
      CORE.qryLane.First;
      while not CORE.qryLane.Eof do
      begin
        uNominee.RefreshStat(CORE.qryLane.FieldByName('NomineeID').AsInteger);
        CORE.qryLane.next;
      end;
      CORE.qryLane.Refresh; // refresh the lane's stats
      CORE.qryLane.First;
  finally
    CORE.qryLane.EnableControls;
    grid.EndUpdate;
    UnLockDrawing;
  end;
end;

procedure TFrameHeat.actnHt_ToggleStatusExecute(Sender: TObject);
begin
  uHeat.ToggleStatus;
end;

procedure TFrameHeat.gridCanEditCell(Sender: TObject; ARow, ACol: Integer; var
    CanEdit: Boolean);
begin
  // no editing done here...
  CanEdit := false;
end;

procedure TFrameHeat.gridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect:
    TRect; State: TGridDrawState);
var
  G: TDBAdvGrid;
  htNum, W, H, txtW, txtH, tx, ty: integer;
  htStr: string;
begin
  G := TDBAdvGrid(Sender);

  if not CORE.IsActive then exit;
  if CORE.qryHeat.IsEmpty then exit;


  if (ARow > G.HeaderRow) and (ACol = 2) then
  begin
      // get the raw stored cell value,
      // irrespective of display transformations.
      htNum := G.AllInts[1, ARow];
      htStr := IntToStr(htNum);
      if htStr.IsEmpty then htStr := '?';
      W := Rect.Width;
      H := Rect.Height;
      // calculate and scale font to fit inside icon
      G.Canvas.Font.Style := [fsBold];
      G.Canvas.Font.Size := 24;
      while (G.Canvas.TextWidth(htStr) > (W - 4))
          and (G.Canvas.Font.Size > 6) do
        G.Canvas.Font.Size := G.Canvas.Font.Size - 1;
      txtW := G.Canvas.TextWidth(htStr);
      txtH := G.Canvas.TextHeight(htStr);
      tx := Rect.Left + 1 + ((W - txtW) div 2);
      ty := Rect.Top + 1 + ((H - txtH) div 2);
      // draw text directly on canvas
      G.Canvas.Font.Color := clWebSeashell;
      G.Canvas.Brush.Style := bsClear;
      G.Canvas.TextOut(tx, ty, htStr);
  end;

end;

procedure TFrameHeat.gridGetCellColor(Sender: TObject; ARow, ACol: Integer;
    AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  ABrush.Color := $00494131;

end;

procedure TFrameHeat.LinkActionsToMenu(AParentMenuItem: TActionClientItem);
var
  i: integer;
  NewItem: TActionClientItem;
  AAction: TAction;
begin
  if not Assigned(AParentMenuItem) then exit;
  for i := 0 to actnlist.ActionCount - 1 do
  begin
    AAction := TAction(actnlist.Actions[i]);
    if Assigned(AAction) then
    begin
      NewItem := AParentMenuItem.Items.Add;
      if Assigned(NewItem) then
      begin
        NewItem.Action := AAction;
      end;
    end;
  end;
end;

procedure TFrameHeat.Loaded;
begin
  inherited;
  pnlDebug.Visible := false; // DEBUG PANEL
  fVerbose := true; // default...
  if Assigned(Settings) then
    fVerbose := Settings.Verbose;

end;

procedure TFrameHeat.OnAfterScroll;
var
  s: string;
begin

  if pnlDebug.Visible then
  begin
    s := 'HeatID:' + IntToStr(CORE.qryHeat.FieldByName('HeatID').AsInteger);
    pnlDebug.Caption := s;
  end;
end;

procedure TFrameHeat.OnPreferenceChange;
begin
  // Debug mode state...
  pnlDebug.Visible := false; // default
  if Assigned(Settings) then
  begin
    if Settings.ShowDebugInfo then
      pnlDebug.Visible := true;
  end;
end;

procedure TFrameHeat.UpdateUI(DoFullUpdate: boolean = false);
var
  DoRefresh: boolean;
begin
  DoRefresh := false;
  if DoFullUpdate then
  begin
    // CHECK TMS rule..
    if grid.RowCount < grid.FixedRows  then
      grid.RowCount := grid.FixedRows + 1;

    { NOTE: never make TMG TDBAdvGrid Invisible. It won't draw correctly.}

    if (not Assigned(SCM2)) or (not SCM2.scmConnection.connected) or
        (not Assigned(CORE)) or (not CORE.IsActive) or (CORE.qrySession.IsEmpty)
        or (CORE.qryEvent.IsEmpty) then
    begin
      Self.Visible := false; // hide everthing - move on.
      exit;
    end;

  end;

  if CORE.qryEvent.IsEmpty then
  begin
    // if located within Lock/UnLock-Drawing - doesn't get repainted.
    Self.Visible := false;
    exit;
  end;

  LockDrawing;

  try
    if not Self.Visible then
    begin
      Self.Visible := true; // we have heat(s) - enforce show lanes.
      DoRefresh := true; // enforce a re-sync?
      Self.Invalidate;  // enforce a repaint?
    end;

    pnlBody.Visible := true; // CNTRL panel is made visible.

    if CORE.qryHeat.IsEmpty then
    begin
      pnlG.Visible := false;
      pnlDebug.Visible := false;
    end
    else
    begin
      if DoRefresh then CORE.qryHeat.Refresh;
      pnlG.Visible := true;

      // conditionals.. locks out user from browseing and reports
      {
      if (uSession.IsLocked()) then
      begin
        if grid.Enabled then
          grid.Enabled := false; // mitigate grid repaints.
      end
      else
      begin
        if not grid.enabled then
          grid.Enabled := true; // mitigate grid repaints.
      end;
      }

      // conditionals..
      if Assigned(Settings) and Settings.ShowDebugInfo then
        pnlDebug.Visible := true else pnlDebug.Visible := false;
    end;

  finally
    UnlockDrawing;
  end;


end;

end.
