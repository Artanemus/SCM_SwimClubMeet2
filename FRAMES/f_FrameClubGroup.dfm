object FrClubGroup: TFrClubGroup
  Left = 0
  Top = 0
  Width = 613
  Height = 537
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
    Width = 613
    Height = 39
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 620
    object vimg1: TVirtualImage
      AlignWithMargins = True
      Left = 283
      Top = 3
      Width = 48
      Height = 33
      Margins.Left = 0
      Align = alLeft
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
      Width = 270
      Height = 33
      Margins.Left = 10
      Align = alLeft
      TabOrder = 0
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 496
    Width = 613
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 620
    object lbl1: TLabel
      Left = 56
      Top = 6
      Width = 150
      Height = 21
      Caption = #9651'  Available Clubs  '#9651
    end
    object lbl2: TLabel
      Left = 407
      Top = 6
      Width = 124
      Height = 21
      Caption = #9651'  Club Group  '#9651
    end
  end
  object rpnlBody: TRelativePanel
    Left = 0
    Top = 39
    Width = 612
    Height = 457
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
        RightOf = spnlBtns
      end
      item
        Control = spnlBtns
        AlignBottomWithPanel = True
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = False
        RightOf = lbxL
      end>
    Align = alLeft
    BevelOuter = bvNone
    Padding.Left = 10
    Padding.Right = 10
    TabOrder = 2
    ExplicitWidth = 620
    DesignSize = (
      612
      457)
    object lbxL: TListBox
      Left = 10
      Top = 0
      Width = 270
      Height = 457
      Margins.Left = 10
      Anchors = []
      ItemHeight = 21
      MultiSelect = True
      Sorted = True
      TabOrder = 0
    end
    object lbxR: TListBox
      Left = 332
      Top = 0
      Width = 270
      Height = 457
      Margins.Right = 10
      ItemHeight = 21
      MultiSelect = True
      Sorted = True
      TabOrder = 1
    end
    object spnlBtns: TStackPanel
      Left = 280
      Top = 0
      Width = 52
      Height = 457
      Anchors = []
      BevelOuter = bvNone
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
      HorizontalPositioning = sphpCenter
      TabOrder = 2
      object spbtnMoveR: TSpeedButton
        Left = 2
        Top = 0
        Width = 48
        Height = 48
        ImageIndex = 3
        ImageName = 'arrow-right'
        Images = IMG.imglstClubGroup
        OnClick = spbtnMoveRClick
      end
      object spbtnMoveR2: TSpeedButton
        Left = 2
        Top = 50
        Width = 48
        Height = 48
        ImageIndex = 1
        ImageName = 'arrow-right2'
        Images = IMG.imglstClubGroup
        OnClick = spbtnMoveR2Click
      end
      object spbtnMoveL: TSpeedButton
        Left = 2
        Top = 100
        Width = 48
        Height = 48
        ImageIndex = 2
        ImageName = 'arrow-left'
        Images = IMG.imglstClubGroup
        OnClick = spbtnMoveLClick
      end
      object spbtnMoveL2: TSpeedButton
        Left = 2
        Top = 150
        Width = 48
        Height = 48
        ImageIndex = 0
        ImageName = 'arrow-left2'
        Images = IMG.imglstClubGroup
        OnClick = spbtnMoveL2Click
      end
    end
  end
  object qryLstSwimClub: TFDQuery
    Connection = CORE.TestConnection
    SQL.Strings = (
      ''
      'DECLARE @ParentClubID AS Integer;'
      'SET @ParentClubID = :PARENTCLUBID; -- IsClubGroup = 1;'
      ''
      '-- CTE for the list of clubs that belong to the special group'
      'WITH GroupMembers AS ('
      '    SELECT cg.ChildClubID'
      '    FROM dbo.SwimClubGroup cg'
      '    WHERE cg.ParentClubID = @ParentClubID'
      ')'
      'SELECT sc.SwimClubID,'
      '       sc.NickName,'
      '       sc.Caption,'
      '       sc.LogoImg'
      'FROM dbo.SwimClub sc'
      'WHERE '
      '  -- exclude all special clubs'
      '  sc.IsClubGroup = 0  '
      '  -- exclude group members'
      
        '  AND sc.SwimClubID NOT IN (SELECT ChildClubID FROM GroupMembers' +
        '); '
      ''
      '')
    Left = 120
    Top = 247
    ParamData = <
      item
        Name = 'PARENTCLUBID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object qryLstSwimClubGroup: TFDQuery
    Connection = CORE.TestConnection
    SQL.Strings = (
      'DECLARE @ParentClubID AS INTEGER;'
      'SET @ParentClubID = :PARENTCLUBID;'
      ''
      'SELECT cg.[SwimClubGroupID]'
      '      ,cg.[ParentClubID]'
      '      ,cg.[ChildClubID]'
      '      ,sc.[Caption]'
      '      ,sc.[NickName]'
      '      ,sc.LogoImg'
      '  FROM [SwimClubMeet2].[dbo].[SwimClubGroup] cg'
      '  INNER JOIN [SwimClub] sc ON cg.[ChildClubID] = sc.[SwimClubID]'
      '  WHERE cg.[ParentClubID] = @ParentClubID;')
    Left = 120
    Top = 335
    ParamData = <
      item
        Name = 'PARENTCLUBID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
