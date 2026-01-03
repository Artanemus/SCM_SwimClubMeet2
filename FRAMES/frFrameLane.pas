unit frFrameLane;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Actions,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.Grids, Vcl.ImgList, Vcl.ActnList, Vcl.Menus, Vcl.Buttons,

  Data.DB,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmIMG, dmSCM2, dmCORE, uDefines  ;

type
  TFrameLane = class(TFrame)
    rpnlCntrl: TRelativePanel;
    spbtnMoveUp: TSpeedButton;
    actnlistLane: TActionList;
    pumenuLane: TPopupMenu;
    pnlBody: TPanel;
    grid: TDBAdvGrid;
    spbtnMoveDown: TSpeedButton;
    spbtnSwitch: TSpeedButton;
    spbtnDelete: TSpeedButton;
    spbtnDeleteForever: TSpeedButton;
    actnLn_MoveUp: TAction;
    actnLn_MoveDown: TAction;
    actnLn_Swap: TAction;
    actnLn_Delete: TAction;
    actnLn_DeleteForever: TAction;
    actnln_Report: TAction;
    ShapeLnBar1: TShape;
    spbtnReport: TSpeedButton;
    procedure actnLn_GenericUpdate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure InitialiseUI;
    procedure InitialiseDB;

    // messages must be forwarded by main form.
    procedure Msg_SCM_Scroll_Session(var Msg: TMessage); message SCM_SCROLL_SESSION;
    procedure Msg_SCM_Scroll_Event(var Msg: TMessage); message SCM_SCROLL_EVENT;
    procedure Msg_SCM_Scroll_Heat(var Msg: TMessage); message SCM_SCROLL_HEAT;
    procedure Msg_SCM_Scroll_Lane(var Msg: TMessage); message SCM_SCROLL_LANE;

  end;

implementation

{$R *.dfm}

uses
  uSession, uEvent, uHeat;

procedure TFrameLane.actnLn_GenericUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
  Assigned(CORE) and CORE.IsActive and
  not CORE.qryHeat.IsEmpty then
  begin
    if uSession.IsUnLocked and uHeat.IsOpened then
      DoEnable := true;
  end;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameLane.InitialiseDB;
begin
  ;
end;

procedure TFrameLane.InitialiseUI;
begin
  grid.Visible := false;
  pnlBody.Caption := '';
  if not Assigned(SCM2) or not SCM2.scmConnection.connected then exit;
  if not Assigned(CORE) or not CORE.IsActive then exit;

  // NOTE:
  // Originally - using grid.pagemode := false; to clear the grid of rows.
  grid.Visible := not CORE.qryLane.IsEmpty();
  if (not CORE.qryHeat.IsEmpty()) and CORE.qryLane.IsEmpty() then
    pnlBody.Caption := 'Use NEW to get started with Lanes.';
  // if CORE.IsWorkingOnConnection = true, then safe to call here...
  // without the DB 'frame AfterScoll' messages.
  if CORE.IsWorkingOnConnection then
    InitialiseDB;
end;

procedure TFrameLane.Msg_SCM_Scroll_Event(var Msg: TMessage);
begin
  {TODO -oBSA -cGeneral : Complete...}
end;

procedure TFrameLane.Msg_SCM_Scroll_Heat(var Msg: TMessage);
begin
  {TODO -oBSA -cGeneral : Complete...}
end;

procedure TFrameLane.Msg_SCM_Scroll_Lane(var Msg: TMessage);
begin
  grid.BeginUpdate; // forces a re-paint of grid.
  if SCM2.scmConnection.Connected and CORE.IsActive then
    grid.Visible := not CORE.qryLane.IsEmpty
  else
    grid.Visible := false;
  grid.EndUpdate;
end;

procedure TFrameLane.Msg_SCM_Scroll_Session(var Msg: TMessage);
begin
  {TODO -oBSA -cGeneral : Complete...}
end;

end.
