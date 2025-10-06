unit uSession;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  System.Variants, System.VarUtils,
  System.StrUtils,
  vcl.Dialogs, Data.DB,
  dmCORE, dmSCM2, uDefines,
  FireDAC.Comp.Client, FireDAC.Stan.Param;

/// <summary>
///  Only call here if SCM2 is assigned and connected...
///  ... AND CORE is assigned and IsActive.
/// </summary>
///
function AllEventsAreClosed: Boolean;
function HasEvents: Boolean;  deprecated;
function IsEmptyOrLocked: Boolean;
function RenumberEvents(DoLocate: Boolean = true): integer;
function SessionDT: TDateTime;
procedure SetEntrantCount();
procedure SetNomineeCount();
//procedure SortSession();
procedure NewSession();
//procedure EditSession();
//procedure ReSyncSession();


// LISTED BELOW ARE ROUTINES WIP.
function WeeksSinceSeasonStart(const ANow: TDateTime): Integer; overload;
function WeeksSinceSeasonStart: Integer; overload;

function Locate(SessionID: integer): Boolean;
function CalcEventCount: integer;
function GetSessionID: integer; // Assert - SAFE.
function Delete_Session(DoExclude: Boolean = true): boolean;
function CalcNomineeCount(): integer;
function CalcEntrantCount: integer;
function EntrantCount: integer;
function NomineeCount: integer;

// LISTED BELOW ARE ROUTINES THAT ARE IN-USE AND DEBUGGED
function PK(): integer; // NO CHECKS. RTNS: Primary key.
function Assert: Boolean;
function IsLocked: Boolean;
function HasClosedOrRacedHeats: Boolean;
procedure SetIndexName(IsLocked: Boolean);
procedure SetSessionStatusID(const aSessionStatusID: Integer);
procedure DetailTBLs_DisableCNTRLs;
procedure DetailTBLs_ApplyMaster;
procedure DetailTBLs_EnableCNTRLs;


implementation

uses
  uSwimClub; //, uEvent, uHeat, uLane;


function AllEventsAreClosed: Boolean;
var
  SQL: string;
  v: variant;
begin
  result := false;
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  SQL := '''
    SELECT COUNT(EventID)
    FROM [SwimClubMeet2].[dbo].[Event]
    WHERE [Event].EventStatusID IN [0,1,2] AND [Event].SessionID = :ID;
    ''';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uSession.PK]);
  if VarIsClear(v) and (v = 0) then result := true;
end;

function Assert: Boolean;
begin
  result := false;
  if Assigned(CORE) then
    if CORE.qrySession.Active then
      if not CORE.qrySession.IsEmpty then
        result := true;
end;

function CalcNomineeCount(): integer;
var
  SQL: string;
  v: variant;
begin
  result := 0;
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  SQL := 'SELECT SwimClubMeet2.dbo.SessionNomineeCount(:ID1);';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uSession.PK]);
  if not VarIsClear(v) and (v > 0) then result := v;
end;

function CalcEntrantCount(): integer;
var
  SQL: string;
  v: variant;
begin
  result := 0;
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  SQL := 'SELECT SwimClubMeet2.dbo.SessionEntrantCount(:ID);';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uSession.PK]);
  if not VarIsClear(v) and (v > 0) then
    result := v;
end;

function CalcEventCount: integer;
var
  SQL: string;
  v: variant;
begin
  result := 0;
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  SQL := '''
		SELECT COUNT(EventID) FROM [SwimClubMeet2].[dbo].[Session]
		INNER JOIN [Event] ON [Session].SessionID = [Event].SessionID
		WHERE [Session].SessionID = :ID;
		''';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uSession.PK]);
  if not VarIsClear(v) and (v > 0) then result := v;
end;

procedure DetailTBLs_DisableCNTRLs;
begin
  CORE.qryTeamLink.DisableControls;
  CORE.qryTeam.DisableControls;
  CORE.qrySplitTime.DisableControls;
  CORE.qryWatchTime.DisableControls;
  CORE.qryLane.DisableControls;
  CORE.qryHeat.DisableControls;
  CORE.qryEvent.DisableControls;
end;

procedure DetailTBLs_ApplyMaster;
begin
  // FireDAC throws exception error if Master is empty?
  if CORE.qrySession.RecordCount <> 0 then
  begin
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
end;

procedure DetailTBLs_EnableCNTRLs;
begin
  CORE.qryEvent.EnableControls;
  CORE.qryHeat.EnableControls;
  CORE.qryLane.EnableControls;
  CORE.qryWatchTime.EnableControls;
  CORE.qrySplitTime.EnableControls;
  CORE.qryTeam.EnableControls;
  CORE.qryTeamLink.DisableControls;
end;

function Delete_Session(DoExclude: Boolean = true): boolean;
var
  SQL: string;
begin
  result := false;
  if not uSession.Assert then exit;
  if DoExclude then
    if uSession.IsLocked then exit; // Locked sessions are never deleted.

  DetailTBLs_DisableCNTRLs;
  CORE.qrySession.DisableControls;

  try
    CORE.qryEvent.ApplyMaster; // assert sync to master.
    if not CORE.qryEvent.IsEmpty then
    begin
      CORE.qryEvent.First;
      while not CORE.qryEvent.Eof do
      begin
        {
        uEvent.DeleteEvent(DoExclude); // Event & all it's dependants
        }
        CORE.qryEvent.next;
      end;
    end;

    // ASSERT that all events have been removed.
    // Can't delete session if events remain.
    if not CORE.qryEvent.IsEmpty then
      RenumberEvents(False)
    else
    begin
      // DELETE dbo.SchedualeSession
      SQL := '''
        DELETE FROM [SwimClubMeet2].[dbo].[ScheduleSession]
        WHERE [SessionID] = :ID;
        ''';
      SCM2.scmConnection.ExecSQL(SQL, [uSession.PK]);
      // F I N A L L Y  Delete THE SESSION.
      CORE.qrySession.Delete;
    end;

  finally
    // ASSERT MASTER-DETAIL STATE.
    // CORE.qrySession.ApplyMaster; // REDUNDANT...
    DetailTBLs_ApplyMaster;

    // Enable all controls.
    CORE.qrySession.EnableControls;
    DetailTBLs_EnableCNTRLs;
  end;
end;

function EntrantCount: integer;
begin
  result := CORE.qrySession.FieldByName('EntrantCount').AsInteger;
end;

function GetSessionID: integer;
begin
  result := CORE.qrySession.FieldByName('SessionID').AsInteger;
end;

function HasClosedOrRacedHeats: Boolean;
var
  SQL: string;
  v: variant;
begin
  result := false;
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  SQL := '''
    SELECT Count(HeatID) FROM  [SwimClubMeet2].[dbo].[Session]
    INNER JOIN [Event] ON [Session].SessionID = [Event].SessionID
    INNER JOIN [Heat] ON [Event].EventID = [Heat].EventID
    WHERE [Heat].HeatStatusID > 1 AND [Session].SessionID = :ID;
    ''';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uSession.PK]);
  if (v > 0) then result := true;  // Count(..) never returns null or empty.
end;

function HasEvents: Boolean; deprecated;
begin
  result := not CORE.qryEvent.IsEmpty;
end;

function IsEmptyOrLocked: Boolean;
var
  i: integer;
begin
  result := true;
  i := CORE.qrySession.FieldByName('SessionStatusID').AsInteger;
  if (i <> 2) then result := false;
end;

function IsLocked: Boolean;
begin
  result := true;
  if (CORE.qrySession.FieldByName('SessionStatusID').AsInteger <> 2)
    then result := false;
end;

function Locate(SessionID: integer): Boolean;
var
  SearchOptions: TLocateOptions;
begin
  SearchOptions := [];
  result := CORE.qrySession.Locate('SessionID', SessionID,
    SearchOptions);
end;

function RenumberEvents(DoLocate: Boolean = true): integer;
begin
  result := 0;
  try
//    if DoLocate then
//      aEvent := uEvent.PK;
    SCM2.procRenumberEvents.Params[1].Value := uSession.PK;
    SCM2.procRenumberEvents.Prepare;
    SCM2.procRenumberEvents.ExecProc;
  finally
//    if DoLocate then
//      uEvent.Locate(aEvent);
  end;
end;

procedure SetEntrantCount;
begin
  var i := uSession.CalcEntrantCount;
  try
    CORE.qrySession.DisableControls;
    if CORE.qrySession.FieldByName('EntrantCount').AsInteger <> i then
    begin
      try
        CORE.qrySession.Edit;
        CORE.qrySession.FieldByName('EntrantCount').AsInteger := i;
        CORE.qrySession.Post;
      except on E: Exception do
          CORE.qrySession.Cancel;
      end;
    end;
  finally
    CORE.qrySession.EnableControls;
  end;
end;

procedure SetNomineeCount();
begin
  var i := uSession.CalcNomineeCount;
  try
    CORE.qrySession.DisableControls;
    try
      CORE.qrySession.Edit;
      CORE.qrySession.FieldByName('NomineeCount').AsInteger := i;
      CORE.qrySession.Post;
    except on E: Exception do
        CORE.qrySession.Cancel;
    end;
  finally
    CORE.qrySession.EnableControls;
  end;
end;

procedure SetSessionStatusID(const aSessionStatusID: Integer);
begin
  if aSessionStatusID in [1,2] then // Check out of bounds.
  begin
    CORE.qrySession.DisableControls;
    try
      CORE.qrySession.Edit;
      CORE.qrySession.FieldByName('SessionStatusID').AsInteger := aSessionStatusID;
      CORE.qrySession.Post;
    except on E: Exception do
        CORE.qrySession.Cancel;
    end;
    CORE.qrySession.EnableControls;
  end;
end;

procedure SetIndexName(IsLocked: Boolean);
/// <param name="IsLocked">
///  true: show both locked and unlocked sessions.
///  false: hides locked sessions.
/// </param>
begin
  DetailTBLs_DisableCNTRLs;
  CORE.qrySession.DisableControls;
  try
    try
      if IsLocked then
        CORE.qrySession.IndexName := 'indxHideLocked'
      else
        CORE.qrySession.IndexName := 'indxShowAll';

      if not CORE.qrySession.IndexesActive then
        CORE.qrySession.IndexesActive := true;
    except on E: Exception do
      begin
        E.Message := E.Message +sLineBreak+ 'FATAL - Session.IndexName ';
        raise;
      end;
    end;
    DetailTBLs_ApplyMaster;   // Re-Sync Master detail relationship.
  finally
    CORE.qrySession.EnableControls;
    DetailTBLs_EnableCNTRLs;
  end;
end;

function SessionDT: TDateTime;
begin
  result := CORE.qrySession.FieldByName('SessionDT').AsDateTime;
end;

procedure NewSession();
/// <remarks>
/// Sorting of session grid handled by active index.
/// </remarks>
begin
  try
    CORE.qrySplitTime.DisableControls;
    CORE.qryWatchTime.DisableControls;
    CORE.qryLane.DisableControls();
    CORE.qryHeat.DisableControls();
    CORE.qryEvent.DisableControls();
    CORE.qrySession.DisableControls();

   //  CORE.qrySession.IndexesActive := false; // Is this needed??? check.

    try
      CORE.qrySession.Insert;
      { // handled by OnNewRecord in dmCORE.
      CORE.qrySession.FieldByName('SwimClubID').AsInteger := uSwimClub.PK;
      CORE.qrySession.FieldByName('SessionDT').AsDateTime := Now();
      CORE.qrySession.FieldByName('CreatedOn').AsDateTime := Now();
      CORE.qrySession.FieldByName('SessionStatusID').AsInteger := 1; // Open.
      }
      CORE.qrySession.Post;
    except on E: Exception do
        CORE.qryHeat.Cancel;
    end;
  finally
    // SQLExec - ID of new record.
    //    CORE.qrySession.IndexesActive := true; // check.
    // Locate to new record.

    CORE.qrySession.EnableControls();
    CORE.qryEvent.ApplyMaster;
    CORE.qryEvent.EnableControls();
    CORE.qryHeat.ApplyMaster;
    CORE.qryHeat.EnableControls();
    CORE.qryLane.ApplyMaster;
    CORE.qryLane.EnableControls();
    CORE.qrySplitTime.ApplyMaster;
    CORE.qryWatchTime.ApplyMaster;
    CORE.qrySplitTime.EnableControls;
    CORE.qryWatchTime.EnableControls;
  end;
end;

function NomineeCount: integer;
begin
  result := CORE.qrySession.FieldByName('NomineeCount').AsInteger;
end;

function PK(): integer;
begin // NO CHECKS. quick and dirty - primary key result.
  result := CORE.qrySession.FieldByName('SessionID').AsInteger;
end;

function WeeksSinceSeasonStart(const ANow: TDateTime): Integer;
var
AThen: TDateTime;
begin
  result := 0;
  // get the number of weeks since the start of the swimming season.
  if not CORE.qrySwimClub.FieldByName('StartOfSwimSeason').IsNull then
  begin
    aThen := CORE.qrySwimClub.FieldByName('StartOfSwimSeason').AsDateTime;
    // Calculates the number of whole weeks between ANow and AThen, counting
    // incomplete weeks as a full week. ALT: WeeksBetween
    result := aNow.WeeksBetween(aThen); // ALT: WeekSpan(aNow, aThen);
  end;
end;

function WeeksSinceSeasonStart: Integer;
var
aNow: TDateTime;
begin
  result := 0;
  if not CORE.qrySwimClub.FieldByName('StartOfSwimSeason').IsNull then
  begin
    aNow := CORE.qrySession.FieldByName('SessionDT').AsDateTime;
    result := WeeksSinceSeasonStart(aNow);
  end;
end;

end.

