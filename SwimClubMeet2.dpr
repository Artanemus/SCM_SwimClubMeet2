program SwimClubMeet2;

uses
  Vcl.Forms,
  frmMain2 in 'frmMain2.pas' {Main2},
  dmCORE in 'dmCORE.pas' {CORE: TDataModule},
  dmIMG in 'dmIMG.pas' {IMG: TDataModule},
  dmSCM2 in 'dmSCM2.pas' {SCM2: TDataModule},
  XSuperJSON in 'JSON\XSuperJSON.pas',
  XSuperObject in 'JSON\XSuperObject.pas',
  scmUtils in 'UTILITY\scmUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSCM2, SCM2);
  Application.CreateForm(TCORE, CORE);
  Application.CreateForm(TIMG, IMG);
  Application.CreateForm(TMain2, Main2);
  Application.Run;
end.
