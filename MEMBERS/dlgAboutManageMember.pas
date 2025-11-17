unit dlgAboutManageMember;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TAboutManageMember = class(TForm)
    pnlHeader: TPanel;
    pnlFooter: TPanel;
    pnlBody: TPanel;
    btnOK: TButton;
    lblDetails: TLabel;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutManageMember: TAboutManageMember;

implementation

{$R *.dfm}

procedure TAboutManageMember.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
