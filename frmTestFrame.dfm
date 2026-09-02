object TestFrame: TTestFrame
  Left = 0
  Top = 0
  Caption = 'TestFrame'
  ClientHeight = 690
  ClientWidth = 737
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnlBody: TPanel
    Left = 0
    Top = 0
    Width = 737
    Height = 690
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 1
    Color = clHighlight
    ParentBackground = False
    TabOrder = 0
    StyleElements = [seFont, seBorder]
  end
end
