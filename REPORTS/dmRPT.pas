unit dmRPT;

interface

uses
  System.SysUtils, System.Classes,

  Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,

  frxClass, frxDBSet,
  frxExportPDF, frxExportHTML, frxExportBaseDialog, frxExportXLS,

  dmSCM2, dmCORE, uSettings, uSwimClub, uSession, uEvent
  ;

type
  TRPT = class(TDataModule)
    dsEvDetailed: TfrxDBDataset;
    dsEvDetailedEx: TfrxDBDataset;
    dsEvMisc: TfrxDBDataset;
    dsEvSummary: TfrxDBDataset;
    dsfrxSession: TfrxDBDataset;
    dsfrxSwimClub: TfrxDBDataset;
    frxHTMLExport1: TfrxHTMLExport;
    frxPDFExport1: TfrxPDFExport;
    frxReportWIP: TfrxReport;
    frxXLSExport1: TfrxXLSExport;
    qryEvDetailed: TFDQuery;
    qryEvDetailedEx: TFDQuery;
    qryEvMisc: TFDQuery;
    qryEvSummary: TFDQuery;
    qryfrxSession: TFDQuery;
    qryfrxSwimClub: TFDQuery;
    rptBase_v1: TfrxReport;
    rptEvDetailed: TfrxReport;
    rptEvDetailedEx: TfrxReport;
    rptEventMisc: TfrxReport;
    rptEvSummary: TfrxReport;
    rptReport: TfrxReport;
    procedure DataModuleCreate(Sender: TObject);
  private
    FIsActive: boolean;
  public
    { Public declarations }
    procedure ActivateRPT;
    procedure DeActivateRPT;
    procedure LoadReportFromBlob(FDConnection: TFDConnection;
      const ReportID: Integer; frxReport: TfrxReport);
    procedure Prepare_EventReports;
    procedure Prepare_Template;
    procedure RunEventReport(EventReportID: Integer);
    procedure SaveReportToBlob(FDConnection: TFDConnection;
      const ReportID: Integer; frxReport: TfrxReport);
    procedure SaveReportToBlobDirect(FDConnection: TFDConnection;
      const ReportID: Integer; frxReport: TfrxReport);

    property IsActive: boolean read FIsActive write FIsActive;
  end;

var
  RPT: TRPT;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TRPT.ActivateRPT;
begin
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    qryEvSummary.Connection := SCM2.scmConnection;
    qryEvDetailed.Connection := SCM2.scmConnection;
    qryEvDetailedEx.Connection := SCM2.scmConnection;
    qryEvMisc.Connection := SCM2.scmConnection;
    FIsActive := true;
  end;
end;

procedure TRPT.DataModuleCreate(Sender: TObject);
begin
  FIsActive := false;
  if not Assigned(SCM2) then
    raise Exception.Create('SCM2 not assigned.');

end;

procedure TRPT.DeActivateRPT;
begin
  fIsActive := false;

  qryEvSummary.Close;
  qryEvDetailed.Close;
  qryEvDetailedEx.Close;
  qryEvMisc.Close;
end;

procedure TRPT.LoadReportFromBlob(FDConnection: TFDConnection;
  const ReportID: Integer; frxReport: TfrxReport);
var
  FDQuery: TFDQuery;
  Stream: TMemoryStream;
begin
  FDQuery := TFDQuery.Create(nil);
  Stream := TMemoryStream.Create;
  try
    FDQuery.Connection := FDConnection;
    FDQuery.SQL.Text := 'SELECT Blob FROM Report WHERE ReportID = :ID';
    FDQuery.ParamByName('ID').AsInteger := ReportID;
    FDQuery.Open;

    if not FDQuery.IsEmpty then
    begin
      // Extract BLOB field data into the memory stream
      TBlobField(FDQuery.FieldByName('Blob')).SaveToStream(Stream);

      // Reset stream position before loading into FastReport
      Stream.Position := 0;

      // Clear current report design and load from stream
      frxReport.Clear;
      frxReport.LoadFromStream(Stream);
    end
    else
      begin
      // error ...
      // ShowMessage('Report record not found.');
      ;
      end;

  finally
    Stream.Free;
    FDQuery.Free;
  end;
end;

procedure TRPT.Prepare_EventReports;
begin
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    try
      // summary of all events in current selected session. (BASIC)
      if qryEvSummary.Active then qryEvSummary.Close;
      qryEvSummary.ParamByName('SESSIONID').AsInteger := uSession.PK;
      qryEvSummary.Prepare;
      qryEvSummary.Open;

      // Details of a SINGLE event (Swimmer, Lane, RaceTime, etc.)
      if qryEvDetailed.Active then qryEvDetailed.Close;
      qryEvDetailed.ParamByName('EVENTID').AsInteger := uEvent.PK;
      qryEvDetailed.Prepare;
      qryEvDetailed.Open;

      // Same as Detailed but lists every event in session. (COMPLEX)
      if qryEvDetailedEx.Active then qryEvDetailedEx.Close;
      qryEvDetailedEx.ParamByName('SESSIONID').AsInteger := uSession.PK;
      qryEvDetailedEx.Prepare;
      qryEvDetailedEx.Open;

      // Based on an EVENTID query that returns every field.
      if qryEvMisc.Active then qryEvMisc.Close;
      qryEvMisc.ParamByName('EVENTID').AsInteger := uEvent.PK;
      qryEvMisc.Prepare;
      qryEvMisc.Open;

    except
      on E: EFDDBEngineException do
        SCM2.FDGUIxErrorDialog.Execute(E);
    end;
  end;
end;

procedure TRPT.Prepare_Template;
begin
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    try
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
    except
      on E: EFDDBEngineException do
        SCM2.FDGUIxErrorDialog.Execute(E);
    end;
  end;
end;

procedure TRPT.RunEventReport(EventReportID: Integer);
begin
  {   }
  Prepare_Template; // Template header/footer (LOGO, PageNum, PrintDate).
  Prepare_EventReports; // Opens ALL 'Event Query' types after a prama reassign.
  try
    LoadReportFromBlob(SCM2.scmConnection, EventReportID, rptReport);
    if Assigned(Settings) then
    begin
      rptReport.Script.Variables['EnablePrintClubLogo']
      := Settings.rpt_EnablePrintClubLogo;
      rptReport.ShowReport;
    end;
  except
    on E: EFDDBEngineException do
      SCM2.FDGUIxErrorDialog.Execute(E);
  end;

  qryEvSummary.Close;
  qryfrxSwimClub.Close;
  qryfrxSession.Close;

end;

procedure TRPT.SaveReportToBlob(FDConnection: TFDConnection;
  const ReportID: Integer; frxReport: TfrxReport);
var
  FDQuery: TFDQuery;
  Stream: TMemoryStream;
begin
  FDQuery := TFDQuery.Create(nil);
  Stream := TMemoryStream.Create;
  try
    // Save report design to stream
    frxReport.SaveToStream(Stream);
    Stream.Position := 0;

    FDQuery.Connection := FDConnection;
    FDQuery.SQL.Text := 'SELECT ReportID, Blob FROM Report WHERE ReportID = :ID';
    FDQuery.ParamByName('ID').AsInteger := ReportID;
    FDQuery.Open;

    if not FDQuery.IsEmpty then
    begin
      FDQuery.Edit;
      TBlobField(FDQuery.FieldByName('Blob')).LoadFromStream(Stream);
      FDQuery.Post;
    end;
  finally
    Stream.Free;
    FDQuery.Free;
  end;
end;

procedure TRPT.SaveReportToBlobDirect(FDConnection: TFDConnection;
  const ReportID: Integer; frxReport: TfrxReport);
var
  FDQuery: TFDQuery;
  Stream: TMemoryStream;
begin
  FDQuery := TFDQuery.Create(nil);
  Stream := TMemoryStream.Create;
  try
    // Save report layout into memory stream
    frxReport.SaveToStream(Stream);
    Stream.Position := 0;

    FDQuery.Connection := FDConnection;
    FDQuery.SQL.Text := 'UPDATE Report SET Blob = :Blob WHERE ReportID = :ID';
    FDQuery.ParamByName('ID').AsInteger := ReportID;
    FDQuery.ParamByName('Blob').LoadFromStream(Stream, ftBlob);
    FDQuery.ExecSQL;
  finally
    Stream.Free;
    FDQuery.Free;
  end;
end;

end.

