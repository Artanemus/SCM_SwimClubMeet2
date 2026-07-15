unit uAgeOfSwimmer;

// Some AI from DeepSeek used here ...

interface

function GetSwimmingAge31stDEC(const DOB: TDateTime): Integer;
function GetSwimmingAge31stDECForDate(const DOB, DateToCheck: TDateTime):
    Integer;
function Get31stDECYear(): integer; // uses CurrentDate as reference.
function Get31stDECDate: TDate;

function GetSwimmingAgeForDate(const DOB, ForDate: TDateTime): Integer;

{ procedure DemonstrateSwimmingAge;}

implementation
uses
  System.SysUtils, System.DateUtils;

{ @Date - Meet, Session, CustomeDate.

  Reference uDefines.
    scmSeedDateAuto = (sda31stDECDate, sdaMeetSessionDate, sdaCustomDate);
}
function GetSwimmingAgeForDate(const DOB, ForDate: TDateTime): Integer;
var
  AYear, AMonth, ADay: Word;
  BirthYear: Word;
  Age: integer;
begin
  result := 0;
  age := 0;
  try
    DecodeDate(ForDate, AYear, AMonth, ADay);
    DecodeDate(DOB, BirthYear, AMonth, ADay); // Reusing vars for birth components
    Age := AYear - BirthYear;
  finally
    if Age <> 0 then Result := Age;
  end;
end;

function Get31stDECDate(): TDate;
var
  SeasonYear: Integer;
begin
  Result := 0;
  SeasonYear := Get31stDECYear;
  if SeasonYear <> 0 then
  begin
    Result := EncodeDate(SeasonYear, 12, 31);
  end;
end;


function Get31stDECYear(): integer;
var
  CurrentDate: TDateTime;
  AYear, AMonth, ADay: Word;
  SeasonYear: Integer;
begin
  Result := 0;
  SeasonYear := 0;
  try
    begin
      CurrentDate := Now;
      DecodeDate(CurrentDate, AYear, AMonth, ADay);
      if AMonth <= 6 then
        SeasonYear := AYear - 1  // Jan-Jun: use previous year's Dec 31
      else
        SeasonYear := AYear;     // Jul-Dec: use current year's Dec 31
      EncodeDate(SeasonYear, 12, 31);
    end;
  finally
    if SeasonYear <> 0 then Result := SeasonYear;
  end;
end;

{ Calculates swimming age based on the "December 31st rule" (Australian/NZ system)
  The swimming season runs July 1 to June 30, and age is locked on December 31st
  of the season's starting year.

  Reference uDefines.
   scmSeedDateAuto = (sda31stDECDate, sdaMeetSessionDate, sdaCustomDate);

  @param DOB: Date of birth as TDateTime
  @returns Integer: Swimming age for the current season }
function GetSwimmingAge31stDEC(const DOB: TDateTime): Integer;
var
  CurrentDate: TDateTime;
  CurrentYear, CurrentMonth, CurrentDay: Word;
  SeasonYear: Integer;
  BirthYear: Word;
begin
  CurrentDate := Now;
  DecodeDate(CurrentDate, CurrentYear, CurrentMonth, CurrentDay);
  DecodeDate(DOB, BirthYear, CurrentMonth, CurrentDay); // Reusing vars for birth components

  // Determine which season we're in
  // Season runs July 1 to June 30
  // If we're in January-June, we're in the season that started in the PREVIOUS year
  // If we're in July-December, we're in the season that started in the CURRENT year
  if CurrentMonth <= 6 then
    SeasonYear := CurrentYear - 1  // Jan-Jun: use previous year's Dec 31
  else
    SeasonYear := CurrentYear;     // Jul-Dec: use current year's Dec 31

  // Age on December 31st of the season year
  Result := SeasonYear - BirthYear;
end;

{ Same as GetSwimmingAge31stDEC, but allows specifying a custom date
  (useful for testing or calculating for past/future seasons)
  @param DOB: Date of birth as TDateTime
  @param DateToCheck: The date of the carnival/meet
  @returns Integer: Swimming age for the season containing DateToCheck }
function GetSwimmingAge31stDECForDate(const DOB, DateToCheck: TDateTime):
    Integer;
var
  YearToCheck, MonthToCheck, DayToCheck: Word;
  SeasonYear: Integer;
  BirthYear: Word;
begin
  DecodeDate(DateToCheck, YearToCheck, MonthToCheck, DayToCheck);
  DecodeDate(DOB, BirthYear, MonthToCheck, DayToCheck);

  // Determine which season this date falls in
  if MonthToCheck <= 6 then
    SeasonYear := YearToCheck - 1  // Jan-Jun: season started previous year
  else
    SeasonYear := YearToCheck;     // Jul-Dec: season started this year

  // Age on December 31st of the season year
  Result := SeasonYear - BirthYear;
end;

{ Procedure to demonstrate corrected logic }
{
procedure DemonstrateSwimmingAge;
var
  DOB: TDateTime;
  CarnivalDate: TDateTime;
  Age: Integer;
begin
  // Example 1: Born Jan 15, 2010
  DOB := EncodeDate(2010, 1, 15);

  // Carnival in January 2026
  CarnivalDate := EncodeDate(2026, 1, 15);
  Age := GetSwimmingAge31stDECForDate(DOB, CarnivalDate);
  Writeln('Born Jan 15, 2010, Carnival Jan 15, 2026: Swimming age = ', Age);
  // CORRECT: Season is 2025/2026, age on Dec 31, 2025 = 15
  // Output: 15

  // Carnival in July 2026 (new season!)
  CarnivalDate := EncodeDate(2026, 7, 1);
  Age := GetSwimmingAge31stDECForDate(DOB, CarnivalDate);
  Writeln('Born Jan 15, 2010, Carnival Jul 1, 2026: Swimming age = ', Age);
  // Season is now 2026/2027, age on Dec 31, 2026 = 16
  // Output: 16

  // Example 2: Born Dec 31, 2010
  DOB := EncodeDate(2010, 12, 31);

  // Carnival in January 2026
  CarnivalDate := EncodeDate(2026, 1, 15);
  Age := GetSwimmingAge31stDECForDate(DOB, CarnivalDate);
  Writeln('Born Dec 31, 2010, Carnival Jan 15, 2026: Swimming age = ', Age);
  // Season 2025/2026, age on Dec 31, 2025 = 15
  // Output: 15 (they just turned 15 on Dec 31, 2025)

  // Carnival in July 2026
  CarnivalDate := EncodeDate(2026, 7, 1);
  Age := GetSwimmingAge31stDECForDate(DOB, CarnivalDate);
  Writeln('Born Dec 31, 2010, Carnival Jul 1, 2026: Swimming age = ', Age);
  // Season 2026/2027, age on Dec 31, 2026 = 16
  // Output: 16 (they'll turn 16 on Dec 31, 2026)

  // Example 3: Born Jun 30, 2015 (end of financial year!)
  DOB := EncodeDate(2015, 6, 30);

  // Carnival in June 2026 (still 2025/2026 season)
  CarnivalDate := EncodeDate(2026, 6, 30);
  Age := GetSwimmingAge31stDECForDate(DOB, CarnivalDate);
  Writeln('Born Jun 30, 2015, Carnival Jun 30, 2026: Swimming age = ', Age);
  // Season 2025/2026, age on Dec 31, 2025 = 10
  // Output: 10 (they're 11 on Jun 30, 2026, but swimming age is 10!)

  // Carnival in July 2026 (new 2026/2027 season)
  CarnivalDate := EncodeDate(2026, 7, 1);
  Age := GetSwimmingAge31stDECForDate(DOB, CarnivalDate);
  Writeln('Born Jun 30, 2015, Carnival Jul 1, 2026: Swimming age = ', Age);
  // Season 2026/2027, age on Dec 31, 2026 = 11
  // Output: 11
end;
}

end.
