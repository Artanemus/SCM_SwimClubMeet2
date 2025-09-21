unit dlgSwimClub_Manage;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,

  Data.DB,

  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.ExtCtrls, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtDlgs, Vcl.DBCtrls, Vcl.Mask, Vcl.WinXCtrls,
  Vcl.Grids,

  dmIMG, dmCORE, dmSCM2,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid, SVGIconImage,
  AdvDateTimePicker, AdvDBDateTimePicker, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client
  ;

type
  TSwimClubManage = class(TForm)
    pnlHeader: TPanel;
    actnToolBar: TActionToolBar;
    actnSwimClub: TActionManager;
    actnEdit: TAction;
    actnNew: TAction;
    actnDelete: TAction;
    pnlBody: TPanel;
    gSwimClub: TDBAdvGrid;
    pnlTools: TPanel;
    pcntrlEdit: TPageControl;
    tsMain: TTabSheet;
    tsLogo: TTabSheet;
    SaveLogoDlg: TSavePictureDialog;
    OpenLogoDlg: TOpenPictureDialog;
    DBLogo: TDBImage;
    btnLoadClubLogo: TButton;
    btnSaveClubLogo: TButton;
    btnClearClubLogo: TButton;
    lblLogoHintTxt: TLabel;
    lblClubName: TLabel;
    lblNickname: TLabel;
    lblEmail: TLabel;
    lblContactNum: TLabel;
    lblWebSite: TLabel;
    lblNumOfLanes: TLabel;
    lblPoolLength: TLabel;
    lblMeters: TLabel;
    lblSeasonStart: TLabel;
    DBClubName: TDBEdit;
    DBNickName: TDBEdit;
    DBEmail: TDBEdit;
    DBContactNum: TDBEdit;
    DBWebSite: TDBEdit;
    DBEditNumOfLanes: TDBEdit;
    DBPoolLength: TDBEdit;
    actnArchive: TAction;
    splitvEdit: TSplitView;
    lblIsArchived: TLabel;
    imgIndxArchive: TSVGIconImage;
    actnClose: TAction;
    DBTextPrimaryKey: TDBText;
    lblPrimaryKey: TLabel;
    AdvDBDTPicker: TAdvDBDateTimePicker;
    ts_LinkedClubs: TTabSheet;
    qryLinkedClubs: TFDQuery;
    gClubGroups: TDBAdvGrid;
    dsLinkedClubs: TDataSource;
    imgindxGroup: TSVGIconImage;
    actnNewGroup: TAction;
    qryClubGroup: TFDQuery;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actnArchiveExecute(Sender: TObject);
    procedure actnCloseExecute(Sender: TObject);
    procedure actnDeleteExecute(Sender: TObject);
    procedure actnEditExecute(Sender: TObject);
    procedure actnGenericUpdate(Sender: TObject);
    procedure actnNewExecute(Sender: TObject);
    procedure actnNewGroupExecute(Sender: TObject);
    procedure actnNewGroupUpdate(Sender: TObject);
    procedure btnClearClubLogoClick(Sender: TObject);
    procedure btnLoadClubLogoClick(Sender: TObject);
    procedure btnSaveClubLogoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure gSwimClubDblClick(Sender: TObject);
    procedure imgIndxArchiveClick(Sender: TObject);
    procedure splitvEditClosing(Sender: TObject);
    procedure splitvEditOpening(Sender: TObject);
  private
    fGridIsUpdating: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SwimClubManage: TSwimClubManage;

implementation

uses
  uSwimClub;

{$R *.dfm}

procedure TSwimClubManage.FormDestroy(Sender: TObject);
begin
  CORE.qrySwimClub.IndexName := 'indxHideArchived';
end;

procedure TSwimClubManage.FormCreate(Sender: TObject);
begin
  // reveal archived swimming clubs which are by default hidden.
  CORE.qrySwimClub.IndexName := 'indxShowAll';
  fGridIsUpdating := false;
  // bring UI to the correct display state.
  splitvEdit.UseAnimation := false;
  splitvEdit.Opened := false;
  splitvEdit.UseAnimation := true;
  if pcntrlEdit.ActivePageIndex <> 0 then pcntrlEdit.ActivePageIndex := 0;
end;

procedure TSwimClubManage.actnArchiveExecute(Sender: TObject);
begin
  // Speedbutton to 'quick toggle' the boolean field IsArchived.
  gSwimClub.BeginUpdate;
  CORE.qrySwimClub.Edit;
  CORE.qrySwimClub.FieldByName('IsArchived').AsBoolean := not
    CORE.qrySwimClub.FieldByName('IsArchived').AsBoolean;
  CORE.qrySwimClub.Post;
  // refreshing will updates qrySwimClub.imgIndxArchived scripted value.
  CORE.qrySwimClub.Refresh;
  gSwimClub.EndUpdate;
end;

procedure TSwimClubManage.actnCloseExecute(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TSwimClubManage.actnDeleteExecute(Sender: TObject);
var
  msgResults, ID: integer;
  msg: string;
begin
  {
    if qrySession.IsEmpty then .... is used, and 'hide closed session'
      is enabled  then the true count is not given due to the filtering
      and Master-Detailed relationship.
    Using the ExecSQLScalar function with SQL script - much safer.
  }
  ID := CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;

{$IFDEF DEBUG}
  // DEBUG ..... HANDS OF THIS SWIMCLUB
  // DEBUG ... don't delete this club - used for demonstrating SCM.
  if ID = 1 then exit;
{$ELSE}
  if ID = 1 then exit;
{$ENDIF}

  // uses EXECSCALAR method to ensure it's empty.
  if uSwimClub.SessionCount = 0 then
    uSwimClub.Delete_SwimClub(false); // false = ignore locked states.

  // We have sessions. Are there any locked sessions?
  if uSwimClub.HasLockedSession then
  begin
    msg := '''
    This club has locked session!
    Deleting it will remove all sessions (Locked or Unlocked).

    Are you sure you want to delete this club?
    ''';
    msgResults := MessageBox(0, PChar(msg), PChar('Delete Swimming Club ...'),
      MB_ICONEXCLAMATION or MB_YESNO or MB_DEFBUTTON2);
    if msgResults <> IDYES then exit;
  end;

  if uSwimClub.HasRaceData then
  begin
    msg := '''
      This club has session data. Deleting it will remove all sessions, events, heats, and race times.
      Members will be unassigned (not deleted).

      Tip: Archiving is safer than losing valuable data.

      Are you sure you want to delete this club?
      ''';
    msgResults := MessageBox(0, PChar(msg), PChar('Delete Swimming Club ...'),
      MB_ICONEXCLAMATION or MB_YESNO or MB_DEFBUTTON2);
    if msgResults <> IDYES then exit;
  end;
      
  // If empty of race-data, wit: Event were not run and heats have no
  // race-times, then the crypt isn't stone-walled by warning messages.
  msg := '''
    Just checking�

    Deleting this club will permanently remove all its data.
    Are you sure you want to continue?
    ''';
  msgResults := MessageBox(0, PChar(msg), PChar('Delete Swimming Club ...'),
    MB_ICONEXCLAMATION or MB_YESNO or MB_DEFBUTTON2);

  if (msgResults = IDYES) then
    uSwimClub.Delete_SwimClub(false); // false = ignore locked states.
end;

procedure TSwimClubManage.actnEditExecute(Sender: TObject);
begin
  if TAction(Sender).Checked then
    splitvEdit.Open
  else
    splitvEdit.Close;
end;

procedure TSwimClubManage.actnGenericUpdate(Sender: TObject);
var
DoEnable: boolean;
begin
  DoEnable := false;
  // Is the table begin modified? (used by buttons, new, delete, archive)
  if not (CORE.qrySwimClub.State in [dsEdit, dsInsert]) then
  DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TSwimClubManage.actnNewExecute(Sender: TObject);
var
  success: boolean;
begin
  success := false;
  try
    CORE.qrySwimClub.Insert; // defaults handled by CORE.OnNewRecord
    CORE.qrySwimClub.Post;
    Success := true;
  except on E: Exception do
      CORE.qrySwimClub.Cancel;
  end;
  if Success then // Start editing the new club.
  begin
    CORE.qrySwimClub.Refresh; // ensured all ImageIndex values are correct.
    actnEdit.Checked := true;
    actnEditExecute(actnEdit);
  end;
end;

procedure TSwimClubManage.actnNewGroupExecute(Sender: TObject);
var
  i, recNo, ASwimClubID: integer;
  txt, SQL: string;
begin
  txt := '';

  if gSwimClub.RowSelectCount > 1 then
  begin
    gSwimClub.BeginUpdate;
    try
      begin
        try  // create a new Club .. default values handle by CORE.OnNewRecord.
          CORE.qrySwimClub.Insert;
          CORE.qrySwimClub.FieldByName('IsClubGroup').AsBoolean := true;
          CORE.qrySwimClub.FieldByName('Caption').AsString := 'CLUB GROUP;';
          CORE.qrySwimClub.Post;
        except on E: Exception do
          begin
            CORE.qrySwimClub.Cancel;
            exit;
          end;
        end;
        // RECOMMENDED Method..
        ASwimClubID := SCM2.scmConnection.ExecSQLScalar('SELECT CAST(SCOPE_IDENTITY() AS INT);');
        // Loop through all data rows in the grid..
        for i := gSwimClub.FixedRows to gSwimClub.RowCount - 1 do
        begin
          // Check if the row is 'selected ROW'
          if gSwimClub.RowSelect[i] then
          begin
            // if the row is a 'GROUP' club - then skip
            if (StrToIntDef(gSwimClub.Cells[4, i], 0) = 1) then
              continue; // sorry 'group inception' is not allowed...

            // get the SwimClubID of the 'selected row'.
            recNo := StrToIntDef(gSwimClub.Cells[5, i], 0);
            if recNo > 0 then
            begin
              try
                // Create a new ClubGroupRecord..
                qryClubGroup.Insert;
                // the linked id value.
                qryClubGroup.FieldByName('ClubLinkID').AsInteger := recNo;
                // the newly created GROUP SWIMCLUB ID
                qryClubGroup.FieldByName('SwimClubID').AsInteger := ASwimClubID;
                qryClubGroup.Post;
              except on E: Exception do
                  qryClubGroup.Cancel;
              end;
              // it would be sweet to build some text for the NickName field.
              txt := txt + ' ' + IntToStr(recNo);
            end;
          end;
        end;
        if not txt.IsEmpty then
        begin // a string of numbers...
          SQL := 'UPDATE [SwimClubMeet2].[dbo].[SwimClub] SET [NickName] = :ID1 WHERE SwimClubID = :ID2;';
          SCM2.scmConnection.ExecSQL(SQL, [txt, ASwimClubID]);
        end;
      end;
    finally
      CORE.qrySwimClub.Refresh; // ensured all ImageIndex values are correct.
      gSwimClub.EndUpdate;
    end;
  end;
end;

procedure TSwimClubManage.actnNewGroupUpdate(Sender: TObject);
var
DoEnable: boolean;
begin
  DoEnable := false;
  // Is the table begin modified? (used by buttons, new, delete, archive)
  if not (CORE.qrySwimClub.State in [dsEdit, dsInsert]) then
  begin
    if (gSwimClub.RowSelectCount > 1) then
      DoEnable := true;
  end;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TSwimClubManage.btnClearClubLogoClick(Sender: TObject);
begin
  if (CORE.qrySwimClub.State = dsEdit) or (CORE.qrySwimClub.State = dsInsert)
    then
  begin
    CORE.qrySwimClub.FieldByName('LogoDir').Clear;
    CORE.qrySwimClub.FieldByName('LogoImg').Clear;
    CORE.qrySwimClub.FieldByName('LogoType').Clear;
  end;
end;

procedure TSwimClubManage.btnLoadClubLogoClick(Sender: TObject);
begin
  if (CORE.qrySwimClub.State = dsEdit) or (CORE.qrySwimClub.State = dsInsert)
    then
  begin
    // NOTE: TOpenPictureDialog.options - ofPathMustExist, ofFileMustExist.
    if (OpenLogoDlg.Execute) then
    begin
      try
        (CORE.qrySwimClub.FieldByName('LogoImg') as TBlobField)
          .LoadFromFile(OpenLogoDlg.FileName);
      except on E: Exception do
        // handle error.
      end;
    end;
  end;
end;

procedure TSwimClubManage.btnSaveClubLogoClick(Sender: TObject);
begin
  if (CORE.qrySwimClub.State = dsEdit) or (CORE.qrySwimClub.State = dsInsert)
    then
  begin
    if (SaveLogoDlg.Execute) then
    begin
      try
        (CORE.qrySwimClub.FieldByName('LogoImg') as TBlobField)
        .SaveToFile(SaveLogoDlg.FileName);
      except on E: Exception do
        // handle error
      end;
    end;
  end;
end;

procedure TSwimClubManage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    CORE.qrySwimClub.CheckBrowseMode; // finalize all editing.
    if fGridIsUpdating then gSwimClub.EndUpdate;
    if splitvEdit.Opened then splitvEdit.Close;
end;

procedure TSwimClubManage.FormKeyDown(Sender: TObject; var Key: Word; Shift:
  TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    {
    if splitvEdit.Opened then
    begin
      Key := 0;
      splitvEdit.Close;
      actnEdit.Checked := false;
    end
    }
    Key := 0;
    CORE.qrySwimClub.CheckBrowseMode;
    ModalResult := mrCancel;
  end;
end;

procedure TSwimClubManage.gSwimClubDblClick(Sender: TObject);
begin
    actnEdit.Checked := true;
    actnEditExecute(actnEdit); // this works.
end;

procedure TSwimClubManage.imgIndxArchiveClick(Sender: TObject);
begin
  if (CORE.qrySwimClub.State = dsEdit) or (CORE.qrySwimClub.State = dsInsert) then
  begin
    // toggle boolean
    CORE.qrySwimClub.FieldByName('IsArchived').AsBoolean := not
      CORE.qrySwimClub.FieldByName('IsArchived').AsBoolean;
    // paint the correct icon
    imgIndxArchive.ImageIndex :=
      ORD(CORE.qrySwimClub.FieldByName('IsArchived').AsBoolean);
  end;
end;

procedure TSwimClubManage.splitvEditClosing(Sender: TObject);
var
i, RecNo: integer;

begin



  if (CORE.qrySwimClub.State = dsEdit) or (CORE.qrySwimClub.State = dsInsert) then
  begin
    CORE.qrySwimClub.Post; // finalize changes..
    CORE.qrySwimClub.Refresh; // Updates qrySwimClub.imgIndxArchived value.
  end;

  { FIX the HTML cell not moving the record selector - wit DB unsynced
    On cell click this routine is call twice. Probably mouse down, then
    mouse up.
    After mouse up the GetRealRow will be equal to ARow.
    Assigning RecNo will move the record selector and the HTML cell
    is painted with the correct data.
  }
  RecNo := gSwimclub.GetRealRow;
  if (RecNo >= 0) and (RecNo < CORE.qrySwimClub.RecordCount) then
    CORE.qrySwimClub.RecNo := RecNo;

  { FIX row selection.
    Often a range of rows are selected. Force single selection of row.}
  if ([goRangeSelect, goEditing] * gSwimclub.Options) <> [] then
  begin
    gSwimclub.Options := gSwimclub.Options - [goRangeSelect, goEditing] + [goRowSelect];
  end;
  gSwimclub.SelectRows(RecNo, 1);

  if fGridIsUpdating then
  begin
    gSwimClub.EndUpdate; // Enable control changes
    fGridIsUpdating := false;
  end;
end;

procedure TSwimClubManage.splitvEditOpening(Sender: TObject);
begin
  // prepare the IsArchived icon image.
  imgIndxArchive.ImageIndex :=
    CORE.qrySwimClub.FieldByName('imgIndxArchived').AsInteger;
  gSwimClub.BeginUpdate; // disable control changes
  fGridIsUpdating := true; // store state...
  // other stuff...to init...
  if not (CORE.qrySwimClub.State in [dsEdit, dsInsert]) then
    CORE.qrySwimClub.Edit;
  if CORE.qrySwimClub.FieldByName('IsClubGroup').AsBoolean then
  begin
    lblClubName.Caption := 'Group Name';
    lblNickname.Caption := 'Group Nickname';
    lblEmail.Visible := false;
    lblWebSite.Visible := false;
    lblContactNum.Visible := false;
    DBEmail.Visible := false;
    DBWebSite.Visible := false;
    DBContactNum.Visible := false;
    imgindxGroup.Visible := true;
  end
  else
  begin
    lblClubName.Caption := 'Club Name';
    lblNickname.Caption := 'Club Nickname';
    lblEmail.Visible := true;
    lblWebSite.Visible := true;
    lblContactNum.Visible := true;
    DBEmail.Visible := true;
    DBWebSite.Visible := true;
    DBContactNum.Visible := true;
    imgindxGroup.Visible := false;
  end;
end;

end.
