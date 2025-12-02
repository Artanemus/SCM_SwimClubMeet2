object ManageMemberData: TManageMemberData
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 738
  Width = 1139
  object tblContactNumType: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'ContactNumTypeID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    TableName = 'SwimClubMeet2..ContactNumType'
    Left = 88
    Top = 472
    object tblContactNumTypeContactNumTypeID: TFDAutoIncField
      FieldName = 'ContactNumTypeID'
      Origin = 'ContactNumTypeID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object tblContactNumTypeCaption: TWideStringField
      FieldName = 'Caption'
      Origin = 'Caption'
      Size = 30
    end
  end
  object tblStroke: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'StrokeID'
    Connection = SCM2.scmConnection
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Stroke'
    TableName = 'SwimClubMeet2..Stroke'
    Left = 88
    Top = 352
  end
  object tblDistance: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'DistanceID'
    Connection = SCM2.scmConnection
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Distance'
    TableName = 'SwimClubMeet2..Distance'
    Left = 88
    Top = 400
  end
  object dsMember: TDataSource
    DataSet = qryMember
    Left = 112
    Top = 16
  end
  object qryMember: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    AfterInsert = qryMemberAfterInsert
    AfterPost = qryMemberAfterPost
    BeforeDelete = qryMemberBeforeDelete
    BeforeScroll = qryMemberBeforeScroll
    AfterScroll = qryMemberAfterScroll
    IndexFieldNames = 'MemberID'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvStrsTrim2Len]
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Member'
    UpdateOptions.KeyFields = 'MemberID'
    SQL.Strings = (
      ''
      'DECLARE @HideInActive BIT;'
      'DECLARE @HideArchived BIT;'
      'DECLARE @HideNonSwimmers BIT;'
      ''
      ''
      'SET @HideInActive = :HIDE_INACTIVE;'
      'SET @HideArchived = :HIDE_ARCHIVED;'
      'SET @HideNonSwimmers = :HIDE_NONSWIMMERS;'
      ''
      ''
      'SELECT [MemberID],'
      '       [MembershipNum],'
      '       [MembershipStr],'
      '       [FirstName],'
      '       [MiddleName],'
      '       [LastName],'
      '       [DOB],'
      '       [IsActive],'
      '       IsSwimmer,'
      '       IsArchived,'
      '       [Email],'
      '       [GenderID],'
      
        '       CONCAT(Member.FirstName, '#39' '#39', UPPER(Member.LastName)) AS ' +
        'FName,'
      '       CreatedOn,'
      '       ArchivedOn,'
      '       TAGS'
      'FROM [dbo].[Member]'
      ''
      ''
      'WHERE (IsActive >= CASE'
      '                       WHEN @HideInActive = 1 THEN'
      '                           1'
      '                       ELSE'
      '                           0'
      '                   END'
      '      )'
      '      AND (IsArchived <= CASE'
      '                             WHEN @HideArchived = 1 THEN'
      '                                 0'
      '                             ELSE'
      '                                 1'
      '                         END'
      '          )'
      '      AND (IsSwimmer >= CASE'
      '                            WHEN @HideNonSwimmers = 1 THEN'
      '                                1'
      '                            ELSE'
      '                                0'
      '                        END'
      '          )'
      '-- mitigates NULL booleans'
      '      OR'
      '      ('
      '          IsArchived IS NULL'
      '          AND @HideArchived = 0'
      '      )'
      '      OR'
      '      ('
      '          IsActive IS NULL'
      '          AND @HideInActive = 0'
      '      )'
      '      OR'
      '      ('
      '          IsSwimmer IS NULL'
      '          AND @HideNonSwimmers = 0'
      '      );'
      '     '
      ''
      ''
      ''
      '')
    Left = 40
    Top = 16
    ParamData = <
      item
        Name = 'HIDE_INACTIVE'
        DataType = ftBoolean
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'HIDE_ARCHIVED'
        DataType = ftBoolean
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'HIDE_NONSWIMMERS'
        DataType = ftBoolean
        ParamType = ptInput
        Value = Null
      end>
    object qryMemberMemberID: TFDAutoIncField
      Alignment = taCenter
      DisplayLabel = 'ID'
      DisplayWidth = 4
      FieldName = 'MemberID'
      Origin = 'MemberID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object qryMemberMembershipNum: TIntegerField
      Alignment = taLeftJustify
      DisplayLabel = 'Num#'
      DisplayWidth = 4
      FieldName = 'MembershipNum'
      Origin = 'MembershipNum'
    end
    object qryMemberMembershipStr: TWideStringField
      FieldName = 'MembershipStr'
      Origin = 'MembershipStr'
      Size = 24
    end
    object qryMemberFirstName: TWideStringField
      DisplayLabel = 'First Name'
      DisplayWidth = 18
      FieldName = 'FirstName'
      Origin = 'FirstName'
      Size = 128
    end
    object qryMemberMiddleName: TWideStringField
      FieldName = 'MiddleName'
      Origin = 'MiddleName'
      Size = 128
    end
    object qryMemberLastName: TWideStringField
      DisplayLabel = 'Last Name'
      DisplayWidth = 18
      FieldName = 'LastName'
      Origin = 'LastName'
      Size = 128
    end
    object qryMemberFName: TWideStringField
      FieldName = 'FName'
      Origin = 'FName'
      ReadOnly = True
      Required = True
      Visible = False
      Size = 257
    end
    object qryMemberDOB: TSQLTimeStampField
      DisplayWidth = 12
      FieldName = 'DOB'
      Origin = 'DOB'
      OnGetText = qryMemberDOBGetText
      OnSetText = qryMemberDOBSetText
      DisplayFormat = 'dd/mm/yyyy'
    end
    object qryMemberIsActive: TBooleanField
      Alignment = taCenter
      DisplayLabel = 'Active'
      FieldName = 'IsActive'
      Origin = 'IsActive'
    end
    object qryMemberIsSwimmer: TBooleanField
      FieldName = 'IsSwimmer'
      Origin = 'IsSwimmer'
    end
    object qryMemberIsArchived: TBooleanField
      FieldName = 'IsArchived'
      Origin = 'IsArchived'
    end
    object qryMemberEmail: TWideStringField
      DisplayWidth = 50
      FieldName = 'Email'
      Origin = 'Email'
      Size = 256
    end
    object qryMemberCreatedOn: TSQLTimeStampField
      FieldName = 'CreatedOn'
      Origin = 'CreatedOn'
    end
    object qryMemberArchivedOn: TSQLTimeStampField
      FieldName = 'ArchivedOn'
      Origin = 'ArchivedOn'
    end
    object qryMemberGenderID: TIntegerField
      FieldName = 'GenderID'
      Origin = 'GenderID'
      Visible = False
    end
    object qryMemberluGender: TStringField
      DisplayLabel = 'Gender'
      DisplayWidth = 12
      FieldKind = fkLookup
      FieldName = 'luGender'
      LookupDataSet = tblGender
      LookupKeyFields = 'GenderID'
      LookupResultField = 'Caption'
      KeyFields = 'GenderID'
      Lookup = True
    end
    object qryMemberTAGS: TWideMemoField
      FieldName = 'TAGS'
      Origin = 'TAGS'
      BlobType = ftWideMemo
    end
  end
  object tblGender: TFDTable
    ActiveStoredUsage = [auDesignTime]
    Active = True
    IndexFieldNames = 'GenderID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Gender'
    TableName = 'SwimClubMeet2..Gender'
    Left = 88
    Top = 304
  end
  object dsGender: TDataSource
    DataSet = tblGender
    Left = 152
    Top = 304
  end
  object dsContactNum: TDataSource
    DataSet = qryContactNum
    Left = 192
    Top = 72
  end
  object qryContactNum: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'mcMember_ContactNum'
        Fields = 'MemberID;ContactNumID'
        DescFields = 'ContactNumID'
      end>
    IndexName = 'mcMember_ContactNum'
    MasterSource = dsMember
    MasterFields = 'MemberID'
    DetailFields = 'MemberID'
    Connection = SCM2.scmConnection
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.ContactNum'
    UpdateOptions.KeyFields = 'ContactNumID'
    SQL.Strings = (
      'USE [SwimClubMeet];'
      ''
      'SELECT ContactNum.ContactNumID'
      #9',ContactNum.Number'
      #9',ContactNum.ContactNumTypeID'
      #9',ContactNum.MemberID'
      'FROM ContactNum;')
    Left = 88
    Top = 72
    object qryContactNumContactNumID: TFDAutoIncField
      FieldName = 'ContactNumID'
      Origin = 'ContactNumID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object qryContactNumNumber: TWideStringField
      FieldName = 'Number'
      Origin = 'Number'
      Size = 30
    end
    object qryContactNumContactNumTypeID: TIntegerField
      FieldName = 'ContactNumTypeID'
      Origin = 'ContactNumTypeID'
    end
    object qryContactNumMemberID: TIntegerField
      FieldName = 'MemberID'
      Origin = 'MemberID'
    end
    object qryContactNumlu: TStringField
      FieldKind = fkLookup
      FieldName = 'luContactNumType'
      LookupDataSet = tblContactNumType
      LookupKeyFields = 'ContactNumTypeID'
      LookupResultField = 'Caption'
      KeyFields = 'ContactNumTypeID'
      Lookup = True
    end
  end
  object qrySwimClub: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'SwimClubID'
    UpdateOptions.UpdateTableName = 'SwimClubMeet..SwimClub'
    UpdateOptions.KeyFields = 'SwimClubID'
    SQL.Strings = (
      'SELECT [SwimClubID],'
      '       [NickName],'
      '       [Caption],'
      '       [Email],'
      '       [ContactNum],'
      '       [WebSite],'
      '       [HeatAlgorithm],'
      '       [EnableTeamEvents],'
      '       [EnableSwimOThon],'
      '       [EnableExtHeatTypes],'
      '       [EnableMembershipStr],'
      '       [NumOfLanes],'
      '       [LenOfPool],'
      '       [StartOfSwimSeason],'
      '       [CreatedOn],'
      
        '       SUBSTRING(CONCAT(SwimClub.Caption, '#39' ('#39', SwimClub.NickNam' +
        'e, '#39')'#39'), 0, 60) AS DetailStr'
      'FROM SwimCLub;'
      '')
    Left = 320
    Top = 264
  end
  object dsSwimClub: TDataSource
    DataSet = qrySwimClub
    Left = 392
    Top = 264
  end
  object qryFindMember: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Filtered = True
    FilterOptions = [foCaseInsensitive]
    Filter = '(GenderID = 1 OR GenderID = 2) AND (IsActive = TRUE)'
    IndexFieldNames = 'MemberID'
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    SQL.Strings = (
      'SELECT        '
      'Member.FirstName'
      ', Member.LastName'
      ', Member.MemberID'
      ', Member.GenderID'
      ', Member.MembershipNum'
      ', FORMAT(Member.DOB, '#39'dd/MM/yyyy'#39') AS dtDOB'
      ', Member.IsActive'
      ', Gender.Caption AS cGender'
      ', Member.IsSwimmer'
      ', CONCAT(UPPER([LastName]), '#39', '#39', Member.FirstName ) AS FName'
      ', DATEDIFF ( year , [DOB], GETDATE() ) AS Age'
      'FROM            Member '
      'LEFT OUTER JOIN'
      
        '                         SwimClub ON Member.SwimClubID = SwimClu' +
        'b.SwimClubID '
      'LEFT OUTER JOIN'
      
        '                         Gender ON Member.GenderID = Gender.Gend' +
        'erID'
      #9#9#9#9#9'ORDER BY Member.LastName')
    Left = 328
    Top = 24
    object qryFindMemberMemberID: TFDAutoIncField
      Alignment = taCenter
      DisplayLabel = '  ID'
      DisplayWidth = 5
      FieldName = 'MemberID'
      Origin = 'MemberID'
      ProviderFlags = [pfInWhere, pfInKey]
      DisplayFormat = '0000'
    end
    object qryFindMemberMembershipNum: TIntegerField
      DisplayLabel = 'Num#'
      DisplayWidth = 6
      FieldName = 'MembershipNum'
      Origin = 'MembershipNum'
      DisplayFormat = '##00'
    end
    object qryFindMemberFName: TWideStringField
      DisplayLabel = 'Member'#39's Name'
      DisplayWidth = 160
      FieldName = 'FName'
      Origin = 'FName'
      ReadOnly = True
      Required = True
      Size = 258
    end
    object qryFindMemberdtDOB: TWideStringField
      Alignment = taCenter
      DisplayLabel = '  DOB'
      DisplayWidth = 11
      FieldName = 'dtDOB'
      Origin = 'dtDOB'
      ReadOnly = True
      Size = 4000
    end
    object qryFindMemberAge: TIntegerField
      Alignment = taCenter
      DisplayWidth = 3
      FieldName = 'Age'
      Origin = 'Age'
      ReadOnly = True
      DisplayFormat = '#0'
    end
    object qryFindMemberIsActive: TBooleanField
      DisplayLabel = 'Active'
      DisplayWidth = 6
      FieldName = 'IsActive'
      Origin = 'IsActive'
    end
    object qryFindMembercGender: TWideStringField
      DisplayLabel = 'Gender'
      DisplayWidth = 7
      FieldName = 'cGender'
      Origin = 'cGender'
    end
    object qryFindMemberFirstName: TWideStringField
      FieldName = 'FirstName'
      Origin = 'FirstName'
      Visible = False
      Size = 128
    end
    object qryFindMemberLastName: TWideStringField
      FieldName = 'LastName'
      Origin = 'LastName'
      Visible = False
      Size = 128
    end
    object qryFindMemberGenderID: TIntegerField
      FieldName = 'GenderID'
      Origin = 'GenderID'
      Visible = False
    end
    object qryFindMemberIsSwimmer: TBooleanField
      FieldName = 'IsSwimmer'
      Origin = 'IsSwimmer'
    end
  end
  object dsFindMember: TDataSource
    DataSet = qryFindMember
    Left = 414
    Top = 24
  end
  object qryMemberRoleLnk: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    BeforePost = qryMemberRoleLnkBeforePost
    OnNewRecord = qryMemberRoleLnkNewRecord
    IndexFieldNames = 'MemberID'
    MasterSource = dsMember
    MasterFields = 'MemberID'
    DetailFields = 'MemberID'
    Connection = SCM2.scmConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.MemberRoleLink'
    UpdateOptions.KeyFields = 'MemberRoleID;MemberID'
    SQL.Strings = (
      'USE SwimClubMeet;'
      ''
      '--DECLARE @MemberID AS INTEGER;'
      '--SET @MemberID = 1; --:MEMBERID'
      ''
      'SELECT [MemberRoleLink].[MemberRoleID]'
      '     , [MemberRoleLink].[MemberID]'
      '     , [MemberRoleLink].[CreatedOn]'
      '     , [MemberRoleLink].[IsActive]'
      '     , [MemberRoleLink].[IsArchived]'
      '     , [MemberRoleLink].[StartOn]'
      '     , [MemberRoleLink].[EndOn]'
      '     '
      'FROM MemberRoleLink'
      '    --INNER JOIN [MemberRole]'
      
        '        --ON [MemberRoleLink].[MemberRoleID] = [MemberRole].[Mem' +
        'berRoleID]'
      '--WHERE [MemberRoleLink].[MemberID] = @MemberID;')
    Left = 88
    Top = 128
    object qryMemberRoleLnkMemberRoleID: TIntegerField
      FieldName = 'MemberRoleID'
      Origin = 'MemberRoleID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryMemberRoleLnkMemberID: TIntegerField
      FieldName = 'MemberID'
      Origin = 'MemberID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryMemberRoleLnkCreatedOn: TSQLTimeStampField
      FieldName = 'CreatedOn'
      Origin = 'CreatedOn'
    end
    object qryMemberRoleLnkIsActive: TBooleanField
      FieldName = 'IsActive'
      Origin = 'IsActive'
      Required = True
    end
    object qryMemberRoleLnkIsArchived: TBooleanField
      FieldName = 'IsArchived'
      Origin = 'IsArchived'
      Required = True
    end
    object qryMemberRoleLnkluMemberRoleStr: TStringField
      FieldKind = fkLookup
      FieldName = 'luMemberRoleStr'
      LookupDataSet = tblMemberRole
      LookupKeyFields = 'MemberRoleID'
      LookupResultField = 'Caption'
      KeyFields = 'MemberRoleID'
      Required = True
      Lookup = True
    end
    object qryMemberRoleLnkElectedOn: TSQLTimeStampField
      FieldName = 'StartOn'
      Origin = 'ElectedOn'
      OnGetText = qryMemberRoleLnkElectedOnGetText
    end
    object qryMemberRoleLnkRetiredOn: TSQLTimeStampField
      FieldName = 'EndOn'
      Origin = 'RetiredOn'
    end
  end
  object dsMemberRoleLnk: TDataSource
    DataSet = qryMemberRoleLnk
    Left = 192
    Top = 128
  end
  object tblMemberRole: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'MemberRoleID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'SwimClubMeet2.dbo.MemberRole'
    Left = 88
    Top = 528
  end
  object tblSwimClub: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'SwimClubID'
    DetailFields = 'SwimClubID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    TableName = 'SwimClubMeet2..SwimClub'
    Left = 88
    Top = 592
  end
  object dsluSwimClub: TDataSource
    DataSet = tblSwimClub
    Left = 184
    Top = 592
  end
end
