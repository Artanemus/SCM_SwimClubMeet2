unit dlgMM_About;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TMM_About = class(TForm)
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
  MM_About: TMM_About;

implementation

{$R *.dfm}

procedure TMM_About.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
