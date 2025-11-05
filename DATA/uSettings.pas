unit uSettings;

interface
uses
  system.IOUtils,
  system.SysUtils, system.Types, system.UITypes, system.Classes,
  system.Variants, VCL.Controls,
  XsuperObject;

type

  TAppSetting = Class
  private
    { private declarations }
    DoAutoLoad: boolean;
  protected
    { protected declarations }
  public
    LoginTimeOut: integer;
    DoLoginOnBoot: boolean;
    LastSwimClubPK: integer;
    HideLockedSessions: boolean;

    // sdaTodaysDate = 0, sdaSessionDate, sdaStartOfSeason
    SeedDateAuto: integer;

    // FrameMember - grid sorton members name.
    MemberSortOn: integer; // 0 firstname-lastname 1 lastname-firstname;

    // variables used to calcuate a Time-To-Beat
    ttb_algorithm: integer;
    ttb_calcDefRT: integer;
    ttb_percent: double;

    constructor Create(); overload;
    constructor Create(AutoLoad: boolean); overload;
    destructor Destroy(); override;
    function GetDefPathFileName: string;
    function GetDefPath: string;
    procedure LoadFromFile(APathFileName: string = '');
    procedure SaveToFile(APathFileName: string = '');
    procedure InitDefaults;
  end;

  const
    CONNECTIONTIMEOUT = 20;  // default is 0 - infinate...
    DEFSETTINGSSUBPATH = 'Artanemus\SCM2\SwimClubMeet';
    DEFSETTINGSFILENAME = 'scmPref.json';

var
  Settings: TAppSetting;

implementation

constructor TAppSetting.Create();
begin
  inherited Create(); // call default constructor
  InitDefaults;
end;


constructor TAppSetting.Create(AutoLoad: boolean);
begin
  inherited Create(); // call default constructor
  InitDefaults;
  DoAutoLoad := AutoLoad;
  if DoAutoLoad then
      LoadFromFile(GetDefPathFileName());
end;

destructor TAppSetting.Destroy();
begin
  if DoAutoLoad then
    SaveToFile(GetDefPathFileName());
  inherited Destroy;
end;

procedure TAppSetting.InitDefaults;
begin
  LoginTimeOut := CONNECTIONTIMEOUT;
  DoLoginOnBoot := false;
  DoAutoLoad := false;
  LastSwimClubPK := 0;
  HideLockedSessions := false;
  MemberSortOn := 0;
  SeedDateAuto := 0;

  ttb_algorithm := 2;
  ttb_calcDefRT := 1;
  ttb_percent :=  50;

  ForceDirectories(GetDefPath());
  if not FileExists(GetDefPathFileName()) then
    SaveToFile();
end;

function TAppSetting.GetDefPathFileName: string;
begin
  result := TPath.Combine(GetDefPath(), DEFSETTINGSFILENAME);
end;

function TAppSetting.GetDefPath: string;
begin
{$IFDEF MACOS}
  Result := TPath.Combine(TPath.GetLibraryPath(), DEFSETTINGSSUBPATH);
{$ELSE}
  // GETHOMEPATH = C:Users\<username>\AppData\Roaming (WINDOWS)
  // Should also work on ANDROID.
  Result := TPath.Combine(TPath.GetHomePath(), DEFSETTINGSSUBPATH);
{$ENDIF}

end;

procedure TAppSetting.LoadFromFile(APathFileName: string = '');
var
  Json: string;
begin
  if APathFileName = '' then
    APathFileName := GetDefPathFileName();
  if not FileExists(APathFileName) then
    exit;
  Json := TFile.ReadAllText(APathFileName, TEncoding.UTF8);
  AssignFromJSON(Json); // magic method from XSuperObject's helper
end;

procedure TAppSetting.SaveToFile(APathFileName: string = '');
var
  Json: string;
begin
  if APathFileName = '' then
    APathFileName := GetDefPathFileName();
  Json := AsJSON(True); // magic method from XSuperObject's helper too
  TFile.WriteAllText(APathFileName, Json, TEncoding.UTF8);
end;




end.
