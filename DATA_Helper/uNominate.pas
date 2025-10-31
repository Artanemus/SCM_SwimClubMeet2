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
  function NewNominee(aMemberID, aEventID: integer): integer;
  function DeleteNominee(aMemberID, aEventID: integer): boolean;


implementation

uses

dmCORE, dmSCM2, uDefines, uSettings, uSwimClub, uSession ;

function DeleteNominee(aMemberID, aEventID: integer): boolean;
begin

    // Clear any lane assignement....

    // finally delete the nominee.
    CORE.qryNominee.Delete;

end;




function NewNominee(aMemberID, aEventID: integer): integer;
begin
  // can't assign a member to an event if there isn't any events!
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
        CORE.qryMemberStats.ParamByName('SEEDDATE').AsDateTime := uNominate.GetSeedDate();

        if Assigned(Settings) then
        begin
           CORE.qryMemberStats.ParamByName('ALGORITHM').AsInteger := Settings.ttb_algorithm;
           CORE.qryMemberStats.ParamByName('CALCDEFAULT').AsInteger := Settings.ttb_calcDefault;
           CORE.qryMemberStats.ParamByName('PERCENT').AsFloat := Settings.ttb_percent;
        end
        else
        begin
           CORE.qryMemberStats.ParamByName('ALGORITHM').AsInteger := 2;
           CORE.qryMemberStats.ParamByName('CALCDEFAULT').AsInteger := 1;
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
        CORE.qryNominee.FieldByName('IsEntrant').AsBoolean := false;
        CORE.qryNominee.FieldByName('SeedTime').AsDateTime := CORE.qryMemberStats.FieldByName('RaceTime').AsDateTime;
        CORE.qryNominee.FieldByName('AutoBuildFlag').Clear;
        CORE.qryNominee.FieldByName('EventID').AsInteger := aEventID;
        CORE.qryNominee.FieldByName('MemberID').AsInteger := aMemberID;
        CORE.qryNominee.Post;
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
