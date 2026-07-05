object ABDebug: TABDebug
  Left = 0
  Top = 0
  Caption = 'ABDebug'
  ClientHeight = 544
  ClientWidth = 815
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object pnlFooter: TPanel
    Left = 0
    Top = 503
    Width = 815
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 112
    ExplicitTop = 368
    ExplicitWidth = 185
  end
  object pnlBody: TPanel
    Left = 0
    Top = 0
    Width = 815
    Height = 503
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 320
    ExplicitTop = 272
    ExplicitWidth = 185
    ExplicitHeight = 41
    object grid: TDBGrid
      Left = 0
      Top = 0
      Width = 815
      Height = 503
      Align = alClient
      DataSource = ABINDV_Data.dsUnplacedNominees
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
  end
end
