unit rptClub_MembersSummary;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, frxExportMail, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, frxExportXLS, frxExportPDF,
  frxClass, frxExportBaseDialog, frxExportHTML, frxDBSet;

type
  TClub_MembersSummary = class(TDataModule)
    frxReport1: TfrxReport;
    frxDSReport: TfrxDBDataset;
    frxHTMLExport1: TfrxHTMLExport;
    frxPDFExport1: TfrxPDFExport;
    frxXLSExport1: TfrxXLSExport;
    qryReport: TFDQuery;
    frxMailExport1: TfrxMailExport;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RunReport(AConnection: TFDConnection; ASwimClubID: integer);
  end;

var
  Club_MembersSummary: TClub_MembersSummary;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TMemberSummaryRpt }

procedure TClub_MembersSummary.RunReport(AConnection: TFDConnection; ASwimClubID: integer);
begin
	qryReport.Connection := AConnection;
	qryReport.ParamByName('SWIMCLUBID').AsInteger := aSwimClubID;
	qryReport.Prepare;
	qryReport.Open;
	if qryReport.Active then
		frxReport1.ShowReport();
	qryReport.Close;
end;

end.
