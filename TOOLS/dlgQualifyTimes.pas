unit dlgQualifyTimes;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,


  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, dmSCM2, AdvUtil, AdvObj, BaseGrid,
  AdvGrid, DBAdvGrid, Vcl.DBCtrls, Vcl.Buttons;

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
    Panel2: TPanel;
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
    DBTextPoolTypeStr: TDBText;
    tblPoolTypes: TFDTable;
    qryTrialDist: TFDQuery;
    qryQualifyDist: TFDQuery;
    tblTStroke: TFDTable;
    qryQualifyTrialStrokeID: TIntegerField;
    qryQualifyluTStroke: TStringField;
    lblTrialStroke: TLabel;
    navGrid: TDBNavigator;
    qryQualifyLaps: TFloatField;
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
    procedure GridGetEditMask(Sender: TObject; ACol, ARow: LongInt; var Value:
        string);
    procedure GridGetEditorType(Sender: TObject; ACol, ARow: Integer; var AEditor:
        TEditorType);
    procedure GridGetEditText(Sender: TObject; ACol, ARow: LongInt; var Value:
        string);
    procedure qryQualifyBeforePost(DataSet: TDataSet);
    procedure tabCntrlChange(Sender: TObject);
  private
    { ... }
  public
    { Public declarations }
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
  // initialise FD Queries ...
  // tblPooltypes.First;
  tabCntrl.TabIndex := 1;
  try
    tabData := TTabPoolType(tabCntrl.Tabs.Objects[tabCntrl.TabIndex]);
    APoolTypeID := tabData.PoolTypeID;
    qryTrialDist.Close;
    qryTrialDist.ParamByName('POOLTYPEID').AsInteger := APoolTypeID;
    qryTrialDist.Prepare;
    qryTrialDist.Open;
    qryQualifyDist.Close;
    qryQualifyDist.ParamByName('POOLTYPEID').AsInteger := APoolTypeID;
    qryQualifyDist.Prepare;
    qryQualifyDist.Open;
    qryQualify.Close;
    qryQualify.ParamByName('POOLTYPEID').AsInteger := APoolTypeID;
    qryQualify.Prepare();
    qryQualify.Open();
    lblCourseDescription.Caption := tabData.Caption;
  except
    on E: EFDDBEngineException do
    begin
      SCM2.FDGUIxErrorDialog.Execute(E);
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

procedure TQualifyTimes.qryQualifyBeforePost(DataSet: TDataSet);
var
  tabData: TTabPoolType;
  APoolTypeID: integer;
begin
  if DataSet.FieldByName('PoolTypeID').IsNull then
  begin
    tabData := TTabPoolType(tabCntrl.Tabs.Objects[tabCntrl.TabIndex]);
    APoolTypeID := tabData.PoolTypeID;
    DataSet.FieldByName('PoolTypeID').AsInteger := APoolTypeID;
  end;
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

      qryTrialDist.Close;
      qryTrialDist.ParamByName('POOLTYPEID').AsInteger := APoolTypeID;
      qryTrialDist.Prepare;
      qryTrialDist.Open;

      qryQualifyDist.Close;
      qryQualifyDist.ParamByName('POOLTYPEID').AsInteger := APoolTypeID;
      qryQualifyDist.Prepare;
      qryQualifyDist.Open;


      qryQualify.Close();
      qryQualify.ParamByName('POOLTYPEID').AsInteger := APoolTypeID;
      qryQualify.Prepare();
      qryQualify.Open();
    except
      on E: EFDDBEngineException do
      begin
        SCM2.FDGUIxErrorDialog.Execute(E);
      end;
    end;

    // fld := obj.FieldByName('Caption');


  finally
    qryQualify.EnableControls;
    Grid.EndUpdate;
    UnlockDrawing;
  end;

end;

end.
