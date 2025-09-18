unit uSwimClub;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  System.Variants, Data.DB,
  vcl.Dialogs,
  dmCORE, dmSCM2;

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

// procedure RenumberSessions();


implementation

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
begin
  if True then
    exit;
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
  v: variant;
begin
  result := false;
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  SQL := '''
    SELECT Count(SesionID) FROM  [SwimClubMeet2].[dbo].[Session]
    WHERE [Session].SessionStatusID > 1 AND [Session].SwimClubID = :ID'
    ''';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uSwimClub.PK]);
  if not VarIsNull(v) and not VarIsEmpty(v) and (v > 0) then result := true;
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

end.

