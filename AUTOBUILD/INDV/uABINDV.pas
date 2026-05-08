unit uABINDV;

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  VCL.Dialogs,
  FireDAC.Comp.Client,
  dmSCM2, dmCORE, uSettings,
  dmABINDV,
  uDefines, uSwimClub, uSession, uEvent, uHeat, uLane
  ;

type
  TABINDV = class(TComponent)
  private
    ABData: TABINV;
    fVerbose: boolean;
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
begin
  result := false;

  if not Assigned(Settings) then
  begin
    if (fVerbose) then
      MessageDlg('Settings (preferences) not assigned.' + sLineBreak +
        'Auto-Build will abort..', mtError, [mbOK], 0, mbOK);
    exit;
  end;

  if not uEvent.Assert then
  begin
    if (fVerbose) then
      MessageDlg('No connection or no event found.' + sLineBreak +
        'Auto-Build will abort.', mtError, [mbOK], 0, mbOK);
    exit;
  end;

  if (uEvent.PK = 0) OR (uEvent.GetEventType = etTEAM) then
  begin
    if (fVerbose) then
      MessageDlg('The event type must be INDV.' + sLineBreak +
        'Auto-Build will abort.', mtError, [mbOK], 0, mbOK);
    exit;
  end;

  if not ABData.IsActive then
  begin
    if (fVerbose) then
      MessageDlg('AB Data Module is in-active.' + sLineBreak +
        'Auto-Build will abort.', mtError, [mbOK], 0, mbOK);
    exit;
  end;

  // CLEAN UP HEATS - make readyfor auto build
  if not CORE.qryHeat.IsEmpty then
  begin
    ABData.procDeleteHeats.Connection := SCM2.scmConnection;
    ABData.procDeleteHeats.StoredProcName := 'DeleteAllHeats';
    ABData.procDeleteHeats.ParamByName('@EventID').AsInteger := uEvent.PK;
    ABData.procDeleteHeats.ParamByName('@Exclude').AsBoolean := true;
    ABData.procDeleteHeats.Prepare;
    ABData.procDeleteHeats.ExecProc;
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

constructor TABINDV.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fVerbose := true;
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

end.
