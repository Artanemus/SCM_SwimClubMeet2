unit uUtility;

interface

{
  All Artanemus applications have there application-specific information and
  settings stored in TIniFiles files.

  The location is given as...
  $APPDATA$\Artanemus\SCM2\$PREFFILENAME$.ini

  $APPDATA$ exspands too...
  '%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Roaming\'
}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Data.DB,
{$IFDEF MSWINDOWS}
  System.Win.Registry,
{$IFEND}
  Vcl.Graphics, Vcl.Controls,
  Vcl.Themes,
  Vcl.Styles,
  shlobj;


type
  TRecordPos = (rpBeforeFirst, rpFirst, rpMiddle, rpLast, rpAfterLast);

function GetRecordPosition(ADataset: TDataSet): TRecordPos;

function CreateSCMPrefFileName(AFileName: TFileName): boolean;
function DeleteSCMPrefFileName(AFileName: TFileName): boolean;
function GetSCMAppDataDir(): string;
function GetSCM_SharedIniFile(): string;
function GetSCMCommonAppDataDir(): string;
function ExistsSCMConnectionDefs(): boolean; deprecated;
function GetSCMPreferenceFileName(AName: String): string; overload;
function GetSCMPreferenceFileName(): string; overload;
function GetSCMTempDir(): string;
function GetSCMHelpPrefFileName(): string;
function GetSCMDocumentDir(): string;
function GetRegAppPath(appName: string): string;
function GetRegArtanemusAppPath(appName: string): string;
function ScatterLanes(index, NumOfPoolLanes: integer): integer;
function CheckInternetA: boolean;
function CheckInternetB: boolean;

function GetStyleTabSheetElementColor: TColor;
function GetStyledPanelColor: TColor;
function GetStyledPanelElementColor: TColor;

{$IFDEF MSWINDOWS}
function LoadSharedIniFileSetting(ASection, AName: string): string;
procedure SaveSharedIniFileSetting(ASection, AName, AValue: string);
{$IFEND}



const
  PrefFileName = 'SCMPref.ini';
  HelpPrefFileName = 'SCMHelpPref.ini';
  SCMSubFolder = 'Artanemus\SCM2\';
  SCMSectionName = 'SCM2';


implementation

uses
{$IFDEF MSWINDOWS}
  System.IniFiles,
{$IFEND}
  System.Math,
  WinInet, // for interenet
  IdTCPClient // for checkinternet
;



function GetStyledPanelColor: TColor;
var
  LStyle: TCustomStyleServices;
begin
  result := $00494131; // matches perfectly the UI schema
  // Check if styles are enabled
  if TStyleManager.IsCustomStyleActive then
  begin
    LStyle := TStyleManager.ActiveStyle;
    // scPanel is the specific color constant for Panel backgrounds
    if Assigned(LStyle) then
      result := LStyle.GetStyleColor(scPanel);
  end;
end;

function GetStyledPanelElementColor: TColor;
var
  LDetails: TThemedElementDetails;
  LColor: TColor;
begin
  result := $00494131; // matches perfectly the UI schema
  // Check if styles are enabled
  if TStyleManager.IsCustomStyleActive then
  begin
    // tpPanelBackground is the standard element for the body of a TPanel
    LDetails := TStyleManager.ActiveStyle.GetElementDetails(tpPanelBackground);
    // Attempt to get the Fill Color of that specific element
    if TStyleManager.ActiveStyle.GetElementColor(LDetails, ecFillColor, LColor)
      and (LColor <> clNone) then
      Result := LColor
    else
      // Fallback if the style doesn't define a specific fill color for panels
      Result := TStyleManager.ActiveStyle.GetStyleColor(scPanel);
  end;
end;

function GetStyleTabSheetElementColor: TColor;
var
  LDetails: TThemedElementDetails;
  LColor: TColor;
begin
  result := $00494131; // matches perfectly the UI schema
  // Check if styles are enabled
  if TStyleManager.IsCustomStyleActive then
  begin
    // ttPane represents the background "body" area of a PageControl/TabSheet
    LDetails := TStyleManager.ActiveStyle.GetElementDetails(ttPane);
    // Attempt to get the Fill Color of that specific element
  // Attempt to get the Fill Color of that specific element
  if TStyleManager.ActiveStyle.GetElementColor(LDetails, ecFillColor, LColor) and (LColor <> clNone) then
    Result := LColor
  else
    // Fallback 1: Many modern styles map the TabSheet background to scGenericBackground
    Result := TStyleManager.ActiveStyle.GetStyleColor(scGenericBackground);
  end
  else
  begin
    Result := clBtnFace; // Fallback 2: Standard Windows (No Style)
  end;
end;

function GetRecordPosition(ADataset: TDataSet): TRecordPos;
begin
  if ADataset.IsEmpty then
    Exit(rpBeforeFirst);

  if ADataset.BOF and ADataset.EOF then
    Exit(rpBeforeFirst); // 1 record, but before it

  if ADataset.BOF then
    Exit(rpBeforeFirst);

  if ADataset.RecNo = 1 then
    Exit(rpFirst);

  if ADataset.EOF then
    Exit(rpAfterLast);

  if ADataset.RecNo = ADataset.RecordCount then
    Exit(rpLast);

  Result := rpMiddle;
end;


function GetSCM_SharedIniFile(): string;
begin
  result := GetSCMAppDataDir + PrefFileName;
end;

// WINDOWS API FUNCTION
function CheckInternetA: boolean;
var
  origin: Cardinal;
begin
  result := False;
  if InternetGetConnectedState(@origin, 0) then
    result := True;
end;

// POLL GOOGLE
function CheckInternetB: boolean;
var
  TCPClient: TIdTCPClient;
begin
  TCPClient := TIdTCPClient.Create(NIL);
  try
    try
      TCPClient.ReadTimeout := 2000;
      TCPClient.ConnectTimeout := 2000;
      TCPClient.Port := 80;
      TCPClient.Host := 'google.com';
      TCPClient.Connect;
      TCPClient.Disconnect;
      result := True;
    except
      result := False;
    end;
  finally
    TCPClient.Free;
  end;
end;

function CreateSCMPrefFileName(AFileName: TFileName): boolean;
var
  filehandle: NativeUInt;
begin
  result := False;
  // create the Help Preference file in 'APPDATA'
  filehandle := FileCreate(AFileName);
  // if NOT 'file already exists'
  if not(filehandle = INVALID_HANDLE_VALUE) then
  begin
    FileClose(filehandle); // close.
    result := True;
  end;
end;

function DeleteSCMPrefFileName(AFileName: TFileName): boolean;
begin
  result := False;
  // delete the Help Preference file in 'APPDATA'
  if (FileExists(AFileName)) then
    result := DeleteFile(AFileName);
end;

function GetSCMAppDataDir(): string;
var
  str: string;
begin

  result := '';
  str := GetEnvironmentVariable('APPDATA');
  str := IncludeTrailingPathDelimiter(str);
  // Append product-specific path
  str := str + SCMSubFolder;
  if not DirectoryExists(str) then
  begin
    { *
      ForceDirectories creates a new directory as specified in Dir, which must be
      a fully-qualified pathname. If the directories given in the path do not yet
      exist, ForceDirectories attempts to create them. ForceDirectories returns
      True if it successfully creates all necessary directories, False if it could
      not create a needed directory.
      Note: Do not call ForceDirectories with an empty string. Doing so causes
      ForceDirectories to raise an exception.
      * }
    if not System.SysUtils.ForceDirectories(str) then
      // FAILED! - Use alternative default document directory...
      exit;
  end;
  result := str;
end;

function GetSCMCommonAppDataDir(): string;
var
  str: string;
  szPath: array [0 .. Max_Path] of Char;
begin
  result := '';
  if (SUCCEEDED(SHGetFolderPath(null, CSIDL_COMMON_APPDATA, 0, 0, szPath))) then
  begin
    str := String(szPath);
    str := IncludeTrailingPathDelimiter(str) + SCMSubFolder;
    if not DirectoryExists(str) then
    begin
      if not CreateDir(str) then
        exit;
    end;
  end;
  result := str;
end;

// ---------------------------------------------------------------------------
// D E P R E C A T E D .
// ---------------------------------------------------------------------------
function ExistsSCMConnectionDefs(): boolean;
  deprecated 'SCM2 static connection definitions are no longer in used.';
var
  str: string;
  szPath: array [0 .. Max_Path] of Char;
  SCMConnectionDefsFileName: String;
begin
  result := False;
  SCMConnectionDefsFileName := 'SCMConnectionDef.ini';
  if (SUCCEEDED(SHGetFolderPath(null, CSIDL_COMMON_APPDATA, 0, 0, szPath))) then
  begin
    str := String(szPath);
    str := IncludeTrailingPathDelimiter(str) + SCMSubFolder +
      SCMConnectionDefsFileName;;
    if FileExists(str) then
      result := True;
  end;
end;
// ---------------------------------------------------------------------------

function GetSCMPreferenceFileName(AName: String): string;
var
  str: string;
  success: boolean;
begin
  result := '';
  str := GetSCMAppDataDir;
  if str.IsEmpty then
    exit;
  str := str + AName;
  if not FileExists(str) then
  begin
    success := CreateSCMPrefFileName(str);
    if not success then
      exit;
  end;
  result := str;
end;

function GetSCMPreferenceFileName(): string;
begin
  result := GetSCMPreferenceFileName(PrefFileName);
end;

function GetSCMTempDir(): string;
var
  str: string;
begin
  result := '';
  str := GetEnvironmentVariable('TMP');
  str := IncludeTrailingPathDelimiter(str);
  if not DirectoryExists(str) then
  begin
    if not CreateDir(str) then
      exit;
  end;
  result := str;
end;

function GetSCMHelpPrefFileName(): string;
begin
  result := GetSCMPreferenceFileName(HelpPrefFileName);
end;

function GetSCMDocumentDir(): string;
begin
  result := GetEnvironmentVariable('HOMEPATH');
  result := IncludeTrailingPathDelimiter(result);
  result := result + 'SCM2\';
end;

function GetRegAppPath(appName: string): string;
var
  reg: TRegistry;
  KeyName: string;
begin
  KeyName := '\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\';
  result := '';
  reg := TRegistry.Create(KEY_READ);
  try
    begin
      reg.RootKey := HKEY_LOCAL_MACHINE;
      if reg.KeyExists(KeyName) then
      begin
        reg.OpenKey(KeyName, False);
        result := reg.ReadString('Path');
      end;
    end;
  finally
    reg.Free;
  end;
end;

function GetRegArtanemusAppPath(appName: string): string;
var
  reg: TRegistry;
  KeyName: string;
begin
  KeyName := '\Software\\Artanemus\';
  result := '';
  KeyName := KeyName + appName + '\';
  result := '';
  reg := TRegistry.Create(KEY_READ);
  try
    begin
      reg.RootKey := HKEY_CURRENT_USER;
      reg.OpenKey(KeyName, False);
      result := reg.ReadString('Path');
    end;
  finally
    reg.Free;
  end;
end;

// -----------------------------------------------------------
// SHARED FUNCTION
// Called by dmSCM2 and dmAutoBuildV2
// -----------------------------------------------------------
function ScatterLanes(index, NumOfPoolLanes: integer): integer;
var
  Lanes: Array of integer;
  i: integer;
  IsEven: boolean;
begin
  result := 0;
  // NumOfPoolLanes must be greater than 1
  if (NumOfPoolLanes < 2) then
    exit;
  // index passed is base 0
  // test for out-of-bounds
  if ((index + 1) > NumOfPoolLanes) then
    exit;
  SetLength(Lanes, NumOfPoolLanes);
  // seed number for first array value
  // Find the center lane. For 'odd' number of pool lanes - round up;
  Lanes[0] := Ceil(double(NumOfPoolLanes) / 2.0);
  // build the
  for i := 1 to NumOfPoolLanes - 1 do
  begin
    // start the iterate at index 1
    // reference previous value in list with base 0
    if (((i + 1) MOD 2) = 0) then
      IsEven := True
    else
      IsEven := False;
    if IsEven then
      Lanes[i] := (i) + (Lanes[(i - 1)])
    else
      Lanes[i] := (Lanes[(i - 1)]) - (i);
  end;
  // pull the entrants lane number.
  result := Lanes[index];
  {
    You don't need to call SetLength at the end.
    A dynamic-array field like 'Lanes' gets released automatically when
    the object is destroyed.
    // SetLength(Lanes, 0);
  }
end;

{$IFDEF MSWINDOWS}

function LoadSharedIniFileSetting(ASection, AName: string): string;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(GetSCM_SharedIniFile);
  try
    result := ini.ReadString(ASection, AName, '');
  finally
    ini.Free;
  end;
end;

procedure SaveSharedIniFileSetting(ASection, AName, AValue: string);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(GetSCM_SharedIniFile);
  try
    ini.WriteString(ASection, AName, AValue);
  finally
    ini.Free;
  end;

end;

{$ENDIF}



end.
