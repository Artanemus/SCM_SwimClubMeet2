object MM_CORE: TMM_CORE
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 738
  Width = 1139
  object tblContactNumType: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'ContactNumTypeID'
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
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Stroke'
    TableName = 'SwimClubMeet2..Stroke'
    Left = 88
    Top = 352
  end
  object tblDistance: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'DistanceID'
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Distance'
    TableName = 'SwimClubMeet2..Distance'
    Left = 88
    Top = 400
  end
  object dsMember: TDataSource
    DataSet = qMember
    Left = 264
    Top = 16
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
    Left = 272
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
    Left = 168
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
  object qryMemberRoleLnk: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    BeforePost = qryMemberRoleLnkBeforePost
    OnNewRecord = qryMemberRoleLnkNewRecord
    IndexFieldNames = 'MemberID'
    MasterSource = dsMember
    MasterFields = 'MemberID'
    DetailFields = 'MemberID'
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
    Left = 168
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
    Left = 272
    Top = 128
  end
  object tblMemberRole: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'MemberRoleID'
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'SwimClubMeet2.dbo.MemberRole'
    Left = 88
    Top = 528
  end
  object tblSwimClub: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'SwimClubID'
    DetailFields = 'SwimClubID'
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
    Left = 168
    Top = 16
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
      Lookup = True
    end
  end
end
