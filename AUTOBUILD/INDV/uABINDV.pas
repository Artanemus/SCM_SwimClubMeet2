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

  TABINDV = class(TComponent)
  private
    ABData: TABINDV_Data;
    AryEntrants: Array of TLaneEntrant;
    AryEntrantsPerHeat: Array of Integer;
    AryExcludeLanes: Array of Integer;
    AryScatteredLanes: Array of Integer;
    fConnection: TFDConnection;
    fError: boolean;
    fErrorNum: integer;
    fEventID: Integer;
    fExcludeLaneCount: integer;
    fNumOfPoolLanes: integer;
    fRealNumOfLanes: integer;
    fVerbose: boolean;
    function AryEntrants_AssignNominees: integer;
    function AryEntrants_AssignLaneNum(NumOfHeats: Integer): integer;
    function AryEntrants_Seed(StartHeatNum, Count: Integer): integer;
    function AryExcludedLanes_Build: Integer;
    procedure AryScatterLanes_Build(NumOfPoolLanes: integer);
    function Build_Entrants(NumOfHeats, StartHeatNum, NumOfNominees: Integer):
        Integer;
    { main execution routine. }

    function Build_EntrantsPerHeat(NumOfHeats: Integer; NumOfNominees: Integer):
        Integer;
    function Build_Heats(NumOfHeats, StartHeatNum, NumOfNominees: Integer): integer;
    function Build_Lanes(HeatNum: Integer): Integer;
    function CalcNumberOfHeats(NumOfNominees, RealNumOfLanes: Integer): Integer;
    procedure ClearAryEntrants;
    function Entrants_AssignLaneNum(StartHeatNum, Count: Integer): Integer;
    procedure Entrants_AssignRanking(StartHeatNum, Count: Integer);
    { Seeding routine. }
    function Seeding_Circle(StartHeatNum, Count: Integer): Integer;
    function Seeding_Default(StartHeatNum, Count: Integer): Integer;
    function Seeding_Random(StartHeatNum, Count: Integer): Integer;
    procedure SortAryEntrantsByTime;
    procedure SortAryEntrantsByRandom;
    function TestExcludedLane(LaneNum: integer): Boolean;
    function TestIsHeatFull(HeatNum: integer): boolean;
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
    LaneRankNum: integer;
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
end;

function TABINDV.AryEntrants_AssignLaneNum(NumOfHeats: Integer): integer;
var
  obj: TLaneEntrant;
  Count, I, J, K: integer;
begin
  result := 0;
  count := 0;
  for K := Length(AryEntrants)-1 downto 0 do
  begin
    for I := NumOfHeats downto 1 do
    begin
      for J := 0 to Length(AryEntrantsPerHeat)-1 do
      begin

      end;

    end;
  end;


end;

function TABINDV.AryEntrants_AssignNominees: integer;
var
  obj: TLaneEntrant;
  Count, Rank: integer;
begin
  result := 0;
  count := 0;
  Rank := 1;
  ClearAryEntrants; // clears TLaneEntrant objects and SetLength = 0.
  // qryUnplacedNominees sorted fastest to slowest.
  ABData.qryUnplacedNominees.First;
  while not ABData.qryUnplacedNominees.EOF do
  begin // populate the AryEntrants...
    obj := TLaneEntrant.Create();
    obj.NomineeID :=
      ABData.qryUnplacedNominees.FieldByName('NomineeID').AsInteger;
    obj.RandomNum := Random(SizeOf(Int16)); // assign randomNum
    obj.EventRankNum := Rank;
    AryEntrants := AryEntrants + [obj]; // append to array.
    INC(Count, 1);
    INC(Rank, 1);
    ABData.qryUnplacedNominees.Next;
  end;
  if Count > 0 then result := Count;
end;

function TABINDV.AryEntrants_Seed(StartHeatNum, Count: Integer): integer;
var
  SeedDepth: integer;
  HeatNum: integer;
  NumOfHeatsSeeded: integer;
begin
  result := 0;
  SeedDepth := Settings.ab_SeedDepth;
  NumOfHeatsSeeded := 0;
  if SeedDepth = 0 then exit;

  case Settings.ab_SeedMethodIndx of
    0:
      begin
        {  STANDARD SEEDING.}
        NumOfHeatsSeeded := Seeding_Default(StartHeatNum, Count);
      end;
    1:
      begin
        {CIRCLE SEEDING.}
        NumOfHeatsSeeded := Seeding_Circle(StartHeatNum, Count);
        {DEFAULT SEEDING.}
        if (NumOfHeatsSeeded < Count) then
        begin
          HeatNum := StartHeatNum + NumOfHeatsSeeded;
          { do the remaining heats using STANDARD SEEDING.}
          NumOfHeatsSeeded := Seeding_Default(HeatNum, Count);
        end;
      end;
    2:
      begin
        NumOfHeatsSeeded := Seeding_Random(StartHeatNum, Count);
      end;
  end;
  if NumOfHeatsSeeded > 0 then result := NumOfHeatsSeeded;
end;

function TABINDV.AryExcludedLanes_Build: Integer;
var
  sa: TStringDynArray;
  LaneNum, J: integer;
  s: string;
begin
  // INIT:
  result := 0; // No exclude lanes.
  SetLength(AryExcludeLanes, 0);

  if Settings.ab_ExcludeLanes then
  begin
    sa := SplitString(Settings.ab_ListOfExcludeLanes, ',');
    for J := Low(sa) to High(sa) do
    begin
      s := Trim(sa[J]);
      If not s.IsEmpty then
      begin
        LaneNum := StrToIntDef(s, 0);
        if (LaneNum > 0) and (LaneNum <= uSwimClub.NumberOfLanes) then
          Insert(LaneNum, AryExcludeLanes, 0);
      end;
    end;
  end;

  if Length(AryExcludeLanes) > 0 then
    result := Length(AryExcludeLanes);

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
    fErrorNum := 2;
    exit;
  end;

  fNumOfPoolLanes := uSwimClub.NumberOfLanes;
  // PREPARE AryExcludeLanes.
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
    // assign random number and event ranking.
    count := AryEntrants_AssignNominees();
    if count = 0 then
    begin
      if (fVerbose) then
      begin
        msg := '''
          Internal error...
          The Entrants Array couldn't be built.
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
          Failed to distrubute entrants across heats.
          Auto-Build will exit.
          ''';
        MessageDlg(msg, mtError, [mbOK], 0, mbOK);
      end;
      fError := true;
      fErrorNum := 1;
      result := false;
      exit;
    end;

    // Assign seed each entrant.
    count := AryEntrants_Seed(StartHeatNum, NumOfHeats);
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

    // Assign a lane to each entrant based on ranking.
      // assign lane number.
    count := Entrants_AssignLaneNum(StartHeatNum, Count);
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



    // build heats and lanes
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

end;

function TABINDV.Build_EntrantsPerHeat(NumOfHeats: Integer; NumOfNominees: Integer): Integer;
var
  I, HeatIndex: Integer;
begin
  Result := 0;
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
    AryEntrantsPerHeat[HeatIndex] := AryEntrantsPerHeat[HeatIndex] + 1;
    HeatIndex := (HeatIndex + 1) mod NumOfHeats;
  end;
  Result := NumOfNominees;
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
    begin
      HeatNum := CORE.qryHeat.FieldByName('HeatNum').AsInteger;
      Count := Build_Lanes(HeatNum);
    end;
  end;
  if Count > 0 then Result := Count;
end;

function TABINDV.Build_Lanes(HeatNum: Integer): Integer;
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
    CORE.qryLane.ApplyMaster;

    for obj in AryEntrants do
    begin
      if obj.HeatNum = HeatNum then
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
  I, J, RankOffset, Rank, EntrantCount: integer;
  obj: TLaneEntrant;
begin
  { Acll here after assigning HeatNum, NomineeID and RankNum.
    How rank works...
    Rank order of the swimmer. ie. 1st, 2nd, 3rd, etc.
    Fast swimmers have a lower value.}
  result := 0;
  for J := StartHeatNum to Count-1 do // iterate on heat.
  begin
    RankOffset := 0; // rankoffest is used to skip user-excluded lanes.
    EntrantCount := 0; // used to test if heat has been processed.
    // Fastest swimmer always at heat of array.
    for I := 0 to Length(AryEntrants) - 1 do
    begin
      { Optimise : this statement can be ommitted. }
      // has all the entrants been assigned a lane for the given heat?
      if (EntrantCount >= AryEntrantsPerHeat[J]) then break;

      obj := AryEntrants[i];
      if (obj.HeatNum <> J) then continue;  // wrong heat number.

      Rank := obj.LaneRankNum + RankOffset;
      { Handle excluded lanes. Skipping lanes by lowing ranking.}
      While (Rank <= Length(AryScatteredLanes))  do
      begin
        if TestExcludedLane(AryScatteredLanes[Rank]) then
          INC(Rank,1)
        else
          break;
      end;
      { Look-up rank and return with lane number. Fastest swim in center of pool. }
      if (Rank <= Length(AryScatteredLanes)) then
        obj.LaneNum := AryScatteredLanes[Rank]
      else
        {TODO -oBSA -cGeneral : ERROR -Entrant never got a lane in chosen heat.}
        obj.LaneNum := 0;

      INC(EntrantCount,1);
    end;

    if I > 0 then result := I;

  end;
end;

procedure TABINDV.Entrants_AssignRanking(StartHeatNum, Count: Integer);
var
  I, J, k, RankNum: integer;
  obj: TLaneEntrant;
begin
  for J := StartHeatNum to Count-1 do
  begin
    RankNum := 1;
    for K := 0 to AryEntrantsPerHeat[J] - 1 do
    begin
      for I := 0 to Length(AryEntrants) do
      begin
        obj := AryEntrants[i];
        // find heat. zero rank
        if (obj.HeatNum = J) and (obj.LaneRankNum = 0) then
        begin
          obj.LaneRankNum := RankNum;
          Inc(RankNum, 1);
        end;
      end;
    end;
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

function TABINDV.Seeding_Circle(StartHeatNum, Count: Integer): Integer;
var
  I, HeatNum, LaneNum: Integer;
  HeatOffset: Integer;
begin
  Result := 0;

  // Validation
  if (Count <= 0) or (Length(AryEntrants) = 0) or (Length(AryEntrantsPerHeat) =
    0) then
    Exit;

  // Ensure swimmers are sorted fastest to slowest
  // (Call a sorting function here or before)

  // Standard circle seeding: Fastest swimmers distributed across heats
  // For example: 3 heats, 8 swimmers
  // Heat 3: Lanes 1,4,7
  // Heat 2: Lanes 2,5,8
  // Heat 1: Lanes 3,6

  for I := 0 to Length(AryEntrants) - 1 do
  begin
    // Calculate which heat this swimmer goes to (circle method)
    HeatOffset := I mod Count;
    HeatNum := StartHeatNum + Count - 1 - HeatOffset;

    // Calculate lane position within heat
    LaneNum := (I div Count) + 1;

    // Check if lane exists in this heat
    if LaneNum <= AryEntrantsPerHeat[HeatNum - StartHeatNum] then
    begin
      AryEntrants[I].HeatNum := HeatNum;
      AryEntrants[I].LaneRankNum := LaneNum;
      Inc(Result);
    end
    else
      Break; // No more lanes available
  end;
end;

function TABINDV.Seeding_Default(StartHeatNum, Count: Integer): Integer;
var
  I, HeatIndex, LaneIndex: Integer;
  CurrentHeat, SwimmerCount: Integer;
begin
  Result := 0;
  // Validation
  if (Count <= 0) or (Length(AryEntrants) = 0) then
    Exit;
  // Ensure AryEntrants is sorted fastest to slowest before calling this function
  // SortAryEntrantsByTime(); // Should be called elsewhere

  // Calculate total swimmers across all heats
  SwimmerCount := 0;
  for I := 0 to Length(AryEntrantsPerHeat) - 1 do
    SwimmerCount := SwimmerCount + AryEntrantsPerHeat[I];

  if SwimmerCount = 0 then
    Exit;

  // Seeding logic: Fastest swimmers go to last heats (circle method)
  HeatIndex := StartHeatNum + Count - 1;  // Start from last heat
  LaneIndex := 1;  // Start lane rank at 1 (fastest lane)

  for I := 0 to Length(AryEntrants) - 1 do
  begin
    // Assign current swimmer to current heat and lane rank
    AryEntrants[I].HeatNum := HeatIndex;
    AryEntrants[I].LaneRankNum := LaneIndex;

    // Move to next lane in same heat
    Inc(LaneIndex);

    // If we've filled this heat, move to previous heat
    if LaneIndex > AryEntrantsPerHeat[HeatIndex - StartHeatNum] then
    begin
      LaneIndex := 1;
      Dec(HeatIndex);

      // If we've assigned all heats, stop
      if HeatIndex < StartHeatNum then
        Break;
    end;
  end;

  Result := I;  // Number of swimmers successfully seeded
end;

function TABINDV.Seeding_Random(StartHeatNum, Count: Integer): Integer;
begin
  SortAryEntrantsByRandom;
  result := Seeding_Default(StartHeatNum, Count);
end;

function TABINDV.TestExcludedLane(LaneNum: integer): Boolean;
var
  I: Integer;
begin
  result := false;
  for I := Low(AryExcludeLanes) to High(AryExcludeLanes) do
  begin
    if AryExcludeLanes[I] = LaneNum then
    begin
      result := true;
      break;
    end;
  end;
end;

function TABINDV.TestIsHeatFull(HeatNum: integer): boolean;
begin
  {is heatfull}
  result := true;
end;

end.
