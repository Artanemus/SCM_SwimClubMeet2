unit frmManageMember;

interface

uses
  Winapi.Windows, Winapi.Messages,
  Winapi.ShellAPI,

  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  System.ImageList, System.Actions, System.Rtti, System.Bindings.Outputs,

  Data.DB,  Data.Bind.EngExt, Data.Bind.Components, Data.Bind.DBScope,

  Vcl.Graphics,
  Vcl.Themes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,  VclTee.TeeGDIPlus,
  Vcl.StdCtrls, VclTee.TeEngine,
  VclTee.TeeSpline, VclTee.Series, VclTee.TeeProcs, VclTee.Chart,
  VclTee.DBChart, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.Menus, Vcl.WinXCalendars,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Vcl.ToolWin, Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.Bind.DBEngExt,
  VclTee.TeeData, Vcl.Buttons,
  Vcl.Bind.Editors,
  Vcl.VirtualImage,
  Vcl.ButtonGroup,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Vcl.ImgList,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmMM_CORE, uDefines, uSettings,
  uSwimClub, uUtility, dmSCM2

  ;


type
  TManageMember = class(TForm)
    actnFilter: TAction;
    actnFilterClub: TAction;
    ActnManagerMember: TActionManager;
    ActnMemberMenuBar: TActionMainMenuBar;
    BalloonHint1: TBalloonHint;
    btnClearDOB: TButton;
    btnClearGender: TButton;
    btnDOBPicker: TButton;
    btnFilterByParam: TButton;
    btnFilterBySwimClub: TButton;
    btnFindMember: TButton;
    btnGotoMemberID: TButton;
    btnGotoMembership: TButton;
    BTNImageList32x32: TVirtualImageList;
    btnInfoContact: TVirtualImage;
    btnInfoDateTime: TVirtualImage;
    btnInfoFilter: TVirtualImage;
    btnInfoRoles: TVirtualImage;
    btnMemberDetail: TButton;
    btnMemberHistory: TButton;
    DBchkIsActive: TDBCheckBox;
    DBchkIsArchived: TDBCheckBox;
    DBchkIsSwimmer: TDBCheckBox;
    DBContactNumNavigator: TDBNavigator;
    DBedtDOB: TDBEdit;
    DBEdtEmail: TDBEdit;
    DBedtFirstName: TDBEdit;
    DBedtLastName: TDBEdit;
    DBedtMembershipNum: TDBEdit;
    DBgridContactInfo: TDBGrid;
    DBGridRole: TDBGrid;
    dblblMemberID: TDBText;
    DBlucboGender: TDBLookupComboBox;
    DBMemo1: TDBMemo;
    DBNavigator1: TDBNavigator;
    DBNavigator2: TDBNavigator;
    DBTextFullName: TDBText;
    ImageCollectMember: TImageCollection;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label18: TLabel;
    Label2: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblMembersAge: TLabel;
    ListBox1: TListBox;
    MemFile_AutoEdit: TAction;
    MemFile_Exit: TAction;
    MemSearch_FindMember: TAction;
    MemSearch_GotoMemberID: TAction;
    MemSearch_GotoMembershipNum: TAction;
    PageControl: TPageControl;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel7: TPanel;
    RegistrationNum: TDBEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    VirtlImageListMember: TVirtualImageList;
    vimgHelpBug: TVirtualImage;
    navSwimClub: TDBNavigator;
    dbgParaCode: TDBGrid;
    lblParaCodes: TLabel;
    vimgParaCodesInfo: TVirtualImage;
    navParaCodes: TDBNavigator;
    ListGrid: TDBAdvGrid;
    DBedtMiddleName: TDBEdit;
    lblMiddleName: TLabel;
    procedure About2Click(Sender: TObject);
    procedure actnFilterClubExecute(Sender: TObject);
    procedure actnFilterExecute(Sender: TObject);
    procedure actnFilterUpdate(Sender: TObject);
    procedure btnClearDOBClick(Sender: TObject);
    procedure btnDOBPickerClick(Sender: TObject);
    procedure btnFindMemberClick(Sender: TObject);
    procedure btnGotoMemberIDClick(Sender: TObject);
    procedure btnGotoMembershipClick(Sender: TObject);
    procedure btnInfoContactClick(Sender: TObject);
    procedure btnInfoDateTimeClick(Sender: TObject);
    procedure btnInfoFilterClick(Sender: TObject);
    procedure btnInfoMouseLeave(Sender: TObject);
    procedure btnInfoRolesClick(Sender: TObject);
    procedure btnMemberDetailClick(Sender: TObject);
    procedure btnMemberHistoryClick(Sender: TObject);
    procedure DBGridCellClick(Column: TColumn);
    procedure DBGridColEnter(Sender: TObject);
    procedure DBGridColExit(Sender: TObject);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridEditButtonClick(Sender: TObject);
    procedure DBGridGenericKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridRoleCellClick(Column: TColumn);
    procedure DBGridRoleEditButtonClick(Sender: TObject);
    procedure DBNavigator1BeforeAction(Sender: TObject; Button: TNavigateBtn);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MemFile_ExitExecute(Sender: TObject);
    procedure MemSearch_FindMemberExecute(Sender: TObject);
    procedure Onlinehelp1Click(Sender: TObject);
    procedure SCMwebsite1Click(Sender: TObject);
  private
//    fColorBgColor: TColor;
//    fColorEditBoxFocused: TColor;
//    fColorEditBoxNormal: TColor;

    // Used to convert DATETIME and then post TMessage to Member DataModule.
    fSystemTime: TSystemTime;
    function AssertConnection: Boolean;
    function GotoMember(MemberID: Integer): Boolean;
    function GetMembersAge(aMemberID: Integer; aDate: TDate): Integer;
    procedure UpdateFilterCount();
    procedure UpdateMembersAge();
  protected
    procedure MSG_AfterPost(var Msg: TMessage); message SCM_MEMBER_AFTERPOST;
    procedure MSG_AfterScroll(var Msg: TMessage); message SCM_MEMBER_AFTERSCROLL;
    procedure MSG_FilterChanged(var Msg: TMessage); message SCM_MEMBER_FILTER_CHANGED;
  public
    procedure Locate_MemberID(aMemberID: Integer);
  end;


//// all preferences are JSON, located in uSettings.Settings.
//const
//  INIFILE_SCM_MEMBERPREF = 'SCM_MemberPref.ini';
//  INIFILE_SECTION = 'SCM_Member';

var
  ManageMember: TManageMember;

implementation

{$R *.dfm}

uses
  System.DateUtils,
  System.IniFiles,
  System.UITypes,
  System.IOUtils,

  dlgDatePicker,

  dlgMM_Delete,
  dlgMM_Find_ID,
  dlgMM_Find_Membership,
  dlgMM_Find_FName,
  rptMM_Detail,
  rptMM_History,
  rptMM_Chart,
  rptMM_CheckData,
  dlgMM_About,
  dlgMM_FilterByParam,
  dlgMM_FilterBySwimClub;

procedure TManageMember.About2Click(Sender: TObject);
var
  dlg: TMM_About;
begin
  dlg := TMM_About.Create(Self);
  dlg.ShowModal;
  FreeAndNil(dlg);
end;

procedure TManageMember.actnFilterClubExecute(Sender: TObject);
//var
//  dlg: TFilterBySwimClub;
begin
//  if not fIsActive then exit;
  {TODO -oBSA -cGeneral : Make dlg persistent. }
{
dlg := TFilterBySwimClub.Create(Self);
if IsPositiveResult(dlg.ShowModal) then
begin
  SendMessage(Handle, SCM_MEMBER_FILTER_CHANGED, 0, 0);
end;
dlg.Free;
}
end;

procedure TManageMember.actnFilterExecute(Sender: TObject);
var
  dlg: TMM_FilterByParam;
  aRect: TRect;
begin
  dlg := TMM_FilterByParam.Create(Self);
  dlg.Position := poDesigned;
  aRect := btnFilterByParam.ClientToScreen(btnFilterByParam.ClientRect);
  dlg.Left := aRect.Left;
  dlg.Top := aRect.Bottom + 1;
  {
    To get the filter dialogue to work without a close button on it's form...

    This is a common UI pattern (often called "Light Dismiss"), but it
    conflicts with the standard Windows definition of ShowModal, which
    explicitly disables the parent window to force user interaction with
    the dialog.

    The PopupMode property is automatically set to pmAuto when the ShowModal
    method is called. However, this causes the window handle to be recreated,
    which is not usually desirable. To avoid the re-creation of window handles,
    you can explicitly set the PopupMode property to pmAuto prior to calling
    the ShowModal method (such as at design time).
  }

  dlg.PopupMode := pmAuto; // Ensures it floats above the parent correctly
  dlg.Show;

  // DO NOT CALL dlg.Free here.
  // The local variable 'dlg' goes out of scope immediately,
  // but the Object instance lives on until the user clicks away,
  // at which point 'caFree' cleans it up.
end;

procedure TManageMember.actnFilterUpdate(Sender: TObject);
begin
  if Assigned(MM_CORE) then
    btnFilterByParam.Caption := 'Filter (' + IntToStr(MM_CORE.RecCount) + ')'
  else
    btnFilterByParam.Caption := 'Filter (..)';
end;

function TManageMember.AssertConnection: Boolean;
begin
  result := false;
  if assigned(MM_CORE) then
  begin
    // IsActive if TFDConnection::scmConnection && FireDAC tables are active
    if MM_CORE.IsActive then
      result := true;
  end;
end;

procedure TManageMember.btnClearDOBClick(Sender: TObject);
begin
  if assigned(MM_CORE) then MM_CORE.ClearDOB;
end;

procedure TManageMember.btnDOBPickerClick(Sender: TObject);
var
  dlg: TDatePicker;
  Rect: TRect;
  rtn: TModalResult;
begin
  dlg := TDatePicker.Create(Self);
  dlg.Position := poDesigned;
  Rect := btnDOBPicker.ClientToScreen(btnDOBPicker.ClientRect);
  dlg.Left := Rect.Left;
  dlg.Top := Rect.Bottom + 1;
  dlg.CalendarView1.Date := MM_CORE.qMember.FieldByName('DOB').AsDateTime;
  rtn := dlg.ShowModal;
  if IsPositiveResult(rtn) then
  begin
    with MM_CORE.qMember do
    begin
      if (State <> dsEdit) or (State <> dsInsert) then
      begin
        Edit;
        FieldByName('DOB').AsDateTime := dlg.CalendarView1.Date;
      end;
    end;
  end;
  dlg.Free;
end;

procedure TManageMember.btnFindMemberClick(Sender: TObject);
var
  dlg: TFindMember_FName;
begin
  dlg := TFindMember_FName.Create(Self);
  if IsPositiveResult(dlg.ShowModal()) then
    GotoMember(dlg.MemberID); // LOCATE MEMBER IN qryMember
  dlg.Free;
end;

procedure TManageMember.btnGotoMemberIDClick(Sender: TObject);
var
  dlg: TFindMember_ID;
  rtn: TModalResult;
begin
  if assigned(MM_CORE) then
  begin
    dlg := TFindMember_ID.Create(Self);
    rtn := dlg.ShowModal;
    if IsPositiveResult(rtn) then
      GotoMember(dlg.MemberID);  // LOCATE MEMBER IN qryMember
    dlg.Free;
  end;
end;

procedure TManageMember.btnGotoMembershipClick(Sender: TObject);
var
  dlg: TFindMember_Membership;
  rtn: TModalResult;
begin
  if assigned(MM_CORE) then
  begin
    dlg := TFindMember_Membership.Create(Self);
    rtn := dlg.ShowModal;
    if IsPositiveResult(rtn) then
      GotoMember(dlg.MemberID); // LOCATE MEMBER IN qryMember
    dlg.Free;
  end;
end;

procedure TManageMember.btnInfoContactClick(Sender: TObject);
begin
  BalloonHint1.Title := 'Contact Number.';
  BalloonHint1.Description := 'A contact number must have a contact type.' +
    sLinebreak + 'To clear a selected cell, press ALT-BACKSPACE.' + sLinebreak +
    'To delete a record, press CTRL-DEL';
  BalloonHint1.ShowHint(btnInfoContact);
end;

procedure TManageMember.btnInfoDateTimeClick(Sender: TObject);
begin
  BalloonHint1.Title := 'Region Date.';
  BalloonHint1.Description := 'SCM2 uses ''Short Date'' locale format.' +
    sLinebreak +
    'To modify how dates are displayed and the syntax used to enter dates, ' +
    sLinebreak + 'go to the ''Region Settings'' in MS Windows. ';
  BalloonHint1.ShowHint(btnInfoDateTime);
end;

procedure TManageMember.btnInfoFilterClick(Sender: TObject);
var
  s: string;
begin
  BalloonHint1.Title := 'Filter members by parameters.';
  s := '''
    Options are...
    Hide members who have be archived. Never delete a member, just archive.
    Hide inactive members. Perhaps these members haven't paid membership?
    Hide non-swimmer. Parent and friends can be hidden.
    Note that the filter button display the number of records found.
    ''';
  BalloonHint1.Description := s;
  BalloonHint1.ShowHint(btnInfoFilter);
end;

procedure TManageMember.btnInfoMouseLeave(Sender: TObject);
begin
  BalloonHint1.HideHint;
end;

procedure TManageMember.btnInfoRolesClick(Sender: TObject);
var
  s: string;
begin
  BalloonHint1.Title := 'Membership Roles.';
  s := '''
    To enter a start or end date, select the cell, then
    press the ellipse button. A date picker will appear.
    To clear a selected cell, press CTRL-BACKSPACE.
    To delete a record, press CTRL-DEL.
    ''';
  BalloonHint1.Description := s;
  BalloonHint1.ShowHint(btnInfoRoles);
end;

procedure TManageMember.btnMemberDetailClick(Sender: TObject);
var
  rpt: TMemberDetail;
begin
  if not assigned(MM_CORE) then
    exit;
  rpt := TMemberDetail.Create(Self);
  rpt.RunReport(SCM2.scmConnection, MM_CORE.GetMemberID,
    MM_CORE.GetMemberID);
  rpt.Free;
end;

procedure TManageMember.btnMemberHistoryClick(Sender: TObject);
var
  rpt: TMemberHistory;
begin
  if not assigned(MM_CORE) then
    exit;
  rpt := TMemberHistory.Create(Self);
  rpt.RunReport(SCM2.scmConnection, MM_CORE.GetMemberID,
    MM_CORE.GetMemberID);
  rpt.Free;
end;

procedure TManageMember.DBGridCellClick(Column: TColumn);
begin
  if assigned(Column.Field) and (Column.Field.DataType = ftBoolean) then
  begin
    Column.Grid.DataSource.DataSet.CheckBrowseMode;
    Column.Grid.DataSource.DataSet.Edit;
    Column.Field.AsBoolean := not Column.Field.AsBoolean;
  end;
  if assigned(Column.Field) and (Column.Field.FieldKind = fkLookup) then
  begin
    Column.Grid.DataSource.DataSet.CheckBrowseMode;
    Column.Grid.DataSource.DataSet.Edit;
  end;
end;

procedure TManageMember.DBGridColEnter(Sender: TObject);
begin
  // By default, two clicks on the same cell enacts the cell editing mode.
  // The grid draws a TEditBox over the cell, killing the checkbox draw UI.
  with Sender as TDBGrid do
  begin
    if assigned(SelectedField) and (SelectedField.DataType = ftBoolean) then
    begin
      Options := Options - [dgEditing];
    end;
  end;
end;

procedure TManageMember.DBGridColExit(Sender: TObject);
begin
  with Sender as TDBGrid do
    if assigned(SelectedField) and (SelectedField.DataType = ftBoolean) then
      Options := Options + [dgEditing];
end;

procedure TManageMember.DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
//var
//  clFont, clBg: TColor;
begin
  // NOTE: DEFAULT DRAWING IS DISABLED ....
  // NOTE: DO NOT ENABLE TDBGRID OPTION dgAlwaysShowEditor.
  // (inconsistent OS MESSAGING)
  if (Column.Field.FieldName = 'IsActive') or
    (Column.Field.FieldName = 'IsArchived') or
    (Column.Field.FieldName = 'IsSwimmer') then
  begin
//    if gdFocused in State then
//      clFont := fColorEditBoxFocused
//    else
//      clFont := fColorEditBoxNormal;
//    clBg := fColorBgColor;
//    TDBGrid(Sender).DrawCheckBoxes(Sender, Rect, Column, clFont, clBg);
    // draw 'Focused' frame  (for boolean datatype only)
    if gdFocused in State then
      TDBGrid(Sender).Canvas.DrawFocusRect(Rect);
  end
  else
  begin
    TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
    if gdFocused in State then
      TDBGrid(Sender).Canvas.DrawFocusRect(Rect);
  end;
end;

procedure TManageMember.DBGridEditButtonClick(Sender: TObject);
var
  fld: TField;
  cal: TDatePicker;
  // point: TPoint;
  Rect: TRect;
  rtn: TModalResult;
begin
  // handle the ellipse button for the DOB - show DatePicker
  fld := TDBGrid(Sender).SelectedField;
  if fld.Name = 'qryMemberDOB' then
  begin
    cal := TDatePicker.Create(Self);
    Rect := TButton(Sender).ClientToScreen(TButton(Sender).ClientRect);
    cal.Left := Rect.Left;
    cal.Top := Rect.Top;
    cal.CalendarView1.Date := fld.AsDateTime;
    rtn := cal.ShowModal;
    if IsPositiveResult(rtn) then
    begin
      if (TDBGrid(Sender).DataSource.State <> dsEdit) or
        (TDBGrid(Sender).DataSource.State <> dsInsert) then
      begin
        // ALT: MM_CORE.UpdateDOB(cal.CalendarView1.Date);
        TDBGrid(Sender).DataSource.Edit;
        fld.Value := cal.CalendarView1.Date;
      end;

    end;
    cal.Free;
  end;
end;

procedure TManageMember.DBGridGenericKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  fld: TField;
begin
  if (Key = VK_BACK) and (ssAlt in Shift) then
  BEGIN
    with Sender as TDBGrid do
    Begin
      DataSource.DataSet.DisableControls;
      fld := TDBGrid(Sender).SelectedField;
      if assigned(fld) then
      BEGIN
        // if the query is not in edit mode
        if (DataSource.DataSet.State <> dsEdit) or
          (DataSource.DataSet.State <> dsInsert) then
          DataSource.DataSet.Edit;
        // D B G r i d R o l e  ...
        if (fld.FieldName = 'ElectedOn') or (fld.FieldName = 'RetiredOn') then
          fld.Clear;
        // D B G r i d C o n t a c t I n f o ...
        if (fld.FieldName = 'luContactNumType') then
          fld.Clear;
      end;
      DataSource.DataSet.EnableControls;
      // signal finished with key;
      Key := 0;
    END;
  END;
end;

procedure TManageMember.DBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  fld: TField;
begin

  With Sender as TDBGrid do
  begin
    if assigned(SelectedField) then
    begin

      if (SelectedField.DataType = ftBoolean) then
      begin
        // If the selected field is a boolean,
        // then enable SPACE key to toggle the value.
        fld := SelectedField;
        if (Key = vkSpace) then
        begin
          if (DataSource.DataSet.State <> dsEdit) or
            (DataSource.DataSet.State <> dsInsert) then
          begin
            DataSource.DataSet.Edit();
          end;
          fld.Value := not fld.AsBoolean;
          Key := NULL;
        end;
        // Y, y, T, t
        if (Key = $59) or (Key = $79) or (Key = $54) or (Key = $74) then
        begin
          if (DataSource.DataSet.State <> dsEdit) or
            (DataSource.DataSet.State <> dsInsert) then
          begin
            DataSource.DataSet.Edit();
          end;
          fld.Value := 1;
          Key := NULL;
        end;
        // N, n, F, f
        if (Key = $4E) or (Key = $6E) or (Key = $46) or (Key = $66) then
        begin
          if (DataSource.DataSet.State <> dsEdit) or
            (DataSource.DataSet.State <> dsInsert) then
          begin
            DataSource.DataSet.Edit();
          end;
          fld.Value := 0;
          Key := NULL;
        end;
      end;

      // DROPDOWN COMBOBOX
      if (SelectedField.FieldKind = fkLookup) then
      begin
        // NullValueKey - Alt+BkSp - CLEAR
        if (Key = vkBack) and (ssAlt in Shift) then
        begin
          fld := SelectedField;
          if (fld.FieldName = 'luHouse') then
          begin
            DataSource.DataSet.Edit();
            DataSource.DataSet.FieldByName('HouseID').Clear();
            DataSource.DataSet.Post();
            Key := NULL;
          end;
          if (fld.FieldName = 'luGender') then
          begin
            DataSource.DataSet.Edit();
            DataSource.DataSet.FieldByName('GenderID').Clear();
            DataSource.DataSet.Post();
            Key := NULL;
          end;
        end;
      end;
    end;
  end;

end;

procedure TManageMember.DBGridRoleCellClick(Column: TColumn);
var
  fld: TField;
begin
  if assigned(Column.Field) and (Column.Field.DataType = ftBoolean) then
  begin
    fld := DBGridRole.DataSource.DataSet.FindField('MemberID');
    if fld.IsNull then
      exit;
    if Column.Grid.DataSource.DataSet.State <> dsEdit then
      Column.Grid.DataSource.DataSet.Edit;

    // Column.Grid.DataSource.DataSet.CheckBrowseMode;
    // Column.Grid.DataSource.DataSet.Edit;
    Column.Field.AsBoolean := not Column.Field.AsBoolean;
  end;

  if assigned(Column.Field) and (Column.Field.FieldKind = fkLookup) then
  begin
    if Column.Grid.DataSource.DataSet.State <> dsEdit then
      Column.Grid.DataSource.DataSet.Edit;
    // Column.Grid.DataSource.DataSet.CheckBrowseMode;
    // Column.Grid.DataSource.DataSet.Edit;
  end;
end;

procedure TManageMember.DBGridRoleEditButtonClick(Sender: TObject);
var
  fld: TField;
  dlg: TDatePicker;
  mrRtn: TModalResult;
begin
  // handle the ellipse button for TDateTime entry...
  fld := TDBGrid(Sender).SelectedField;
  if not assigned(fld) then
    exit;
  if (fld.FieldName = 'ElectedOn') OR (fld.FieldName = 'RetiredOn') then
  begin
    dlg := TDatePicker.Create(Self);
    mrRtn := dlg.ShowModal; // open DATE PICKER ...
    if (mrRtn = mrOk) then
    begin
      DateTimeToSystemTime(dlg.CalendarView1.Date, fSystemTime);
      if (fld.FieldName = 'ElectedOn') then
        PostMessage(MM_CORE.Handle, SCM_MEMBER_UPDATE_ELECTEDON,
          longint(@fSystemTime), 0)
      else
        PostMessage(MM_CORE.Handle, SCM_MEMBER_UPDATE_RETIREDON,
          longint(@fSystemTime), 0);
    end;
    dlg.Free;
  end;
end;

procedure TManageMember.DBNavigator1BeforeAction(Sender: TObject;
  Button: TNavigateBtn);
var
  dlg: TMM_Delete;
  FName, s: string;
  fDoDelete: Boolean;
begin
  fDoDelete := false;
  if Button = nbDelete then
  begin
    dlg := TMM_Delete.Create(Self);
    // get the fullname of the member to delete
    FName := MM_CORE.qMember.FieldByName('FName').AsString;
    s := IntToStr(MM_CORE.GetMemberID);
    dlg.lblTitle.Caption := 'Delete (ID: ' + s + ') ' + FName +
      ' from the SwimClubMeet2 database ?';
    // display the confirm delete dlg
    if IsPositiveResult(dlg.ShowModal) then
      fDoDelete := true;
    dlg.Free;
    if not fDoDelete then
      // raises a silent exception - cancelling the action.
      Abort;
  end;
end;

function TManageMember.GotoMember(MemberID: Integer): Boolean;
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
    s := 'Filters must to be cleared to display this member.' + sLinebreak +
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

procedure TManageMember.Locate_MemberID(aMemberID: Integer);
begin
  if aMemberID > 0 then
  begin
    if Assigned(MM_CORE) and MM_CORE.IsActive then
    begin
      ListGrid.BeginUpdate;
      MM_CORE.LocateMember(aMemberID);
      ListGrid.EndUpdate;
    end;
  end;
end;

procedure TManageMember.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if assigned(MM_CORE) and (MM_CORE.IsActive) then
    MM_CORE.qMember.CheckBrowseMode;
end;

procedure TManageMember.FormCreate(Sender: TObject);
var
  LFormatSettings: TFormatSettings;
begin
  // ----------------------------------------------------
  // I N I T I A L I Z E   P A R A M S .
  // ----------------------------------------------------
  PageControl.TabIndex := 0;
  LFormatSettings := TFormatSettings.Create;
  Label11.Caption := 'Date Syntax : ' + LFormatSettings.ShortDateFormat;

  // ----------------------------------------------------
  // C R E A T E   D A T A M O D U L E .
  // ----------------------------------------------------
  if not Assigned(MM_CORE) then
  begin
    try
      MM_CORE := TMM_CORE.Create(Self);
      MM_CORE.ActivateMMD; // Uses SCM2 connection.
      if not MM_CORE.IsActive then Close;
      UpdateFilterCount; // # of records appears on filter button.
    except
      on E: EFDDBEngineException do
        SCM2.FDGUIxErrorDialog.Execute(E);
    end;
  end;

  // user  preferences for manage members...
  if Assigned(Settings) then
  begin
    if Settings.mm_ActivePageIndex in [0..2] then
      PageControl.ActivePageIndex := Settings.mm_ActivePageIndex;
  end;

end;

procedure TManageMember.FormDestroy(Sender: TObject);
begin
  if Assigned(Settings) then // store the active page index.
    Settings.mm_ActivePageIndex := PageControl.ActivePageIndex;
  if Assigned(MM_CORE) then
    FreeAndNil(MM_CORE);
end;

procedure TManageMember.FormShow(Sender: TObject);
begin
//  Update
  // Standard ShowModal disables the parent. We must re-enable it
  // so it can receive the mouse clicks we want to intercept.
//  if Application.MainForm <> nil then
//    EnableWindow(Application.MainForm.Handle, True);

end;

function TManageMember.GetMembersAge(aMemberID: Integer; aDate: TDate): Integer;
var
  aSQL: string;
  v: Variant;
  dt: TDateTime;
begin
  result := 0;
  if not AssertConnection then
    exit;
  with MM_CORE.qMember do
  begin
    if not Active or IsEmpty then
      exit;
    if FieldByName('DOB').IsNull then
      exit;
    dt := FieldByName('DOB').AsDateTime;

    aSQL := '''
      SELECT dbo.SwimmerAge(GETDATE(), :ID1) AS SwimmerAge
      FROM [SwimClubMeet2].[dbo].[Member]
      WHERE MemberID = :ID2
      ''';

    v := SCM2.scmConnection.ExecSQLScalar(aSQL, [dt, aMemberID],
      [ftDateTime, ftInteger]);
    if not VarIsNull(v) and not VarIsEmpty(v) and (v > 0) then
      result := v;
  end;
end;

procedure TManageMember.MemFile_ExitExecute(Sender: TObject);
begin
  Close();
end;

procedure TManageMember.MemSearch_FindMemberExecute(Sender: TObject);
begin
  btnFindMemberClick(Self);
end;

procedure TManageMember.MSG_AfterPost(var Msg: TMessage);
begin
  UpdateMembersAge;
end;

procedure TManageMember.MSG_AfterScroll(var Msg: TMessage);
begin
  UpdateMembersAge;
end;

procedure TManageMember.MSG_FilterChanged(var Msg: TMessage);
begin
  if not Assigned(MM_CORE) then exit;
  ListGrid.BeginUpdate;
  try
    if Assigned(Settings) then
      MM_CORE.UpdateFilterByParam(Settings.mm_HideArchived,
        Settings.mm_HideInActive, Settings.mm_HideNonSwimmer)
    else
      MM_CORE.UpdateFilterByParam(false, false, false);
  finally
    actnFilterUpdate(Self); // updates filter btn caption - displays recCount.
    ListGrid.EndUpdate;
  end;
end;

procedure TManageMember.Onlinehelp1Click(Sender: TObject);
var
  base_URL: string;
begin
  base_URL := 'http://artanemus.github.io/manual/index.htm';
  ShellExecute(0, NIL, PChar(base_URL), NIL, NIL, SW_SHOWNORMAL);

end;

procedure TManageMember.SCMwebsite1Click(Sender: TObject);
var
  base_URL: string;
begin
  // compiles just fine!
  // ShellExecute(0, 0, L"http://artanemus.github.io", 0, 0, SW_SHOW);
  base_URL := 'http://artanemus.github.io';
  ShellExecute(0, 'open', PChar(base_URL), NIL, NIL, SW_SHOWNORMAL);

end;

procedure TManageMember.UpdateFilterCount;
begin
  if Assigned(MM_CORE) then
    btnFilterByParam.Caption := 'Filter (' + IntToStr(MM_CORE.RecCount) + ')'
  else
    btnFilterByParam.Caption := 'Filter (..)';
end;

procedure TManageMember.UpdateMembersAge;
var
  dt: TDate;
  age: Integer;
begin
  lblMembersAge.Caption := '';
  if not AssertConnection then
    exit;
  with MM_CORE.qMember do
  BEGIN // calculate the age of the member
    if not Active or IsEmpty then
      exit;
    if FieldByName('MemberID').IsNull then
      exit;
    if FieldByName('DOB').IsNull then
      exit;
    dt := FieldByName('DOB').AsDateTime;
    if (dt <= 0) then
      exit;
    age := GetMembersAge(FieldByName('MemberID').AsInteger, dt);
    if (age <= 0) then
      exit;
    lblMembersAge.Caption := IntToStr(age);
  END;
end;


end.
