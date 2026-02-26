unit frFrameLane;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Actions,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.Grids, Vcl.ImgList, Vcl.ActnList, Vcl.Menus, Vcl.Buttons,
  Vcl.ActnMan,

  Data.DB,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmIMG, dmSCM2, dmCORE, uDefines, uSettings;

type
  TFrameLane = class(TFrame)
    actnlist: TActionList;
    actnLn_Delete: TAction;
    actnLn_DeleteForever: TAction;
    actnLn_MoveDown: TAction;
    actnLn_MoveUp: TAction;
    actnLn_Renumber: TAction;
    actnln_Report: TAction;
    actnLn_Swap: TAction;
    grid: TDBAdvGrid;
    pnlBody: TPanel;
    pnlG: TPanel;
    pumenuLane: TPopupMenu;
    rpnlCntrl: TRelativePanel;
    ShapeLnBar1: TShape;
    spbtnDelete: TSpeedButton;
    spbtnDeleteForever: TSpeedButton;
    spbtnMoveDown: TSpeedButton;
    spbtnMoveUp: TSpeedButton;
    spbtnReport: TSpeedButton;
    spbtnSwitch: TSpeedButton;
    actnLn_RefreshStat: TAction;
    spbtnRefreshStats: TSpeedButton;
    actnLn_SplitTime: TAction;
    spbtnSplitTime: TSpeedButton;
    procedure actnLn_GenericUpdate(Sender: TObject);
    procedure actnLn_RefreshStatExecute(Sender: TObject);
    procedure gridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
    procedure gridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure gridEllipsClick(Sender: TObject; ACol, ARow: Integer; var S: string);
    procedure gridFixedCellClick(Sender: TObject; ACol, ARow: LongInt);
    procedure gridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState:
        TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure gridGetEditMask(Sender: TObject; ACol, ARow: LongInt; var Value:
        string);
    procedure gridGetEditorType(Sender: TObject; ACol, ARow: Integer; var AEditor:
        TEditorType);
    procedure gridGetEditText(Sender: TObject; ACol, ARow: LongInt; var Value:
        string);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
  private
    DefGridColWidths: Array of integer;

  protected
    procedure Loaded; override;
  public
    procedure LinkActionsToMenu(AParentMenuItem: TActionClientItem);
    procedure OnEventTypeChange(AEventTypeID: Integer);
    procedure OnPreferenceChange();
    procedure UpdateUI(DoFullUpdate: boolean = false);
  end;

implementation

{$R *.dfm}

uses
  uSession, uEvent, uHeat, uLane, uNominee, uPickerStage, dlgLaneColumnPicker;

procedure TFrameLane.actnLn_GenericUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
  Assigned(CORE) and CORE.IsActive and
  not CORE.qryHeat.IsEmpty then
  begin
    if uSession.IsUnLocked and uHeat.IsOpened then
      DoEnable := true;
  end;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameLane.actnLn_RefreshStatExecute(Sender: TObject);
begin
  if not (Assigned(CORE) and CORE.IsActive) then exit;
  LockDrawing;
  grid.BeginUpdate;
  try
    uNominee.RefreshStat(CORE.qryLane.FieldByName('NomineeID').AsInteger);
    CORE.qryLane.Refresh; // refresh the lane's stats
  finally
    grid.EndUpdate;
    UnlockDrawing;
  end;


  {
  aMemberID := uLane.GetMemberID; // obtain the member's ID for the current lane.
  if aMemberID > 0 then
  begin
    LockDrawing;
    grid.BeginUpdate;
    try
      uNominee.RefreshStat(uEvent.PK(), aMemberID); // Calc-Reload tblNominate metrics
      CORE.qryLane.Refresh; // refresh the lane's stats
    finally
      grid.EndUpdate;
      UnlockDrawing;
    end;
  end;
  }

end;

procedure TFrameLane.gridCanEditCell(Sender: TObject; ARow, ACol: Integer; var
    CanEdit: Boolean);
var
  G: TDBAdvGrid;
  indx: integer;
begin
  G := TDBAdvGrid(Sender);
  CanEdit := false;
  indx := G.FieldIndexAtColumn[ACol];
  case uHeat.HeatStatusID of
    1: // OPEN. swimmer/team, racetime, s, q, dQ.
        if indx in [2, 3, 6, 7, 8] then CanEdit := true;
    2: // RACED. racetime, s, q, dQ.
        if indx in [3, 6, 7, 8] then CanEdit := true;
    3: // CLOSED.
        CanEdit := false;
  end;
end;

procedure TFrameLane.gridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect:
  TRect; State: TGridDrawState);
var
  G: TDBAdvGrid;
  item: TDBGridColumnItem;
begin
  G := TDBAdvGrid(Sender);
  if (ARow = 0) then // GRID's HEADER BAR.
  begin
    // This method deals with sorted columns and correctly draws ...
    item := G.Columns[ACol];
    if item.FieldName = 'LaneID' then  // Hamburger
      IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 6);
    if item.FieldName = 'GenderABREV' then  // male-female
      IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 3);
    if item.FieldName = 'EventTypeID' then  // Event Type IND-R
      IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 7);
  end;
end;

procedure TFrameLane.gridEllipsClick(Sender: TObject; ACol, ARow: Integer; var
    S: string);
var
  G: TDBAdvGrid;
  stage: TPickerStage;
  success: boolean;
begin
  success := false;
  G := TDBAdvGrid(Sender);
  G.BeginUpdate;
  if (ARow >= G.FixedRows) and (G.Columns[ACol].FieldName = 'FullName') then
  begin
    stage := TPickerStage.Create(Self);
    if ((GetKeyState(VK_CONTROL) and 128) = 128) then
      // List members pool for nomination and entrant assignment.
      success := stage.Stage(uEvent.GetEventType,  uLane.PK, true)
    else
      // List nominee pool for entrant assignment
      success := stage.Stage(uEvent.GetEventType,  uLane.PK, false);
    stage.free;
  end;
  G.EndUpdate;

  if Success then
  begin
    // Update date main for metrics? (post status message, etc... )
  end;
end;

procedure TFrameLane.gridFixedCellClick(Sender: TObject; ACol, ARow: LongInt);
var
  dlg: TLaneColumnPicker;
  I, indx: Integer;
  fld: TField;
  item: TDBGridColumnItem;
begin
  if (ARow = 0) and (ACol = 0) then
  begin
    // display dlg to select column visibility...
    dlg := TLaneColumnPicker.Create(Self);
    dlg.ShowModal();
    // iterate over results and adjust column visibility.
    for I := 0 to dlg.clbLane.Items.Count - 1 do
    begin
      fld := TField(dlg.clbLane.Items.Objects[I]);
      item := Grid.ColumnByFieldName[fld.FieldName];
      if Assigned(item) and Assigned(fld) then
      begin
        if fld.Visible and (item.Width = 0) then
        begin
          // lookup default column widths...
          indx := fld.index;
          if indx in [Low(DefGridColWidths)..High(DefGridColWidths)] then
          begin
            if DefGridColWidths[indx] <> -1 then
              item.Width := DefGridColWidths[indx];
          end;
        end
        else if (not fld.Visible) and (item.Width <> 0) then
          item.Width := 0;
      end;
    end;
    dlg.Free;
  end;
end;

procedure TFrameLane.gridGetCellColor(Sender: TObject; ARow, ACol: Integer;
  AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  if (ARow >= grid.FixedRows) then
  begin
    case uHeat.HeatStatusID of
      1:
        begin
          ; // Default assigned color.
        end;
      2: // RACED.
        begin
          AFont.Color := clWebGoldenRod;
        end;
      3: // CLOSED.
        begin
          AFont.Color := clWebDarkSalmon;
        end;
    end;
    if uSession.IsLocked then AFont.Color := grid.DisabledFontColor;
  end;
end;

procedure TFrameLane.gridGetEditMask(Sender: TObject; ACol, ARow: LongInt; var
    Value: string);
var
  G: TDBAdvGrid;
begin
  G := TDBAdvGrid(Sender);
  if (ARow >= G.FixedRows) and (G.Columns[ACol].FieldName = 'RaceTime') then
  begin
    Value := '!00:00.000;1;0';
  end;
end;

procedure TFrameLane.gridGetEditorType(Sender: TObject; ACol, ARow: Integer;
    var AEditor: TEditorType);
var
  G: TDBAdvGrid;
begin
  G := TDBAdvGrid(Sender);
  if (ARow >= G.FixedRows) and (G.Columns[ACol].FieldName = 'RaceTime') then
  begin
    AEditor := edNumeric;
  end;
  if (ARow >= G.FixedRows) and (G.Columns[ACol].FieldName = 'FullName') then
  begin
    AEditor := edEditBtn;
    Grid.BtnEdit.EditorEnabled := False; // disables typing
    Grid.BtnEdit.ButtonCaption := '..'; // optional
  end;
end;

procedure TFrameLane.gridGetEditText(Sender: TObject; ACol, ARow: LongInt; var
    Value: string);
var
  Hour, Min, Sec, MSec: word;
  G: TDBAdvGrid;
  dt: TDateTime;
begin
  G := TDBAdvGrid(Sender);
  if (ARow >= G.FixedRows) and (G.Columns[ACol].FieldName = 'RaceTime')then
  begin
    // This method FIXES display format issues.
    dt := G.DataSource.DataSet.FieldByName('RaceTime').AsDateTime;
    DecodeTime(dt, Hour, Min, Sec, MSec);
    Value := Format('%0:2.2u:%1:2.2u.%2:3.3u', [Min, Sec, MSec]);
  end;
end;

procedure TFrameLane.gridKeyPress(Sender: TObject; var Key: Char);
var
  G: TDBAdvGrid;
  indx: integer;
begin
  {TODO -oBSA -cGeneral :
    Clear lookup cells, whether in edit state of not, using the BACKSPACE key.
    make it optional to use CNTRL+BACKSPACE to clear cell}

//      if ((GetKeyState(VK_CONTROL) and 128) = 128) then
//      begin
//      end;

  G := TDBAdvGrid(Sender);
  indx := G.FieldIndexAtColumn[G.Col]; // fields index on tag at TFrameLane.Loaded..
  // FullName (Entrant.RelayTeam, Race-Time, luDQ).
  if (grid.row >= grid.FixedRows) and (indx in [2, 3, 8]) then
  begin
    if (Key = char(VK_BACK)) then
    begin
      grid.BeginUpdate;
      try
        begin
          try
            begin
              if (CORE.qryLane.State <> dsEdit) then
                CORE.qryLane.Edit;

              case (indx) of
                2:
                CORE.qryLane.FieldByName('FullName').Clear;
                3:
                CORE.qryLane.FieldByName('RaceTime').Clear;
                8:
                CORE.qryLane.FieldByName('DisqualifyCodeID').Clear;
              end;
              CORE.qryLane.Post;
              Key := char(0);
            end;
          except
            on E: Exception do ShowMessage(E.Message);
          end;
        end;
      finally
        grid.EndUpdate;
      end;
    end;
  end;
end;

procedure TFrameLane.LinkActionsToMenu(AParentMenuItem: TActionClientItem);
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

procedure TFrameLane.Loaded;
var
  item: TCollectionItem;
  fld: TField;
begin
  inherited;
  // Store a snap-shot of design-time field/column state.
  Grid.SetColumnOrder;

  // snapshot of design-time columnwidths used in TDBAdvGrid.
  SetLength(DefGridColWidths,CORE.qryLane.Fields.Count);
  for fld in CORE.qryLane.Fields do
  begin
    item := Grid.ColumnByFieldName[fld.FieldName];
    if Assigned(item) then
      DefGridColWidths[fld.Index] := TDBGridColumnItem(item).Width
    else DefGridColWidths[fld.Index] := -1;
  end;

  // ASSERT field visibility. Default SCMv1 schema.
  CORE.qryLane.FieldByName('LaneID').Visible := false;
  CORE.qryLane.FieldByName('ClubRecord').Visible := false;
  CORE.qryLane.FieldByName('HeatID').Visible := false;
  CORE.qryLane.FieldByName('TeamID').Visible := false;
  CORE.qryLane.FieldByName('NomineeID').Visible := false;
  CORE.qryLane.FieldByName('GenderABREV').Visible := false;
  CORE.qryLane.FieldByName('AGE').Visible := false;
  CORE.qryLane.FieldByName('EventTypeID').Visible := false;

  // Set ... Simplified or FINA disqualification codes.
  OnPreferenceChange;

  // ASSERT additional grid column visibility (via Column Width)
  Grid.ColumnByFieldName['ClubRecord'].Width := 0;
  Grid.ColumnByFieldName['GenderABREV'].Width := 0;
  Grid.ColumnByFieldName['AGE'].Width := 0;
  Grid.ColumnByFieldName['EventTypeID'].Width := 0;

  OnEventTypeChange(CORE.qryLane.FieldByName('EventTypeID').AsInteger);

end;

procedure TFrameLane.OnEventTypeChange(AEventTypeID: Integer);
var
  item: TDBGridColumnItem;
begin
  item := Grid.ColumnByFieldName['FullName'];
  if AEventTypeID = 2 then
    item.Header := 'Relay Team'
  else
    item.Header := 'Entrant';
end;

procedure TFrameLane.OnPreferenceChange;
begin
  LockDrawing;
  Grid.BeginUpdate;

  CORE.qryLane.FieldByName('luDQ').Visible := false;
  CORE.qryLane.FieldByName('IsScratched').Visible := true;
  CORE.qryLane.FieldByName('IsDisqualified').Visible := true;

  Grid.ColumnByFieldName['luDQ'].Width := 0;
  Grid.ColumnByFieldName['IsScratched'].Width := 39;
  Grid.ColumnByFieldName['IsDisqualified'].Width := 39;
  try
    if Assigned(Settings) and Settings.EnableDQcodes then
    begin
      CORE.qryLane.FieldByName('luDQ').Visible := true;
      CORE.qryLane.FieldByName('IsScratched').Visible := false;
      CORE.qryLane.FieldByName('IsDisqualified').Visible := false;

      Grid.ColumnByFieldName['luDQ'].Width := 54;
      Grid.ColumnByFieldName['IsScratched'].Width := 0;
      Grid.ColumnByFieldName['IsDisqualified'].Width := 0;
    end;

  finally
    Grid.EndUpdate;
    UnlockDrawing;
  end;
end;

procedure TFrameLane.UpdateUI(DoFullUpdate: boolean = false);
begin

  {CASES: after Connection, after change of swimming club, after manage-clubs. }
  if DoFullUpdate then
  begin
    if (not Assigned(SCM2)) or (not SCM2.scmConnection.connected) or
        (not Assigned(CORE)) or (not CORE.IsActive) or (CORE.qrySession.IsEmpty)
        or (CORE.qryEvent.IsEmpty) or (CORE.qryHeat.IsEmpty) then
    begin
      Self.Visible := false;
      exit;
    end;
        { NOTE: grid must be visible to sync + forces re-paint. }
      LockDrawing;
      Self.Visible := true;
      pnlBody.Visible := true;
      pnlG.Visible := true;
      grid.Enabled := true;
//      grid.Refresh;
      UnlockDrawing;
  end;


  LockDrawing;
  try

    if CORE.qryHeat.IsEmpty then
    begin
      Self.Visible := false;
      exit;
    end;

    if not Self.Visible then Self.Visible := true;

    if CORE.qryLane.IsEmpty then
    begin
      Self.Visible := false;
      exit;
    end
    else
    begin
      pnlBody.Visible := true;
      pnlG.Visible := true;
    end;

  finally
    UnlockDrawing;
  end;
end;

end.
