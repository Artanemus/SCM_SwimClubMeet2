object MM_MetaData: TMM_MetaData
  Left = 0
  Top = 0
  Caption = 'MM_MetaData'
  ClientHeight = 790
  ClientWidth = 998
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 21
  object pnlList: TPanel
    Left = 0
    Top = 0
    Width = 369
    Height = 790
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    inline MMframe: TFrameMM_ListMember
      Left = 0
      Top = 0
      Width = 369
      Height = 790
      Align = alClient
      TabOrder = 0
      ExplicitLeft = -28
      ExplicitTop = -9
      inherited rpnlSearch: TRelativePanel
        Width = 369
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
            Control = MMframe.vimgSearch
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
          end
          item
            Control = MMframe.edtSearch
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
          end
          item
            Control = MMframe.btnClearSearch
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
        Width = 369
        Height = 741
        inherited grid: TDBAdvGrid
          Width = 369
          Height = 741
          ExplicitTop = 0
        end
      end
    end
  end
end
