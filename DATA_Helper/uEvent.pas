unit uEvent;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  System.Variants, System.VarUtils,
  System.StrUtils,
  VCL.Dialogs,

  Data.DB,

  FireDAC.Comp.Client,

  dmCORE, dmSCM2, uDefines, Vcl.ActnList;

function AllHeatsAreClosed: Boolean;
function Assert(): boolean;
function CalcEvent_EntrantCount: integer;
function CalcEvent_NomineeCount: integer;
function GetEvent_EntrantCount: integer;
function GetEvent_NomineeCount: integer;
function GetHeatCount: integer;
function DeleteEvent(DoExclude: Boolean = true): boolean;
procedure DeleteHeats(DoExclude: boolean = true);
function GetEventType: uDefines.scmEventType;
function ToggleEventTypeID: integer;
function SetEventTypeID(aEventTypeID: integer): integer;

function GetEventID: integer; // Assert - make SAFE.
function HasClosedHeats: Boolean;
function HasClosedOrRacedHeats: Boolean;
function HasNominee(MemberID: integer): Boolean;
function HasNominees: Boolean;
function HasRacedHeats: Boolean;
function LastEventNum: integer;
function Locate(aDistanceID, aStrokeID: integer): Boolean; overload;
function Locate(aEventID: integer): Boolean; overload;
function PK(): integer; // NO CHECKS. RTNS: Primary key.
function RenumberHeats(DoLocate: Boolean = true): integer;

procedure SetEventStatusID(aEventStatusID: integer);
procedure SetEvent_EntrantCount; // performs calculation
procedure SetEvent_NomineeCount; // performs calculation
procedure FNameEllipse(); // todo: move out of uEvent to frame.
procedure NewEvent();

procedure MoveUpDown(MoveDirection: scmMoveDirection);



implementation

uses
	uSession, scmUtils; // , uHeat, uLane;



procedure DetailTBLs_DisableCNTRLs;
begin
  CORE.qryTeamLink.DisableControls;
  CORE.qryTeam.DisableControls;
  CORE.qrySplitTime.DisableControls;
  CORE.qryWatchTime.DisableControls;
  CORE.qryLane.DisableControls;
  CORE.qryHeat.DisableControls;
end;

procedure DetailTBLs_ApplyMaster;
begin
  // FireDAC throws exception error if Master is empty?
  CORE.qryEvent.ApplyMaster;
  if CORE.qryEvent.RecordCount <> 0 then
  begin
    CORE.qryHeat.ApplyMaster;
    if CORE.qryHeat.RecordCount <> 0 then
    begin
      CORE.qryLane.ApplyMaster;
      if CORE.qryLane.RecordCount <> 0 then
      begin
        CORE.qryWatchTime.ApplyMaster;
        CORE.qrySplitTime.ApplyMaster;
//          CORE.qryTeam.ApplyMaster;
      end;
    end;
  end;
end;

procedure DetailTBLs_EnableCNTRLs;
begin
  CORE.qryHeat.EnableControls;
  CORE.qryLane.EnableControls;
  CORE.qryWatchTime.EnableControls;
  CORE.qrySplitTime.EnableControls;
  CORE.qryTeam.EnableControls;
  CORE.qryTeamLink.DisableControls;
end;
// ----------------------------------------------------------------------

function Assert(): boolean;
begin
  result := false;
  if Assigned(CORE) then
    if CORE.qryEvent.Active then
      if not CORE.qryEvent.IsEmpty then
        result := true;
end;

function RenumberHeats(DoLocate: Boolean = true): integer;
var
  aHeatID: integer;
begin
  result := 0;

  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  if CORE.dsHeat.DataSet.IsEmpty then exit;
  if DoLocate then
    aHeatID := CORE.qryHeat.FieldByName('HeatID').AsInteger; // uHeat.PK;

  DetailTBLs_DisableCNTRLs;
  try
    (*
    SCM2.procRenumberHeats.Params[1].Value := uEvent.PK;
    SCM2.procRenumberHeats.Prepare;
    results := SCM2.procRenumberHeats.ExecProc;
    *)
  finally
    if DoLocate then
    begin
      // will also handle ApplyMaster for the heat's dependant tables.
      ;// uHeat.Locate(aHeatID);
    end;
    DetailTBLs_EnableCNTRLs;
  end;
end;

procedure DeleteHeats(DoExclude: boolean = true);
var
  HeatWasDeleted, DoRenumber: boolean;
begin
  HeatWasDeleted := false;
  DoRenumber := false;
  // Not permitted to delete anything if session is locked.
  if uSession.IsLocked() then exit;
  if CORE.qryHeat.IsEmpty then exit; // Nothing to delete

  DetailTBLs_DisableCNTRLs;
  try
    CORE.qryHeat.ApplyMaster; // ASSERT MASTER-DETAILED.
    CORE.qryHeat.First;
    while not CORE.qryHeat.eof do
    begin
      // Deletes watch-times, split-times and lane data.
      // Disables detailed tables controls and will renumber lanes if needed.
      // Dependant on DoExclude - will retain raced or closed heats.
      {---------------------------------------------------------------------}
      // HeatWasDeleted := uHeat.DeleteHeat(DoExclude);

      if HeatWasDeleted then
      begin
        DoRenumber := true;
        continue;   // next used required here.
      end
      else
        CORE.qryHeat.Next;
    end;
  finally

    if DoRenumber then // if required records have been deleted, renumber.
      RenumberHeats;  // Performs DB procedure.
    DetailTBLs_ApplyMaster; // sync detailed tables to this (master) Event.
    DetailTBLs_EnableCNTRLs;
  end;
end;

function DeleteEvent(DoExclude: Boolean = true): boolean;
var
  SQL: string;
begin
	result := false;
  if uSession.IsLocked then exit;  // Not permitted to delete.

  CORE.qryEvent.DisableControls;
  CORE.qryEvent.CheckBrowseMode;
  try
    // Delete heats. handles Disable/Enable and will renumber if needed.
    uEvent.DeleteHeats(true); // exclude raced or closed heats

    // Can't delete remaining dependants if heats are retained.
    if (CORE.qryHeat.IsEmpty) then
    begin
      // Clear Scheduled Events.
      SQL := 'UPDATE SwimClubMeet2.dbo.ScheduleEvent SET EventID = NULL WHERE EventID = :ID';
      SCM2.scmConnection.ExecSQL(SQL, [uEvent.PK]);

      // D E L E T E   N O M I N A T I O N S .
      CORE.qryNominee.DisableControls;
      try
        SQL := 'Delete FROM SwimClubMeet2.dbo.Nominee WHERE Nominee.EventID = :ID';
        SCM2.scmConnection.ExecSQL(SQL, [uEvent.PK]);
      finally
        CORE.qryNominee.EnableControls;
      end;

      // F I N A L L Y   DELETE THE EVENT..
      CORE.qryEvent.Delete;
      result := true;
    end;

  finally
    CORE.qryEvent.EnableControls;
  end;
end;

function AllHeatsAreClosed: Boolean;
var
  SQL: string;
  v: variant;
begin
  result := false;
  if uEvent.GetHeatCount() = 0 then exit; // NO HEATS.
  SQL := 'SELECT COUNT(HeatStatusID) FROM SwimClubMeet2.dbo.Heat ' +
  'WHERE (EventID = :GetEventID ) AND (HeatStatusID < 3)';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uEvent.PK]);
  if not VarIsNull(v) and not VarIsEmpty(v) then
    if v = 0 then result := true;
end;

procedure FNameEllipse;
//var
//  ds: TFDQuery;
begin
  // BSA wip - may all chage with TMS grid
  (*
  ds := (SCM2.dsFNameEllipse.DataSet as TFDQuery);
  // re-assign parameters ...
  // TODO: reassigning params without close or prepare?
  ds.ParamByName('SESSIONID').AsInteger :=
  CORE.qrySession.FieldByName('SessionID').AsInteger;
  ds.ParamByName('EVENTID').AsInteger := CORE.qryEvent.FieldByName('EventID')
  .AsInteger;
  ds.ParamByName('DISTANCEID').AsInteger := CORE.qryEvent.FieldByName
  ('DistanceID').AsInteger;
  ds.ParamByName('STROKEID').AsInteger := CORE.qryEvent.FieldByName
  ('StrokeID').AsInteger;
  if (ds.Active) then ds.Refresh();
  *)
end;

function CalcEvent_EntrantCount: integer;
var
  v: variant;
  SQL: string;
begin
  result := 0;
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  SQL := 'SELECT SwimClubMeet2.dbo.GetEvent_EntrantCount(:ID);';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uEvent.PK]);
  if not VarIsClear(v) and (v > 0) then result := v;
end;

procedure SetEvent_EntrantCount;
var
  fld: TField;
  DoReadOnly: boolean;
  i: integer;
begin
  fld := nil;
  DoReadOnly := false;
  if CORE.qryEvent.IsEmpty then exit;
  CORE.qryEvent.CheckBrowseMode;
  CORE.qryEvent.DisableControls;
  try
    i := uEvent.CalcEvent_EntrantCount;
    fld := CORE.qryEvent.FindField('GetEvent_EntrantCount');
    if Assigned(fld) and fld.ReadOnly then
    begin
      fld.ReadOnly := false;
      DoReadOnly := true;
    end;
    if CORE.qryEvent.FieldByName('GetEvent_EntrantCount').AsInteger <> i then
    begin
      try
        CORE.qryEvent.Edit;
        CORE.qryEvent.FieldByName('GetEvent_EntrantCount').AsInteger := i;
        CORE.qryEvent.Post;
      except on E: Exception do
          CORE.qryEvent.Cancel;
      end;
    end;
  finally
    if Assigned(fld) and DoReadOnly then fld.ReadOnly := true;
    CORE.qryEvent.EnableControls;
  end;
end;

function GetEvent_EntrantCount: integer;
begin
  result := CORE.qryEvent.FieldByName('GetEvent_EntrantCount').AsInteger;
end;

function CalcEvent_NomineeCount: integer;
var
  v: variant;
  SQL: string;
begin
  result := 0;
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  SQL := 'SELECT SwimClubMeet2.dbo.GetEvent_NomineeCount(:GetEventID);';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uEvent.PK]);
  if not VarIsClear(v) then result := v;
end;

procedure SetEvent_NomineeCount;
var
  fld: TField;
  DoReadOnly: boolean;
  i: integer;
begin
  fld := nil;
  DoReadOnly := false;
  if CORE.qryEvent.IsEmpty then exit;
  CORE.qryEvent.CheckBrowseMode;
  CORE.qryEvent.DisableControls;
  try
    i := uEvent.CalcEvent_NomineeCount;
    fld := CORE.qryEvent.FindField('GetEvent_NomineeCount');
    if Assigned(fld) and fld.ReadOnly then
    begin
      fld.ReadOnly := false;
      DoReadOnly := true;
    end;

    try
      CORE.qryEvent.Edit;
      CORE.qryEvent.FieldByName('GetEvent_NomineeCount').AsInteger := i;
      CORE.qryEvent.Post;
    except on E: Exception do
        CORE.qryEvent.Cancel;
    end;
  finally
    if Assigned(fld) and DoReadOnly then fld.ReadOnly := true;
    CORE.qryEvent.EnableControls;
  end;
end;

function GetEvent_NomineeCount: integer;
begin
  result := CORE.qryEvent.FieldByName('GetEvent_NomineeCount').AsInteger;
end;

function GetEventID: integer;
begin
  result := 0;
  if uEvent.Assert then  // Assert - make safe.
    result := CORE.qryLane.FieldByName('EventID').AsInteger;
end;

function GetEventType: uDefines.scmEventType;
var
  v: variant;
begin
  result := uDefines.scmEventType.etUnknown; // Default.
  if CORE.qryEvent.IsEmpty then exit; // Table is empty.
  v := CORE.qryEvent.FieldByName('EventTypeID').AsVariant;
  if VarIsNull(v) or VarIsEmpty(v) or (v = 0) then exit;
  case v of
    1: result := uDefines.scmEventType.etINDV;
    2: result := uDefines.scmEventType.etTEAM;
  end;
end;

function GetHeatCount: integer;
var
  SQL: string;
  v: variant;
begin
  result := 0;
  SQL := '''
    SELECT Count(Heat.HeatID) FROM SwimClubMeet2.dbo.[Event]
    INNER JOIN Heat ON [Event].EventID = Heat.EventID
    WHERE Event.EventID = :ID;
    ''';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uEvent.PK]);
  if not VarIsNull(v) and not VarIsEmpty(v) and (v > 0) then result := v;
end;

function HasClosedHeats: Boolean;
var
  SQL: string;
  v: variant;
begin
  result := false;
  // count the closed heats.
  SQL := '''
    SELECT Count([Heat].[HeatID]) FROM [SwimClubMeet2].[dbo].[Event]
    INNER JOIN Heat ON Event.EventID = Heat.EventID
    WHERE Event.EventID = :ID AND (Heat.HeatStatusID = 3);
    ''';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uEvent.PK]);
  if not VarIsNull(v) and not VarIsEmpty(v) and (v > 0) then result := true;
end;

function HasClosedOrRacedHeats: Boolean;
var
  SQL: string;
  v: variant;
begin
  result := false;
  SQL := '''
    SELECT Count([Heat].[HeatID]) FROM [SwimClubMeet2].[dbo].[Event]
    INNER JOIN Heat ON Event.EventID = Heat.EventID
    WHERE Event.EventID = :ID AND (Heat.HeatStatusID > 1);
    ''';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uEvent.PK]);
  if not VarIsNull(v) and not VarIsEmpty(v) and (v > 0) then result := true;
end;

function HasNominee(MemberID: integer): Boolean;
var
  SQL: string;
  v: variant;
begin
  result := false;
  SQL := '''
		SELECT COUNT(Nominee.NomineeID) FROM SwimClubMeet2.dbo.Nominee
		WHERE [MemberID] = :ID1 AND [EventID] = :ID2;
		''';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [MemberID, uEvent.PK]);
  if not VarIsClear(v) then
    if (v > 0) then result := true;
end;

function HasNominees: Boolean;
var
  SQL: string;
  v: variant;
begin
  result := false;
  SQL := '''
    SELECT COUNT(NomineeID) FROM SwimClubMeet2.dbo.Nominee
    WHERE Nominee.EventID = :ID AND MemberID IS NOT NULL;
    ''';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uEvent.PK]);
  if not VarIsNull(v) and not VarIsEmpty(v) and (v > 0) then result := true;
end;

function HasRacedHeats: Boolean;
var
  SQL: string;
  v: variant;
begin
  result := false;
  SQL := '''
    SELECT Count([Heat].[HeatID]) FROM [SwimClubMeet2].[dbo].[Event]
    INNER JOIN Heat ON Event.EventID = Heat.EventID
    WHERE Event.EventID = :ID AND (Heat.HeatStatusID = 2);
    ''';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uEvent.PK]);
  if not VarIsNull(v) and not VarIsEmpty(v) and (v > 0) then result := true;
end;

function LastEventNum: integer;
var
  SQL: string;
  v: variant;
begin
  result := 0;
  if not Assigned(SCM2) and SCM2.scmConnection.Connected then exit;
  SQL := '''
    SELECT MAX(EventNum) FROM SwimClubMeet2.dbo.Event
    WHERE Event.SessionID = :ID;
    ''';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uSession.PK()]);
  if not VarIsNull(v) and not VarIsEmpty(v) and (v > 0) then result := v;
end;

function Locate(aEventID: integer): Boolean;
var
  SearchOptions: TLocateOptions;
begin
  result := false;
  if CORE.qryEvent.IsEmpty then exit;
  if (aEventID = 0) then exit;
  SearchOptions := [];
  result := CORE.qryEvent.Locate('EventID', aEventID,  SearchOptions);
end;

procedure NewEvent();
var
  fld: TField;
  aEventNum: integer;
  DoReadOnly: boolean;
begin
  fld := nil;
  DoReadOnly := false;
  if CORE.qrySession.IsEmpty then exit;
  CORE.qryEvent.CheckBrowseMode;
  CORE.qryEvent.DisableControls();
  try
    DetailTBLs_DisableCNTRLs;
    aEventNum := uEvent.LastEventNum();
    Inc(aEventNum);
    fld := CORE.qryEvent.FindField('EventStatusID');
    if Assigned(fld) and fld.ReadOnly then
    begin
      fld.ReadOnly := false;
      DoReadOnly := true;
    end;
    try
      CORE.qryEvent.Insert;
      CORE.qryEvent.FieldByName('SessionID').AsInteger := uSession.PK;
      CORE.qryEvent.FieldByName('EventNum').AsInteger := aEventNum;
      CORE.qryEvent.FieldByName('RoundID').AsInteger := 1; // Preliminary.
      CORE.qryEvent.FieldByName('EventStatusID').AsInteger := 1; // Open.
      CORE.qryEvent.Post;
    except on E: Exception do
        CORE.qryHeat.Cancel;
    end;
  finally
    if Assigned(fld) and DoReadOnly then fld.ReadOnly := true;
    CORE.qryEvent.EnableControls();
    DetailTBLs_ApplyMaster();
    DetailTBLs_EnableCNTRLs;
  end;
end;

function Locate(aDistanceID, aStrokeID: integer): Boolean;
var
  SearchOptions: TLocateOptions;
begin
  result := false;
  SearchOptions := [];
  if CORE.qryEvent.Active then
    result := CORE.qryEvent.Locate('DistanceID;StrokeID',
      VarArrayOf([aDistanceID, aStrokeID]), SearchOptions);
end;

function PK(): integer;
begin // NO CHECKS. quick and dirty - primary key result.
  result := CORE.qryEvent.FieldByName('EventID').AsInteger;
end;

function ToggleEventTypeID: integer;
var
  aEventTypeID: integer;
begin
  result := 0;
  if CORE.qryEvent.IsEmpty then exit;

  aEventTypeID := CORE.qryEvent.FieldByName('EventTypeID').AsInteger;
  Inc(aEventTypeID);
  if aEventTypeID > 2 then aEventTypeID := 1;
  result := SetEventTypeID(aEventTypeID);
end;

function SetEventTypeID(aEventTypeID: integer): integer;
var
fld: TField;
DoReadOnly: boolean;
begin
  fld := nil;
  result := 0;
  DoReadOnly := false;
  if uSession.IsLocked() then exit;
  if CORE.qryEvent.IsEmpty then exit;
  if not aEventTypeID in [1,2] then exit;
  if (aEventTypeID = CORE.qryEvent.FieldByName('EventTypeID').AsInteger) then exit;

  CORE.qryEvent.CheckBrowseMode;
  try
    fld := CORE.qryEvent.FindField('EventTypeID');
    if Assigned(fld) and fld.ReadOnly then
    begin
      fld.ReadOnly := false;
      DoReadOnly := true;
    end;
    CORE.qryEvent.DisableControls;
    try
      CORE.qryEvent.Edit;
      CORE.qryEvent.FieldByName('EventTypeID').AsInteger := aEventTypeID;
      CORE.qryEvent.Post;
      result := aEventTypeID;
    except on E: Exception do
        CORE.qryEvent.Cancel;
    end;
  finally
    if Assigned(fld) and DoReadOnly then fld.ReadOnly := true;
    CORE.qryEvent.EnableControls;

  end;
end;

procedure SetEventStatusID(aEventStatusID: integer);
var
fld: TField;
DoReadOnly: boolean;
begin
  fld := nil;
  DoReadOnly := false;
  if uSession.IsLocked() then exit;
  if CORE.qryEvent.IsEmpty then exit;
  if not aEventStatusID in [1,2] then exit;
  if (aEventStatusID = CORE.qryEvent.FieldByName('EventStatusID').AsInteger) then exit;
  CORE.qryEvent.CheckBrowseMode;
  CORE.qryEvent.DisableControls;
  try
    fld := CORE.qryEvent.FindField('EventStatusID');
    if Assigned(fld) and fld.ReadOnly then
    begin
      fld.ReadOnly := false;
      DoReadOnly := true;
    end;
    try
      CORE.qryEvent.Edit;
      CORE.qryEvent.FieldByName('EventStatusID').AsInteger := aEventStatusID;
      CORE.qryEvent.Post;
    except on E: Exception do
        CORE.qryEvent.Cancel;
    end;
  finally
    if Assigned(fld) and DoReadOnly then fld.ReadOnly := true;
    CORE.qryEvent.EnableControls;
  end;
end;

procedure MoveUpDown(MoveDirection: scmMoveDirection);
var
  aEventID, recA, recB: integer;
  fld: TField;
  recPos: TRecordPos;
  DoReadOnly: boolean;
begin
  // TODO -cMM: MoveUpDown default body inserted .
  DoReadOnly := false;
  fld := nil;
  if not ORD(MoveDirection) in [1,2] then exit;

  recPos := scmUtils.GetRecordPosition(CORE.qryEvent);
  if recPos = rpMiddle then
  begin
    CORE.qryEvent.CheckBrowseMode;
    CORE.qryEvent.DisableControls();

    try
      fld := CORE.qryEvent.FindField('EventNum');
      if Assigned(fld) and fld.ReadOnly then
      begin
        fld.ReadOnly := false;
        DoReadOnly := true;
      end;

      aEventID := uEvent.PK; // store  primary key  for later re-locate.
      recA := CORE.qryEvent.FieldByName('EventNum').AsInteger;

      case MoveDirection of
        scmMoveDirection.mdUp:  // move to previous record
          CORE.qryEvent.Prior();
        scmMoveDirection.mdDown:  // move to next record.
          CORE.qryEvent.Next();
      end;

      try
        recB := CORE.qryEvent.FieldByName('EventNum').AsInteger;
        CORE.qryEvent.Edit();
        CORE.qryEvent.FieldByName('EventNum').AsInteger := recA;
        CORE.qryEvent.Post();
        if uEvent.Locate(aEventID) then
        begin
          CORE.qryEvent.Edit();
          CORE.qryEvent.FieldByName('EventNum').AsInteger := recB;
          CORE.qryEvent.Post();
        end;

      except on E: Exception do
        begin
          CORE.qryEvent.Cancel;
          { if recA = 0 then  uEvent.RenumberLanes(true); }
          exit;
        end;
      end;
    finally
      if Assigned(fld) and DoReadOnly then fld.ReadOnly := true;
      CORE.qryEvent.EnableControls();
    end;
  end;
end;

end.

