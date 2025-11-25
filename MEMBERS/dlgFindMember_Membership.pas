unit dlgFindMember_Membership;

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
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  dmSCM2, dmIMG;

type
  TFindMember_Membership = class(TForm)
    Panel1: TPanel;
    btnGoto: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    lblErrMsg: TLabel;
    Edit1: TEdit;
    vimgMember: TVirtualImage;
    vimgGoto: TVirtualImage;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnGotoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    fMemberID: integer;
    fMembershipNum: integer;
    function TestForMembershipNum(MembershipNum: integer): boolean;

  public
    property MemberID: integer read fMemberID write fMemberID;
    property MembershipNum: integer read fMembershipNum write fMembershipNum;
  end;

var
  FindMember_Membership: TFindMember_Membership;

implementation

{$R *.dfm}

function TFindMember_Membership.TestForMembershipNum(MembershipNum: integer): boolean;
var
  SQL: string;
  v: variant;

begin
  result := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    SQL := '''
      SELECT MemberID
      FROM dbo.Member
      WHERE MembershipNum = :ID
      ''';
    try
      begin
        v := SCM2.scmConnection.ExecSQL(SQL, [MembershipNum]);
        if not VarIsClear(v) then
        begin
          fMemberID := v;
          result := true;
        end;
      end;
    except
      on E: Exception do
        lblErrMsg.Caption := 'SCM DB access error.';
    end;
  end;
end;

procedure TFindMember_Membership.btnGotoClick(Sender: TObject);
begin
  if (fMembershipNum <> 0) and TestForMembershipNum(fMembershipNum) then
    ModalResult := mrOk
  else
  begin
    Beep;
    lblErrMsg.Caption := 'Membership number is invalid.';
  end;
end;

procedure TFindMember_Membership.Edit1Change(Sender: TObject);
begin
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
  if TestForMembershipNum(i) then
  begin
    fMembershipNum := i;
    lblErrMsg.Caption := 'Membership number ..OK.';
    exit;
  end
  else
  begin
    lblErrMsg.Caption := '...?';
    exit;
  end;
end;


end;

procedure TFindMember_Membership.FormCreate(Sender: TObject);
begin
  fMemberID := 0;
  fMembershipNum := 0;
  lblErrMsg.Caption := '';
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then
    Close();
  Edit1.Text := ''; // Triggers Edit1Change event.

end;

procedure TFindMember_Membership.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    btnGotoClick(self)
  else
  begin
    if (Key = VK_ESCAPE) then
    begin
      fMemberID := 0;
      fMembershipNum := 0;
      ModalResult := mrCancel;
    end;
  end;
end;

procedure TFindMember_Membership.FormShow(Sender: TObject);
begin
  Edit1.SetFocus;
end;



end.
