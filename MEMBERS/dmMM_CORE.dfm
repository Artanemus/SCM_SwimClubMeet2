object MM_CORE: TMM_CORE
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 472
  Width = 928
  object tblContactNumType: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'ContactNumTypeID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2..ContactNumType'
    Left = 704
    Top = 176
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
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Stroke'
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2..Stroke'
    Left = 704
    Top = 56
  end
  object tblDistance: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'DistanceID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Distance'
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2..Distance'
    Left = 704
    Top = 104
  end
  object dsMember: TDataSource
    DataSet = qMember
    Left = 112
    Top = 8
  end
  object tblGender: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'GenderID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Gender'
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2..Gender'
    Left = 704
    Top = 8
  end
  object dsluGender: TDataSource
    DataSet = tblGender
    Left = 800
    Top = 8
  end
  object dsContactNum: TDataSource
    DataSet = qryContactNum
    Left = 216
    Top = 64
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
      'USE [SwimClubMeet2];'
      ''
      'SELECT ContactNum.ContactNumID'
      #9',ContactNum.Number'
      #9',ContactNum.ContactNumTypeID'
      #9',ContactNum.MemberID'
      'FROM ContactNum;')
    Left = 112
    Top = 64
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
      'USE SwimClubMeet2;'
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
    Left = 112
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
    Left = 216
    Top = 128
  end
  object tblMemberRole: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'MemberRoleID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2.dbo.MemberRole'
    Left = 704
    Top = 232
  end
  object tblSwimClub: TFDTable
    ActiveStoredUsage = [auDesignTime]
    Active = True
    Filtered = True
    Filter = '(IsClubGroup <> 1) AND (IsArchived <> 1)'
    IndexFieldNames = 'SwimClubID'
    DetailFields = 'SwimClubID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2..SwimClub'
    Left = 704
    Top = 296
  end
  object dsluSwimClub: TDataSource
    DataSet = tblSwimClub
    Left = 808
    Top = 296
  end
  object qMember: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Active = True
    OnNewRecord = qMemberNewRecord
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxFilterOff'
        Fields = 'MemberID'
      end
      item
        Active = True
        Name = 'idxHideArchived'
        Fields = 'MemberID'
        Options = [soDescending]
        Filter = 'IsArchived=false'
      end
      item
        Active = True
        Name = 'idxHideInActive'
        Fields = 'MemberID'
        Filter = 'IsActive=true'
      end
      item
        Active = True
        Name = 'idxHideNonSwimmer'
        Fields = 'MemberID'
        Filter = 'IsSwimmer=true'
      end
      item
        Active = True
        Name = 'idxArchivedInActive'
        Fields = 'MemberID'
        Filter = 'IsArchived=false and IsActive=true'
      end
      item
        Active = True
        Name = 'idxArchivedInActiveNonSwimmer'
        Fields = 'MemberID'
        Filter = 'IsArchived=false and IsActive=true and IsSwimmer=true'
      end
      item
        Active = True
        Name = 'idxInActiveNonSwimmer'
        Fields = 'MemberID'
        Filter = 'IsActive=true and IsSwimmer=true'
      end
      item
        Active = True
        Name = 'idxArchivedNonSwimmer'
        Fields = 'MemberID'
        Filter = 'IsArchived=false and IsSwimmer=true'
      end>
    IndexName = 'idxFilterOff'
    Connection = SCM2.scmConnection
    UpdateOptions.AssignedValues = [uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Member'
    UpdateOptions.KeyFields = 'MemberID'
    SQL.Strings = (
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
      'FROM [SwimClubMeet2].[dbo].[Member]  '
      ''
      '     '
      ''
      ''
      ''
      '')
    Left = 16
    Top = 8
    object qMemberMemberID: TFDAutoIncField
      FieldName = 'MemberID'
      Origin = 'MemberID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object qMemberMembershipNum: TIntegerField
      FieldName = 'MembershipNum'
      Origin = 'MembershipNum'
    end
    object qMemberMembershipStr: TWideStringField
      FieldName = 'MembershipStr'
      Origin = 'MembershipStr'
      Size = 24
    end
    object qMemberFirstName: TWideStringField
      FieldName = 'FirstName'
      Origin = 'FirstName'
      Size = 128
    end
    object qMemberMiddleName: TWideStringField
      FieldName = 'MiddleName'
      Origin = 'MiddleName'
      Size = 128
    end
    object qMemberLastName: TWideStringField
      FieldName = 'LastName'
      Origin = 'LastName'
      Size = 128
    end
    object qMemberDOB: TSQLTimeStampField
      FieldName = 'DOB'
      Origin = 'DOB'
    end
    object qMemberIsActive: TBooleanField
      FieldName = 'IsActive'
      Origin = 'IsActive'
      Required = True
      OnGetText = qMemberIsActiveGetText
      OnSetText = qMemberIsActiveSetText
    end
    object qMemberIsSwimmer: TBooleanField
      FieldName = 'IsSwimmer'
      Origin = 'IsSwimmer'
      Required = True
    end
    object qMemberIsArchived: TBooleanField
      FieldName = 'IsArchived'
      Origin = 'IsArchived'
      Required = True
    end
    object qMemberEmail: TWideStringField
      FieldName = 'Email'
      Origin = 'Email'
      Size = 256
    end
    object qMemberGenderID: TIntegerField
      FieldName = 'GenderID'
      Origin = 'GenderID'
    end
    object qMemberFName: TWideStringField
      FieldName = 'FName'
      Origin = 'FName'
      ReadOnly = True
      Required = True
      Size = 257
    end
    object qMemberCreatedOn: TSQLTimeStampField
      FieldName = 'CreatedOn'
      Origin = 'CreatedOn'
    end
    object qMemberArchivedOn: TSQLTimeStampField
      FieldName = 'ArchivedOn'
      Origin = 'ArchivedOn'
    end
    object qMemberTAGS: TWideMemoField
      FieldName = 'TAGS'
      Origin = 'TAGS'
      BlobType = ftWideMemo
    end
    object qMemberluGender: TStringField
      FieldKind = fkLookup
      FieldName = 'luGender'
      LookupDataSet = tblGender
      LookupKeyFields = 'GenderID'
      LookupResultField = 'Caption'
      KeyFields = 'GenderID'
      LookupCache = True
      Lookup = True
    end
  end
  object qryHouse: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'SwimClubID'
    MasterSource = dsSwimClub
    MasterFields = 'SwimClubID'
    DetailFields = 'SwmClubID'
    Connection = SCM2.scmConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.House'
    UpdateOptions.KeyFields = 'HouseID'
    Left = 320
    Top = 320
  end
  object dsHouse: TDataSource
    DataSet = qryHouse
    Left = 424
    Top = 320
  end
  object dsSwimClub: TDataSource
    DataSet = qrySwimClub
    Left = 320
    Top = 256
  end
  object qrySwimClub: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'SwimClubID'
    MasterSource = dsMemberLink
    MasterFields = 'SwimClubID'
    DetailFields = 'SwimClubID'
    Connection = SCM2.scmConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.SwimClub'
    UpdateOptions.KeyFields = 'SwimClubID'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'SELECT [SwimClubID]'
      '      ,[GUID]'
      '      ,[NickName]'
      '      ,[Caption]'
      '      ,[Email]'
      '      ,[ContactNum]'
      '      ,[WebSite]'
      '      ,[HeatAlgorithm]'
      '      ,[EnableSimpleDQ]'
      '      ,[NumOfLanes]'
      '      ,[LenOfPool]'
      '      ,[DefTeamSize]'
      '      ,[StartOfSwimSeason]'
      '      ,[CreatedOn]'
      '      ,[LogoImg]'
      '      ,[IsArchived]'
      '      ,[IsClubGroup]'
      '      ,[PoolTypeID]'
      '      ,[SwimClubTypeID]'
      '  FROM [SwimClubMeet2].[dbo].[SwimClub]'
      '  WHERE IsClubGroup <> 1 AND IsArchived <> 1'
      '')
    Left = 216
    Top = 256
  end
  object qryMemberLink: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'MemberID'
    MasterSource = dsMember
    MasterFields = 'MemberID'
    DetailFields = 'MemberID'
    Connection = SCM2.scmConnection
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.MemberLink'
    UpdateOptions.KeyFields = 'MemberID;SwimClubID'
    SQL.Strings = (
      'SELECT [MemberID]'
      '      ,[SwimClubID]'
      '      ,[HouseID]'
      '      ,[IsArchived]'
      '  FROM [SwimClubMeet2].[dbo].[MemberLink]')
    Left = 112
    Top = 192
    object qryMemberLinkMemberID: TIntegerField
      FieldName = 'MemberID'
      Origin = 'MemberID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryMemberLinkSwimClubID: TIntegerField
      FieldName = 'SwimClubID'
      Origin = 'SwimClubID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryMemberLinkHouseID: TIntegerField
      FieldName = 'HouseID'
      Origin = 'HouseID'
    end
    object qryMemberLinkluHouseStr: TStringField
      FieldKind = fkLookup
      FieldName = 'luHouseStr'
      LookupDataSet = tblHouse
      LookupKeyFields = 'HouseID'
      LookupResultField = 'Caption'
      KeyFields = 'HouseID'
      Size = 64
      Lookup = True
    end
    object qryMemberLinkluSwimClubStr: TStringField
      FieldKind = fkLookup
      FieldName = 'luSwimClubStr'
      LookupDataSet = tblSwimClub
      LookupKeyFields = 'SwimClubID'
      LookupResultField = 'Caption'
      KeyFields = 'SwimClubID'
      Size = 64
      Lookup = True
    end
    object qryMemberLinkIsArchived: TBooleanField
      FieldName = 'IsArchived'
      Origin = 'IsArchived'
      Required = True
    end
  end
  object dsMemberLink: TDataSource
    DataSet = qryMemberLink
    Left = 216
    Top = 192
  end
  object tblHouse: TFDTable
    ActiveStoredUsage = [auDesignTime]
    Active = True
    IndexFieldNames = 'HouseID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.House'
    UpdateOptions.KeyFields = 'HouseID'
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'House'
    Left = 704
    Top = 360
  end
  object dsluHouse: TDataSource
    DataSet = tblHouse
    Left = 808
    Top = 360
  end
end
