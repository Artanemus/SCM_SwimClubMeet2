unit frFrameSwimClub;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.DBCtrls, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, SVGIconImage, Vcl.ComCtrls,
  dmSCM2, dmCORE,  uSwimClub, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, Data.Bind.Components,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  frFrame2ClubGroup;

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
    luUnitType: TDataSource;
    tblUnitType: TFDTable;
    pnlCG: TPanel;
  private
    { Private declarations }
    FIsClubGroup: boolean;
    frCG: TFrame2ClubGroup;

    // Link Icon image to data change.
    FDataLink: TFieldDataLink;
    procedure DataLinkDataChange(Sender: TObject);

  protected
    procedure Loaded; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Prepare();
    procedure SetDataSource(ADataSource: TDataSource);
    procedure CheckAndSaveData();
  end;

implementation

{$R *.dfm}

{ TFrameSwimClub }

procedure TFrameSwimClub.CheckAndSaveData;
begin
  if (Assigned(frCG) and frCG.IsChanged) then
  begin
    frCG.CheckAndSaveData;
  end;
end;

constructor TFrameSwimClub.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Use for:
  // - Initializing non-visual fields (integers, strings, objects)
  // - Setting default property values
  // - Creating objects that don't depend on child components
  // - DO NOT access child components (they don't exist yet!)

  FIsClubGroup := false;

end;

procedure TFrameSwimClub.Loaded;
begin
  // Loaded can be called multiple times (in rare cases)
  inherited;

  if not Assigned(SCM2) or not SCM2.scmConnection.connected then exit;
  if not Assigned(CORE) or not CORE.IsActive then exit;


  if not Assigned(FDataLink) then
  begin
    // create
    FDataLink := TFieldDataLink.Create;
    FDataLink.OnDataChange := DataLinkDataChange;
  end;

  if not Assigned(frCG) then
  begin
     frCG := TFrame2ClubGroup.Create(Self);
    // PREPARE CLUB GROUP FRAME.  exception error!!!!!!!!!!
    frCG.Parent := pnlCG; // should work if tab is visible?
    frCG.Align := alClient;
    frCG.Prepare(PK);
  end;

end;

procedure TFrameSwimClub.DataLinkDataChange(Sender: TObject);
begin
  if Assigned(FDataLink.DataSource) and
     Assigned(FDataLink.DataSource.DataSet) then
  begin
    // You can check the actual field value directly
    if FDataLink.DataSource.DataSet.FieldByName('IsArchived').AsBoolean then
      imgIndxArchive.ImageIndex := 1
    else
      imgIndxArchive.ImageIndex := 0;
  end;
end;

destructor TFrameSwimClub.Destroy;
begin
  // Explicit free - optional but good practice
  // This is safe even if nil

  frCG.Free;
  FDataLink.Free;

  inherited;
end;

procedure TFrameSwimClub.Prepare;
var
  PK: integer;
begin

  SetDataSource(CORE.dsSwimClub);

  tblUnitType.Connection := SCM2.scmConnection;
  try
    tblUnitType.Open;
  except
    on E: EFDDBEngineException do
      SCM2.FDGUIxErrorDialog.Execute(E);
  end;

  // IsArchived icon image.
  imgIndxArchive.ImageIndex :=
  CORE.qrySwimClub.FieldByName('imgIndxArchived').AsInteger;
  FIsClubGroup := false;

  if Assigned(frCG) then
      frCG.IsChanged := false;;

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
    ts_LinkedClubs.TabVisible := true;
    pnlCG.Visible := true;   // 'Group Club' info on linked clubs.
    tsMain.TabVisible := true;
    tsLogo.TabVisible := true;

    if Assigned(frCG) then
      frCG.Prepare(PK);

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
    ts_LinkedClubs.TabVisible := true;
//    pnlCG.Visible := false;  // doesn't apply to none grouped Clubs.
    tsMain.TabVisible := true;
    tsLogo.TabVisible := true;
  end;

  pcntrlEdit.ActivePageIndex := 0; // default to tabsheet 'tsMAIN'

end;

procedure TFrameSwimClub.SetDataSource(ADataSource: TDataSource);
begin
  FDataLink.DataSource := ADataSource;
  // Optionally specify a specific field
  FDataLink.FieldName := 'IsArchived';
end;

end.
