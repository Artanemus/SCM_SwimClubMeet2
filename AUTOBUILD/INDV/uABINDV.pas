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
  scmABSortMode = (abNotSorted, abTime, abRandom);

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
    fVerbose: boolean;
    fSortMode: scmABSortMode;
    function AryEntrants_AssignEventRankNum: integer;
    function AryEntrants_AssignLaneNum(StartHeatNum, NumOfHeats: Integer): integer;
    function AryEntrants_AssignHeatRankNum(StartHeatNum, NumOfHeats: Integer):
        integer;
    function AryEntrants_AssignNominees: integer;
    function AryEntrants_HeatNum(StartHeatNum, NumOfHeats: Integer): integer;
    function AryExcludedLanes_Build: Integer;
    procedure AryScatterLanes_Build(NumOfPoolLanes: integer);
    function Build_Entrants(NumOfHeats, StartHeatNum, NumOfNominees: Integer):
        Integer;
    { main execution routine. }

    function Build_EntrantsPerHeat(NumOfHeats: Integer; NumOfNominees: Integer):
        Integer;
    function Build_Heats(NumOfHeats, StartHeatNum, NumOfNominees: Integer): integer;
    function Build_FillLanes(HeatID: Integer): Integer;
    function CalcNumberOfHeats(NumOfNominees, RealNumOfLanes: Integer): Integer;
    procedure ClearAryEntrants;
    function Entrants_AssignLaneNum(StartHeatNum, Count: Integer): Integer;
    { Seeding routine. }
    function Seeding_Circle(StartHeatNum, NumOfHeats, SeedDepth: Integer): Integer;
    function Seeding_Default(StartHeatNum, NumOfHeats: Integer): Integer;
    function Seeding_Random(StartHeatNum, NumOfHeats: Integer): Integer;
    procedure SortAryEntrantsByRandom;
    procedure SortAryEntrantsByTime;
    function TestExcludedLane(LaneNum: integer): Boolean;
    function TestIsHeatFull(HeatNum: integer): boolean;
    function TestLaneIsFilled(HeatNum, LaneNum: integer): boolean;
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
    function AutoBuildExec: Boolean;
    function Prepare(AConnection: TFDConnection; EventID: Integer; Verbose: boolean
        = false): Boolean;
  end;

  TLaneEntrant = class(TObject)
    NomineeID: integer;
    EventRankNum: integer;
    HeatRankNum: integer;
    HeatNum: integer;
    LaneNum: integer;
    RandomNum: integer;
    TTB: TTime;
    constructor Create();
    destructor Destroy; override;
  end;

implementation

{ TLaneEntrant }

constructor TLaneEntrant.Create;
begin
  NomineeID := 0;
  EventRankNum := 0;
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

function TABINDV.AryEntrants_AssignEventRankNum: integer;
var
  I: integer;
begin
  result := 0;
  if not (fSortMode = scmABSortMode.abTime) then
    SortAryEntrantsByTime;
  for I := 0 to Length(AryEntrants) - 1 do
  begin
    AryEntrants[I].EventRankNum := I + 1;
    INC(result);
  end;
end;

function TABINDV.AryEntrants_AssignLaneNum(StartHeatNum, NumOfHeats: Integer):
integer;
var
  err, I, J, LaneNum, Rank, offset: integer;
  found: boolean;
  msg: string;
begin
  result := 0;
  err := 0;
  // Note: AryEntrants sorted by time...
  for J := StartHeatNum to NumOfHeats - 1 do
  begin
    offset := 0; // reset with each heat.
    for I := 0 to Length(AryEntrants) - 1 do
    begin
      found := false;
      if AryEntrants[I].HeatNum <> J then continue;
      Rank := AryEntrants[I].HeatRankNum;
      While not found and ((Rank+Offset) > 0) and ((Rank+Offset) <= fNumOfPoolLanes) do
      begin
        LaneNum := AryScatteredLanes[Rank+Offset];
        if not AryExcludedLanes[LaneNum] then
        begin
          AryEntrants[I].LaneNum := LaneNum;
          found := true;
        end
        else
        begin
          INC(Offset); // bump up ranking..
        end;
      end;
    end;
  end;

  if err > 0 then
  begin
    if (fVerbose) then
    begin
      msg := '''
        Internal error... (AryEntrants_AssignLaneNum)
        Failed to assign a swimming lane for entrant.
      ''';
      MessageDlg(msg, mtError, [mbOK], 0, mbOK);
    end;
  end;

end;

function TABINDV.AryEntrants_AssignHeatRankNum(StartHeatNum, NumOfHeats:
    Integer): integer;
var
  count, I, J, HeatRankNum: integer;
begin
  result := 0;
  count := 0;
  // CHECK: sorted by time.
  if fSortMode <> abTime then
    SortAryEntrantsByTime;

  for J := StartHeatNum to NumOfHeats do
  begin
    HeatRankNum := 1;
    for I := 0 to Length(AryEntrants) - 1 do
    begin
      if AryEntrants[I].HeatNum <> J then continue;
      AryEntrants[I].HeatRankNum := HeatRankNum;
      INC(HeatRankNum);
      INC(Count);
    end
  end;
  if Count > 0 then
    result := Count;
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
    AryEntrants := AryEntrants + [obj]; // append to array.
    INC(Count, 1);
    ABData.qryUnplacedNominees.Next;
  end;
  if Count > 0 then result := Count;
end;

function TABINDV.AryEntrants_HeatNum(StartHeatNum, NumOfHeats: Integer):
    integer;
var
  SeedDepth: integer;
  HeatNum: integer;
  NumOfHeatsSeeded: integer;
begin
  result := 0;
  SeedDepth := Settings.ab_SeedDepth;
  NumOfHeatsSeeded := 0;
  if SeedDepth = 0 then
    SeedDepth := NumOfHeats;

  case Settings.ab_SeedMethodIndx of
    0:
      begin
        {  STANDARD SEEDING.}
        NumOfHeatsSeeded := Seeding_Default(StartHeatNum, NumOfHeats);
      end;
    1:
      begin
        {CIRCLE SEEDING.}
        NumOfHeatsSeeded := Seeding_Circle(StartHeatNum, NumOfHeats, SeedDepth);
        {DEFAULT SEEDING.}
        if (NumOfHeatsSeeded < NumOfHeats) then
        begin
          HeatNum := StartHeatNum + NumOfHeatsSeeded;
          { do the remaining heats using STANDARD SEEDING.}
          NumOfHeatsSeeded := Seeding_Default(HeatNum, NumOfHeats);
        end;
      end;
    2:
      begin
        NumOfHeatsSeeded := Seeding_Random(StartHeatNum, NumOfHeats);
      end;
  end;
  if NumOfHeatsSeeded > 0 then result := NumOfHeatsSeeded;
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
//          Insert(LaneNum, AryExcludedLanes, 0);
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
  StartHeatNum, NomineeCount, NumOfHeats, count: integer;
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
    ABData.procDeleteHeats.Connection := SCM2.scmConnection;
    ABData.procDeleteHeats.StoredProcName := 'DeleteAllHeats';
    ABData.procDeleteHeats.ParamByName('@EventID').AsInteger := uEvent.PK;
    ABData.procDeleteHeats.ParamByName('@Exclude').AsBoolean := true;
    ABData.procDeleteHeats.Prepare;
    ABData.procDeleteHeats.ExecProc;
  end;

  // RENUMBER HEATS.
  if not CORE.qryHeat.IsEmpty then
  begin
    ABData.procRenumberHeats.Connection := SCM2.scmConnection;
    ABData.procRenumberHeats.StoredProcName := 'RenumberHeats';
    ABData.procRenumberHeats.ParamByName('@EventID').AsInteger := uEvent.PK;
    ABData.procRenumberHeats.Prepare;
    ABData.procRenumberHeats.ExecProc;
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

  ABData.qryUnplacedNominees.IndexName := 'indxPK';
  ABData.qryUnplacedNominees.Filter := '';
  ABData.qryUnplacedNominees.Filtered := false;

  if (ABData.qryUnplacedNominees.IsEmpty) then
  begin
    if (fVerbose) then
    begin
      msg := '''
        Unswum heats have been cleared.
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

  StartHeatNum := uHeat.LastHeatNum + 1;

  if not (fSortMode = scmABSortMode.abTime) then
    SortAryEntrantsByTime(); // fastest to slowest....

  // *********************************************
  // B A S I C   A u t o - B u i l d . (NO GROUPING)
  // Seperate gender setting - managed.
  // *********************************************
  if (Settings.ab_GroupByIndx <= 0) then
  begin
    ABData.qryUnplacedNominees.IndexName := 'indxTTB';
    if ABData.qryUnplacedNominees.Filtered then
      ABData.qryUnplacedNominees.Filtered := false;


    NomineeCount := ABData.qryUnplacedNominees.RecordCount;
    if NomineeCount = 0 then
    begin
      if (fVerbose) then
      begin
        msg := '''
          Unswum heats have been cleared.
          After excluding entrants in closed and raced heats,
          and applying the basic auto-build filters...
          all outstanding nominees have been given a lane.
          Auto-Build will exit.
          ''';
        MessageDlg(msg, mtError, [mbOK], 0, mbOK);
      end;
      fError := false;
      fErrorNum := 0;
      result := true;
      exit;
    end;


    // GENDER LOOP START ....
    // for each gender - run filter....
    // StartHeatNum := uHeat.LastHeatNum + 1;
    // NomineeCount := ABData.qryUnplacedNominees.RecordCount;
    // if NomineeCount = 0 continue

    {
        ABData.qryGender.Connection := SCM2.scmConnection;
    ABData.qryGender.Open;
    if ABData.qryGender.Active then
    begin
      ABData.qryGender.Last; // reverse order, female then male swimmers.
      while not ABData.qryGender.EOF do
      begin
        var id: integer;
        id := ABData.qryGender.FieldByName('GenderID').AsInteger;
        ABData.qryUnplacedNominees.Filter := 'GenderID = ' + IntToStr(id);
        if not ABData.qryUnplacedNominees.Filtered then
          ABData.qryUnplacedNominees.Filtered := true;
        ABData.qryUnplacedNominees.Refresh; // play it safe.
        // after filter is applied - get the number of unplaced nominees.
        NomineeCount := ABData.qryUnplacedNominees.RecordCount;
        count := Build_Entrants(NumOfHeats, StartHeatNum, NomineeCount);
        if count <> 0 then
          Build_Heats(NumOfHeats, StartHeatNum, NomineeCount); // build heats and lanes
      end;
    }

    // CALCULATE the number of heats needed to build.
    NumOfHeats := CalcNumberOfHeats(NomineeCount, fRealNumOfLanes);
    if NumOfHeats = 0 then
    begin
      if (fVerbose) then
      begin
        msg := '''
          Internal error...
          Calculate number of heats returned zero.
          Auto-Build will exit.
          ''';
        MessageDlg(msg, mtError, [mbOK], 0, mbOK);
      end;
      fError := true;
      fErrorNum := 1;
      result := false;
      exit;
    end;

    // construct the AryEntrants array with it's TLaneEntrant objects.
    // assign random number.
    count := AryEntrants_AssignNominees();
    if count <> NomineeCount then
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
      result := false;
      exit;
    end;

    count := AryEntrants_AssignEventRankNum();
    if count <> NomineeCount then
    begin
      if (fVerbose) then
      begin
        msg := '''
          Internal error...
          Failed to assign all entrants with Event Ranking.
          Auto-Build will exit.
          ''';
        MessageDlg(msg, mtError, [mbOK], 0, mbOK);
      end;
      fError := true;
      fErrorNum := 1;
      result := false;
      exit;
    end;

    // how many entrants per heat with consideration to fRealNumOfLanes.
    // TODO: set weights to first or last heat?
    count := Build_EntrantsPerHeat(NumOfHeats, NomineeCount);
    if count <> NomineeCount then
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
      result := false;
      exit;
    end;

    // SEED : Assign each entrant to a heat and assign a HeatRankNum.
    count := AryEntrants_HeatNum(StartHeatNum, NumOfHeats);
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
      result := false;
      exit;
    end;

    // Assign a swimming lane to each entrant based on heat ranking,
    // taking into account lane scattering and excluded lanes.
    count := Entrants_AssignLaneNum(StartHeatNum, NumOfHeats);
    if count = 0 then
    begin
      if (fVerbose) then
      begin
        msg := '''
          Internal error...
          Failed to assign a swimming lanes to entrants.
          Auto-Build will exit.
          ''';
        MessageDlg(msg, mtError, [mbOK], 0, mbOK);
      end;
      fError := true;
      fErrorNum := 1;
      result := false;
      exit;
    end;

    // FINALLY : create heats and lanes in the SwimClubMeet2 database.
    count := Build_Heats(NumOfHeats, StartHeatNum, NomineeCount);
    if count = 0 then
    begin
      if (fVerbose) then
      begin
        msg := '''
          Internal error...
          Unable to create the heats.
          Auto-Build will exit.
          ''';
        MessageDlg(msg, mtError, [mbOK], 0, mbOK);
      end;
      fError := true;
      fErrorNum := 1;
      result := false;
      exit;
    end;

    // GENDER LOOP END...

    // **** S U C C E S S *****
    result := true;
    // ************************
    exit;
  end;

  // *********************************************
  // FILTER BY GENDER   A u t o - B u i l d .
  // *********************************************
  if (Settings.ab_SeperateGender = true)
  and (Settings.ab_GroupByIndx <= 0) then
  begin
    StartHeatNum := 1;
    NumOfHeats := 0;
    ABData.qryUnplacedNominees.IndexName := 'indxTTB';
    if not ABData.qryUnplacedNominees.Filtered then
      ABData.qryUnplacedNominees.Filtered := false;

    ABData.qryGender.Connection := SCM2.scmConnection;
    ABData.qryGender.Open;
    if ABData.qryGender.Active then
    begin
      ABData.qryGender.Last; // reverse order, female then male swimmers.
      while not ABData.qryGender.EOF do
      begin
        var id: integer;
        id := ABData.qryGender.FieldByName('GenderID').AsInteger;
        ABData.qryUnplacedNominees.Filter := 'GenderID = ' + IntToStr(id);
        if not ABData.qryUnplacedNominees.Filtered then
          ABData.qryUnplacedNominees.Filtered := true;
        ABData.qryUnplacedNominees.Refresh; // play it safe.
        // after filter is applied - get the number of unplaced nominees.
        NomineeCount := ABData.qryUnplacedNominees.RecordCount;
        count := Build_Entrants(NumOfHeats, StartHeatNum, NomineeCount);
        if count <> 0 then
          Build_Heats(NumOfHeats, StartHeatNum, NomineeCount); // build heats and lanes
      end;
    end;
  end;



  // *******************************************************
  result := true;
  // *******************************************************

end;

function TABINDV.Build_Entrants(NumOfHeats, StartHeatNum,
  NumOfNominees: Integer): Integer;
begin
  ; //todo
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

function TABINDV.Build_Heats(NumOfHeats, StartHeatNum, NumOfNominees: Integer):
    integer;
var
  Count: Integer;
  HeatID: Integer;
  HeatNum: Integer;
  I: Integer;
begin
  result := 0;
  Count := 0;
  for I := 0 to NumOfHeats-1 do
  begin
    HeatID := uHeat.NewHeat;
    if HeatID > 0 then
      Count := Build_FillLanes(HeatID);
  end;
  if Count > 0 then Result := Count;
end;

function TABINDV.Build_FillLanes(HeatID: Integer): Integer;
var
  Count: integer;
  obj: TLaneEntrant;
  SearchOptions: TLocateOptions;
begin
  result := 0;
  Count := 0;
  SearchOptions := [];
  try
    CORE.qrySplitTime.DisableControls;
    CORE.qryWatchTime.DisableControls;
    CORE.qryLane.DisableControls();
    if CORE.qryHeat.Locate('HeatID', HeatID, SearchOptions) then
    begin
      CORE.qryLane.ApplyMaster; // syncro.
      for obj in AryEntrants do
      begin
        if obj.HeatNum <> Core.qryHeat.FieldByName('HeatNum').AsInteger then continue;
        begin
          if CORE.qryLane.Locate('LaneNum', obj.LaneNum, SearchOptions) then
          begin
            try
              CORE.qryLane.Edit;
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
    CORE.qryLane.ApplyMaster;
    CORE.qryLane.EnableControls();
    CORE.qrySplitTime.ApplyMaster;
    CORE.qryWatchTime.ApplyMaster;
    CORE.qrySplitTime.EnableControls;
    CORE.qryWatchTime.EnableControls;
  end;
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



function TABINDV.Entrants_AssignLaneNum(StartHeatNum, Count: Integer): Integer;
var
  I, J, RankOffset, Rank, laneNum, EntrantCount: integer;
  obj: TLaneEntrant;
  found: boolean;
begin
  { Acll here after assigning HeatNum, NomineeID and RankNum.
    How rank works...
    Rank order of the swimmer. ie. 1st, 2nd, 3rd, etc.
    Fast swimmers have a lower value.}
  result := 0;
  if fSortMode <> abTime then
    SortAryEntrantsByTime;

  for J := StartHeatNum to Count do // iterate over heats.
  begin
    RankOffset := 0; // rankoffest is used to skip user-excluded lanes.
    EntrantCount := 0; // used to test if heat has been processed.

    for I := 0 to Length(AryEntrants) - 1 do // Fastest swimmer always at head of array.
    begin
      // Has all the entrants been assigned a lane for the given heat?
      if (EntrantCount >= AryEntrantsPerHeat[J-1]) then break;

      obj := AryEntrants[i];
      if (obj.HeatNum <> J) then continue;  // wrong heat number.

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
      end
      else
        {TODO -oBSA -cGeneral : ERROR -Entrant never got a lane in chosen heat.}
        obj.LaneNum := 0;

      INC(EntrantCount);

    end;

    if I > 0 then result := I;  // number of heats

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

function TABINDV.Seeding_Circle(StartHeatNum, NumOfHeats, SeedDepth: Integer):
    Integer;
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
  if not (fSortMode = scmABSortMode.abTime) then
    SortAryEntrantsByTime;

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
        HeatNum := StartHeatNum + TryHeat;
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

function TABINDV.Seeding_Default(StartHeatNum, NumOfHeats: Integer): Integer;
var
  I, J, indx: Integer;
  LaneCounts: array of Integer;

begin
  Result := 0;
  indx := 0;
  // Validation
  if (NumOfHeats <= 0) or (Length(AryEntrants) = 0)
    or (Length(AryEntrantsPerHeat) =  0) then
    Exit;
  // Ensure swimmers are sorted fastest to slowest
  if not (fSortMode = scmABSortMode.abTime) then
    SortAryEntrantsByTime;

  // Initialize lane counters for each heat
  SetLength(LaneCounts, NumOfHeats);
  for I := 0 to NumOfHeats - 1 do
    LaneCounts[I] := 0;

  for J := 0 to NumOfHeats - 1 do
  begin
    for I := indx to Length(AryEntrants) - 1 do
    begin
      // if circle seed preceeds this function then
      // skip lane entrants that have already been processed.
      if (AryEntrants[I].HeatNum > 0) then
        continue;

      if LaneCounts[J] < AryEntrantsPerHeat[J] then
      begin
        AryEntrants[I].HeatNum := StartHeatNum + J;
        AryEntrants[I].HeatRankNum := LaneCounts[J] + 1;
        Inc(LaneCounts[J]);
        Inc(Result);
      end
      else
      begin
        indx := I;  // inti offset into lane entrants.
        break;   // move to next heat
      end;
    end;
  end;

  if (J > 0) then Result := j; // Number of heats seeded.

end;

function TABINDV.Seeding_Random(StartHeatNum, NumOfHeats: Integer): Integer;
begin
  SortAryEntrantsByRandom;
  result := Seeding_Default(StartHeatNum, NumOfHeats);
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

procedure TABINDV.SortAryEntrantsByTime;
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
  fSortMode := abTime;
end;

function TABINDV.TestExcludedLane(LaneNum: integer): Boolean;
begin
  result := false;
  if (LaneNum > 0) and (LaneNum <= fNumOfPoolLanes) then
    result := AryExcludedLanes[LaneNum-1];
end;

function TABINDV.TestIsHeatFull(HeatNum: integer): boolean;
begin
  {is heatfull}
  result := true;
end;

function TABINDV.TestLaneIsFilled(HeatNum, LaneNum: integer): boolean;
var
  I: integer;
  obj: TLaneEntrant;
begin
  result := false;
  for I := 0 to Length(AryEntrants)-1 do
  begin
    obj := AryEntrants[I];
    if (obj.HeatNum = HeatNum) and (obj.LaneNum = LaneNum) then
    begin
      result := true;
      exit;
    end;
  end;
end;

end.
