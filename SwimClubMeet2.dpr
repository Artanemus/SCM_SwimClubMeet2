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
  uSwimClub in 'FRAMES\uSwimClub.pas',
  dlgSwimClub_Manage in 'DIALOGS\SwimClub\dlgSwimClub_Manage.pas' {SwimClubManage},
  uSession in 'FRAMES\uSession.pas';

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
