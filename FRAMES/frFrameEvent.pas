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
    procedure gridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState:
        TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure gridGetDisplText(Sender: TObject; ACol, ARow: Integer; var Value:
        string);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
  private
    FOnGridViewChange: TFrameNotifyEvent_GridViewChange;
    procedure SetGridView_ColVisibility;
    procedure SetGridView_IconIndex;
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
begin
    TAction(Sender).Checked := not TAction(Sender).Checked; // T O G G L E .
    grid.BeginUpdate;
    CORE.qryEvent.DisableControls;
    try
      SetGridView_IconIndex;  // uses actnEv_GridView.Checked state.
      SetGridView_ColVisibility;  // uses actnEv_GridView.Checked state.
    finally
      begin
        CORE.qryEvent.EnableControls;
        grid.EndUpdate;
      end;
    end;

    if Assigned(FOnGridViewChange) then
      FOnGridViewChange(self, TAction(Sender).Checked);
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
begin
  // inhibit -  description, gender, round.
  if actnEv_GridView.Checked then // Expanded.
    CanEdit := not (ACol in [0, 1, 2, 5, 7, 8, 9])
  else
    CanEdit := not (ACol in [0, 1, 2, 5 ,6, 7, 8, 9, 10, 11, 12, 13]); // collapsed.
end;

procedure TFrameEvent.gridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect:
  TRect; State: TGridDrawState);
var
  G: TDBAdvGrid;
begin
  G := TDBAdvGrid(Sender);

  if (ARow = 0) then
  begin
    case ACol of // Draw icons in the header line of the grid.
      8:
        IMG.imglstEventCell.Draw(G.Canvas, Rect.left + 4,
          Rect.top + 4, 1);
      9:
        IMG.imglstEventCell.Draw(G.Canvas, Rect.left + 4,
          Rect.top + 4, 2);
      10: // centered gender icon...
        IMG.imglstEventCell.Draw(G.Canvas, Rect.left + 6,
          Rect.top + 4, 3);
    end;
  end;
end;

procedure TFrameEvent.gridGetCellColor(Sender: TObject; ARow, ACol: Integer;
    AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  { C E L L   C O L O R S  .
    1. the StyleElements seFont has been disabled for the session grid.
    2. the property UseSelectionColor has been disabled.
    3. the property SelectionTextColor has been set but will be ignored.

    - results : all assignments of font color are handles here.
  }
  if (ARow >= grid.FixedRows) then   // (ARow >= grid.FixedCols)
  begin

    if (ACol in [2, 8, 9]) then
      AFont.Color := clWebLightgrey // readonly fields - not so white...

    else
    begin
      if (gdSelected in AState) then
      begin
        AFont.Color := clWhite;
      end
      else
        AFont.Color :=  clWebGhostWhite;
    end;

    // overrides all
    if uSession.IsLocked then
      AFont.Color := grid.DisabledFontColor;
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

procedure TFrameEvent.gridKeyPress(Sender: TObject; var Key: Char);
begin
  {TODO -oBSA -cGeneral :
    Clear lookup cells, whether in edit state of not, using the BACKSPACE key.
    make it optional to use CNTRL+BACKSPACE to clear cell}

//      if ((GetKeyState(VK_CONTROL) and 128) = 128) then
//      begin
//      end;

  if (grid.row >= grid.FixedRows) and
      (grid.RealColIndex(grid.Col) in [10, 11, 12, 13]) then
  begin
    if (Key = char(VK_BACK)) or (Key = #$7F) then
    begin
      grid.BeginUpdate;
      try
        begin
          try
            begin
              if (CORE.qryEvent.State <> dsEdit) then
                CORE.qryEvent.Edit;
              case (grid.RealColIndex(grid.Col)) of
                10:
                CORE.qryEvent.FieldByName('GenderID').Clear;
                11:
                CORE.qryEvent.FieldByName('RoundID').Clear;
                12:
                CORE.qryEvent.FieldByName('EventCategoryID').Clear;
                13:
                CORE.qryEvent.FieldByName('ParalympicTypeID').Clear;
              end;
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
  // This executes after the DFM has loaded and ActionLinks have synced.
  // Fix Delphi's disabling column settings.
  item := Grid.ColumnByFieldName['luRound'];
  if item <> nil then item.AllowBlank := true;
  item := Grid.ColumnByFieldName['luEventCat'];
  if item <> nil then item.AllowBlank := true;
  item := Grid.ColumnByFieldName['luParalympicType'];
  if item <> nil then item.AllowBlank := true;
  // UNSAFE - Grid.Columns[?].AllowBlank := true;
end;

procedure TFrameEvent.SetGridView_ColVisibility;
begin
  // EXPANDED or COLLAPSED grid views...
  if actnEv_GridView.Checked then
  begin  // EXPANDED...
    grid.Columns[6].Width := 400;   // DESCRIPTION.
    grid.Columns[10].Width := 38;   // Gender (ABREV)
    grid.Columns[11].Width := 80;   // Round (ABREV)
    grid.Columns[12].Width := 100;   // Event Category (ABREV)
    grid.Columns[13].Width := 140;   // ParaOlympic (Caption)
  end
  else
  begin  // COLLAPSED...
    grid.Columns[6].Width := 0;
    grid.Columns[10].Width := 0;
    grid.Columns[11].Width := 0;
    grid.Columns[12].Width := 0;
    grid.Columns[13].Width := 0;
  end;
end;

procedure TFrameEvent.SetGridView_IconIndex;
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
//    grid.Refresh;
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
      // Are we making a Connection or changing SwimClubs?
      if CORE.IsWorkingOnConnection then
        actnEv_GridView.Checked := false;

      SetGridView_IconIndex();
      SetGridView_ColVisibility;
    end;

  finally
    UnlockDrawing;
  end;

end;

end.
