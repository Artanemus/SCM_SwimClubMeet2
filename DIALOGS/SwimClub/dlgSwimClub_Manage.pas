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
    AdvDBDTPicker: TAdvDBDateTimePicker;
    ts_LinkedClubs: TTabSheet;
    qryLinkedClubs: TFDQuery;
    gClubGroups: TDBAdvGrid;
    dsLinkedClubs: TDataSource;
    imgindxGroup: TSVGIconImage;
    actnNewGroup: TAction;
    qryClubGroup: TFDQuery;
    actnInfo: TAction;
    actnGroupSelect: TAction;
    actnGroupUpdate: TAction;
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
    procedure gSwimClubAnchorClick(Sender: TObject; ARow, ACol: Integer; Anchor:
        string; var AutoHandle: Boolean);
    procedure gSwimClubClick(Sender: TObject);
    procedure gSwimClubDblClick(Sender: TObject);
    procedure gSwimClubGetHTMLTemplate(Sender: TObject; ACol, ARow: Integer; var
        HTMLTemplate: string; Fields: TFields);
    procedure imgIndxArchiveClick(Sender: TObject);
    procedure splitvEditClosed(Sender: TObject);
    procedure splitvEditClosing(Sender: TObject);
    procedure splitvEditOpening(Sender: TObject);
  private
    fGridIsUpdating: Boolean;
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
  qryClubGroup.Open;

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
  // NOTE: this action traps VK_ESCAPE before event TForm.OnFormKeyDown is called.
  if splitvEdit.Opened then
    splitvEdit.Close // CheckBrowseMode will be called here.
  else
    ModalResult := mrOK;
end;

procedure TSwimClubManage.actnDeleteExecute(Sender: TObject);
var
  msgResults, ID, recNo: integer;
  msg: string;
begin
  {
    if qrySession.IsEmpty then .... is used, and 'hide closed session'
      is enabled  then the true count is not given due to the filtering
      and Master-Detailed relationship.
    Using the ExecSQLScalar function with SQL script - much safer.
  }

  ID := CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;
  recNo := CORE.qrySwimClub.RecNo;

  // clean up the UI
  gSwimClub.ClearSelection; // GRID : highlight 'nothing' and../
  try  // ...then set row selection to current record.
    gSwimClub.Row := gSwimClub.RealRowIndex(RecNo);
  finally
    actnDelete.Checked := false; // de-select buttons on the actnToolBar.
    if gSwimClub.CanFocus then
      gSwimClub.SetFocus; //lose focus on the ToolBar buttons
  end;

//  if gSwimClub.SelectedRowCount > 1 then
//  begin
//    MessageDlg('Deletion of multi-selected swimming clubs not currently implemented.', mtInformation, [mbOK], 0);
//    exit;
//  end;





{$IFDEF DEBUG}
  // DEBUG ..... HANDS OF THIS SWIMCLUB
  // DEBUG ... don't delete this club - used for demonstrating SCM.
  if ID = 1 then exit;
{$ELSE}
  if ID = 1 then exit;
{$ENDIF}

  // uses EXECSCALAR method to ensure it's empty.
  if uSwimClub.SessionCount = 0 then
  begin
    uSwimClub.Delete_SwimClub(false); // false = ignore locked states.
    exit;
  end;

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
  begin
    uSwimClub.Delete_SwimClub(false); // false = ignore locked states.
  end;
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
//  gSwimClub.BeginUpdate;
  CORE.dsSwimClub.Enabled := false;
  try
    try
      CORE.qrySwimClub.Insert; // defaults handled by CORE.OnNewRecord
      CORE.qrySwimClub.FieldByName('Caption').AsString := 'UNNAMED CLUB';
      CORE.qrySwimClub.Post;
      Success := true;
    except on E: Exception do
        CORE.qrySwimClub.Cancel;
    end;

    if Success then // Start editing the new club.
    begin
      CORE.qrySwimClub.Refresh; // ensured all ImageIndex values are correct.
      CORE.dsSwimClub.Enabled := true;
      gSwimClub.ClearSelection;
      try  // ...then set row selection to current record.
        gSwimClub.Row := gSwimClub.RealRowIndex(CORE.qrySwimClub.RecNo);
      finally
        actnNew.Checked := false; // de-select buttons on the actnToolBar.
        if gSwimClub.CanFocus then
          gSwimClub.SetFocus; // lose focus on the ToolBar buttons
      end;
    end;
  finally
//    gSwimClub.EndUpdate;
;
  end;
end;

procedure TSwimClubManage.actnNewGroupExecute(Sender: TObject);
var
  i, refSwimClubID, ASwimClubID: integer;
begin
  if gSwimClub.RowSelectCount > 1 then
  begin
    gSwimClub.BeginUpdate;
    try
      begin
        try  // create a new Club .. default values handle by CORE.OnNewRecord.
          CORE.qrySwimClub.Insert;
          CORE.qrySwimClub.FieldByName('IsClubGroup').AsBoolean := true;
          CORE.qrySwimClub.FieldByName('Caption').AsString := 'NEW CLUB GROUP';
          CORE.qrySwimClub.Post;

          // Get the newly created CLUBGROUP-SWIMCLUB.. Safe to do this in FireDAC.
          ASwimClubID := CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;


{  // Alternative method...
v := SCM2.scmConnection.ExecSQLScalar('SELECT IDENT_CURRENT (''dbo.SwimClub'');' );
if not VarIsClear(v) and (v=0) then  ASwimClubID := v;
}

{NOTE: on create - CLUBGROUP-SWIMCLUB is an additional selected row in grid!}

        except on E: Exception do
          begin
            CORE.qrySwimClub.Cancel;
            exit;
          end;
        end;

        if ASwimClubID <> 0 then
        begin
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
              refSwimClubID := StrToIntDef(gSwimClub.Cells[5, i], 0);
              // don't insert the CLUBGROUP-SWIMCLUB into table (it'll also be selected)
              if (refSwimClubID > 0) and (ASwimClubID <> refSwimClubID) then
              begin
                try
                  // Create a new ClubGroupRecord..
                  qryClubGroup.Insert;
                  // the linked swim club.
                  qryClubGroup.FieldByName('ClubLinkID').AsInteger := refSwimClubID;
                  // the newly created CLUBGROUP-SWIMCLUB
                  qryClubGroup.FieldByName('SwimClubID').AsInteger := ASwimClubID;
                  qryClubGroup.Post;
                except on E: Exception do
                  begin
                      qryClubGroup.Cancel;
                      break;
                  end;
                end;
              end;
            end;

          end;

          // locate grid at new record.
          CORE.qrySwimClub.Refresh; // ensured all ImageIndex values are correct.
          gSwimClub.ClearSelection;
          gSwimClub.Row := gSwimClub.RealRowIndex(CORE.qrySwimClub.RecNo);
          gSwimClub.Invalidate;
        end;
      end;
    finally
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
    CORE.qrySwimClub.CheckBrowseMode; // ASSERT - finalize all editing.
    if fGridIsUpdating then gSwimClub.EndUpdate;
    if splitvEdit.Opened then splitvEdit.Close;
end;

procedure TSwimClubManage.FormKeyDown(Sender: TObject; var Key: Word; Shift:
  TShiftState);
begin
  // TAction - actnExit traps VK_ESCAPE (HotKey ESC has been assigned)
  // and this event never gets called ... (TForm.KeyPreview = true.)
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    CORE.qrySwimClub.CheckBrowseMode; // ASSERT STATE...
    ModalResult := mrCancel;
  end;
end;

procedure TSwimClubManage.gSwimClubAnchorClick(Sender: TObject; ARow, ACol:
    Integer; Anchor: string; var AutoHandle: Boolean);
begin
  // Check if the clicked anchor matches our custom action string
  if Anchor = 'IMAGE_CLICK_ACTION' then
  begin
    if (CORE.qrySwimClub.RecNo <> gSwimclub.GetRealRow) then
      CORE.qrySwimClub.RecNo := gSwimclub.GetRealRow;

    // The image was clicked, so perform the desired action.
    ShowMessage('Image in cell (' + IntToStr(ACol) + ',' + IntToStr(ARow) + ') was clicked!');

    // Prevent the grid from trying to open "IMAGE_CLICK_ACTION" as a URL
    AutoHandle := False;
  end;
end;

procedure TSwimClubManage.gSwimClubClick(Sender: TObject);
begin
(*
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
*)
  if (CORE.qrySwimClub.RecNo <> gSwimclub.GetRealRow) then
    CORE.qrySwimClub.RecNo := gSwimclub.GetRealRow;

end;

procedure TSwimClubManage.gSwimClubDblClick(Sender: TObject);
begin
    actnEdit.Checked := true;
    actnEditExecute(actnEdit); // this works.
end;

procedure TSwimClubManage.gSwimClubGetHTMLTemplate(Sender: TObject; ACol, ARow:
  Integer; var HTMLTemplate: string; Fields: TFields);
var
  htmlStr: string;
begin
  htmlStr := '';
  if (ARow >= gSwimClub.FixedRows) then
  begin
    if CORE.qrySwimClub.FieldByName('IsClubGroup').AsBoolean then
    begin
      htmlStr := '''
    <FONT size="12"><A HREF="IMAGE_CLICK_ACTION"><IMG SRC="idx:0"></A>  <#Caption></FONT>
    <FONT size="8"></FONT><#NickName>
    ''';
    end
    else
    begin
      htmlStr := '''
    <FONT size="12"><#SwimClubID>:  <#Caption></FONT>
    <FONT size="8"></FONT><#NickName>
    ''';
    end;
    if not htmlStr.IsEmpty then
    begin
      HTMLTemplate := htmlStr;
    end;

  end;
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

procedure TSwimClubManage.splitvEditClosed(Sender: TObject);
begin
  gSwimClub.ClearSelection; // clean up the UI
  actnEdit.Checked := false; // de-select buttons on the actnToolBar.
end;

procedure TSwimClubManage.splitvEditClosing(Sender: TObject);
begin
  CORE.qrySwimClub.CheckBrowseMode;
  CORE.qrySwimClub.Refresh; // Updates qrySwimClub.imgIndxArchived value.
  qryLinkedClubs.Close;
  if fGridIsUpdating then
  begin
    gSwimClub.EndUpdate; // Enable changes in TMS grid.
    fGridIsUpdating := false;
  end;
end;

procedure TSwimClubManage.splitvEditOpening(Sender: TObject);
begin
  // prepare the IsArchived icon image.
  imgIndxArchive.ImageIndex :=
  CORE.qrySwimClub.FieldByName('imgIndxArchived').AsInteger;

  gSwimClub.BeginUpdate; // disable changes in TMS grid.
  fGridIsUpdating := true; // store TMS update state...

  // E D I T   R E C O R D . ===============================
  if not (CORE.qrySwimClub.State in [dsEdit, dsInsert]) then
    CORE.qrySwimClub.Edit;

  // UI init...
  if CORE.qrySwimClub.FieldByName('IsClubGroup').AsBoolean then
  begin
    lblClubName.Caption := 'Group Name';
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
    // build table with information on linked clubs - read only.
    qryLinkedClubs.Close;
    qryLinkedClubs.ParamByName('SWIMCLUBID').AsInteger :=
    CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;
    qryLinkedClubs.Prepare;
    qryLinkedClubs.Open;
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
    DBTextPrimaryKey.Visible := false;
    imgindxGroup.Visible := false;
    ts_LinkedClubs.TabVisible := false; // doesn't apply to 'Clubs'
    tsMain.TabVisible := true;
    tsLogo.TabVisible := true;
  end;
  pcntrlEdit.ActivePageIndex := 0; // default to tabsheet 'tsMAIN'

end;

end.
