unit uABINDV;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.Math,
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
    function CalcNumberOfHeats(NumOfNominees: Integer): Integer;

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

function TABINDV.AutoBuildExec: Boolean;
var
  msg: string;
  totalNumOfHeats, I, indx, fNumOfHeats: Integer;
begin
  result := false;

  if not Assigned(Settings) then
  begin
    if (fVerbose) then
      MessageDlg('Settings (preferences) not assigned.' + sLineBreak +
        'Auto-Build will abort..', mtError, [mbOK], 0, mbOK);
    fError := true;
    fErrorNum := 1;
    exit;
  end;

  if not uEvent.Assert then
  begin
    if (fVerbose) then
      MessageDlg('No connection or no event found.' + sLineBreak +
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
      MessageDlg('AB Data Module is in-active.' + sLineBreak +
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
  if (uSwimClub.NumberOfLanes < 2) then
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

  // Message disabled for BATCH AUTO-BUILD
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

  // BASIC Auto-Build.
  if (Settings.ab_SeperateGender = false)
    and (Settings.ab_GroupByIndx <= 0) then
  begin
      fNumOfHeats := CalcNumberOfHeats(ABData.qryUnplacedNominees.RecordCount);
      ABData.qryUnplacedNominees.IndexName := 'indxTTB';
      if ABData.qryUnplacedNominees.Filtered then
        ABData.qryUnplacedNominees.Filtered := false;

      for I := 0 to fNumOfHeats-1 do
      begin
        uHeat.NewHeat; // Builds the heat and lanes
        // uUtility.ScatterLanes(indx, uSwimClub.NumberOfLanes)  // Scatter....
        // place the nominee into the lane...
      end;

  end;

  // Filter by gender Auto-Build.
  if (Settings.ab_SeperateGender = true)
    and (Settings.ab_GroupByIndx <= 0) then
  begin
    totalNumOfHeats := 0;
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
        fNumOfHeats := CalcNumberOfHeats(ABData.qryUnplacedNominees.RecordCount);
        totalNumOfHeats := totalNumOfHeats + fNumOfHeats;

        for I := 0 to fNumOfHeats-1 do
        begin
//          uHeat.NewHeat; // Builds the heat and lanes
          // uUtility.ScatterLanes(indx, uSwimClub.NumberOfLanes)  // Scatter....
          // place the nominee into the lane...
        end;

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

function TABINDV.CalcNumberOfHeats(NumOfNominees: Integer): Integer;
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

end.
