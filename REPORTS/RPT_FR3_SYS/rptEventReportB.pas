unit rptEventReportB;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, frxClass, frxDBSet,
  frxExportPDF, frxExportHTML, frxExportBaseDialog, frxExportXLS, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  dmSCM2, dmCORE, dmRPTTemplate, uSettings, uSwimClub, uSession, uReport;

type
  TEventReportB = class(TDataModule)
    frxrptEventDetailed: TfrxReport;
    qryReportB: TFDQuery;
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

//  qrySwimClub.Connection := SCM2.scmConnection;
//  qrySwimClub.ParamByName('SWIMCLUBID').AsInteger := uSwimClub.PK;
//  qrySwimClub.Prepare;
//  qrySwimClub.Open;
//
//  qrySession.Connection := SCM2.scmConnection;
//  qrySession.ParamByName('SESSIONID').AsInteger := uSession.PK;
//  qrySession.Prepare;
//  qrySession.Open;

  // Include system template for header footer.
  frxrptEventDetailed.ParentReport := uReport.GetRPTTemplatePath();
  if not frxrptEventDetailed.ParentReport.IsEmpty then
  begin
    // Ensure Template tables in dmRPT are initiated.
    if RPTTemplate.IsActive then
    begin
      if RPTTemplate.Prepare then
      begin
        // assign additional FastReports params.
        if Assigned(Settings) then
        begin
          frxrptEventDetailed.Script.Variables['EnablePrintClubLogo']
          := Settings.rpt_EnablePrintClubLogo;
        end;
      end;
    end;

  end;

  qryReportB.Connection := SCM2.scmConnection;
  qryReportB.ParamByName('SESSIONID').AsInteger := uSession.PK;
  try
    qryReportB.Prepare;
    qryReportB.Open;
    if qryReportB.Active then
    begin
      if Assigned(Settings) then
      begin
        // pass a variable
        frxrptEventDetailed.Script.Variables['EnablePrintClubLogo']
        := Settings.rpt_EnablePrintClubLogo;
        frxrptEventDetailed.ShowReport;
      end;
    end;
  except
    on E: EFDDBEngineException do
      SCM2.FDGUIxErrorDialog.Execute(E);
  end;

  qryReportB.Close;
  qrySwimClub.Close;
  qrySession.Close;

end;

end.
