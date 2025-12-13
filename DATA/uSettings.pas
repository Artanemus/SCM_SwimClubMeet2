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
    ttb_algorithmIndx: integer; // originally - HeatAlgorithm
    ttb_calcDefRT: boolean; // originally - UseDefRaceTime
    ttb_calcDefRTpercent: double;    // originally - RaceTimeTopPercent
    ttb_checkMembersPB: boolean; // Inspect Members PB's data for ttb.

    // Displays floating panel with PKs - a debug tool.
    ShowDebugInfo: boolean;

    // limits number of data points shown when charting members RTs
    MemberChartDataPoints: integer;

    mm_HideArchived: boolean;
    mm_HideInActive: boolean;
    mm_HideNonSwimmer: boolean;
    mm_ActivePageIndex: integer;

    // depreciated.
    // HideTitlePanel: boolean; // no longer required.
    // UseWindowsDefTheme: boolean; // only one theme available.
    // CheckUnNomination: boolean; // no warning message will be shown.
    // ImportSeedTime: integer; // see.. ttb_checkMembersPB.

    // variables for Auto-Build.
    ab_ExcludeOutsideLanes: boolean;
    ab_SeperateGender: boolean;
    ab_GroupByIndx: integer;     // originally - GroupBy.
    ab_SeedMethodIndx: integer;  // originally - SeedMethod.
    ab_SeedDepth: integer;

    EnableDQcodes: boolean; // switch to FINA disqualification codes.


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

  LastSwimClubPK := 0; // Restore last swim club. Used when booting up and managing clubs.
  HideLockedSessions := false; // Display all sessions. Session grid variable.
  MemberSortOn := 0; // Sort on firstname-lastname. Nomination members grid variable.
  SeedDateAuto := 0; // Today's date. Needed to calculate AGE and TTB.

  ttb_algorithmIndx := 2; // Use the average of the member's 3 fastest RTs
  ttb_calcDefRT := true;  // if algorithm fails - calculate a mean average.
  ttb_calcDefRTpercent :=  50.0; // bottom percent ...
  ttb_checkMembersPB := false; // look for RT in SwimClubMeet2.dbo.PB data.

  ShowDebugInfo := false;
  MemberChartDataPoints := 26; // number of club nights - the length of a swimming season.

  mm_HideArchived := false;
  mm_HideInActive := false;
  mm_HideNonSwimmer := false;
  mm_ActivePageIndex := -1;

  ab_ExcludeOutsideLanes := false;
  ab_SeperateGender := false;
  ab_GroupByIndx := 0; // 0=none, 1=Entrant's Age, 2-Swimming category, 3=Division.
  ab_SeedMethodIndx := 0; // 0=SCM2 Method 1=Circle Seeding
  ab_SeedDepth := 3; // Default.

  EnableDQcodes := false; // use simple DQ method. (not FINA Codes).

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
  AssignFromJSON(Json); // magic method from XSuperObject's helper...
end;

procedure TAppSetting.SaveToFile(APathFileName: string = '');
var
  Json: string;
begin
  if APathFileName = '' then
    APathFileName := GetDefPathFileName();
  Json := AsJSON(True); // magic method from XSuperObject's helper...
  TFile.WriteAllText(APathFileName, Json, TEncoding.UTF8);
end;




end.
