unit dlgMM_Delete;

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
  TMM_Delete = class(TForm)
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
  MM_Delete: TMM_Delete;

implementation

{$R *.dfm}



procedure TMM_Delete.FormCreate(Sender: TObject);
begin
  fMemberName := '';
end;

procedure TMM_Delete.btnNoClick(Sender: TObject);
begin
  ModalResult := mrNo;
end;

procedure TMM_Delete.btnYesClick(Sender: TObject);
begin
  ModalResult := mrYes;
end;

procedure TMM_Delete.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then
    ModalResult := mrNo;
end;

procedure TMM_Delete.FormShow(Sender: TObject);
begin
  if fMemberName.IsEmpty then
    lblTitle.Caption := 'Delete member from database?'
  else
    lblTitle.Caption := 'Delete ' + fMemberName + ' from database?';

  btnNo.SetFocus;
end;

end.
