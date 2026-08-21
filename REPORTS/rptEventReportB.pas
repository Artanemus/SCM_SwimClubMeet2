unit rptEventReportB;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, frxClass, frxDBSet,
  frxExportPDF, frxExportHTML, frxExportBaseDialog, frxExportXLS, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  dmSCM2, uSwimClub, uEvent;

type
  TEventReportB = class(TDataModule)
    frxrptEventDetailed: TfrxReport;
    qryReport: TFDQuery;
    frxXLSExport1: TfrxXLSExport;
    frxHTMLExport1: TfrxHTMLExport;
    frxPDFExport1: TfrxPDFExport;
    frxdsReport: TfrxDBDataset;
    qrySwimClub: TFDQuery;
    frxdsSwimClub: TfrxDBDataset;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RunReport();
  end;

var
  EventReportB: TEventReportB;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TEventReportB.DataModuleCreate(Sender: TObject);
begin
	if not Assigned(SCM2) then
    raise exception.Create('SCM2 not assigned.');
end;

procedure TEventReportB.RunReport;
begin
	qrySwimClub.Connection := SCM2.scmConnection;
	qrySwimClub.ParamByName('SWIMCLUBID').AsInteger := uSwimClub.PK;
	qrySwimClub.Prepare;
	qrySwimClub.Open;

	qryReport.Connection := SCM2.scmConnection;
	qryReport.ParamByName('EVENTID').AsInteger := uEvent.PK;
	qryReport.Prepare;
	qryReport.Open;
	if qryReport.Active then
		frxrptEventDetailed.ShowReport;
	qryReport.Close
end;

end.
