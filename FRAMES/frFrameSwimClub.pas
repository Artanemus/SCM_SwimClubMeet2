unit frFrameSwimClub;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frFrameClubGroup,
  Vcl.DBCtrls, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, SVGIconImage, Vcl.ComCtrls,
  dmSCM2, dmCORE,  uSwimClub, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFrameSwimClub = class(TFrame)
    pcntrlEdit: TPageControl;
    tsMain: TTabSheet;
    lblClubName: TLabel;
    lblNickname: TLabel;
    lblNumOfLanes: TLabel;
    lblPoolLength: TLabel;
    imgIndxArchive: TSVGIconImage;
    DBTextPrimaryKey: TDBText;
    imgindxGroup: TSVGIconImage;
    lblClubType: TLabel;
    lblQualifyType: TLabel;
    lblUnitType: TLabel;
    lblCourseType: TLabel;
    DBTextCourseType: TDBText;
    DBTextLengthOfPool: TDBText;
    DBTextUnitType: TDBText;
    DBClubName: TDBEdit;
    DBNickName: TDBEdit;
    DBEditNumOfLanes: TDBEdit;
    dblucmbClubType: TDBLookupComboBox;
    dbcboxArchive: TDBCheckBox;
    dblucmbPoolType: TDBLookupComboBox;
    btnClearClubType: TButton;
    btnClearPoolType: TButton;
    tsOptions2: TTabSheet;
    lblEmail: TLabel;
    lblWebSite: TLabel;
    lblContactNum: TLabel;
    lblAddress: TLabel;
    DBContactNum: TDBEdit;
    DBWebSite: TDBEdit;
    DBEmail: TDBEdit;
    DBMemoAddress: TDBMemo;
    tsLogo: TTabSheet;
    lblLogoHintTxt: TLabel;
    DBLogo: TDBImage;
    btnLoadClubLogo: TButton;
    btnSaveClubLogo: TButton;
    btnClearClubLogo: TButton;
    ts_LinkedClubs: TTabSheet;
    CGFrame: TFrameClubGroup;
    luUnitType: TDataSource;
    tblUnitType: TFDTable;
  private
    { Private declarations }
    FIsClubGroup: boolean;
  protected
    procedure Loaded; override;

  public
    procedure Prepare();
    procedure Finalize();
  end;

implementation

{$R *.dfm}

{ TFrameSwimClub }

procedure TFrameSwimClub.Finalize;
begin
  CORE.qrySwimClub.CheckBrowseMode;
  {
    Trap possible UI condition...
    if focus is still on FrameClubGroup when finalize is called then
    FrameClubGroup.OnExit hasn't been called and we are
    missing an update to the SwimClubGroup state.
  }
  CGFrame.OnExit(Self);
end;

procedure TFrameSwimClub.Loaded;
begin
  inherited;
  if not Assigned(SCM2) or not SCM2.scmConnection.connected then exit;
  if not Assigned(CORE) or not CORE.IsActive then exit;
  tblUnitType.Connection := SCM2.scmConnection;
end;

procedure TFrameSwimClub.Prepare;
var
  PK: integer;
begin
  // prepare the IsArchived icon image.
  imgIndxArchive.ImageIndex :=
  CORE.qrySwimClub.FieldByName('imgIndxArchived').AsInteger;
  FIsClubGroup := false;

  // When Swimming Club is a Group then PK = ParentClubID.
  PK := CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;

  // E N T E R   E D I T   R E C O R D .
  if not (CORE.qrySwimClub.State in [dsEdit, dsInsert]) then
    CORE.qrySwimClub.Edit;

  // UI init...
  if CORE.qrySwimClub.FieldByName('IsClubGroup').AsBoolean then
  begin
    FIsClubGroup := true;
    lblClubName.Caption := 'Group Name*';
    lblNickname.Caption := 'Description';
    lblEmail.Visible := false;
    lblWebSite.Visible := false;
    lblContactNum.Visible := false;
    DBEmail.Visible := false;
    DBWebSite.Visible := false;
    DBContactNum.Visible := false;
    DBTextPrimaryKey.Visible := true;
    imgindxGroup.Visible := true;
    ts_LinkedClubs.TabVisible := true; // 'Group Club' info on linked clubs.
    tsMain.TabVisible := true;
    tsLogo.TabVisible := true;

    // PREPARE CLUB GROUP FRAME.
    CGFrame.Prepare(PK)

  end
  else
  begin
    lblClubName.Caption := 'Club Name*';
    lblNickname.Caption := 'Club Nickname*';
    lblEmail.Visible := true;
    lblWebSite.Visible := true;
    lblContactNum.Visible := true;
    DBEmail.Visible := true;
    DBWebSite.Visible := true;
    DBContactNum.Visible := true;
    DBTextPrimaryKey.Visible := false;
    imgindxGroup.Visible := false;
    ts_LinkedClubs.TabVisible := false; // doesn't apply to none grouped Clubs.
    tsMain.TabVisible := true;
    tsLogo.TabVisible := true;
  end;

  pcntrlEdit.ActivePageIndex := 0; // default to tabsheet 'tsMAIN'

end;

end.
