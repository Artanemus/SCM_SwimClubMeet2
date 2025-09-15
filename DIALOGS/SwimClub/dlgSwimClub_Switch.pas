unit dlgSwimClub_Switch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Vcl.Grids,
  AdvObj, BaseGrid, AdvGrid, DBAdvGrid,
  dmSCM2, dmIMG, dmCORE, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TSwimClubSwitch = class(TForm)
    gSwitchSwimClub: TDBAdvGrid;
    pnlFooter: TPanel;
    btnOk: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SwimClubSwitch: TSwimClubSwitch;

implementation

{$R *.dfm}

procedure TSwimClubSwitch.btnOkClick(Sender: TObject);
begin
  ModalResult := mrClose;
end;

procedure TSwimClubSwitch.FormKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrClose;
  end;
end;

end.
