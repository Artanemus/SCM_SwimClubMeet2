unit uNominate;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  System.Variants, System.VarUtils,
  System.StrUtils,

  VCL.Dialogs, Vcl.ActnList,

  Data.DB,

  FireDAC.Comp.Client, FireDAC.Stan.Param ;

  function Locate_FilterMember(aMemberID: integer): Boolean;
  function Locate_Nominee(aMemberID, aEventID: integer): Boolean;
  function GetSeedDate(): TDate;
  function NewNominee(aMemberID: integer): integer; // current event (PARENT)
  function DeleteNominee(aMemberID: integer): boolean; // current event (PARENT)


implementation

uses

dmCORE, dmSCM2, uDefines, uSettings, uSwimClub, uSession, uEvent ;

function DeleteNominee(aMemberID: integer): boolean;
var
  SQL: string;
  v: variant;
begin
  result := false;
  // Clear any lane assignement....
  // uEvent.ClearEntrant(aMemberID);
  SQL := '''
    UPDATE SwimClubMeet2.dbo.Lane SET(NomineeID) = NULL
    INNER JOIN dbo.Heat ON Lane.HeatID = Heat.HeatID
    INNER JOIN dbo.Event ON heat.EventID = Event.EventID
    INNER JOIN dbo.Nominee ON dbo.Event.EventID = Nominee.EventID
    WHERE dbo.Event.EventID = :ID1 AND NomineeID.MemberID = :ID2
    ''';


  // Clear any team assignment...
  // uTeam.ClearTeamMember();
  SQL := '''
      DELETE FROM SwimClubMeet2.dbo.TeamLink
      INNER JOIN dbo.Nominee ON TeamLink.NomineeID = Nominee.NomineeID
      WHERE Nominee.EventID := ID1 AND Nominee.MemberID := ID2
      ''';
  try
    begin
      v := SCM2.scmConnection.ExecSQL(SQL, [uEvent.PK, aMemberID]);
      if uNominate.Locate_Nominee(aMemberID, uEvent.PK) then
      begin
        // finally delete the nominee.
        CORE.qryNominee.Delete;
        result := true;
      end;
    end;
  except on E: Exception do
  end;

end;




function NewNominee(aMemberID: integer): integer;
begin
  result := 0;

  if not Assigned(CORE) then exit;
  if not CORE.IsActive then exit;
  if CORE.qryEvent.IsEmpty then exit;

  CORE.qryNominee.CheckBrowseMode;
  CORE.qryNominee.DisableControls();
  try
    begin
      try
      begin
        CORE.qryMemberStats.Connection := SCM2.scmConnection;
        CORE.qryMemberStats.Close;
        CORE.qryMemberStats.ParamByName('MEMBERID').AsInteger := aMemberID;
        CORE.qryMemberStats.ParamByName('EVENTID').AsInteger := uEvent.PK;

        // SeedDate - Used to calculate AGE.
        // StartOfSeason, StartOfSession, Today's Date.
        CORE.qryMemberStats.ParamByName('SEEDDATE').AsDateTime := uNominate.GetSeedDate();

        if Assigned(Settings) then     //Algorithm
        begin
           CORE.qryMemberStats.ParamByName('ALGORITHM').AsInteger := Settings.ttb_algorithmIndx;
           CORE.qryMemberStats.ParamByName('CALCDEFRT').AsInteger := ORD(Settings.ttb_calcDefRT);
           CORE.qryMemberStats.ParamByName('PERCENT').AsFloat := Settings.ttb_calcDefRTpercent;
        end
        else
        begin
          // Calculate the entrant's average RT from top 3 race-times
          CORE.qryMemberStats.ParamByName('ALGORITHM').AsInteger := 1;
          // If no RT exists ...
          // 0 - ignore
          // 1 - Calculate race-time from the average times of (filtered) swimmers
          // 2 - use SeedTime
          CORE.qryMemberStats.ParamByName('CALCDEFRT').AsInteger := 1;
           // The (bottom) percent to select from ... default is 50%.
          CORE.qryMemberStats.ParamByName('PERCENT').AsFloat := 50.0;
        end;

        CORE.qryMemberStats.Prepare;
        CORE.qryMemberStats.Open;
      end;
      except on E: Exception do
      end;
      try
        CORE.qryNominee.Insert;
        CORE.qryNominee.FieldByName('AGE').AsInteger := CORE.qryMemberStats.FieldByName('AGE').AsInteger;
        CORE.qryNominee.FieldByName('TTB').AsDateTime := CORE.qryMemberStats.FieldByName('TTB').AsDateTime;
        CORE.qryNominee.FieldByName('PB').AsDateTime :=CORE.qryMemberStats.FieldByName('PB').AsDateTime;
        CORE.qryNominee.FieldByName('SeedTime').AsDateTime := CORE.qryMemberStats.FieldByName('SeedTime').AsDateTime;
        CORE.qryNominee.FieldByName('MemberID').AsInteger := aMemberID;
        CORE.qryNominee.Post;

        // Get the newly created nominee ID.. Safe to do in FireDAC.
        result := CORE.qryNominee.FieldByName('NomineeID').AsInteger;

      {  // BEST PRACTISE - Alternative method...
      v := SCM2.scmConnection.ExecSQLScalar('SELECT IDENT_CURRENT (''dbo.Nominee'');' );
      if not VarIsClear(v) and (v=0) then  NomineeID := v;
      }

      except on E: Exception do
          CORE.qryNominee.Cancel;
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
  result := CORE.qryFilterMember.Locate('MemberID;EventID', VarArrayOf([aMemberID, aEventID]),  SearchOptions);
end;

function GetSeedDate(): TDate;
var
  SeedDateAuto: scmSeedDateAuto;
begin
  result := Date;
  SeedDateAuto := scmSeeddateAuto.sdaTodaysDate;

  if Assigned(Settings) then
    if Settings.SeedDateAuto in [1..2] then
      SeedDateAuto := scmSeedDateAuto(Settings.SeedDateAuto);
  case SeedDateAuto of
    sdaTodaysDate:
      result := Date();
    sdaSessionDate:
      result := uSession.SessionDT;
    sdaStartOfSeason:
      result := uSwimClub.StartOfSwimSeason;
  end;

end;

end.
