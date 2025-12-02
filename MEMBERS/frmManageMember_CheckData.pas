unit frmManageMember_CheckData;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, dmCORE, dmSCM2;

type
  TManageMember_CheckData = class(TForm)
    pnlDataCheck: TPanel;
    lblDataCheck: TLabel;
    DBGrid2: TDBGrid;
    GridPanel1: TGridPanel;
    btnFirstName: TButton;
    btnLastName: TButton;
    btnGender: TButton;
    btnDOB: TButton;
    btnSwimmingClub: TButton;
    btnBooleanNulls: TButton;
    btnMembershipNum: TButton;
    btnCheckDataReport: TButton;
    Panel4: TPanel;
    qryDataCheck: TFDQuery;
    qryDataCheckMemberID: TIntegerField;
    qryDataCheckMSG: TStringField;
    dsDataCheck: TDataSource;
    qryDataCheckPart: TFDQuery;
    dsDataCheckPart: TDataSource;
    cmdFixNullBooleans: TFDCommand;
    procedure FormCreate(Sender: TObject);
    procedure btnCheckDataClick(Sender: TObject);
    procedure btnCheckDataReportClick(Sender: TObject);
  private
    fMemberID: integer;
    procedure DataCheckPart(PartNumber: integer);
  public
    property MemberID: integer read FMemberID write FMemberID;
  end;

var
  ManageMember_CheckData: TManageMember_CheckData;

implementation

uses
  rptMemberCheckData;

{$R *.dfm}

procedure TManageMember_CheckData.FormCreate(Sender: TObject);
begin
  fMemberID := 0;
end;

procedure TManageMember_CheckData.btnCheckDataClick(Sender: TObject);
begin
  if assigned(CORE) and CORE.IsActive then
  begin
    DataCheckPart(TButton(Sender).Tag);
    if dsDataCheckPart.Enabled then
    begin
      if dsDataCheckPart.DataSet.IsEmpty then
        Panel4.Caption := TButton(Sender).Caption + ' - NO ERRORS'
      else
        Panel4.Caption := TButton(Sender).Caption + ' - ' +
          IntToStr(dsDataCheckPart.DataSet.RecordCount) +
          ' ERRORS';
    end
    else
      Panel4.Caption := 'DATA CHECK FAILED.';
  end;end;

procedure TManageMember_CheckData.btnCheckDataReportClick(Sender: TObject);
var
  rpt: TMemberCheckData;
begin
  if not assigned(CORE) or not CORE.IsActive then
    exit;
  rpt := TMemberCheckData.Create(Self);
  rpt.RunReport(SCM2.scmConnection);
  rpt.Free;
end;

procedure TManageMember_CheckData.DataCheckPart(PartNumber: integer);
var
  SQL: string;
begin
  if qryDataCheckPart.Active then
    qryDataCheckPart.Close;
  dsDataCheckPart.Enabled := false;

  case PartNumber of
    1: // FirstName
      begin
        SQL := 'SELECT[MemberID], ''No first-name.'' as MSG' + sLineBreak +
          'FROM [SwimClubMeet2].[dbo].[Member]' + sLineBreak +
          'WHERE firstname IS NULL AND' + sLineBreak +
          'ORDER BY MemberID DESC;';
      end;
    2:
      begin
        SQL := SQL +
          'SELECT[MemberID], ''No last-name.'' as MSG' + sLineBreak +
          'FROM [SwimClubMeet2].[dbo].[Member]' + sLineBreak +
          'WHERE lastname IS NULL AND' + sLineBreak +
          'ORDER BY MemberID DESC;';
      end;
     3:
     begin
        SQL := SQL +
          'SELECT[MemberID], ''Gender not given.'' as MSG' + sLineBreak +
          'FROM [SwimClubMeet2].[dbo].[Member]' + sLineBreak +
          'WHERE genderID IS NULL AND' + sLineBreak +
          'ORDER BY MemberID DESC;';
     end;
     4:
     begin
        SQL := SQL +
          'SELECT[MemberID], ''No date of birth.'' as MSG' + sLineBreak +
          'FROM [SwimClubMeet2].[dbo].[Member]' + sLineBreak +
          'WHERE DOB IS NULL AND' + sLineBreak +
          'ORDER BY MemberID DESC;';
     end;
     5:
     begin
       SQL := SQL +
          'SELECT[MemberID], ''Swimming Club not assigned.'' as MSG' + sLineBreak +
          'FROM [SwimClubMeet2].[dbo].[Member]' + sLineBreak +
          'WHERE SwimClubID IS NULL AND' + sLineBreak +
          'ORDER BY MemberID DESC;';
     end;
     6:
     begin
       SQL := SQL +
          'SELECT[MemberID], ''IsArchived, IsActive, IsSwimmer?'' as MSG' + sLineBreak +
          'FROM [SwimClubMeet2].[dbo].[Member]' + sLineBreak +
          'WHERE IsArchived IS NULL OR IsActive IS NULL OR IsSwimmer IS NULL AND' + sLineBreak +
          'ORDER BY MemberID DESC;';
     end;
     7:
     begin
       SQL := SQL +
          'SELECT[MemberID], ''No Membership number.'' as MSG' + sLineBreak +
          'FROM [SwimClubMeet2].[dbo].[Member]' + sLineBreak +
          'WHERE MemberShipNum IS NULL AND' + sLineBreak +
          'ORDER BY MemberID DESC;';
     end;
  end;

  qryDataCheckPart.SQL.Text := SQL;
  qryDataCheckPart.Prepare;
  qryDataCheckPart.Open;
  if qryDataCheckPart.Active then
    dsDataCheckPart.Enabled := true;
end;
end.
