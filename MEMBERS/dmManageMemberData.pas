unit dmManageMemberData;

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
  TManageMemberData = class(TDataModule)
    cmdFixNullBooleans: TFDCommand;
    dsChart: TDataSource;
    dsContactNum: TDataSource;
    dsDataCheck: TDataSource;
    dsDataCheckPart: TDataSource;
    dsFindMember: TDataSource;
    dsGender: TDataSource;
    dsluSwimClub: TDataSource;
    dsMember: TDataSource;
    dsMemberEvents: TDataSource;
    dsMemberPB: TDataSource;
    dsMemberRoleLnk: TDataSource;
    dsSwimClub: TDataSource;
    qAssertMemberID: TFDQuery;
    qryChart: TFDQuery;
    qryContactNum: TFDQuery;
    qryContactNumContactNumID: TFDAutoIncField;
    qryContactNumContactNumTypeID: TIntegerField;
    qryContactNumlu: TStringField;
    qryContactNumMemberID: TIntegerField;
    qryContactNumNumber: TWideStringField;
    qryDataCheck: TFDQuery;
    qryDataCheckMemberID: TIntegerField;
    qryDataCheckMSG: TStringField;
    qryDataCheckPart: TFDQuery;
    qryEntrantDataCount: TFDQuery;
    qryFindMember: TFDQuery;
    qryFindMemberAge: TIntegerField;
    qryFindMembercGender: TWideStringField;
    qryFindMemberdtDOB: TWideStringField;
    qryFindMemberFirstName: TWideStringField;
    qryFindMemberFName: TWideStringField;
    qryFindMemberGenderID: TIntegerField;
    qryFindMemberIsActive: TBooleanField;
    qryFindMemberIsSwimmer: TBooleanField;
    qryFindMemberLastName: TWideStringField;
    qryFindMemberMemberID: TFDAutoIncField;
    qryFindMemberMembershipNum: TIntegerField;
    qryMember: TFDQuery;
    qryMemberArchivedOn: TSQLTimeStampField;
    qryMemberCreatedOn: TSQLTimeStampField;
    qryMemberDOB: TSQLTimeStampField;
    qryMemberEmail: TWideStringField;
    qryMemberEvents: TFDQuery;
    qryMemberEventsEventDate: TStringField;
    qryMemberEventsEventID: TFDAutoIncField;
    qryMemberEventsEventStr: TWideStringField;
    qryMemberEventsFName: TWideStringField;
    qryMemberEventsMemberID: TIntegerField;
    qryMemberEventsRaceTime: TTimeField;
    qryMemberFirstName: TWideStringField;
    qryMemberFName: TWideStringField;
    qryMemberGenderID: TIntegerField;
    qryMemberIsActive: TBooleanField;
    qryMemberIsArchived: TBooleanField;
    qryMemberIsSwimmer: TBooleanField;
    qryMemberLastName: TWideStringField;
    qryMemberluGender: TStringField;
    qryMemberMemberID: TFDAutoIncField;
    qryMemberMembershipNum: TIntegerField;
    qryMemberMembershipStr: TWideStringField;
    qryMemberPB: TFDQuery;
    qryMemberPBDistanceID: TFDAutoIncField;
    qryMemberPBEventStr: TWideStringField;
    qryMemberPBMemberID: TFDAutoIncField;
    qryMemberPBPB: TTimeField;
    qryMemberPBStrokeID: TFDAutoIncField;
    qryMemberRoleLnk: TFDQuery;
    qryMemberRoleLnkCreatedOn: TSQLTimeStampField;
    qryMemberRoleLnkElectedOn: TSQLTimeStampField;
    qryMemberRoleLnkIsActive: TBooleanField;
    qryMemberRoleLnkIsArchived: TBooleanField;
    qryMemberRoleLnkluMemberRoleStr: TStringField;
    qryMemberRoleLnkMemberID: TIntegerField;
    qryMemberRoleLnkMemberRoleID: TIntegerField;
    qryMemberRoleLnkRetiredOn: TSQLTimeStampField;
    qryMemberTAGS: TWideMemoField;
    qrySwimClub: TFDQuery;
    tblContactNumType: TFDTable;
    tblContactNumTypeCaption: TWideStringField;
    tblContactNumTypeContactNumTypeID: TFDAutoIncField;
    tblDistance: TFDTable;
    tblGender: TFDTable;
    tblMemberRole: TFDTable;
    tblStroke: TFDTable;
    tblSwimClub: TFDTable;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure qryMemberAfterInsert(DataSet: TDataSet);
    procedure qryMemberAfterPost(DataSet: TDataSet);
    procedure qryMemberAfterScroll(DataSet: TDataSet);
    procedure qryMemberBeforeDelete(DataSet: TDataSet);
    procedure qryMemberBeforeScroll(DataSet: TDataSet);
    procedure qryMemberDOBGetText(Sender: TField; var Text: string; DisplayText:
        Boolean);
    procedure qryMemberDOBSetText(Sender: TField; const Text: string);
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
    { Private declarations }
    fIsActive: Boolean;
    fRecordCount: Integer;
    prefChartMaxRecords: Integer;
    procedure UpdateMembersPersonalBest;
  protected
    procedure WndProc(var wndMsg: TMessage); virtual;
  public
    procedure ActivateMMD;
    procedure DeActivateMMD;
    procedure DataCheckPart(PartNumber: integer);
    function GetMemberID(): integer;
    function LocateChart(ChartX: Integer): Boolean;
    function LocateMember(MemberID: Integer): Boolean;
    function LocateSwimClub(SwimClubID: Integer): Boolean;
    procedure UpdateChart(aMemberID, aDistanceID, aStrokeID: integer; DoCurrSeason: boolean = true);
    procedure UpdateDOB(DOB: TDateTime);
    procedure UpdateElectedOn(aDate: TDate);
    procedure UpdateMember(hideArchived, hideInactive, hideNonSwimmer: Boolean);
    procedure UpdateRetiredOn(aDate: TDate);
    property Handle: HWND read fHandle;
    property IsActive: boolean read FIsActive write FIsActive;
    property RecordCount: Integer read fRecordCount;
  end;

const
  CHARTMAXRECORDS = 26; // max number of events show in TDBChart

var
  ManageMemberData: TManageMemberData;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

uses
  System.IOUtils, IniFiles, SCMUtils,
  vcl.Dialogs, System.UITypes, vcl.Forms, System.DateUtils;


procedure TManageMemberData.ActivateMMD;
begin
  fIsActive := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    qryMember.Connection := SCM2.scmConnection;
    qryContactNum.Connection := SCM2.scmConnection;
    qryMemberRoleLnk.Connection := SCM2.scmConnection;
    qryMemberPB.Connection := SCM2.scmConnection;
    qryMemberEvents.Connection := SCM2.scmConnection;
    qryChart.Connection := SCM2.scmConnection;
    qryDataCheck.Connection := SCM2.scmConnection;

    // prepare lookup tables.
    tblStroke.Connection := SCM2.scmConnection;
    tblDistance.Connection := SCM2.scmConnection;
    tblGender.Connection := SCM2.scmConnection;
    tblContactNumType.Connection := SCM2.scmConnection;
    tblMemberRole.Connection := SCM2.scmConnection;
    tblSwimClub.Connection := SCM2.scmConnection;

    try
      // Lookup tables...
      tblStroke.Open;
      tblDistance.Open;
      tblGender.Open;
      tblContactNumType.Open;
      tblMemberRole.Open;

      qryMember.Open;
      qryContactNum.Open;
      qryMemberRoleLnk.Open;
      qryMemberPB.Open;
      qryChart.Open;
      qryDataCheck.Open;
      qryMemberEvents.Open;
      fIsActive := True;
    except
      on E: EFDDBEngineException do
        SCM2.FDGUIxErrorDialog.Execute(E);
    end;
  end;
end;

procedure TManageMemberData.DataCheckPart(PartNumber: Integer);
var
  SQL: string;
begin
  if qryDataCheckPart.Active then
    qryDataCheckPart.Close;
  dsDataCheckPart.Enabled := false;

  case PartNumber of
    1: // FirstName
      begin
        SQL := 'SELECT[MemberID], ''No first-name.'' as MSG' + sLineBreak +
          'FROM [SwimClubMeet2].[dbo].[Member]' + sLineBreak +
          'WHERE firstname IS NULL AND' + sLineBreak +
          'ORDER BY MemberID DESC;';
      end;
    2:
      begin
        SQL := SQL +
          'SELECT[MemberID], ''No last-name.'' as MSG' + sLineBreak +
          'FROM [SwimClubMeet2].[dbo].[Member]' + sLineBreak +
          'WHERE lastname IS NULL AND' + sLineBreak +
          'ORDER BY MemberID DESC;';
      end;
     3:
     begin
        SQL := SQL +
          'SELECT[MemberID], ''Gender not given.'' as MSG' + sLineBreak +
          'FROM [SwimClubMeet2].[dbo].[Member]' + sLineBreak +
          'WHERE genderID IS NULL AND' + sLineBreak +
          'ORDER BY MemberID DESC;';
     end;
     4:
     begin
        SQL := SQL +
          'SELECT[MemberID], ''No date of birth.'' as MSG' + sLineBreak +
          'FROM [SwimClubMeet2].[dbo].[Member]' + sLineBreak +
          'WHERE DOB IS NULL AND' + sLineBreak +
          'ORDER BY MemberID DESC;';
     end;
     5:
     begin
       SQL := SQL +
          'SELECT[MemberID], ''Swimming Club not assigned.'' as MSG' + sLineBreak +
          'FROM [SwimClubMeet2].[dbo].[Member]' + sLineBreak +
          'WHERE SwimClubID IS NULL AND' + sLineBreak +
          'ORDER BY MemberID DESC;';
     end;
     6:
     begin
       SQL := SQL +
          'SELECT[MemberID], ''IsArchived, IsActive, IsSwimmer?'' as MSG' + sLineBreak +
          'FROM [SwimClubMeet2].[dbo].[Member]' + sLineBreak +
          'WHERE IsArchived IS NULL OR IsActive IS NULL OR IsSwimmer IS NULL AND' + sLineBreak +
          'ORDER BY MemberID DESC;';
     end;
     7:
     begin
       SQL := SQL +
          'SELECT[MemberID], ''No Membership number.'' as MSG' + sLineBreak +
          'FROM [SwimClubMeet2].[dbo].[Member]' + sLineBreak +
          'WHERE MemberShipNum IS NULL AND' + sLineBreak +
          'ORDER BY MemberID DESC;';
     end;
  end;

  qryDataCheckPart.SQL.Text := SQL;
  qryDataCheckPart.Prepare;
  qryDataCheckPart.Open;
  if qryDataCheckPart.Active then
    dsDataCheckPart.Enabled := true;
end;

procedure TManageMemberData.DataModuleCreate(Sender: TObject);
begin
  FIsActive := false;
  fHandle := AllocateHWnd(WndProc);
  if Assigned(Settings) then
    prefChartMaxRecords := Settings.MemberChartDataPoints
  else
    prefChartMaxRecords := CHARTMAXRECORDS;
end;

procedure TManageMemberData.DataModuleDestroy(Sender: TObject);
begin
  DeallocateHWND(fHandle);
end;

procedure TManageMemberData.DeActivateMMD;
begin
  try
    tblStroke.Close;
    tblDistance.Close;
    tblGender.Close;
    tblContactNumType.Close;
    tblMemberRole.Close;
    qryContactNum.Close;
    qryMemberRoleLnk.Close;
    qryMemberPB.Close;
    qryMemberEvents.Close;
    qryChart.Close;
    qryDataCheck.Close;
    qrymember.Close;
  finally
    fIsActive := false;
  end;
end;

function TManageMemberData.GetMemberID: integer;
begin
  result := 0;
  if dsMember.DataSet.Active then
    if not dsMember.DataSet.IsEmpty then
        result := dsMember.DataSet.FieldByName('MemberID').AsInteger;
end;

function TManageMemberData.LocateChart(ChartX: Integer): Boolean;
var
  SearchOptions: TLocateOptions;
begin
  result := false;
  SearchOptions := [loPartialKey];
  try
    begin
      result := qryChart.Locate('ChartX', ChartX, SearchOptions);
    end
  except
    on E: Exception do
      // lblErrMsg.Caption := 'SCM2 DB access error.';
  end;
end;

function TManageMemberData.LocateMember(MemberID: Integer): Boolean;
var
  SearchOptions: TLocateOptions;
begin
  result := false;
  SearchOptions := [loPartialKey];
  try
    begin
      result := qryMember.Locate('MemberID', MemberID, SearchOptions);
    end
  except
    on E: Exception do
      // lblErrMsg.Caption := 'SCM2 DB access error.';
  end;
end;

function TManageMemberData.LocateSwimClub(SwimClubID: Integer): Boolean;
var
  SearchOptions: TLocateOptions;
begin
  result := false;
  SearchOptions := [loPartialKey];
  try
    begin
      result := qrySwimClub.Locate('SwimClubID', SwimClubID, SearchOptions);
    end
  except
    on E: Exception do
      // lblErrMsg.Caption := 'SCM2 DB access error.';
  end;
end;

procedure TManageMemberData.qryMemberAfterInsert(DataSet: TDataSet);
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
  fld := DataSet.FieldByName('IsSwimmer');
  if (fld.IsNull) then
  begin
    fld.AsBoolean := True;
  end;

end;

procedure TManageMemberData.qryMemberAfterPost(DataSet: TDataSet);
begin
{TODO -oBSA -cV2 : CHECK}

  // As there is a calculation field (FNAME) in this query - the call to
  // refresh ensures that the main forms header banner will display the new
  // member's name.
  // ie. frmManageMember.DBTextFullName uses field qrMember.FNAME.
  qryMember.Refresh;
  if Owner is TForm then
//     Updates the display of the member's age.
    PostMessage(TForm(Owner).Handle, SCM_MEMBER_AFTERPOST, 0, 0);
end;

procedure TManageMemberData.qryMemberAfterScroll(DataSet: TDataSet);
begin
{TODO -oBSA -cV2 : CHECK}

  // Display Members Personal Best
  UpdateMembersPersonalBest();
  qryMember.Refresh;
  // Updates the display of the member's age.
  if Owner is TForm then
    PostMessage(TForm(Owner).Handle, SCM_MEMBER_SCROLL, 0, 0);

  // Update chart query?

end;

procedure TManageMemberData.qryMemberBeforeDelete(DataSet: TDataSet);
var
  SQL: string;
  MemberID, result: Integer;
  tmpQry: TFDQuery;
begin
  // Best to finalize any editing - prior to calling execute statements.
  // DataSet.CheckBrowseMode;



  MemberID := DataSet.FieldByName('MemberID').AsInteger;
  if MemberID <> 0 then
  begin
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

procedure TManageMemberData.qryMemberBeforeScroll(DataSet: TDataSet);
begin
  if (DataSet.State = dsEdit) or (DataSet.State = dsInsert) then
    DataSet.CheckBrowseMode; // auto-commit changes ...
end;

procedure TManageMemberData.qryMemberDOBGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
var
  LFormatSettings: TFormatSettings;
begin
  LFormatSettings := TFormatSettings.Create; // Use the system locale
  if (Sender.IsNull) or (DateOf(Sender.AsDateTime) = 0) then Text := ''
  else Text := FormatDateTime('ddddd', Sender.AsDateTime, LFormatSettings);
end;

procedure TManageMemberData.qryMemberDOBSetText(Sender: TField;
  const Text: string);
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

procedure TManageMemberData.qryMemberMETADATAGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := Sender.AsString;
end;

procedure TManageMemberData.qryMemberMETADATASetText(Sender: TField;
  const Text: string);
begin
  Sender.AsString := Text;
end;

procedure TManageMemberData.qryMemberRoleLnkBeforePost(DataSet: TDataSet);
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
    v := FConnection.ExecSQLScalar(SQL);
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

procedure TManageMemberData.qryMemberRoleLnkElectedOnGetText(Sender: TField;
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

procedure TManageMemberData.qryMemberRoleLnkElectedOnSetText(Sender: TField;
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

procedure TManageMemberData.qryMemberRoleLnkNewRecord(DataSet: TDataSet);
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

procedure TManageMemberData.UpdateChart(aMemberID, aDistanceID, aStrokeID: integer; DoCurrSeason: boolean = true);
begin
  if not Assigned(SCM2.scmConnection) then
    exit;
  if not qryChart.Active then
    exit;
  qryChart.DisableControls;
  qryChart.Close;
  if (aMemberID = 0) and (qryMember.Active) then
    aMemberID := qryMember.FieldByName('MemberID').AsInteger;
  if aMemberID <> 0 then
  begin
    qryChart.ParamByName('MEMBERID').AsInteger := aMemberID;
    qryChart.ParamByName('DISTANCEID').AsInteger := aDistanceID;
    qryChart.ParamByName('STROKEID').AsInteger := aStrokeID;
    qryChart.ParamByName('DOCURRSEASON').AsBoolean:= DoCurrSeason;
    qryChart.ParamByName('MAXRECORDS').AsInteger:= prefChartMaxRecords;
    qryChart.Prepare;
    qryChart.Open;
    if qryChart.Active then
    begin
      // signal success?
    end
  end;
  qryChart.EnableControls;
end;

procedure TManageMemberData.UpdateDOB(DOB: TDateTime);

begin
  if Assigned(qryMember.Connection) and (qryMember.Active) then
  begin
    qryMember.DisableControls;
    qryMember.edit;
    qryMember.FieldByName('DOB').AsDateTime := DOB;
    qryMember.Post;
    qryMember.EnableControls;
  end;
end;

procedure TManageMemberData.UpdateElectedOn(aDate: TDate);
begin
  if Assigned(qryMember.Connection) and (qryMember.Active) then
  begin
    qryMember.DisableControls;
    qryMember.edit;
    qryMember.FieldByName('ElectedOn').AsDateTime := aDate;
    qryMember.Post;
    qryMember.EnableControls;
  end;
end;

procedure TManageMemberData.UpdateMember(hideArchived, hideInactive, hideNonSwimmer: Boolean);
begin
  if not Assigned(SCM2.scmConnection) then
    exit;
  if not qryMember.Active then
    exit;

  qryMember.DisableControls;
  qryMember.Close;
  qryMember.ParamByName('HIDE_ARCHIVED').AsBoolean := hideArchived;
  qryMember.ParamByName('HIDE_INACTIVE').AsBoolean := hideInactive;
  qryMember.ParamByName('HIDE_NONSWIMMERS').AsBoolean := hideNonSwimmer;
  qryMember.Prepare;
  qryMember.Open;
  if qryMember.Active then
  begin
    fRecordCount := qryMember.RecordCount;
    if not Assigned(qryContactNum.Connection) then
      qryContactNum.Connection := SCM2.scmConnection;
    if not qryContactNum.Active then
      qryContactNum.Open;
  end
  else
    fRecordCount := 0;
  qryMember.EnableControls;
end;

procedure TManageMemberData.UpdateMembersPersonalBest;
begin
  if not Assigned(SCM2.scmConnection) then
    exit;
  if not dsMember.DataSet.Active then
    exit;
  // to improve loading performance of the Member's Dialogue
  // the 'personal bests' for a member are loaded on demand.
  qryMemberPB.DisableControls;
  qryMemberPB.Close();
  qryMemberPB.ParamByName('MEMBERID').AsInteger :=
    dsMember.DataSet.FieldByName('MemberID').AsInteger;
  // ensures params changes are used
  qryMemberPB.Prepare();
  qryMemberPB.Open();
  qryMemberPB.EnableControls;
end;

procedure TManageMemberData.UpdateRetiredOn(aDate: TDate);
begin
  if Assigned(qryMember.Connection) and (qryMember.Active) then
  begin
    qryMember.DisableControls;
    qryMember.edit;
    qryMember.FieldByName('RetiredOn').AsDateTime := aDate;
    qryMember.Post;
    qryMember.EnableControls;
  end;
end;

procedure TManageMemberData.WndProc(var wndMsg: TMessage);
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
    currDt := dsMember.DataSet.FieldByName(fldName).AsDateTime;
    if dt <> currDt then
    BEGIN
      dsMember.DataSet.DisableControls;
      if (dsMember.DataSet.State <> dsEdit) or
        (dsMember.DataSet.State <> dsInsert) then
      begin
        dsMember.DataSet.CheckBrowseMode;
        dsMember.DataSet.edit;
      end;
      if (dt = 0) then
        dsMember.DataSet.FieldByName(fldName).Clear
      else
        dsMember.DataSet.FieldByName(fldName).AsDateTime := dt;
      dsMember.DataSet.Post;
      dsMember.DataSet.EnableControls;
    END;

  END;

end;

end.
