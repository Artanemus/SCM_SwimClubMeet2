unit frFrameNavEvItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Data.DB,
  SVGIconImage,

  dmIMG, uDefines ;

type
  // Makes all Labels on this frame "Mouse Transparent"
  TLabel = class(Vcl.StdCtrls.TLabel)
    procedure CMHitTest(var Message: TCMHitTest); message CM_HITTEST;
  end;

  // Makes Ethea SVG Icons "Mouse Transparent"
  TSVGIconImage = class(SVGIconImage.TSVGIconImage)
    procedure CMHitTest(var Message: TCMHitTest); message CM_HITTEST;
  end;

  // Makes Ethea SVG Icons "Mouse Transparent"
  TShape = class(Vcl.ExtCtrls.TShape)
    procedure CMHitTest(var Message: TCMHitTest); message CM_HITTEST;
  end;

  TFrameNavEvItem = class(TFrame)
    imgRelay: TSVGIconImage;
    imgStroke: TSVGIconImage;
    lblEv: TLabel;
    lblDesc: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    procedure FrameClick(Sender: TObject);
  private
    fSelected: boolean;
    fParentFrame: TFrame;
  public
    procedure FillFromQuery(AQuery: TDataSet);
    procedure Select(Mode: Boolean);
    constructor Create(AOwner: TComponent); override;
    property ParentFrame: TFrame read FParentFrame write FParentFrame;
end;


implementation

{$R *.dfm}

{ TLabel }
procedure TLabel.CMHitTest(var Message: TCMHitTest);
begin
  Message.Result := HTNOWHERE;
end;

{ TSVGIconImage }
procedure TSVGIconImage.CMHitTest(var Message: TCMHitTest);
begin
  Message.Result := HTNOWHERE;
end;

{ TShape }
procedure TShape.CMHitTest(var Message: TCMHitTest);
begin
  Message.Result := HTNOWHERE;
end;


constructor TFrameNavEvItem.Create(AOwner: TComponent);
begin
  inherited;
  fParentFrame := nil;
  fSelected := false;
  imgStroke.ImageIndex := 0;
  imgRelay.Visible := false;
  Shape1.Visible := false;
  lblEv.Caption := '';
end;

{ TFrameEvItem }

procedure TFrameNavEvItem.FillFromQuery(AQuery: TDataSet);
var
  s: string;
  w, w2, idx: integer;
begin
  // RELAY BUG...
  if (AQuery.FieldByName('EventTypeID').AsInteger = 2) then
    imgRelay.Visible := true else imgRelay.Visible := false;
  // ICON FS, BK, BS, BF, IM, etc...
  imgStroke.ImageIndex := AQuery.FieldByName('StrokeID').AsInteger;

  lblEv.Caption := IntToStr(AQuery.FieldByName('EventNum').AsInteger) +
    '.' + IntToStr(AQuery.FieldByName('Meters').AsInteger) +'m';

  // Adjust thin underline
  shape2.left := lblEv.Left - 2;
  shape2.width := lblEv.Width + 2;

  lblDesc.Caption := AQuery.FieldByName('Caption').AsString;
  if string(lblDesc.caption).IsEmpty then
    lblDesc.Caption := AQuery.FieldByName('ABREV').AsString;

  // truncate caption to fit. append '...' to indicate text continues

  w := lblDesc.Canvas.TextWidth(lblDesc.Caption);
  w2 := lblDesc.Width - 16; // margin allowance.
  if (w > w2) then
  begin
    s := lblDesc.Caption;
    while (s <> '') and (lblDesc.Canvas.TextWidth(s + '...') > W2) do
    begin
      s := s.Substring(0, Length(s) - 1);
    end;
    idx := LastDelimiter(' ', s);
    if idx > 0 then
      s := s.Substring(0, idx - 1);
    
    lblDesc.Caption := s + '...';
  end;
end;

procedure TFrameNavEvItem.FrameClick(Sender : TObject);
begin
  // Basic frame, knows nothing of DB...
  // ParentFrame will handle this.
  if Assigned(ParentFrame) then // Send to TFrameNavEv.
      SendMessage(ParentFrame.Handle, SCM_FRAME_SELECTED,
        WPARAM(Tag), LPARAM(Self));
end;

procedure TFrameNavEvItem.Select(Mode: Boolean);
begin
//$009B8B6C
  if Mode then
  begin
    fSelected := true;
    lblEv.Font.Color := clWebIvory;

    lblDesc.Font.Color := clWebCornSilk;
    Shape1.Pen.Color := clWebCornSilk;
    Shape1.Visible := true;
    Shape2.Brush.Color := clWebCornSilk;
  end
  else
  begin
    fSelected := false;
    lblEv.Font.Color := $00E7CFA1;
    lblDesc.Font.Color := $009B8B6C;
    Shape1.Visible := false;
    Shape2.Brush.Color := $009B8B6C;
  end;
end;

end.
