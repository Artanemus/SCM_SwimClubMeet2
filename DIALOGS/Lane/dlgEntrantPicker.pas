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
    procedure GridCustomCompare(Sender: TObject; str1, str2: string; var Res:
        Integer);
    procedure GridGetFormat(Sender: TObject; ACol: Integer; var AStyle: TSortStyle;
        var aPrefix, aSuffix: string);
  private
    { Private declarations }
    fToggleNameState: boolean;

    prefUseDefRaceTime: boolean;
    prefRaceTimeTopPercent: double;
    prefHeatAlgorithm: Integer;
    ToggleState: Array [0 .. 4] of boolean;
    fSeedDate: TDate;
    FSuccess: boolean;

    function AssertConnection(AConnection: TFDConnection): boolean;
    function UpdateLaneData: boolean;
    function LocateMemberID(AMemberID: Integer; ADataSet: TDataSet): boolean;
    procedure UpdateGridTitleBar(ColumnID: Integer);
    function NormalizeDistanceID(aDistanceID: integer): integer;

  public
    { Public declarations }
    function Prepare(LaneID: Integer): boolean;

    property Success: boolean read FSuccess write FSuccess;

  end;

var
  EntrantPicker: TEntrantPicker;

implementation

{$R *.dfm}

uses uUtility, uEvent, uNominee, IniFiles, System.Math;


function TEntrantPicker.AssertConnection(AConnection: TFDConnection): boolean;
begin

end;

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
  FSuccess := false;

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

  // U P D A T E   N O M I N A T I O N S .

  // U P D A T E   L A N E D A T A .
  if True then
  begin
    fSuccess := true;
  end;

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

procedure TEntrantPicker.GridCanEditCell(Sender: TObject; ARow, ACol:
    Integer; var CanEdit: Boolean);
begin
  CanEdit := false;
end;

function ParseMMSSmmmToTime(const S: string; out ATime: TTime): Boolean;
var
  sTrim, minsPart, secsPart, msPart: string;
  mins, secs, ms: Integer;
  totalMS, hrs, minsR, secsR: Int64;
  dotPos, colonPos: Integer;
  i: Integer;
  digits: string;
begin
  Result := False;
  ATime := 0;
  sTrim := Trim(S);
  if sTrim = '' then Exit;

  // split minutes and seconds by ':' (if present)
  colonPos := Pos(':', sTrim);
  if colonPos > 0 then
  begin
    minsPart := Trim(Copy(sTrim, 1, colonPos-1));
    secsPart := Trim(Copy(sTrim, colonPos+1, MaxInt));
  end
  else
  begin
    // no colon means we treat the whole string as seconds[.ms]
    minsPart := '0';
    secsPart := sTrim;
  end;

  // split seconds and milliseconds by '.' or ','
  dotPos := Pos('.', secsPart);
  if dotPos = 0 then dotPos := Pos(',', secsPart);
  if dotPos > 0 then
  begin
    msPart := Copy(secsPart, dotPos+1, MaxInt);
    secsPart := Copy(secsPart, 1, dotPos-1);
  end
  else
    msPart := '0';

  mins := StrToIntDef(minsPart, -1);
  secs := StrToIntDef(secsPart, -1);
  if (mins < 0) or (secs < 0) then Exit(False);

  // normalise ms to 0..999 (handle 1-3 digits)
  digits := '';
  for i := 1 to Length(msPart) do
    if msPart[i] in ['0'..'9'] then
      digits := digits + msPart[i]
    else
      Break;
  if digits = '' then
    ms := 0
  else if Length(digits) = 1 then
    ms := StrToIntDef(digits, 0) * 100
  else if Length(digits) = 2 then
    ms := StrToIntDef(digits, 0) * 10
  else
    ms := StrToIntDef(Copy(digits, 1, 3), 0);

  // compute total milliseconds and convert into h:m:s:ms for EncodeTime
  totalMS := (Int64(mins) * 60 + Int64(secs)) * 1000 + ms;
  hrs := totalMS div 3600000;
  totalMS := totalMS mod 3600000;
  minsR := totalMS div 60000;
  totalMS := totalMS mod 60000;
  secsR := totalMS div 1000;
  ms := totalMS mod 1000;

  try
    ATime := EncodeTime(hrs, minsR, secsR, ms);
    Result := True;
  except
    Result := False;
  end;
end;

procedure TEntrantPicker.GridCustomCompare(Sender: TObject; str1, str2: string;
    var Res: Integer);
var
  T1, T2: TTime;
  fs: TFormatSettings;
  ok1, ok2: Boolean;
begin
  // Prefer MM:SS.mmm parsing, but fall back to StrToTime for other formats
  ok1 := ParseMMSSmmmToTime(str1, T1);
  ok2 := ParseMMSSmmmToTime(str2, T2);
  if not (ok1 and ok2) then
  begin
    fs := TFormatSettings.Create;
    fs.ShortTimeFormat := 'hh:nn:ss.zzz';
    try
      T1 := StrToTime(str1, fs);
      T2 := StrToTime(str2, fs);
    except
      on E: EConvertError do
      begin
        Res := 0;
        Exit;
      end;
    end;
  end;

  if T1 < T2 then Res := -1
  else if T1 = T2 then Res := 0
  else Res := 1;
end;

procedure TEntrantPicker.GridGetFormat(Sender: TObject; ACol: Integer; var
    AStyle: TSortStyle; var aPrefix, aSuffix: string);
var
  G: TDBAdvGrid;
begin
  G := TDBAdvGrid(Sender);
  case ACol of
  1, 5:
    AStyle := ssAlphaNoCase;
  2, 3:
    AStyle := ssCustom; // sorting on TTB, PB.
  4:
    AStyle := ssNumeric;
  end;
end;

end.
