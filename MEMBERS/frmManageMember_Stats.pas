unit frmManagemember_Stats;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.WinXCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, dmSCM2, Vcl.Grids, Vcl.DBGrids,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs,
  VCLTee.Chart, VCLTee.DBChart, uSwimClub, uSettings, uDefines;

type
  TManageMember_Stats = class(TForm)
    pcntrlStats: TPageControl;
    rpnlHeader: TRelativePanel;
    pnlBody: TPanel;
    pnlFooter: TPanel;
    tsMemberStats: TTabSheet;
    tsMemberChart: TTabSheet;
    tsDash: TTabSheet;
    DBTextMemberName: TDBText;
    dsPB: TDataSource;
    qryPB: TFDQuery;
    qryPBEventStr: TWideStringField;
    qryPBPB: TTimeField;
    qryPBMemberID: TFDAutoIncField;
    qryPBDistanceID: TFDAutoIncField;
    qryPBStrokeID: TFDAutoIncField;
    qryChart: TFDQuery;
    dsChart: TDataSource;
    dsEventsSwum: TDataSource;
    qryEventsSwum: TFDQuery;
    qryEventsSwumEventID: TFDAutoIncField;
    qryEventsSwumMemberID: TIntegerField;
    qryEventsSwumFName: TWideStringField;
    qryEventsSwumEventStr: TWideStringField;
    qryEventsSwumRaceTime: TTimeField;
    qryEventsSwumEventDate: TStringField;
    lblPB: TLabel;
    dbgPB: TDBGrid;
    lblEventsSwum: TLabel;
    dbgEventsSwum: TDBGrid;
    pnlChartPick: TPanel;
    Label27: TLabel;
    Label28: TLabel;
    cmboDistance: TComboBox;
    cmboStroke: TComboBox;
    chkbDoCurrSeason: TCheckBox;
    btmPrintChart: TButton;
    DBChart: TDBChart;
    Series2: TLineSeries;
    dsMember: TDataSource;
    qryMember: TFDQuery;
    qryMemberMemberID: TFDAutoIncField;
    qryMemberMembershipNum: TIntegerField;
    qryMemberMembershipStr: TWideStringField;
    qryMemberFirstName: TWideStringField;
    qryMemberLastName: TWideStringField;
    qryMemberFName: TWideStringField;
    qryMemberDOB: TSQLTimeStampField;
    qryMemberIsActive: TBooleanField;
    qryMemberIsSwimmer: TBooleanField;
    qryMemberIsArchived: TBooleanField;
    qryMemberEmail: TWideStringField;
    qryMemberCreatedOn: TSQLTimeStampField;
    qryMemberArchivedOn: TSQLTimeStampField;
    qryMemberGenderID: TIntegerField;
    qryMemberTAGS: TWideMemoField;
    tblDistance: TFDTable;
    tblStroke: TFDTable;
    btnOK: TButton;
    btnPickMember: TButton;
    qryChartRaceTimeAsString: TWideStringField;
    qryChartSeconds: TFMTBCDField;
    qryChartSessionDT: TSQLTimeStampField;
    qryChartcDistance: TWideStringField;
    qryChartcStroke: TWideStringField;
    qryChartChartX: TLargeintField;
    qryChartMemberID: TIntegerField;
    procedure chkbDoCurrSeasonClick(Sender: TObject);
    procedure cmboDistanceChange(Sender: TObject);
    procedure cmboStrokeChange(Sender: TObject);
    procedure DBChartGetLegendText(Sender: TCustomAxisPanel; LegendStyle:
        TLegendStyle; Index: Integer; var LegendText: string);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fMemberID: integer;
    fMemberChartDataPoints: Integer;
    fConnection: TFDConnection;
    fIsActive: Boolean;
    procedure ActivateMMS;
    procedure ChartReport();
    procedure ChartPrepare(aMemberID, aDistanceID, aStrokeID: integer; DoCurrSeason: boolean = true);
    procedure UpdateChart();
    function LocateChart(ChartX: Integer): Boolean;
  public
    procedure Prepare(aMemberID: Integer = 0);

    property MemberID: integer read FMemberID write FMemberID;

  protected
    procedure Msg_SCM_Connect(var Msg: TMessage); message SCM_CONNECT;

  end;

var
  ManageMember_Stats: TManageMember_Stats;

implementation

uses
  rptMemberChart, dlgMemberPicker;

{$R *.dfm}

procedure TManageMember_Stats.FormCreate(Sender: TObject);
begin
  fConnection := nil;
  fMemberID := 0;
  if Assigned(Settings) then
    fMemberChartDataPoints := Settings.MemberChartDataPoints
  else
    fMemberChartDataPoints := 26;
end;

function TManageMember_Stats.LocateChart(ChartX: Integer): Boolean;
var
  SearchOptions: TLocateOptions;
begin
  result := false;
  SearchOptions := [loPartialKey];
  try
    begin
      result := qryChart.Locate('ChartX', ChartX, SearchOptions);
    end
  except
    on E: Exception do
      // lblErrMsg.Caption := 'SCM2 DB access error.';
  end;
end;

procedure TManageMember_Stats.Msg_SCM_Connect(var Msg: TMessage);
var
  dlg: TMemberPicker;
begin
  dlg := TMemberPicker.Create(Self);
  dlg.ShowModal;
  fMemberID := dlg.MemberID;
  dlg.Free;
  UpdateChart;

end;

procedure TManageMember_Stats.Prepare(aMemberID: Integer = 0);
begin
  fMemberID := aMemberID;
  fIsActive := false;
  ActivateMMS();

  // prepare comboboxes - distance and stroke
  if fIsActive then
  begin
    tblDistance.First;
    cmboDistance.Items.Clear;
    while not tblDistance.eof do
    begin
      cmboDistance.Items.Add(tblDistance.FieldByName('Caption')
        .AsString);
      tblDistance.next;
    end;
    cmboDistance.ItemIndex := 0;

    tblStroke.First;
    cmboStroke.Items.Clear;
    while not tblStroke.eof do
    begin
      cmboStroke.Items.Add(tblStroke.FieldByName('Caption')
        .AsString);
      tblStroke.next;
    end;
    cmboStroke.ItemIndex := 0;
  end;

end;

procedure TManageMember_Stats.ActivateMMS;
begin
  fIsActive := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    qryPB.Connection := SCM2.scmConnection;
    qryChart.Connection := SCM2.scmConnection;
    qryEventsSwum.Connection := SCM2.scmConnection;
    qryMember.Connection := SCM2.scmConnection;
    tblDistance.Connection := SCM2.scmConnection;
    tblStroke.Connection := SCM2.scmConnection;
    try
      qryMember.ParamByName('MEMBERID').AsInteger := fMemberID;
      qryMember.Prepare;
      qryMember.Open;
      tblDistance.Open;
      tblStroke.Open;
      qryPB.Open;
      qryEventsSwum.Open;
      fIsActive := true;
    except
      on E: EFDDBEngineException do
        SCM2.FDGUIxErrorDialog.Execute(E);
    end;
  end;
end;

procedure TManageMember_Stats.ChartPrepare(aMemberID, aDistanceID,
  aStrokeID: integer; DoCurrSeason: boolean);
begin
  if not fIsActive then exit;
  qryChart.DisableControls;
  qryChart.Close;
  try
    qryChart.ParamByName('MEMBERID').AsInteger := aMemberID;
    qryChart.ParamByName('DISTANCEID').AsInteger := aDistanceID;
    qryChart.ParamByName('STROKEID').AsInteger := aStrokeID;
    qryChart.ParamByName('DOCURRSEASON').AsBoolean:= DoCurrSeason;
    qryChart.ParamByName('MAXRECORDS').AsInteger:= fMemberChartDataPoints;
    qryChart.Prepare;
    qryChart.Open;
  except
    on E: EFDDBEngineException do
      SCM2.FDGUIxErrorDialog.Execute(E);
  end;
  qryChart.EnableControls;
end;

procedure TManageMember_Stats.ChartReport;
var
  s, s2: string;
  rpt: TMemberChart;
begin
  // Distance
  s := cmboDistance.Text;
  // Stroke
  s2 := cmboStroke.Text;
  rpt := TMemberChart.Create(Self);
  // params ... MemberID
  rpt.RunReport(fMemberID, DBChart, s, s2);
  rpt.Free;
end;

procedure TManageMember_Stats.chkbDoCurrSeasonClick(Sender: TObject);
begin
  UpdateChart;
end;

procedure TManageMember_Stats.cmboDistanceChange(Sender: TObject);
begin
  UpdateChart;
end;

procedure TManageMember_Stats.cmboStrokeChange(Sender: TObject);
begin
  UpdateChart;
end;

procedure TManageMember_Stats.DBChartGetLegendText(Sender: TCustomAxisPanel;
    LegendStyle: TLegendStyle; Index: Integer; var LegendText: string);
var
  s: string;
  LFormatSettings: TFormatSettings;
begin
  if fIsActive then exit;
  LFormatSettings := TFormatSettings.Create;
  LocateChart((Index + 1));
  s := FormatDateTime(LFormatSettings.ShortDateFormat,
    qryChart.FieldByName('SessionDT').AsDateTime,
    LFormatSettings);
  LegendText := qryChart.FieldByName('RaceTimeAsString')
    .AsString + '  ' + s;
end;

procedure TManageMember_Stats.FormShow(Sender: TObject);
begin
  if fIsActive and (fMemberID = 0)then
  begin
    TThread.CreateAnonymousThread(
      procedure
      begin
        Sleep(250); // Wait 250ms for the form and grids to paint
        TThread.Synchronize(nil,
          procedure
          begin
            PostMessage(Handle, SCM_CONNECT, 0, 0);
          end
        );
      end
    ).Start;
  end;

end;

procedure TManageMember_Stats.UpdateChart;
var
  d, s: Integer;
  docurrseason: Boolean;
  str: string;
  fs: TFormatSettings;
begin
  fs := TFormatSettings.Create; // default locale values assigned by OS.
  // Gather UI state
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then
    exit;
  if cmboDistance.ItemIndex <> -1 then
    d := cmboDistance.ItemIndex + 1
  else
    d := 1;
  if cmboStroke.ItemIndex <> -1 then
    s := cmboStroke.ItemIndex + 1
  else
    s := 1;
  if chkbDoCurrSeason.Checked then
    docurrseason := true
  else
    docurrseason := false;
  // Requery FireDAC Chart
  ChartPrepare(fMemberID, d, s, docurrseason);
  // Chart title
  DBChart.Title.Text.Clear;
  str := qryMember.FieldByName('FName').AsString;
  str := str + ' ' + cmboDistance.Text + ' ' + cmboStroke.Text;
  if docurrseason then
    str := str + ' - Start of season' + DateToStr(uSwimClub.StartOfSwimSeason, fs);

  str := str + ' - (Max ' + IntToStr(fMemberChartDataPoints) + ' events)';
  DBChart.Title.Text.Add(str);
  // Reload chart data
  DBChart.RefreshData;
end;

end.
