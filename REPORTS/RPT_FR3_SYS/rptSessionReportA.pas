unit rptSessionReportA;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, frxClass, frxDBSet,
  frxExportPDF, frxExportHTML, frxExportBaseDialog, frxExportXLS, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  dmSCM2, uSwimClub, uSession;

type
  TSessionReportA = class(TDataModule)
    frxXLSExport1: TfrxXLSExport;
    frxHTMLExport1: TfrxHTMLExport;
    frxPDFExport1: TfrxPDFExport;
    qryClubInfo: TFDQuery;
    frxClubInfo: TfrxDBDataset;
    qrySession: TFDQuery;
    qryEvent: TFDQuery;
    dsSession: TDataSource;
    dsEvent: TDataSource;
    dsHeat: TDataSource;
    qryHeat: TFDQuery;
    frxdsSession: TfrxDBDataset;
    frxdsEvent: TfrxDBDataset;
    frxdsHeat: TfrxDBDataset;
    qryEntrant: TFDQuery;
    dsEntrant: TDataSource;
    frxdsEntrant: TfrxDBDataset;
    frxReport2: TfrxReport;
    qryTEAM: TFDQuery;
    dsTEAM: TDataSource;
    frxdsTEAM: TfrxDBDataset;
    qryTeamEntrant: TFDQuery;
    dsTeamEntrant: TDataSource;
    frxdsTeamEntrant: TfrxDBDataset;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RunReport;
  end;

var
  SessionReportA: TSessionReportA;

implementation


{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TSessionReportA.DataModuleDestroy(Sender: TObject);
begin
    qryClubInfo.Close;
    qrySession.Close;
    qryEvent.Close;
    qryHeat.Close;
    qryEntrant.Close;
    qryTEAM.Close;
    qryTeamEntrant.Close;
end;

procedure TSessionReportA.DataModuleCreate(Sender: TObject);
begin
  if not Assigned(SCM2) then
    raise Exception.Create('SCM data module not assigned.');
end;

procedure TSessionReportA.RunReport;
var
  aSessionID: integer;
  aSessionDT: TDateTime;
  aSwimClubID: integer;
begin

  qryClubInfo.Connection := SCM2.scmConnection;
  qrySession.Connection := SCM2.scmConnection;
  qryEvent.Connection := SCM2.scmConnection;
  qryHeat.Connection := SCM2.scmConnection;
  qryEntrant.Connection := SCM2.scmConnection;
  qryTEAM.Connection := SCM2.scmConnection;
  qryTeamEntrant.Connection := SCM2.scmConnection;

  aSessionID := uSession.PK;
  aSessionDT := uSession.SessionDT;
  aSwimClubID := uSwimClub.PK;

  if (aSessionID > 0) then
  begin
    // HEADER BANNER DATA
    qryClubInfo.Close;
    qryClubInfo.ParamByName('SWIMCLUBID').AsInteger := aSwimClubID;
    qryClubInfo.Prepare;
    qryClubInfo.Open;

    // SESSION REPORT
    qrySession.Close;
    qrySession.ParamByName('SESSIONID').AsInteger := aSessionID;
    qrySession.Prepare;
    qrySession.Open;

    qryEvent.Open;
    qryHeat.Open;

    // CALCULATE AGE
    qryEntrant.Close;
    qryEntrant.ParamByName('SESSIONDATE').AsDateTime := aSessionDT;
    qryEntrant.Prepare;
    qryEntrant.Open;

    qryTEAM.Open;

    // CALCULATE AGE
    qryTeamEntrant.Close;
    qryTeamEntrant.ParamByName('SESSIONDATE').AsDateTime := aSessionDT;
    qryTeamEntrant.Prepare;
    qryTeamEntrant.Open;


    if qrySession.Active then
      frxReport2.ShowReport();

    qryClubInfo.Close;
    qrySession.Close;
    qryEvent.Close;
    qryHeat.Close;
    qryEntrant.Close;
    qryTEAM.Close;
    qryTeamEntrant.Close;

  end;
end;

end.
