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
    pnlG: TPanel;
    procedure actnLn_GenericUpdate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure UpdateUI(DoFullUpdate: boolean = false);
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

procedure TFrameLane.UpdateUI(DoFullUpdate: boolean = false);
begin

  {CASES: after Connection, after change of swimming club, after manage-clubs. }
  if DoFullUpdate then
  begin
    if (not Assigned(SCM2)) or (not SCM2.scmConnection.connected) or
        (not Assigned(CORE)) or (not CORE.IsActive) or (CORE.qrySession.IsEmpty)
        or (CORE.qryEvent.IsEmpty) or (CORE.qryHeat.IsEmpty) then
    begin
      Self.Visible := false;
      exit;
    end;
        { NOTE: grid must be visible to sync + forces re-paint. }
      LockDrawing;
      Self.Visible := true;
      pnlBody.Visible := true;
      pnlG.Visible := true;
      grid.Refresh;
//    grid.BeginUpdate;
//    grid.EndUpdate;
      UnlockDrawing;
  end;


  LockDrawing;
  try

    if CORE.qryHeat.IsEmpty then
    begin
      // CNTRL panel is displayed but not the grid.
      Self.Visible := false;
      exit;
    end;

    if not Visible then Self.Visible := true;

    if not CORE.qryLane.IsEmpty then
    begin
      pnlBody.Visible := true;
      pnlG.Visible := true;
      // Are we making a Connection or changing SwimClubs?
      if CORE.IsWorkingOnConnection then
      begin
        // reset
        // CORE.qryLane.First;
      end
      else
      begin
        ;
      end;
    end;

  finally
    UnlockDrawing;
  end;
end;

end.
