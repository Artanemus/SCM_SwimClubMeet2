program SwimClubMeet2;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  XSuperJSON in 'JSON\XSuperJSON.pas',
  XSuperObject in 'JSON\XSuperObject.pas',
  uUtility in 'TOOLS\uUtility.pas',
  dmSCM2 in 'DATA\dmSCM2.pas' {SCM2: TDataModule},
  dmCORE in 'DATA\dmCORE.pas' {CORE: TDataModule},
  dmIMG in 'DATA\dmIMG.pas' {IMG: TDataModule},
  dmMM_CORE in 'MEMBERS\dmMM_CORE.pas' {MM_CORE: TDataModule},
  dmMMD_House in 'MEMBERS\dmMMD_House.pas' {MemberHouse: TDataModule},
  uDefines in 'DATA\uDefines.pas',
  uSettings in 'DATA\uSettings.pas',
  uSwimClub in 'DATA_Helper\uSwimClub.pas',
  uSession in 'DATA_Helper\uSession.pas',
  uEvent in 'DATA_Helper\uEvent.pas',
  uNominee in 'DATA_Helper\uNominee.pas',
  frFrameSession in 'FRAMES\frFrameSession.pas' {FrameSession: TFrame},
  frFrameEvent in 'FRAMES\frFrameEvent.pas' {FrameEvent: TFrame},
  frFrameClubGroup in 'FRAMES\frFrameClubGroup.pas' {FrameClubGroup: TFrame},
  frFrameNominate in 'FRAMES\frFrameNominate.pas' {FrameNominate: TFrame},
  frFrameFilterMember in 'FRAMES\frFrameFilterMember.pas' {FrameFilterMember: TFrame},
  frmMain2 in 'frmMain2.pas' {Main2},
  SCMSimpleConnect in 'TOOLS\SCMSimpleConnect.pas',
  frmMM_Stats in 'MEMBERS\frmMM_Stats.pas' {ManageMember_Stats},
  frmMM_CheckData in 'MEMBERS\frmMM_CheckData.pas' {ManageMember_CheckData},
  frmManageMember in 'MEMBERS\frmManageMember.pas' {ManageMember},
  dlgSwimClub_Switch in 'DIALOGS\SwimClub\dlgSwimClub_Switch.pas' {SwimClubSwitch},
  dlgLogin in 'DIALOGS\dlgLogin.pas' {Login},
  dlgSwimClubGroup_View in 'DIALOGS\SwimClub\dlgSwimClubGroup_View.pas' {SwimClubGroup_View},
  dlgEditSession in 'DIALOGS\Session\dlgEditSession.pas' {EditSession},
  dlgscmDatePicker in 'DIALOGS\Picker\dlgscmDatePicker.pas' {scmDatePicker},
  dlgNewSession in 'DIALOGS\Session\dlgNewSession.pas' {NewSession},
  dlgSwimClub_Manage in 'DIALOGS\SwimClub\dlgSwimClub_Manage.pas' {SwimClubManage},
  dlgPreferences in 'TOOLS\dlgPreferences.pas' {Preferences},
  dlgMM_Delete in 'MEMBERS\dlgMM_Delete.pas' {MM_Delete},
  dlgMM_Find_FName in 'MEMBERS\dlgMM_Find_FName.pas' {FindMember_FName},
  dlgMM_Find_ID in 'MEMBERS\dlgMM_Find_ID.pas' {FindMember_ID},
  dlgMM_Find_Membership in 'MEMBERS\dlgMM_Find_Membership.pas' {FindMember_Membership},
  dlgMM_FilterBySwimClub in 'MEMBERS\dlgMM_FilterBySwimClub.pas' {MM_FilterBySwimClub},
  dlgMM_FilterByParam in 'MEMBERS\dlgMM_FilterByParam.pas' {MM_FilterByParam},
  dlgMM_About in 'MEMBERS\dlgMM_About.pas' {MM_About},
  dlgSwimClubPicker in 'DIALOGS\Picker\dlgSwimClubPicker.pas' {SwimClubPicker},
  dlgSwimClub_Reports in 'DIALOGS\SwimClub\dlgSwimClub_Reports.pas' {SwimClub_Reports},
  dlgMemberPicker in 'DIALOGS\Picker\dlgMemberPicker.pas' {MemberPicker},
  rptMM_Chart in 'MEMBERS\rptMM_Chart.pas' {MemberChart: TDataModule},
  rptMM_CheckData in 'MEMBERS\rptMM_CheckData.pas' {MemberCheckData: TDataModule},
  rptMM_Detail in 'MEMBERS\rptMM_Detail.pas' {MemberDetail: TDataModule},
  rptMM_History in 'MEMBERS\rptMM_History.pas' {MemberHistory: TDataModule},
  rptClub_MembersDetail in 'REPORTS\SwimClub\rptClub_MembersDetail.pas' {Club_MembersDetail: TDataModule},
  rptClub_MembersList in 'REPORTS\SwimClub\rptClub_MembersList.pas' {Club_MembersList: TDataModule},
  rptClub_MembersSummary in 'REPORTS\SwimClub\rptClub_MembersSummary.pas' {Club_MembersSummary: TDataModule},
  frFrameHeat in 'FRAMES\frFrameHeat.pas' {FrameHeat: TFrame},
  uIntercepters in 'TOOLS\uIntercepters.pas',
  uHeat in 'DATA_Helper\uHeat.pas',
  frFrameLane in 'FRAMES\frFrameLane.pas' {FrameLane: TFrame},
  uLane in 'DATA_Helper\uLane.pas',
  frFrameNavEv in 'FRAMES\frFrameNavEv.pas' {FrameNavEv: TFrame},
  frFrameNavEvItem in 'FRAMES\frFrameNavEvItem.pas' {FrameNavEvItem: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 SlateGray');
  Application.CreateForm(TSCM2, SCM2);
  Application.CreateForm(TCORE, CORE);
  Application.CreateForm(TIMG, IMG);
  Application.CreateForm(TMain2, Main2);
  Application.Run;

end.
