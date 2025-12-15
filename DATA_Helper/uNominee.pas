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

function NewNominee(aMemberID, aEventID: integer): integer;
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
        CORE.qryMemberStats.ParamByName('EVENTID').AsInteger := aEventID;

        // SeedDate - Used to calculate AGE.
        // StartOfSeason, StartOfSession, Today's Date.
        CORE.qryMemberStats.ParamByName('SEEDDATE').AsDateTime := uNominee.GetSeedDate();

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
      except
        on E: EFDDBEngineException do
            SCM2.FDGUIxErrorDialog.Execute(E);
      end;

      try
        CORE.qryNominee.Insert;
        CORE.qryNominee.FieldByName('AGE').AsInteger := CORE.qryMemberStats.FieldByName('AGE').AsInteger;
        CORE.qryNominee.FieldByName('TTB').AsDateTime := CORE.qryMemberStats.FieldByName('TTB').AsDateTime;
        CORE.qryNominee.FieldByName('PB').AsDateTime :=CORE.qryMemberStats.FieldByName('PB').AsDateTime;
        CORE.qryNominee.FieldByName('SeedTime').AsDateTime := CORE.qryMemberStats.FieldByName('SeedTime').AsDateTime;
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
