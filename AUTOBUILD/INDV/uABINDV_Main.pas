unit uABINDV_Main;

interface

uses
  System.SysUtils, System.Classes, VCL.Dialogs,
  FireDAC.Comp.Client,
  dmSCM2, dmCORE, uSettings, uHeats,
  dmABINDV_Data ;

type
  TABHeatsINDV = class(TComponent)
  private
    dmData: TABINV_Data;
    fVerbose: boolean;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    function Prepare(AConnection: TFDConnection): Boolean;
    function AutoBuild_INDV_Heats(EventID: Integer): Boolean;

  end;


implementation

function TABHeatsINDV.Prepare(AConnection: TFDConnection): Boolean;
begin
  // TODO -cMM: Prepare default body inserted
  Result := false;
  if Assigned(AConnection) then
  begin
    dmData.ActivateData;
    if dmData.IsActive then
      Result := true;
  end;
end;

function TABHeatsINDV.AutoBuild_INDV_Heats(EventID: Integer): Boolean;
var
  SQL: string;
begin
  result := false;

  if (EventID = 0) then
  begin
    if (fVerbose) then
      MessageDlg('The event ID was invalid.' + sLineBreak +
        'Auto-Build Heats will abort.', mtError, [mbOK], 0, mbOK);
    exit;
  end;


  // CLEAN UP HEATS - make readyfor auto build
  if not CORE.qryHeat.IsEmpty then
  begin
    // EXCLUDE RACED OR CLOSED HEATS
    SQL := 'EXEC dbo.DeleteAllHeats(:ID1, ID2)';
    // ID1 EventID, ID2 1       '
    // uEvent.DeleteHeats(EventID, true); // also renumbers heats.
    // qryOrderedHeatList(EventID); // Not needed? ommit...
  end;

  if not dmData.IsActive then
  begin
    if (fVerbose) then
      MessageDlg('No database connection!' + sLineBreak +
        'Auto-Build Heats will abort..', mtError, [mbOK], 0, mbOK);
    exit;
  end;

  if not Assigned(Settings) then
  begin
    if (fVerbose) then
      MessageDlg('Settings (preferences) not intialised!' + sLineBreak +
        'Auto-Build Heats will abort..', mtError, [mbOK], 0, mbOK);
    exit;
  end;

  if Assigned(Settings) and dmData.IsActive then
  begin
    // Removed ALL opened heats (raced and closed remain.)
  if not AssertConnection then
  begin
  end;


  if (prefSeedMethod = smDualSeeding) then
  begin
    if (Verbose) then
      MessageDlg('The event selected is an individual event.' + sLineBreak +
        'Dual seeding can only be applied to teamed events (relays).' +
        sLineBreak + 'Auto-Build Heats will abort.', mtError, [mbOK], 0, mbOK);
    exit;
  end;

  if (prefSeedMethod = smMastersChampionSeeding) then
  begin
    if (Verbose) then
      MessageDlg('Master Champion seeding is in development' + sLineBreak +
        'and was made not available for this build.' + sLineBreak +
        'Auto-Build Heats will abort.', mtError, [mbOK], 0, mbOK);
    exit;
  end;

  // G R O U P B Y   D I V I S I O N S . . .
  if (prefGroupBy = 3) then
  begin
    if (Verbose) then
      MessageDlg('GroupBy Divisions is in development' + sLineBreak +
        'and was made not available for this build.' + sLineBreak +
        'Auto-Build Heats will abort.', mtError, [mbOK], 0, mbOK);
    exit;
  end;

  // TODO : Test/Locate SwimClubID ... for future multi-club DB.
  numOfSwimmingLanes := GetNumOfSwimmingLanes(NumberOfPoolLanes,
    prefExcludeOutsideLanes);

  // There must be a least 2 lanes for the scatter algorithm.
  if (numOfSwimmingLanes < 2) then
  begin
    if (Verbose) then
    begin
      s := '';
      s := s + 'Your pool needs at least two swimming lanes' + sLineBreak +
        'else the scatter algorithm cannot run.' + sLineBreak +
        'Is the Club''s number of pool lanes correctly assigned?' + sLineBreak +
        'Auto-Build Heats will abort.';
      MessageDlg(s, mtError, [mbOK], 0, mbOK);
    end;
    exit;
  end;

  // FROM THIS POINT ...
  // Auto-Build must return true as the grids need a refresh.
  // *******************************************************
  result := true;
  // *******************************************************


  {
    With Heats CLEANED ....
    Count the number of Nominees to be placed into lanes.
    EXCLUDES pre-placed nominees in closed or raced heats
  }



  end;
end;

constructor TABHeatsINDV.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // TODO -cMM: TABHeatsINDV.Create default body inserted
  dmData := TABINV_Data.Create(Self);
end;

destructor TABHeatsINDV.Destroy;
begin
  // TODO -cMM: TABHeatsINDV.Destroy default body inserted
  dmData.DeActivateData;
  dmData.Free;
  inherited;
end;

end.
