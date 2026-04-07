unit dlgQualifyTimes;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,

  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.DBCtrls, Vcl.Buttons,

  Data.DB,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmSCM2, dmCORE;

type
  TTabPoolType = class
    PoolTypeID: Integer;
    Caption: string;
  end;

type
  TQualifyTimes = class(TForm)
    pgcntrlMain: TPageControl;
    TabSheet1: TTabSheet;
    Panel3: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    btnSessionReport: TButton;
    btnMemberReport: TButton;
    btnDistStrokeReport: TButton;
    btnTableReport: TButton;
    btnNotQualifyReport: TButton;
    pnlFooter: TPanel;
    BtnClose: TButton;
    qryQualify: TFDQuery;
    qryQualifyTrialDistID: TIntegerField;
    qryQualifyQualifyDistID: TIntegerField;
    qryQualifyStrokeID: TIntegerField;
    qryQualifyGenderID: TIntegerField;
    qryQualifyQualifyID: TFDAutoIncField;
    qryQualifyluQDistance: TStringField;
    qryQualifyluStroke: TStringField;
    qryQualifyluTDistance: TStringField;
    qryQualifyluGender: TStringField;
    qryQualifyTrialTime: TTimeField;
    DSQualify: TDataSource;
    tblQStroke: TFDTable;
    luGender: TFDTable;
    tabCntrl: TTabControl;
    lblCourseDescription: TLabel;
    Grid: TDBAdvGrid;
    qryQualifyPoolTypeStr: TWideStringField;
    tblPoolTypes: TFDTable;
    qryTrialDist: TFDQuery;
    qryQualifyDist: TFDQuery;
    tblTStroke: TFDTable;
    qryQualifyTrialStrokeID: TIntegerField;
    qryQualifyluTStroke: TStringField;
    lblTrialStroke: TLabel;
    navGrid: TDBNavigator;
    qryQualifyLaps: TFloatField;
    qryQualifyPoolTypeID: TIntegerField;
    qryQualifyABREV: TWideStringField;
    qryQualifyLengthOfPool: TFloatField;
    qryQualifyUnitTypeStr: TWideStringField;
    qryQualifyDistPoolTypeID: TFDAutoIncField;
    qryQualifyDistDistanceID: TFDAutoIncField;
    qryQualifyDistDistStr: TWideStringField;
    qryTrialDistPoolTypeID: TFDAutoIncField;
    qryTrialDistDistanceID: TFDAutoIncField;
    qryTrialDistDistStr: TWideStringField;
    qryQualifyDistLaps: TFloatField;
    qryTrialDistLaps: TFloatField;
    procedure BtnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qryQualifyTrialTimeGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure qryQualifyTrialTimeSetText(Sender: TField; const Text: string);
    procedure btnSessionReportClick(Sender: TObject);
    procedure btnTableReportClick(Sender: TObject);
    procedure btnMemberReportClick(Sender: TObject);
    procedure btnDistStrokeReportClick(Sender: TObject);
    procedure btnNotQualifyReportClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GridGetEditMask(Sender: TObject; ACol, ARow: LongInt; var Value:
        string);
    procedure GridGetEditorType(Sender: TObject; ACol, ARow: Integer; var AEditor:
        TEditorType);
    procedure GridGetEditText(Sender: TObject; ACol, ARow: LongInt; var Value:
        string);
    procedure qryQualifyNewRecord(DataSet: TDataSet);
    procedure tabCntrlChange(Sender: TObject);
  private
    FPoolTypeID: integer;
    function LocatePoolTypeTab(PoolTypeID: integer): integer;
  public
    property PoolTypeID: integer read FPoolTypeID write FPoolTypeID;
  end;

var
  QualifyTimes: TQualifyTimes;

implementation

{$R *.dfm}

uses rptQTSessionReportA, rptQTDistStrokeReportA, rptQTMemberReportA,
  rptQTTableReportA, rptQTNotQualified, uSwimClub;

procedure TQualifyTimes.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TQualifyTimes.btnDistStrokeReportClick(Sender: TObject);
var
  rptA: TQTDistStrokeReportA;
  // rptB: TQTDistStrokeReportB;
begin
  // run qulify for session report
  try
    // control key is pressed
    if ((GetKeyState(VK_CONTROL) and 128) = 128) then
    begin
      // rptB := TQTDistStrokeReportB.Create(self);
      // rptB.RunReport;
      // rptB.Free;
    end
    else
    begin
      rptA := TQTDistStrokeReportA.Create(self);
      rptA.RunReport();
      rptA.Free;
    end;
  except
    on E: Exception do
      // illegal date..
      ShowMessage('Error opening QualifyTimes : Session Report.');
  end;
  if BtnClose.CanFocus then
    BtnClose.SetFocus;
end;

procedure TQualifyTimes.btnMemberReportClick(Sender: TObject);
var
  rptA: TQTMemberReportA;
  // rptB: TQTMemberReportB;
begin
  // run qulify for session report
  try
    // control key is pressed
    if ((GetKeyState(VK_CONTROL) and 128) = 128) then
    begin
      // rptB := TQTMemberReportB.Create(self);
      // rptB.RunReport;
      // rptB.Free;
    end
    else
    begin
      rptA := TQTMemberReportA.Create(self);
      rptA.RunReport();
      rptA.Free;
    end;
  except
    on E: Exception do
      // illegal date..
      ShowMessage('Error opening QualifyTimes : Session Report.');
  end;
  if BtnClose.CanFocus then
    BtnClose.SetFocus;
end;

procedure TQualifyTimes.btnNotQualifyReportClick(Sender: TObject);
var
  rptA: TQTNotQualified;
begin
  try
    begin
      rptA := TQTNotQualified.Create(self);
      rptA.RunReport();
      rptA.Free;
    end
  except
    on E: Exception do
      // illegal date..
        ShowMessage('Error opening QualifyTimes : Session Report.');
  end;
  if BtnClose.CanFocus then BtnClose.SetFocus;
end;

procedure TQualifyTimes.btnSessionReportClick(Sender: TObject);
var
  rptA: TQTSessionReportA;
begin
  try
    begin
      rptA := TQTSessionReportA.Create(self);
      rptA.RunReport();
      rptA.Free;
    end
  except
    on E: Exception do
      // illegal date..
        ShowMessage('Error opening QualifyTimes : Session Report.');
  end;
  if BtnClose.CanFocus then BtnClose.SetFocus;
end;

procedure TQualifyTimes.btnTableReportClick(Sender: TObject);
var
  rptA: TQTTableReportA;
  // rptB: TQTTableReportB;
begin
  // run qulify for session report
  try
    // control key is pressed
    if ((GetKeyState(VK_CONTROL) and 128) = 128) then
    begin
      // rptB := TQTTableReportB.Create(self);
      // rptB.RunReport;
      // rptB.Free;
    end
    else
    begin
      rptA := TQTTableReportA.Create(self);
      rptA.RunReport();
      rptA.Free;
    end;
  except
    on E: Exception do
      // illegal date..
      ShowMessage('Error opening QualifyTimes : Table Report.');
  end;
  if BtnClose.CanFocus then
    BtnClose.SetFocus;

end;

procedure TQualifyTimes.FormCreate(Sender: TObject);
var
  tabData: TTabPoolType;
  APoolTypeID: integer;
begin

  FPoolTypeID := 0;

  if not (Assigned(SCM2) and SCM2.scmConnection.Connected)  then
  raise Exception.Create('No database connection');   // or call Abort
  // Init connection ...
  try
    qryQualify.Connection := SCM2.scmConnection;
    tblQStroke.Connection := SCM2.scmConnection;
    tblTStroke.Connection := SCM2.scmConnection;
    qryTrialDist.Connection := SCM2.scmConnection;
    qryQualifyDist.Connection := SCM2.scmConnection;
    luGender.Connection := SCM2.scmConnection;
    tblPooltypes.Connection := SCM2.scmConnection;
    tblQStroke.Active;
    tblTStroke.Active;
    luGender.Active;
  except
    on E: EFDDBEngineException do
    begin
      SCM2.FDGUIxErrorDialog.Execute(E);
    end;
  end;

  // Create control tabs ...
  tabCntrl.tabs.Clear;
  tblPooltypes.Open;
  tblPooltypes.First;
  while not tblPooltypes.Eof do
  begin
    tabData := TTabPoolType.Create;
    tabData.PoolTypeID := tblPooltypes.FieldByName('PoolTypeID').AsInteger;
    tabData.Caption := tblPooltypes.FieldByName('Caption').AsString;
    tabCntrl.tabs.AddObject(tblPooltypes.FieldByName('ABREV').AsString, tabData);
    tblPooltypes.Next;
  end;
  tblPooltypes.Close;

  // Prepare GRID - initialise Queries ...
  tabCntrl.TabIndex := 0; // DEFAULT TAB = ShortCourse Olympic Standard.
  try
    tabData := TTabPoolType(tabCntrl.Tabs.Objects[tabCntrl.TabIndex]);
    APoolTypeID := tabData.PoolTypeID;
    lblCourseDescription.Caption := tabData.Caption;

    qryQualify.DisableControls;
    try
      if not qryQualify.Active then qryQualify.Open;
      qryQualify.Filter := 'PoolTypeID = ' + IntToStr(APoolTypeID);
      if not qryQualify.Filtered then qryQualify.Filtered := true;
    finally
      qryQualify.EnableControls;
    end;

    if qryQualify.Active then
    begin
      qryTrialDist.Close;
      qryTrialDist.ParamByName('POOLTYPEID').AsInteger := APoolTypeID;
      qryTrialDist.Prepare;
      qryTrialDist.Open;
      qryQualifyDist.Close;
      qryQualifyDist.ParamByName('POOLTYPEID').AsInteger := APoolTypeID;
      qryQualifyDist.Prepare;
      qryQualifyDist.Open;
    end;

  except
    on E: EFDDBEngineException do
    begin
      SCM2.FDGUIxErrorDialog.Execute(E);
    end;
  end;

  // Auto assign FPoolTypeID based on the current selected Swimming Club.
  if Assigned(CORE) and CORE.IsActive then
  begin
    var indx: integer;
    if not CORE.qrySwimClub.IsEmpty then
    begin
      APoolTypeID := CORE.qrySwimClub.FieldByName('PoolTypeID').AsInteger;
      if (APoolTypeID <> 0) then
      begin
        indx := LocatePoolTypeTab(APoolTypeID);
        if (indx <> -1) then
          FPoolTypeID := APoolTypeID; // ShowForm uses FPoolTypeID cue to TAB.
      end;
    end;
  end;

end;

procedure TQualifyTimes.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to tabCntrl.Tabs.Count - 1 do
    tabCntrl.Tabs.Objects[i].Free;  // free the TTabPoolType instance
  tabCntrl.Tabs.Clear;
  // de-activate tables ...
  qryQualify.Close;
  qryTrialDist.Close;
  qryQualifyDist.Close;
  tblQStroke.Close;
  tblTStroke.Close;
  luGender.Close;
  tblPooltypes.Close;
end;

procedure TQualifyTimes.FormShow(Sender: TObject);
var
  indx: integer;
begin
  if FPoolTypeID <> 0 then
  begin
    indx := LocatePoolTypeTab(FPoolTypeID);
    if (indx <> -1) then
    begin
      tabCntrl.TabIndex := indx;
      tabCntrlChange(tabCntrl);
    end;
  end;
end;

procedure TQualifyTimes.GridGetEditMask(Sender: TObject; ACol, ARow: LongInt;
    var Value: string);
var
  G: TDBAdvGrid;
  fld: TField;
begin
  G := TDBAdvGrid(Sender);
  fld := G.FieldAtColumn[ACol];
  if Assigned(fld) then
  begin
    if (ARow >= G.FixedRows) and (fld.FieldName = 'TrialTime') then
    begin
      Value := '!00:00.000;1;0';
    end;
  end;
end;

procedure TQualifyTimes.GridGetEditorType(Sender: TObject; ACol, ARow: Integer;
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
      if fld.FieldName = 'TrialTime' then AEditor := edNumeric;
    end;
  end;
end;

procedure TQualifyTimes.GridGetEditText(Sender: TObject; ACol, ARow: LongInt;
    var Value: string);
var
  Hour, Min, Sec, MSec: word;
  G: TDBAdvGrid;
  dt: TDateTime;
begin
  G := TDBAdvGrid(Sender);
  if (ARow >= G.FixedRows) and (G.Columns[ACol].FieldName = 'TrialTime')then
  begin
    // This method FIXES display format issues.
    dt := G.DataSource.DataSet.FieldByName('TrialTime').AsDateTime;
    DecodeTime(dt, Hour, Min, Sec, MSec);
    Value := Format('%0:2.2u:%1:2.2u.%2:3.3u', [Min, Sec, MSec]);
  end;
end;

function TQualifyTimes.LocatePoolTypeTab(PoolTypeID: integer): integer;
var
  I: Integer;
  tabData: TTabPoolType;
begin
  result := -1;
  // iterate over the tabs - examine object param PoolTypeID
  for I := 0 to (tabCntrl.Tabs.Count - 1) do
  begin
    tabData := TTabPoolType(tabCntrl.Tabs.Objects[tabCntrl.TabIndex]);
    if Assigned(tabData) then
    begin
      if (tabdata.PoolTypeID = PoolTypeID) then
        result := I;
    end;
  end;
end;

procedure TQualifyTimes.qryQualifyNewRecord(DataSet: TDataSet);
var
  tabData: TTabPoolType;
  APoolTypeID: integer;
begin
  tabData := TTabPoolType(tabCntrl.Tabs.Objects[tabCntrl.TabIndex]);
  APoolTypeID := tabData.PoolTypeID;
  DataSet.FieldByName('PoolTypeID').AsInteger := APoolTypeID;
end;

procedure TQualifyTimes.qryQualifyTrialTimeGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
var
  Hour, Min, Sec, MSec: word;
begin
  // CALLED BY TimeToBeat AND PersonalBest (Read Only fields)
  // this FIXES display format issues.
  DecodeTime(Sender.AsDateTime, Hour, Min, Sec, MSec);
  // DisplayText is true if the field's value is to be used for display only;
  // false if the string is to be used for editing the field's value.
  // "%" [index ":"] ["-"] [width] ["." prec] type
  if DisplayText then
  begin
    if (Min > 0) then Text := Format('%0:2u:%1:2.2u.%2:3.3u', [Min, Sec, MSec])
    else if ((Min = 0) and (Sec > 0)) then
        Text := Format('%1:2u.%2:3.3u', [Min, Sec, MSec])

    else if ((Min = 0) and (Sec = 0)) then Text := '';
  end
  else Text := Format('%0:2.2u:%1:2.2u.%2:3.3u', [Min, Sec, MSec]);
end;

procedure TQualifyTimes.qryQualifyTrialTimeSetText(Sender: TField;
  const Text: string);
var
  Min, Sec, MSec: word;
  s: string;
  dt: TDateTime;
  i: integer;
  failed: Boolean;
begin
  s := Text;
  failed := false;

  // Take the user input that was entered into the time mask and replace
  // spaces with '0'. Resulting in a valid TTime string.
  // UnicodeString is '1-based'
  for i := 1 to Length(s) do
  begin
    if (s[i] = ' ') then s[i] := '0';
  end;

  // SubString is '0-based'
  Min := StrToIntDef(s.SubString(0, 2), 0);
  Sec := StrToIntDef(s.SubString(3, 2), 0);
  MSec := StrToIntDef(s.SubString(6, 3), 0);
  try
    begin
      dt := EncodeTime(0, Min, Sec, MSec);
      Sender.AsDateTime := dt;
    end;
  except
    failed := true;
  end;

  if failed then Sender.Clear; // Sets the value of the field to NULL

end;

procedure TQualifyTimes.tabCntrlChange(Sender: TObject);
var
  TC: TTabControl;
  tabData: TTabPoolType;
  APoolTypeID: integer;
begin
  TC := TTabControl(Sender);
  try
    LockDrawing;
    Grid.BeginUpdate;
    qryQualify.DisableControls;

    try
      tabData := TTabPoolType(TC.Tabs.Objects[TC.TabIndex]);
      APoolTypeID := tabData.PoolTypeID;
      lblCourseDescription.Caption := tabData.Caption;

      qryQualify.Filter := 'PoolTypeID = ' + IntToStr(APoolTypeID);
      if not qryQualify.Filtered then qryQualify.Filtered := true;

      qryTrialDist.Close;
      qryTrialDist.ParamByName('POOLTYPEID').AsInteger := APoolTypeID;
      qryTrialDist.Prepare;
      qryTrialDist.Open;

      qryQualifyDist.Close;
      qryQualifyDist.ParamByName('POOLTYPEID').AsInteger := APoolTypeID;
      qryQualifyDist.Prepare;
      qryQualifyDist.Open;

    except
      on E: EFDDBEngineException do
      begin
        SCM2.FDGUIxErrorDialog.Execute(E);
      end;
    end;

  finally
    qryQualify.EnableControls;
    Grid.EndUpdate;
    UnlockDrawing;
  end;

end;

end.
