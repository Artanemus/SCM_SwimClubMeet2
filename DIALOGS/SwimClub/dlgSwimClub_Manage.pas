unit dlgSwimClub_Manage;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, system.UITypes,
  System.Generics.Collections,

  Data.DB,

  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.ExtCtrls, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtDlgs, Vcl.DBCtrls, Vcl.Mask, Vcl.WinXCtrls,
  Vcl.Grids,

  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  dmIMG, dmCORE, dmSCM2,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid, SVGIconImage,
  AdvDateTimePicker, AdvDBDateTimePicker, FireDAC.Stan.Intf, frFrameClubGroup;

  //, hintlist;

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
    hintInfo: TBalloonHint;
    CGFrame: TFrameClubGroup;
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
    procedure SelectClubsInGroup;
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
  if qrySwimClubGroup.Active then
    qrySwimClubGroup.Close;
  CORE.qrySwimClub.IndexName := 'indxHideArchived';
end;

procedure TSwimClubManage.FormCreate(Sender: TObject);
begin
  if qrySwimClubGroup.Active then qrySwimClubGroup.Close;

  // reveal archived swimming clubs which are by default hidden.
  CORE.qrySwimClub.IndexName := 'indxShowAll';
  fGridIsUpdating := false;
  // bring UI to the correct display state.
  splitvEdit.UseAnimation := false;
  splitvEdit.Opened := false;
  splitvEdit.UseAnimation := true;
  if pcntrlEdit.ActivePageIndex <> 0 then pcntrlEdit.ActivePageIndex := 0;

  // Assign current connection...
  if Assigned(SCM2) then
  begin
    qrySwimClubGroup.Connection := SCM2.scmConnection;
    if qrySwimClubGroup.Connection.Connected then
      qrySwimClubGroup.Open;
  end;

  CGFrame.Initialize; // assigned connection but not active.

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
  msgResults, PK: integer;
  msg, clubName, mbTitle: string;
begin
  {
    if qrySession.IsEmpty then .... is used, and 'hide closed session'
      is enabled  then the true count is not given due to the filtering
      and Master-Detailed relationship.
    Using the ExecSQLScalar function with SQL script - much safer.
  }
  SyncGridToDB(2); // clean up the UI
  actnDelete.Checked := false; // de-select button on the actnToolBar.

  if gSwimClub.RowSelectCount > 1 then
  begin
    msg := '''
      Sorry, the deletion of 'multi-selected' grid rows
      is currently not implemented.
      ''';
    MessageDlg(msg, mtInformation, [mbOK], 0);
    exit;
  end;

  // collect some helpful db info.
  PK := CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;
  ClubName := CORE.qrySwimClub.FieldByName('Caption').AsString;
  mbTitle := 'DELETE ' + ClubName + '...';

  // uses EXECSCALAR method to ensure it's empty.
  if uSwimClub.SessionCount = 0 then
  begin
    msg := '''
      Are you sure you want to delete this club?
      ''';
    msg := 'DELETE ' + ClubName + sLineBreak + msg;
    msgResults := MessageBox(0, PChar(msg), PChar(mbTitle),
      MB_ICONEXCLAMATION or MB_YESNO or MB_DEFBUTTON2);
    if msgResults = IDYES then
    begin
      // includes deletion of club group and member link records.
      // false = ignore locked states.
      {$IFDEF DEBUG}
        // ... DON'T DELETE THIS SWIMCLUB - used for demonstrating SCM2.
        if PK = 1 then exit;
      {$ELSE}
        if PK = 1 then exit;
      {$ENDIF}
      uSwimClub.Delete_SwimClub(false);
    end;
    exit;
  end;

  // We have sessions. Are there any locked sessions?
  if uSwimClub.HasLockedSession then
  begin
    msg := '''
    This club has locked session!
    Deleting will remove all sessions, locked or unlocked.

    Are you sure you want to delete this club?
    ''';
    msgResults := MessageBox(0, PChar(msg), PChar(mbTitle),
      MB_ICONEXCLAMATION or MB_YESNO or MB_DEFBUTTON2);
    if msgResults <> IDYES then exit;
  end;

  if uSwimClub.HasRaceData then
  begin
    msg := '''
      This club has race data.
      Deleting it will remove all sessions, events, heats, and race times.
      Note: Members will be unassigned from the club and will not be deleted.

      Tip: Archiving is safer than losing valuable data.

      Are you sure you want to delete this club?
      ''';
    msgResults := MessageBox(0, PChar(msg), PChar(mbTitle),
      MB_ICONEXCLAMATION or MB_YESNO or MB_DEFBUTTON2);
    if msgResults <> IDYES then exit;
  end;
      
  // If empty of race-data, wit: Event were not run and heats have no
  // race-times, then the crypt isn't stone-walled by warning messages.
  msg := '''
    .... Just checking.

    Deleting this club will permanently remove all its data.
    Are you sure you want to continue?
    ''';
  msgResults := MessageBox(0, PChar(msg), PChar(mbTitle),
    MB_ICONEXCLAMATION or MB_YESNO or MB_DEFBUTTON2);

  if (msgResults = IDYES) then
  begin
    {$IFDEF DEBUG}
      // ... DON'T DELETE THIS SWIMCLUB - used for demonstrating SCM2.
      if PK = 1 then exit;
    {$ELSE}
      if PK = 1 then exit;
    {$ENDIF}

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
    CORE.qrySwimClub.Insert;
    // NOTE: IsClubGroup = false in CORE.qrySwimClub.OnNewRecord.
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
  cc: TList<integer>; // List of ChildClubIDs.
begin
  // TRAP: no grid rows have been selected...
  if gSwimClub.RowSelectCount = 0 then exit;
  { NOTE: when we create the new CLUB GROUP, TMS will place
    'focus' and 'select' row.
    To avoid selection issues, collect the ChildClub's IDs first.
  }
  cc := TList<integer>.Create;
  try
    gSwimClub.BeginUpdate;
    try
      // STEP 1: COLLECT THE CILDCLUBID's
      // iterate over selected rows - gather the ChildClubID's.
      for i := gSwimClub.FixedRows to gSwimClub.RowCount-1 do
      begin
        // Check if the row is 'selected ROW'
        if gSwimClub.RowSelect[i] then
        begin
          // row[4] = Field: dbo.SwimClub.IsClubGroup.
          if (StrToIntDef(gSwimClub.Cells[4, i], 0) = 1) then
            continue; // sorry, 'group inception' is not allowed...
          // row[5] = Field: dbo.Swimclub.SwimClubID
          ChildClubID := StrToIntDef(gSwimClub.Cells[5, i], 0);
          cc.Add(ChildClubID); // store ChildClubID.
        end;
      end;
    finally
      gSwimClub.EndUpdate;
    end;
    if not cc.IsEmpty then
    begin
      // STEP 2: CREATE THE CLUB GROUP.
      try  // create a new Club .. default values handle by CORE.OnNewRecord.
        CORE.qrySwimClub.Insert;
        CORE.qrySwimClub.FieldByName('IsClubGroup').AsBoolean := true;
        CORE.qrySwimClub.FieldByName('Caption').AsString := 'NEW CLUB GROUP';
        CORE.qrySwimClub.Post;
        // Get the newly created CLUBGROUP-SWIMCLUB.. Safe to do in FireDAC.
        ParentClubID := CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;

      {  // BEST PRACTISE - Alternative method...
      v := SCM2.scmConnection.ExecSQLScalar('SELECT IDENT_CURRENT (''dbo.SwimClub'');' );
      if not VarIsClear(v) and (v=0) then  ParentClubID := v;
      }

      except on E: Exception do
        begin
          CORE.qrySwimClub.Cancel;
          exit;
        end;
      end;
      // STEP 3: ASSIGN CHILD CLUBs TO CLUB GROUP.
      for I := 0 to cc.Count-1 do
      begin
        try
          // Create a new ClubGroupRecord..
          qrySwimClubGroup.Insert;
          // the linked swim club.
          qrySwimClubGroup.FieldByName('ChildClubID').AsInteger := cc[i];
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
  finally
    cc.Free;
  end;

  // STEP 4: TIDY-U{ UI.
  // locate grid to sync with new record. Fix UI selection.
  CORE.qrySwimClub.Refresh; // ensured all ImageIndex values are correct.
  SyncGridToDB(1); // de-select all , focus and select ClubGroup.
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
    // DB record must move to display ARow.
    SyncDBtoGrid(2, ARow); // method toggles DisjunctRowSelect.
  end;

  // Check if the clicked anchor matches our custom action string
  if Anchor = 'EYE_CLICK_ACTION' then
  begin
    // The image was clicked, so perform the desired action.
    SelectClubsInGroup();
    // Prevent the grid from trying to open as a URL
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
        <IND x="8"><#Caption></FONT><BR>
        <FONT size="9">
        <IND x="4">
        <A HREF="EYE_CLICK_ACTION"><IMG SRC="idx:1" align="middle"></A>
        </FONT>
        <FONT size="9">
        <IND x="8">
        <#NickName></FONT>
        ''';
    end
    else
    begin
      htmlStr := '''
        <FONT size="12">
        <IND x="4"><#Caption></FONT><BR>
        <FONT size="9">
        <IND x="8">
        <#NickName></FONT>
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

procedure TSwimClubManage.SelectClubsInGroup;
var
  idx, ChildClubID, PK: integer;
  doOnce: boolean;
begin
  doOnce := true;
  PK := CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;
  gSwimClub.ClearRowSelect; // nils 'selected items' and REPAINTS!
  // club group - SwimClubID = ParentClubID in dbo.SwimClubGroup.
  // full re-query on table.
  qrySwimClubGroup.Close;
  qrySwimClubGroup.Open;
  qrySwimClubGroup.Filter := 'ParentClubID = ' + IntToStr(PK);
  qrySwimClubGroup.Filtered := true;
  // iterate over rows in grid.
  for idx := gSwimClub.FixedRows to gSwimClub.RowCount do
  begin
    qrySwimClubGroup.First;
    while not qrySwimClubGroup.eof do
    begin
      ChildClubID := qrySwimClubGroup.FieldByName('ChildClubID').AsInteger;
      // Cell holds [SwimClub].[SwimClubID] ..
      if gSwimClub.Cells[5,idx] = IntToStr(ChildClubID) then
      begin
        if doOnce then
        begin
          // de-select Club Croup row and ...
          SyncDBtoGrid(2, idx); // make this the current selected row.
          doOnce := false;
        end
        else
          gSwimClub.RowSelect[gSwimClub.DisplRowIndex(idx)] := true;
      end;
      qrySwimClubGroup.next;
    end;
  end;
  // finally - reposition to active rec
  qrySwimClubGroup.Filter := '';
  qrySwimClubGroup.Filtered := false;

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
    if CGFrame.IsChanged then
      CGFrame.UpdateData_SwimClubGroup(CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger);
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
    CGFrame.IsChanged := false;
    CGFrame.ParentClubID := PK;
    CGFrame.LoadList_SwimClubGroup(PK);
    CGFrame.LoadList_SwimClub(PK);

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
