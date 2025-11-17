unit dlgGotoMember;

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
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.VirtualImage,
  Vcl.BaseImageCollection,
  Vcl.ImageCollection,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  dmSCM2,
  dmIMG;

type
  TGotoMember = class(TForm)
    Panel1: TPanel;
    btnGoto: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    lblErrMsg: TLabel;
    Edit1: TEdit;
    vimgMember: TVirtualImage;
    vimgGoto: TVirtualImage;
    procedure FormCreate(Sender: TObject);
    procedure btnGotoClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    fMemberID: integer;
    function TestForMemberID(aMemberID: integer): boolean;

  public
    property MemberID: integer read fMemberID write fMemberID;

  end;

var
  GotoMember: TGotoMember;

implementation

{$R *.dfm}

function TGotoMember.TestForMemberID(aMemberID: integer): boolean;
var
  SQL: string;
  v: variant;
begin
  result := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    SQL := '''
      SELECT Count(MemberID)
      FROM dbo.Member
      WHERE MemberID = :ID
      ''';
    try
      begin
        v := SCM2.scmConnection.ExecSQL(SQL, [fMemberID]);
        if v = 1 then result := true;
      end;
    except
      on E: Exception do
        lblErrMsg.Caption := 'SCM DB access error.';
    end;
  end;
end;

procedure TGotoMember.btnCancelClick(Sender: TObject);
begin
  fMemberID := 0;
  ModalResult := mrCancel;
end;

procedure TGotoMember.btnGotoClick(Sender: TObject);
begin
  if (MemberID <> 0) and TestForMemberID(fMemberID) then
    ModalResult := mrOk
  else
  begin
    Beep;
    lblErrMsg.Caption := 'Member''s ID invalid.';
  end;
end;

procedure TGotoMember.Edit1Change(Sender: TObject);
var
  i: integer;
begin
  fMemberID := 0;
  if (Length(Edit1.Text) = 0) then
  begin
    lblErrMsg.Caption := '';
    exit;
  end;
  i := StrToIntDef(Edit1.Text, 0);
  if (i = 0) then
  begin
    lblErrMsg.Caption := '';
    exit;
  end;
  if TestForMemberID(i) then
  begin
    fMemberID := i;
    lblErrMsg.Caption := 'Member''s ID ..OK';
    exit;
  end
  else
  begin
    lblErrMsg.Caption := '...?';
    exit;
  end;
end;

procedure TGotoMember.FormCreate(Sender: TObject);
begin
  fMemberID := 0;
  lblErrMsg.Caption := '';
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then
    Close();
  // Triggers Edit1Change event.
  Edit1.Text := '';
end;

procedure TGotoMember.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    btnGotoClick(self)
  else
  begin
    if (Key = VK_ESCAPE) then
      btnCancelClick(self);
  end;
end;

procedure TGotoMember.FormShow(Sender: TObject);
begin
  Edit1.SetFocus;
end;



end.
