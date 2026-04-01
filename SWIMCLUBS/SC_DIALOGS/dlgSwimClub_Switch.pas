unit dlgSwimClub_Switch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Vcl.Grids,
  Data.DB,
  AdvObj, BaseGrid, AdvGrid, DBAdvGrid,
  dmSCM2, dmIMG, dmCORE, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TSwimClubSwitch = class(TForm)
    gSwitchSwimClub: TDBAdvGrid;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure gSwitchSwimClubDblClick(Sender: TObject);
    procedure gSwitchSwimClubGetHTMLTemplate(Sender: TObject; ACol,
      ARow: Integer; var HTMLTemplate: string; Fields: TFields);
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

procedure TSwimClubSwitch.gSwitchSwimClubGetHTMLTemplate(Sender: TObject; ACol,
  ARow: Integer; var HTMLTemplate: string; Fields: TFields);
var
  htmlStr: string;
begin
  htmlStr := '''
      <FONT size="12">
      <IND x="4"><#Caption></FONT><BR>
      <FONT size="9">
      <IND x="8">
      <#NickName> (<#CaptionShort>)</FONT>
    ''';
   HTMLTemplate := htmlStr
end;

end.
