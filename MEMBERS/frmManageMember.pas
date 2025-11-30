unit frmManageMember;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  System.ImageList, System.Actions, System.Rtti, System.Bindings.Outputs,

  Data.DB,  Data.Bind.EngExt, Data.Bind.Components, Data.Bind.DBScope,

  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,  VclTee.TeeGDIPlus,
  Vcl.StdCtrls, VclTee.TeEngine,
  VclTee.TeeSpline, VclTee.Series, VclTee.TeeProcs, VclTee.Chart,
  VclTee.DBChart, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.Menus, Vcl.WinXCalendars,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Vcl.ToolWin, Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.Bind.DBEngExt,
  VclTee.TeeData, Vcl.Buttons,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Vcl.ImgList,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet,

  Vcl.Bind.Editors,
  Vcl.VirtualImage,
  Vcl.ButtonGroup,

  dmManageMemberData, uDefines,
  dlgFilterByParam, // persistent dlg.
  dlgFilterBySwimClub, AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid, dmSCM2 // persistent dlg.
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
    btnFilter: TButton;
    btnFilterClub: TButton;
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
    DBGrid3: TDBGrid;
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
    Label19: TLabel;
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
    PageControl1: TPageControl;
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
    procedure About2Click(Sender: TObject);
    procedure actnFilterClubExecute(Sender: TObject);
    procedure actnFilterExecute(Sender: TObject);
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
    { Private declarations }
    fColorBgColor: TColor;
    fColorEditBoxFocused: TColor;
    fColorEditBoxNormal: TColor;
    FConnection: TFDConnection;
    fFilterDlg: TFilterByParam;
    fHideArchived: Boolean;
    fHideInActive: Boolean;
    fHideNonSwimmer: Boolean;

    // Used to convert DATETIME and then post TMessage to Member DataModule.
    fSystemTime: TSystemTime;
    function AssertConnection: Boolean;
    function GotoMember(MemberID: Integer): Boolean;
    function GetMembersAge(aMemberID: Integer; aDate: TDate): Integer;
    procedure ReadPreferences(aIniFileName: string);
    procedure UpdateFilterCount();
    procedure UpdateMembersAge();
    procedure WritePreferences();
  protected
    procedure MSG_AfterPost(var Msg: TMessage); message SCM_MEMBER_AFTERPOST;
    procedure MSG_AfterScroll(var Msg: TMessage); message SCM_MEMBER_AFTERSCROLL;
    procedure MSG_ChangeSwimClub(var Msg: TMessage); message SCM_MEMBER_FILTER_SWIMCLUB;
    procedure MSG_FilterDeactivated(var Msg: TMessage); message SCM_MEMBER_FILTER_DEACTIVATED;
    procedure MSG_FilterChanged(var Msg: TMessage); message
        SCM_MEMBER_FILTER_CHANGED;
  public
    { Public declarations }
    procedure Prepare(AConnection: TFDConnection; aMemberID: Integer = 0);
  end;

const
  INIFILE_SCM_MEMBERPREF = 'SCM_MemberPref.ini';
  INIFILE_SECTION = 'SCM_Member';

var
  ManageMember: TManageMember;

implementation

{$R *.dfm}

uses
  System.DateUtils,
  System.IniFiles,
  System.UITypes,
  System.IOUtils,
  Winapi.ShellAPI,
  dlgDeleteMember,
  Vcl.Themes,
  SCMUtils,
  dlgDatePicker,
  dlgFindMember_ID,
  dlgFindMember_Membership,
  dlgFindMember_FName,
  rptMemberDetail,
  rptMemberHistory,
  rptMemberChart,
  rptMemberCheckData,
  dlgAboutManageMember, uSwimClub;

  // dlgBasicLogin,  dlgAbout,

procedure TManageMember.About2Click(Sender: TObject);
var
  dlg: TAboutManageMember;
begin
  dlg := TAboutManageMember.Create(Self);
  dlg.ShowModal;
  FreeAndNil(dlg);
end;

procedure TManageMember.actnFilterClubExecute(Sender: TObject);
//var
//  dlg: TFilterBySwimClub;
begin
  if not assigned(FConnection) then
    exit;
  {TODO -oBSA -cGeneral : Make dlg persistent. }
{
dlg := TFilterBySwimClub.Create(Self);
if IsPositiveResult(dlg.ShowModal) then
begin
  SendMessage(Handle, SCM_MEMBER_CHANGE_SWIMCLUB, 0, 0);
end;
dlg.Free;
}
end;

procedure TManageMember.actnFilterExecute(Sender: TObject);
var
  aRect: TRect;
begin
  if assigned(fFilterDlg) then
  begin
    FreeAndNil(fFilterDlg);
    exit;
  end;

  WritePreferences;

  fFilterDlg := TFilterByParam.Create(Self);
  fFilterDlg.Position := poDesigned;
  aRect := btnFilter.ClientToScreen(btnFilter.ClientRect);
  fFilterDlg.Left := aRect.Left;
  fFilterDlg.Top := aRect.Bottom + 1;
  fFilterDlg.Show;
end;

function TManageMember.AssertConnection: Boolean;
begin
  result := false;
  // test datamodule construction
  if assigned(ManageMemberData) then
  begin
    // IsActive if TFDConnection::scmConnection && FireDAC tables are active
    if ManageMemberData.IsActive then
      result := true;
  end;
end;

procedure TManageMember.btnClearDOBClick(Sender: TObject);
begin
  if not assigned(ManageMemberData) then
    exit;
  with ManageMemberData.dsMember.DataSet do
  begin
    if not(Active) then
      exit;
    if (State <> dsInsert) or (State <> dsEdit) then
      Edit;
    FieldByName('DOB').Clear;
  end;
end;

procedure TManageMember.btnDOBPickerClick(Sender: TObject);
var
  dlg: TDatePicker;
  Rect: TRect;
  rtn: TModalResult;
begin
  dlg := TDatePicker.Create(Self);
  dlg.Position := poDesigned;
  // Assign date to DB Field.
  Rect := btnDOBPicker.ClientToScreen(btnDOBPicker.ClientRect);
  dlg.Left := Rect.Left;
  dlg.Top := Rect.Bottom + 1;
  dlg.CalendarView1.Date := ManageMemberData.dsMember.DataSet.FieldByName('DOB')
    .AsDateTime;
  rtn := dlg.ShowModal;
  if IsPositiveResult(rtn) then
  begin
    with ManageMemberData.dsMember.DataSet do
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
  begin
    // LOCATE MEMBER IN qryMember
    GotoMember(dlg.MemberID)
  end;
  dlg.Free;
end;

procedure TManageMember.btnGotoMemberIDClick(Sender: TObject);
var
  dlg: TFindMember_ID;
  rtn: TModalResult;
begin
  if assigned(ManageMemberData) then
  begin
    dlg := TFindMember_ID.Create(Self);
    rtn := dlg.ShowModal;
    if IsPositiveResult(rtn) then
    begin
      // LOCATE MEMBER IN qryMember
      GotoMember(dlg.MemberID)
    end;
    dlg.Free;
  end;
end;

procedure TManageMember.btnGotoMembershipClick(Sender: TObject);
var
  dlg: TFindMember_Membership;
  rtn: TModalResult;
begin
  if assigned(ManageMemberData) then
  begin
    dlg := TFindMember_Membership.Create(Self);
    rtn := dlg.ShowModal;
    if IsPositiveResult(rtn) then
    begin
      // NOTE: returns both MembershipNum and MemberID
      // LOCATE MEMBER IN qryMember
      GotoMember(dlg.MemberID)
    end;
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
  BalloonHint1.Description := 'SCM uses ''Short Date'' locale format.' +
    sLinebreak +
    'To modify how dates are displayed and the syntax used to enter dates, ' +
    sLinebreak + 'go to the ''Region Settings'' in MS Windows. ';
  BalloonHint1.ShowHint(btnInfoDateTime);
end;

procedure TManageMember.btnInfoFilterClick(Sender: TObject);
begin
  BalloonHint1.Title := 'Filter ...';
  BalloonHint1.Description := 'Click the main form to close.' + sLinebreak +
    'Displays the number of records found' + sLinebreak +
    'using the current filter settings.';
  BalloonHint1.ShowHint(btnInfoFilter);
end;

procedure TManageMember.btnInfoMouseLeave(Sender: TObject);
begin
  BalloonHint1.HideHint;
end;

procedure TManageMember.btnInfoRolesClick(Sender: TObject);
begin
  BalloonHint1.Title := 'Membership Roles.';
  BalloonHint1.Description := 'To enter a start or end date, select the cell' +
    sLinebreak + 'and then press the ellipse button.' + sLinebreak +
    'To clear a selected cell, press ALT-BACKSPACE.' + sLinebreak +
    'To delete a record, press CTRL-DEL';
  BalloonHint1.ShowHint(btnInfoRoles);
end;

procedure TManageMember.btnMemberDetailClick(Sender: TObject);
var
  rpt: TMemberDetail;
begin
  if not assigned(ManageMemberData) then
    exit;
  rpt := TMemberDetail.Create(Self);
  rpt.RunReport(FConnection, ManageMemberData.GetMemberID,
    ManageMemberData.GetMemberID);
  rpt.Free;
end;

procedure TManageMember.btnMemberHistoryClick(Sender: TObject);
var
  rpt: TMemberHistory;
begin
  if not assigned(ManageMemberData) then
    exit;
  rpt := TMemberHistory.Create(Self);
  rpt.RunReport(FConnection, ManageMemberData.GetMemberID,
    ManageMemberData.GetMemberID);
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
var
  clFont, clBg: TColor;
begin
  // NOTE: DEFAULT DRAWING IS DISABLED ....
  // NOTE: DO NOT ENABLE TDBGRID OPTION dgAlwaysShowEditor.
  // (inconsistent OS MESSAGING)
  if (Column.Field.FieldName = 'IsActive') or
    (Column.Field.FieldName = 'IsArchived') or
    (Column.Field.FieldName = 'IsSwimmer') then
  begin
    if gdFocused in State then
      clFont := fColorEditBoxFocused
    else
      clFont := fColorEditBoxNormal;
    clBg := fColorBgColor;
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
        // ALT: ManageMemberData.UpdateDOB(cal.CalendarView1.Date);
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
        PostMessage(ManageMemberData.Handle, SCM_MEMBER_UPDATE_ELECTEDON,
          longint(@fSystemTime), 0)
      else
        PostMessage(ManageMemberData.Handle, SCM_MEMBER_UPDATE_RETIREDON,
          longint(@fSystemTime), 0);
    end;
    dlg.Free;
  end;
end;

procedure TManageMember.DBNavigator1BeforeAction(Sender: TObject;
  Button: TNavigateBtn);
var
  dlg: TDeleteMember;
  FName, s: string;
  fDoDelete: Boolean;
begin
  fDoDelete := false;
  if Button = nbDelete then
  begin
    dlg := TDeleteMember.Create(Self);
    // get the fullname of the member to delete
    FName := ManageMemberData.dsMember.DataSet.FieldByName('FName').AsString;
    s := IntToStr(ManageMemberData.GetMemberID);
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
  b := ManageMemberData.LocateMember(MemberID);
  if b then
    result := true
  else
  begin
    s := 'Filters must to be cleared to display this member.' + sLinebreak +
      'Clear the filters?';
    rtn := MessageDlg(s, TMsgDlgType.mtConfirmation, mbYesNo, 0);
    if IsPositiveResult(rtn) then
    begin
      fHideArchived := false;
      fHideInActive := false;
      fHideNonSwimmer := false;
      // run filter on form
      ManageMemberData.UpdateMember(fHideArchived, fHideInActive,
        fHideNonSwimmer);
      actnFilter.Caption := 'Filter (' +
        IntToStr(ManageMemberData.RecordCount) + ')';
      b := ManageMemberData.LocateMember(MemberID);
      if b then
        result := true;
    end;
  end;
end;

procedure TManageMember.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Test database state
  if assigned(ManageMemberData) and (ManageMemberData.qryMember.Active) then
  begin
    if (ManageMemberData.qryMember.State = dsEdit) or
      (ManageMemberData.qryMember.State = dsInsert) then
      ManageMemberData.qryMember.Post();
  end;
end;

procedure TManageMember.FormCreate(Sender: TObject);
var
  css: TCustomStyleServices;
  LFormatSettings: TFormatSettings;
begin
  // ----------------------------------------------------
  // I N I T I A L I Z E   P A R A M S .
  // ----------------------------------------------------
  fHideArchived := false;
  fHideInActive := false;
  fHideNonSwimmer := false;
  fFilterDlg := nil;

  // Special color assignment - used in TDBGrid painting...
  // -------------------------------------------
  css := TStyleManager.Style[TStyleManager.ActiveStyle.Name];
  if assigned(css) then
  begin
    fColorEditBoxFocused := css.GetStyleFontColor(sfEditBoxTextFocused);
    fColorEditBoxNormal := css.GetStyleFontColor(sfEditBoxTextNormal);
    fColorBgColor := css.GetStyleColor(scGrid);
  end
  else
  begin
    fColorEditBoxFocused := cardinal(clWebTomato); // TColors.Tomato;
    fColorEditBoxNormal := cardinal(clWindowText); // TColors.SysWindowText;
    fColorBgColor := cardinal(clAppWorkSpace); // TColors.SysAppWorkSpace;
  end;

  // Display tabsheet
  PageControl1.TabIndex := 0;
  LFormatSettings := TFormatSettings.Create;
  Label11.Caption := 'Date Syntax : ' + LFormatSettings.ShortDateFormat;

end;

procedure TManageMember.FormDestroy(Sender: TObject);
begin
  WritePreferences;
  if assigned(fFilterDlg) then
    fFilterDlg.Free;
end;

procedure TManageMember.FormShow(Sender: TObject);
var
  iniFileName: string;
begin
  // ----------------------------------------------------
  // R E A D   P R E F E R E N C E S .
  // ----------------------------------------------------
  iniFileName := SCMUtils.GetSCMPreferenceFileName;
  ReadPreferences(iniFileName);
  if not AssertConnection then
    exit;

  // run filter
  ManageMemberData.UpdateMember(fHideArchived, fHideInActive, fHideNonSwimmer);
  UpdateFilterCount;

  // display record count
  actnFilter.Caption := 'Filter (' +
    IntToStr(ManageMemberData.RecordCount) + ')';
end;

function TManageMember.GetMembersAge(aMemberID: Integer; aDate: TDate): Integer;
var
  SQL: string;
  v: Variant;
  dt: TDateTime;
begin
  result := 0;
  if not AssertConnection then
    exit;
  with ManageMemberData.dsMember.DataSet do
  begin
    if not Active or IsEmpty then
      exit;
    if FieldByName('DOB').IsNull then
      exit;
    dt := FieldByName('DOB').AsDateTime;
    SQL := 'SELECT dbo.SwimmerAge(GETDATE(), :ID1) AS SwimmerAge FROM ' +
      '[SwimClubMeet2].[dbo].[Member] WHERE MemberID = :ID2';
    v := FConnection.ExecSQLScalar(SQL, [dt, aMemberID],
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

procedure TManageMember.MSG_ChangeSwimClub(var Msg: TMessage);
//var
//  aMemberID: Integer;
begin
{
  // already displaying the requested Club.
  if Msg.LParam = ManageMemberData.qrySwimClub.FieldByName('SwimClubID').AsInteger
  then
    exit;

  if Msg.LParam = 0 then
  begin
    ManageMemberData.qrySwimClub.First;
    exit;
  end;

  // it's posible that the current member is also assigned to requested Club.
  aMemberID := ManageMemberData.GetMemberID;
  if ManageMemberData.LocateSwimClub(Msg.LParam) then
  begin
    // SYNC MEMBER'S DATA.
    ManageMemberData.UpdateMember(fHideArchived, fHideInActive,
      fHideNonSwimmer);
    actnFilter.Caption := 'Filter (' +
      IntToStr(ManageMemberData.RecordCount) + ')';
  end;
  if aMemberID > 0 then
    PostMessage(ManageMemberData.Handle, SCM_MEMBER_LOCATE, aMemberID, 0);
  }
end;

procedure TManageMember.MSG_FilterDeactivated(var Msg: TMessage);
begin
  if assigned(fFilterDlg) then
    FreeAndNil(fFilterDlg);
end;

procedure TManageMember.MSG_FilterChanged(var Msg: TMessage);
var
  CopyData: PCopyDataStruct;
  FilterState: PFilterState;
begin
  if Msg.LParam = 0 then
    exit;
  try
    begin
      CopyData := PCopyDataStruct(Msg.LParam);
      FilterState := PFilterState(CopyData^.lpData);
      // access the fields of the record.
      fHideArchived := FilterState^.HideArchived;
      fHideInActive := FilterState^.HideInActive;
      fHideNonSwimmer := FilterState^.HideNonSwimmer;
    end
  finally
    begin
      ManageMemberData.UpdateMember(fHideArchived, fHideInActive,
        fHideNonSwimmer);

      actnFilter.Caption := 'Filter (' +
        IntToStr(ManageMemberData.RecordCount) + ')';
    end;
  end;

end;

procedure TManageMember.Onlinehelp1Click(Sender: TObject);
var
  base_URL: string;
begin
  base_URL := 'http://artanemus.github.io/manual/index.htm';
  ShellExecute(0, NIL, PChar(base_URL), NIL, NIL, SW_SHOWNORMAL);

end;

procedure TManageMember.Prepare(AConnection: TFDConnection; aMemberID: Integer
    = 0);
begin
  FConnection := AConnection;

  // ----------------------------------------------------
  // C R E A T E   D A T A M O D U L E   S C M .
  // ----------------------------------------------------
  try
    ManageMemberData := TManageMemberData.Create(Self); // uses SCM2.scmConnection
  finally
    // with ManageMemberData created and the essential tables are open then
    // asserting the connection should be true
    if not assigned(ManageMemberData) then
      raise Exception.Create('Manage Member''s Data Module creation error.');
  end;

  // ----------------------------------------------------
  // Check that ManageMemberData is active .
  // fails if SCM2 isn't connected
  // ----------------------------------------------------
  ManageMemberData.ActivateMMD;
  if not ManageMemberData.IsActive then
  begin
    MessageDlg('An error occurred during MSSQL table activation.' + sLinebreak +
      'The database''s schema may need updating.' + sLinebreak +
      'The application will terminate!', mtError, [mbOk], 0);
    raise Exception.Create('ManageMemberData Member not active.');
  end;

  ManageMemberData.qryMember.First;
  // ASSUMPTION: at least one swimming club...


  if aMemberID > 0 then
    PostMessage(ManageMemberData.Handle, SCM_MEMBER_LOCATE, aMemberID, 0);
end;

procedure TManageMember.ReadPreferences(aIniFileName: string);
var
  i: Integer;
  iFile: TIniFile;
begin
  // ---------------------------------------------------------
  // A S S I G N   MANAGEMEMBER  P R E F E R E N C E S ...
  // ---------------------------------------------------------
  if not FileExists(aIniFileName) then
    exit;
  iFile := TIniFile.Create(aIniFileName);
  fHideArchived := iFile.ReadBool(INIFILE_SECTION, 'HideArchived', true);
  fHideInActive := iFile.ReadBool(INIFILE_SECTION, 'HideInActive', false);
  fHideNonSwimmer := iFile.ReadBool(INIFILE_SECTION, 'HideNonSwimmer', false);
  i := iFile.ReadInteger(INIFILE_SECTION, 'TabIndex', -1);
  // test bounds
  if ((i > -1) and (i < PageControl1.PageCount)) then
    PageControl1.ActivePageIndex := i;

  iFile.Free;
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
  if not AssertConnection then
    exit;
  // display record count
  actnFilter.Caption := 'Filter (' +
    IntToStr(ManageMemberData.RecordCount) + ')';
end;

procedure TManageMember.UpdateMembersAge;
var
  dt: TDate;
  age: Integer;
begin
  lblMembersAge.Caption := '';
  if not AssertConnection then
    exit;
  with ManageMemberData.dsMember.DataSet do
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

procedure TManageMember.WritePreferences;
var
  iFile: TIniFile;
  iniFileName: string;
begin
  iniFileName := SCMUtils.GetSCMPreferenceFileName;
  if not FileExists(iniFileName) then
    exit;
  iFile := TIniFile.Create(iniFileName);
  iFile.WriteBool(INIFILE_SECTION, 'HideArchived', fHideArchived);
  iFile.WriteBool(INIFILE_SECTION, 'HideInActive', fHideInActive);
  iFile.WriteBool(INIFILE_SECTION, 'HideNonSwimmer', fHideNonSwimmer);
  iFile.WriteInteger(INIFILE_SECTION, 'TabIndex', PageControl1.ActivePageIndex);

  iFile.Free;
end;

end.
