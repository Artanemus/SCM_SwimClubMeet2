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

  dmIMG, dmSCM2, dmCORE, uDefines, uSettings, uStateString;

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
  private
    FOnGridViewChange: TFrameNotifyLane_GridViewChange;


    { Design Time Grid UI state. Captured on load.
      Captures column widths for all fields.}
    fSysStateString: String;
    { Grid-View Collapsed StringState. }
    fStateStringCollapsed: String;
    { Grid-View Expanded StringState.
      User may include/excude columns when in expanded grid view. }
    fStateStringExpanded: String;


    procedure SetGridView_ColVisibility;
    procedure SetGridView_IconIndex;
    procedure SetDefGridSchemaState();

  protected
    procedure Loaded; override;

  public
    destructor Destroy; override; // Must be "override"

    procedure LinkActionsToMenu(AParentMenuItem: TActionClientItem);
    procedure OnEventTypeChange(AEventTypeID: Integer);
    procedure OnPreferenceChange();
    procedure UpdateUI(DoFullUpdate: boolean = false);

    // Notify main form of a grid view change (expand/collapse)...
    property OnGridViewChanged: TFrameNotifyLane_GridViewChange
      read FOnGridViewChange write FOnGridViewChange;

  end;

implementation

{$R *.dfm}

uses
  uSwimClub, uSession, uEvent, uHeat, uLane, uNominee,
  uPickerStage, dlgLaneColumnPicker, ASGEdit;

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
  item: TRelativePanelControlItem;
  indx: integer;
begin
  LaneAction := TAction(Sender);
  LaneAction.Checked := not LaneAction.Checked; // TOGGLE
  grid.BeginUpdate;
  CORE.qryLane.DisableControls;
  try
    SetGridView_IconIndex; // uses actnEv_GridView.Checked state.
    SetGridView_ColVisibility; // uses actnEv_GridView.Checked state.
    if LaneAction.Checked then
    begin
      actnLn_HeatPicker.Visible := true;
      indx := rpnlCntrl.ControlCollection.IndexOf(ShapeLnBar2);
      if indx <> -1 then
      begin
        item := rpnlCntrl.ControlCollection.Items[indx];
        item.Below := spbtnHeatPicker;
      end;
    end
    else
    begin
      actnLn_HeatPicker.Visible := false;
      indx := rpnlCntrl.ControlCollection.IndexOf(ShapeLnBar2);
      if indx <> -1 then
      begin
        item := rpnlCntrl.ControlCollection.Items[indx];
        item.Below := spbtnGridView;
      end;
    end;

  finally
    begin
      CORE.qryLane.EnableControls;
      grid.EndUpdate;
    end;
  end;

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
        else if fld.FieldName = 'luDQ' then CanEdit := true
        else if fld.FieldName = 'ClubRecord' then CanEdit := true;
      end;
      2: // RACED. racetime, s, q, dQ.
      begin
         // if indx in [3, 6, 7, 8] then CanEdit := true;
        if fld.FieldName = 'RaceTime' then CanEdit := true
        else if fld.FieldName = 'IsScratched' then CanEdit := true
        else if fld.FieldName = 'IsDisQualified' then CanEdit := true
        else if fld.FieldName = 'luDQ' then CanEdit := true
        else if fld.FieldName = 'ClubRecord' then
          CanEdit := true;
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
      if fld.FieldName = 'ClubRecord' then
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
  I, J: Integer;
  fld: TField;
//  item: TDBGridColumnItem;
  mr: TModalResult;
  // Params to restore user's column order and width.
//  BaseStateString: string;
//  offset1, offset2, offset3: integer;
//  widthindex: integer;
  TLaneStateString: TStateString; // Columns count, width, order, visibility.

begin
  // Must be in EXPANDED column mode to alter grid columns, withs, index, etc.
  if (ARow = 0) and (ACol = 0) and actnLn_GridView.Checked then
  begin
    LockDrawing;
    Grid.BeginUpdate;

    TLaneStateString := TStateString.Create;

    if Assigned(TLaneStateString) then
      TLaneStateString.StateString := Grid.ColumnStatesToString;

    try
      // display dlg to select column visibility...
      dlg := TLaneColumnPicker.Create(Self);
      dlg.SortItemsToMatchGrid(Grid);
      mr := dlg.ShowModal();
      if (mr = mrOK) then
      begin
        if dlg.DoReset then
        begin
//          Grid.ResetColumnOrder;
          // Restore layout. Displays ALL fields - as per design time...
          Grid.StringToColumnStates(fStateStringCollapsed);
        end
        else
        begin
          // iterate over results and adjust column visibility.
          for I := 0 to dlg.clbLane.Items.Count - 1 do
          begin
            fld := TField(dlg.clbLane.Items.Objects[I]);
            if Assigned(fld) then
            begin
              TLaneStateString.SetColVisible(fld.index, fld.Visible);
              if fld.Visible and  (TLaneStateString.GetColWidth(fld.Index) = 0) then
              begin
                // assign a default value prepared during design time ....
                J := TLaneStateString.GetColWidth(fld.index, fSysStateString);
                if J<>0 then
                  TLaneStateString.SetColWidth(fld.index, j);
              end;

            end;
          end;
          // fStateStringExpanded := TLaneStateString.StateString;
          Grid.StringToColumnStates(fStateStringExpanded);
        end;
      end;
      dlg.Free;

    finally
      Grid.EndUpdate;
      UnLockDrawing;
      TLaneStateString.Free;
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
      else if fld.FieldName = 'ClubRecord' then
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

procedure TFrameLane.SetDefGridSchemaState();
var
fld: Tfield;
begin
  // Set ALL fields too visible...
  for fld in CORE.qryLane.Fields do fld.Visible := true;

  // ASSERT field visibility per SCM (version 1) schema.
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

  // Set grid visiblity for EXPANDED grid columns .
  Grid.ColumnByFieldName['ClubRecord'].Width := 0;
  Grid.ColumnByFieldName['GenderABREV'].Width := 0;
  Grid.ColumnByFieldName['AGE'].Width := 0;
  Grid.ColumnByFieldName['EventTypeID'].Width := 0;
end;

procedure TFrameLane.SetGridView_ColVisibility;
begin
  // EXPANDED or COLLAPSED grid views...
  if actnLn_GridView.Checked then
  begin  // EXPANDED...
//    Grid.ResetColumnOrder;
    Grid.StringToColumnStates(fStateStringExpanded);
  end
  else
  begin  // COLLAPSED...  (DEFAULT VIEW)
//    Grid.ResetColumnOrder;
    Grid.StringToColumnStates(fStateStringCollapsed);
    { ALTERNATIVE - stable ...}
    // SetDefGridSchemaState();
  end;
end;

procedure TFrameLane.SetGridView_IconIndex;
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
  fld: TField;
  indx: integer;
begin
  inherited;
  // While all columns are visible at design time...
  // Take a snapshot of the columnwidths. These will be used when the user
  // adds columns to the grid view and the width is unknown.
  Grid.SetColumnOrder; // reference needed to restore state.
  fSysStateString := Grid.ColumnStatesToString;

  // Let the user have the option to assign 'none' (or empty)
  // in the combobox drop-down for disqualification codes.
  item := Grid.ColumnByFieldName['luDQ'];
  TDBGridColumnItem(item).AllowBlank := true;

  actnLn_GridView.Checked := false; // Collapsed - indicates fixed defult gridview.
  actnLn_HeatPicker.Visible := false; // hide. Button only visible when grid view is Expanded.
  spbtnGridView.ImageIndex := 12; // a button icon that displays a grid with slash.
  // ASSERT: position all control icons to stack after btnGridView.
  indx := rpnlCntrl.ControlCollection.IndexOf(ShapeLnBar2);
  if indx <> -1 then
    rpnlCntrl.ControlCollection.Items[indx].Below := spbtnGridView;

  // The default 'lane' grid column order, width, visibility used by SCM1
  SetDefGridSchemaState();
  // Performed again as this is the preferred state for a grid UI reset.
  Grid.SetColumnOrder;
  // store the 'default grid design schema' column states.
  fStateStringCollapsed := Grid.ColumnStatesToString;

  // User's custom column layout that is displayed in expanded gridview.
  if Assigned(Settings) then
    fStateStringExpanded := Settings.Ln_ColumnStatesStringExpanded
  else
    fStateStringExpanded := Grid.ColumnStatesToString;

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
