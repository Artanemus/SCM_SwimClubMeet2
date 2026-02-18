object MM_About: TMM_About
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'About SwimClubMeet - Manage Members'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 21
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 368
    Width = 624
    Height = 73
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnOK: TButton
      Left = 275
      Top = 21
      Width = 75
      Height = 32
      Caption = 'Close'
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  object pnlBody: TPanel
    Left = 0
    Top = 41
    Width = 624
    Height = 327
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object lblDetails: TLabel
      Left = 166
      Top = 153
      Width = 292
      Height = 21
      Caption = 'About SwimClubMeet - Manage Members'
    end
  end
end
