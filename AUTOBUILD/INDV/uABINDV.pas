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

    indxX: integer;
    indxM: integer;
    indxF: integer;
    indxSCM: integer;

    function AryEntrants_AssignLaneNum(NumOfHeats: Integer): Integer;
    function AryEntrants_AssignNominees: integer;
    function AryEntrants_AssignHeatNum(NumOfHeats: Integer): integer;

    function AryExcludedLanes_Build: Integer;
    procedure AryScatterLanes_Build(NumOfPoolLanes: integer);
    function Build_EntrantsPerHeat(NumOfHeats: Integer; NumOfNominees: Integer):
        Integer;
    function Build_FillLanes(HeatID, HeatNum: Integer): Integer;
    function Build_Heats(NumOfHeats, NumOfNominees: Integer): integer;
    function CalcNumberOfHeats(NumOfNominees, RealNumOfLanes: Integer): Integer;
    procedure ClearAryEntrants;

    { Seed AryEntrants. }
    function Seed_Circle(NumOfHeats, SeedDepth: Integer): Integer;
    function Seed_Default(NumOfHeats: Integer; Offset: Integer = 0): Integer;
    function Seed_Random(NumOfHeats: Integer): Integer;

    { Sort AryEntrants.}
    procedure SortAryEntrantsByRandom;
    procedure SortAryEntrantsByTTB;

    function LOOP_Divisions(): integer;
    function LOOP_Entrants(NumOfEntrants: Integer): Integer;
    function LOOP_Gender(DivisionFilter: string; PK: Integer = 0): Integer;
    function GetDivisionFilter(GenderID: Integer = 0): string;

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
    AgeFrom: integer;
    AgeTo: integer;
    GenderID: integer;
    Caption: string;
    RangeCaption: string;
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
  count, I, DBNumOfNominees: integer;
begin
  result := false;
  count := 0;
  DBNumOfNominees := 0;

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
        DBNumOfNominees := ABData.qryUnplacedNominees.RecordCount;
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

  // Default filtering... sort on TTB.
  ABData.qryUnplacedNominees.IndexName := 'indxTTB';
  ABData.qryUnplacedNominees.Filter := '';
  ABData.qryUnplacedNominees.Filtered := false;


  ABData.qryDivision.Connection := SCM2.scmConnection;
  try
    abData.qryDivision.Open;
    if abData.qryDivision.Active then
    begin
      abData.qryDivision.IndexName := 'indxDiv';
      if not abData.qryDivision.Filtered then
        abData.qryDivision.Filtered := true;
    end;
  except
    on E: EFDDBEngineException do
    begin
      SCM2.FDGUIxErrorDialog.Execute(E);
      fError := true;
      fErrorNum := 1;
      exit;
    end;
  end;

  ABData.qryGender.Connection := SCM2.scmConnection;
  try
    ABData.qryGender.Open;
    if ABData.qryGender.Active then
    begin
      abData.qryGender.IndexName := 'indxDESC';
      if not abData.qryGender.Filtered then
        abData.qryGender.Filtered := true;
    end;
  except
    on E: EFDDBEngineException do
    begin
      SCM2.FDGUIxErrorDialog.Execute(E);
      fError := true;
      fErrorNum := 1;
      exit;
    end;
  end;

  count := LOOP_Divisions();

  if count > 0 then result := true;

end;

function TABINDV.LOOP_Divisions(): integer;
var
  GroupBy: scmGroupByType;
  NumOfEntrants: integer;
  DivisionFilter: string;
begin
  result := 0;
  NumOfEntrants := 0;
  DivisionFilter := '';
  GroupBy := scmGroupByType(Settings.ab_GroupByIndx);

  case GroupBy of
    agNone:
      NumOfEntrants := LOOP_Gender(DivisionFilter);
    agCustom:
    begin
      if Settings.ab_SeperateGender = false then
      begin
        abData.qryDivision.IndexName := 'indxCustMixed';
        if not abData.qryDivision.Filtered then
          abData.qryDivision.Filtered := true;
        while not abData.qryDivision.EOF do
        begin
          divisionFilter := '(Age >= '
          + IntToStr(abData.qryDivision.FieldByName('AgeFrom').AsInteger)
          + ') AND (Age <= '
          + IntToStr(abData.qryDivision.FieldByName('.AgeTo').AsInteger)
          + ')' ;
          NumOfEntrants := LOOP_Gender(DivisionFilter);
          abData.qryDivision.NEXT;
        end;
      end
      else
      begin
        // special case  ....
      end;
    end;
    agSCM:
      begin
        abData.qryDivision.IndexName := 'indxSCM';
        if not abData.qryDivision.Filtered then
          abData.qryDivision.Filtered := true;
        while not abData.qryDivision.EOF do
        begin
          divisionFilter := '(Age >= '
          + IntToStr(abData.qryDivision.FieldByName('AgeFrom').AsInteger)
          + ') AND (Age <= '
          + IntToStr(abData.qryDivision.FieldByName('.AgeTo').AsInteger)
          + ')' ;
          NumOfEntrants := LOOP_Gender(DivisionFilter);
          abData.qryDivision.NEXT;
        end;
      end;
  end;

end;

function TABINDV.LOOP_Gender(DivisionFilter: string; PK: Integer = 0): Integer;
var
  count: Integer;
  FilterStr: string;
  GenderID: Integer;
  GroupByType: scmGroupByType;
  msg: string;
  NumOfEntrants: Integer;
begin
  result := 0;
  GroupByType := scmGroupByType(Settings.ab_GroupByIndx);

  // -----------------------------------------------------
  // ENABLED ... SEPERATE BY GENDER ...ENABLED.
  // -----------------------------------------------------
  if Settings.ab_SeperateGender then
  begin
    count := 0;
    // NOTE active index sorts reverse order, (X, F, M).
    ABData.qryGender.first;

    while not ABData.qryGender.BOF do
    // iterate across Mixed, Female, Male (in that order)...
    begin
      GenderID := ABData.qryGender.FieldByName('GenderID').AsInteger;
      FilterStr := 'GenderID = ' + IntToStr(GenderID);

      // SPECIAL CASE.... CUSTOM DIVISIONS MALE/FEMALE
      if (Settings.ab_GroupByIndx = ORD(agCustom)) and (PK > 0) then
      begin
        case GenderID of
          1: //MALE
          begin
            abData.qryDivision.IndexName := 'indxCustMale';
            if not abData.qryDivision.Filtered then
              abData.qryDivision.Filtered := true;
          end;
          2: // FEMALE
          begin
            abData.qryDivision.IndexName := 'indxCustFemale';
            if not abData.qryDivision.Filtered then
              abData.qryDivision.Filtered := true;
          end;
        end;
        if abData.qryDivision.Locate(IntToStr(PK), 'DivisionID') then
        begin
          divisionFilter := '(Age >= '
          + IntToStr(abData.qryDivision.FieldByName('AgeFrom').AsInteger)
          + ') AND (Age <= '
          + IntToStr(abData.qryDivision.FieldByName('.AgeTo').AsInteger)
          + ')' ;
        end;
      end;

      if Length(DivisionFilter) > 0 then
        FilterStr := FilterStr + ' AND ' + DivisionFilter;

      // ASSIGN and TURN FILTERING ON....
      ABData.qryUnplacedNominees.Filter := FilterStr;
      if not ABData.qryUnplacedNominees.Filtered then
        ABData.qryUnplacedNominees.Filtered := true;

      // after all filters are applied - get the number of unplaced nominees.
      NumOfEntrants := ABData.qryUnplacedNominees.RecordCount;

      if NumOfEntrants > 0 then
        count := count + LOOP_Entrants(NumOfEntrants);

      ABData.qryGender.Next; // next gender...
    end;
  end

  else

  // -----------------------------------------------------
  // DO NOT SEPERATE GENDER - HEATS ARE MIXED...
  // -----------------------------------------------------
  begin
    if Length(DivisionFilter) > 0 then
    begin
      // ASSIGN and TURN FILTERING ON....
      ABData.qryUnplacedNominees.Filter := DivisionFilter;
      if not ABData.qryUnplacedNominees.Filtered then
        ABData.qryUnplacedNominees.Filtered := true;
    end
    else
      ABData.qryUnplacedNominees.Filtered := false;

    // ABData.qryUnplacedNominees.Refresh;

    // after all filters are applied - get the number of unplaced nominees.
    NumOfEntrants := ABData.qryUnplacedNominees.RecordCount;

    if (NumOfEntrants > 0) then
      count := LOOP_Entrants(NumOfEntrants);

    if (count > 0) then
      result := count;
    end;
end;

function TABINDV.LOOP_Entrants(NumOfEntrants: Integer): Integer;
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

  if count <> 0 then
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
  I, AgeFrom, AgeTo: Integer;
begin
  result := 0;
  LanesFilled := 0;

  // Slowest heat (swimmers) first - fastest heat (swimmers) last.
  for I := (NumOfHeats) downto 1 do
  begin
    HeatID := uHeat.NewHeat;
    if HeatID > 0 then
    begin
      // Groupby Division is enabled....
      if (Settings.ab_GroupByIndx <> 0)  then
      begin
        CORE.qryHeat.Edit;
        AgeFrom := abData.qryDivision.FieldByName('AgeFrom').AsInteger;
        AgeTo := abData.qryDivision.FieldByName('AgeTo').AsInteger;
        CORE.qryHeat.FieldByName('Caption').AsString :=
          abData.qryDivision.FieldByName('Caption').AsString;
        CORE.qryHeat.FieldByName('AgeFrom').AsInteger :=
          abData.qryDivision.FieldByName('AgeFrom').AsInteger;
        CORE.qryHeat.FieldByName('AgeTo').AsInteger :=
          abData.qryDivision.FieldByName('AgeTo').AsInteger;

        if (AgeFrom = 0) and (AgeTo <> 0) then
          CORE.qryHeat.FieldByName('RangeCaption').AsString :=
          IntToStr(AgeFrom) + '& Under'
        else if AgeTo = 999 then
          CORE.qryHeat.FieldByName('RangeCaption').AsString := 'Open'
        else
        CORE.qryHeat.FieldByName('RangeCaption').AsString :=
        '(' + IntToStr(AgeFrom) + '-' + IntToStr(AgeTo) + ')';

        if Settings.ab_SeperateGender then
          CORE.qryHeat.FieldByName('Gender').AsInteger :=
            abData.qryGender.FieldByName('GenderID').AsInteger;


        CORE.qryHeat.Post;
      end;

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
  AgeFrom := 0;
  AgeTo := 0;
  GenderID := 0;
end;

destructor TDivision.Destroy;
begin
  ; // cleanup?
  inherited;
end;

end.
