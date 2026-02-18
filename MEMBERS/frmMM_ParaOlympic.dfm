object MM_ParaOlympic: TMM_ParaOlympic
  Left = 0
  Top = 0
  Caption = 'MM_ParaOlympic'
  ClientHeight = 768
  ClientWidth = 1039
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 21
  object vimgParaCodesInfo: TVirtualImage
    Left = 439
    Top = 6
    Width = 25
    Height = 26
    ImageWidth = 0
    ImageHeight = 0
    ImageIndex = 4
    ImageName = 'Info'
  end
  object lblParaCodes: TLabel
    Left = 489
    Top = 6
    Width = 164
    Height = 19
    Alignment = taRightJustify
    Caption = 'PARAOLYMPIC CODES'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
  object navParaCodes: TDBNavigator
    Left = 423
    Top = 38
    Width = 60
    Height = 176
    DataSource = MM_CORE.dsContactNum
    VisibleButtons = [nbInsert, nbDelete, nbPost, nbCancel]
    Hints.Strings = (
      'First record'
      'Prior record'
      'Next record'
      'Last record'
      'Insert contact record'
      'Delete contact record'
      'Edit record'
      'Post contact edit'
      'Cancel contact edit'
      'Refresh data'
      'Apply updates'
      'Cancel updates')
    Kind = dbnVertical
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object dbgParaCode: TDBGrid
    Left = 503
    Top = 38
    Width = 528
    Height = 562
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  inline TFrameMM_ListMember1: TFrameMM_ListMember
    Left = 5
    Top = 5
    Width = 397
    Height = 726
    TabOrder = 2
    ExplicitLeft = 5
    ExplicitTop = 5
    ExplicitHeight = 726
    inherited rpnlSearch: TRelativePanel
      ControlCollection = <
        item
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = True
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = True
        end
        item
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = True
          AlignRightWithPanel = True
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = True
        end
        item
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = True
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = True
        end
        item
          Control = TFrameMM_ListMember1.vimgSearch
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end
        item
          Control = TFrameMM_ListMember1.edtSearch
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end
        item
          Control = TFrameMM_ListMember1.btnClearSearch
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end>
      inherited edtSearch: TEdit
        Height = 29
        ExplicitHeight = 29
      end
    end
    inherited pnlList: TPanel
      Height = 677
      inherited grid: TDBAdvGrid
        Height = 677
        ExplicitTop = 0
      end
    end
  end
end
