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
  AdvGrid, DBAdvGrid, Vcl.DBCtrls;

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
    luTrialDist: TFDTable;
    luQualifyDist: TFDTable;
    luStroke: TFDTable;
    luGender: TFDTable;
    tabCntrl: TTabControl;
    lblCourseDescription: TLabel;
    Grid: TDBAdvGrid;
    qryQualifyPoolTypeStr: TWideStringField;
    DBTextPoolTypeStr: TDBText;
    tblPoolTypes: TFDTable;
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
    procedure tabCntrlChange(Sender: TObject);
  private
    { Private declarations }
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
  obj: TFields;
  fld: TField;
begin
  if not (Assigned(SCM2) and SCM2.scmConnection.Connected)  then
  raise Exception.Create('No database connection');   // or call Abort

  try
    qryQualify.Connection := SCM2.scmConnection;
    luStroke.Connection := SCM2.scmConnection;
    luTrialDist.Connection := SCM2.scmConnection;
    luQualifyDist.Connection := SCM2.scmConnection;
    luGender.Connection := SCM2.scmConnection;
    tblPooltypes.Connection := SCM2.scmConnection;

    luStroke.Active;
    luTrialDist.Active;
    luQualifyDist.Active;
    luGender.Active;
    luTrialDist.Active;

  except
    on E: EFDDBEngineException do
    begin
      SCM2.FDGUIxErrorDialog.Execute(E);
    end;
  end;


  // create the tabs
  tabCntrl.tabs.Clear;
  tblPooltypes.Open;
  tblPooltypes.First;
  while not tblPooltypes.Eof do
  begin
    obj := tblPooltypes.Fields;
    tabCntrl.tabs.AddObject(tblPooltypes.FieldByName('ABREV').AsString, obj);
    tblPooltypes.Next;
  end;
  tblPooltypes.First;
  tabCntrl.TabIndex := 0;

  try
    obj := TFields(tabCntrl.tabs.Objects[tabCntrl.TabIndex]);
    fld := obj.FieldByName('PoolTypeID');
    qryQualify.ParamByName('POOLTYPEID').AsInteger := fld.AsInteger;
    qryQualify.Prepare();
    qryQualify.Open();
  except
    on E: EFDDBEngineException do
    begin
      SCM2.FDGUIxErrorDialog.Execute(E);
    end;
  end;



end;

procedure TQualifyTimes.FormDestroy(Sender: TObject);
begin
  tabCntrl.tabs.Clear;
  qryQualify.Close;
  tblPooltypes.Close;
end;

procedure TQualifyTimes.qryQualifyTrialTimeGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
var
  Hour: word; // unsigned short: Word ;
  Min: word; // unsigned short: Word ;
  Sec: word;
  MSec: word;
begin
  DecodeTime(Sender.AsDateTime, Hour, Min, Sec, MSec);
  // DisplayText is true if the field's value is to be used for display only;
  // false if the string is to be used for editing the field's value.
  if (DisplayText) then
  begin
    // "%" [index ":"] ["-"] [width] ["." prec] type
    if (Min > 0) then
      Text := Format('%0:2u:%1:2.2u.%2:3.3u', [Min, Sec, MSec])
    else if ((Min = 0) and (Sec > 0)) then
      Text := Format('%1:2u.%2:3.3u', [Min, Sec, MSec])
    else if ((Min = 0) and (Sec = 0)) then
      Text := '';
  end
  else
    // "%" [index ":"] ["-"] [width] ["." prec] type
    Text := Format('%0:2.2u:%1:2.2u.%2:3.3u', [Min, Sec, MSec]);
end;

procedure TQualifyTimes.qryQualifyTrialTimeSetText(Sender: TField;
  const Text: string);
var
  s: String;
  dt: TDateTime;
  Min, Sec, MSec: word;
  i: integer;
  failed: Boolean;
begin

  failed := false;

  // Take the user input that was entered into the time mask and replace
  // spaces with '0'. Resulting in a valid TTime string.
  // UnicodeString is '1-based'

  s := Text;
  for i := 1 to s.Length - 1 do
    if (s[i] = ' ') then
      s[i] := '0';

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

  // set the racetime to nil.
  if failed then
    Sender.Clear; // Sets the value of the field to NULL

end;

procedure TQualifyTimes.tabCntrlChange(Sender: TObject);
var
  TC: TTabControl;
  obj: TFields;
  fld: TField;
begin
  TC := TTabControl(Sender);

  try
    LockDrawing;
    Grid.BeginUpdate;
    qryQualify.DisableControls;

    try
      obj := TFields(TC.tabs.Objects[tabCntrl.TabIndex]);
      fld := obj.FieldByName('PoolTypeID');
      qryQualify.Close();
      qryQualify.ParamByName('POOLTYPEID').AsInteger := fld.AsInteger;
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
