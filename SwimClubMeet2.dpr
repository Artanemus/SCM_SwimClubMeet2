program SwimClubMeet2;

uses
  Vcl.Forms,
  frmMain2 in 'frmMain2.pas' {Main2},
  XSuperJSON in 'JSON\XSuperJSON.pas',
  XSuperObject in 'JSON\XSuperObject.pas',
  scmUtils in 'TOOLS\scmUtils.pas',
  dmCORE in 'DATA\dmCORE.pas' {CORE: TDataModule},
  dmIMG in 'DATA\dmIMG.pas' {IMG: TDataModule},
  dmSCM2 in 'DATA\dmSCM2.pas' {SCM2: TDataModule},
  uDefines in 'DATA\uDefines.pas',
  uSettings in 'DATA\uSettings.pas',
  Vcl.Themes,
  Vcl.Styles,
  dlgSwimClub_Switch in 'DIALOGS\SwimClub\dlgSwimClub_Switch.pas' {SwimClubSwitch},
  dlgLogin in 'DIALOGS\dlgLogin.pas' {Login},
  SCMSimpleConnect in 'TOOLS\SCMSimpleConnect.pas',
  uSwimClub in 'DATA_Helper\uSwimClub.pas',
  uSession in 'DATA_Helper\uSession.pas',
  uEvent in 'DATA_Helper\uEvent.pas',
  frFrameSession in 'FRAMES\frFrameSession.pas' {FrameSession: TFrame},
  frFrameEvent in 'FRAMES\frFrameEvent.pas' {FrameEvent: TFrame},
  frFrameClubGroup in 'FRAMES\frFrameClubGroup.pas' {FrameClubGroup: TFrame},
  dlgSwimClubGroup_View in 'DIALOGS\SwimClub\dlgSwimClubGroup_View.pas' {SwimClubGroup_View},
  dlgEditSession in 'DIALOGS\Session\dlgEditSession.pas' {EditSession},
  dlgDatePicker in 'DIALOGS\Picker\dlgDatePicker.pas' {DatePicker},
  dlgNewSession in 'DIALOGS\Session\dlgNewSession.pas' {NewSession},
  dlgSwimClub_Manage in 'DIALOGS\SwimClub\dlgSwimClub_Manage.pas' {SwimClubManage},
  frFrameNominate in 'FRAMES\frFrameNominate.pas' {FrameNominate: TFrame},
  frFrameFilterMember in 'FRAMES\frFrameFilterMember.pas' {FrameFilterMember: TFrame},
  uNominate in 'DATA_Helper\uNominate.pas',
  dlgPreferences in 'TOOLS\dlgPreferences.pas' {Preferences},
  dlgDeleteMember in 'MEMBERS\dlgDeleteMember.pas' {DeleteMember},
  dlgFindMember_FName in 'MEMBERS\dlgFindMember_FName.pas' {FindMember_FName},
  dlgFindMember_ID in 'MEMBERS\dlgFindMember_ID.pas' {FindMember_ID},
  dlgFindMember_Membership in 'MEMBERS\dlgFindMember_Membership.pas' {FindMember_Membership},
  dlgFilterBySwimClub in 'MEMBERS\dlgFilterBySwimClub.pas' {FilterBySwimClub},
  dlgFilterByParam in 'MEMBERS\dlgFilterByParam.pas' {FilterByParam},
  dmManageMemberData in 'MEMBERS\dmManageMemberData.pas' {ManageMemberData: TDataModule},
  dmMemberHouse in 'MEMBERS\dmMemberHouse.pas' {MemberHouse: TDataModule},
  frmManageMember in 'MEMBERS\frmManageMember.pas' {ManageMember},
  rptMemberChart in 'MEMBERS\rptMemberChart.pas' {MemberChart: TDataModule},
  rptMemberCheckData in 'MEMBERS\rptMemberCheckData.pas' {MemberCheckData: TDataModule},
  rptMemberDetail in 'MEMBERS\rptMemberDetail.pas' {MemberDetail: TDataModule},
  rptMemberHistory in 'MEMBERS\rptMemberHistory.pas' {MemberHistory: TDataModule},
  rptMembersDetail in 'MEMBERS\rptMembersDetail.pas' {MembersDetail: TDataModule},
  rptMembersList in 'MEMBERS\rptMembersList.pas' {MembersList: TDataModule},
  rptMembersSummary in 'MEMBERS\rptMembersSummary.pas' {MembersSummary: TDataModule},
  dlgAboutManageMember in 'MEMBERS\dlgAboutManageMember.pas' {AboutManageMember},
  dlgSwimClubPicker in 'DIALOGS\Picker\dlgSwimClubPicker.pas' {SwimClubPicker};

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
