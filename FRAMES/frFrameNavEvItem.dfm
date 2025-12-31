object FrameNavEvItem: TFrameNavEvItem
  Left = 0
  Top = 0
  Width = 194
  Height = 68
  Margins.Left = 0
  Margins.Top = 0
  Margins.Right = 0
  Margins.Bottom = 0
  TabOrder = 0
  StyleElements = [seClient, seBorder]
  OnClick = FrameClick
  object Shape2: TShape
    Left = 21
    Top = 22
    Width = 121
    Height = 4
    Brush.Color = 10193772
    Pen.Color = 10193772
    Pen.Style = psClear
    Pen.Width = 2
    Shape = stRoundRect
  end
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 194
    Height = 68
    Align = alClient
    Brush.Style = bsClear
    Pen.Color = 10193772
    Pen.Width = 2
    Shape = stRoundRect
    ExplicitLeft = 53
    ExplicitTop = 25
    ExplicitWidth = 87
    ExplicitHeight = 4
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
  object lblEvNum: TLabel
    Left = 3
    Top = -9
    Width = 51
    Height = 50
    Alignment = taCenter
    AutoSize = False
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -43
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object lblMeter: TLabel
    Left = 3
    Top = -4
    Width = 181
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
    Left = 3
    Top = 40
    Width = 184
    Height = 20
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
