object FrameNavEvItem: TFrameNavEvItem
  Left = 0
  Top = 0
  Width = 194
  Height = 68
  TabOrder = 0
  StyleElements = [seClient, seBorder]
  OnClick = FrameClick
  object Shape1: TShape
    Left = 45
    Top = 24
    Width = 97
    Height = 9
    Brush.Color = clBlack
    Pen.Style = psClear
    Shape = stRoundRect
  end
  object imgRelay: TSVGIconImage
    Left = 123
    Top = 0
    Width = 24
    Height = 24
    AutoSize = False
    ImageList = IMG.imglstHeatStrokeEx
    ImageIndex = 10
    ImageName = 'RELAY_DOT'
  end
  object imgStroke: TSVGIconImage
    Left = 136
    Top = 3
    Width = 48
    Height = 41
    AutoSize = False
    ImageList = IMG.imglstHeatStrokeEx
    ImageIndex = 0
    ImageName = 'StrokeFS'
  end
  object imgBox: TSVGIconImage
    Left = 6
    Top = 3
    Width = 48
    Height = 48
    AutoSize = False
    ImageList = IMG.imglstHeatStrokeEx
    ImageIndex = 11
    ImageName = 'checkbox-blank'
  end
  object lblEvNum: TLabel
    Left = 3
    Top = 0
    Width = 51
    Height = 50
    Alignment = taCenter
    AutoSize = False
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object lblMeter: TLabel
    Left = 60
    Top = 0
    Width = 70
    Height = 50
    Alignment = taCenter
    AutoSize = False
    Caption = '000'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object lblDesc: TLabel
    Left = 0
    Top = 35
    Width = 184
    Height = 30
    Alignment = taCenter
    AutoSize = False
    Caption = 'Event Description Truncated ...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clCornsilk
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    StyleElements = [seClient, seBorder]
  end
end
