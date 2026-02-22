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
    actnLn_RefreshStats: TAction;
    spbtnRefreshStats: TSpeedButton;
    procedure actnLn_GenericUpdate(Sender: TObject);
    procedure actnLn_RefreshStatsExecute(Sender: TObject);
    procedure gridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
    procedure gridEllipsClick(Sender: TObject; ACol, ARow: Integer; var S: string);
    procedure gridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState:
        TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure gridGetEditMask(Sender: TObject; ACol, ARow: LongInt; var Value:
        string);
    procedure gridGetEditorType(Sender: TObject; ACol, ARow: Integer; var AEditor:
        TEditorType);
    procedure gridGetEditText(Sender: TObject; ACol, ARow: LongInt; var Value:
        string);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
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
  uSession, uEvent, uHeat, uLane, uNominee, uPickerStage;

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

procedure TFrameLane.actnLn_RefreshStatsExecute(Sender: TObject);
begin
  LockDrawing;
  // refresh the member's stats held in tblNominate
  uNominee.RefreshStats(uEvent.PK);
  // ... and push to lanes.
  uLane.RefreshStats(uHeat.PK);
  UnlockDrawing;
end;

procedure TFrameLane.gridCanEditCell(Sender: TObject; ARow, ACol: Integer; var
    CanEdit: Boolean);
begin
  CanEdit := false;
  case uHeat.HeatStatusID of
    1: // OPEN.
      begin // swimmer/team, racetime, s, q, dQ.
        if ACol in [2, 3, 6, 7, 8] then
          CanEdit := true;
      end;
    2: // RACED.
      begin // racetime, s, q, dQ.
        if ACol in [3, 6, 7, 8] then
          CanEdit := true;
      end;
    3: // CLOSED.
      begin
        CanEdit := false;
      end;
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
  if (ARow >= G.FixedRows) and (ACol = 2) then
  begin
    stage := TPickerStage.Create(Self);
    // deal with the ellipse button getting clicked...
    if ((GetKeyState(VK_CONTROL) and 128) = 128) then
      success := stage.Stage(uEvent.GetEventType,  uLane.PK, true)
    else
      success := stage.Stage(uEvent.GetEventType,  uLane.PK, false);
    stage.free;
  end;
  G.EndUpdate;
  if Success then
  begin
    // post ststus message?...
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
  if (ARow >= G.FixedRows) and (ACol = 3) then
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
  if (ARow >= G.FixedRows) and (ACol = 3) then
  begin
    AEditor := edNumeric;
  end;
  if (ARow >= G.FixedRows) and (ACol = 2) then
  begin
    AEditor := edEditBtn;
    Grid.BtnEdit.EditorEnabled := False; // disables typing
    Grid.BtnEdit.ButtonCaption := '...'; // optional
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
  if (ARow >= G.FixedRows) and (ACol = 3 )then
  begin
    // This method FIXES display format issues.
    dt := G.DataSource.DataSet.FieldByName('RaceTime').AsDateTime;
    DecodeTime(dt, Hour, Min, Sec, MSec);
    Value := Format('%0:2.2u:%1:2.2u.%2:3.3u', [Min, Sec, MSec]);
  end;
end;

procedure TFrameLane.gridKeyPress(Sender: TObject; var Key: Char);
begin
  {TODO -oBSA -cGeneral :
    Clear lookup cells, whether in edit state of not, using the BACKSPACE key.
    make it optional to use CNTRL+BACKSPACE to clear cell}

//      if ((GetKeyState(VK_CONTROL) and 128) = 128) then
//      begin
//      end;

  if (grid.row >= grid.FixedRows) and
      (grid.RealColIndex(grid.Col) in [2, 3, 8]) then
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
              case (grid.RealColIndex(grid.Col)) of
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
  item: TDBGridColumnItem;
begin
  inherited;
  // This executes after the DFM has loaded and ActionLinks have synced.
  // Fix Delphi's disabling column settings.
  item := Grid.ColumnByFieldName['luDQ'];
  if item <> nil then item.AllowBlank := true;
    // UNSAFE - Grid.Columns[?].AllowBlank := true;
end;

procedure TFrameLane.OnEventTypeChange(AEventTypeID: Integer);
begin
  if AEventTypeID = 2 then
    Grid.Columns[2].Header := 'Relay Team'
  else
    Grid.Columns[2].Header := 'Entrant';
end;

procedure TFrameLane.OnPreferenceChange;
begin
  LockDrawing;
  Grid.BeginUpdate;
  // default - use simplified method of disqualification
  Grid.Columns[8].Width := 0;
  Grid.Columns[6].Width := 39;
  Grid.Columns[7].Width := 39;
  try
    if Assigned(Settings) and Settings.EnableDQcodes then
    begin
      Grid.Columns[8].Width := 64;
      Grid.Columns[6].Width := 0;
      Grid.Columns[7].Width := 0;
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
