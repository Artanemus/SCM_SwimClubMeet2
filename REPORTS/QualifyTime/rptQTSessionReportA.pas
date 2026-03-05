unit rptQTSessionReportA;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, frxClass, frxDBSet,
  frxExportPDF, frxExportHTML, frxExportBaseDialog, frxExportXLS, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, dmSCM2;

type
  TQTSessionReportA = class(TDataModule)
    frxReport1: TfrxReport;
    qryReport: TFDQuery;
    frxXLSExport1: TfrxXLSExport;
    frxHTMLExport1: TfrxHTMLExport;
    frxPDFExport1: TfrxPDFExport;
    frxDSReport: TfrxDBDataset;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RunReport;
  end;

var
  QTSessionReportA: TQTSessionReportA;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

Uses
uSession;

procedure TQTSessionReportA.DataModuleCreate(Sender: TObject);
begin
  if not Assigned(SCM2) then
    raise Exception.Create('SCM not assigned.');
end;

procedure TQTSessionReportA.RunReport;
begin
	qryReport.Connection := SCM2.scmConnection;
	qryReport.ParamByName('SESSIONID').AsInteger := uSession.PK;
	qryReport.Prepare;
	qryReport.Open;
	if qryReport.Active then
		frxReport1.ShowReport;
	qryReport.Close;
end;

end.
