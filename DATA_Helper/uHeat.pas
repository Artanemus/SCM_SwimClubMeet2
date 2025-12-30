unit uHeat;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  System.Variants, System.VarUtils,
  System.StrUtils,
  vcl.Dialogs, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Error, FireDAC.Stan.Param,

  dmCORE, dmSCM2, uDefines,
  uUtility;


function Assert: boolean;
function ClearLanes(DoExclude: Boolean = true): integer;
function CountLanes: integer;
function DeleteHeat(DoExclude: Boolean = true): boolean;
function DeleteLanes: boolean;
function GetHeatID: integer; // Assert - SAFE.
function HeatStatusID: integer;
function IsClosed(): Boolean;
function IsRaced(): Boolean;
function IsOpened(): Boolean;
function LastHeatNum: integer;
function Locate(aHeatID: integer): Boolean;
function NextID(aHeatID: integer): integer; // uses HeatNum
function PK(): integer; // NO CHECKS. RTNS: Primary key.
function PrevID(aHeatID: integer): integer; // uses HeatNum
function RenumberLanes(DoLocate: Boolean = true): integer; deprecated;
function RenumberLanesAdv(DoLocate: Boolean = true): integer;
function RenumberLanesAdvINDV(DoLocate: Boolean = true): integer;
function RenumberLanesAdvTEAM(DoLocate: Boolean = true): integer;
function PadLanes()	: integer;
function TrimLanes(DoExclude: Boolean = true): integer;
//function ClearGutters(DoExclude: Boolean = true): integer;
procedure NewHeat();
procedure ToggleStatus(); // current heat


implementation

uses
	uSwimClub, uSession, uEvent, uLane; //, uLane;


procedure DetailTBLs_DisableCNTRLs;
begin
  CORE.qrySplitTime.DisableControls;
  CORE.qryWatchTime.DisableControls;
  CORE.qryLane.DisableControls;
end;

procedure DetailTBLs_EnableCNTRLs;
begin
  CORE.qryLane.DisableControls;
  CORE.qrySplitTime.DisableControls;
  CORE.qryWatchTime.DisableControls;
end;

procedure DetailTBLs_ApplyMaster;
begin
  if CORE.qryHeat.RecordCount <> 0 then
  begin
    CORE.qryLane.ApplyMaster;
    if CORE.qryLane.RecordCount <> 0 then
    begin
      CORE.qryWatchTime.ApplyMaster;
      CORE.qrySplitTime.ApplyMaster;
    end;
  end;
end;

function Assert(): boolean;
begin
  result := false;
  if Assigned(CORE) then
    if CORE.qryHeat.Active then
      if not CORE.qryHeat.IsEmpty then
        result := true;
end;

function ClearLanes(DoExclude: Boolean = true): integer;
var
  aHeatStatusID: integer;
begin
  result := 0;
  if uSession.IsLocked then exit;
  aHeatStatusID := uHeat.HeatStatusID();
  if (aHeatStatusID = 1) or (DoExclude = false) then
  begin
    ;
  end;
end;

function CountLanes: integer;
var
  SQL: string;
  v: variant;
begin
  result := 0;
  // Count number of lanes ....
  SQL := 'SELECT Count(LaneID) FROM SwimClubMeet2.dbo.Lane WHERE Lane.HeatID = :ID';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uHeat.PK]);
  if not VarIsNull(v) or not VarIsEmpty(v) then result := v;
end;

function DeleteLanes: boolean;
var
  done: boolean;
begin
  result := false;
  // Not permitted to delete anything if session is locked.
  if uSession.IsLocked() then exit;
  CORE.qryLane.DisableControls;
  try
    // D E L E T E   L A N E S .
    CORE.qryLane.ApplyMaster; // ASSERT MASTER-DETAILED.
    CORE.qryLane.First;
    while not eof do
    begin
      // deletes watch-times and split-times and finally the lane.
      done := uLane.DeleteLane();
      if done then
        continue
      else
        CORE.qryLane.Next;
    end;
  finally
    if CORE.qryLane.IsEmpty then result := true;
    CORE.qryLane.EnableControls;
  end;
end;

function DeleteHeat(DoExclude: Boolean = true): boolean;
var
  doRenumber: boolean;
begin
  result := false;
  doRenumber := false;
  // Not permitted to DeleteHeat events if session is locked.
  if uSession.IsLocked() then exit;
  // Can't delete heat if 'raced' or 'closed', UNLESS DoExclude = false.
  if (uHeat.HeatStatusID() = 1) or (DoExclude = false) then
  begin
    //if (uHeat.HeatStatusID() = 1) or (DoExclude = false) then


    CORE.qryLane.DisableControls;
    try
      doRenumber := uHeat.DeleteLanes();
      // ASSERT that all heats have been removed within Master-Detail relationship.
      // Can't delete remaining dependants if heats are retained.
      if (CORE.qryLane.IsEmpty) then
      begin
        try
          CORE.qryHeat.Delete; // Finally.. delete heat.
          doRenumber := true;
          result := true;
        except on E: Exception do
          // If the dataset is inactive, Delete raises an exception.
        end;
      end
    finally
      if doRenumber then
        uHeat.RenumberLanes(false); // don't relocate  ... depreciated
      CORE.qryLane.ApplyMaster;
      CORE.qryLane.EnableControls;
    end;
  end;
end;

function GetHeatID: integer;
begin
  result := 0;
  if uHeat.Assert then // Assert.
      result := CORE.qryLane.FieldByName('HeatID').AsInteger;
end;

function HeatStatusID: integer;
begin
  result := CORE.qryHeat.FieldByName('HeatStatusID').AsInteger;
end;

function IsClosed: Boolean;
var
  HeatStatusID: integer;
begin
  result := false;
  HeatStatusID := CORE.qryHeat.FieldByName('HeatStatusID').AsInteger;
  if (HeatStatusID = 3) then result := true;
end;

function IsRaced: Boolean;
var
  HeatStatusID: integer;
begin
  result := false;
  HeatStatusID := CORE.qryHeat.FieldByName('HeatStatusID').AsInteger;
  if (HeatStatusID = 2) then result := true;
end;

function IsOpened(): Boolean;
var
  HeatStatusID: integer;
begin
  result := false;
  HeatStatusID := CORE.qryHeat.FieldByName('HeatStatusID').AsInteger;
  if (HeatStatusID = 1)  or (HeatStatusID = 0) then result := true;
end;


function LastHeatNum: integer;
var
  SQL: string;
  v: variant;
begin
  result := 0;
  if not Assigned(SCM2) and SCM2.scmConnection.Connected  then exit;
  SQL := 'SELECT MAX(HeatNum) FROM SwimClubMeet2.dbo.Heat ' +
  'WHERE Heat.EventID = :ID';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uEvent.PK()]);
  if not VarIsNull(v) and not VarIsEmpty(v) and (v > 0) then result := v;
end;

function Locate(aHeatID: integer): Boolean;
var
  SearchOptions: TLocateOptions;
begin
  result := false;
  if (aHeatID = 0) then exit;
  SearchOptions := [];
  result := CORE.qryHeat.Locate('HeatID', aHeatID, SearchOptions);
end;

function PadLanes()	: integer;
var
  laneCount: integer;
begin
  result := 0;
  if CORE.qryHeat.IsEmpty then exit;
  laneCount := uHeat.CountLanes();
  if laneCount < uSwimClub.NumberOfLanes() then
  begin
    repeat
      {
        uLane.NewLane();
      }
      Inc(laneCount);
    until laneCount = uSwimClub.NumberOfLanes();
  end;
end;

function PrevID(aHeatID: integer): integer;
begin
  result := 0;
  // get the previuos heat in the event  (uses HeatNum)
  // BSA wip .. Move into query uHeat
  (*
  SCM2.qryGetPrevHeat.Connection := SCM2.scmConnection;
  SCM2.qryGetPrevHeat.ParamByName('HEATID').AsInteger := aHeatID;
  SCM2.qryGetPrevHeat.Prepare;
  SCM2.qryGetPrevHeat.Open;
  if SCM2.qryGetPrevHeat.Active and (SCM2.qryGetPrevHeat.RecordCount > 0) then
    result := SCM2.qryGetPrevHeat.FieldByName('HeatID').AsInteger;
  *)
end;

function PK(): integer;
begin // NO CHECKS. quick and dirty - primary key result.
  result := CORE.qryHeat.FieldByName('HeatID').AsInteger;
end;

function NextID(aHeatID: integer): integer;
begin
  result := 0;
  // get the next heat in the event  (uses HeatNum)
  // BSA wip .. Move into query uHeat
  (*
  SCM2.qryGetNextHeat.Connection := SCM2.scmConnection;
  SCM2.qryGetNextHeat.ParamByName('HEATID').AsInteger := aHeatID;
  SCM2.qryGetNextHeat.Prepare;
  SCM2.qryGetNextHeat.Open;
  if SCM2.qryGetNextHeat.Active and (SCM2.qryGetNextHeat.RecordCount > 0) then
    result := SCM2.qryGetNextHeat.FieldByName('HeatID').AsInteger;
  *)
end;

procedure NewHeat;
var
  fld: TField;
  aHeatNum: integer;
begin
  fld := nil;
  if CORE.qryEvent.IsEmpty then exit;
  try
    aHeatNum := uHeat.LastHeatNum();
    Inc(aHeatNum);
    CORE.qrySplitTime.DisableControls;
    CORE.qryWatchTime.DisableControls;
    CORE.qryLane.DisableControls();
    CORE.qryHeat.DisableControls();
    fld := CORE.qryHeat.FindField('HeatNum');
    if Assigned(fld) then fld.ReadOnly := false;
    try
      CORE.qryHeat.Insert;
      CORE.qryHeat.FieldByName('EventID').AsInteger := uEvent.PK;
      CORE.qryHeat.FieldByName('HeatNum').AsInteger := aHeatNum;
      CORE.qryHeat.FieldByName('HeatTypeID').AsInteger := 1; // Preliminary.
      CORE.qryHeat.FieldByName('HeatStatusID').AsInteger := 1; // Open.
      CORE.qryHeat.Post;
      uHeat.PadLanes();
    except on E: Exception do
        CORE.qryHeat.Cancel;
    end;
  finally
    if Assigned(fld) then fld.ReadOnly := true;
    CORE.qryHeat.EnableControls();
    CORE.qryLane.ApplyMaster;
    CORE.qryLane.EnableControls();
    CORE.qrySplitTime.ApplyMaster;
    CORE.qryWatchTime.ApplyMaster;
    CORE.qrySplitTime.EnableControls;
    CORE.qryWatchTime.EnableControls;
  end;
end;

function RenumberLanes(DoLocate: Boolean = true): integer; deprecated;
var
  aLaneID: integer;
begin
  result := 0;
  aLaneID := 0;
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  if CORE.dsHeat.DataSet.IsEmpty then exit;
  CORE.qryLane.DisableControls;
  CORE.qryHeat.DisableControls;
  try
    if DoLocate then
      aLaneID := uHeat.PK;
  // BSA wip .. Move into query uHeat
  (*
    SCM2.procRenumberLanes.Params[1].Value := uHeat.PK;
    SCM2.procRenumberLanes.Prepare;
    SCM2.procRenumberLanes.ExecProc;
  *)
  finally
    CORE.qryHeat.ApplyMaster;
    if DoLocate then
      uHeat.Locate(aLaneID);
    CORE.qryHeat.EnableControls;
    CORE.qryLane.EnableControls;
  end;
end;

function RenumberLanesAdv(DoLocate: Boolean = true): integer;
var
evType: scmEventType;
begin
  result := 0;
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  if CORE.dsHeat.DataSet.IsEmpty then exit;
  CORE.qryWatchTime.DisableControls;
  CORE.qrySplitTime.DisableControls;
  CORE.qryLane.DisableControls;
  CORE.qryHeat.DisableControls;
  try
  { if DoLocate then aLaneID := uLane.PK; }
  evType := uEvent.getEventType;
  if evType = scmEventType.etINDV then
    result := uHeat.RenumberLanesAdvINDV(true) // do relocate.
  else if evType = scmEventType.etTeam then
    result := uHeat.RenumberLanesAdvTEAM(true) // do relocate.
  finally
    {if DoLocate then
      uLane.Locate(aLaneID); }
    CORE.qryWatchTime.ApplyMaster;
    CORE.qrySplitTime.ApplyMaster;
    CORE.qryHeat.EnableControls;
    CORE.qryLane.EnableControls;
    CORE.qryWatchTime.EnableControls;
    CORE.qrySplitTime.EnableControls;
  end;
end;

function RenumberLanesAdvINDV(DoLocate: Boolean = true): integer;
var
  laneNum, i: integer;
  qry: TFDQuery;
  SQL: string;
begin
  result := 0;
  i := 0;
  try
    {if DoLocate then aLaneID := uLane.PK;}
    qry := TFDQuery.Create(CORE);
    qry.Connection := SCM2.scmConnection;
    {
      SwimClubMeet2.dbo.Nominee joined on SwimClubMeet2.dbo.Lane.NomineeID (FK).
      If Lane.NomineeID is null then the lane is empty.
      If the Lane.NomineeID is not null then a swimmer has been assigned to lane.
      NOTE: Assumed: TTBs have been calculated.
      Build an ordered list of lanes in this order ...
        Place swimmers with TTB first (sorted on TTB - fastest to slowest)...
        followed by swimmers with no TTB ...
        followed by empty lanes.
    }
    SQL := '''
      Lane.LaneID,
      SELECT
        -- TTB - estimated race time for the swimmer in the lane.
        CASE
          WHEN (Lane.NomineeID IS NULL) THEN 0
          WHEN (Lane.NomineeID IS NOT NULL) AND
            (Nominee.TTB IS NOT NULL) THEN Nominee.TTB
          ELSE 0
        END AS TTB,

        CASE
          WHEN (Lane.NomineeID IS NULL) THEN 2
          -- Nominee but no data.
          WHEN (Lane.NomineeID IS NOT NULL)
            AND (CAST(CAST(Nominee.TTB AS DATETIME) AS FLOAT) = 0) THEN 1
          -- Nominee with TTB data.
          ELSE 0
        END AS SortOn,
        Lane.LaneNum,
        Lane.NomineeID
        FROM SwimClubMeet2.dbo.Lane
        LEFT JOIN Nominee ON Lane.NomineeID = Nominee.NomineeID
        -- TFDQuery param
        WHERE Lane.HeatID = :HEATID
        ORDER BY SortOn ASC, TTB DESC;
      ''';

//  qry.UpdateOptions.KeyFields := 'LaneID';
//  qry.UpdateOptions.UpdateTableName := 'SwimClubMeet2..Lane';

  qry.SQL.Text := SQL;
  qry.IndexFieldNames := 'SortOn;TTB';
  qry.ParamByName('HEATID').AsInteger := uHeat.PK; // only lanes in this heat
  qry.Prepare;
  qry.Open;
  if qry.Active then
  begin
    // Perform a scatter of lanes. Fastest are in center lanes. Slowest
    // are in outer lanes. Empty lanes are most outer.
    i := 0; // NOTE: ScatterLanes is based 0
    while not qry.Eof do
    begin
      laneNum := uUtility.ScatterLanes(i, uSwimClub.NumberOfLanes);
      {
      if uLane.Locate(qry.FieldByName('LaneID').AsInteger) then
      begin
        try
          CORE.qryLane.Edit;
          CORE.qryLane.FieldByName('LaneNum').AsInteger :=
            qry.FieldByName('laneNum').AsInteger;
          CORE.qryLane.Post;
        except on E: Exception do
            CORE.qryLane.Cancel;
        end;
      end;
      }
      i := i + 1;
      qry.Next;
    end;
    qry.free;
  end;

  finally
    result := i;
  end;
end;

function RenumberLanesAdvTeam(DoLocate: Boolean = true): integer;
var
  aLaneID, laneNum, i: integer;
  qry: TFDQuery;
  SQL: string;
begin
  result := 0;
  i := 0;
  try
    {if DoLocate then aLaneID := uLane.PK;}
    qry := TFDQuery.Create(CORE);
    qry.Connection := SCM2.scmConnection;
    {
      SwimClubMeet2.dbo.Nominee joined on SwimClubMeet2.dbo.Lane.NomineeID (FK).
      If Lane.NomineeID is null then the lane is empty.
      If the Lane.NomineeID is not null then a swimmer has been assigned to lane.
      NOTE: Assumed: TTBs have been calculated.
      Build an ordered list of lanes in this order ...
        Place swimmers with TTB first (sorted on TTB - fastest to slowest)...
        followed by swimmers with no TTB ...
        followed by empty lanes.
    }
    SQL := '''
      Lane.LaneID,
      SELECT
        -- Estimated race time for the swimmer in the lane.
        CASE
          WHEN (Lane.TeamID IS NULL) THEN 0
          WHEN (Lane.TeamID IS NOT NULL) AND
            (Team.TTB IS NOT NULL) THEN Team.TTB
          ELSE 0
        END AS TTB,

        CASE
          WHEN (Lane.TeamID IS NULL) THEN 2
          -- Team but no data.
          WHEN (Lane.TeamID IS NOT NULL)
            AND (CAST(CAST(Team.TTB AS DATETIME) AS FLOAT) = 0) THEN 1
          -- Team with TTB data.
          ELSE 0
        END AS SortOn,
        Lane.LaneNum,
        Lane.TeamID
        FROM SwimClubMeet2.dbo.Lane
        LEFT JOIN Team ON Lane.TeamID = Team.TeamID
        -- TFDQuery param
        WHERE Lane.HeatID = :HEATID
        ORDER BY SortOn ASC, TTB DESC;
      ''';

//  qry.UpdateOptions.KeyFields := 'LaneID';
//  qry.UpdateOptions.UpdateTableName := 'SwimClubMeet2..Lane';

  qry.SQL.Text := SQL;
  qry.IndexFieldNames := 'SortOn;TTB';
  qry.ParamByName('HEATID').AsInteger := uHeat.PK; // only lanes in this heat
  qry.Prepare;
  qry.Open;
  if qry.Active then
  begin
    // Perform a scatter of lanes. Fastest are in center lanes. Slowest
    // are in outer lanes. Empty lanes are most outer.
    i := 0; // NOTE: ScatterLanes is based 0
    while not qry.Eof do
    begin
      laneNum := uUtility.ScatterLanes(i, uSwimClub.NumberOfLanes);
      {
      if uLane.Locate(qry.FieldByName('LaneID').AsInteger) then
      begin
        try
          CORE.qryLane.Edit;
          CORE.qryLane.FieldByName('LaneNum').AsInteger :=
            qry.FieldByName('laneNum').AsInteger;
          CORE.qryLane.Post;
        except on E: Exception do
            CORE.qryLane.Cancel;
        end;
      end;
      }
      i := i + 1;
      qry.Next;
    end;
    qry.Free;
  end;

  finally
    result := i;
  end;
end;

procedure ToggleStatus;
var
  i: integer;
begin
  DetailTBLs_DisableCNTRLs;
  CORE.qryHeat.DisableControls;
  try
    begin
      CORE.qryHeat.CheckBrowseMode;
      i := CORE.qryHeat.FieldByName('HeatStatusID').AsInteger;
      try
        begin
          CORE.qryHeat.Edit;
          case i of
            1:
              // toggle to RACED ...
              CORE.qryHeat.FieldByName('HeatStatusID').AsInteger := 2;
            2:
              begin
                // toggle to CLOSED ...
                CORE.qryHeat.FieldByName('HeatStatusID').AsInteger := 3;
                // 22.09.2020 TimeStamp
                CORE.qryHeat.FieldByName('CloseDT').AsDateTime := Now;
              end;
          else
            // toggle to OPEN ...
            CORE.qryHeat.FieldByName('HeatStatusID').AsInteger := 1;
          end;
          CORE.qryHeat.Post;
          // CHECK .... CORE.qryEvent.Refresh; // updates icons?
        end;
      except on E: EFDDBEngineException do
        begin
          CORE.qryEvent.Cancel;
          SCM2.FDGUIxErrorDialog.Execute(E);
        end;
      end;
    end;
  finally
    CORE.qryHeat.EnableControls;
    DetailTBLs_EnableCNTRLs;
  end;
end;

function TrimLanes(DoExclude: Boolean = true): integer;
var
  NumOfLanes, Lanes, aHeatStatusID: integer;
begin
  // NOTE: if renumbering is needed, this must be done by caller.
  result := 0;
  if uSession.IsLocked() then exit;
  if (uHeat.HeatStatusID = 1) or (DoExclude = false) then
  begin // Remove excess lanes.
    NumOfLanes := uSwimClub.NumberOfLanes; // number of lanes in club pool.
    Lanes := CountLanes();
    if Lanes > NumOfLanes then
    begin
      CORE.qryLane.DisableControls;

      try
        CORE.qryLane.First;
        // pass 1: look for empty swimming lanes.
        while not CORE.qryLane.eof do
        begin
          if CORE.qryLane.FieldByName('TeamID').IsNull and
          CORE.qryLane.FieldByName('NomineeID').IsNull then
          begin
            {
            if uLane.DeleteLane() then // candidate for delete.
            begin
              Dec(Lanes);
              if Lanes <= NumOfLanes then
                break
              else
                continue;
            end
            else
              CORE.qryLane.next;
            }
          end
          else
            CORE.qryLane.next;
        end;

        if Lanes > NumOfLanes then
        begin
          // pass 2: trim from end...
        end;


      finally
        CORE.qryLane.EnableControls;
      end;
    end;
  end;
end;



end.

