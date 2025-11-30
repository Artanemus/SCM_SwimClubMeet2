unit dlgSwimClub_Reports;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,

  dmSCM2,
  dmCORE;

type
  TSwimClub_Reports = class(TForm)
    btnClubMembersSummary: TButton;
    btnClubMembersList: TButton;
    btnClubMembersDetailed: TButton;
    Label20: TLabel;
    Label9: TLabel;
    Label17: TLabel;
    Label16: TLabel;
    pnlFooter: TPanel;
    btnClose: TButton;
    btnClub_Dashboard: TButton;
    lblDashboard: TLabel;
    procedure btnClubMembersDetailedClick(Sender: TObject);
    procedure btnClubMembersListClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnClubMembersSummaryClick(Sender: TObject);
  private
    fSwimClubID: integer;
  public
   property SwimClubID: integer read FSwimClubID write FSwimClubID;
  end;

var
  SwimClub_Reports: TSwimClub_Reports;

implementation

uses
  rptClub_MembersSummary, rptClub_MembersDetail, rptClub_MembersList;

{$R *.dfm}

procedure TSwimClub_Reports.btnClubMembersDetailedClick(Sender: TObject);
var
  rpt: TClub_MembersDetail;
begin
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then
    exit;
  if not CORE.IsActive then
    exit;
  rpt := TClub_MembersDetail.Create(Self);
  rpt.RunReport(SCM2.scmConnection, fSwimClubID);
  rpt.Free;
end;

procedure TSwimClub_Reports.btnClubMembersListClick(Sender: TObject);
var
  rpt: TClub_MembersList;
begin
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then
    exit;
  if not CORE.IsActive then
    exit;
  rpt := TClub_MembersList.Create(Self);
  rpt.RunReport(SCM2.scmConnection, fSwimClubID);
  rpt.Free;
end;

procedure TSwimClub_Reports.FormCreate(Sender: TObject);
begin
  fSwimClubID := 0;
end;

procedure TSwimClub_Reports.btnClubMembersSummaryClick(Sender: TObject);
var
  rpt: TClub_MembersSummary;
begin
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then
    exit;
  if not CORE.IsActive then
    exit;
  rpt := TClub_MembersSummary.Create(Self);
  rpt.RunReport(SCM2.scmConnection, fSwimClubID);
  rpt.Free;
end;


end.
