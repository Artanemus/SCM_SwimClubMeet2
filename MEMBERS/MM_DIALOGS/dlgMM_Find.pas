unit dlgMM_Find;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants,
  System.Classes, System.UITypes,

  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,

  dmSCM2, dmMM_CORE, dmIMG, SVGIconImage;

type
  TMM_Find = class(TForm)
    btnGotoID: TButton;
    btnGotoMembershipNum: TButton;
    btnFindFName: TButton;
    btnCancel: TButton;
    imgFind: TSVGIconImage;
    lblFind: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnFindFNameClick(Sender: TObject);
    procedure btnGotoIDClick(Sender: TObject);
    procedure btnGotoMembershipNumClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    function GotoMember(MemberID: Integer): Boolean;

  public
    { Public declarations }
  end;

var
  MM_Find: TMM_Find;

implementation

uses
  dlgMM_Find_ID, dlgMM_Find_Membership, dlgMM_Find_FName;

{$R *.dfm}

procedure TMM_Find.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TMM_Find.btnFindFNameClick(Sender: TObject);
var
  dlg: TFindMember_FName;
begin
  Visible := False;
  dlg := TFindMember_FName.Create(Self);
  if IsPositiveResult(dlg.ShowModal()) then
    GotoMember(dlg.MemberID); // LOCATE MEMBER IN qryMember
  dlg.Free;
  Close();
end;

procedure TMM_Find.btnGotoIDClick(Sender: TObject);
var
  dlg: TFindMember_ID;
  rtn: TModalResult;
begin
  if assigned(MM_CORE) then
  begin
    Visible := False;
    dlg := TFindMember_ID.Create(Self);
    rtn := dlg.ShowModal();
    if IsPositiveResult(rtn) then
      GotoMember(dlg.MemberID);  // LOCATE MEMBER IN qryMember
    dlg.Free;
    Close();
  end;
end;

procedure TMM_Find.btnGotoMembershipNumClick(Sender: TObject);
var
  dlg: TFindMember_Membership;
  rtn: TModalResult;
begin
  if assigned(MM_CORE) then
  begin
    Visible := False;
    dlg := TFindMember_Membership.Create(Self);
    rtn := dlg.ShowModal;
    if IsPositiveResult(rtn) then
      GotoMember(dlg.MemberID); // LOCATE MEMBER IN qryMember
    dlg.Free;
    Close();
  end;
end;

procedure TMM_Find.FormKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if (Key = VK_ESCAPE) then
  begin
    Key := 0;
    ModalResult := mrCancel;
  end;
end;

function TMM_Find.GotoMember(MemberID: Integer): Boolean;
var
  b: Boolean;
  s: string;
  rtn: TModalResult;
begin
  result := false;
  b := MM_CORE.LocateMember(MemberID);
  if b then
    result := true
  else
  begin
    s := '"Filters" must to be cleared to display this member.' + sLinebreak +
      'Clear the filters?';
    rtn := MessageDlg(s, TMsgDlgType.mtConfirmation, mbYesNo, 0);
    if IsPositiveResult(rtn) then
    begin
      MM_CORE.UpdateFilterByParam(false, false, false); // clear filter params.
      b := MM_CORE.LocateMember(MemberID);
      if b then
        result := true;
    end;
  end;
end;


end.
