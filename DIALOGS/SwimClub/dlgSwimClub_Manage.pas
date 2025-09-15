unit dlgSwimClub_Manage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.ExtCtrls, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.StdCtrls,

  dmIMG, dmCORE, dmSCM2, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  DBAdvGrid;

type
  TSwimClubManage = class(TForm)
    pnlHeader: TPanel;
    pnlFooter: TPanel;
    actnToolBar: TActionToolBar;
    btnOK: TButton;
    actnSwimClub: TActionManager;
    actnMoveUp: TAction;
    actnMoveDown: TAction;
    actnEdit: TAction;
    actnNew: TAction;
    actnDelete: TAction;
    pnlBody: TPanel;
    gSwimClub: TDBAdvGrid;
    pnlTools: TPanel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SwimClubManage: TSwimClubManage;

implementation

{$R *.dfm}

procedure TSwimClubManage.FormKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;
  end;
end;

end.
