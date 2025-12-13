unit dlgLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.Actions,
  Vcl.ActnList, Vcl.Imaging.pngimage, Vcl.WinXCtrls, Vcl.StdCtrls, dmSCM2,
  uSettings, uDefines, scmSimpleConnect,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  Vcl.VirtualImage, dmIMG, SVGIconImage;

type
  TLogin = class(TForm)
    lblServer: TLabel;
    lblUserName: TLabel;
    lblPassword: TLabel;
    chkbOSAuthent: TCheckBox;
    edtPassword: TEdit;
    edtServer: TEdit;
    edtUser_Name: TEdit;
    pnlSideBar: TPanel;
    Panel2: TPanel;
    btnDisconnect: TButton;
    btnConnect: TButton;
    RelativePanel1: TRelativePanel;
    pnlBody: TPanel;
    btnDone: TButton;
    vimgVisibility: TVirtualImage;
    imgLoginPanel: TImage;
    lblLoginPanelTxt1: TLabel;
    lblLoginPanelTxt2: TLabel;
    memoInfo: TMemo;

    procedure btnDisconnectClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vimgVisibilityClick(Sender: TObject);
  private
    procedure ReadLoginParams();
    procedure SetConnectionInfo;
    procedure WriteLoginParams();

  public
    { Public declarations }

  published
  end;

var
  Login: TLogin;

implementation

{$R *.dfm}

uses exeinfo, System.IniFiles, scmUtils;   //frmMain2,


procedure TLogin.btnDisconnectClick(Sender: TObject);
begin
  if Assigned(SCM2.scmConnection) then
  begin
    if (SCM2.scmConnection.Connected) then
    begin
      SCM2.scmConnection.Close;
    end;
  end;

  if (SCM2.scmConnection.Connected) then
  begin
    btnDisconnect.Visible := true;
    btnConnect.Visible := false;
  end
  else
  begin
    btnDisconnect.Visible := false;
    btnConnect.Visible := true;
  end;

  SetConnectionInfo;

end;

procedure TLogin.btnConnectClick(Sender: TObject);
begin
  if Assigned(SCM2.scmConnection) then
  begin
    if (SCM2.scmConnection.Connected) then
      SCM2.scmConnection.Close;
    memoInfo.Lines.BeginUpdate;
    memoInfo.Clear;
    memoInfo.Lines.Append('Attempting to connect.');
    memoInfo.Lines.EndUpdate;

    // Assert the default OLE DB provider login timeout. 5 seconds.
    SCM2.WriteConnectionDef('MSSQL_SCM2', 'LoginTimeout', '5');
    btnDisconnect.Visible := false;
    btnConnect.Visible := false;
    WriteLoginParams();
    SCM2.scmConnection.Open;
    if (SCM2.scmConnection.Connected) then
    begin
      btnDisconnect.Visible := true;
      btnConnect.Visible := false;
      SetConnectionInfo;
    end
    else
    begin
      memoInfo.Text := '';
      btnDisconnect.Visible := false;
      btnConnect.Visible := true;
    end;
  end;

  SetConnectionInfo;

end;

procedure TLogin.btnDoneClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TLogin.FormCreate(Sender: TObject);
begin
  memoInfo.Clear;
  edtPassword.PasswordChar := '*'; // default : hide password.
  vimgVisibility.imageName := 'visible_off';

  ReadLoginParams;
  if Assigned(SCM2.scmConnection) then
  begin
    if (SCM2.scmConnection.Connected) then
    begin
      btnDisconnect.Visible := true;
      btnConnect.Visible := false;
    end
    else
    begin
      btnDisconnect.Visible := false;
      btnConnect.Visible := true;
    end;
  end;

  SetConnectionInfo;
end;

procedure TLogin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then
    ModalResult := mrAbort;
end;

procedure TLogin.FormShow(Sender: TObject);
begin
  SetConnectionInfo; // Assert or duplicity?
  btnDone.SetFocus;
end;

procedure TLogin.ReadLoginParams();
var
  iFile: TIniFile;
  iniFileName, UseOsAuthentication: string;
begin
  // FDManager SHOULD point to this connection definition file...
  // %AppData%\Artanemus\scm\FDConnectionDefs.ini
  iniFileName := FDManager.ActualConnectionDefFileName;
  if not FileExists(iniFileName) then exit;
  iFile := TIniFile.Create(iniFileName);
  edtServer.Text := iFile.ReadString('MSSQL_SCM2', 'Server', 'localHost\SQLEXPRESS');
  edtUser_Name.Text := iFile.ReadString('MSSQL_SCM2', 'User_Name', '');
  edtPassword.Text := iFile.ReadString('MSSQL_SCM2', 'Password', '');
  UseOsAuthentication := iFile.ReadString('MSSQL_SCM2', 'OSAuthent', 'Yes');
  UseOsAuthentication := LowerCase(UseOsAuthentication);
  if UseOsAuthentication.Contains('yes') or UseOsAuthentication.Contains('true') then
    chkbOSAuthent.Checked := true else chkbOSAuthent.Checked := false;
  iFile.Free;
end;

procedure TLogin.SetConnectionInfo;
var
  VersionInfo: string;
  HostMachine: string;
  DataBaseName: string;
begin
  HostMachine := '';
  memoInfo.Lines.BeginUpdate;
  try
    memoInfo.Clear;
    if Assigned(SCM2.scmConnection) and SCM2.scmConnection.Connected then
    begin
      // Display some information on the connection.
      memoInfo.Lines.Append('FireDAC''s Connection Definition: ' +
        FDManager.ActualConnectionDefFileName);
      VersionInfo := SCM2.scmConnection.ExecSQLScalar(
        'SELECT CAST(SERVERPROPERTY(''ProductVersion'') AS VARCHAR(50)) + '' - '' ' +
        '+ CAST(SERVERPROPERTY(''ProductLevel'') AS VARCHAR(50)) + '' - '' ' +
        '+ CAST(SERVERPROPERTY(''Edition'') AS VARCHAR(50)) AS VersionInfo');
      memoInfo.Lines.Append('Server version: ' + VersionInfo);

{$IFDEF DEBUG}
      // Security issues. (wit: demostrating code).
      memoInfo.Lines.Append('Host Machine: ARTANEMUS-LORE');
{$ELSE}
      HostMachine := SCM2.scmConnection.ExecSQLScalar(
        'SELECT CAST(SERVERPROPERTY(''MachineName'') AS VARCHAR(50)) AS MachineName;');
      memoInfo.Lines.Append('Host Machine: ' + HostMachine);
{$ENDIF}
      SCM2.ReadConnectionDef('MSSQL_SCM2', 'DataBase', DataBaseName);
      memoInfo.Lines.Append('Database: ' + DataBaseName);
      memoInfo.Lines.Append('DB Version: ' + SCM2.GetDBVerInfo);
    end
    else
      memoInfo.Lines.Append('NOT CONNECTED.');
  finally
    memoInfo.Lines.EndUpdate;
  end;
end;

procedure TLogin.vimgVisibilityClick(Sender: TObject);
begin
  // toggle image
  if vimgVisibility.imageName = 'visible_off' then
    vimgVisibility.imageName := 'visible_on'
  else
    vimgVisibility.imageName := 'visible_off';

  if vimgVisibility.imageName = 'visible_on' then
    edtPassword.PasswordChar := #0
  else
    edtPassword.PasswordChar := '*';

end;

procedure TLogin.WriteLoginParams();
var
  iFile: TIniFile;
  iniFileName: string;
begin
  iniFileName := FDManager.ActualConnectionDefFileName;
  if not FileExists(iniFileName) then exit;
  iFile := TIniFile.Create(iniFileName);
  if chkbOSAuthent.Checked then
    iFile.WriteString('MSSQL_SCM2', 'OSAuthent', 'Yes')
  else
    iFile.WriteString('MSSQL_SCM2', 'OSAuthent', 'No');
  iFile.WriteString('MSSQL_SCM2', 'Password', edtPassword.Text);
  iFile.WriteString('MSSQL_SCM2', 'User_Name', edtUser_Name.Text);
  iFile.WriteString('MSSQL_SCM2', 'Server', edtServer.Text);
  iFile.Free;
end;


end.
