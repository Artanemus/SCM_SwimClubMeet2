unit dlgDeleteMember;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.WinXCtrls,
  Vcl.VirtualImage,
  Vcl.BaseImageCollection,
  Vcl.ImageCollection,
  Vcl.StdCtrls,
  dmIMG
  ;

type
  TDeleteMember = class(TForm)
    VirtualImage1: TVirtualImage;
    RelativePanel1: TRelativePanel;
    lblTitle: TLabel;
    Panel1: TPanel;
    btnYes: TButton;
    btnNo: TButton;
    lblDetails: TLabel;
    VirtualImage2: TVirtualImage;
    lblDetailEx: TLabel;
    vimgWarningTape: TVirtualImage;
    vimgWarningTapeTop: TVirtualImage;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnYesClick(Sender: TObject);
    procedure btnNoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fMemberName: string;
  public
    property MemberName: string read FMemberName write FMemberName;
  end;

var
  DeleteMember: TDeleteMember;

implementation

{$R *.dfm}



procedure TDeleteMember.FormCreate(Sender: TObject);
begin
  fMemberName := '';
end;

procedure TDeleteMember.btnNoClick(Sender: TObject);
begin
  ModalResult := mrNo;
end;

procedure TDeleteMember.btnYesClick(Sender: TObject);
begin
  ModalResult := mrYes;
end;

procedure TDeleteMember.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then
    ModalResult := mrNo;
end;

procedure TDeleteMember.FormShow(Sender: TObject);
begin
  if fMemberName.IsEmpty then
    lblTitle.Caption := 'Delete member from database?'
  else
    lblTitle.Caption := 'Delete ' + fMemberName + ' from database?';

  btnNo.SetFocus;
end;

end.
