unit dlgEntrantPicker;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants,
  System.Classes, System.Actions, System.ImageList,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList,
  Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.VirtualImage, Vcl.BaseImageCollection,
  Vcl.ImageCollection,  Vcl.ImgList, Vcl.VirtualImageList,

  Data.DB,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,


  dmSCM2, dmCORE, dmIMG, uDefines, uSettings, AdvUtil, AdvObj, BaseGrid,
  AdvGrid, DBAdvGrid;

type
  TEntrantPicker = class(TForm)
    Panel1: TPanel;
    btnPost: TButton;
    btnCancel: TButton;
    btnToggleName: TButton;
    Nominate_Edit: TEdit;
    qryQuickPick: TFDQuery;
    qryQuickPickMemberID: TIntegerField;
    qryQuickPickFName: TWideStringField;
    qryQuickPickTTB: TTimeField;
    qryQuickPickPB: TTimeField;
    qryQuickPickAGE: TIntegerField;
    dsQuickPick: TDataSource;
    qryQuickPickEventID: TIntegerField;
    qryQuickPickGenderID: TIntegerField;
    VirtualImage2: TVirtualImage;
    qryQuickPickGenderABREV: TWideStringField;
    Grid: TDBAdvGrid;
    qryQuickPickNomineeID: TFDAutoIncField;
    pnlHeader: TPanel;
    pnlBody: TPanel;
    pnlCntrl: TPanel;
    pnlGrid: TPanel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridDblClick(Sender: TObject);
    procedure GridTitleClick(Column: TColumn);
    procedure Nominate_EditChange(Sender: TObject);
    procedure btnToggleNameClick(Sender: TObject);
    procedure GridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
  private
    { Private declarations }
    fToggleNameState: boolean;

    prefUseDefRaceTime: boolean;
    prefRaceTimeTopPercent: double;
    prefHeatAlgorithm: Integer;
    ToggleState: Array [0 .. 4] of boolean;
    fSeedDate: TDate;

    function AssertConnection(AConnection: TFDConnection): boolean;
    function UpdateLaneData: boolean;
    function LocateMemberID(AMemberID: Integer; ADataSet: TDataSet): boolean;
    procedure UpdateGridTitleBar(ColumnID: Integer);
    function NormalizeDistanceID(aDistanceID: integer): integer;

  public
    { Public declarations }
    function Prepare(LaneID: Integer): boolean;
  end;

var
  EntrantPicker: TEntrantPicker;

implementation

{$R *.dfm}

uses uUtility, uEvent, uNominee, IniFiles, System.Math;


procedure TEntrantPicker.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TEntrantPicker.btnPostClick(Sender: TObject);
begin
  if not qryQuickPick.Active then exit;
  if UpdateLaneData then
    ModalResult := mrOk else
    ModalResult := mrCancel;
end;

procedure TEntrantPicker.btnToggleNameClick(Sender: TObject);
var
  MemberID: Integer;
begin
  fToggleNameState := not fToggleNameState;
  with dsQuickPick.DataSet as TFDQuery do
  begin
    MemberID := FieldByName('MemberID').AsInteger;
    DisableControls;
    Close;
    ParamByName('TOGGLENAME').AsBoolean := fToggleNameState;
    Prepare;
    Open;
    if (Active) then LocateMemberID(MemberID, dsQuickPick.DataSet);
    EnableControls();
  end;
end;

procedure TEntrantPicker.GridDblClick(Sender: TObject);
var
  Pt: TPoint;
  Coord: TGridCoord;
begin
  // if titles are enabled - check that the double click didn't
  // occur in the title bar.
  if (dgTitles in TDBGrid(Sender).Options) then
  begin
    Pt := TDBGrid(Sender).ScreenToClient(Mouse.CursorPos);
    Coord := TDBGrid(Sender).MouseCoord(Pt.X, Pt.Y);
    // row zero is title bar.
    if (Coord.Y <> 0) then btnPostClick(Sender);
  end
  else btnPostClick(Sender);
end;

procedure TEntrantPicker.GridTitleClick(Column: TColumn);
begin
  // toggle the state of ASC or DESC.
  ToggleState[Column.ID] := not ToggleState[Column.ID];
  UpdateGridTitleBar(Column.ID);
end;

procedure TEntrantPicker.FormCreate(Sender: TObject);
var
  iniFileName: String;
  ifile: TIniFile;
  i: Integer;
begin
  prefUseDefRaceTime := true;
  prefRaceTimeTopPercent := 50.0;
  prefHeatAlgorithm := 1; // Base is zero
  fSeedDate := uNominee.GetSeedDate;

  if Assigned(SCM2) and SCM2.scmConnection.Connected then
    qryQuickPick.Connection := SCM2.scmConnection
  else
    Close;

  // ---------------------------------------------------------
  // A S S I G N   P R E F E R E N C E S ...
  // ---------------------------------------------------------
  if Assigned(Settings) then
  begin
    prefUseDefRaceTime := Settings.ttb_calcDefRT;
    prefRaceTimeTopPercent := Settings.ttb_calcDefRTpercent;
    prefHeatAlgorithm := settings.ttb_algorithmIndx;
  end
  else
  begin
    prefUseDefRaceTime := false;
    prefRaceTimeTopPercent := 50.0;
    // 1 - the entrant's average of top 3 race-times. Note: Base is zero.
    prefHeatAlgorithm := 1;
  end;

  UpdateGridTitleBar(0);
end;

procedure TEntrantPicker.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then ModalResult := mrCancel;
end;

function TEntrantPicker.LocateMemberID(AMemberID: Integer;
  ADataSet: TDataSet): boolean;
var
  SearchOptions: TLocateOptions;
begin
  SearchOptions := SearchOptions + [loPartialKey];
  try
    result := ADataSet.Locate('MemberID', AMemberID, SearchOptions);
  except
    on E: Exception do result := false;
  end;
end;

procedure TEntrantPicker.Nominate_EditChange(Sender: TObject);
var
  fs: string;
begin
  with dsQuickPick.DataSet do
  begin
    if Active then
    begin
      fs := '';
      DisableControls;
      // update filter string ....
      if (Length(Nominate_Edit.Text) > 0) then
      begin
        fs := fs + '[FName] LIKE ' + QuotedStr('%' + Nominate_Edit.Text + '%');
      end;
      // assign filter
      if fs.IsEmpty then Filtered := false
      else
      begin
        Filter := fs;
        if not Filtered then Filtered := true;
      end;
      EnableControls;
    end;
  end;
end;

function TEntrantPicker.Prepare(LaneID: Integer): boolean;
begin
  result := false;
  LockDrawing;
  // Grid.BeginUpdate
  qryQuickPick.DisableControls;
  try
    qryQuickPick.Close();
    qryQuickPick.ParamByName('EVENTID').AsInteger := uEvent.PK;
    qryQuickPick.ParamByName('TOGGLENAME').AsBoolean := fToggleNameState;
    qryQuickPick.Prepare();
    qryQuickPick.Open();
    if (qryQuickPick.Active) then
      result := true;
  finally
    qryQuickPick.EnableControls;
    // Grid.EndUpdate
    UnlockDrawing;
  end;
end;

function TEntrantPicker.UpdateLaneData: boolean;
begin
  result := false;
end;

procedure TEntrantPicker.UpdateGridTitleBar(ColumnID: Integer);
var
  idx: Integer;
  s: string;
begin
{
  Grid.Columns[0].Title.Caption := 'Nominees';
  Grid.Columns[1].Title.Caption := 'TimeToBeat';
  Grid.Columns[2].Title.Caption := 'Personal Best';
  Grid.Columns[3].Title.Caption := 'AGE';
  Grid.Columns[4].Title.Caption := 'Gender';

  // This cryptic method works provided all indexes are listed in the
  // correct order and all are active...
  //
  idx := (ColumnID * 2) + Integer(ToggleState[ColumnID]);
  qryQuickPick.Indexes[idx].Selected := true;
  if ToggleState[ColumnID] then s := (#$02C4 + ' ')
  else s := (#$02C5 + ' ');

  Grid.Columns[ColumnID].Title.Caption := s + Grid.Columns[ColumnID]
    .Title.Caption;
}
end;

function TEntrantPicker.NormalizeDistanceID(aDistanceID: integer): integer;
var
  tbl: TFDTable;
  SearchOptions: TLocateOptions;
  foundit: Boolean;
  meters, aEventTypeID: integer;
begin
  result := 0; // Flags - failed to normalize.
//  if not Assigned(fConnection) then exit;
  tbl := TFDTable.Create(self);
  tbl.TableName := 'SwimClubMeet2..Distance';
//  tbl.Connection := FConnection;
  tbl.IndexFieldNames := 'DistanceID';
  tbl.UpdateOptions.ReadOnly := true;
  tbl.Open;
  if tbl.Active then
  Begin
    // locate the
    foundit := tbl.Locate('DistanceID', aDistanceID, SearchOptions);
    if foundit then
    begin
      meters := tbl.FieldByName('Meters').AsInteger;
      aEventTypeID := tbl.FieldByName('EventTypeID').AsInteger;
      if aEventTypeID = 1 then // INDV EVENT
          result := aDistanceID
      else if aEventTypeID = 2 then // TEAM EVENT
      Begin
        // Total meters divided by number of swimmers.
        // It's ASSUMED that relays have 4 swimmer (Olympic Standard).
        meters := (meters div 4);
        // XReference : The distance swum by each swimmer in the relay.
        // Result is the ID of a INDV event.
        foundit := tbl.Locate('Meters; EventTypeID', VarArrayOf([meters, 1]),
          SearchOptions);
        // This normalized distance is required/used by scalar
        // functions dbo.TTB and dbo.PB
        if foundit then result := tbl.FieldByName('DistanceID').AsInteger;
      End;
    end;
  End;
  tbl.Close;
  tbl.Free;
end;

procedure TEntrantPicker.GridCanEditCell(Sender: TObject; ARow, ACol:
    Integer; var CanEdit: Boolean);
begin
  CanEdit := false;
end;

end.
