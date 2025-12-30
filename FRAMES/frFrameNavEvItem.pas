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
    imgBox: TSVGIconImage;
    lblEvNum: TLabel;
    lblMeter: TLabel;
    Shape1: TShape;
    lblDesc: TLabel;
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

      // Color := clHighlight;
      // lblEvNum.Font.Color := clHighlightText;
      // lblMeter.Font.Color := clHighlightText;
      // lblDesc.Font.Color := clHighlightText;

{ TLabel }
procedure TLabel.CMHitTest(var Message: TCMHitTest);
begin
//  Color := clYellow;
//  lblEvNum.Font.Color := clWindowText;
//  lblMeter.Font.Color := clWindowText;
//  lblDesc.Font.Color := clWindowText;
  Message.Result := HTNOWHERE;
//    Invalidate;
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
end;


{ TFrameEvItem }

procedure TFrameNavEvItem.FillFromQuery(AQuery: TDataSet);
//var
//  i: integer;
begin
  // RELAY BUG...
  if (AQuery.FieldByName('EventTypeID').AsInteger = 2) then
    imgRelay.Visible := true else imgRelay.Visible := false;
  // ICON FS, BK, BS, BF, IM, etc...
  imgStroke.ImageIndex := AQuery.FieldByName('StrokeID').AsInteger;
  lblEvNum.Caption := IntToStr(AQuery.FieldByName('EventNum').AsInteger);

//  i := AQuery.FieldByName('Meters').AsInteger;
//  lblMeter.Caption := Format('%2d', [i]);
  lblMeter.Caption := IntToStr(AQuery.FieldByName('Meters').AsInteger);

  lblDesc.Caption := AQuery.FieldByName('Caption').AsString;
  if string(lblDesc.caption).IsEmpty then
    lblDesc.Caption := AQuery.FieldByName('ABREV').AsString;
end;

procedure TFrameNavEvItem.FrameClick(Sender : TObject);
begin

  // lblEvNum.Color := clYellow;
  // lblEvNum.Invalidate;
  // lblMeter.Color := clYellow;
  // lblMeter.Invalidate;
  // lblDesc.Color := clYellow;
  // lblDesc.Invalidate;

//  Self.Repaint;

  if Assigned(ParentFrame) then // Send to TFrameNavEv.
      SendMessage(ParentFrame.Handle, SCM_FRAME_SELECTED,
      WPARAM(NativeInt(Tag)), LPARAM(NativeInt(Self)));
end;

procedure TFrameNavEvItem.Select(Mode: Boolean);
begin
  if Mode then
  begin
    fSelected := true;
//    Color := clHighlight;
  end
  else
  begin
    fSelected := false;
//    Color := clBtnFace;
  end;
end;

end.
