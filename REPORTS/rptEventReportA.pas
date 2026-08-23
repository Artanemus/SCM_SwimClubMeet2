unit rptEventReportA;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, frxClass, frxDBSet,
  frxExportPDF, frxExportHTML, frxExportBaseDialog, frxExportXLS, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  dmSCM2, dmCORE, uSettings, uSwimClub, uSession;

type
  TEventReportA = class(TDataModule)
    frxrptEventSummary: TfrxReport;
    qryReport: TFDQuery;
    frxXLSExport1: TfrxXLSExport;
    frxHTMLExport1: TfrxHTMLExport;
    frxPDFExport1: TfrxPDFExport;
    frxdsReport: TfrxDBDataset;
    qrySwimClub: TFDQuery;
    frxdsSwimClub: TfrxDBDataset;
    qrySession: TFDQuery;
    frxdsSession: TfrxDBDataset;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RunReport;
  end;

var
  EventReportA: TEventReportA;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TEventReportA.DataModuleCreate(Sender: TObject);
begin
  if not Assigned(SCM2) then
    raise Exception.Create('SCM2 not assigned.');
end;

procedure TEventReportA.RunReport;
begin

  qrySwimClub.Connection := SCM2.scmConnection;
  qrySwimClub.ParamByName('SWIMCLUBID').AsInteger := uSwimClub.PK;
  qrySwimClub.Prepare;
  qrySwimClub.Open;

  qrySession.Connection := SCM2.scmConnection;
  qrySession.ParamByName('SESSIONID').AsInteger := uSession.PK;
  qrySession.Prepare;
  qrySession.Open;

  qryReport.Connection := SCM2.scmConnection;
  qryReport.ParamByName('SESSIONID').AsInteger := uSession.PK;
  try
    qryReport.Prepare;
    qryReport.Open;
    if qryReport.Active then
    begin
      if Assigned(Settings) then
      begin
        // pass a variable
        frxrptEventSummary.Script.Variables['EnablePrintClubLogo']
        := Settings.rpt_EnablePrintClubLogo;
        frxrptEventSummary.ShowReport;
      end;
    end;
  except
    on E: EFDDBEngineException do
      SCM2.FDGUIxErrorDialog.Execute(E);
  end;

  qryReport.Close;
  qrySwimClub.Close;
  qrySession.Close;

end;

end.

