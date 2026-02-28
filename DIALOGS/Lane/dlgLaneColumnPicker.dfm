object LaneColumnPicker: TLaneColumnPicker
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Lane - Column Picker...'
  ClientHeight = 397
  ClientWidth = 268
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 21
  object pnlBody: TPanel
    Left = 0
    Top = 0
    Width = 268
    Height = 285
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 352
    object clbLane: TCheckListBox
      Left = 0
      Top = 0
      Width = 268
      Height = 285
      Align = alClient
      ItemHeight = 21
      TabOrder = 0
      OnClickCheck = clbLaneClickCheck
      ExplicitHeight = 352
    end
  end
  object spnlFooter: TStackPanel
    Left = 0
    Top = 285
    Width = 268
    Height = 112
    Align = alBottom
    ControlCollection = <
      item
        Control = spbtnSaveGridMetrics
        HorizontalPositioning = sphpFill
        VerticalPositioning = spvpTop
      end
      item
        Control = spbtnLoadGridMetrics
        HorizontalPositioning = sphpFill
        VerticalPositioning = spvpTop
      end
      item
        Control = spbtnResetGrigLayout
        HorizontalPositioning = sphpFill
        VerticalPositioning = spvpTop
      end>
    Spacing = 4
    TabOrder = 1
    ExplicitTop = 240
    object spbtnSaveGridMetrics: TSpeedButton
      Left = 1
      Top = 1
      Width = 266
      Height = 32
      Caption = 'Save Layout'
      Flat = True
    end
    object spbtnLoadGridMetrics: TSpeedButton
      Left = 1
      Top = 37
      Width = 266
      Height = 32
      Caption = 'Load Layout'
    end
    object spbtnResetGrigLayout: TSpeedButton
      Left = 1
      Top = 73
      Width = 266
      Height = 32
      Caption = 'RESET'
      OnClick = spbtnResetGrigLayoutClick
    end
  end
end
