object ManageMember_CheckData: TManageMember_CheckData
  Left = 0
  Top = 0
  Caption = 'Manage Members - check member'#39's data...'
  ClientHeight = 723
  ClientWidth = 553
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 21
  object pnlDataCheck: TPanel
    Left = 0
    Top = 0
    Width = 553
    Height = 723
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlDataCheck'
    ShowCaption = False
    TabOrder = 0
    object lblDataCheck: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 10
      Width = 219
      Height = 33
      Margins.Top = 10
      Align = alTop
      Alignment = taCenter
      Caption = '... CHECK DATA ...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object DBGrid2: TDBGrid
      Left = 0
      Top = 337
      Width = 553
      Height = 386
      Align = alClient
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -16
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
    object GridPanel1: TGridPanel
      Left = 0
      Top = 46
      Width = 553
      Height = 250
      Align = alTop
      Caption = 'GridPanel1'
      ColumnCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = btnFirstName
          Row = 0
        end
        item
          Column = 1
          Control = btnLastName
          Row = 0
        end
        item
          Column = 0
          Control = btnGender
          Row = 1
        end
        item
          Column = 1
          Control = btnDOB
          Row = 1
        end
        item
          Column = 0
          Control = btnSwimmingClub
          Row = 2
        end
        item
          Column = 1
          Control = btnBooleanNulls
          Row = 2
        end
        item
          Column = 0
          Control = btnMembershipNum
          Row = 3
        end
        item
          Column = 1
          Control = btnCheckDataReport
          Row = 3
        end>
      RowCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 60.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 60.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 60.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 60.000000000000000000
        end>
      ShowCaption = False
      TabOrder = 1
      DesignSize = (
        553
        250)
      object btnFirstName: TButton
        Tag = 1
        Left = 70
        Top = 12
        Width = 137
        Height = 38
        Anchors = []
        Caption = 'FirstName'
        TabOrder = 0
        OnClick = btnCheckDataClick
      end
      object btnLastName: TButton
        Tag = 2
        Left = 346
        Top = 12
        Width = 137
        Height = 38
        Anchors = []
        Caption = 'LastName'
        TabOrder = 1
      end
      object btnGender: TButton
        Tag = 3
        Left = 70
        Top = 72
        Width = 137
        Height = 38
        Anchors = []
        Caption = 'Gender'
        TabOrder = 2
      end
      object btnDOB: TButton
        Tag = 4
        Left = 346
        Top = 72
        Width = 137
        Height = 38
        Anchors = []
        Caption = 'DOB'
        TabOrder = 3
      end
      object btnSwimmingClub: TButton
        Tag = 5
        Left = 70
        Top = 132
        Width = 137
        Height = 38
        Anchors = []
        Caption = 'Swimming Club'
        TabOrder = 4
      end
      object btnBooleanNulls: TButton
        Tag = 6
        Left = 346
        Top = 132
        Width = 137
        Height = 38
        Anchors = []
        Caption = 'Boolean NULLS'
        TabOrder = 5
      end
      object btnMembershipNum: TButton
        Tag = 7
        Left = 70
        Top = 192
        Width = 137
        Height = 38
        Anchors = []
        Caption = 'Membership #'
        TabOrder = 6
      end
      object btnCheckDataReport: TButton
        Tag = 8
        Left = 346
        Top = 192
        Width = 137
        Height = 38
        Anchors = []
        Caption = 'Create Report'
        TabOrder = 7
        OnClick = btnCheckDataReportClick
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 296
      Width = 553
      Height = 41
      Align = alTop
      Caption = 'DESCRIPTION'
      TabOrder = 2
    end
  end
  object qryDataCheck: TFDQuery
    Connection = SCM2.scmConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    SQL.Strings = (
      ''
      'SELECT [MemberID]'
      '      ,'#39'No firstname.'#39' as MSG'
      '  FROM [dbo].[Member]'
      'WHERE firstname IS NULL'
      ''
      'UNION'
      ''
      'SELECT [MemberID]'
      '      ,'#39'No lastname.'#39' as MSG'
      '  FROM [dbo].[Member]'
      'WHERE lastname IS NULL'
      ''
      'UNION'
      ''
      'SELECT [MemberID]'
      '    ,'#39'Gender not given.'#39' as MSG'
      'FROM [dbo].[Member]'
      'WHERE GenderID IS NULL'
      ''
      'UNION'
      ''
      'SELECT [MemberID]'
      '      ,'#39'No date of birth.'#39' as MSG'
      '  FROM [dbo].[Member]'
      'WHERE DOB is null'
      ''
      'UNION'
      ''
      'SELECT [MemberID]'
      '      ,'#39'Archived or Active or Swimmer unknown.'#39' as MSG'
      '  FROM [dbo].[Member]'
      
        'WHERE IsArchived IS NULL OR IsActive IS NULL OR IsSwimmer IS NUL' +
        'L  '
      ''
      'UNION'
      ''
      'SELECT [MemberID]'
      '      ,'#39'No membership number.'#39' as MSG'
      '  FROM [dbo].[Member]'
      'WHERE MembershipNum IS NULL'
      ''
      'ORDER BY MemberID DESC;'
      ''
      ''
      ''
      ''
      ''
      '')
    Left = 165
    Top = 384
    object qryDataCheckMemberID: TIntegerField
      DisplayLabel = 'Member'#39's ID'
      FieldName = 'MemberID'
      Origin = 'MemberID'
      ReadOnly = True
      Required = True
    end
    object qryDataCheckMSG: TStringField
      DisplayLabel = 'Warnings ... Errors'
      FieldName = 'MSG'
      Origin = 'MSG'
      ReadOnly = True
      Required = True
      Size = 27
    end
  end
  object dsDataCheck: TDataSource
    DataSet = qryDataCheck
    Left = 317
    Top = 384
  end
  object qryDataCheckPart: TFDQuery
    Connection = SCM2.scmConnection
    SQL.Strings = (
      'SELECT [MemberID]'
      '      ,'#39'No firstname.'#39' as MSG'
      '  FROM [dbo].[Member]'
      'WHERE firstname IS NULL '
      'ORDER BY MemberID DESC;')
    Left = 165
    Top = 448
  end
  object dsDataCheckPart: TDataSource
    DataSet = qryDataCheckPart
    Enabled = False
    Left = 317
    Top = 448
  end
  object cmdFixNullBooleans: TFDCommand
    CommandText.Strings = (
      'USE SwimClubMeet;'
      ''
      'UPDATE [SwimClubMeet].[dbo].[Member]'
      'SET IsActive = CASE'
      '                   WHEN IsActive IS NULL THEN'
      '                       1'
      '                   ELSE'
      '                       IsActive'
      '               END'
      '  , [IsArchived] = CASE'
      '                       WHEN IsArchived IS NULL THEN'
      '                           0'
      '                       ELSE'
      '                           IsArchived'
      '                   END'
      '  , [IsSwimmer] = CASE'
      '                      WHEN IsSwimmer IS NULL THEN'
      '                          1'
      '                      ELSE'
      '                          IsSwimmer'
      '                  END'
      'WHERE IsArchived IS NULL'
      '      OR IsActive IS NULL'
      '      OR IsSwimmer IS NULL'
      ''
      ';')
    ActiveStoredUsage = []
    Left = 237
    Top = 528
  end
end
