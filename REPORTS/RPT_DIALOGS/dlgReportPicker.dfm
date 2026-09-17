object ReportPicker: TReportPicker
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Report Picker ...'
  ClientHeight = 573
  ClientWidth = 537
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
    Top = 527
    Width = 537
    Height = 46
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 992
    DesignSize = (
      537
      46)
    object btnClose: TButton
      Left = 454
      Top = 6
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      Caption = 'Pick'
      TabOrder = 0
      OnClick = btnCloseClick
      ExplicitLeft = 909
    end
    object btnCancel: TButton
      Left = 365
      Top = 6
      Width = 83
      Height = 33
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      TabOrder = 1
      ExplicitLeft = 820
    end
  end
  object pnlBody: TPanel
    Left = 0
    Top = 0
    Width = 537
    Height = 527
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 41
    ExplicitWidth = 992
    ExplicitHeight = 486
  end
end
