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
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure gSwitchSwimClubDblClick(Sender: TObject);
  private
  public
  end;

var
  SwimClubSwitch: TSwimClubSwitch;

implementation

{$R *.dfm}

procedure TSwimClubSwitch.FormKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if (Key = VK_ESCAPE) or (Key = VK_RETURN) or (Key = VK_SPACE) then
  begin
    ModalResult := mrOk;
    Key := 0;
  end;
end;

procedure TSwimClubSwitch.gSwitchSwimClubDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
