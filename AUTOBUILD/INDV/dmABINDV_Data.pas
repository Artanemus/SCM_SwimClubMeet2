unit dmABINDV_Data;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client,
  Data.DB, FireDAC.Comp.DataSet, uDefines, dmSCM2, dmCORE;

type

  TABINDV_Data = class(TDataModule)
    qryGender: TFDQuery;
    procDeleteHeats: TFDStoredProc;
    qryUnplacedNominees: TFDQuery;
    procRenumberHeats: TFDStoredProc;
    procedure DataModuleCreate(Sender: TObject);

  private
    fIsActive: boolean;
  public
    { Public declarations }
    procedure ActivateData;
    procedure DeActivateData;
    property IsActive: boolean read FIsActive write FIsActive;
  end;

var
  ABINDV_Data: TABINDV_Data;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses uUtility, System.Math, vcl.Dialogs, System.Variants, IniFiles,
  vcl.StdCtrls, System.UITypes, uSwimClub, uSession, uEvent, uHeat, ulane;

  // dmSCMNom,  dmSCMHelper;

{$R *.dfm}

procedure TABINDV_Data.ActivateData;
begin
  IsActive := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    qryGender.Connection := SCM2.scmConnection;
    qryUnplacedNominees.Connection := SCM2.scmConnection;
    qryGender.Open;
    if qryGender.Active then
      IsActive := true;
  end
  else
    raise Exception.Create('AUTO-BUILD DATA : No connection to SCM2.');
end;

procedure TABINDV_Data.DataModuleCreate(Sender: TObject);
begin
  // Default preferences ...
  IsActive := false;


end;

procedure TABINDV_Data.DeActivateData;
begin
  qryGender.Close;
  qryUnplacedNominees.Close;
end;


end.
