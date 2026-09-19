object ReportPicker: TReportPicker
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Report Picker ...'
  ClientHeight = 673
  ClientWidth = 680
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 21
  object pnlFooter: TPanel
    Left = 0
    Top = 627
    Width = 680
    Height = 46
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      680
      46)
    object btnClose: TButton
      Left = 597
      Top = 6
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      Caption = 'Pick'
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object btnCancel: TButton
      Left = 508
      Top = 6
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      TabOrder = 1
    end
  end
  object pnlBody: TPanel
    Left = 0
    Top = 0
    Width = 680
    Height = 627
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
  end
end
