unit dlgSwimClubGroup_View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, AdvUtil, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, DBAdvGrid, dmSCM2, dmIMG,
  dmCORE;

type
  TSwimClubGroup_View = class(TForm)
    qryChildClubs: TFDQuery;
    dsChildClubs: TDataSource;
    gClubGroups: TDBAdvGrid;
    pnlBody: TPanel;
    pnlHeader: TPanel;
    lblTitle: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    fSwimClubID: integer;
  public
    { Public declarations }
  end;

var
  SwimClubGroup_View: TSwimClubGroup_View;

implementation

{$R *.dfm}

procedure TSwimClubGroup_View.FormDestroy(Sender: TObject);
begin
  qryChildClubs.Close;
end;

procedure TSwimClubGroup_View.FormCreate(Sender: TObject);
var
SQL: string;
v: variant;
begin

  if CORE.qrySwimClub.IsEmpty then
  begin
    ModalResult := mrCancel;
    Exit;
  end;

  fSwimClubID := CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;
  // Find the child clubs linked to this parent - read only.
  qryChildClubs.Close;
  // Current selected 'Grouped Swimming Club' is the parent.
  qryChildClubs.ParamByName('PARENTCLUBID').AsInteger := fSwimClubID;
  qryChildClubs.Prepare;
  qryChildClubs.Open;

  // construct the header panel caption
  lblTitle.Caption := CORE.qrySwimClub.FieldByName('Caption').AsString
     + '  (use ESC to close dialogue)'
end;

procedure TSwimClubGroup_View.FormKeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrOk;
  end;
end;

end.
