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
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, hintlist, f_FrameClubGroup
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
    imgindxGroup: TSVGIconImage;
    actnNewGroup: TAction;
    qrySwimClubGroup: TFDQuery;
    actnInfo: TAction;
    actnGroupSelect: TAction;
    actnGroupUpdate: TAction;
    hintInfo: TBalloonHint;
    FrSCG: TFrClubGroup;
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
    // if row=0 then Grid's focused display row number is used.
    procedure SyncDBtoGrid(AMethod: integer; ARow: integer = 0);
    // ScrollInView currently not enabled...
    procedure SyncGridToDB(AMethod: integer);
  protected

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
  qrySwimClubGroup.Open;

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
    gSwimClub.Row := gSwimClub.DisplRowIndex(RecNo);
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
  try
    CORE.qrySwimClub.Insert; // defaults handled by CORE.OnNewRecord
    CORE.qrySwimClub.FieldByName('Caption').AsString := 'NEW UNNAMED CLUB';
    CORE.qrySwimClub.Post;
    Success := true;
  except on E: Exception do
      CORE.qrySwimClub.Cancel;
  end;

  if Success then // Fix UI selection. Sync to database
  begin
    CORE.qrySwimClub.Refresh; // ensured all ImageIndex values are correct.
    SyncGridToDB(1);
  end;
end;

procedure TSwimClubManage.actnNewGroupExecute(Sender: TObject);
var
  i, ChildClubID, ParentClubID: integer;
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
          ParentClubID := CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;
        {  // Alternative method...
        v := SCM2.scmConnection.ExecSQLScalar('SELECT IDENT_CURRENT (''dbo.SwimClub'');' );
        if not VarIsClear(v) and (v=0) then  ParentClubID := v;
        }

        {NOTE: because we have created a new CLUBGROUP-SWIMCLUB
          it's has 'focus' and counts as a selected row in grid!
          CONSIDER: To avoid this, get all the selected 'clubs' then create.
        }

        except on E: Exception do
          begin
            CORE.qrySwimClub.Cancel;
            exit;
          end;
        end;

        if ParentClubID <> 0 then
        begin
          // Loop through all data rows in the grid..
          for i := gSwimClub.FixedRows to gSwimClub.RowCount - 1 do
          begin
            // Check if the row is 'selected ROW'
            if gSwimClub.RowSelect[i] then
            begin
              // if the row is a 'GROUP' club - then skip
              if (StrToIntDef(gSwimClub.Cells[4, i], 0) = 1) then
                continue; // sorry, 'group inception' is not allowed...

              // get the SwimClubID (ChildClub) of the 'selected row'.
              ChildClubID := StrToIntDef(gSwimClub.Cells[5, i], 0);
              // don't insert the CLUBGROUP-SWIMCLUB into table (it'll also be selected)
              if (ChildClubID > 0) and (ParentClubID <> ChildClubID) then
              begin
                try
                  // Create a new ClubGroupRecord..
                  qrySwimClubGroup.Insert;
                  // the linked swim club.
                  qrySwimClubGroup.FieldByName('ChildClubID').AsInteger := ChildClubID;
                  // the newly created CLUBGROUP-SWIMCLUB
                  qrySwimClubGroup.FieldByName('ParentClubID').AsInteger := ParentClubID;
                  qrySwimClubGroup.Post;
                except on E: Exception do
                  begin
                      qrySwimClubGroup.Cancel;
                      break;
                  end;
                end;
              end;
            end;

          end;

          // STEP : locate grid to sync with new record. Fix UI selection.
          // NOTE: Doesn't require toggeling of MouseAction.DisjunctRowSelect
          CORE.qrySwimClub.Refresh; // ensured all ImageIndex values are correct.
          SyncGridToDB(1);
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

  // User click on an UNSELECTED 'Gropued Club' HTML row's anchor
  // ... fix UI display. Select the row.
  if (ARow <> gSwimClub.DisplRowIndex(CORE.qrySwimClub.RecNo)) then
  begin
    SyncDBtoGrid(2); // toggles DisjunctRowSelect, current focused row.
  end;

  // Check if the clicked anchor matches our custom action string
  if Anchor = 'EYE_CLICK_ACTION' then
  begin
    // The image was clicked, so perform the desired action.
    ShowMessage('SHOW SELECT CLUBS IN GROUP.');
    // Prevent the grid from trying to open "IMAGE_CLICK_ACTION" as a URL
    AutoHandle := False;
  end;

end;

procedure TSwimClubManage.gSwimClubClick(Sender: TObject);
begin
  { FIX SYNC - Locate DataBase to Grid ROW.}
//  SyncDBtoGrid(1); // TESTING SYNC METHODS.
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
      {NOTE: gSwimClub.HTMLKeepLineBreak := false. Use <BR> for line breaks}
      htmlStr := '''
        <FONT size="12">
        <IND x="3">
          <#Caption></FONT><BR>
        <FONT size="12">
        <IND x="3">
        <A HREF="EYE_CLICK_ACTION"><IMG SRC="idx:1"></A>
        </FONT>
        <FONT size="8">  <#NickName></FONT>
        ''';
    end
    else
    begin
      htmlStr := '''
        <FONT size="12"><#SwimClubID>:  <#Caption></FONT><BR>
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
  actnEdit.Checked := false; // de-select button on the actnToolBar.
end;

procedure TSwimClubManage.splitvEditClosing(Sender: TObject);
begin
  CORE.qrySwimClub.CheckBrowseMode;
  CORE.qrySwimClub.Refresh; // Updates qrySwimClub.imgIndxArchived value.

  if CORE.qrySwimClub.FieldByName('IsClubGroup').AsBoolean then
  begin
    if FrSCG.IsChanged then
      FrSCG.UpdateData_SwimClubGroup(CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger);
  end;


  if fGridIsUpdating then
  begin
    gSwimClub.EndUpdate; // Enable changes in TMS grid.
    fGridIsUpdating := false;
  end;
end;

procedure TSwimClubManage.splitvEditOpening(Sender: TObject);
var
PK: integer;
begin
  // prepare the IsArchived icon image.
  imgIndxArchive.ImageIndex :=
  CORE.qrySwimClub.FieldByName('imgIndxArchived').AsInteger;
  gSwimClub.BeginUpdate; // disable changes in TMS grid.
  fGridIsUpdating := true; // store TMS update state...

  // When Swimming Club is a Group then PK = ParentClubID.
  PK := CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;

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

    // PREPARE FRAME.
    FrSCG.IsChanged := false;
    FrSCG.ParentClubID := PK;
    FrSCG.LoadList_SwimClubGroup(PK);
    FrSCG.LoadList_SwimClub(PK);

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

procedure TSwimClubManage.SyncGridToDB(AMethod: integer);
begin
  case AMethod of
    1: // METHOD 1: typically use when moving grid-row to DB
    begin
      gSwimClub.ClearRowSelect; // nils 'selected items' and REPAINTS!
      // Converts a real row index to its visible index on screen.
      gSwimClub.Row := gSwimclub.DisplRowIndex(CORE.qrySwimClub.RecNo);
      gSwimClub.SelectRows(gSwimClub.Row, 1); // Select current Focused row.
      // gSwimClub.ScrollInView(0, gSwimClub.Row);
    end;
    2: // METHOD 2: typically use when moving DB to grid-row
    begin
      gSwimClub.MouseActions.DisjunctRowSelect := false;
      // Converts a real row index to its visible index on screen.
      gSwimClub.Row := gSwimclub.DisplRowIndex(CORE.qrySwimClub.RecNo);
      gSwimClub.MouseActions.DisjunctRowSelect := true;
      // gSwimClub.ScrollInView(0, gSwimClub.Row);
    end;
  end;
end;

procedure TSwimClubManage.SyncDBtoGrid(AMethod: integer; ARow: integer);
begin

  if ARow = 0 then
    ARow := gSwimClub.Row; // current focused (display) row number.
  {
    // intersection operator : test if either rangeselect or editing is in options.
    if ([goRangeSelect, goEditing] * gSwimclub.Options) <> [] then
      gSwimclub.Options := gSwimclub.Options - [goRangeSelect, goEditing] + [goRowSelect];
  }
  case AMethod of
    1: // METHOD 1: typically use when moving grid-row to DB
    begin
      gSwimClub.ClearRowSelect; // nils 'selected items' and REPAINTS!
      // Converts a visible row index to its actual index in the grid’s full dataset.
      if (ARow >= gSwimClub.FixedRows) and (ARow < gSwimClub.RowCount) then
        CORE.qrySwimClub.RecNo := gSwimclub.RealRowIndex(ARow);
      gSwimClub.SelectRows(ARow, 1); // Select current Focused row.
    end;
    2: // METHOD 2: typically use when moving DB to grid-row
    begin
      gSwimClub.MouseActions.DisjunctRowSelect := false;
      // Converts a visible row index to its actual index in the grid’s full dataset.
      if (ARow >= gSwimClub.FixedRows) and (ARow < gSwimClub.RowCount) then
        CORE.qrySwimClub.RecNo := gSwimclub.RealRowIndex(ARow);
      gSwimClub.MouseActions.DisjunctRowSelect := true;
    end;
  end;
end;

end.
