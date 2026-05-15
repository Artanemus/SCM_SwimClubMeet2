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
    fLaneCount: integer;
    fHeatCount: integer;

    procedure CALC_EntrantsPerHeat(var NumOfHeats: Integer);
    function CALC_NumberOfHeats(NumOfNominees: Integer): Integer;
    function CALC_RealLaneCount(SwimClub_NumOfLanes: Integer): Integer;
    function AutoBuildCORE: Boolean;
    procedure Seeding_Circle(HeatNumber: Integer);
    procedure Seeding_Default(HeatNumber: Integer);

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

function TABINDV.AutoBuildCORE: Boolean;
var
  msg: string;
  fHeatNum, I: integer;
begin
  result := true;
  fLaneCount := CALC_RealLaneCount(uSwimClub.NumberOfLanes);

  if (fLaneCount <= 0) then
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
  CALC_EntrantsPerHeat(fHeatCount);

  ABData.qryUnplacedNominees.First;

  // init:
  Setlength(ArrayLanes, fHeatCount, fLaneCount);
  // CIRCLE SEEDING...
  if Settings.ab_SeedMethodIndx = 0 then
  begin
    for fHeatNum := 0 to Settings.ab_SeedDepth-1 do
    begin
      if fHeatNum >= fHeatCount then break;
      Seeding_Circle(fHeatNum+1);
    end;
  end;
  // DEFAULT SEEDING...
  if (fHeatNum < fHeatCount) then
  begin
    for fHeatNum := fHeatNum to fHeatCount - 1 do
    begin
      Seeding_Default(fHeatNum+1);
    end;
  end;

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

function TABINDV.CALC_RealLaneCount(SwimClub_NumOfLanes: Integer): Integer;
var
  J, fLaneCount: integer;
begin
  result := 0;
  SetLength(ArrayLanesExclude, 0);
  // Are lanes being excluded?
  fLaneCount := uSwimClub.NumberOfLanes;
  if Settings.ab_ExcludeOutsideLanes then
  begin
    fLaneCount := fLaneCount - 2;
    Insert(1,ArrayLanesExclude, 0);
    Insert(fLaneCount,ArrayLanesExclude, 0);
  end;
  if Settings.ab_ExcludeLanesCustom then
  begin
    var sa: TStringDynArray;
    sa := SplitString(Settings.ab_ListOfExcludeLanes, ',');
    for J := Low(sa) to High(sa) do
    begin
      var s:string;
      var LaneNum: integer;
      s := sa[J];
      s := Trim(s);
      LaneNum := StrToIntDef(s, 0);
      if LaneNum > 0 then
      begin
        if Settings.ab_ExcludeOutsideLanes then
        begin
          if (LaneNum <> 1) and (LaneNum <> uSwimClub.NumberOfLanes) then
          begin
            fLaneCount := fLaneCount - 1;
            Insert(LaneNum,ArrayLanesExclude, 0);
          end;
        end
        else
        begin
          fLaneCount := fLaneCount - 1;
          Insert(LaneNum,ArrayLanesExclude, 0);
        end;
      end;
    end;
  end;
  if fLaneCount > 0  then result := fLaneCount;
end;

procedure TABINDV.Seeding_Circle(HeatNumber: Integer);
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
      var LaneNum: integer;
      LaneNum := 0;
      // keep repeating loop across heat while...
      while not ABData.qryUnplacedNominees.EOF and (LaneNum < fSeedDepth) do
      begin
        for fHeatNum := 0 to fSeedDepth-1 do // cloop across heats..
        begin
          if ABData.qryUnplacedNominees.EOF then break;
          // .. seeding nominee swimmers into heats
          ArrayLanes[fHeatNum][LaneNum] := ABData.qryUnplacedNominees.FieldByName('NomineeID').AsInteger;
          ABData.qryUnplacedNominees.Next;
        end;
        Inc(LaneNum, 1);
      end;
      fHeatCount := fHeatCount - fSeedDepth;
    end;
  END;
end;

procedure TABINDV.Seeding_Default(HeatNumber: Integer);
var
  I: Integer;
begin

  // DEFAULT SEEDING ....
  if fHeatNum < fHeatCount-1 then
  begin
    // complete seeding the remain lanes using default method
      var LaneNum: integer;
      LaneNum := 0;
      // keep repeating loop across heat while...
      while not ABData.qryUnplacedNominees.EOF and (LaneNum < fHeatCount) do
      begin
        for fHeatNum := 0 to fHeatCount-1 do // cloop across heats..
        begin
          for I := 0 to fLaneCount-1 do
          begin
            if ABData.qryUnplacedNominees.EOF then break;
            // .. seeding nominee swimmers into heats
            ArrayLanes[fHeatNum][I] := ABData.qryUnplacedNominees.FieldByName('NomineeID').AsInteger;
            ABData.qryUnplacedNominees.Next;
          end;
        end;
        Inc(LaneNum, 1);
      end;
  end;
end;

end.
