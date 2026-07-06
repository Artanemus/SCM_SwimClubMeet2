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
  end
  object pnlBody: TPanel
    Left = 0
    Top = 0
    Width = 815
    Height = 503
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pcntrlBody: TPageControl
      Left = 0
      Top = 0
      Width = 815
      Height = 503
      ActivePage = tsCOREqryHeat
      Align = alClient
      TabOrder = 0
      object tsUnPlacedNominees: TTabSheet
        Caption = 'UnPlaced Nominees'
        object grid: TDBGrid
          Left = 0
          Top = 0
          Width = 807
          Height = 473
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
      object tsCOREqryHeat: TTabSheet
        Caption = 'CORE.qryHeat'
        ImageIndex = 1
        object grid2: TDBGrid
          Left = 0
          Top = 0
          Width = 807
          Height = 473
          Align = alClient
          DataSource = CORE.dsHeat
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
      end
    end
  end
end
