unit rptQTDistStrokeReportA;

interface

uses
  System.SysUtils, System.Classes, dmSCM2, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  frxClass, frxDBSet, frxExportPDF, frxExportHTML, frxExportBaseDialog,
  frxExportXLS, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TQTDistStrokeReportA = class(TDataModule)
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
  QTDistStrokeReportA: TQTDistStrokeReportA;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses uSwimClub;

{ TQTDistStrokeReportA }

procedure TQTDistStrokeReportA.DataModuleCreate(Sender: TObject);
begin
  if not Assigned(SCM2) then
    raise Exception.Create('SCM2 not assigned.');
end;

procedure TQTDistStrokeReportA.RunReport;
begin
	qryReport.Connection := SCM2.scmConnection;
  qryReport.ParamByName('CLUBNAME').AsString := uSwimClub.ClubName;
  qryReport.ParamByName('CLUBNICKNAME').AsString := uSwimClub.NickName;
	qryReport.Prepare;
	qryReport.Open;
	if qryReport.Active then
		frxReport1.ShowReport;
	qryReport.Close;
end;

end.
