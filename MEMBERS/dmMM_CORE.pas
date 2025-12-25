unit dmMM_CORE;

interface

uses
  System.SysUtils, System.Classes,
  Windows, Winapi.Messages,
  Data.DB,

  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef,

  dmSCM2,

  uDefines, uSettings
  ;

type
  TMM_CORE = class(TDataModule)
    dsContactNum: TDataSource;
    dsGender: TDataSource;
    dsluSwimClub: TDataSource;
    dsMember: TDataSource;
    dsMemberRoleLnk: TDataSource;
    qryContactNum: TFDQuery;
    qryContactNumContactNumID: TFDAutoIncField;
    qryContactNumContactNumTypeID: TIntegerField;
    qryContactNumlu: TStringField;
    qryContactNumMemberID: TIntegerField;
    qryContactNumNumber: TWideStringField;
    qryMemberRoleLnk: TFDQuery;
    qryMemberRoleLnkCreatedOn: TSQLTimeStampField;
    qryMemberRoleLnkElectedOn: TSQLTimeStampField;
    qryMemberRoleLnkIsActive: TBooleanField;
    qryMemberRoleLnkIsArchived: TBooleanField;
    qryMemberRoleLnkluMemberRoleStr: TStringField;
    qryMemberRoleLnkMemberID: TIntegerField;
    qryMemberRoleLnkMemberRoleID: TIntegerField;
    qryMemberRoleLnkRetiredOn: TSQLTimeStampField;
    tblContactNumType: TFDTable;
    tblContactNumTypeCaption: TWideStringField;
    tblContactNumTypeContactNumTypeID: TFDAutoIncField;
    tblDistance: TFDTable;
    tblGender: TFDTable;
    tblMemberRole: TFDTable;
    tblStroke: TFDTable;
    tblSwimClub: TFDTable;
    qMember: TFDQuery;
    qMemberMemberID: TFDAutoIncField;
    qMemberMembershipNum: TIntegerField;
    qMemberMembershipStr: TWideStringField;
    qMemberFirstName: TWideStringField;
    qMemberMiddleName: TWideStringField;
    qMemberLastName: TWideStringField;
    qMemberDOB: TSQLTimeStampField;
    qMemberIsActive: TBooleanField;
    qMemberIsSwimmer: TBooleanField;
    qMemberIsArchived: TBooleanField;
    qMemberEmail: TWideStringField;
    qMemberGenderID: TIntegerField;
    qMemberFName: TWideStringField;
    qMemberCreatedOn: TSQLTimeStampField;
    qMemberArchivedOn: TSQLTimeStampField;
    qMemberTAGS: TWideMemoField;
    qMemberluGender: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure qDEPRECIATEDMemberOLDBeforeDelete(DataSet: TDataSet);
    procedure qMemberIsActiveGetText(Sender: TField; var Text: string; DisplayText:
        Boolean);
    procedure qMemberIsActiveSetText(Sender: TField; const Text: string);
    procedure qMemberNewRecord(DataSet: TDataSet);
    procedure qryMemberMETADATAGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure qryMemberMETADATASetText(Sender: TField; const Text: string);
    procedure qryMemberRoleLnkBeforePost(DataSet: TDataSet);
    procedure qryMemberRoleLnkElectedOnGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure qryMemberRoleLnkElectedOnSetText(Sender: TField;
      const Text: string);
    procedure qryMemberRoleLnkNewRecord(DataSet: TDataSet);
  private
    fHandle: HWND;
    fIsActive: Boolean;
    function GetRecCount: integer;
  protected
    procedure WndProc(var wndMsg: TMessage); virtual;
  public
    procedure ActivateMMD;
    procedure DeActivateMMD;
    function GetMemberID(): integer;
    function LocateMember(MemberID: Integer): Boolean;
    procedure UpdateDOB(DOB: TDateTime);
    procedure UpdateElectedOn(aDate: TDate);
    procedure UpdateFilterByParam(hideArchived, hideInactive, hideNonSwimmer:
        Boolean);
    procedure UpdateRetiredOn(aDate: TDate);
    procedure ClearDOB();

    property Handle: HWND read fHandle;
    property IsActive: boolean read FIsActive write FIsActive;
    property RecCount: integer read GetRecCount;
  end;

var
  MM_CORE: TMM_CORE;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

uses
  System.IOUtils, IniFiles, uUtility,
  vcl.Dialogs, System.UITypes, vcl.Forms, System.DateUtils;

procedure TMM_CORE.ActivateMMD;
begin
  fIsActive := false;

  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin

    qMember.Connection := SCM2.scmConnection;
    qryContactNum.Connection := SCM2.scmConnection;
    qryMemberRoleLnk.Connection := SCM2.scmConnection;
    // lookup tables.
    tblStroke.Connection := SCM2.scmConnection;
    tblDistance.Connection := SCM2.scmConnection;
    tblGender.Connection := SCM2.scmConnection;
    tblContactNumType.Connection := SCM2.scmConnection;
    tblMemberRole.Connection := SCM2.scmConnection;
    tblSwimClub.Connection := SCM2.scmConnection;


    qryContactNum.DisableControls;
    qryMemberRoleLnk.DisableControls;
    qMember.DisableControls;
    try
      try
        // Lookup tables...
        tblStroke.Open;
        tblDistance.Open;
        tblGender.Open;
        tblContactNumType.Open;
        tblMemberRole.Open;

        qMember.Open;
        if qMember.Active then
        begin
          qryContactNum.Open;
          qryMemberRoleLnk.Open;
          fIsActive := True;
        end;
      except
        on E: EFDDBEngineException do
          SCM2.FDGUIxErrorDialog.Execute(E);
      end;
    finally
      begin
        qMember.EnableControls;
        qryContactNum.EnableControls;
        qryMemberRoleLnk.EnableControls;
      end;
    end;
  end;
end;

procedure TMM_CORE.ClearDOB;
begin
  if not fIsActive then exit;
  if qMember.IsEmpty then exit;
  qMember.CheckBrowseMode;
  qMember.Edit;
  qMember.FieldByName('DOB').Clear;
  qMember.Post;
end;

procedure TMM_CORE.DataModuleCreate(Sender: TObject);
begin
  FIsActive := false;
  qMember.Connection := nil;
  qryContactNum.Connection := nil;
  qryMemberRoleLnk.Connection := nil;
  tblStroke.Connection := nil;
  tblDistance.Connection := nil;
  tblGender.Connection := nil;
  tblContactNumType.Connection := nil;
  tblMemberRole.Connection := nil;
  tblSwimClub.Connection := nil;
  fHandle := AllocateHWnd(WndProc);
end;

procedure TMM_CORE.DataModuleDestroy(Sender: TObject);
begin
  DeActivateMMD;
  DeallocateHWND(fHandle);
end;

procedure TMM_CORE.DeActivateMMD;
begin
  try
    tblStroke.Close;
    tblDistance.Close;
    tblGender.Close;
    tblContactNumType.Close;
    tblMemberRole.Close;
    qryContactNum.Close;
    qryMemberRoleLnk.Close;
    qMember.Close;
  finally
    fIsActive := false;
  end;
end;

function TMM_CORE.GetMemberID: integer;
begin
  result := 0;
  if qMember.Active then
    if not qMember.IsEmpty then
        result := qMember.FieldByName('MemberID').AsInteger;
end;

function TMM_CORE.GetRecCount: integer;
begin
  result := 0;
  if qMember.Active then
    result := qMember.RecordCount;
end;

function TMM_CORE.LocateMember(MemberID: Integer): Boolean;
var
  SearchOptions: TLocateOptions;
begin
  result := false;
  SearchOptions := [loPartialKey];

  qMember.DisableControls;
  qryContactNum.DisableControls;
  qryMemberRoleLnk.DisableControls;

  try
    try
      begin
        result := qMember.Locate('MemberID', MemberID, SearchOptions);
        if result then
        begin
          qryContactNum.ApplyMaster;
          qryMemberRoleLnk.ApplyMaster;
        end;
      end
    except
      on E: Exception do
        // lblErrMsg.Caption := 'SCM2 DB access error.';
    end;
  finally
    qMember.EnableControls;
    qryContactNum.EnableControls;
    qryMemberRoleLnk.EnableControls;

  end;
end;

  // As there is a calculation field (FNAME) in this query - the call to
  // refresh ensures that the main forms header banner will display the new
  // member's name.
  // ie. frmManageMember.DBTextFullName uses field qrMember.FNAME.
//  qryMember.Refresh;
//  if Owner is TForm then
//     Updates the display of the member's age.

//    PostMessage(TForm(Owner).Handle, SCM_MEMBER_AFTERPOST, 0, 0);
//    qryMember.Refresh;
    // Updates the display of the member's age.
//    if Owner is TForm then
//      PostMessage(TForm(Owner).Handle, SCM_MEMBER_SCROLL, 0, 0);procedure TMM_CORE.qDEPRECIATEDMemberOLDAfterPost(DataSet: TDataSet);


procedure TMM_CORE.qDEPRECIATEDMemberOLDBeforeDelete(DataSet: TDataSet);
var
  SQL: string;
  MemberID: Integer;
  tmpQry: TFDQuery;
begin
  // Best to finalize any editing - prior to calling execute statements.
  // DataSet.CheckBrowseMode;



  MemberID := DataSet.FieldByName('MemberID').AsInteger;
  if MemberID <> 0 then
  begin

  {
    // second chance to abort delete - but only displayed if there is entrant data with race-times
    // could have used SCMConnection.ExecScalar(SQL, [MemberID]).
    qryEntrantDataCount.Connection := SCM2.scmConnection;
    // FYI - assignment of connection typically sets DS state to closed.
    qryEntrantDataCount.Close;
    qryEntrantDataCount.ParamByName('MEMBERID').AsInteger := MemberID;
    qryEntrantDataCount.Prepare;
    qryEntrantDataCount.Open;
    if qryEntrantDataCount.Active then
    begin
      if qryEntrantDataCount.FieldByName('TOT').AsInteger > 0 then
      begin
        result := MessageDlg('This member has race-time data!' + sLineBreak +
          'Are you sure you want to delete the member?',
          TMsgDlgType.mtConfirmation, [mbYes, mbNo], 0, mbNo);
        if IsNegativeResult(result) then
        begin
          qryEntrantDataCount.Close; // tidy up...?
          Abort;
        end;
      end;
      qryEntrantDataCount.Close;
    end;
  }

    // remove all C O N T A C T N U Mbers for this member.
    SQL := 'DELETE FROM [SwimClubMeet2].[dbo].[ContactNum] WHERE MemberID = ' +
      IntToStr(MemberID) + ';';
    SCM2.scmConnection.ExecSQL(SQL);
    // remove all R O L E S assigned to this member held in linked-list.
    SQL := 'DELETE FROM [SwimClubMeet2].[dbo].[MemberRoleLink] WHERE MemberID = '
      + IntToStr(MemberID) + ';';
    SCM2.scmConnection.ExecSQL(SQL);

    // remove all split data for indv events
    SQL := 'SELECT EntrantID FROM [SwimClubMeet2].[dbo].Entrant WHERE MemberID = ' +
      IntToStr(MemberID) + ';';
    tmpQry := TFDQuery.Create(self);
    tmpQry.Connection := SCM2.scmConnection;
    tmpQry.SQL.Add(SQL);
    tmpQry.IndexFieldNames := 'EntrantID';
    tmpQry.Open;
    if tmpQry.Active then
    begin
      while not tmpQry.Eof do
      begin
        SQL := 'DELETE FROM [SwimClubMeet2].[dbo].[Split] WHERE EntrantID = ' +
          IntToStr(tmpQry.FieldByName('EntrantID').AsInteger) + ';';
        SCM2.scmConnection.ExecSQL(SQL);
        tmpQry.Next;
      end;
    end;
    tmpQry.Close;
    tmpQry.Free;

    // Remove all split data assigned to TeamEntrant for TEAM EVENT
    // NOTE: no individual split data store for members in relays.
    // Split data is linked to dbo.Team.

    // ENTRANTS
    SQL := 'UPDATE [SwimClubMeet2].[dbo].[Entrant] SET [MemberID] = NULL, ' +
      '[RaceTime] = NULL, [TTB] = NULL, [PersonalBest] = NULL, ' +
      '[IsDisqualified] = 0,[IsScratched] = 0, DisqualifyCodeID = NULL WHERE MemberID = ' +
      IntToStr(MemberID) + ';';
    SCM2.scmConnection.ExecSQL(SQL);
    // TEAM ENTRANTS
    SQL := 'UPDATE [SwimClubMeet2].[dbo].[TeamEntrant] SET [MemberID] = NULL, ' +
      '[RaceTime] = NULL, [TTB] = NULL, [PersonalBest] = NULL, ' +
      '[IsDisqualified] = 0,[IsScratched] = 0, DisqualifyCodeID = NULL WHERE MemberID = ' +
      IntToStr(MemberID) + ';';
    SCM2.scmConnection.ExecSQL(SQL);

    // DELETE MEMBERS NOMINATIONS TO EVENTS
    SQL := 'DELETE FROM [SwimClubMeet2].[dbo].[Nominee] WHERE MemberID = ' +
      IntToStr(MemberID) + ';';
    SCM2.scmConnection.ExecSQL(SQL);

    { TODO -oBen -cGeneral : Version 1.5.5.4 uses a linked list to SwimClub ... }
    (*
      SQL := 'DELETE FROM [SwimClubMeet2].[dbo].[lnkSwimClubMember] WHERE MemberID = '
      + IntToStr(MemberID) + ' AND SwimClubID = ' +
      IntToStr(qrySwimClub.FieldByName('SwimClubID').AsInteger) + ';';
      SCM2.scmConnection.ExecSQL(SQL);
    *)


  end;
end;

procedure TMM_CORE.qMemberIsActiveGetText(Sender: TField; var Text: string;
    DisplayText: Boolean);
var
  LFormatSettings: TFormatSettings;
begin
  LFormatSettings := TFormatSettings.Create; // Use the system locale
  if (Sender.IsNull) or (DateOf(Sender.AsDateTime) = 0) then
    Text := ''
  else
    Text := FormatDateTime('ddddd', Sender.AsDateTime, LFormatSettings);
end;

procedure TMM_CORE.qMemberIsActiveSetText(Sender: TField; const Text: string);
var
  dt: TDateTime;
  LFormatSettings: TFormatSettings;
begin
  LFormatSettings := TFormatSettings.Create; // Use the system locale
  if Text.IsNullOrEmpty(Text) then Sender.Clear
  else
  begin
    try
      dt := StrToDate(Text, LFormatSettings);
      Sender.AsDateTime := dt;
    except
      on E: EConvertError do
      begin
        ShowMessage('Invalid date format: ' + E.Message);
      end;
    end;
  end;
end;

procedure TMM_CORE.qMemberNewRecord(DataSet: TDataSet);
var
  fld: TField;
begin
  fld := DataSet.FieldByName('IsArchived');
    if Assigned(fld) then fld.AsBoolean := false;
  fld := DataSet.FieldByName('IsActive');
    if Assigned(fld) then fld.AsBoolean := true;
  fld := DataSet.FieldByName('IsSwimmer');
    if Assigned(fld) then fld.AsBoolean := true;
end;

procedure TMM_CORE.qryMemberMETADATAGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := Sender.AsString;
end;

procedure TMM_CORE.qryMemberMETADATASetText(Sender: TField;
  const Text: string);
begin
  Sender.AsString := Text;
end;

procedure TMM_CORE.qryMemberRoleLnkBeforePost(DataSet: TDataSet);
var
  // SQL: string;
  // v: variant;
  fld: TField;
begin
  // Validate MemberRoleID
  fld := DataSet.FieldByName('MemberRoleID');
  if Assigned(fld) AND (fld.IsNull) then
  begin
    // raise Exception.Create('A member''s role must be assigned.');
    Abort;
  end;

  {
    // test for duplicity ...
    SQL := 'SELECT COUNT(MemberRoleID) FROM dbo.MemberRoleLink WHERE MemberRoleID = '
    + IntToStr(fld.AsInteger);
    v := SCM2.scmConnection.ExecSQLScalar(SQL);
    if (v <> 0) then
    begin
    // raise Exception.Create('A member cannot have the same role twice.');
    Abort;
    end;
  }

  // NULL NOT ALLOWED
  fld := DataSet.FieldByName('IsArchived');
  if Assigned(fld) AND (fld.IsNull) then
    fld.AsBoolean := false;
  // NULL NOT ALLOWED
  fld := DataSet.FieldByName('IsActive');
  if Assigned(fld) AND (fld.IsNull) then
    fld.AsBoolean := false;
  // Creation date.
  fld := DataSet.FieldByName('CreatedOn');
  if Assigned(fld) AND (fld.IsNull) then
    fld.AsDateTime := Now;

end;

procedure TMM_CORE.qryMemberRoleLnkElectedOnGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
var
  LFormatSettings: TFormatSettings;
begin
  // Set up format settings using current system locale
  LFormatSettings := TFormatSettings.Create;
  if (Sender.IsNull) or (DateOf(Sender.AsDateTime) = 0) then
    Text := ''
  else
    Text := FormatDateTime('dd.mm.yy', Sender.AsDateTime, LFormatSettings);
end;

procedure TMM_CORE.qryMemberRoleLnkElectedOnSetText(Sender: TField;
  const Text: string);
var
  dt: TDateTime;
  LFormatSettings: TFormatSettings;
begin
  // // Set up format settings using current system locale
  LFormatSettings := TFormatSettings.Create;
  {
    LFormatSettings.DateSeparator := '-';
    LFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
    LFormatSettings.TimeSeparator := ':';
    LFormatSettings.LongTimeFormat := 'hh:nn:ss';
  }
  if Text.IsNullOrEmpty(Text) then
    Sender.Clear
  else
  begin
    try
      dt := StrToDate(Text, LFormatSettings);
      Sender.AsDateTime := dt;
    except
      on E: EConvertError do
      begin
        ShowMessage('Invalid date format: ' + E.Message);
      end;
    end;
  end;
end;

procedure TMM_CORE.qryMemberRoleLnkNewRecord(DataSet: TDataSet);
var
  fld: TField;
begin
  fld := DataSet.FieldByName('IsArchived');
  if (fld.IsNull) then
  begin
    fld.AsBoolean := false;
  end;
  fld := DataSet.FieldByName('IsActive');
  if (fld.IsNull) then
  begin
    fld.AsBoolean := True;
  end;
  fld := DataSet.FieldByName('CreatedOn');
  fld.AsDateTime := Now;

  // fld := DataSet.FieldByName('MemberID');
  // if (fld.IsNull) then
  // begin
  // fld.AsInteger := DataSet.FieldByName('MemberID').AsInteger;
  // end;
  // fld := DataSet.FieldByName('MemberRoleID');
  // if (fld.IsNull) then
  // begin
  // fld.AsInteger := 0;
  // end;
end;



procedure TMM_CORE.UpdateDOB(DOB: TDateTime);

begin
  if Assigned(qMember.Connection) and (qMember.Active) then
  begin
    qMember.DisableControls;
    qMember.edit;
    qMember.FieldByName('DOB').AsDateTime := DOB;
    qMember.Post;
    qMember.EnableControls;
  end;
end;

procedure TMM_CORE.UpdateElectedOn(aDate: TDate);
begin
  if Assigned(qMember.Connection) and (qMember.Active) then
  begin
    qMember.DisableControls;
    qMember.edit;
    qMember.FieldByName('ElectedOn').AsDateTime := aDate;
    qMember.Post;
    qMember.EnableControls;
  end;
end;

procedure TMM_CORE.UpdateFilterByParam(hideArchived, hideInactive,
    hideNonSwimmer: Boolean);
begin
  qryContactNum.DisableControls;
  qryMemberRoleLnk.DisableControls;
  qMember.DisableControls;

  if hideArchived and not hideInactive and not hideNonSwimmer then
    qMember.IndexName := 'idxHideArchived';
  if not hideArchived and hideInactive and not hideNonSwimmer then
    qMember.IndexName := 'idxHideInActive';
  if not hideArchived and not hideInactive and hideNonSwimmer then
    qMember.IndexName := 'idxHideNonSwimmer';
  if hideArchived and hideInactive and not hideNonSwimmer then
    qMember.IndexName := 'idxArchivedInActive';
  if hideArchived and hideInactive and hideNonSwimmer then
    qMember.IndexName := 'idxArchivedInActiveNonSwimmer';
  if not hideArchived and hideInactive and hideNonSwimmer then
    qMember.IndexName := 'idxInActiveNonSwimmer';
  if hideArchived and not hideInActive and hideNonSwimmer then
    qMember.IndexName := 'idxArchivedNonSwimmer';
  if not hideArchived and not hideInActive and not hideNonSwimmer then
    qMember.IndexName := 'idxFilterOff';
  try
    begin
      qryContactNum.ApplyMaster;
      qryMemberRoleLnk.ApplyMaster;
    end;
  finally
    begin
      qMember.EnableControls;
      qryContactNum.EnableControls;
      qryMemberRoleLnk.EnableControls;
    end;

  end;
end;


procedure TMM_CORE.UpdateRetiredOn(aDate: TDate);
begin
  if fIsActive then
  begin
    qMember.DisableControls;
    qMember.edit;
    qMember.FieldByName('RetiredOn').AsDateTime := aDate;
    qMember.Post;
    qMember.EnableControls;
  end;
end;

procedure TMM_CORE.WndProc(var wndMsg: TMessage);
var
  dt, currDt: TDateTime;
  fldName: string;
  st: TSystemTime;
  aMemberID: integer;

begin
  if (wndMsg.WParam = 0) then
    exit;

  if (wndMsg.Msg = SCM_MEMBER_LOCATE) then
  begin
    aMemberID := wndMsg.WParam;
    LocateMember(aMemberID);
  end;


  if (wndMsg.Msg = SCM_MEMBER_UPDATE_DOB) OR (wndMsg.Msg = SCM_MEMBER_UPDATE_ELECTEDON) OR
    (wndMsg.Msg = SCM_MEMBER_UPDATE_RETIREDON) then
  BEGIN
    case wndMsg.Msg of
      SCM_MEMBER_UPDATE_DOB:
        fldName := 'DOB';
      SCM_MEMBER_UPDATE_ELECTEDON:
        fldName := 'ElectedOn';
      SCM_MEMBER_UPDATE_RETIREDON:
        fldName := 'RetiredOn';
    end;

    try
      st := pSystemTime(wndMsg.WParam)^;
      if (st.wYear = 0) then
        dt := 0
      else
      begin
        dt := SystemTimeToDateTime(st);
      end;
    except
      on E: Exception do
        raise;
    end;
    {TODO -oBSA -cGeneral : IsNul?}
    currDt := qMember.FieldByName(fldName).AsDateTime;
    if dt <> currDt then
    BEGIN
      qMember.DisableControls;
      if (qMember.State <> dsEdit) or
        (qMember.State <> dsInsert) then
      begin
        qMember.CheckBrowseMode;
        qMember.edit;
      end;
      if (dt = 0) then
        qMember.FieldByName(fldName).Clear
      else
        qMember.FieldByName(fldName).AsDateTime := dt;
      qMember.Post;
      qMember.EnableControls;
    END;

  END;

end;

end.
