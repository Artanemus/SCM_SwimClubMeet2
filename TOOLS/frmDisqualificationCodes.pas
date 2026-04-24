unit frmDisqualificationCodes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frxClass, frxPreview, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  // NOTE: Component TfrxGradientView requires frxGradientRTTI
  frxDBSet, frxExportBaseDialog, frxExportPDF, frxGradientRTTI,
  Vcl.ExtCtrls, dmSCM2, Vcl.StdCtrls
  ;

type
  TDisqualificationCodes = class(TForm)
    frxPreview1: TfrxPreview;
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    qryDisqualifyCode: TFDQuery;
    frxPDFExport1: TfrxPDFExport;
    Panel1: TPanel;
    btnPrintPDF: TButton;
    btnClose: TButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure btnPrintPDFClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function GetConnection: TFDConnection;
    procedure SetConnection(const Value: TFDConnection);

  public
    { Public declarations }
    fConnection: TFDConnection;

    function GetDCodeTypeSCM(): integer;
    function GetIsScratchedDCode: integer;
    function GetIsDisqualifiedDCode: integer;

    property Connection: TFDConnection read GetConnection write SetConnection;

  end;

var
  DisqualificationCodes: TDisqualificationCodes;

implementation

{$R *.dfm}

{ TForm1 }

procedure TDisqualificationCodes.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TDisqualificationCodes.btnPrintPDFClick(Sender: TObject);
begin
  frxReport1.PrepareReport;
  frxreport1.Export(frxPDFExport1);
end;

procedure TDisqualificationCodes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  qryDisqualifyCode.Close;
end;

procedure TDisqualificationCodes.FormCreate(Sender: TObject);
begin
  fConnection := nil;
end;

procedure TDisqualificationCodes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TDisqualificationCodes.FormShow(Sender: TObject);
begin
  if btnClose.CanFocus then
    btnClose.SetFocus;
end;

function TDisqualificationCodes.GetIsDisqualifiedDCode: integer;
var
s: string;
v: variant;
begin
  {-- SCM Special
    [DisqualifyCodeID], [Caption], [ABREV], [DisqualifyTypeID]
    (54, N'Unspecified disqualification. (Simplified method.)',N'ScmB',7)}
  result := 0;
  if not (Assigned(SCM2) and SCM2.scmConnection.Connected) then exit;
  s := 'SELECT [DisqualifyCodeID] FROM [dbo].[DisqualifyCode] ' +
    'WHERE [ABREV] = N''SCMB'' ';
  v := SCM2.scmConnection.ExecSQLScalar(s);
  if not VarIsNull(v) and not VarIsEmpty(v) then result := v;
end;

function TDisqualificationCodes.GetIsScratchedDCode: integer;
var
  s: string;
  v: variant;
begin
  { -- SCM Special
    [DisqualifyCodeID], [Caption], [ABREV], [DisqualifyTypeID]
    (53, N'Swimmer didn''t show for event. Scratched',N'ScmA',7) }
  result := 0;
  if not (Assigned(SCM2) and SCM2.scmConnection.Connected) then exit;
  s := ' SELECT [DisqualifyCodeID] FROM [dbo].[DisqualifyCode] ' +
    'WHERE [ABREV] = N''SCMA'' ';
  v := SCM2.scmConnection.ExecSQLScalar(s);
  if not VarIsNull(v) and not VarIsEmpty(v) then result := v;
end;

function TDisqualificationCodes.GetConnection: TFDConnection;
begin
  result := fConnection;
end;

procedure TDisqualificationCodes.SetConnection(const Value: TFDConnection);
begin
  fConnection := Value;
  qryDisqualifyCode.Connection := Value;
  qryDisqualifyCode.Open;
  if qryDisqualifyCode.Active then
    frxReport1.ShowReport;
end;

function TDisqualificationCodes.GetDCodeTypeSCM(): integer;
var
  s: string;
  v: variant;
begin
  { -- SCM Special
    [DisqualifyCodeID], [Caption], [ABREV], [DisqualifyTypeID]
    (53, N'Swimmer didn''t show for event. Scratched',N'ScmA',7) }
  result := 0;
  if not (Assigned(SCM2) and SCM2.scmConnection.Connected) then exit;
  s := ' SELECT [DisqualifyTypeID] FROM [dbo].[DisqualifyType] ' +
    'WHERE [Caption] = N''SCM'' ';
  v := SCM2.scmConnection.ExecSQLScalar(s);
  if not VarIsNull(v) and not VarIsEmpty(v) then result := v;
end;



end.
