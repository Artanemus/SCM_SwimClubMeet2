unit uABINDV;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Math,
  System.StrUtils, System.Types,  System.Variants,
  Data.DB,

  VCL.Dialogs,
  FireDAC.Comp.Client, FireDAC.Stan.Error,
  dmSCM2, dmCORE, uSettings,
  dmABINDV,
  uDefines, uUtility, uSwimClub, uSession, uNominee, uEvent, uHeat, uLane
  ;

type

  TLaneEntrant = class;

  TABINDV = class(TComponent)
  private
    ABData: TABINV;
    ArrayEntrants: Array of TLaneEntrant;
    ArrayEntrantsPerHeat: Array of Integer;
    ArrayExcludeLanes: Array of Integer;
    ArrayScatteredLanes: Array of Integer;
    fError: boolean;
    fErrorNum: integer;
    fExcludeLaneCount: integer;
    fNomineeCount: integer;
    fNumOfHeats: integer;
    fNumOfLanes: integer;
    fRealNumOfLanes: integer;
    fVerbose: boolean;
    fConnection: TFDConnection;

    { main execution routine. }
    function AutoBuildCORE(StartHeatNum: Integer): Integer;
    function AutoBuildHeatsAndLanes(): Integer;
    procedure Entrants_AssignLaneNum(StartHeatNum, EndHeatNum: Integer);
    procedure Entrants_AssignRanking(StartHeatNum, EndHeatNum: Integer);
    { Initialise }
    procedure InitEntrantsPerHeat(var NumOfHeats: Integer);
    function InitExcludedLanes: Integer;
    function CalcNumberOfHeats(NumOfNominees, NumOfRealLanes: Integer): Integer;
    procedure InitScatterLanes(NumOfPoolLanes: integer);
    procedure BuildEntrants();
    { Seeding routine. }
    function Seeding_Circle(StartHeatNum, EndHeatNum: Integer): Integer;
    function Seeding_Default(StartHeatNum, EndHeatNum: Integer): Integer;
    function Seeding_Random(StartHeatNum, EndHeatNum: Integer): Integer;
    function TestExcludedLane(LaneNum: integer): Boolean;
    function TestIsHeatFull(HeatNum: integer): boolean;

  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    function AutoBuildExec: Boolean;
    function CountNominees(): integer;
    function Prepare(AConnection: TFDConnection): Boolean;
  end;

  TLaneEntrant = class(TObject)
    NomineeID: integer;
    RankNum: integer;
    HeatNum: integer;
    LaneNum: integer;
    RandomNum: integer;
    constructor Create();
    destructor Destroy; override;
  end;

implementation

{ TLaneEntrant }

constructor TLaneEntrant.Create;
begin
  NomineeID := 0;
  RankNum := 0;
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
  fVerbose := true;
  fError := false;
  fErrorNum := 0;
  Randomize;
  fConnection := nil;

  ABData := TABINV.Create(Self);
end;

destructor TABINDV.Destroy;
var
  I: integer;
begin
  // TODO -cMM: TABINDV.Destroy default body inserted
  ABData.DeActivateData;
  ABData.Free;
  if Length(ArrayEntrants) > 0 then
  begin
    for I := LOW(ArrayEntrants) to HIGH(ArrayEntrants) do
      ArrayEntrants[I].Free;
    SetLength(ArrayEntrants, 0);
  end;
  inherited;
end;

function TABINDV.AutoBuildCORE(StartHeatNum: Integer): Integer;
var
  msg: string;
  NumOfHeatsSeeded, EndHeatNum, NumOfHeatsToSeed: integer;
  SeedDepth, HeatNum: integer;
begin
  { Call here after qryUnplacedNominees has been prepared and active.
  Nominees are ordered in qryUnplacedNominees : Fastest to Slowest.}
  result := 0;

  // CALCULATE the number of heats needed to build.
  NumOfHeatsToSeed := CalcNumberOfHeats(fNomineeCount, fRealNumOfLanes);
  // CALCULATE the number ofswimmers per heat. Populate ArrayEntrantsPerHeat.
  InitEntrantsPerHeat(NumOfHeatsToSeed);

  { Populate ArrayEntrants with TLaneEntrants from ABData.qryUnplacedNominees }
  BuildEntrants();


  case Settings.ab_SeedMethodIndx of
    0:
      begin
        {  STANDARD SEEDING.}
        NumOfHeatsSeeded := Seeding_Default(StartHeatNum, NumOfHeatsToSeed + StartHeatNum);
      end;

    1:
      begin
        SeedDepth := Settings.ab_SeedDepth;
        if SeedDepth = 0 then
          EndHeatNum := (NumOfHeatsToSeed + StartHeatNum) // circle seed all heats.
        else
          EndHeatNum := (SeedDepth + StartHeatNum);

        {CIRCLE SEEDING.}
        NumOfHeatsSeeded := Seeding_Circle(StartHeatNum, EndHeatNum);

        {DEFAULT SEEDING.}
        if NumOfHeatsSeeded < NumOfHeatsToSeed then
        begin
          HeatNum := StartHeatNum + NumOfHeatsSeeded;
          { do the remaining heats using STANDARD SEEDING.}
          NumOfHeatsSeeded := Seeding_Default(HeatNum, HeatNum+NumOfHeatsToSeed);
        end;


      end;
    2:
      begin
        NumOfHeatsSeeded := Seeding_Random(StartHeatNum, NumOfHeatsToSeed + StartHeatNum);
      end;
  end;
  if NumOfHeatsSeeded > 0 then result := NumOfHeatsSeeded;

end;

function TABINDV.AutoBuildExec: Boolean;
var
  msg: string;
  totalHeatCount, I, J, indx: Integer;
  NumOfHeatsSeeded, StartHeatNum: integer;
begin
  result := false;

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
        Your pool needs at least two swimming lanes
        else the scatter algorithm cannot run.
        Is the Club''s number of pool lanes correctly assigned?
        Auto-Build will abort.
      ''';
      MessageDlg(msg, mtError, [mbOK], 0, mbOK);
    end;
    fError := true;
    fErrorNum := 2;
    exit;
  end;

  fNumOfLanes := uSwimClub.NumberOfLanes;
  // PREPARE ArrayExcludeLanes.
  fExcludeLaneCount := InitExcludedLanes;
  // Get the real number of available lanes.
  fRealNumOfLanes:=fNumOfLanes-fExcludeLaneCount;

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

 { Initialise ArrayScatteredLanes. Fast ranked swimmers take center lanes,
    slow swimmers outside lanes. Routine ignores excluded lanes. }
  InitScatterLanes(fNumOfLanes); // dbo.SwimClub ... number of pool lanes.

  { Create a list of unplaced nominees in the event.}
  ABData.qryUnplacedNominees.Connection := SCM2.scmConnection;
  ABData.qryUnplacedNominees.ParamByName('EVENTID').AsInteger  := uEvent.PK;
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
        Auto-Build Heats will exit.
        ''';
      MessageDlg(msg, mtError, [mbOK], 0, mbOK);
    end;
    // All the nominees are placed - nothing more to do. OK.
    fError := false;
    fErrorNum := 0;
    result := true;
    exit;
  end;

  fNomineeCount := ABData.qryUnplacedNominees.RecordCount;

  StartHeatNum := uHeat.LastHeatNum + 1;

    // BASIC Auto-Build.  Assign active index name.
  if (Settings.ab_SeperateGender = false)
  and (Settings.ab_GroupByIndx <= 0) then
  begin
    StartHeatNum := 1;
    ABData.qryUnplacedNominees.IndexName := 'indxTTB';
    if ABData.qryUnplacedNominees.Filtered then
      ABData.qryUnplacedNominees.Filtered := false;
    NumOfHeatsSeeded := AutoBuildCORE(StartHeatNum);
    //********************************************
    // BUILD THE HEATS.
    //********************************************
    exit;
  end;

     // Filter by gender Auto-Build.
  if (Settings.ab_SeperateGender = true)
  and (Settings.ab_GroupByIndx <= 0) then
  begin
    totalHeatCount := 0;
    StartHeatNum := 1;
    ABData.qryUnplacedNominees.IndexName := 'indxTTB';
    if not ABData.qryUnplacedNominees.Filtered then
      ABData.qryUnplacedNominees.Filtered := true;
    ABData.qryGender.Connection := SCM2.scmConnection;
    ABData.qryGender.Open;
    if ABData.qryGender.Active then
    begin
      while not ABData.qryGender.EOF do
      begin
        var id: integer;
        id := ABData.qryGender.FieldByName('GenderID').AsInteger;
        ABData.qryUnplacedNominees.Filter := 'GenderID = ' + IntToStr(id);
          // gender M.
        ABData.qryUnplacedNominees.Refresh;
        fNumOfHeats := CalcNumberOfHeats(ABData.qryUnplacedNominees.RecordCount,
          fRealNumOfLanes);
        totalHeatCount := totalHeatCount + fNumOfHeats;
        NumOfHeatsSeeded := AutoBuildCORE(StartHeatNum);
        StartHeatNum := StartHeatNum + NumOfHeatsSeeded;
        //********************************************
        // BUILD THE HEAT.
        // aHeatID := uHeat.NewHeat;
        // iterate over object - assigning data to lanes..
        {
        for obj in ArrayEntrants do
        begin

        end;
        }

        //********************************************
        ABData.qryGender.Next;
      end;
    end;
  end;

  // *******************************************************
  result := true;
  // *******************************************************

end;

function TABINDV.AutoBuildHeatsAndLanes: Integer;
var
  I, EventID, HeatID, HeatNum: integer;
  obj: TLaneEntrant;
  SearchOptions: TLocateOptions;
begin
  result := 0;
  if not assigned(fConnection) then exit;
  ABData.qryLanes.Connection := fConnection;
  SearchOptions := [];
  EventID := uEvent.PK;
  for I := 0 to fNumOfHeats-1 do
  begin
    HeatID := uHeat.NewHeat;
    if ABData.qryLanes.Active then ABData.qryLanes.Close;
    ABData.qryLanes.ParamByName('HEATID').AsInteger := HeatID;
    ABData.qryLanes.Prepare;
    ABData.qryLanes.Open;
    if ABData.qryLanes.Active then
    begin
      HeatNum := ABData.qryLanes.FieldByName('HeatNum').AsInteger;
      for obj in ArrayEntrants do
      begin
        if obj.HeatNum = HeatNum then
        begin
          if ABData.qryLanes.Locate('LaneNum', obj.LaneNum, SearchOptions) then
          begin
            ABData.qryLanes.Edit;
            ABData.qryLanes.FieldByName('NomineeID').AsInteger := obj.NomineeID;
            ABData.qryLanes.Post;
          end;
        end;
      end;
    end;
    ABData.qryLanes.Close;
  end;

end;

procedure TABINDV.BuildEntrants;
var
  obj: TLaneEntrant;
begin
  SetLength(ArrayEntrants, 0);
  ABData.qryUnplacedNominees.First;
  while not ABData.qryUnplacedNominees.EOF do
  begin // populate the ArrayEntrants...
    obj := TLaneEntrant.Create();
    obj.NomineeID :=
      ABData.qryUnplacedNominees.FieldByName('NomineeID').AsInteger;
    obj.RandomNum := Random(SizeOf(Int16)); // assign randomNum
    ArrayEntrants := ArrayEntrants + [obj]; // append to array.
    ABData.qryUnplacedNominees.Next;
  end;
end;

function TABINDV.CountNominees(): integer;
begin
  result := 0;
  with  ABData.qryCountNominees do
  begin
    Close;
    ParamByName('EVENTID').AsInteger := uEvent.PK;
    Prepare;
    Open;
    if Active and not IsEmpty then
    begin
      // return the number of nominees
      result := FieldByName('countNominees').AsInteger;
      Close;
    end;
  end;
end;

procedure TABINDV.Entrants_AssignLaneNum(StartHeatNum, EndHeatNum: Integer);
var
  I, J, RankOffset, Rank, EntrantCount: integer;
  obj: TLaneEntrant;
begin
  { Acll here after assigning HeatNum, NomineeID and RankNum.
    How rank works...
    Rank order of the swimmer. ie. 1st, 2nd, 3rd, etc.
    Fast swimmers have a lower value.}

  for J := StartHeatNum to EndHeatNum do // iterate on heat.
  begin
    RankOffset := 0; // rankoffest is used to skip user-excluded lanes.
    EntrantCount := 0; // used to test if heat has been processed.
    // Fastest swimmer always at heat of array.
    for I := 0 to Length(ArrayEntrants) - 1 do
    begin
      { Optimise : this statement can be ommitted. }
      // has all the entrants been assigned a lane for the given heat?
      if (EntrantCount >= ArrayEntrantsPerHeat[J]) then break;

      obj := ArrayEntrants[i];
      if (obj.HeatNum <> J) then continue;  // wrong heat number.

      Rank := obj.RankNum + RankOffset;
      { Handle excluded lanes. Skipping lanes by lowing ranking.}
      While (Rank <= Length(ArrayScatteredLanes))  do
      begin
        if TestExcludedLane(ArrayScatteredLanes[Rank]) then
          INC(Rank,1)
        else
          break;
      end;
      { Look-up rank and return with lane number. Fastest swim in center of pool. }
      if (Rank <= Length(ArrayScatteredLanes)) then
        obj.LaneNum := ArrayScatteredLanes[Rank]
      else
        {TODO -oBSA -cGeneral : ERROR -Entrant never got a lane in chosen heat.}
        obj.LaneNum := 0;

      INC(EntrantCount,1);
    end;
  end;
end;

procedure TABINDV.Entrants_AssignRanking(StartHeatNum, EndHeatNum: Integer);
var
  I, J, k, RankNum: integer;
  obj: TLaneEntrant;
begin
  for J := StartHeatNum to EndHeatNum do
  begin
    RankNum := 1;
    for K := 0 to ArrayEntrantsPerHeat[J] - 1 do
    begin
      for I := 0 to Length(ArrayEntrants) do
      begin
        obj := ArrayEntrants[i];
        // find heat. zero rank
        if (obj.HeatNum = J) and (obj.RankNum = 0) then
        begin
          obj.RankNum := RankNum;
          Inc(RankNum, 1);
        end;
      end;
    end;
  end;
end;

procedure TABINDV.InitEntrantsPerHeat(var NumOfHeats: Integer);
var
  I, J: Integer;
begin
  // CALCULATE the number of entrants (swimmers) in each heat.
  // Init:
  Setlength(ArrayEntrantsPerHeat, NumOfHeats);
  // prepare: clear array values.
  for I := Low(ArrayEntrantsPerHeat) to High(ArrayEntrantsPerHeat) do
    ArrayEntrantsPerHeat[I] := 0;
  // init:
  I := fNomineeCount;
  J := 0;
  // brute force:
  repeat
    ArrayEntrantsPerHeat[J] := ArrayEntrantsPerHeat[J] + 1;
    INC(J);
    if J > HIGH(ArrayEntrantsPerHeat) then J := 0;
    DEC(I);
  until (I = 0);
  // Make pretty... ? (Shuffle / Stack).
end;

function TABINDV.InitExcludedLanes: Integer;
var
  sa: TStringDynArray;
  LaneNum, J: integer;
  s: string;
begin
  // INIT:
  result := 0; // No exclude lanes.
  SetLength(ArrayExcludeLanes, 0);

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
          Insert(LaneNum, ArrayExcludeLanes, 0);
      end;
    end;
  end;

  if Length(ArrayExcludeLanes) > 0 then
    result := Length(ArrayExcludeLanes);

end;

function TABINDV.CalcNumberOfHeats(NumOfNominees, NumOfRealLanes: Integer):
    Integer;
var
NumOfHeats: integer;
begin
  Result := 0;
  if NumOfNominees <= 0 then exit;
  Result := 1;
  // Calculate the number of heats in each event.
  if (numOfNominees > NumOfRealLanes) then
  begin
    NumOfHeats :=
      Ceil(double(numOfNominees) / double(NumOfRealLanes));
    Result := NumOfHeats;
  end;
end;

// -----------------------------------------------------------
// SHARED FUNCTION
// Called by dmSCM2 and dmAutoBuildV2
// -----------------------------------------------------------
procedure TABINDV.InitScatterLanes(NumOfPoolLanes: integer);
var
  i, j: integer;
  IsEven, found: boolean;
begin
  // NumOfPoolLanes must be greater than 1
  if (NumOfPoolLanes < 2) then
    exit;
  SetLength(ArrayScatteredLanes, NumOfPoolLanes);
  // seed number for first array value
  // Find the center lane. For 'odd' number of pool ArrayScatteredLanes - round up;
  ArrayScatteredLanes[0] := Ceil(double(NumOfPoolLanes) / 2.0);
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
      ArrayScatteredLanes[i] := (i) + (ArrayScatteredLanes[(i - 1)])
    else
      ArrayScatteredLanes[i] := (ArrayScatteredLanes[(i - 1)]) - (i);
  end;
end;

{ TABINDV }

function TABINDV.Prepare(AConnection: TFDConnection): Boolean;
begin
  // Attach auto-create data module to connection and activate.
  Result := false;
  fConnection := nil;
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

function TABINDV.Seeding_Circle(StartHeatNum, EndHeatNum: Integer): Integer;
var
  I, J, K, Count: integer;
  obj: TLaneEntrant;

begin
  // iterate.
  result := 0;
  Count := 0;
  K := 0;
  // Nominees are Sorted on fastest to slowest TTB.
  while K < Length(ArrayEntrants) do
  begin
    for I := EndHeatNum downto StartHeatNum do // SEED DEPTH...
    begin
      // Check bounds and if more entrants can be placed into this heat.
      if (K < Length(ArrayEntrants)) and not TestIsHeatFull(I) then
      begin
        obj := ArrayEntrants[K];
        obj.HeatNum := I; // Fastest swimmers swim in last heat.
        INC(Count, 1);
        INC(K, 1);
      end;
    end;
  end;

  // assign ranknum
  Entrants_AssignRanking(StartHeatNum, EndHeatNum);
  // assign lane number.
  Entrants_AssignLaneNum(StartHeatNum, EndHeatNum);

  if Count <> 0 then
    result := count;
end;

function TABINDV.Seeding_Default(StartHeatNum, EndHeatNum: Integer): Integer;
var
  I, J, K, RankNum, Count: integer;
  obj: TLaneEntrant;
begin
  // iterate.
  result := 0;
  Count := 0;
  // bounds check
  if StartHeatNum<EndHeatNum then
  begin
    I := StartHeatNum;
    StartHeatNum := EndHeatNum;
    EndHeatNum := I;
  end;

  if StartHeatNum > fNumOfHeats then StartHeatNum := fNumOfHeats;
  if EndHeatNum < 1 then EndHeatNum := 1;
  if (StartHeatNum<EndHeatNum) OR (StartHeatNum=EndHeatNum) then exit;

  // GO SEED HeatNum and Ranking.
  K := 0;
  for I := EndHeatNum downto StartHeatNum do // iterate heats.
  begin
    RankNum := 1; // reset on each heat
    for J :=0 to ArrayEntrantsPerHeat[i] -1  do // fill with entants until full.
    begin
      // Nominees are Sorted on fastest to slowest TTB.
      if K < Length(ArrayEntrants) then
      begin
        obj := ArrayEntrants[K]; // TLaneEntrant ordered fastest to slowest.
        obj.HeatNum := I; // Fastest swimmers are placed into last heat.
        obj.RankNum := RankNum;
        INC(Count, 1);
        INC(K, 1);
        INC(RankNum, 1);
      end;
    end;
  end;

  // assign lane number.
  Entrants_AssignLaneNum(StartHeatNum, EndHeatNum);
  if Count <> 0 then
    { obj.LaneNum needs assignment}
    result := count;

end;

function TABINDV.Seeding_Random(StartHeatNum, EndHeatNum: Integer): Integer;
var
  I, J, K, Count: integer;
  obj: TLaneEntrant;
begin
  // iterate.
  result := 0;
  Count := 0;
  // bounds check
  if StartHeatNum<EndHeatNum then
  begin
    I := StartHeatNum;
    StartHeatNum := EndHeatNum;
    EndHeatNum := I;
  end;

  if StartHeatNum > fNumOfHeats then StartHeatNum := fNumOfHeats;
  if EndHeatNum < 1 then EndHeatNum := 1;
  if (StartHeatNum<EndHeatNum) OR (StartHeatNum=EndHeatNum) then exit;

  ABData.qryUnplacedNominees.First;
  while not ABData.qryUnplacedNominees.EOF do
  begin // populate the ArrayEntrants...
    obj := TLaneEntrant.Create();
    obj.NomineeID :=
      ABData.qryUnplacedNominees.FieldByName('NomineeID').AsInteger;
    obj.RandomNum := Random(SizeOf(Int16)); // assign randomNum

    // find insert position.
    for I := Low(ArrayEntrants) to High(ArrayEntrants) do
      if ArrayEntrants[I].RandomNum > obj.RandomNum  then
        break;

    INSERT(obj, ArrayEntrants, I);
    ABData.qryUnplacedNominees.Next;
  end;

  K := Low(ArrayEntrants);
  // GO SEED.
  for I := StartHeatNum to EndHeatNum do // iterate heats.
  begin
    for J :=0 to ArrayEntrantsPerHeat[i] -1  do // fill with entants until full.
    begin
      if K <= High(ArrayEntrants) then // bounds check
      begin
        obj := ArrayEntrants[K];
        obj.HeatNum := I;
        INC(Count, 1);
      end;
    end;
  end;

  // assign rank number.
  Entrants_AssignRanking(StartHeatNum, EndHeatNum);
  // assign lane number.
  Entrants_AssignLaneNum(StartHeatNum, EndHeatNum);

  if Count <> 0 then
    { obj.LaneNum needs assignment}
    result := count;

end;

function TABINDV.TestExcludedLane(LaneNum: integer): Boolean;
var
  I: Integer;
begin
  result := false;
  for I := Low(ArrayExcludeLanes) to High(ArrayExcludeLanes) do
  begin
    if ArrayExcludeLanes[I] = LaneNum then
    begin
      result := true;
      break;
    end;
  end;
end;

function TABINDV.TestIsHeatFull(HeatNum: integer): boolean;
begin
  {is heatfull}
end;





end.
