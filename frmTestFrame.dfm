object TestFrame: TTestFrame
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'TestFrame'
  ClientHeight = 690
  ClientWidth = 737
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 21
  object pnlBody: TPanel
    Left = 0
    Top = 0
    Width = 737
    Height = 690
    Align = alClient
    BevelOuter = bvNone
    Color = clDarkslateblue
    ParentBackground = False
    TabOrder = 0
    ExplicitLeft = 352
    ExplicitTop = 192
    ExplicitWidth = 185
    ExplicitHeight = 41
  end
end
