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
  dlgSwimClub_Manage in 'DIALOGS\SwimClub\dlgSwimClub_Manage.pas' {SwimClubManage},
  uSession in 'DATA_Helper\uSession.pas',
  uSwimClub in 'DATA_Helper\uSwimClub.pas',
  f_FrameClubGroup in 'FRAMES\f_FrameClubGroup.pas' {FrClubGroup: TFrame},
  dlgSwimClubGroup_View in 'DIALOGS\SwimClub\dlgSwimClubGroup_View.pas' {SwimClubGroup_View},
  frFrameSessionEx in 'FRAMES\frFrameSessionEx.pas' {FrameSessionEx: TFrame},
  f_FrameSession in 'FRAMES\f_FrameSession.pas' {FrameSession: TFrame};

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
