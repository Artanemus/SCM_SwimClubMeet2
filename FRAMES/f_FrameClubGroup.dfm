object ClubGroupAssign: TClubGroupAssign
  Left = 0
  Top = 0
  Width = 571
  Height = 486
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 571
    Height = 39
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object vimg1: TVirtualImage
      AlignWithMargins = True
      Left = 513
      Top = 3
      Width = 48
      Height = 33
      Margins.Right = 10
      Align = alRight
      ImageCollection = IMG.CollectionCore
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 67
      ImageName = 'search'
      ExplicitLeft = 392
    end
    object edtL: TEdit
      AlignWithMargins = True
      Left = 10
      Top = 3
      Width = 497
      Height = 33
      Margins.Left = 10
      Align = alClient
      TabOrder = 0
      ExplicitHeight = 29
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 445
    Width = 571
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
  end
  object rpnlBody: TRelativePanel
    Left = 0
    Top = 39
    Width = 571
    Height = 406
    ControlCollection = <
      item
        Control = lbxL
        AlignBottomWithPanel = True
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = True
        AlignRightWithPanel = False
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = False
      end
      item
        Control = lbxR
        AlignBottomWithPanel = True
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = True
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = False
      end
      item
        Control = spnlBtns
        AlignBottomWithPanel = True
        AlignHorizontalCenterWithPanel = True
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = False
      end>
    Align = alClient
    TabOrder = 2
    DesignSize = (
      571
      406)
    object lbxL: TListBox
      AlignWithMargins = True
      Left = 11
      Top = 4
      Width = 200
      Height = 398
      Margins.Left = 10
      Anchors = []
      ItemHeight = 21
      TabOrder = 0
    end
    object lbxR: TListBox
      AlignWithMargins = True
      Left = 360
      Top = 4
      Width = 200
      Height = 398
      Margins.Right = 10
      Anchors = []
      ItemHeight = 21
      TabOrder = 1
    end
    object spnlBtns: TStackPanel
      Left = 259
      Top = 1
      Width = 50
      Height = 404
      Anchors = []
      ControlCollection = <
        item
          Control = spbtnMoveR
        end
        item
          Control = spbtnMoveR2
        end
        item
          Control = spbtnMoveL
        end
        item
          Control = spbtnMoveL2
        end>
      TabOrder = 2
      object spbtnMoveR: TSpeedButton
        Left = 1
        Top = 1
        Width = 48
        Height = 48
        ImageIndex = 3
        ImageName = 'arrow-right'
        Images = IMG.imglstClubGroup
      end
      object spbtnMoveR2: TSpeedButton
        Left = 1
        Top = 51
        Width = 48
        Height = 48
        ImageIndex = 1
        ImageName = 'arrow-right2'
        Images = IMG.imglstClubGroup
      end
      object spbtnMoveL: TSpeedButton
        Left = 1
        Top = 101
        Width = 48
        Height = 48
        ImageIndex = 2
        ImageName = 'arrow-left'
        Images = IMG.imglstClubGroup
      end
      object spbtnMoveL2: TSpeedButton
        Left = 1
        Top = 151
        Width = 48
        Height = 48
        ImageIndex = 0
        ImageName = 'arrow-left2'
        Images = IMG.imglstClubGroup
      end
    end
  end
  object qryLstSwimClub: TFDQuery
    Connection = CORE.TestConnection
    SQL.Strings = (
      ''
      'DECLARE @SwimClubID AS Integer;'
      
        'SET @SwimClubID = :SWIMCLUBID; --- 75; This club has IsClubGroup' +
        ' = 1;'
      ''
      '-- CTE for the list of clubs that belong to the special group'
      'WITH GroupMembers AS ('
      '    SELECT cg.ChildClubID'
      '    FROM dbo.SwimClubGroup cg'
      '    WHERE cg.ParentClubID = @SwimClubID'
      ')'
      'SELECT sc.SwimClubID,'
      '       sc.NickName,'
      '       sc.Caption,'
      '       sc.LogoImg'
      'FROM dbo.SwimClub sc'
      
        'WHERE sc.IsClubGroup = 0                               -- exclud' +
        'e all special clubs'
      
        '  AND sc.SwimClubID NOT IN (SELECT ChildClubID FROM GroupMembers' +
        '); -- exclude group members'
      ''
      '')
    Left = 136
    Top = 247
    ParamData = <
      item
        Name = 'SWIMCLUBID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryLstClubGroup: TFDQuery
    Connection = CORE.TestConnection
    Left = 128
    Top = 335
  end
end
