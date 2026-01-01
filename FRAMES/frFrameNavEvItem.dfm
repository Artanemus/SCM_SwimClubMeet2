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
    Left = 56
    Top = 39
    Width = 95
    Height = 3
    Brush.Color = 10193772
    Pen.Color = 10193772
    Pen.Style = psClear
    Pen.Width = 2
    Shape = stRoundRect
  end
  object Shape1: TShape
    AlignWithMargins = True
    Left = 1
    Top = 1
    Width = 192
    Height = 66
    Margins.Left = 1
    Margins.Top = 1
    Margins.Right = 1
    Margins.Bottom = 1
    Align = alClient
    Brush.Style = bsClear
    Pen.Color = 10193772
    Shape = stRoundRect
    ExplicitLeft = 53
    ExplicitTop = 25
    ExplicitWidth = 87
    ExplicitHeight = 4
  end
  object imgStroke: TSVGIconImage
    Left = 143
    Top = 3
    Width = 48
    Height = 41
    AutoSize = False
    ImageList = IMG.imglstHeatStrokeEx
    ImageIndex = 0
    ImageName = 'StrokeFS'
  end
  object lblEvNum: TLabel
    Left = 5
    Top = -1
    Width = 36
    Height = 45
    Alignment = taRightJustify
    Caption = '00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10193772
    Font.Height = -32
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object lblMeter: TLabel
    Left = 57
    Top = -1
    Width = 83
    Height = 45
    Caption = '000m'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10193772
    Font.Height = -32
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
    Font.Color = 10193772
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    StyleElements = [seClient, seBorder]
  end
  object lblEV: TLabel
    Left = 41
    Top = -6
    Width = 12
    Height = 30
    Caption = '#'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10193772
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object imgRelay: TSVGIconImage
    Left = 134
    Top = 0
    Width = 24
    Height = 24
    AutoSize = False
    ImageList = IMG.imglstHeatStrokeEx
    ImageIndex = 11
    ImageName = 'RELAY_DOT'
  end
end
