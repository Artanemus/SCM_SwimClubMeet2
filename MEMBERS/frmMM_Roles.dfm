object MM_Roles: TMM_Roles
  Left = 0
  Top = 0
  Caption = 'MM_Roles'
  ClientHeight = 797
  ClientWidth = 1081
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 21
  object DBNavigator2: TDBNavigator
    Left = 660
    Top = 615
    Width = 60
    Height = 176
    DataSource = MM_CORE.dsMemberRoleLink
    VisibleButtons = [nbInsert, nbDelete, nbPost, nbCancel]
    Hints.Strings = (
      'First record'
      'Prior record'
      'Next record'
      'Last record'
      'Insert role record'
      'Delete role record'
      'Edit record'
      'Post role edit'
      'Cancel role edit'
      'Refresh data'
      'Apply updates'
      'Cancel updates')
    Kind = dbnVertical
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object DBGridRole: TDBGrid
    Left = 398
    Top = 55
    Width = 675
    Height = 554
    DataSource = MM_CORE.dsMemberRoleLink
    DefaultDrawing = False
    Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        DropDownRows = 12
        Expanded = False
        FieldName = 'luMemberRoleStr'
        Title.Caption = 'Member'#39's Roles'
        Width = 250
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'IsActive'
        Title.Caption = 'Active'
        Width = 72
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'IsArchived'
        Title.Caption = 'Archived'
        Width = 72
        Visible = True
      end
      item
        ButtonStyle = cbsEllipsis
        Expanded = False
        FieldName = 'StartOn'
        ReadOnly = True
        Title.Caption = 'Start On'
        Width = 110
        Visible = True
      end
      item
        ButtonStyle = cbsEllipsis
        Expanded = False
        FieldName = 'EndOn'
        ReadOnly = True
        Title.Caption = 'End On'
        Width = 110
        Visible = True
      end>
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 1081
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitLeft = 424
    ExplicitTop = 400
    ExplicitWidth = 185
    object btnInfoRoles: TVirtualImage
      Left = 10
      Top = 9
      Width = 25
      Height = 26
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 4
      ImageName = 'Info'
    end
    object Label6: TLabel
      Left = 60
      Top = 11
      Width = 48
      Height = 19
      Alignment = taRightJustify
      Caption = 'ROLES'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
  end
  object pnlList: TPanel
    Left = 0
    Top = 41
    Width = 369
    Height = 756
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 3
    inline TFrameMM_ListMember1: TFrameMM_ListMember
      Left = 0
      Top = 0
      Width = 369
      Height = 756
      Align = alClient
      TabOrder = 0
      ExplicitLeft = -76
      ExplicitTop = -43
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
        Width = 369
        Height = 707
        inherited grid: TDBAdvGrid
          Width = 369
          Height = 707
          ExplicitTop = 0
        end
      end
    end
  end
end
