object SwimClubEdit: TSwimClubEdit
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Edit Swimming Club ...'
  ClientHeight = 652
  ClientWidth = 818
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 818
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 611
    Width = 818
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
  end
  object pnlBody: TPanel
    Left = 0
    Top = 41
    Width = 818
    Height = 570
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
  end
end
