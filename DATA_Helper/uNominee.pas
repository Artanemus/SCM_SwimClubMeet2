unit uNominee;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  System.Variants, System.VarUtils,
  System.StrUtils,

  VCL.Dialogs, Vcl.ActnList,

  Data.DB,

  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.Stan.Error,

  uDefines ;


  function Locate_FilterMember(aMemberID: integer): Boolean;
  function Locate_Nominee(aMemberID, aEventID: integer): Boolean;
  function GetSeedDate(): TDate;
  function NewNominee(aMemberID, aEventID: integer): integer;
  function DeleteNominee(aMemberID, aEventID: integer): boolean;
  function RefreshStats(aEventID: integer): boolean;
  function RefreshStat(aEventID, aMemberID: integer): boolean; overload;
  function RefreshStat(aNomineeID: integer): boolean; overload;
  procedure ToogleNomination();

  procedure GetStatSettings(
    out Algorithm: integer; out CalcDefRT: integer; out Percent: double);

  procedure GetMetrics(var aMetrics: TSCMSwimmerMetrics);

implementation

uses

dmCORE, dmSCM2, uSettings, uSwimClub, uSession, uEvent ;

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

procedure GetMetrics(var aMetrics: TSCMSwimmerMetrics);
var
  Algorithm, CalcDefRT: integer;
  Percent: double;
Begin
  if (aMetrics.MemberID = 0) OR (aMetrics.EventID = 0) then exit;

  // initialise out params.
  aMetrics.TTB := 0;
  aMetrics.PB := 0;
  aMetrics.ClubRecord := 0;
  aMetrics.PBSeedTime := 0;
  aMetrics.AGE := 0;
  aMetrics.GenderABREV := '';

  GetStatSettings(Algorithm, CalcDefRT, Percent);
  CORE.qryMemberMetrics.Connection := SCM2.scmConnection;
  CORE.qryMemberMetrics.Close;
  CORE.qryMemberMetrics.ParamByName('MEMBERID').AsInteger := aMetrics.MemberID;
  CORE.qryMemberMetrics.ParamByName('EVENTID').AsInteger := aMetrics.EventID;
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
      aMetrics.TTB := CORE.qryMemberMetrics.FieldByName('TTB').AsDateTime;
      // personal best time for [stroke, distance].
      aMetrics.PB := CORE.qryMemberMetrics.FieldByName('PB').AsDateTime;
      // club record race-time for [age, gender, stroke, distance].
      aMetrics.ClubRecord := CORE.qryMemberMetrics.FieldByName('ClubRecord').AsDateTime;
      // an estimated race-time assigned during nomination..
      // i.e. new member with no historical data or member hasn't ever
      // swum this [stroke, distance].
      aMetrics.PBSeedTime := CORE.qryMemberMetrics.FieldByName('PBSeedTime').AsDateTime;
      // members AGE as of SEEDDATE.
      aMetrics.AGE := CORE.qryMemberMetrics.FieldByName('AGE').AsInteger;
      // Gender ABBREVIATION 'M' Male, 'F' Female, 'X' Mixed or EMPTY.
      aMetrics.GenderABREV := CORE.qryMemberMetrics.FieldByName('GenderABREV').AsString;
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

function RefreshStat(aNomineeID: integer): boolean;
var
  aMemberID, aEventID: integer;
  Metrics: TSCMSwimmerMetrics;
  foundit: boolean;
  SQL: string;
  v: variant;
begin
  Result := false;
  SQL := '''
    SELECT TOP (1) EventID FROM SwimClubMeet2.dbo.Nominee
    WHERE Nominee.NomineeID = :ID;
    ''';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [aNomineeID]) ;
  if not VarIsClear(v) then
  begin
    aEventID := v;
    SQL := '''
      SELECT TOP (1) MemberID FROM SwimClubMeet2.dbo.Nominee
      WHERE Nominee.NomineeID = :ID;
      ''';
    v := SCM2.scmConnection.ExecSQLScalar(SQL, [aNomineeID]) ;
    if not VarIsNull(v) then
    begin
      aMemberID := v;
      Metrics.MemberID := aMemberID;
      Metrics.EventID := aEventID;
      GetMetrics(Metrics);
      foundit := uNominee.Locate_Nominee(aMemberID, aEventID);
      if foundit then
      begin
        CORE.qryNominee.CheckBrowseMode;
        try
          CORE.qryNominee.Edit;
          CORE.qryNominee.FieldByName('TTB').AsDateTime := Metrics.TTB;
          CORE.qryNominee.FieldByName('PB').AsDateTime := Metrics.PB;
          CORE.qryNominee.FieldByName('ClubRecord').AsDateTime := Metrics.ClubRecord;
          CORE.qryNominee.FieldByName('AGE').AsINteger := Metrics.AGE;
          CORE.qryNominee.FieldByName('PBSeedTime').AsDateTime := Metrics.PBSeedTime;
          CORE.qryNominee.Post;
          result := true;
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
end;


function RefreshStat(aEventID, aMemberID: integer): boolean;
var
  Metrics: TSCMSwimmerMetrics;
  foundit: boolean;
begin
  result := false;
  Metrics.MemberID := aMemberID;
  Metrics.EventID := aEventID;
  GetMetrics(Metrics);
  foundit := uNominee.Locate_Nominee(aMemberID, aEventID);
  if foundit then
  begin
    CORE.qryNominee.CheckBrowseMode;
    try
      CORE.qryNominee.Edit;
      CORE.qryNominee.FieldByName('TTB').AsDateTime := Metrics.TTB;
      CORE.qryNominee.FieldByName('PB').AsDateTime := Metrics.PB;
      CORE.qryNominee.FieldByName('ClubRecord').AsDateTime := Metrics.ClubRecord;
      CORE.qryNominee.FieldByName('AGE').AsINteger := Metrics.AGE;
      CORE.qryNominee.FieldByName('PBSeedTime').AsDateTime := Metrics.PBSeedTime;
      CORE.qryNominee.Post;
      result := true;
    except
    on E: EFDDBEngineException do
      begin
        CORE.qryNominee.Cancel;
        SCM2.FDGUIxErrorDialog.Execute(E);
      end;
    end;
  end;
end;

function NewNominee(aMemberID, aEventID: integer): integer;
var
  Metrics: TSCMSwimmerMetrics;
begin
  result := 0;

  if not Assigned(CORE) then exit;
  if not CORE.IsActive then exit;
  if CORE.qryEvent.IsEmpty then exit;
  Metrics.MemberID := aMemberID;
  Metrics.EventID := aEventID;
  GetMetrics(Metrics);
  CORE.qryNominee.CheckBrowseMode;
  CORE.qryNominee.DisableControls();
  try
    begin
            try
        CORE.qryNominee.Insert;
        CORE.qryNominee.FieldByName('AGE').AsInteger := Metrics.AGE;
        CORE.qryNominee.FieldByName('TTB').AsDateTime := Metrics.TTB;
        CORE.qryNominee.FieldByName('PB').AsDateTime := Metrics.PB;
        CORE.qryNominee.FieldByName('PBSeedTime').AsDateTime := Metrics.PBSeedTime;
        CORE.qryNominee.FieldByName('ClubRecord').AsDateTime := Metrics.ClubRecord;
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
