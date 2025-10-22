unit dmSCM2;

interface

uses
  System.SysUtils, System.Classes, System.UITypes,

  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.VCLUI.Error, FireDAC.Comp.UI,

  Data.DB,

  VCL.Dialogs;


type
  TSCM2 = class(TDataModule)
    scmConnection: TFDConnection;
    qrySCMSystem: TFDQuery;
    scmFDManager: TFDManager;
    FDGUIxErrorDialog: TFDGUIxErrorDialog;
    procRenumberHeats: TFDStoredProc;
    procRenumberEvents: TFDStoredProc;
    procRenumberLanes: TFDStoredProc;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure scmConnectionAfterConnect(Sender: TObject);
    procedure scmConnectionAfterDisconnect(Sender: TObject);
  private
    fDBVersion: Integer;
    fDBMajor: Integer;
    fDBMinor: Integer;
    fDBBuild: integer;
    fDBVerInfoStr: string;

  public
    function GetDBVerInfo: string;
    procedure ReadConnectionDef(const ConnectionName, ParamName: string;
      out ParamValue: string);
    procedure WriteConnectionDef(const ConnectionName, ParamName,
      ParamValue: string);
  published
    property DBVerInfoStr: string read FDBVerInfoStr;

  end;

var
  SCM2: TSCM2;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  dmCORE;


procedure TSCM2.DataModuleDestroy(Sender: TObject);
begin
  // ASSERT connection state.
  if scmConnection.Connected then scmConnection.Close;
end;

procedure TSCM2.DataModuleCreate(Sender: TObject);
begin
  // ASSERT connection state.
  if scmConnection.Connected then scmConnection.Close;
end;

function TSCM2.GetDBVerInfo: string;
begin
  result := '';
  if scmConnection.Connected then
  begin
    qrySCMSystem.Connection := scmConnection;
    qrySCMSystem.Open;
    if qrySCMSystem.Active then
    begin
      fDBVersion := qrySCMSystem.FieldByName('DBVersion').AsInteger;
      fDBMajor := qrySCMSystem.FieldByName('Major').AsInteger;
      fDBMinor := qrySCMSystem.FieldByName('Minor').AsInteger;
      fDBBuild := qrySCMSystem.FieldByName('Build').AsInteger;
      result := 'V' + fDBVersion.ToString + ' ' + fDBMajor.ToString + '.' +
        fDBMinor.ToString + '.' + fDBBuild.ToString;
    end;
    qrySCMSystem.Close;
  end;
end;

procedure TSCM2.scmConnectionAfterConnect(Sender: TObject);
var
  msg: string;
begin
  fDBVerInfoStr := GetDBVerInfo();
  {
    And what happens if CORE isn't assigned?
    Answer ... 'Manage Connection' cannot be started if CORE isn't assigned.
  }
  if Assigned(CORE) then
  begin
    try
      CORE.ActivateCore; // open tables. & traps exceptions
    finally
      if not CORE.IsActive then
      begin
        msg := '''
          The CORE failed to activate.
          Probable cause: Most likely a bad field name was used in a query.

          Note: A connection to the database server was established, but
          the application's internal data failed to boot.

          Contact the developer!
          ''';
        MessageDlg(msg, mtError, [mbOK], 0);
        scmConnection.Close; // DISCONNECT ?....
      end;
    end;
  end;
end;

(*
You do not need to make the TFDManager inactive before updating its
ConnectionDefs. The TFDManager allows you to modify connection definitions
dynamically at runtime without deactivating it.
*)

procedure TSCM2.ReadConnectionDef(const ConnectionName, ParamName: string;
  out ParamValue: string);
var
  ConnectionDef: IFDStanConnectionDef;
begin
  // Check if the connection definition exists
  ConnectionDef := SCM2.scmFDManager.ConnectionDefs.ConnectionDefByName(ConnectionName);
  if Assigned(ConnectionDef) then
  begin
    // Read the parameter value
    ParamValue := ConnectionDef.Params.Values[ParamName];
  end
  else
    raise Exception.CreateFmt('Connection definition "%s" not found.', [ConnectionName]);
end;

procedure TSCM2.scmConnectionAfterDisconnect(Sender: TObject);
begin
  if Assigned(CORE) then CORE.IsActive := false;
end;


procedure TSCM2.WriteConnectionDef(const ConnectionName, ParamName,
  ParamValue: string);
var
  ConnectionDef: IFDStanConnectionDef;
begin
  // Get the connection definition by name
  ConnectionDef := SCM2.scmFDManager.ConnectionDefs.ConnectionDefByName(ConnectionName);

  if Assigned(ConnectionDef) then
  begin
    // Update the parameter
    ConnectionDef.Params.Values[ParamName] := ParamValue;

    // Save the changes to the FDConnectionDefs.ini file
    SCM2.scmFDManager.ConnectionDefs.Save;
  end
  else
    raise Exception.CreateFmt('Connection definition "%s" not found.', [ConnectionName]);
end;


end.
