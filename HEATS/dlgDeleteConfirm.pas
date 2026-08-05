unit dlgDeleteConfirm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.TitleBarCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TDeleteConfirm = class(TForm)
    pnlBody: TPanel;
    pnlFooter: TPanel;
    btnYes: TButton;
    btnNo: TButton;
    lblDeleteConfirm: TLabel;
    lblMsg: TLabel;
    procedure btnNoClick(Sender: TObject);
    procedure btnYesClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DeleteConfirm: TDeleteConfirm;

implementation

{$R *.dfm}

procedure TDeleteConfirm.btnNoClick(Sender: TObject);
begin
  ModalResult := mrNo;
  //Close;
end;

procedure TDeleteConfirm.btnYesClick(Sender: TObject);
begin
  ModalResult := mrOk;
  //Close;
end;

procedure TDeleteConfirm.FormKeyDown(Sender: TObject; var Key: Word; Shift:
  TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrNo;
    Close;
  end;
end;

end.
