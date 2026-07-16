unit uABINDV;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Math,
  System.StrUtils, System.Types,  System.Variants,
  Data.DB,

  VCL.Dialogs,
  FireDAC.Comp.Client, FireDAC.Stan.Error,  FireDAC.Stan.Param,
  dmSCM2, dmCORE, uSettings,
  dmABINDV_Data,
  uDefines, uUtility, uSwimClub, uSession, uNominee, uEvent, uHeat, uLane
  ;

type

  TLaneEntrant = class;  // forward declaration.
  TDivision = class; // forward declaration.

  scmABSortMode = (abNotSorted, abTTB, abRandom);

  TABINDV = class(TComponent)
  private
    ABData: TABINDV_Data;
    AryEntrants: Array of TLaneEntrant;
    AryDivisionsSCM: Array of TDivision;
    AryDivisionsMixed: Array of TDivision;
    AryDivisionsFemale: Array of TDivision;
    AryDivisionsMale: Array of TDivision;
    AryEntrantsPerHeat: Array of Integer;
    AryExcludedLanes: Array of boolean;
    AryScatteredLanes: Array of Integer;
    fConnection: TFDConnection;
    fError: boolean;
    fErrorNum: integer;
    fEventID: Integer;
    fExcludeLaneCount: integer;
    fNumOfPoolLanes: integer;
    fRealNumOfLanes: integer;
    fSortMode: scmABSortMode;
    fVerbose: boolean;

    findxDivisionMixed: integer;
    findxDivisionMale: integer;
    findxDivisionFemale: integer;
    findxDivisionSCM: integer;

    function AryEntrants_AssignLaneNum(NumOfHeats: Integer): Integer;
    function AryEntrants_AssignNominees: integer;
    function AryEntrants_AssignHeatNum(NumOfHeats: Integer): integer;
    function AryDivisions_Build(GenderID: Integer): integer;

    function AryExcludedLanes_Build: Integer;
    procedure AryScatterLanes_Build(NumOfPoolLanes: integer);
    function Build_EntrantsPerHeat(NumOfHeats: Integer; NumOfNominees: Integer):
        Integer;
    function Build_FillLanes(HeatID, HeatNum: Integer): Integer;
    function Build_Heats(NumOfHeats, NumOfNominees: Integer): integer;
    function CalcNumberOfHeats(NumOfNominees, RealNumOfLanes: Integer): Integer;
    procedure ClearAryEntrants;
    procedure ClearAllAryDivisions;
    { Seed AryEntrants. }
    function Seed_Circle(NumOfHeats, SeedDepth: Integer): Integer;
    function Seed_Default(NumOfHeats: Integer; Offset: Integer = 0): Integer;
    function Seed_Random(NumOfHeats: Integer): Integer;
    { Sort AryEntrants.}
    procedure SortAryEntrantsByRandom;
    procedure SortAryEntrantsByTTB;
    function INNER_LOOP(NumOfEntrants: Integer): Integer;
    function OUTER_LOOP: Integer;
    function GetDivisionFilterString(GenderID: integer): string;

  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
    function AutoBuildExec: Boolean;
    function Prepare(AConnection: TFDConnection; EventID: Integer; Verbose: boolean
        = false): Boolean;
  end;

  TLaneEntrant = class(TObject)
    NomineeID: integer;
    HeatRankNum: integer;
    HeatNum: integer;
    LaneNum: integer;
    RandomNum: integer;
    TTB: TTime;
    constructor Create();
    destructor Destroy; override;
  end;

  TDivision = class(TObject)
    StartAge: integer;
    EndAge: integer;
    GenderID: integer;
    constructor Create();
    destructor Destroy; override;
  end;

implementation

uses
  dlgABDebug;

{ TLaneEntrant }

constructor TLaneEntrant.Create;
begin
  NomineeID := 0;
  HeatNum := 0;
  LaneNum := 0;
  RandomNum := 0;
end;

destructor TLaneEntrant.Destroy;
begin
  // Do stuff here...
  inherited;
end;

constructor TABINDV.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fConnection := nil;
  fError := false;
  fErrorNum := 0;
  fEventID := 0;
  fExcludeLaneCount := 0;
  fNumOfPoolLanes:= 0;
  fRealNumOfLanes := 0;
  fVerbose := true;
  fSortMode := abNotSorted;

  Randomize; // initialize RAND seed.
  ABData := TABINDV_Data.Create(Self);
end;

destructor TABINDV.Destroy;
begin
  // TODO -cMM: TABINDV.Destroy default body inserted
  ABData.DeActivateData;
  ABData.Free;
  ClearAryEntrants;
  ClearAllAryDivisions;
  inherited;
end;

function TABINDV.AryEntrants_AssignLaneNum(NumOfHeats: Integer): Integer;
var
  I, J, RankOffset, Rank, laneNum, EntrantCount, Count: integer;
  obj: TLaneEntrant;
  found: boolean;
begin
  { Acll here after assigning HeatNum, NomineeID and RankNum.
    How rank works...
    Rank order of the swimmer. ie. 1st, 2nd, 3rd, etc.
    Fast swimmers have a lower value.}
  result := 0;
  EntrantCount := 0;

  if fSortMode <> abTTB then
    SortAryEntrantsByTTB;

  for J := 0 to NumOfHeats-1 do // iterate over heats.
  begin
    RankOffset := 0; // rankoffest is used to skip user-excluded lanes.
    Count := 0; // used to test if heat has been processed.

    for I := 0 to Length(AryEntrants) - 1 do // Fastest swimmer always at head of array.
    begin
      // Has all the entrants been assigned a lane for the given heat?
      if (Count >= AryEntrantsPerHeat[J]) then break;

      obj := AryEntrants[i];
      if (obj.HeatNum <> (J+1)) then continue;  // wrong heat number.

      Rank := obj.HeatRankNum + RankOffset; // modify to skip lanes.
      found := false;

      { Handle excluded lanes. Skipping lanes by adjusting ranking.}
      While not found do
      begin
        if (Rank < 1) or (Rank >= Length(AryScatteredLanes)) then
          break;  // out of bounds.
        laneNum := AryScatteredLanes[Rank-1]; // NOTE: AryScatteredLanes is base 0
        if AryExcludedLanes[laneNum-1] then // NOTE: AryExcludedLanes is base 0
        begin
          INC(Rank);
          INC(RankOffset); // needed for the next entrant - to skip excluded lanes.
        end
        else
          found := true;
      end;
      { Look-up rank and return with lane number. }
      if found then
      begin
        obj.LaneNum := AryScatteredLanes[Rank-1] ;
        INC(EntrantCount);
        INC(Count);
      end
      else
        {TODO -oBSA -cGeneral : ERROR -Entrant never got a lane in chosen heat.}
        obj.LaneNum := 0;
    end;
  end;
  if EntrantCount > 0 then result := EntrantCount;  // number of heats
end;


function TABINDV.AryEntrants_AssignNominees: integer;
var
  obj: TLaneEntrant;
  Count: integer;
begin
  result := 0;
  count := 0;
  ClearAryEntrants; // clears TLaneEntrant objects and SetLength = 0.
  // NOTE: qryUnplacedNominees sorted fastest to slowest.
  ABData.qryUnplacedNominees.First;
  while not ABData.qryUnplacedNominees.EOF do
  begin // populate the AryEntrants...
    obj := TLaneEntrant.Create();
    obj.NomineeID :=
      ABData.qryUnplacedNominees.FieldByName('NomineeID').AsInteger;
    obj.RandomNum := Random(SizeOf(Int16)); // assign randomNum
    AryEntrants := AryEntrants + [obj]; // append to end of array.
    INC(Count, 1);
    ABData.qryUnplacedNominees.Next;
  end;
  if Count > 0 then result := Count;
end;

function TABINDV.AryDivisions_Build(GenderID: Integer): integer;
var
  obj: TDivision;
  count: integer;
begin
  result := 0;
  count := 0;
  ClearAllAryDivisions; // clear divisions array.

  case GenderID of
    0: // SCM Divisions
    begin
      obj := TDivision.Create;
      obj.StartAge := 0;
      obj.EndAge := 6;
      obj.GenderID := 0; // zero assignment indicates - ignore gender.
      AryDivisionsSCM := AryDivisionsSCM + [obj]; // append to array.
      INC(Count);
      obj := TDivision.Create;
      obj.StartAge := 7;
      obj.EndAge := 8;
      obj.GenderID := 0;
      AryDivisionsSCM := AryDivisionsSCM + [obj]; // append to array.
      INC(Count);
      obj := TDivision.Create;
      obj.StartAge := 9;
      obj.EndAge := 10;
      obj.GenderID := 0;
      AryDivisionsSCM := AryDivisionsSCM + [obj]; // append to array.
      INC(Count);
      obj := TDivision.Create;
      obj.StartAge :=11;
      obj.EndAge := 12;
      obj.GenderID := 0;
      AryDivisionsSCM := AryDivisionsSCM + [obj]; // append to array.
      INC(Count);
      obj := TDivision.Create;
      obj.StartAge := 13;
      obj.EndAge := 14;
      obj.GenderID := 0;
      AryDivisionsSCM := AryDivisionsSCM + [obj]; // append to array.
      INC(Count);
      obj := TDivision.Create;
      obj.StartAge := 15;
      obj.EndAge := 16;
      obj.GenderID := 0;
      AryDivisionsSCM := AryDivisionsSCM + [obj]; // append to array.
      INC(Count);
      obj := TDivision.Create;
      obj.StartAge := 17; // OPEN division
      obj.EndAge := 999;
      obj.GenderID := 0;
      AryDivisionsSCM := AryDivisionsSCM + [obj]; // append to array.
      INC(Count);
    end;
    1: // Custom Division - MALE
    begin
      ABData.qryDivision.IndexName := 'idxGender1';
    end;
    2:  // Custom Division - FEMALE
    begin
      ABData.qryDivision.IndexName := 'idxGender2';
    end;
    3: // Custom Division - MIXED
    begin
      ABData.qryDivision.IndexName := 'idxGender3';
    end;
  end;

  if GenderID in [1,2,3] then
  begin
    ABData.qryDivision.Connection := SCM2.scmConnection;
    ABData.qryDivision.Open;
    if ABData.qryDivision.Active then
    begin
      While not ABData.qryDivision.EOF do
      begin
        obj := TDivision.Create;
        obj.StartAge := ABData.qryDivision.FieldByName('AgeFrom').AsInteger;
        obj.EndAge := ABData.qryDivision.FieldByName('AgeTo').AsInteger;
        obj.GenderID := ABData.qryDivision.FieldByName('GenderID').AsInteger;
        case GenderID of
        1:
          AryDivisionsMale := AryDivisionsMale + [obj]; // append to array.
        2:
          AryDivisionsFemale := AryDivisionsFemale + [obj]; // append to array.
        3:
          AryDivisionsMixed := AryDivisionsMixed + [obj]; // append to array.
        end;
        INC(Count);
        ABData.qryDivision.Next;
      end;
    end;
  end;
  if Count <> 0 then
    result := Count;
end;

function TABINDV.AryEntrants_AssignHeatNum(NumOfHeats: Integer): integer;
var
  SeedDepth: integer;
  NumOfEntrantsSeeded, count: integer;
begin
  result := 0;
  SeedDepth := Settings.ab_SeedDepth;
  NumOfEntrantsSeeded := 0;
  if SeedDepth = 0 then
    SeedDepth := NumOfHeats;

  case Settings.ab_SeedMethodIndx of
    0:
      begin
        {  STANDARD SEEDING.}
        NumOfEntrantsSeeded := Seed_Default(NumOfHeats);
      end;
    2:
      begin
        {CIRCLE SEEDING.}
        NumOfEntrantsSeeded := Seed_Circle(NumOfHeats, SeedDepth);
        {DEFAULT SEEDING.}
        if (NumOfEntrantsSeeded < NumOfHeats) then
        begin
          { do the remaining heats using STANDARD SEEDING.}
          count := Seed_Default(NumOfHeats, NumOfEntrantsSeeded);
          NumOfEntrantsSeeded := NumOfEntrantsSeeded + count;
        end;
      end;
    3:
      begin
        NumOfEntrantsSeeded := Seed_Random(NumOfHeats);
      end;
  end;
  if NumOfEntrantsSeeded > 0 then result := NumOfEntrantsSeeded;
end;

function TABINDV.AryExcludedLanes_Build: Integer;
var
  sa: TStringDynArray;
  LaneNum, J, count: integer;
  s: string;
begin
  // INIT BOOLEANS:
  result := 0;
  count := 0;
  SetLength(AryExcludedLanes, fNumOfPoolLanes);
  for j := Low(AryExcludedLanes) to High(AryExcludedLanes) do
    AryExcludedLanes[j] := false;

  if Settings.ab_ExcludeLanes then
  begin
    sa := SplitString(Settings.ab_ListOfExcludeLanes, ',');
    for J := Low(sa) to High(sa) do
    begin
      s := Trim(sa[J]);
      If not s.IsEmpty then
      begin
        LaneNum := StrToIntDef(s, 0);
        if (LaneNum > 0) and (LaneNum <= fNumOfPoolLanes) then
        begin
          AryExcludedLanes[Lanenum-1] := true;
          INC(count);
        end;
      end;
    end;
    result := count;
  end;
end;

// -----------------------------------------------------------
// SHARED FUNCTION
// Called by dmSCM2 and dmAutoBuildV2
// -----------------------------------------------------------
procedure TABINDV.AryScatterLanes_Build(NumOfPoolLanes: integer);
var
  i: integer;
  IsEven: boolean;
begin
  // NumOfPoolLanes must be greater than 1
  if (NumOfPoolLanes < 2) then
    exit;
  SetLength(AryScatteredLanes, NumOfPoolLanes);
  // seed number for first array value
  // Find the center lane. For 'odd' number of pool AryScatteredLanes - round up;
  AryScatteredLanes[0] := Ceil(double(NumOfPoolLanes) / 2.0);
  // build the
  for i := 1 to NumOfPoolLanes - 1 do
  begin
    // start the iterate at index 1
    // reference previous value in list with base 0
    if (((i + 1) MOD 2) = 0) then
      IsEven := True
    else
      IsEven := False;
    if IsEven then
      AryScatteredLanes[i] := (i) + (AryScatteredLanes[(i - 1)])
    else
      AryScatteredLanes[i] := (AryScatteredLanes[(i - 1)]) - (i);
  end;
end;

function TABINDV.AutoBuildExec: Boolean;
var
  msg: string;
  count, tot, I: integer;
  obj: TDivision;
begin
  result := false;

  if fEventID = 0 then
  begin
    if (fVerbose) then
      MessageDlg('No event number was given.' + sLineBreak +
        'Auto-Build will abort..', mtError, [mbOK], 0, mbOK);
    fError := true;
    fErrorNum := 1;
    exit;
  end;


  if not Assigned(Settings) then
  begin
    if (fVerbose) then
      MessageDlg('Settings (preferences) error.' + sLineBreak +
        'Auto-Build will abort..', mtError, [mbOK], 0, mbOK);
    fError := true;
    fErrorNum := 1;
    exit;
  end;

  if not uEvent.Assert then
  begin
    if (fVerbose) then
      MessageDlg('No connection or no events found.' + sLineBreak +
        'Auto-Build will abort.', mtError, [mbOK], 0, mbOK);
    fError := true;
    fErrorNum := 1;
    exit;
  end;

  if (uEvent.PK = 0) OR (uEvent.GetEventType = etTEAM) then
  begin
    if (fVerbose) then
      MessageDlg('The event type must be INDV.' + sLineBreak +
        'Auto-Build will abort.', mtError, [mbOK], 0, mbOK);
    fError := true;
    fErrorNum := 1;
    exit;
  end;

  if not ABData.IsActive then
  begin
    if (fVerbose) then
      MessageDlg('AB Data Module error.' + sLineBreak +
        'Auto-Build will abort.', mtError, [mbOK], 0, mbOK);
    fError := true;
    fErrorNum := 1;
    exit;
  end;

  // CLEAN UP HEATS - Remove opened heats. Exclude raced or closed heats.
  if not CORE.qryHeat.IsEmpty then
  begin
    SCM2.ProcDeleteALLHeats.Connection := SCM2.scmConnection;
    SCM2.ProcDeleteALLHeats.StoredProcName := 'DeleteAllHeats';
    SCM2.procDeleteALLHeats.ParamByName('@EventID').AsInteger := uEvent.PK;
    SCM2.procDeleteALLHeats.ParamByName('@Exclude').AsBoolean := true;
    SCM2.procDeleteALLHeats.Prepare;
    SCM2.procDeleteALLHeats.ExecProc;

    // IMPORTANT: Resync CORE Master/Detail to DataBase State..
    CORE.qryHeat.Refresh;
  end;

  if not CORE.qryHeat.IsEmpty then
  begin
    // RENUMBER HEATS: calls stored procedure - SwimClubMeet.dbo.RenumberHeats
    uEvent.RenumberHeats; // performs refresh on qryheat.
  end;

  // There must be a least 2 lanes for the scatter algorithm.
  if ( uSwimClub.NumberOfLanes < 2) then
  begin
    if (fVerbose) then
    begin
      msg := '''
        Your pool needs at least two swimming lanes.
        Is the Club''s number of pool lanes correctly assigned?
        Auto-Build will abort.
      ''';
      MessageDlg(msg, mtError, [mbOK], 0, mbOK);
    end;
    fError := true;
    fErrorNum := 1;
    exit;
  end;

  fNumOfPoolLanes := uSwimClub.NumberOfLanes;
  // PREPARE AryExcludedLanes.
  fExcludeLaneCount := AryExcludedLanes_Build;
  // Get the real number of available lanes.
  fRealNumOfLanes:=fNumOfPoolLanes-fExcludeLaneCount;

  if (fRealNumOfLanes <= 0) then
  begin
    if (fVerbose) then
    begin
      msg := '''
        After considering the total number of pool lanes,
        less the selected lanes to exclude, the total number
        of lanes available for a heat is zero! Consider making
        adjustment to the auto-build settings.
        Auto-Build will exit.
        ''';
      MessageDlg(msg, mtError, [mbOK], 0, mbOK);
    end;
    // Is this an error or a warning.
    fError := true;
    fErrorNum := 1;
    result := false;
    exit;
  end;

 { Initialise AryScatteredLanes. Fast ranked swimmers take center lanes,
    slow swimmers outside lanes. Routine ignores excluded lanes. }
  AryScatterLanes_Build(fNumOfPoolLanes); // dbo.SwimClub ... number of pool lanes.

  { Create a list of unplaced nominees in the event.}
  ABData.qryUnplacedNominees.Connection := SCM2.scmConnection;
  ABData.qryUnplacedNominees.ParamByName('EVENTID').AsInteger  := fEventID;
  ABData.qryUnplacedNominees.Prepare;
  try
    begin
      ABData.qryUnplacedNominees.Open;
      { Rebuild the metric data for all unplaced nominees in the event.}
      if ABData.qryUnplacedNominees.Active then
      begin
        While not ABData.qryUnplacedNominees.Eof do
        begin
          uNominee.RefreshStat(
              ABData.qryUnplacedNominees.FieldByName('NomineeID').AsInteger );
          ABData.qryUnplacedNominees.Next;
        end;
      end;
    end;
  except on E: EFDDBEngineException do
    SCM2.FDGUIxErrorDialog.Execute(E);
  end;

  if (ABData.qryUnplacedNominees.IsEmpty) then
  begin
    if (fVerbose) then
    begin
      msg := '''
        ''OPEN'' heats have been cleared.
        After excluding entrants in closed and raced heats ...
        all outstanding nominees have been given a lane.
        Auto-Build will exit.
        ''';
      MessageDlg(msg, mtError, [mbOK], 0, mbOK);
    end;
    // All the nominees are placed - nothing more to do. OK.
    fError := false;
    fErrorNum := 0;
    result := true;
    exit;
  end;

  // Assign FireDAC index name.
  // sort unplaced entrants fastest to slowest - using TTB.
  ABData.qryUnplacedNominees.IndexName := 'indxTTB';
  ABData.qryUnplacedNominees.Filter := '';
  ABData.qryUnplacedNominees.Filtered := false;

  // Build ALL division arrays ...
  if (Settings.ab_GroupByIndx > 0) then
  begin
    AryDivisions_Build(0); //SCM
    AryDivisions_Build(1); //MALE
    AryDivisions_Build(2); //FEMALE
    AryDivisions_Build(3); //MIXED
  end;

  findxDivisionMixed := 0;
  findxDivisionMale := 0;
  findxDivisionFemale := 0;
  findxDivisionSCM := 0;

  count := OUTER_LOOP;  // Seperate gender :: INNER_LOOP Array Init, etc.
  if count > 0 then result := true;

end;

function TABINDV.GetDivisionFilterString(GenderID: integer): string;
var
  obj: TDivision;
  divisionFilter: string;
begin
  // DIVISIONS FILTER STRING .
  result := '';
  divisionFilter := '';
  obj := nil;
  // Extract a filter for age range.
  case Settings.ab_GroupByIndx of
    0: // no grouping .. no divisions.
      divisionFilter := '';
    1: // CUSTOM DIVISIONS
    begin
      case GenderID of
        1:
        begin
          if findxDivisionMale <= high(AryDivisionsMale) then
            obj := AryDivisionsMale[findxDivisionMale];
        end;
        2:
        begin
          if findxDivisionFemale <= high(AryDivisionsFemale) then
          begin
            obj := AryDivisionsFemale[findxDivisionFemale];
          end;
        end;
        3:
        begin
          if findxDivisionMixed <= high(AryDivisionsMixed) then
          begin
            obj := AryDivisionsMixed[findxDivisionMixed];
          end;
        end;
      end;

      if obj <> nil then
        divisionFilter := 'Age >= ' + IntToStr(obj.StartAge)
          + ' Age <= ' + IntToStr(obj.EndAge) ;
    end;

    2: // SCM DIVISIONs
    begin
      if findxDivisionSCM<= high(findxDivisionSCM) then
        obj := AryDivisionsMale[findxDivisionSCM];

      if obj <> nil then
        divisionFilter := 'Age >= ' + IntToStr(obj.StartAge)
          + ' Age <= ' + IntToStr(obj.EndAge) ;
    end;
  end;
  if Length(divisionFilter) > 0 then
    result := divisionFilter;
end;

function TABINDV.OUTER_LOOP: Integer;
var
  NumOfEntrants, GenderID, count: integer;
  msg, divisionFilter, filterStr: string;
begin
  result := 0;

  ABData.qryUnplacedNominees.Filter := '';
  ABData.qryUnplacedNominees.Filtered := false;

  // -----------------------------------------------------
  // ENABLED ... SEPERATE BY GENDER ...ENABLED.
  // -----------------------------------------------------
  if Settings.ab_SeperateGender then
  begin
    ABData.qryGender.Connection := SCM2.scmConnection;
    ABData.qryGender.Open;

    if ABData.qryGender.Active then
    begin
      count := 0;

      // do

      ABData.qryGender.Last; // reverse order, female then male swimmers.
      // iterate across Mixed, Female, Male (in that order)...
      while not ABData.qryGender.BOF do
      begin
        GenderID := ABData.qryGender.FieldByName('GenderID').AsInteger;

        divisionFilter := GetDivisionFilterString(GenderID);
        FilterStr := 'GenderID = ' + IntToStr(GenderID);
        if Length(divisionFilter) <> 0 then
          FilterStr := FilterStr + ' AND ' + DivisionFilter;

        ABData.qryUnplacedNominees.Filter := FilterStr;
        if not ABData.qryUnplacedNominees.Filtered then
          ABData.qryUnplacedNominees.Filtered := true;

        // after all filters are applied - get the number of unplaced nominees.
        NumOfEntrants := ABData.qryUnplacedNominees.RecordCount;
        if NumOfEntrants <> 0 then
          count := count + INNER_LOOP(NumOfEntrants);

        ABData.qryGender.Prior;
      end;

      // until not divisionstoDO

      if count <> 0 then
        result := count;
    end
    else
    begin
      // unable to open qryGender...
      if (fVerbose) then
      begin
        msg := '''
          Failed to activate local query - qryGender.
          Internal error : Unable to seperate genders.
          Auto-Build will exit.
          ''';
        MessageDlg(msg, mtError, [mbOK], 0, mbOK);
      end;
      // All the nominees are placed - nothing more to do. OK.
      fError := true;
      fErrorNum := 1;
      result := 0;
      exit;
      end;
  end

  else

  // -----------------------------------------------------
  // SEPERATE BY GENDER DISABLED
  // -----------------------------------------------------
  begin
    // do

    divisionFilter := GetDivisionFilterString(GenderID);
    if Length(divisionFilter) <> 0 then
    begin
      ABData.qryUnplacedNominees.Filter :=  DivisionFilter;
      if not ABData.qryUnplacedNominees.Filtered then
        ABData.qryUnplacedNominees.Filtered := true;
    end;

    NumOfEntrants := ABData.qryUnplacedNominees.RecordCount;
    count := INNER_LOOP(NumOfEntrants);

    // until MoreDivisionsToDo .

    if count <> 0 then
      result := count;
    end;
end;

function TABINDV.INNER_LOOP(NumOfEntrants: Integer): Integer;
var
  NumOfHeats, count: integer;
  msg: string;
begin
  result := 0;
  // CALCULATE the number of heats needed to build.
  NumOfHeats := CalcNumberOfHeats(NumOfEntrants, fRealNumOfLanes);
  if NumOfHeats = 0 then
  begin
    // This isn't flagged as an error.
    // For example is seperate gender is true and none found
    // OR
    // Group by index and none found,,,
    fError := false;
    fErrorNum := 0;
    result := 0;
    exit;
  end;

  // construct the AryEntrants array with it's TLaneEntrant objects.
  // assign random number.
  count := AryEntrants_AssignNominees();
  if count <> NumOfEntrants then
  begin
    if (fVerbose) then
    begin
      msg := '''
        Internal error...
        Failed to assign all Entrants to AryEntrants.
        Auto-Build will exit.
        ''';
      MessageDlg(msg, mtError, [mbOK], 0, mbOK);
    end;
    fError := true;
    fErrorNum := 1;
    result := 0;
    exit;
  end;

  // how many entrants per heat with consideration to fRealNumOfLanes.
  // TODO: set weights to first or last heat?
  count := Build_EntrantsPerHeat(NumOfHeats, NumOfEntrants);
  if count <> NumOfEntrants then
  begin
    if (fVerbose) then
    begin
      msg := '''
        Internal error...
        Failed to distrubute all entrants across heats.
        Auto-Build will exit.
        ''';
      MessageDlg(msg, mtError, [mbOK], 0, mbOK);
    end;
    fError := true;
    fErrorNum := 1;
    result := 0;
    exit;
  end;

  // SEEDING BEGINS....
  // Each Seeding Method sets array entrants sort order..
  // Assign each entrant to a heat and assign a HeatRankNum.
  // returns the number of entrants seeded (given a heat number).
  count := AryEntrants_AssignHeatNum(NumOfHeats);
  if count = 0 then
  begin
    if (fVerbose) then
    begin
      msg := '''
        Internal error...
        Failed to assign a ranking to each entrant.
        Auto-Build will exit.
        ''';
      MessageDlg(msg, mtError, [mbOK], 0, mbOK);
    end;
    fError := true;
    fErrorNum := 1;
    result := 0;
    exit;
  end;

  // Assign a swimming lane to each entrant based on heat ranking,
  // taking into account lane scattering and excluded lanes.
  // returns the number of entrants assigned a lane number.
  count := AryEntrants_AssignLaneNum(NumOfHeats);
  if count = 0 then
  begin
    if (fVerbose) then
    begin
      msg := '''
        Internal error...
        Failed to assign swimming lanes to entrants.
        Auto-Build will exit.
        ''';
      MessageDlg(msg, mtError, [mbOK], 0, mbOK);
    end;
    fError := true;
    fErrorNum := 1;
    result := 0;
    exit;
  end;

  if count <> NumOfEntrants then
  begin
    if (fVerbose) then
    begin
      msg := '''
        Internal warning...
        Failed to provide all entrants with a swimming lane.
        Auto-Build will continue.
        ''';
      MessageDlg(msg, mtError, [mbOK], 0, mbOK);
    end;
  end;

  // FINALLY : create heats and lanes in the SwimClubMeet2 database.
  // returns number of entrants assigned to lanes
  count := Build_Heats(NumOfHeats, NumOfEntrants);
  CORE.qryLane.Refresh; // REQUIRED: ReSync data state.

  if count < NumOfEntrants then
  begin
    if (fVerbose) then
    begin
      msg := '''
        Internal error...
        Failed to create all heats and lanes. (SCM database error).
        Auto-Build will exit.
        ''';
      MessageDlg(msg, mtError, [mbOK], 0, mbOK);
    end;
    fError := true;
    fErrorNum := 1;
    result := 0;
    exit;
  end;

  if not CORE.qryHeat.IsEmpty then
  begin
    // RENUMBER HEATS: calls stored procedure - SwimClubMeet.dbo.RenumberHeats
    // Will performs refresh on qryheat, ApplyMaster and FreFresh on qryLane.
    uEvent.RenumberHeats;
    // NOTE: if IsEmpty - call UpdateUI at frFrameHeat....
  end;

  result := count;

end;

function TABINDV.Build_EntrantsPerHeat(NumOfHeats: Integer; NumOfNominees:
  Integer): Integer;
var
  I, Count, HeatIndex: Integer;
begin
  Result := 0;
  Count := 0;
  // Input validation
  if NumOfHeats <= 0 then
  begin
    SetLength(AryEntrantsPerHeat, 0);
    Exit;
  end;
  // Initialize array with zeros
  SetLength(AryEntrantsPerHeat, NumOfHeats);
  for I := 0 to NumOfHeats - 1 do
    AryEntrantsPerHeat[I] := 0;
  // Distribute one swimmer at a time in round-robin fashion
  HeatIndex := 0;
  for I := 1 to NumOfNominees do
  begin
    INC(AryEntrantsPerHeat[HeatIndex]);
    INC(Count);
    HeatIndex := (HeatIndex + 1) mod NumOfHeats;
  end;
  if Count > 0 then Result := Count;
end;

function TABINDV.Build_FillLanes(HeatID, HeatNum: Integer): Integer;
var
  Count: integer;
  obj: TLaneEntrant;
  SearchOptions: TLocateOptions;
  found: boolean;
begin
  result := 0;
  Count := 0;
  SearchOptions := [];
  if fSortMode <> abTTB then
    SortAryEntrantsByTTB;
  try
    CORE.qrySplitTime.DisableControls;
    CORE.qryWatchTime.DisableControls;
    CORE.qryLane.DisableControls();
    found := CORE.qryHeat.Locate('HeatID', HeatID, SearchOptions);
    if found then
    begin
      CORE.qryLane.ApplyMaster; // Required.
      for obj in AryEntrants do
      begin
        if obj.HeatNum <> HeatNum then continue;
        begin
          found := CORE.qryLane.Locate('LaneNum', obj.LaneNum, SearchOptions);
          if found then
          begin
            try
              CORE.qryLane.Edit;
              {
              if uEvent.EventType = scmTEAM then
              begin
                CORE.qryLane.FieldByName('TeamID').AsInteger := obj.TeamID;
              end
              else
              }
              CORE.qryLane.FieldByName('NomineeID').AsInteger := obj.NomineeID;
              CORE.qryLane.Post;
              INC(Count, 1);
            except on E: Exception do
                CORE.qryLane.Cancel;
            end;
          end;
        end;
      end;
    end;

  finally
    if Count > 0 then result := Count;
    // CORE.qryLane.ApplyMaster; // Assert: is this required?
    CORE.qryLane.EnableControls();

    if not CORE.qrySplitTime.IsEmpty then // avoid exception error.
      CORE.qrySplitTime.ApplyMaster;
    if not CORE.qryWatchTime.IsEmpty then // avoid exception error.
      CORE.qryWatchTime.ApplyMaster;
    CORE.qrySplitTime.EnableControls;
    CORE.qryWatchTime.EnableControls;
  end;
end;

function TABINDV.Build_Heats(NumOfHeats, NumOfNominees: Integer): integer;
var
  LanesFilled: Integer;
  HeatID: Integer;
  I: Integer;
begin
  result := 0;
  LanesFilled := 0;
  // Slowest heat (swimmers) first - fastest heat (swimmers) last.
  for I := (NumOfHeats) downto 1 do
  begin
    HeatID := uHeat.NewHeat;
    if HeatID > 0 then
    begin
      LanesFilled := LanesFilled + Build_FillLanes(HeatID, I);
    end;
  end;
  if LanesFilled > 0 then Result := LanesFilled;
end;

function TABINDV.CalcNumberOfHeats(NumOfNominees, RealNumOfLanes: Integer):
    Integer;
var
NumOfHeats: integer;
begin
  Result := 0;
  if NumOfNominees <= 0 then exit;
  Result := 1;
  // Calculate the number of heats in each event.
  if (numOfNominees > RealNumOfLanes) then
  begin
    NumOfHeats :=
      Ceil(double(numOfNominees) / double(RealNumOfLanes));
    Result := NumOfHeats;
  end;
end;

procedure TABINDV.ClearAllAryDivisions;
var
  I: integer;
begin
  if Length(AryDivisionsSCM) > 0 then
  begin
    for I := LOW(AryDivisionsSCM) to HIGH(AryDivisionsSCM) do
      AryDivisionsSCM[I].Free;
    SetLength(AryDivisionsSCM, 0);
  end;
  if Length(AryDivisionsMixed) > 0 then
  begin
    for I := LOW(AryDivisionsMixed) to HIGH(AryDivisionsMixed) do
      AryDivisionsMixed[I].Free;
    SetLength(AryDivisionsMixed, 0);
  end;
  if Length(AryDivisionsFemale) > 0 then
  begin
    for I := LOW(AryDivisionsFemale) to HIGH(AryDivisionsFemale) do
      AryDivisionsFemale[I].Free;
    SetLength(AryDivisionsFemale, 0);
  end;
  if Length(AryDivisionsMale) > 0 then
  begin
    for I := LOW(AryDivisionsMale) to HIGH(AryDivisionsMale) do
      AryDivisionsMale[I].Free;
    SetLength(AryDivisionsMale, 0);
  end;
end;

procedure TABINDV.ClearAryEntrants;
var
  I: integer;
begin
  if Length(AryEntrants) > 0 then
  begin
    for I := LOW(AryEntrants) to HIGH(AryEntrants) do
      AryEntrants[I].Free;
    SetLength(AryEntrants, 0);
  end;
end;

{ TABINDV }

function TABINDV.Prepare(AConnection: TFDConnection; EventID: Integer; Verbose:
    boolean = false): Boolean;
begin
  // Attach auto-create data module to connection and activate.
  Result := false;
  fConnection := nil;
  fEventID := EventID;
  if Assigned(AConnection) then
  begin
    ABData.ActivateData;
    if ABData.IsActive then
    begin
      Result := true;
      fConnection := AConnection;
    end;
  end;
end;


function TABINDV.Seed_Circle(NumOfHeats, SeedDepth: Integer): Integer;
var
  I, J, HeatNum, LaneNum, NumOfEntrants: Integer;
  HeatOffset, TryHeat: Integer;
  LaneCounts: array of Integer;
  Found: boolean;
  msg: string;
begin
  Result := 0;
  NumOfEntrants := 0;
  { PARAMS::
    StartHeatNum : heat number to start seeding
    NumOfHeats : Total number of heats - Ceil(Entrants / lanes in swimming pool)
    SeedDepth : Number of heats to fill using circle seeding.
  }

  // Validation:
  if (SeedDepth <= 0) or (Length(AryEntrants) = 0)
      or (Length(AryEntrantsPerHeat) =  0) then
    Exit;

  // Rules used by SwimClubMeet meet manager:
  if (SeedDepth > NumOfHeats) or (SeedDepth = 0)  then
    SeedDepth := NumOfHeats;

  // Ensure swimmers are sorted fastest to slowest
  if not (fSortMode = scmABSortMode.abTTB) then
    SortAryEntrantsByTTB;

  // Standard circle seeding: Fastest swimmers distributed across heats
  // For example: 3 heats, 8 swimmers , StartHeatNum=12, SeedDepth=3,
  // NumOfHeats = CalcNumberOfHeats(Length(AryEntrants),  RealNumOfLanes).
  // Note: NumOfHeats can exceed SeedDepth...
  // Heat 12: Lanes 1,4,7
  // Heat 13: Lanes 2,5,8
  // Heat 14: Lanes 3,6

  {
  NOTES:
    AryEntrantsPerHeat correctly scatters the number of swimmers that can go
    into a heat after considering the REAL number of lanes available in
    the swimming pool.
  }

  // Calc the total number of lane entrants needed.
  for I := 0 to Length(AryEntrantsPerHeat) - 1 do
  begin
    if I = SeedDepth then break;
    NumOfEntrants := NumOfEntrants + AryEntrantsPerHeat[I];
  end;

  // Initialize lane counters for each heat
  SetLength(LaneCounts, SeedDepth);
  for I := 0 to SeedDepth - 1 do
    LaneCounts[I] := 0;


  for I := 0 to Length(AryEntrants)  - 1 do
  begin

    // Validate: if only a select number of heats are to be cicle seeded.
    if I = NumOfEntrants then break;

    // Calculate which heat this swimmer goes to (circle method)
    HeatOffset := I mod SeedDepth;
    Found := False;

    for J := 0 to SeedDepth - 1 do
    begin
      TryHeat := (HeatOffset + J) mod SeedDepth;
      if LaneCounts[TryHeat] < AryEntrantsPerHeat[TryHeat] then
      begin
        HeatNum := TryHeat + 1;
        LaneNum := LaneCounts[TryHeat] + 1;

        AryEntrants[I].HeatNum := HeatNum;
        AryEntrants[I].HeatRankNum := LaneNum;
        Inc(LaneCounts[TryHeat]);
        Inc(Result);
        Found := True;
        Break;
      end;
    end;

    // If no heat has space, skip (handled by default seeding)
    if not Found then
    begin
      if (fVerbose) then
      begin
        msg := '''
          Function "Circle_Seed" reported a problem:
          Failed to seed an entrant correctly.
          Unable to find an empty lane for the given seed depth.
          The entrant will be seeded using the Default_Seed routine.
          ''';
        MessageDlg(msg, mtWarning, [mbOK], 0, mbOK);
      end;
      // Optionally log or track unseeded count
      Continue;
    end;
  end;

  { Next functions called after this circle seed.
    1. Use a 'default seeding' for the remaining entrants that were not seeded here.
    2. Using the HeatRankNum, scatter the entrants assigned in heat to the correct
        swimming lane.
        ie. Fastest swimmer (HeatRankNum =1) in each heat, swims in lane 4.
   }

end;

function TABINDV.Seed_Default(NumOfHeats: Integer; Offset: Integer = 0):
    Integer;
var
  I, J, indx: Integer;
  EntrantsCountPerHeat: array of Integer;
begin
  Result := 0;
  indx := 0;
  // Validation
  if (NumOfHeats <= 0) or (Length(AryEntrants) = 0)
    or (Length(AryEntrantsPerHeat) =  0) then
    Exit;

  // Ensure swimmers are sorted fastest to slowest
  if not (fSortMode = scmABSortMode.abTTB) then
    SortAryEntrantsByTTB;

  // Initialize lane counters for each heat
  SetLength(EntrantsCountPerHeat, NumOfHeats);
  for I := 0 to NumOfHeats - 1 do
    EntrantsCountPerHeat[I] := 0;

  for J := 0 to NumOfHeats - 1 do
  begin
    for I := indx to Length(AryEntrants) - 1 do
    begin
      // if circle seed preceeds this function then
      // skip lane entrants that have already been processed.
      if (AryEntrants[I].HeatNum > 0) then
        continue;

      if EntrantsCountPerHeat[J] < AryEntrantsPerHeat[J] then
      begin
        // if circle seed preceeds this function then offset =
        //  number of heats already seeded.
        AryEntrants[I].HeatNum := J + 1 + Offset;
        AryEntrants[I].HeatRankNum := EntrantsCountPerHeat[J] + 1;
        Inc(EntrantsCountPerHeat[J]);
        Inc(Result);
      end
      else
      begin
        indx := I;  // inti offset into lane entrants.
        break;   // move to next heat
      end;
    end;
  end;

end;

function TABINDV.Seed_Random(NumOfHeats: Integer): Integer;
var
  I, J, indx: integer;
  EntrantsCountPerHeat: array of Integer;
begin
  Result := 0;
  indx := 0;
  // Validation
  if (NumOfHeats <= 0) or (Length(AryEntrants) = 0)
    or (Length(AryEntrantsPerHeat) =  0) then
    Exit;

  // Ensure swimmers are sorted RANDOM.
  if not (fSortMode = scmABSortMode.abRandom) then
    SortAryEntrantsByRandom;

  // Initialize lane counters for each heat
  SetLength(EntrantsCountPerHeat, NumOfHeats);

  for I := 0 to NumOfHeats - 1 do
    EntrantsCountPerHeat[I] := 0;

  for J := 0 to NumOfHeats - 1 do
  begin
    for I := indx to Length(AryEntrants) - 1 do
    begin
      if EntrantsCountPerHeat[J] < AryEntrantsPerHeat[J] then
      begin
        AryEntrants[I].HeatNum := J + 1;
        AryEntrants[I].HeatRankNum := EntrantsCountPerHeat[J] + 1;
        Inc(EntrantsCountPerHeat[J]);
        Inc(Result);
      end
      else
      begin
        indx := I;  // inti offset into lane entrants.
        break;   // move to next heat
      end;
    end;
  end;

end;

procedure TABINDV.SortAryEntrantsByRandom;
var
  I, J: Integer;
  Temp: TLaneEntrant;
begin
  // Simple bubble sort - replace with better algorithm for production
  for I := 0 to Length(AryEntrants) - 2 do
    for J := I + 1 to Length(AryEntrants) - 1 do
      if AryEntrants[I].RandomNum > AryEntrants[J].RandomNum then
      begin
        Temp := AryEntrants[I];
        AryEntrants[I] := AryEntrants[J];
        AryEntrants[J] := Temp;
      end;
  fSortMode := abRandom;
end;

procedure TABINDV.SortAryEntrantsByTTB;
var
  I, J: Integer;
  Temp: TLaneEntrant;
begin
  // Simple bubble sort - replace with better algorithm for production
  for I := 0 to Length(AryEntrants) - 2 do
    for J := I + 1 to Length(AryEntrants) - 1 do
      if AryEntrants[I].TTB > AryEntrants[J].TTB then  // Assuming TTB property
      begin
        Temp := AryEntrants[I];
        AryEntrants[I] := AryEntrants[J];
        AryEntrants[J] := Temp;
      end;
  fSortMode := abTTB;
end;

{ TDivision }

constructor TDivision.Create;
begin
  StartAge := 0;
  EndAge := 0;
  GenderID := 0;
end;

destructor TDivision.Destroy;
begin
  ; // cleanup?
  inherited;
end;

end.
