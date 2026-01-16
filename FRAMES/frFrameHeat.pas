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
    actnHt_AllMarshallSheets: TAction;
    actnHt_AllTimeKeeperSheets: TAction;
    actnHt_AutoBuild: TAction;
    actnHt_AutoBuildAll: TAction;
    actnHt_Delete: TAction;
    actnHt_MarshallSheet: TAction;
    actnHt_MoveDown: TAction;
    actnHt_MoveUp: TAction;
    actnHt_New: TAction;
    actnHt_Renumber: TAction;
    actnHt_Report: TAction;
    actnHt_SheetSet: TAction;
    actnHt_TimeKeeperSheets: TAction;
    actnHt_ToggleStatus: TAction;
    actnlistHeat: TActionList;
    ALLTimeKeeperSets1: TMenuItem;
    AutoBuild1: TMenuItem;
    Delete1: TMenuItem;
    grid: TDBAdvGrid;
    HeatReport1: TMenuItem;
    lblMsgEmpty: TLabel;
    MarshallSheet1: TMenuItem;
    MoveDown1: TMenuItem;
    MoveUp1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    New1: TMenuItem;
    oggleStatus1: TMenuItem;
    pnlBody: TPanel;
    pumenuHeat: TPopupMenu;
    rpnlCntrl: TRelativePanel;
    ShapeHtBar1: TShape;
    ShapeHtBar2: TShape;
    ShapeHtBar3: TShape;
    SheetSet1: TMenuItem;
    spbtnAllLogs: TSpeedButton;
    spbtnAutoBuild: TSpeedButton;
    spbtnDelete: TSpeedButton;
    spbtnMarshall: TSpeedButton;
    spbtnMoveDown: TSpeedButton;
    spbtnMoveUp: TSpeedButton;
    spbtnNew: TSpeedButton;
    spbtnReport: TSpeedButton;
    spbtnTimeKeeper: TSpeedButton;
    spbtnToggleStatus: TSpeedButton;
    pnlG: TPanel;
    procedure actnHt_GenericUpdate(Sender: TObject);
    procedure actnHt_ToggleStatusExecute(Sender: TObject);
    procedure gridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
    procedure gridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure gridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState:
        TGridDrawState; ABrush: TBrush; AFont: TFont);
  public
    procedure UpdateUI(DoFullUpdate: boolean = false);
  end;

implementation

{$R *.dfm}

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

procedure TFrameHeat.UpdateUI(DoFullUpdate: boolean = false);
begin

  if DoFullUpdate then
  begin
    // CHECK TMS rule..
    if grid.RowCount < grid.FixedRows  then
      grid.RowCount := grid.FixedRows + 1;

    { NOTE: never make TMG TDBAdvGrid Invisible. It won't draw correctly.}

    if (not Assigned(SCM2)) or (not SCM2.scmConnection.connected) or
        (not Assigned(CORE)) or (not CORE.IsActive) or (CORE.qrySession.IsEmpty)
        or (CORE.qryEvent.IsEmpty) then
    begin
      Self.Visible := false; // hide everthing - move on.
      exit;
    end;

    { NOTE: grid must be visible to sync + forces re-paint. }
    LockDrawing;
    try
      Self.Visible := true;
      pnlBody.Visible := true;
      pnlG.Visible := true;
      grid.Enabled := true;
//      grid.Refresh;
    finally
      UnlockDrawing;
    end;
  end;


  LockDrawing;

  if (uSession.IsUnLocked()) AND (not grid.Enabled) then
    grid.Enabled := true;

  try
    if CORE.qryEvent.IsEmpty then
    begin
      Self.Visible := false; // hide everthing - move on.
      exit;
    end;

    if not Self.Visible then Self.Visible := true;

    if CORE.qryHeat.IsEmpty then
    begin
      // CNTRL panel is displayed but not the grid.
      pnlBody.Visible := true;
      pnlG.Visible := false;
    end
    else
    begin
      pnlBody.Visible := true;
      pnlG.Visible := true;
    end;

  finally
    UnlockDrawing;
  end;


end;

end.
