unit dmRPT;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, frxClass, frxDBSet,
  frxExportPDF, frxExportHTML, frxExportBaseDialog, frxExportXLS, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  dmSCM2, dmCORE, uSettings, uSwimClub, uSession;

type
  TRPT = class(TDataModule)
    rptEvSummary: TfrxReport;
    qryEvSummary: TFDQuery;
    frxXLSExport1: TfrxXLSExport;
    frxHTMLExport1: TfrxHTMLExport;
    frxPDFExport1: TfrxPDFExport;
    dsEvSummary: TfrxDBDataset;
    qryfrxSwimClub: TFDQuery;
    dsfrxSwimClub: TfrxDBDataset;
    qryfrxSession: TFDQuery;
    dsfrxSession: TfrxDBDataset;
    rptEvDetailed: TfrxReport;
    rptEventMisc: TfrxReport;
    rptEvDetailedEx: TfrxReport;
    qryEvDetailed: TFDQuery;
    dsEvDetailed: TfrxDBDataset;
    qryEvMisc: TFDQuery;
    dsEvMisc: TfrxDBDataset;
    rptTemplate_Base: TfrxReport;
    qryEvDetailedEx: TFDQuery;
    dsEvDetailedEx: TfrxDBDataset;
    frxReportWIP: TfrxReport;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RunReport_EvSummary();
  end;

var
  RPT: TRPT;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TRPT.DataModuleCreate(Sender: TObject);
begin
  if not Assigned(SCM2) then
    raise Exception.Create('SCM2 not assigned.');
end;

procedure TRPT.RunReport_EvSummary();
begin
  if not Assigned(SCM2) then
  // used by TemplateBase.fr3
  qryfrxSwimClub.Connection := SCM2.scmConnection;
  qryfrxSwimClub.ParamByName('SWIMCLUBID').AsInteger := uSwimClub.PK;
  qryfrxSwimClub.Prepare;
  qryfrxSwimClub.Open;
  // used by TemplateBase.fr3
  qryfrxSession.Connection := SCM2.scmConnection;
  qryfrxSession.ParamByName('SESSIONID').AsInteger := uSession.PK;
  qryfrxSession.Prepare;
  qryfrxSession.Open;
  // summary of all events in current selected session.
  qryEvSummary.Connection := SCM2.scmConnection;
  qryEvSummary.ParamByName('SESSIONID').AsInteger := uSession.PK;
  try
    qryEvSummary.Prepare;
    qryEvSummary.Open;
    if qryEvSummary.Active then
    begin
      if Assigned(Settings) then
      begin
        // Bring header (with LOGO) and Footer (Page, printdate).
//        rptEvSummary.InheritFromTemplate('Template_Base.fr3');
        // pass a variable - print LOGO?/
        rptEvSummary.Script.Variables['EnablePrintClubLogo']
        := Settings.rpt_EnablePrintClubLogo;

        rptEvSummary.ShowReport;
      end;
    end;
  except
    on E: EFDDBEngineException do
      SCM2.FDGUIxErrorDialog.Execute(E);
  end;

  qryEvSummary.Close;
  qryfrxSwimClub.Close;
  qryfrxSession.Close;

end;

end.

