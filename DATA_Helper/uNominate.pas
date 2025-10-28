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
  function GetSeedDate(): TDate;


implementation

uses

dmCORE, dmSCM2, uDefines, uSettings, uSwimClub, uSession ;

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
