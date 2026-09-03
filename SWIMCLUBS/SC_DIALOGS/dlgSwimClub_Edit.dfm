object SwimClubEdit: TSwimClubEdit
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Edit Swimming Club ...'
  ClientHeight = 652
  ClientWidth = 604
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 21
  object pnlFooter: TPanel
    Left = 0
    Top = 611
    Width = 604
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 818
  end
  object pnlBody: TPanel
    Left = 0
    Top = 0
    Width = 604
    Height = 611
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 620
  end
end
