unit frFrameEvent;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes,  System.Actions,

  Data.DB, BaseGrid,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.Menus, Vcl.ActnList, Vcl.Buttons, vcl.ImgList,
  Vcl.ActnMan,

  AdvUtil, AdvObj, AdvGrid, DBAdvGrid, Vcl.WinXCtrls,

  dmSCM2, dmIMG, dmCORE, uDefines,

  uSettings, uSession, uEvent, Vcl.StdCtrls;


type
{
    // 1. THE INTERCEPTER MUST GO HERE (Before the TFrame declaration)
    TSpeedButton = class(Vcl.Buttons.TSpeedButton)
    protected
      procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    end;
}

  TFrameNotifyEvent_GridViewChange = procedure(Sender: TObject; GridState:
      Boolean) of object;

  TFrameEvent = class(TFrame)
    actnEv_ClearCell: TAction;
    actnEv_Delete: TAction;
    actnEv_EventType: TAction;
    actnEv_Export: TAction;
    actnEv_Final: TAction;
    actnEv_GridView: TAction;
    actnEv_Import: TAction;
    actnEv_MoveDown: TAction;
    actnEv_MoveUp: TAction;
    actnEv_New: TAction;
    actnEv_QuartFinals: TAction;
    actnEv_Renumber: TAction;
    actnEv_Report: TAction;
    actnEv_Schedule: TAction;
    actnEv_SemiFinals: TAction;
    actnEv_Stats: TAction;
    actnlist: TActionList;
    ClearCell1: TMenuItem;
    DeleteEvent1: TMenuItem;
    EventReport1: TMenuItem;
    EventType1: TMenuItem;
    grid: TDBAdvGrid;
    MoveDown1: TMenuItem;
    MoveUp1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    NewEvent1: TMenuItem;
    oogleGridView1: TMenuItem;
    pnlBody: TPanel;
    pnlG: TPanel;
    pumenuEvent: TPopupMenu;
    rpnlCntrl: TRelativePanel;
    ShapeEvBar1: TShape;
    ShapeEvBar2: TShape;
    spbtnEvDelete: TSpeedButton;
    spbtnEvDown: TSpeedButton;
    spbtnEvGridView: TSpeedButton;
    spbtnEvIndvTeam: TSpeedButton;
    spbtnEvNew: TSpeedButton;
    spbtnEvReport: TSpeedButton;
    spbtnEvUp: TSpeedButton;
    procedure actnEv_DeleteExecute(Sender: TObject);
    procedure actnEv_DeleteUpdate(Sender: TObject);
    procedure actnEv_EventTypeExecute(Sender: TObject);
    procedure actnEv_EventTypeUpdate(Sender: TObject);
    procedure actnEv_GridViewExecute(Sender: TObject);
    procedure actnEv_GridViewUpdate(Sender: TObject);
    procedure actnEv_MoveUpDownExecute(Sender: TObject);
    procedure actnEv_MoveUpDownUpdate(Sender: TObject);
    procedure actnEv_NewExecute(Sender: TObject);
    procedure actnEv_NewUpdate(Sender: TObject);
    procedure actnEv_RenumberExecute(Sender: TObject);
    procedure actnEv_RenumberUpdate(Sender: TObject);
    procedure gridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
    procedure gridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure gridFixedCellClick(Sender: TObject; ACol, ARow: LongInt);
    procedure gridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState:
        TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure gridGetDisplText(Sender: TObject; ACol, ARow: Integer; var Value:
        string);
    procedure gridGetEditMask(Sender: TObject; ACol, ARow: LongInt; var Value:
        string);
    procedure gridGetEditorType(Sender: TObject; ACol, ARow: Integer; var AEditor:
        TEditorType);
    procedure gridGetEditText(Sender: TObject; ACol, ARow: LongInt; var Value:
        string);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
  private
    FOnGridViewChange: TFrameNotifyEvent_GridViewChange;

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
    procedure SetExpandedUIState;

  protected
    procedure Loaded; override;
  public
    procedure LinkActionsToMenu(AParentMenuItem: TActionClientItem);
    procedure UpdateUI(DoFullUpdate: Boolean = false);
    // Notify main form of a grid view change (expand/collapse)...
    property OnGridViewChanged: TFrameNotifyEvent_GridViewChange
      read FOnGridViewChange write FOnGridViewChange;
  end;

implementation

uses
  dlgLaneColumnPicker;

{$R *.dfm}

procedure TFrameEvent.actnEv_DeleteExecute(Sender: TObject);
begin
  grid.BeginUpdate;
  try
    if uEvent.DeleteEvent(true) then
    begin
      uSession.RenumberEvents(); // runs SCM2.dbo.RenumberEvents...
      CORE.qryEvent.Refresh;
    end;
  finally
    grid.EndUpdate;
  end;
end;

procedure TFrameEvent.actnEv_DeleteUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
    // fix RAD STUDIO icon re-assignment issue.
//  if (spbtnEvDelete.imageindex <> 5) then spbtnEvDelete.imageindex := 5;

  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameEvent.actnEv_EventTypeExecute(Sender: TObject);
begin
  grid.BeginUpdate;
  uEvent.ToggleEventTypeID;
  grid.EndUpdate;
end;

procedure TFrameEvent.actnEv_EventTypeUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  // fix RAD STUDIO icon re-assignment issue.
//  if (spbtnEvIndvTeam.imageindex <> 7) then spbtnEvDelete.imageindex := 7;

  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameEvent.actnEv_GridViewExecute(Sender: TObject);
var
  AAction: TAction;
begin
  AAction := TAction(Sender);
  grid.BeginUpdate;
  CORE.qryEvent.CheckBrowseMode;
  CORE.qryLane.DisableControls;
  AAction.Checked := not AAction.Checked; // TOGGLE
  try
    if AAction.Checked then // GRID-VIEW EXPANDED..
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
    FOnGridViewChange(self, AAction.Checked);
end;

procedure TFrameEvent.actnEv_GridViewUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;

  // NOTE: grid view remains enabled evenif events table is empty.
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameEvent.actnEv_MoveUpDownExecute(Sender: TObject);
var
cn: TComponentName;
PK: integer;
begin
    grid.BeginUpdate;
    PK := uEvent.PK;
    try
      cn := TComponent(Sender).Name;
      if String(cn).Contains('Down') then
        uEvent.MoveUpDown(scmMoveDirection.mdDown)
      else if string(cn).Contains('Up')  then
        uEvent.MoveUpDown(scmMoveDirection.mdUp)
      else exit;
    finally
      CORE.qryEvent.Refresh; // re-sort on indx - eventNum.
      uEvent.Locate(PK); // track event just moved.
      grid.EndUpdate;
    end;
end;

procedure TFrameEvent.actnEv_MoveUpDownUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;

  // fix RAD STUDIO icon re-assignment issue.
  {
  if (spbtnEvDown.imageindex <> 3) then
      spbtnEvDown.imageindex := 3;
  if (spbtnEvUp.imageindex <> 2) then
      spbtnEvUp.imageindex := 2;
  }

  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameEvent.actnEv_NewExecute(Sender: TObject);
begin
  grid.BeginUpdate;
  uEvent.NewEvent;
  // uSession.RenumberEvents();
  grid.EndUpdate;
end;

procedure TFrameEvent.actnEv_NewUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  // fix RAD STUDIO icon re-assignment issue.
//  if (spbtnEvNew.imageindex <> 4) then spbtnEvNew.imageindex := 4;

  // new is enabled when events table is empty
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameEvent.actnEv_RenumberExecute(Sender: TObject);
begin
  // call DB Procedure
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    grid.BeginUpdate;
    try
      uSession.RenumberEvents(); // runs SCM2.dbo.RenumberEvents...
      CORE.qryEvent.Refresh;
    finally
      grid.EndUpdate;
    end;
  end;
end;

procedure TFrameEvent.actnEv_RenumberUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;

  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameEvent.gridCanEditCell(Sender: TObject; ARow, ACol: Integer;
    var CanEdit: Boolean);
var
  G: TDBAdvGrid;
  fld: TField;
begin
  G := TDBAdvGrid(Sender);
  CanEdit := false;
  if uSession.IsLocked then exit;

  fld := G.FieldAtColumn[Acol];
  if Assigned(fld) then
  begin
    if not uEvent.AllHeatsAreClosed then
    begin
      if fld.FieldName = 'luDistance' then CanEdit := true;
      if fld.FieldName = 'luStroke' then CanEdit := true;
      if fld.FieldName = 'Caption' then CanEdit := true;
      if fld.FieldName = 'EventTypeID' then CanEdit := true;
      if fld.FieldName = 'luGender' then CanEdit := true;
      if fld.FieldName = 'luRound' then CanEdit := true;
      if fld.FieldName = 'luEventCat' then CanEdit := true;
      if fld.FieldName = 'luParalympicType' then CanEdit := true;
    end;
  end;
end;

procedure TFrameEvent.gridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect:
  TRect; State: TGridDrawState);
var
  G: TDBAdvGrid;
  item: TDBGridColumnItem;
begin
  G := TDBAdvGrid(Sender);
  { As columns can be moved - best practise is to use fieldname.}
  if (ARow = 0) then
  begin
    item := G.Columns[ACol];

    // Hamburger
    if (item.FieldName = 'EventID') and actnEv_GridView.Checked then
    begin
      IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 6);
      exit;
    end;
    // INDV/RELAY ICON
    if (item.FieldName = 'EntrantTypeID') then
    begin
      IMG.imglstEventCell.Draw(G.Canvas, Rect.left + 4, Rect.top + 4, 4);
      exit;
    end;
    // TICK ICON
    if (item.FieldName = 'EventStatusID') then
    begin
        IMG.imglstEventCell.Draw(G.Canvas, Rect.left + 4, Rect.top + 4, 5);
      exit;
    end;
    // PERSON ICON
    if (item.FieldName = 'NomineeCount') then
    begin
        IMG.imglstEventCell.Draw(G.Canvas, Rect.left + 4, Rect.top + 4, 1);
      exit;
    end;
    // PERSON WITH TICK ICON.
    if (item.FieldName = 'EntrantCount') then
    begin
        IMG.imglstEventCell.Draw(G.Canvas, Rect.left + 4, Rect.top + 4, 2);
      exit;
    end;
    // MALE/FEMAL ICON.
    if (item.FieldName = 'luGender') then
    begin
        IMG.imglstEventCell.Draw(G.Canvas, Rect.left + 4, Rect.top + 4, 2);
      exit;
    end;
  end;
end;

procedure TFrameEvent.gridFixedCellClick(Sender: TObject; ACol, ARow: LongInt);
var
  dlg: TLaneColumnPicker;
  mr: TModalResult;
begin
  // Must be in EXPANDED column mode to alter grid columns, withs, index, etc.
  if (ARow = 0) and (ACol = 0) and actnEv_GridView.Checked then
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

procedure TFrameEvent.gridGetCellColor(Sender: TObject; ARow, ACol: Integer;
  AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  fld: TField;
begin
  { C E L L   C O L O R S  .
    1. the StyleElements seFont has been disabled for the session grid.
    2. the property UseSelectionColor has been disabled.
    3. the property SelectionTextColor has been set but will be ignored.
    - results : all assignments of font color are handles here.
  }
  if (ARow >= grid.FixedRows) then // (ARow >= grid.FixedCols)
  begin
      fld := TDBAdvGrid(Sender).FieldAtColumn[ACol];
      if Assigned(fld) then
      begin
        if (fld.FieldName = 'EventNum') or (fld.FieldName = 'NomineeCount') or
        (fld.FieldName = 'EntrantCount') then
          AFont.Color := clWebLightgrey // readonly fields - not so white...
        else
        begin
          if (gdSelected in AState) then
          begin
            AFont.Color := clWhite;
          end
          else
            AFont.Color := clWebGhostWhite;
        end;

        // overrides all
        if uSession.IsLocked then
          AFont.Color := grid.DisabledFontColor;
      end;
  end;
end;

procedure TFrameEvent.gridGetDisplText(Sender: TObject; ACol, ARow: Integer;
    var Value: string);
var
  indx: integer;
begin
  // Here we toggle the DISABLED ICONS when needed by the TDBAdvGrid.
  // Ref: IMG.imglstEventType
  if (ARow >= grid.FixedRows) then
    if CORE.qryEvent.UpdateOptions.ReadOnly then
    begin
      indx := StrToIntDef(Value, 0);
      case ACol of
        5: // EVENT TYPE - INDV/RELAY.
        begin
          if indx > 0 then Value := IntToStr(indx + 2);
          if indx = 0 then Value := '5'; // lightbulb+error.
        end;
      end;
    end;
end;

procedure TFrameEvent.gridGetEditMask(Sender: TObject; ACol, ARow: LongInt; var
    Value: string);
var
  G: TDBAdvGrid;
  fld: TField;
begin
  G := TDBAdvGrid(Sender);
  fld := G.FieldAtColumn[ACol];
  if Assigned(fld) then
  begin
    if (ARow >= G.FixedRows) and (fld.FieldName = 'StartTime') then
    begin
      Value := '!00:00;1;0';
    end;
  end;
end;

procedure TFrameEvent.gridGetEditorType(Sender: TObject; ACol, ARow: Integer;
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
      if fld.FieldName = 'StartTime' then AEditor := edNumeric
    end;
  end;
end;

procedure TFrameEvent.gridGetEditText(Sender: TObject; ACol, ARow: LongInt; var
    Value: string);
var
  Hour, Min, Sec, MSec: word;
  G: TDBAdvGrid;
  dt: TDateTime;
begin
  G := TDBAdvGrid(Sender);
  if (ARow >= G.FixedRows) and (G.Columns[ACol].FieldName = 'StartTime')then
  begin
    // This method FIXES display format issues.
    dt := G.DataSource.DataSet.FieldByName('StartTime').AsDateTime;
    DecodeTime(dt, Hour, Min, Sec, MSec);
    Value := Format('%0:2.2u:%1:2.2u', [Hour, Min]);
  end;
end;

procedure TFrameEvent.gridKeyPress(Sender: TObject; var Key: Char);
var
  G: TDBAdvGrid;
  fld: TField;
begin
  {TODO -oBSA -cGeneral :
    Clear lookup cells, whether in edit state of not, using the BACKSPACE key.
    make it optional to use CNTRL+BACKSPACE to clear cell}

//      if ((GetKeyState(VK_CONTROL) and 128) = 128) then
//      begin
//      end;
  if (grid.row >= grid.FixedRows) then
  begin
    G := TDBAdvGrid(Sender);
    fld := G.FieldAtColumn[G.Col];
    if (Key = char(VK_BACK)) or (Key = #$7F) then
    begin
      if (fld.FieldName = 'GenderID') or
      (fld.FieldName = 'RoundID') or
      (fld.FieldName = 'EventCategoryID') or
      (fld.FieldName = 'ParalympicTypeID') then
      begin
        grid.BeginUpdate;
        try
          begin
            try
              begin
                if (CORE.qryEvent.State <> dsEdit) then
                  CORE.qryEvent.Edit;
                if (fld.FieldName = 'GenderID') then
                  CORE.qryEvent.FieldByName('GenderID').Clear;
                if (fld.FieldName = 'RoundID') then
                  CORE.qryEvent.FieldByName('RoundID').Clear;
                if (fld.FieldName = 'EventCategoryID') then
                  CORE.qryEvent.FieldByName('EventCategoryID').Clear;
                if (fld.FieldName = 'ParalympicTypeID') then
                  CORE.qryEvent.FieldByName('ParalympicTypeID').Clear;
                CORE.qryEvent.Post;
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
end;

procedure TFrameEvent.LinkActionsToMenu(AParentMenuItem: TActionClientItem);
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

procedure TFrameEvent.Loaded;
var
  item: TDBGridColumnItem;
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
  item := Grid.ColumnByFieldName['luRound'];
  if item <> nil then
    TDBGridColumnItem(item).AllowBlank := true;
  item := Grid.ColumnByFieldName['luEventCat'];
  if item <> nil then
    TDBGridColumnItem(item).AllowBlank := true;
  item := Grid.ColumnByFieldName['luParalympicType'];
  if item <> nil then
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


end;

procedure TFrameEvent.SetCollapsedGridState;
var
fld: Tfield;
begin
  // Set ALL fields too visible...
  for fld in CORE.qryEvent.Fields do fld.Visible := true;
  { COLLAPSE SCHEMA (same as SCMv1.)
    EventNum, LuDistance, luStroke, Caption, EventTypeID, EventStatusID,
    NomineeCount, EntrantCount.
  }
  CORE.qryEvent.FieldByName('EventID').Visible := false;
  CORE.qryEvent.FieldByName('SessionID').Visible := false;
  CORE.qryEvent.FieldByName('DistanceID').Visible := false;
  CORE.qryEvent.FieldByName('StrokeID').Visible := false;
  CORE.qryEvent.FieldByName('RoundID').Visible := false;
  CORE.qryEvent.FieldByName('GenderID').Visible := false;
  CORE.qryEvent.FieldByName('ParalympicTypeID').Visible := false;
  CORE.qryEvent.FieldByName('EventCategoryID').Visible := false;
  CORE.qryEvent.FieldByName('ABBREV').Visible := false;

  { Set: grid visiblity for COLLAPSED (extended features) grid columns .}
  Grid.ColumnByFieldName['luGender'].Width := 0;
  Grid.ColumnByFieldName['luRound'].Width := 0;
  Grid.ColumnByFieldName['luEventCat'].Width := 0;
  Grid.ColumnByFieldName['luParalympicType'].Width := 0;
  Grid.ColumnByFieldName['StartTime'].Width := 0;
  Grid.ColumnByFieldName['luEventType'].Width := 0;
  Grid.ColumnByFieldName['luDistanceEx'].Width := 0;

end;

procedure TFrameEvent.SetCollapsedUIState;
begin
  // ASSERT STATE: Collapsed Grid-View UI State...
  // Collapsed grid-view.
  if actnEv_GridView.Checked <> false then
    actnEv_GridView.Checked := false;
  // Button icon that displays a grid-view state.
  SetGridViewIconState;
end;

procedure TFrameEvent.SetExpandedUIState;
begin
  // ASSERT STATE: Collapsed Grid-View UI State...
  // Collapsed grid-view.
  if actnEv_GridView.Checked <> true then
    actnEv_GridView.Checked := true;
  // Button icon that displays a grid-view state.
  SetGridViewIconState;
end;


procedure TFrameEvent.SetGridViewIconState;
begin
  // logic saves on unessesary repaints.
  if (actnEv_GridView.Checked) then // Expanded view - icon has no slash.
  begin
    if (spbtnEvGridView.ImageIndex <> 1) then
      spbtnEvGridView.ImageIndex := 1;
  end
  else // Collapsed view - icon contains a slash.
  begin
    if (spbtnEvGridView.ImageIndex <> 0) then
       spbtnEvGridView.ImageIndex := 0;
  end;
end;

procedure TFrameEvent.UpdateUI(DoFullUpdate: Boolean = false);
begin

  if DoFullUpdate then
  begin
    // CHECK TMS rule..
    if grid.RowCount < grid.FixedRows  then
      grid.RowCount := grid.FixedRows + 1;

    { NOTE: never make TMG TDBAdvGrid Invisible. It won't draw correctly.}

    if (not Assigned(SCM2)) or (not SCM2.scmConnection.connected) or
        (not Assigned(CORE)) or (not CORE.IsActive) or (CORE.qrySession.IsEmpty) then
    begin
      Self.Visible := false; // hide everthing - move on.
      exit;
    end;
    { grid must be visible to sync + forces re-paint. }
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
    if CORE.qrySession.IsEmpty() then
    begin
      Self.Visible := false;   // hide TMS grid.
      exit;
    end;
    if not Self.Visible then Self.Visible := true;
    if CORE.qryEvent.IsEmpty then
    begin
      // CNTRL panel is displayed but not the grid.
      pnlBody.Visible := true;
      pnlG.Visible := false;
      actnEv_GridView.Checked := false; // DEFAULT: Collapsed grid view.
    end
    else
    begin
      pnlBody.Visible := true;
      pnlG.Visible := true;
      {
      // Are we making a Connection or changing SwimClubs?
      if CORE.IsWorkingOnConnection then
      begin
        if actnEv_GridView.Checked <> false then
        begin
          // SET TO COLLAPSED GRID OR DO FULL UPDATE?
        end;
      end;
      }
    end;

  finally
    UnlockDrawing;
  end;

end;

end.
