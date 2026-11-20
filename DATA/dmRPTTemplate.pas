unit dmRPTTemplate;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, frxClass, frxDBSet,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  dmSCM2, uSwimCLub, uSession;

type
  TRPTTemplate = class(TDataModule)
    qryfrxSwimClub: TFDQuery;
    dsfrxSwimClub: TfrxDBDataset;
    qryfrxSession: TFDQuery;
    dsfrxSession: TfrxDBDataset;
    procedure DataModuleCreate(Sender: TObject);
  private
    fIsActive: boolean;
  public
    procedure Activate;
    procedure DeActivate;
    function Prepare(): boolean;
    property IsActive: boolean read FIsActive write FIsActive;

  end;

var
  RPTTemplate: TRPTTemplate;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TRPTTemplate.Activate;
begin
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    qryfrxSwimClub.Connection := SCM2.scmConnection;
    qryfrxSession.Connection := SCM2.scmConnection;
    FIsActive := true;
  end;
end;

procedure TRPTTemplate.DeActivate;
begin
  fIsActive := false;
  qryfrxSession.Close();
  qryfrxSwimClub.Close();
end;

procedure TRPTTemplate.DataModuleCreate(Sender: TObject);
begin
  FIsActive := false;
  if not Assigned(SCM2) then
    raise Exception.Create('SCM2 not assigned.');

end;

function TRPTTemplate.Prepare: boolean;
begin
  result := false;
  if fIsActive then
  begin
    try
      qryfrxSwimClub.Close;
      qryfrxSwimClub.ParamByName('SWIMCLUBID').AsInteger := uSwimClub.PK;
      qryfrxSwimClub.Prepare;
      qryfrxSwimClub.Open;

      qryfrxSession.Close;
      qryfrxSession.ParamByName('SESSIONID').AsInteger := uSession.PK;
      qryfrxSession.Prepare;
      qryfrxSession.Open;

      result := true;
    except
      on E: EFDDBEngineException do
        SCM2.FDGUIxErrorDialog.Execute(E);
    end;
  end;
end;



end.
