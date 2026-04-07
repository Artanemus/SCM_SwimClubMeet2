unit frmSwimClubType;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  dmSCM2, AdvUtil, Vcl.StdCtrls, Vcl.Buttons, Vcl.DBCtrls, Vcl.ExtCtrls,
  Vcl.Grids, AdvObj, BaseGrid, AdvGrid, DBAdvGrid;

type
  TSwimClubType = class(TForm)
    qrySwimClubType: TFDQuery;
    qrySwimClubTypeSwimClubTypeID: TFDAutoIncField;
    qrySwimClubTypeCaption: TWideStringField;
    qrySwimClubTypeShortCaption: TWideStringField;
    qrySwimClubTypeABREV: TWideStringField;
    qrySwimClubTypeIsArchived: TBooleanField;
    qrySwimClubTypeIsActive: TBooleanField;
    dsSwimClubType: TDataSource;
    Grid: TDBAdvGrid;
    pnlFooter: TPanel;
    pnlBody: TPanel;
    Nav: TDBNavigator;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    fConnection: TFDConnection;
  public
    { Public declarations }
    property Connection: TFDConnection read FConnection write FConnection;
  end;

var
  SwimClubType: TSwimClubType;

implementation

{$R *.dfm}

procedure TSwimClubType.btnCloseClick(Sender: TObject);
begin
  qrySwimClubType.CheckBrowseMode;
  ModalResult := mrOk;
end;

procedure TSwimClubType.FormCreate(Sender: TObject);
begin
  FConnection := nil;
end;

procedure TSwimClubType.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    qrySwimClubType.CheckBrowseMode;
    ModalResult := mrOk;
    Key := 0;
  end;
end;

procedure TSwimClubType.FormShow(Sender: TObject);
begin
  if Assigned(FConnection) then
  begin
    qrySwimClubType.Connection := FConnection;
    qrySwimClubType.Open;
  end;
end;

end.
