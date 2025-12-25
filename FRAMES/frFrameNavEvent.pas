unit frFrameNavEvent;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ControlList,
  Vcl.Themes, Vcl.Styles,
  SVGIconImage,
  dmIMG, dmSCM2, dmCORE, Vcl.StdCtrls, AdvUtil, Vcl.Grids, AdvObj, BaseGrid,
  AdvGrid, DBAdvGrid, Vcl.ExtCtrls,
  uUtility, uDefines,
  UIntercepters
  ;

type
  TFrameNavEvent = class(TFrame)
    pnlBody: TPanel;
    grid: TDBAdvGrid;
    procedure gridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure gridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState:
        TGridDrawState; ABrush: TBrush; AFont: TFont);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrameNavEvent.gridDrawCell(Sender: TObject; ACol, ARow: LongInt;
    Rect: TRect; State: TGridDrawState);
var
  meters: string;
  i: integer;
  G: TDBAdvGrid;
  txtW, txtH, tx, ty, imgW, imgH: Integer;
begin
  G := TDBAdvGrid(Sender);
  if Arow > G.HeaderRow then
  begin
    if ACol = 1 then
    begin
      // draw the RELAY icon..
      i := G.AllInts[4, ARow];
      if i = 2 then
        IMG.imglstEventType.Draw(G.Canvas, Rect.Left + 2, Rect.Top + 1, 2);

      // As this column is hidden, get the raw stored cell value,
      // irrespective of display transformations.
      i := G.AllInts[3, ARow];
      meters := IntToStr(i);
      if meters.IsEmpty then meters := '?';
      imgW := Rect.Width;
      imgH := Rect.Height;
      // calculate and scale font to fit inside icon
      G.Canvas.Font.Style := [fsBold];
      G.Canvas.Font.Size := 24;
      while (G.Canvas.TextWidth(meters) > (imgW - 4))
          and (G.Canvas.Font.Size > 6) do
        G.Canvas.Font.Size := G.Canvas.Font.Size - 1;
      txtW := G.Canvas.TextWidth(meters);
      txtH := G.Canvas.TextHeight(meters);
      tx := Rect.Left + 1 + ((imgW - txtW) div 2);
      ty := Rect.Top + 1 + ((imgH - txtH) div 2);
      // draw text directly on canvas
      G.Canvas.Font.Color := clWebSeashell;
      G.Canvas.Brush.Style := bsClear;
      G.Canvas.TextOut(tx, ty, meters);
    end;
  end;
end;

procedure TFrameNavEvent.gridGetCellColor(Sender: TObject; ARow, ACol: Integer;
    AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  ABrush.Color := uUtility.GetStyledPanelColor; // a little light - Why?
end;

end.
