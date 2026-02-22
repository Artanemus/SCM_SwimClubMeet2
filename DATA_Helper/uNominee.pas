unit uNominee;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  System.Variants, System.VarUtils,
  System.StrUtils,

  VCL.Dialogs, Vcl.ActnList,

  Data.DB,

  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.Stan.Error ;

  function Locate_FilterMember(aMemberID: integer): Boolean;
  function Locate_Nominee(aMemberID, aEventID: integer): Boolean;
  function GetSeedDate(): TDate;
  function NewNominee(aMemberID, aEventID: integer): integer;
  function DeleteNominee(aMemberID, aEventID: integer): boolean;
  function RefreshStats(aEventID: integer): boolean;
  function RefreshStat(aEventID, aMemberID: integer): boolean;
  procedure ToogleNomination();

  procedure GetStatSettings(
    out Algorithm: integer; out CalcDefRT: integer; out Percent: double);

  procedure GetMetrics(aEventID, aMemberID: integer;
    out TTB: TDateTime; out PB: TDateTime;
    out ClubRecord: TDateTime; out PBSeedTime: TDateTime; out AGE: integer);

implementation

uses

dmCORE, dmSCM2, uDefines, uSettings, uSwimClub, uSession, uEvent ;

function DeleteNominee(aMemberID, aEventID: integer): boolean;
var
  SQL: string;
  v: variant;
//  NomineeID: integer;
begin
  result := false;

  // Clear any team assignment...
  SQL := '''
      DELETE TL
      FROM SwimClubMeet2.dbo.TeamLink AS TL
      INNER JOIN dbo.Nominee AS N ON TL.NomineeID = N.NomineeID
      WHERE N.EventID = :ID1 AND N.MemberID = :ID2
      ''';
  try
    v := SCM2.scmConnection.ExecSQL(SQL, [aEventID, aMemberID]);
  except
    on E: EFDDBEngineException do
      SCM2.FDGUIxErrorDialog.Execute(E);
  end;

  // Clear any lane assignement given to the swimmer (nominee)
  SQL := '''
    UPDATE L
    SET NomineeID = NULL
    FROM SwimClubMeet2.dbo.Lane AS L
    INNER JOIN dbo.Nominee AS N ON L.NomineeID = N.NomineeID
    WHERE N.EventID = :ID1 AND N.MemberID = :ID2;
    ''';
  try
    v := SCM2.scmConnection.ExecSQL(SQL, [aEventID, aMemberID]);
  except
    on E: EFDDBEngineException do
      SCM2.FDGUIxErrorDialog.Execute(E);
  end;

  try
    begin
      if uNominee.Locate_Nominee(aMemberID, aEventID) then
      begin
        // finally delete the nominee.
        CORE.qryNominee.Delete;
        result := true;
      end;
    end;
  except
    on E: EFDDBEngineException do
      begin
        CORE.qryNominee.Cancel;
        SCM2.FDGUIxErrorDialog.Execute(E);
      end;
  end;

end;

procedure GetStatSettings(
  out Algorithm: integer; out CalcDefRT: integer; out Percent: double);
begin
  if Assigned(Settings) then //Algorithm
  begin
    Algorithm := Settings.ttb_algorithmIndx;
    CalcDefRT := ORD(Settings.ttb_calcDefRT);
    Percent := Settings.ttb_calcDefRTpercent;
  end
  else
  begin
    { D E F A U L T S }
    // Calculate the entrant's average RT from top 3 race-times
    Algorithm := 1;
    // If no RT exists ...
    // 0 - ignore
    // 1 - Calculate race-time from the average times of (filtered) swimmers
    // 2 - use SeedTime
    CalcDefRT := 1;
    // The (bottom) percent to select from ...
    Percent := 50.0;
  end;
end;

procedure GetMetrics(aEventID, aMemberID: integer;
  out TTB: TDateTime; out PB: TDateTime;
  out ClubRecord: TDateTime; out PBSeedTime: TDateTime; out AGE: integer);
var
  Algorithm, CalcDefRT: integer;
  Percent: double;
Begin
  // initialise out params.
  TTB := 0;
  PB := 0;
  ClubRecord := 0;
  PBSeedTime := 0;
  AGE := 0;

  GetStatSettings(Algorithm, CalcDefRT, Percent);
  CORE.qryMemberMetrics.Connection := SCM2.scmConnection;
  CORE.qryMemberMetrics.Close;
  CORE.qryMemberMetrics.ParamByName('MEMBERID').AsInteger := aMemberID;
  CORE.qryMemberMetrics.ParamByName('EVENTID').AsInteger := aEventID;
  CORE.qryMemberMetrics.ParamByName('SEEDDATE').AsDateTime :=
    uNominee.GetSeedDate();
  CORE.qryMemberMetrics.ParamByName('ALGORITHM').AsInteger := Algorithm;
  CORE.qryMemberMetrics.ParamByName('CALCDEFRT').AsInteger := CalcDefRT;
  CORE.qryMemberMetrics.ParamByName('PERCENT').AsFloat := Percent;
  CORE.qryMemberMetrics.Prepare;
  try
    CORE.qryMemberMetrics.Open;
    if CORE.qryMemberMetrics.Active then
    begin
      // predicted time to beat (based on historical performance data)
      TTB := CORE.qryMemberMetrics.ParamByName('TTB').AsDateTime;
      // personal best time for [stroke, distance].
      PB := CORE.qryMemberMetrics.ParamByName('PB').AsDateTime;
      // club record race-time for [age, gender, stroke, distance].
      ClubRecord := CORE.qryMemberMetrics.ParamByName('ClubRecord').AsDateTime;
      // an estimated race-time assigned during nomination..
      // i.e. new member with no historical data or member hasn't ever
      // swum this [stroke, distance].
      PBSeedTime := CORE.qryMemberMetrics.ParamByName('PBSeedTime').AsDateTime;
      // members AGE as of SEEDDATE.
      AGE := CORE.qryMemberMetrics.ParamByName('AGE').AsInteger;
    end;
  except on E: EFDDBEngineException do
    exit;
  end;
End;

function RefreshStats(aEventID: integer): boolean;
var
  aMemberID: integer;
begin
  result := false;
  if aEventID = 0 then exit;
  if not Assigned(CORE) then exit;
  if not CORE.IsActive then exit;

  CORE.qryNominees.Connection := SCM2.scmConnection;
  CORE.qryNominees.ParamByName('EVENTID').AsInteger := aEventID;
  CORE.qryNominees.Prepare;
  try
    CORE.qryNominees.Open;
    if CORE.qryNominees.Active then
    begin
      while not CORE.qryNominees.Eof do
      begin
        aMemberID := CORE.qryNominees.FieldByName('MemberID').AsInteger;
        RefreshStat(aEventID, aMemberID);
        CORE.qryNominees.Next;
      end;
    end;
    { Refresh on SwimClubMeet2.dbo.qryLane may be needed...}
  except on E: EFDDBEngineException do
    exit;
  end;

end;

function RefreshStat(aEventID, aMemberID: integer): boolean;
var
  TTB, PB, ClubRecord, PBSeedTime: TDateTime;
  AGE: integer;
  rtn, found: boolean;
begin
  GetMetrics(aEventID, aMemberID, TTB, PB, ClubRecord, PBSeedTime, AGE);
  if rtn then
  begin
    found := uNominee.Locate_Nominee(aMemberID, aEventID);
    if found then
    begin
      CORE.qryNominee.CheckBrowseMode;
      try
        CORE.qryNominee.Edit;
        CORE.qryNominee.FieldByName('TTB').AsDateTime := TTB;
        CORE.qryNominee.FieldByName('PB').AsDateTime := PB;
        CORE.qryNominee.FieldByName('ClubRecord').AsDateTime := ClubRecord;
        CORE.qryNominee.Post;
      except
      on E: EFDDBEngineException do
        begin
          CORE.qryNominee.Cancel;
          SCM2.FDGUIxErrorDialog.Execute(E);
        end;
      end;
    end;
  end;
end;

function NewNominee(aMemberID, aEventID: integer): integer;
var
  TTB, PB, ClubRecord, PBSeedTime: TDateTime;
  AGE: integer;
begin
  result := 0;

  if not Assigned(CORE) then exit;
  if not CORE.IsActive then exit;
  if CORE.qryEvent.IsEmpty then exit;
  GetMetrics(aEventID, aMemberID, TTB, PB, ClubRecord, PBSeedTime, AGE);
  CORE.qryNominee.CheckBrowseMode;
  CORE.qryNominee.DisableControls();
  try
    begin
            try
        CORE.qryNominee.Insert;
        CORE.qryNominee.FieldByName('AGE').AsInteger := AGE;
        CORE.qryNominee.FieldByName('TTB').AsDateTime := TTB;
        CORE.qryNominee.FieldByName('PB').AsDateTime := PB;
        CORE.qryNominee.FieldByName('PBSeedTime').AsDateTime := PBSeedTime;
        CORE.qryNominee.FieldByName('ClubRecord').AsDateTime := ClubRecord;
        CORE.qryNominee.FieldByName('MemberID').AsInteger := aMemberID;
        CORE.qryNominee.FieldByName('EventID').AsInteger := aEventID;
        CORE.qryNominee.Post;

        // Get the newly created nominee ID.. Safe to do in FireDAC.
        result := CORE.qryNominee.FieldByName('NomineeID').AsInteger;

      {  // BEST PRACTISE - Alternative method...
      v := SCM2.scmConnection.ExecSQLScalar('SELECT IDENT_CURRENT (''dbo.Nominee'');' );
      if not VarIsClear(v) and (v=0) then  NomineeID := v;
      }

      except
      on E: EFDDBEngineException do
        begin
          CORE.qryNominee.Cancel;
          SCM2.FDGUIxErrorDialog.Execute(E);
        end;
      end;
    end;

  finally
    CORE.qryNominee.EnableControls();
  end;
end;

function Locate_FilterMember(aMemberID: integer): Boolean;
var
  SearchOptions: TLocateOptions;
begin
  result := false;
  if CORE.qryFilterMember.IsEmpty then exit;
  if (aMemberID = 0) then exit;
  SearchOptions := [];
  result := CORE.qryFilterMember.Locate('MemberID', aMemberID,  SearchOptions);
end;

function Locate_Nominee(aMemberID, aEventID: integer): Boolean;
var
  SearchOptions: TLocateOptions;
begin
  result := false;
  if CORE.qryNominee.IsEmpty then exit;
  if (aMemberID = 0) or (aEventID = 0) then exit;
  SearchOptions := [];
  result := CORE.qryNominee.Locate('MemberID;EventID', VarArrayOf([aMemberID,
    aEventID]), SearchOptions);
end;

function GetSeedDate(): TDate;
var
  SeedDateAuto: scmSeedDateAuto;
begin
  result := Date;
  SeedDateAuto := scmSeeddateAuto.sdaTodaysDate; // DEFAULT Assignment.

  if Assigned(Settings) then  // use USER PREFERENCES if available.
    if Settings.SeedDateAuto in [1..5] then
      SeedDateAuto := scmSeedDateAuto(Settings.SeedDateAuto);

  case SeedDateAuto of
    sdaTodaysDate:  // today's date.
      result := Date();
    sdaSessionDate: // current session date.
      result := uSession.SessionDT;
    sdaStartOfSeason: // start of the swimming season date.
      result := uSwimClub.StartOfSwimSeason;
    sdaCustomDate: // custom date assigned in preferences.
    begin
      if Assigned(Settings) then
       If (Settings.CustomSeedDate <> 0) then
        result := Settings.CustomSeedDate;
    end;
    sdaMeetDate: // date of the meet (or carnival)
    begin
    // PK := uMeet.GetMeetID_WithSession(SessionID)
//      if (PK <> 0) then
//        result := uMeet.GetStartDT(PK);
      ;
    end;
  end;
end;

procedure ToogleNomination();
var
 aMemberID, aEventID: integer;
begin
  // table's readonly state is determined on the lock state of the Session.
  if CORE.qryNominate.UpdateOptions.ReadOnly then exit;

  CORE.qryNominate.DisableControls;
  try
    aMemberID := CORE.qryFilterMember.FieldByName('MemberID').AsInteger;
    aEventID := CORE.qryNominate.FieldByName('EventID').AsInteger;
    if (aMemberID=0) or (aEventID=0)  then exit;
    // is the member nominate?
    if uNominee.Locate_Nominee(aMemberID, aEventID) then
    begin
      // UN-NOMINATE the member. (in the current event)
      uNominee.DeleteNominee(aMemberID, aEventID);
    end
    else
    begin
      // NOMINATE the member. (for the current event)
      uNominee.NewNominee(aMemberID, aEventID);
    end;
  finally
    CORE.qryNominate.Refresh; // redraws (icon) checkbox state.
    CORE.qryNominate.EnableControls;
  end;
end;


end.
