unit dmFRXRPT;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, frxClass, frxDBSet,
  dmSCM2, uSwimClub, uSession, uSettings, frxExportPDF, frxExportHTML,
  frxExportBaseDialog, frxExportXLS;

type
  TFRXRPT = class(TDataModule)
    qryEvSummary: TFDQuery;
    dsEvSummary: TfrxDBDataset;
    qryfrxSwimClub: TFDQuery;
    dsfrxSwimClub: TfrxDBDataset;
    qryfrxSession: TFDQuery;
    dsfrxSession: TfrxDBDataset;
    rptTemplate_Base: TfrxReport;
    rptEvSummary: TfrxReport;
    frxXLSExport1: TfrxXLSExport;
    frxHTMLExport1: TfrxHTMLExport;
    frxPDFExport1: TfrxPDFExport;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure RunReport_EvSummary();
  end;

var
  FRXRPT: TFRXRPT;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


procedure TFRXRPT.DataModuleCreate(Sender: TObject);
begin
  if not Assigned(SCM2) then
    raise Exception.Create('SCM2 not assigned.');
end;

procedure TFRXRPT.RunReport_EvSummary();
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
