unit frFrameLane;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Actions,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.Grids, Vcl.ImgList, Vcl.ActnList, Vcl.Menus, Vcl.Buttons,
  Vcl.ActnMan, Vcl.StdCtrls,

  Data.DB,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmIMG, dmSCM2, dmCORE, uDefines, uSettings;

type

  TFrameNotifyLane_GridViewChange = procedure(Sender: TObject; GridState:
      Boolean) of object;

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
    spbtnGridView: TSpeedButton;
    spbtnHeatPicker: TSpeedButton;
    ShapeLnBar2: TShape;
    actnLn_GridView: TAction;
    actnLn_HeatPicker: TAction;
    pnlDebug: TPanel;
    lblStateString: TLabel;
    btnUpdateLableStateString: TButton;
    procedure actnLn_GenericUpdate(Sender: TObject);
    procedure actnLn_RefreshStatExecute(Sender: TObject);
    procedure gridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
    procedure gridClickCell(Sender: TObject; ARow, ACol: Integer);
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
    procedure actnLn_GridViewExecute(Sender: TObject);
    procedure btnUpdateLableStateStringClick(Sender: TObject);
  private

    // CALL-BACK NOTIFICATION...
    FOnGridViewChange: TFrameNotifyLane_GridViewChange;

    { Design Time Grid UI state. Captured on load.
      Captures column widths for all fields.}
    fStateStringSystem: String;
    { Grid-View Collapsed StringState. }
    fStateStringCollapsed: String;
    { Grid-View Expanded StringState.
      User may include/excude columns when in expanded grid view. }
    fStateStringExpanded: String;

    procedure SetGridViewIconState;
    procedure SetCollapsedGridState;
    procedure SetCollapsedUIState;
    procedure SetGridViewDQState;
    procedure SetExpandedUIState;

  protected
    procedure Loaded; override;

  public
    destructor Destroy; override; // Must be "override"

    procedure LinkActionsToMenu(AParentMenuItem: TActionClientItem);
    // Makes UI/Grid changes for TEAM/INDIVUAL events.
    procedure OnEventTypeChange(AEventTypeID: Integer);
    // Tools preferences calls here, via main form.
    procedure OnPreferenceChange();
    // after Connection, after change of swimming club, after manage-clubs.
    procedure UpdateUI(DoFullUpdate: boolean = false);

    // CALL-BACK...
    // Notify main form of a grid view change (expand/collapse)...
    property OnGridViewChanged: TFrameNotifyLane_GridViewChange
      read FOnGridViewChange write FOnGridViewChange;

  end;

implementation

{$R *.dfm}

uses
  uSwimClub, uSession, uEvent, uHeat, uLane, uNominee,
  uPickerStage, dlgLaneColumnPicker, ASGEdit, uStateString;

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

procedure TFrameLane.actnLn_GridViewExecute(Sender: TObject);
var
  LaneAction: TAction;
begin
  LaneAction := TAction(Sender);
  grid.BeginUpdate;
  CORE.qryLane.DisableControls;
  LaneAction.Checked := not LaneAction.Checked; // TOGGLE
  try
    if LaneAction.Checked then // GRID-VIEW EXPANDED..
    begin
      // store the collapsed state prior to expanding.
      fStateStringCollapsed := Grid.ColumnStatesToString;
      Grid.ReSetColumnOrder; // best practice prior to assigning StatesString.
      Grid.StringToColumnStates(fStateStringExpanded);
      SetExpandedUIState;
    end
    else // GRID-VIEW COLLAPSED..
    begin
      // store the expanded state prior to collapsing.
      fStateStringExpanded := Grid.ColumnStatesToString;
      Grid.ReSetColumnOrder; // best practice prior to assigning StatesString.
      Grid.StringToColumnStates(fStateStringCollapsed);
      SetCollapsedUIState;
    end;
  finally
    begin
      CORE.qryLane.EnableControls;
      grid.EndUpdate;
    end;
  end;
  // Call-back to main form.
  if Assigned(FOnGridViewChange) then
    FOnGridViewChange(self, LaneAction.Checked);
end;

procedure TFrameLane.actnLn_RefreshStatExecute(Sender: TObject);
begin
  if not (Assigned(CORE) and CORE.IsActive) then exit;
  LockDrawing;
  grid.BeginUpdate;
  CORE.qryLane.DisableControls;
  try
    uNominee.RefreshStat(CORE.qryLane.FieldByName('NomineeID').AsInteger);
    CORE.qryLane.Refresh; // refresh the lane's stats
  finally
    CORE.qryLane.DisableControls;
    grid.EndUpdate;
    UnlockDrawing;
  end;
end;

destructor TFrameLane.Destroy;
begin
  ;
  inherited;
end;

procedure TFrameLane.btnUpdateLableStateStringClick(Sender: TObject);
begin
  lblStateString.Caption := Grid.ColumnStatesToString;
end;

procedure TFrameLane.gridCanEditCell(Sender: TObject; ARow, ACol: Integer; var
    CanEdit: Boolean);
var
  G: TDBAdvGrid;
  fld: TField;
begin
  G := TDBAdvGrid(Sender);
  CanEdit := false;
  fld := G.FieldAtColumn[Acol];
  if Assigned(fld) then
  begin
    case uHeat.HeatStatusID of
      1: // OPEN. swimmer/team, racetime, s, q, dQ.
      begin
          // if indx in [2, 3, 6, 7, 8] then CanEdit := true;
        if fld.FieldName = 'FullName' then CanEdit := true
        else if fld.FieldName = 'RaceTime' then CanEdit := true
        else if fld.FieldName = 'IsScratched' then CanEdit := true
        else if fld.FieldName = 'IsDisQualified' then CanEdit := true
        else if fld.FieldName = 'luDQ' then CanEdit := true;
      end;
      2: // RACED. racetime, s, q, dQ.
      begin
         // if indx in [3, 6, 7, 8] then CanEdit := true;
        if fld.FieldName = 'RaceTime' then CanEdit := true
        else if fld.FieldName = 'IsScratched' then CanEdit := true
        else if fld.FieldName = 'IsDisQualified' then CanEdit := true
        else if fld.FieldName = 'luDQ' then CanEdit := true;
      end;
      3: // CLOSED.
          CanEdit := false;
    end;
  end;
end;

procedure TFrameLane.gridClickCell(Sender: TObject; ARow, ACol: Integer);
var
  item: TDBGridColumnItem;
begin
  // this param keeps getting scrubbed.
  item := Grid.Columns[ACol];
  if item.FieldName = 'luDQ' then item.AllowBlank := true;
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

    // Hamburger
    if (item.FieldName = 'LaneID') and actnLn_GridView.Checked then
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
  fld: TField;
begin
  success := false;
  G := TDBAdvGrid(Sender);
  fld := G.FieldAtColumn[ACol];
  if Assigned(fld) then
  begin
    G.BeginUpdate;
    if (ARow >= G.FixedRows) then
    begin
      if fld.FieldName = 'FullName' then
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
      if fld.FieldName = 'RecordTime' then
      begin
        // display a balloon hint with details on record
        // who swum the time, the date, age, gender, etc
        ;
      end;
    end;
    G.EndUpdate;
  end;

  if Success then
  begin
    // Update date main for metrics? (post status message, etc... )
  end;
end;


procedure TFrameLane.gridFixedCellClick(Sender: TObject; ACol, ARow: LongInt);
var
  dlg: TLaneColumnPicker;
  mr: TModalResult;
begin
  // Must be in EXPANDED column mode to alter grid columns, withs, index, etc.
  if (ARow = 0) and (ACol = 0) and actnLn_GridView.Checked then
  begin
    LockDrawing;
    Grid.BeginUpdate;
    try
      // display dlg to select column visibility...
      dlg := TLaneColumnPicker.Create(Self);
      // Current string state, system state for default widths and grid ref.
      dlg.Prepare(Grid);
      // RULE. must call prepare before showing dialogue.
      mr := dlg.ShowModal();
      if (mr = mrOK) then
      begin
          Grid.ReSetColumnOrder;
          // Move the new string state into expanded grid view.
          fStateStringExpanded := dlg.StateString;
          // apply UI changes to the grid.
          Grid.StringToColumnStates(fStateStringExpanded);
      end;
      dlg.Free;
    finally
      Grid.EndUpdate;
      UnLockDrawing;
    end;
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
  fld: TField;
begin
  G := TDBAdvGrid(Sender);
  fld := G.FieldAtColumn[ACol];
  if Assigned(fld) then
  begin
    if (ARow >= G.FixedRows) and (fld.FieldName = 'RaceTime') then
    begin
      Value := '!00:00.000;1;0';
    end;
  end;
end;

procedure TFrameLane.gridGetEditorType(Sender: TObject; ACol, ARow: Integer;
  var AEditor: TEditorType);
var
  G: TDBAdvGrid;
  fld: TField;
begin
  G := TDBAdvGrid(Sender);
  fld := G.FieldAtColumn[ACol];
  if Assigned(fld) then
  begin
    if (ARow >= G.FixedRows) then
    begin
      if fld.FieldName = 'RaceTime' then AEditor := edNumeric
      else if fld.FieldName = 'FullName' then
      begin
        AEditor := edEditBtn;
        Grid.BtnEdit.EditorEnabled := False; // disables typing
        Grid.BtnEdit.ButtonAlign := TButtonAlign(btnRight);

        {DOES NOTHING ... USE grid.Column[..] button params }
//        Grid.BtnEdit.ButtonCaption := '...'; // optional
//        Grid.BtnEdit.ButtonWidth := 32;
//        Grid.BtnEdit.Button.ButtonCaption := '...'
      end
      else if fld.FieldName = 'RecordTime' then
      begin
        AEditor := edEditBtn;
        Grid.BtnEdit.EditorEnabled := False; // disables typing
        Grid.BtnEdit.ButtonAlign := TButtonAlign(btnLeft);
//        Grid.BtnEdit.ButtonCaption := '.'; // optional
//        Grid.BtnEdit.ButtonWidth := 12;
//        Grid.BtnEdit.Button.ButtonCaption := '.'
      end;
    end;
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

procedure TFrameLane.SetCollapsedGridState;
var
fld: Tfield;
begin
  // Set ALL fields too visible...
  for fld in CORE.qryLane.Fields do fld.Visible := true;

  { COLLAPSE SCHEMA (same as SCMv1.)
    LaneID, LaneNum, FullName, Gender, Age, RaceTime, TTB, PB, (S,D) or (DQ). }
  CORE.qryLane.FieldByName('LaneID').Visible := false;
  CORE.qryLane.FieldByName('RecordTime').Visible := false;
  CORE.qryLane.FieldByName('HeatID').Visible := false;
  CORE.qryLane.FieldByName('TeamID').Visible := false;
  CORE.qryLane.FieldByName('NomineeID').Visible := false;
  CORE.qryLane.FieldByName('EventTypeID').Visible := false;
  // hide DB extended features.
  CORE.qryLane.FieldByName('RecordTime').Visible := false;
  CORE.qryLane.FieldByName('luHouse').Visible := false;
  CORE.qryLane.FieldByName('EvScore').Visible := false;
  CORE.qryLane.FieldByName('EvPlace').Visible := false;
  CORE.qryLane.FieldByName('HtScore').Visible := false;
  CORE.qryLane.FieldByName('HtPlace').Visible := false;
  CORE.qryLane.FieldByName('SplitCount').Visible := false;

  { Set: COLLAPSED Simplified (Scratched, Disqualified)
      or FINA (DQ) disqualification codes. }
  OnPreferenceChange;

  { Set: grid visiblity for COLLAPSED (extended features) grid columns .}
  Grid.ColumnByFieldName['RecordTime'].Width := 0;
  Grid.ColumnByFieldName['EventTypeID'].Width := 0;
  Grid.ColumnByFieldName['luHouse'].Width := 0;
  Grid.ColumnByFieldName['EvScore'].Width := 0;
  Grid.ColumnByFieldName['EvPlace'].Width := 0;
  Grid.ColumnByFieldName['HtScore'].Width := 0;
  Grid.ColumnByFieldName['HtPlace'].Width := 0;
  Grid.ColumnByFieldName['SplitCount'].Width := 0;
end;

procedure TFrameLane.SetCollapsedUIState;
var
  indx: integer;
begin
  // ASSERT STATE: Collapsed Grid-View UI State...
  // Collapsed grid-view.
  if actnLn_GridView.Checked <> false then
    actnLn_GridView.Checked := false;
  // Button icon that displays a grid-view state.
  SetGridViewIconState;
  // Hide. Button is only visible in Expanded gridview.
  actnLn_HeatPicker.Visible := false;
  // With the heat-picker button hidden, tidy up the control panel's display.
  // Position all control icons to stack after btnGridView.
  indx := rpnlCntrl.ControlCollection.IndexOf(ShapeLnBar2);
  if indx <> -1 then
    rpnlCntrl.ControlCollection.Items[indx].Below := spbtnGridView;
end;

procedure TFrameLane.SetExpandedUIState;
var
  indx: integer;
begin
  // ASSERT STATE: Collapsed Grid-View UI State...
  // Collapsed grid-view.
  if actnLn_GridView.Checked <> true then
    actnLn_GridView.Checked := true;
  // Button icon that displays a grid-view state.
  SetGridViewIconState;
  // Hide. Button is only visible in Expanded gridview.
  actnLn_HeatPicker.Visible := true;
  // With the heat-picker button hidden, tidy up the control panel's display.
  // Position all control icons to stack after btnGridView.
  indx := rpnlCntrl.ControlCollection.IndexOf(ShapeLnBar2);
  if indx <> -1 then
    rpnlCntrl.ControlCollection.Items[indx].Below := spbtnHeatPicker;
end;

procedure TFrameLane.SetGridViewDQState;
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

procedure TFrameLane.SetGridViewIconState;
begin
  // logic saves on unessesary repaints.
  if (actnLn_GridView.Checked) then // Expanded view - icon has no slash.
  begin
    if (spbtnGridView.ImageIndex <> 11) then
      spbtnGridView.ImageIndex := 11;
  end
  else // Collapsed view - icon contains a slash.
  begin
    if (spbtnGridView.ImageIndex <> 12) then
       spbtnGridView.ImageIndex := 12;
  end;
end;

procedure TFrameLane.Loaded;
var
  item: TCollectionItem;
begin
  inherited;
  { IMPORTANT: At design time all columns are visible.}
  { IMPORTANT: Store column-order, needed by TMS to restore state.}
  Grid.SetColumnOrder;
  { Store the design-time layout. This contains default column display widths
     that will be useful later.}
  fStateStringSystem := Grid.ColumnStatesToString;
  // store the grid's design-time column state into settings.
  if Assigned(Settings) then
    Settings.Ln_ColumnStatesStringSystem := fStateStringSystem;

  { ASSERT STATE: The user have the option to assign 'none' (or empty)
    in the combobox drop-down for disqualification codes.
    TMS BUG: This is set at design-time but isn't persistent on construction
    of the TFrame.}
  item := Grid.ColumnByFieldName['luDQ'];
  if (item <> nil) then
    TDBGridColumnItem(item).AllowBlank := true;

  { Collapsed control panel UI State...  }
  SetCollapsedUIState;

  { The grid's collapsed 'lane' grid column order, width, visibility.
    This grid dis[play schema is identical to SCM version 1.
    Display widths for visible columns are not handled in this routine.
    It's presumed to be correctly set at design-time.
    Extended column features have their display widths set to 0.}
  SetCollapsedGridState; // DEFAULT GRID LAYOUT.

  // store the 'grid design schema'. (DEAULT GRID LAYOUT.)
  fStateStringCollapsed := Grid.ColumnStatesToString;

  // Get the user's custom column layout that is displayed in expanded gridview.
  if Assigned(Settings) then
  begin
    fStateStringExpanded := Settings.Ln_ColumnStatesStringExpanded;
    if fStateStringExpanded.IsEmpty then
      fStateStringExpanded := fStateStringCollapsed; // DEFAULT GRID LAYOUT.
  end
  else
    fStateStringExpanded := fStateStringCollapsed; // DEFAULT GRID LAYOUT.

  // TEAM/INDIVIDUAL
  OnEventTypeChange(CORE.qryLane.FieldByName('EventTypeID').AsInteger);
end;

procedure TFrameLane.OnEventTypeChange(AEventTypeID: Integer);
var
  item: TDBGridColumnItem;
begin
  item := Grid.ColumnByFieldName['FullName'];
  if item <> nil then
  begin
    if AEventTypeID = 2 then
      item.Header := 'Relay Team'
    else
      item.Header := 'Entrant';
  end;
end;

procedure TFrameLane.OnPreferenceChange;
begin
  SetGridViewDQState;
  // Debug mode state...
  pnlDebug.Visible := false; // default
  if Assigned(Settings) then
  begin
    if Settings.ShowDebugInfo then
      pnlDebug.Visible := true;
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
      grid.BeginUpdate;
      grid.ResetColumnOrder;

      // Collapsed control panel UI State...
      SetCollapsedUIState;
      // The grid's collapsed 'lane' grid column order, width, visibility.
      SetCollapsedGridState; // DEFAULT SCHEMA
      // store the 'default grid design schema'. (DEAULT UI LAYOUT.)
      fStateStringCollapsed := Grid.ColumnStatesToString;

      grid.EndUpdate;
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
      actnLn_GridView.Checked := false; // DEFAULT: Collapsed grid view.
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
