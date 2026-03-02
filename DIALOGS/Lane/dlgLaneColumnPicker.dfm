object LaneColumnPicker: TLaneColumnPicker
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Lane - Column Picker...'
  ClientHeight = 400
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
    Height = 264
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 285
    object clbLane: TCheckListBox
      Left = 0
      Top = 0
      Width = 268
      Height = 264
      Align = alClient
      ItemHeight = 21
      TabOrder = 0
      OnClickCheck = clbLaneClickCheck
      ExplicitHeight = 285
    end
  end
  object spnlFooter: TStackPanel
    Left = 0
    Top = 264
    Width = 268
    Height = 136
    Align = alBottom
    ControlCollection = <
      item
        Control = spbtnClose
        HorizontalPositioning = sphpFill
        VerticalPositioning = spvpTop
      end
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
    object spbtnClose: TSpeedButton
      Left = 1
      Top = 1
      Width = 266
      Height = 22
      Caption = 'CLOSE'
      OnClick = spbtnCloseClick
    end
    object spbtnSaveGridMetrics: TSpeedButton
      Left = 1
      Top = 27
      Width = 266
      Height = 32
      Caption = 'Save Layout'
      Flat = True
    end
    object spbtnLoadGridMetrics: TSpeedButton
      Left = 1
      Top = 63
      Width = 266
      Height = 32
      Caption = 'Load Layout'
    end
    object spbtnResetGrigLayout: TSpeedButton
      Left = 1
      Top = 99
      Width = 266
      Height = 32
      Caption = 'RESET'
      OnClick = spbtnResetGrigLayoutClick
    end
  end
end
