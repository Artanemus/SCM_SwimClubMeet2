unit frFrameHeat;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.Grids, Vcl.ImgList,

  Data.DB,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmIMG, dmSCM2, dmCORE, System.Actions, Vcl.ActnList, Vcl.Menus, Vcl.Buttons,

  uSession, uEvent, uHeat, uDefines, Vcl.StdCtrls;

type
{
  // 1. THE INTERCEPTER MUST GO HERE (Before the TFrame declaration)
  TSpeedButton = class(Vcl.Buttons.TSpeedButton)
  protected
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
  end;
}

  TFrameHeat = class(TFrame)
    rpnlCntrl: TRelativePanel;
    pnlBody: TPanel;
    grid: TDBAdvGrid;
    actnlistHeat: TActionList;
    pumenuHeat: TPopupMenu;
    actnHt_MoveUp: TAction;
    actnHt_MoveDown: TAction;
    actnHt_ToggleStatus: TAction;
    actnHt_New: TAction;
    actnHt_Delete: TAction;
    actnHt_AutoBuild: TAction;
    actnHt_MarshallSheet: TAction;
    actnHt_TimeKeeperSheets: TAction;
    actnHt_SheetSet: TAction;
    actnHt_Report: TAction;
    spbtnMoveUp: TSpeedButton;
    spbtnMoveDown: TSpeedButton;
    spbtnToggleStatus: TSpeedButton;
    spbtnNew: TSpeedButton;
    spbtnDelete: TSpeedButton;
    ShapeHtBar1: TShape;
    spbtnAutoBuild: TSpeedButton;
    ShapeHtBar2: TShape;
    spbtnMarshall: TSpeedButton;
    spbtnTimeKeeper: TSpeedButton;
    spbtnAllLogs: TSpeedButton;
    ShapeHtBar3: TShape;
    spbtnReport: TSpeedButton;
    actnHt_AutoBuildAll: TAction;
    actnHt_AllMarshallSheets: TAction;
    actnHt_AllTimeKeeperSheets: TAction;
    actnHt_Renumber: TAction;
    MoveUp1: TMenuItem;
    MoveDown1: TMenuItem;
    oggleStatus1: TMenuItem;
    New1: TMenuItem;
    Delete1: TMenuItem;
    AutoBuild1: TMenuItem;
    MarshallSheet1: TMenuItem;
    ALLTimeKeeperSets1: TMenuItem;
    SheetSet1: TMenuItem;
    HeatReport1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    lblMsgEmpty: TLabel;
    procedure actnHt_GenericUpdate(Sender: TObject);
    procedure actnHt_ToggleStatusExecute(Sender: TObject);
    procedure gridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
    procedure gridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure gridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState:
        TGridDrawState; ABrush: TBrush; AFont: TFont);
  private
    { Private declarations }
  public
    procedure InitialiseDB;
    procedure InitialiseUI;
    // messages must be forwarded by main form.
    procedure Msg_SCM_Scroll_Heat(var Msg: TMessage); message SCM_SCROLL_HEAT;
    procedure Msg_SCM_Scroll_Event(var Msg: TMessage); message SCM_SCROLL_Event;

  end;

implementation

{$R *.dfm}
procedure TFrameHeat.InitialiseDB;
begin
  ;
end;

procedure TFrameHeat.InitialiseUI;
begin
  grid.Visible := false;
  lblMsgEmpty.Caption := '';
  lblMsgEmpty.Visible := false;
  if not Assigned(SCM2) or not SCM2.scmConnection.connected then exit;
  if not Assigned(CORE) or not CORE.IsActive then exit;

  // NOTE:
  // Originally - using grid.pagemode := false; to clear the grid of rows.
  grid.Visible := not CORE.qryHeat.IsEmpty();
  if (not CORE.qryEvent.IsEmpty()) and CORE.qryHeat.IsEmpty() then
  begin
    lblMsgEmpty.Caption := 'Use AUTOBUILD or NEW to get started with heats.';
    lblMsgEmpty.Visible := true;
  end;
  // if CORE.IsWorkingOnConnection = true, then safe to call here...
  // without the DB 'frame AfterScoll' messages.
  if CORE.IsWorkingOnConnection then
    InitialiseDB;
end;


procedure TFrameHeat.Msg_SCM_Scroll_Event(var Msg: TMessage);
begin
  LockDrawing; // forces a repaint of the frame...
  try
    if SCM2.scmConnection.Connected and CORE.IsActive then
    begin
      pnlBody.Visible := not CORE.qryEvent.IsEmpty;
      if not CORE.qryHeat.IsEmpty() then
        grid.Visible := true;
    end
    else
      pnlBody.Visible := false;
  finally
    UnlockDrawing;
  end;
end;

procedure TFrameHeat.Msg_SCM_Scroll_Heat(var Msg: TMessage);
begin
  // Depreciated:
  // setting pagemode to false clears grid of text. (it appears empty)
  // Set pagemode to the default 'editable' fetch records mode.

  grid.beginUpdate; // forces a repaint of grid...
  if SCM2.scmConnection.Connected and CORE.IsActive then
    grid.Visible := not CORE.qryHeat.IsEmpty
  else
    grid.Visible := false;
  grid.EndUpdate;
end;

procedure TFrameHeat.actnHt_GenericUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryHeat.IsEmpty then
  begin
//    if not uSession.IsLocked then
      DoEnable := true;
  end;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameHeat.actnHt_ToggleStatusExecute(Sender: TObject);
begin
  uHeat.ToggleStatus;
end;

procedure TFrameHeat.gridCanEditCell(Sender: TObject; ARow, ACol: Integer; var
    CanEdit: Boolean);
begin
  // no editing done here...
  CanEdit := false;
end;

procedure TFrameHeat.gridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect:
    TRect; State: TGridDrawState);
var
  G: TDBAdvGrid;
  htNum, W, H, txtW, txtH, tx, ty: integer;
  htStr: string;
begin
  G := TDBAdvGrid(Sender);

  if not CORE.IsActive then exit;
  if CORE.qryHeat.IsEmpty then exit;


  if (ARow > G.HeaderRow) and (ACol = 2) then
  begin
      // get the raw stored cell value,
      // irrespective of display transformations.
      htNum := G.AllInts[1, ARow];
      htStr := IntToStr(htNum);
      if htStr.IsEmpty then htStr := '?';
      W := Rect.Width;
      H := Rect.Height;
      // calculate and scale font to fit inside icon
      G.Canvas.Font.Style := [fsBold];
      G.Canvas.Font.Size := 24;
      while (G.Canvas.TextWidth(htStr) > (W - 4))
          and (G.Canvas.Font.Size > 6) do
        G.Canvas.Font.Size := G.Canvas.Font.Size - 1;
      txtW := G.Canvas.TextWidth(htStr);
      txtH := G.Canvas.TextHeight(htStr);
      tx := Rect.Left + 1 + ((W - txtW) div 2);
      ty := Rect.Top + 1 + ((H - txtH) div 2);
      // draw text directly on canvas
      G.Canvas.Font.Color := clWebSeashell;
      G.Canvas.Brush.Style := bsClear;
      G.Canvas.TextOut(tx, ty, htStr);
  end;

end;

procedure TFrameHeat.gridGetCellColor(Sender: TObject; ARow, ACol: Integer;
    AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  ABrush.Color := $00494131;

end;

end.
