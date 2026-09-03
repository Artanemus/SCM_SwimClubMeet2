object FrameClubGroup: TFrameClubGroup
  Left = 0
  Top = 0
  Width = 620
  Height = 627
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object pnlGrid: TGridPanel
    Left = 0
    Top = 0
    Width = 620
    Height = 627
    Align = alClient
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 55.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 1
        Control = spnlBtns
        Row = 1
      end
      item
        Column = 0
        Control = pnlL
        Row = 1
      end
      item
        Column = 2
        Control = pnlR
        Row = 1
      end
      item
        Column = 0
        Control = lbl1
        Row = 2
      end
      item
        Column = 2
        Control = lbl2
        Row = 2
      end
      item
        Column = 0
        Control = edtL
        Row = 0
      end
      item
        Column = 1
        Control = vimg1
        Row = 0
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 43.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 41.000000000000000000
      end>
    TabOrder = 0
    ExplicitWidth = 621
    DesignSize = (
      620
      627)
    object spnlBtns: TStackPanel
      Left = 284
      Top = 69
      Width = 52
      Height = 491
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
      TabOrder = 0
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
    object pnlL: TPanel
      AlignWithMargins = True
      Left = 11
      Top = 47
      Width = 272
      Height = 535
      Margins.Left = 10
      Margins.Right = 0
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object lbxL: TListBox
        Left = 0
        Top = 0
        Width = 272
        Height = 535
        Margins.Left = 10
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        ItemHeight = 21
        MultiSelect = True
        Sorted = True
        TabOrder = 0
      end
    end
    object pnlR: TPanel
      AlignWithMargins = True
      Left = 338
      Top = 47
      Width = 271
      Height = 535
      Margins.Left = 0
      Margins.Right = 10
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitWidth = 272
      object lbxR: TListBox
        Left = 0
        Top = 0
        Width = 271
        Height = 535
        Margins.Right = 10
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        ItemHeight = 21
        MultiSelect = True
        Sorted = True
        TabOrder = 0
        ExplicitWidth = 272
      end
    end
    object lbl1: TLabel
      Left = 1
      Top = 585
      Width = 282
      Height = 41
      Align = alClient
      Alignment = taCenter
      Caption = 'Available Clubs'
      Layout = tlCenter
      ExplicitWidth = 106
      ExplicitHeight = 21
    end
    object lbl2: TLabel
      Left = 338
      Top = 585
      Width = 281
      Height = 41
      Align = alClient
      Alignment = taCenter
      Caption = 'Club Group'
      Layout = tlCenter
      ExplicitWidth = 80
      ExplicitHeight = 21
    end
    object edtL: TEdit
      AlignWithMargins = True
      Left = 11
      Top = 4
      Width = 272
      Height = 37
      Margins.Left = 10
      Margins.Right = 0
      Align = alClient
      TabOrder = 3
      ExplicitHeight = 29
    end
    object vimg1: TVirtualImage
      AlignWithMargins = True
      Left = 283
      Top = 4
      Width = 52
      Height = 37
      Margins.Left = 0
      Align = alClient
      Center = True
      ImageCollection = IMG.CollectionCore
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 67
      ImageName = 'search'
      ExplicitLeft = 345
      ExplicitTop = 0
      ExplicitWidth = 48
      ExplicitHeight = 33
    end
  end
  object qryLstSwimClub: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Connection = SCM2.scmConnection
    SQL.Strings = (
      'USE SwimClubMeet2;'
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
    ActiveStoredUsage = [auDesignTime]
    Connection = SCM2.scmConnection
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
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
