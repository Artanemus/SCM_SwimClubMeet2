unit uSwimClub;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  System.Variants, Data.DB,
  vcl.Dialogs,
  dmCORE, dmSCM2, uSession;

function Assert(): boolean;
function ClubName(): string;
function GetSwimClubID: integer; // Assert made here.
function IsShortCourse(): Boolean;
function Locate(SwimClubID: integer): boolean;
function PK(): integer; // RTNS: Primary key.
function NickName: string;
function NumberOfLanes(): integer;
function SessionCount(): integer; overload;
function SessionCount(SDate, EDate: TDateTime): integer; overload;
function StartOfSwimSeason(): TDateTime; overload;
function HasLockedSession(): boolean;
function HasRaceData(): Boolean;
function Delete_SwimClub(DoExclude: boolean = true): boolean;
function TestForSwimClubID(SwimCLubID: integer): boolean;

// procedure RenumberSessions();


implementation

procedure DetailTBLs_DisableCNTRLs;
begin
    CORE.qryTeam.DisableControls;
    CORE.qrySplitTime.DisableControls;
    CORE.qryWatchTime.DisableControls;
    CORE.qryLane.DisableControls;
    CORE.qryHeat.DisableControls;
    CORE.qryEvent.DisableControls;
    CORE.qrySession.DisableControls;
end;

procedure DetailTBLs_ApplyMaster;
begin
  // FireDAC throws exception error if Master is empty?
  if CORE.qrySwimClub.RecordCount <> 0 then
  begin
    CORE.qrySession.ApplyMaster;
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
            CORE.qryTeam.ApplyMaster;
          end;
        end;
      end;
    end;
  end;
end;

procedure DetailTBLs_EnableCNTRLs;
begin
    CORE.qrySession.EnableControls;
    CORE.qryEvent.EnableControls;
    CORE.qryHeat.EnableControls;
    CORE.qryLane.EnableControls;
    CORE.qryWatchTime.EnableControls;
    CORE.qrySplitTime.EnableControls;
    CORE.qryTeam.EnableControls;
end;

function Assert(): boolean;
begin
  result := false;
  if CORE.qrySwimClub.Active then
    if not CORE.qrySwimClub.IsEmpty then
      result := true;
end;

function ClubName: string;
begin
  result := CORE.dsSwimClub.DataSet.FieldByName('Caption').AsString;
end;

function Delete_SwimClub(DoExclude: boolean): boolean;
var
  SQL: string;
begin
  result := false;
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  DetailTBLs_DisableCNTRLs;
  try
    // delete the club data - Sessions, Events, Heats,
    CORE.qrySession.ApplyMaster; // Assert Master-Detail.
    while not CORE.qrySession.Eof do
    begin
      uSession.Delete_Session(DoExclude);
      CORE.qrySession.next;
    end;

    // delete  ClubGroup records then delete the club.
    if CORE.qrySession.IsEmpty then
    begin
      SCM2.scmConnection.StartTransaction;
      try
        // THIS CLUB IS A 'GROUP CLUB'
        if CORE.qrySwimClub.FieldByName('IsClubGroup').AsBoolean then
        begin  // DELETE ParentClubID records
          SQL := '''
            DELETE FROM [SwimClubMeet2].[dbo].[SwimClubGroup]
            WHERE [ParentClubID] = :ID;
            ''';
          SCM2.scmConnection.ExecSQL(SQL, [uSwimClub.PK]);
        end
        else
        begin // DELETE ChildClubID records
          SQL := '''
            DELETE FROM [SwimClubMeet2].[dbo].[SwimClubGroup]
            WHERE [ChildClubID] = :ID;
            ''';
          SCM2.scmConnection.ExecSQL(SQL, [uSwimClub.PK]);
        end;

        // DELETE ALL dbo.MemberLink RECORDS (member's data remains intact).
        SQL := '''
          DELETE FROM [SwimClubMeet2].[dbo].[MemberLink]
          WHERE [SwimClubID] = :ID;
          ''';
        SCM2.scmConnection.ExecSQL(SQL, [uSwimClub.PK]);

        // DELETE ALL dbo.House RECORDS
        // MUST FOLLOW MemberLink deletions else DB integerity exceptions.
        SQL := '''
          DELETE FROM [SwimClubMeet2].[dbo].[House]
          WHERE [SwimClubID] = :ID;
          ''';
        SCM2.scmConnection.ExecSQL(SQL, [uSwimClub.PK]);

        // NOTE: In SwimClubMeet version 2
        // dbo.ScoreDivision and dbo.ScorePoints are universal
        // and are no longer joined on swimming clubs.

        // F I N A L L Y  Delete THE SWIMMING CLUB.
        CORE.qrySwimClub.Delete;
        result := true;
        SCM2.scmConnection.Commit;
      except
        SCM2.scmConnection.Rollback;
        raise;
      end;
    end;
  finally
    DetailTBLs_ApplyMaster;
    DetailTBLs_EnableCNTRLs;
  end;
end;

function GetSwimClubID: integer;
begin
  result := 0;
  if uSwimClub.Assert then
    result := CORE.dsSwimClub.DataSet.FieldByName('SwimClubID').AsInteger;
end;

function HasLockedSession(): boolean;
var
  SQL: string;
  sessionCount: variant;
begin
  result := false;
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  SQL := '''
    SELECT Count(SessionID) FROM  [SwimClubMeet2].[dbo].[Session]
    WHERE [Session].SessionStatusID > 1 AND [Session].SwimClubID = :ID;
    ''';
  try
    // COUNT() will always return 0 or more, never NULL or Empty.
    // So, just checking if sessionCount is greater than 0 is sufficient.
    sessionCount := SCM2.scmConnection.ExecSQLScalar(SQL, [uSwimClub.PK]);
    if sessionCount > 0 then  result := true;
  except on E: exception do
    result := false;
  end;
end;

function HasRaceData(): Boolean;
begin
  result := true;
end;

function IsShortCourse: Boolean;
var
  i: integer;
begin
  result := true;
  i := CORE.dsSwimClub.DataSet.FieldByName('LenOfPool').AsInteger;
  if (i >= 50) then result := false;
end;

function Locate(SwimClubID: integer): boolean;
var
  SearchOptions: TLocateOptions;
begin
  SearchOptions := [];
  result := CORE.qrySwimClub.Locate('SwimClubID', SwimClubID,  SearchOptions);
end;

function PK(): integer;
begin // NO CHECKS. quick and dirty - primary key result.
  result := CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;
end;

function NickName: string;
begin
  result := CORE.dsSwimClub.DataSet.FieldByName('NickName').AsString;
end;

function NumberOfLanes: integer;
begin // how many lanes in the swim club's pool?
  result := CORE.dsSwimClub.DataSet.FieldByName('NumOfLanes').AsInteger;
end;

function SessionCount(): integer;
var
  SQL: string;
  v: variant;
begin
  result := 0;
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    SQL := '''
      SELECT Count(SessionID)
      FROM SwimClubMeet2.dbo.Session
      WHERE Session.SwimClubID = :ID1;
      ''';
    v := SCM2.scmConnection.ExecSQLScalar(SQL, [uSwimClub.PK]);
    if not VarIsClear(v) then result := v;
  end;
end;

function SessionCount(SDate, EDate: TDateTime): integer;
var
  SQL: string;
  v: variant;
begin
  result := 0;
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    SQL := '''
    SELECT Count(SessionID)
    FROM SwimClubMeet2.dbo.Session
    WHERE Session.SwimClubID = :ID1 AND StartDT >= :ID2 AND EndDT <= :ID3;
    ''';
    v := SCM2.scmConnection.ExecSQLScalar(SQL, [uSwimClub.PK, SDate, EDate]);
    if not VarIsClear(v) then result := v;
  end;
end;

function StartOfSwimSeason: TDateTime;
begin
  result := CORE.dsSwimClub.DataSet.FieldByName('StartOfSwimSeason').AsDateTime;
end;

function TestForSwimClubID(SwimCLubID: integer): boolean;
var
  SQL: string;
  v: variant;
begin
  result := false;
  SQL := '''
      SELECT
        CASE WHEN EXISTS (
          SELECT 1 FROM [SwimClubMeet2].[dbo].[SwimClub] sc
          WHERE sc.[SwimClubID] = :ID
        ) THEN 1 ELSE 0 END;
      ''';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [SwimCLubID]);
  if  (not VarIsNull(v)) and (v = 1) then
    result := true;
end;

end.

