unit scmSimpleConnect;

interface

uses

{$IFDEF FRAMEWORK_VCL}
  // Needed for class TApplication. wit: Application.ExeName
  vcl.Forms,
{$IFEND}
  (*
    {$IFDEF FRAMEWORK_FMX}
    FMX.Forms,
    {$IFEND}
  *)

  Classes, FireDAC.Stan.Def, FireDAC.Comp.Client;

type
  TSimpleConnect = class(TComponent)
  private
    fAppShortName: String;
    fDBConnection: TFDConnection;
    fDBName: String;
    fSaveConfigAfterConnect: boolean;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateWithConnection(AOwner: TComponent;
      AConnection: TFDConnection);
    procedure SimpleMakeTemporyConnection(Server, User, Password: string;
      OsAuthent: boolean);
  published
    property DBConnection: TFDConnection read fDBConnection write fDBConnection;
    property DBName: string read fDBName write fDBName;
    property SaveConfigAfterConnection: boolean read fSaveConfigAfterConnect
      write fSaveConfigAfterConnect;
  end;

  { TSimpleConnect }
implementation

uses
  SysUtils, uUtility, System.IniFiles, System.IOUtils;

constructor TSimpleConnect.Create(AOwner: TComponent);
begin
  inherited;
  // default
  fDBName := 'SwimClubMeet2';
  fSaveConfigAfterConnect := true;
{$IFDEF FRAMEWORK_VCL}
  fAppShortName := TPath.GetFileNameWithoutExtension(Application.ExeName);
{$IFEND}
{$IFDEF FRAMEWORK_FMX}
  fAppShortName := TPath.GetFileNameWithoutExtension(ParamStr(0));
{$IFEND}
end;

constructor TSimpleConnect.CreateWithConnection(AOwner: TComponent;
  AConnection: TFDConnection);
begin
  Create(AOwner);
  fDBConnection := AConnection;
end;

procedure TSimpleConnect.SimpleMakeTemporyConnection(Server, User,
  Password: string; OsAuthent: boolean);
var
  AValue, ASection, AName: string;
begin

  if not Assigned(fDBConnection) then
    exit;

  if (fDBConnection.Connected) then
  begin
    fDBConnection.Close();
  end;

  // Required for multi connection attempts to work
  fDBConnection.Params.Clear;

  fDBConnection.Params.Add('Server=' + Server);
  fDBConnection.Params.Add('DriverID=MSSQL');
  fDBConnection.Params.Add('Database=' + fDBName);
  fDBConnection.Params.Add('User_name=' + User);
  fDBConnection.Params.Add('Password=' + Password);
  if (OsAuthent) then
    AValue := 'Yes'
  else
    AValue := 'No';
  fDBConnection.Params.Add('OSAuthent=' + AValue);
  fDBConnection.Params.Add('Mars=yes');
  fDBConnection.Params.Add('MetaDefSchema=dbo');
  fDBConnection.Params.Add('ExtendedMetadata=False');
  fDBConnection.Params.Add('Encrypt=No');
  fDBConnection.Params.Add('ODBCAdvanced=Encrypt=no;Trust Server Certificate =Yes;');
  fDBConnection.Params.Add('Certificate =Yes');
  fDBConnection.Params.Add('ApplicationName=' + fAppShortName);

  { TODO -oBSA -cGeneral : DEBUG using FireDAC Tracing
    - requires component TFDMoniRemoteClientLink placed on form.
  }
{$IFDEF DEBUG}
  // fDBConnection.Params.Add('MonitorBy=Remote');
{$ENDIF}
  try
    fDBConnection.Open;
  except
    // Display the server error?
  end;

  // ON SUCCESS - Save connection details.
  if (fDBConnection.Connected and fSaveConfigAfterConnect) then
  begin
    ASection := 'MSSQL_Connection';
    AName := 'Server';
    SaveSharedIniFileSetting(ASection, AName, Server);
    AName := 'User';
    SaveSharedIniFileSetting(ASection, AName, User);
    AName := 'Password';
    SaveSharedIniFileSetting(ASection, AName, Password);
    AName := 'OSAuthent';
    SaveSharedIniFileSetting(ASection, AName, AValue);

{$IFDEF DEBUG}
    { TODO -oBSA -cGeneral : FireDAC Tracing - DISABLE DEBUG }
    // fDBConnection.ConnectionIntf.Tracing := false;
{$ENDIF}
  end

end;

end.
