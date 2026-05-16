unit uABINDV;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Math,
  System.StrUtils, System.Types,
  VCL.Dialogs,
  FireDAC.Comp.Client, FireDAC.Stan.Error,
  dmSCM2, dmCORE, uSettings,
  dmABINDV,
  uDefines, uUtility, uSwimClub, uSession, uNominee, uEvent, uHeat, uLane
  ;

type
  TABINDV = class(TComponent)
  private
    ABData: TABINV;
    fVerbose: boolean;
    fError: boolean;
    fErrorNum: integer;
    ArrayLanes: Array of array of integer; // [HeatNum, NomineeID]
    ArrayLanesExclude: Array of Integer;  // Unordered list of lanes to exclude.
    ArrayEntrants: Array of Integer; // Number of swimmers/entrants in each heat.
    fNomineeCount: integer;
    fRealLaneCount: integer;
    fExcludeLaneCount: integer;
    fHeatCount: integer;

    procedure CALC_EntrantsPerHeat(var NumOfHeats: Integer);
    function CALC_NumberOfHeats(NumOfNominees: Integer): Integer;
    function PREPARE_ArrayLanesExclude(): Integer; // rtns NumOfExcludeLanes
    function AutoBuildCORE: Boolean;
    function Seeding_Circle: Integer; // rtns numofheat done.
    function Seeding_Default(TotalNumOfHeats: Integer; NumOfHeatsSeeded: Integer =
        0): Integer;

  function ScatterLanes(index, NumOfPoolLanes: integer;
    Excludedlanes: Array of integer): integer;


  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    function Prepare(AConnection: TFDConnection): Boolean;
    function AutoBuildExec: Boolean;

    function CountNominees(): integer;

  end;


implementation

function TABINDV.Prepare(AConnection: TFDConnection): Boolean;
begin
  // TODO -cMM: Prepare default body inserted
  Result := false;
  if Assigned(AConnection) then
  begin
    ABData.ActivateData;
    if ABData.IsActive then
      Result := true;
  end;
end;

function TABINDV.PREPARE_ArrayLanesExclude: Integer;
var
  sa: TStringDynArray;
  LaneNum, J: integer;
  s: string;
begin
  // INIT:
  result := 0; // No exclude lanes.
  SetLength(ArrayLanesExclude, 0);

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
          Insert(LaneNum,ArrayLanesExclude, 0);
      end;
    end;
  end;

  if Length(ArrayLanesExclude) > 0 then
    result := Length(ArrayLanesExclude);

end;

function TABINDV.AutoBuildCORE: Boolean;
var
  msg: string;
  NumberofHeatsSeeded: integer;
begin
  result := true;
  fRealLaneCount := uSwimClub.NumberOfLanes;
  // PREPARE ArrayLanesExclude.
  fExcludeLaneCount := PREPARE_ArrayLanesExclude;
  // Acutal available lanes in the swimming pool.
  fRealLaneCount:=fRealLaneCount-fExcludeLaneCount;


  if (fRealLaneCount <= 0) then
  begin
    if (fVerbose) then
    begin
      msg := '''
        After taking into consideration "exclude outside lanes"
        and the user''s selected lanes to exclude, the total number
        of lanes available for a heat is zero. Consider making
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

  // CALCULATE the number of heats needed to build.
  fHeatCount := CALC_NumberOfHeats(fNomineeCount);
  // CALCULATE swimmers per heat. Populate ArrayEntrants.
  CALC_EntrantsPerHeat(fHeatCount);

  // init:
  ABData.qryUnplacedNominees.First;
  Setlength(ArrayLanes, fHeatCount, fRealLaneCount);

  // CIRCLE SEEDING...
  if Settings.ab_SeedMethodIndx = 0 then
  begin
    NumberofHeatsSeeded := Seeding_Circle();
  end;

  // DEFAULT SEEDING... (offset heatnum, total number of heats)
  Seeding_Default(NumberofHeatsSeeded, fHeatCount);

end;


function TABINDV.AutoBuildExec: Boolean;
var
  msg: string;
  totalHeatCount, I, J, indx: Integer;
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
        Heats have been cleaned.
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

  // BASIC Auto-Build.  Assign active index name.
  if (Settings.ab_SeperateGender = false)
    and (Settings.ab_GroupByIndx <= 0) then
  begin
      ABData.qryUnplacedNominees.IndexName := 'indxTTB';
      if ABData.qryUnplacedNominees.Filtered then
        ABData.qryUnplacedNominees.Filtered := false;
  end;

  result := AutoBuildCORE;











  // Filter by gender Auto-Build.
  if (Settings.ab_SeperateGender = true)
    and (Settings.ab_GroupByIndx <= 0) then
  begin
    totalHeatCount := 0;
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
        ABData.qryUnplacedNominees.Filter := 'GenderID = ' + IntToStr(id); // gender M.
        fHeatCount := CALC_NumberOfHeats(ABData.qryUnplacedNominees.RecordCount);
        totalHeatCount := totalHeatCount + fHeatCount;

        { AUTOBUILD - EXEC PART 2}

        ABData.qryGender.Next;
      end;
    end;


  end;



  // *******************************************************
  result := true;
  // *******************************************************



end;

constructor TABINDV.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fVerbose := true;
  fError := false;
  fErrorNum := 0;
  ABData := TABINV.Create(Self);
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

destructor TABINDV.Destroy;
begin
  // TODO -cMM: TABINDV.Destroy default body inserted
  ABData.DeActivateData;
  ABData.Free;
  inherited;
end;

procedure TABINDV.CALC_EntrantsPerHeat(var NumOfHeats: Integer);
var
  I, J: Integer;
begin
  // CALCULATE the number of entrants (swimmers) in each heat.
  // Init:
  Setlength(ArrayEntrants, NumOfHeats);
  // prepare: clear array values.
  for I := Low(ArrayEntrants) to High(ArrayEntrants) do
    ArrayEntrants[I] := 0;
  // init:
  I := fNomineeCount;
  J := 0;
  // brute force:
  repeat
    ArrayEntrants[J] := ArrayEntrants[J] + 1;
    INC(J);
    if J > HIGH(ArrayEntrants) then J := 0;
    DEC(I);
  until (I = 0);
  // Make pretty... ? (Shuffle / Stack).
end;

function TABINDV.CALC_NumberOfHeats(NumOfNominees: Integer): Integer;
var
NumOfLanes, NumOfHeats: integer;
begin
  Result := 1;
  NumOfLanes:= uSwimClub.NumberOfLanes;
  // Calculate the number of heats in each event.
  if (numOfNominees > NumOfLanes) then
  begin
    NumOfHeats :=
      Ceil(double(numOfNominees) / double(NumOfLanes));
    Result := NumOfHeats;
  end;
end;

function TABINDV.Seeding_Circle: Integer;
var
LaneNum, HeatNum, I: integer;
begin
  // CIRCLE SEEDING ...
  if Settings.ab_SeedMethodIndx = 1 then
  BEGIN
    var fSeedDepth: integer;
    fSeedDepth := Settings.ab_SeedDepth;
    if (fSeedDepth <> 0) and (fHeatCount >= fSeedDepth) then
    begin
      // Nominees are Sorted on fastest to slowest TTB.
      // Seed depth is fHeatCount.
      // LaneCount is SwimClub.NumOfLanes - (Exclude gutter lanes + Exclude custom lanes.)
      LaneNum := 1;
      HeatNum := 1;
      // keep repeating loop across heat while...
      while not ABData.qryUnplacedNominees.EOF and (HeatNum <= fSeedDepth) do
      begin
        for I := HeatNum to fHeatCount do // cloop across heats..
        begin
          if ABData.qryUnplacedNominees.EOF then break;
          if I > fRealLaneCount then continue;

          ArrayLanes[I-1][LaneNum-1] :=
            ABData.qryUnplacedNominees.FieldByName('NomineeID').AsInteger;
          ABData.qryUnplacedNominees.Next;
        end;
        Inc(LaneNum, 1);
      end;
    end;
  END;
end;

function TABINDV.Seeding_Default(TotalNumOfHeats: Integer;
    NumOfHeatsSeeded: Integer = 0): Integer;
var
  I, J, HeatNum, offset: Integer;
begin
  offset := fHeatCount + NumOfHeatsSeeded - 1;
  // DEFAULT SEEDING ....
  if HeatNum < fHeatCount-1 then
  begin
    // complete seeding the remain heats using default method.
    var LaneNum: integer;
    LaneNum := 0;
    // keep repeating loop across heat while...
    while not ABData.qryUnplacedNominees.EOF and (LaneNum < fHeatCount) do
    begin
      for HeatNum := offset to fHeatCount-1 do // loop across heats..
      begin
        for I := 0 to fRealLaneCount-1 do
        begin
          if ABData.qryUnplacedNominees.EOF then break;
          // .. seeding nominee swimmers into heats
          J := ScatterLanes(I+1, uSwimClub.NumberOfLanes, ArrayLanesExclude);
          ArrayLanes[HeatNum][J-1] := ABData.qryUnplacedNominees.FieldByName('NomineeID').AsInteger;
          ABData.qryUnplacedNominees.Next;
        end;
      end;
      Inc(LaneNum, 1);
    end;
  end;
end;



// -----------------------------------------------------------
// SHARED FUNCTION
// Called by dmSCM2 and dmAutoBuildV2
// -----------------------------------------------------------
function TABINDV.ScatterLanes(index, NumOfPoolLanes: integer;
  Excludedlanes: Array of integer): integer;
var
  Lanes: Array of integer;
  i, j: integer;
  IsEven, found: boolean;
begin
  result := 0;
  // NumOfPoolLanes must be greater than 1
  if (NumOfPoolLanes < 2) then
    exit;
  // index passed is base 0
  // test for out-of-bounds
  if ((index + 1) > NumOfPoolLanes) then
    exit;
  SetLength(Lanes, NumOfPoolLanes);
  // seed number for first array value
  // Find the center lane. For 'odd' number of pool lanes - round up;
  Lanes[0] := Ceil(double(NumOfPoolLanes) / 2.0);
  // build the
  for i := 1 to NumOfPoolLanes - 1 do
  begin
    // ----------------------------------
    // Skip over excluded lanes...
    // ----------------------------------
    if Length(Excludedlanes) <> 0 then
    begin
      found := false;
      for j in Excludedlanes do
      begin
        if (i = j) then
        begin
          found := true;
          break;
        end;
      end;
      if found then continue;
    end;

    // start the iterate at index 1
    // reference previous value in list with base 0
    if (((i + 1) MOD 2) = 0) then
      IsEven := True
    else
      IsEven := False;
    if IsEven then
      Lanes[i] := (i) + (Lanes[(i - 1)])
    else
      Lanes[i] := (Lanes[(i - 1)]) - (i);
  end;
  // pull the entrants lane number.
  result := Lanes[index];
  {
    You don't need to call SetLength at the end.
    A dynamic-array field like 'Lanes' gets released automatically when
    the object is destroyed.
    // SetLength(Lanes, 0);
  }
end;

end.
