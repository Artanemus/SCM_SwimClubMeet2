object LaneColumnPicker: TLaneColumnPicker
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Lane - Column Picker...'
  ClientHeight = 486
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  TextHeight = 21
  object pnlBody: TPanel
    Left = 58
    Top = 0
    Width = 326
    Height = 486
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 0
    ExplicitWidth = 268
    ExplicitHeight = 334
    object clbLane: TCheckListBox
      Left = 0
      Top = 0
      Width = 326
      Height = 486
      Align = alClient
      CheckBoxPadding = 4
      ItemHeight = 25
      Items.Strings = (
        'line 1'
        'line 2'
        'line 3')
      TabOrder = 0
      OnClickCheck = clbLaneClickCheck
      ExplicitWidth = 268
      ExplicitHeight = 334
    end
  end
  object rpnlCntrl: TRelativePanel
    Left = 0
    Top = 0
    Width = 58
    Height = 486
    ControlCollection = <
      item
        Control = spbtnClose
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = True
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = False
      end
      item
        Control = spbtnLoadGridMetrics
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = True
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = False
        Below = spbtnSaveGridMetrics
      end
      item
        Control = spbtnResetGrigLayout
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = True
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = False
        Below = spbtnLoadGridMetrics
      end
      item
        Control = spbtnSaveGridMetrics
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = True
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = False
        Below = spbtnClose
      end
      item
        Control = spbtnUpdate
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = True
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = False
        Below = spbtnResetGrigLayout
      end>
    Align = alLeft
    BevelOuter = bvNone
    Padding.Top = 10
    TabOrder = 1
    DesignSize = (
      58
      486)
    object spbtnClose: TSpeedButton
      Left = 5
      Top = 10
      Width = 48
      Height = 48
      Hint = 'Update UI and close.'
      Anchors = []
      ImageIndex = 0
      ImageName = 'close'
      Images = SVGList
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
      OnClick = spbtnCloseClick
    end
    object spbtnLoadGridMetrics: TSpeedButton
      Left = 5
      Top = 106
      Width = 48
      Height = 48
      Hint = 'Load layout from file.'
      Anchors = []
      ImageIndex = 3
      ImageName = 'upload-file'
      Images = SVGList
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
    end
    object spbtnResetGrigLayout: TSpeedButton
      Left = 5
      Top = 154
      Width = 48
      Height = 48
      Hint = 'Reset to system default layout.'
      Anchors = []
      ImageIndex = 2
      ImageName = 'reset-wrench'
      Images = SVGList
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
      OnClick = spbtnResetGrigLayoutClick
    end
    object spbtnSaveGridMetrics: TSpeedButton
      Left = 5
      Top = 58
      Width = 48
      Height = 48
      Hint = 'Save layout to file.'
      Anchors = []
      ImageIndex = 4
      ImageName = 'download-file'
      Images = SVGList
      Flat = True
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
    end
    object spbtnUpdate: TSpeedButton
      Left = 5
      Top = 202
      Width = 48
      Height = 48
      Hint = 'Update UI. '
      Anchors = []
      ImageIndex = 5
      ImageName = 'update'
      Images = SVGList
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
      OnClick = spbtnResetGrigLayoutClick
    end
  end
  object SVGList: TSVGIconVirtualImageList
    Images = <
      item
        CollectionIndex = 78
        CollectionName = 'close'
        Name = 'close'
      end
      item
        CollectionIndex = 56
        CollectionName = 'cancel'
        Name = 'cancel'
      end
      item
        CollectionIndex = 119
        CollectionName = 'reset-wrench'
        Name = 'reset-wrench'
      end
      item
        CollectionIndex = 120
        CollectionName = 'upload-file'
        Name = 'upload-file'
      end
      item
        CollectionIndex = 121
        CollectionName = 'download-file'
        Name = 'download-file'
      end
      item
        CollectionIndex = 93
        CollectionName = 'update'
        Name = 'update'
      end>
    ImageCollection = IMG.CollectionCore
    Width = 48
    Height = 48
    Size = 48
    Left = 184
    Top = 248
  end
  object FileOpenDlg: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 266
    Top = 128
  end
  object FileSaveDlg: TFileSaveDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 266
    Top = 192
  end
end
