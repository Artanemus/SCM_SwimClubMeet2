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
    Left = 184
    Top = 552
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
      'SELECT [MemberID],'
      '       [MembershipNum],'
      '       [MembershipStr],'
      '       [FirstName],'
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
        Value = False
      end
      item
        Name = 'HIDE_ARCHIVED'
        DataType = ftBoolean
        ParamType = ptInput
        Value = False
      end
      item
        Name = 'HIDE_NONSWIMMERS'
        DataType = ftBoolean
        ParamType = ptInput
        Value = False
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
    Left = 936
    Top = 280
  end
  object dsSwimClub: TDataSource
    DataSet = qrySwimClub
    Left = 1008
    Top = 280
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
    Left = 624
    Top = 96
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
    Left = 710
    Top = 96
  end
  object qAssertMemberID: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'MemberID'
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    SQL.Strings = (
      'SELECT MemberID, MembershipNum FROM Member WHERE SwimClubID = 1')
    Left = 624
    Top = 184
  end
  object qryEntrantDataCount: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    SQL.Strings = (
      'USE SwimClubMeet;'
      ''
      'DECLARE @MemberID as INTEGER;'
      'SET @MemberID = :MEMBERID; -- 57;'
      ''
      'SELECT Count(EntrantID) as TOT '
      'FROM Entrant '
      'WHERE MemberID = @MemberID AND '
      
        '(RaceTime IS NOT NULL OR (dbo.SwimTimeToMilliseconds(RaceTime) >' +
        ' 0))'
      ';')
    Left = 624
    Top = 248
    ParamData = <
      item
        Name = 'MEMBERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 57
      end>
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
    Left = 624
    Top = 336
  end
  object dsMemberPB: TDataSource
    DataSet = qryMemberPB
    Left = 585
    Top = 496
  end
  object qryMemberPB: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'MemberID'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvFmtDisplayTime]
    FormatOptions.FmtDisplayTime = 'nn:ss.zzz'
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2..Member'
    UpdateOptions.KeyFields = 'MemberID'
    SQL.Strings = (
      ''
      ''
      'DECLARE @memberid as int'
      'SET @memberid = :MEMBERID'
      ''
      'SELECT DISTINCT Member.MemberID'
      #9',Distance.DistanceID'
      #9',Stroke.StrokeID'
      
        #9',dbo.PersonalBest(MemberID, DistanceID, StrokeID, GETDATE()) AS' +
        ' PB'
      #9',('
      #9#9'CONCAT ('
      #9#9#9'distance.caption'
      #9#9#9','#39' '#39
      #9#9#9',stroke.caption'
      #9#9#9')'
      #9#9') AS EventStr'
      'FROM Distance'
      'CROSS JOIN Stroke'
      'CROSS JOIN Member'
      
        'WHERE Member.MemberID = @memberid AND dbo.PersonalBest(MemberID,' +
        ' DistanceID, StrokeID, GETDATE()) IS NOT NULL'
      'ORDER BY MemberID'
      #9',DistanceID'
      #9',StrokeID'
      #9',PB ASC'
      ';')
    Left = 497
    Top = 496
    ParamData = <
      item
        Name = 'MEMBERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryMemberPBEventStr: TWideStringField
      FieldName = 'EventStr'
      Origin = 'EventStr'
      ReadOnly = True
      Required = True
      Size = 257
    end
    object qryMemberPBPB: TTimeField
      FieldName = 'PB'
      Origin = 'PB'
      ReadOnly = True
      DisplayFormat = 'nn:ss.zzz'
    end
    object qryMemberPBMemberID: TFDAutoIncField
      FieldName = 'MemberID'
      Origin = 'MemberID'
      ProviderFlags = [pfInWhere, pfInKey]
      Visible = False
    end
    object qryMemberPBDistanceID: TFDAutoIncField
      FieldName = 'DistanceID'
      Origin = 'DistanceID'
      Visible = False
    end
    object qryMemberPBStrokeID: TFDAutoIncField
      FieldName = 'StrokeID'
      Origin = 'StrokeID'
      Visible = False
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
    Left = 184
    Top = 608
  end
  object dsMemberEvents: TDataSource
    DataSet = qryMemberEvents
    Left = 192
    Top = 184
  end
  object qryMemberEvents: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'MemberID'
    MasterSource = dsMember
    MasterFields = 'MemberID'
    DetailFields = 'MemberID'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvFmtDisplayTime]
    FormatOptions.FmtDisplayTime = 'nn:ss.zzz'
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Event'
    UpdateOptions.KeyFields = 'EventID'
    SQL.Strings = (
      'DECLARE @EventID AS INteger;'
      'SET @EventID = :EVENTID;'
      ''
      ''
      'SELECT '
      '[Event].EventID'
      ',Nominee.MemberID '
      ',Concat(Member.FirstName, '#39' '#39', Member.LastName) AS FName'
      ',Concat(Distance.Caption, '#39' '#39', Stroke.Caption) AS EventStr'
      ',Lane.RaceTime'
      ', CONVERT(VARCHAR(11), Session.SessionDT, 106) AS EventDate '
      ''
      'FROM [Event]'
      'INNER JOIN Session ON [Event].SessionID = Session.SessionID'
      'INNER JOIN Stroke ON [Event].StrokeID = Stroke.StrokeID'
      'INNER JOIN Distance ON [Event].DistanceID = Distance.DistanceID'
      'INNER JOIN Heat ON [Event].EventID = Heat.EventID'
      'INNER JOIN Lane ON [Heat].HeatID = Lane.HeatID'
      'INNER JOIN Nominee ON Lane.NomineeID = Nominee.NomineeID'
      
        'INNER JOIN Member ON Nominee.MemberID = Member.MemberID AND [Eve' +
        'nt].[EventID] = Nominee.EventID'
      'WHERE RaceTime IS NOT NULL'
      'ORDER BY Session.SessionDT ASC, Distance.Meters, Stroke.StrokeID'
      ';')
    Left = 88
    Top = 184
    ParamData = <
      item
        Name = 'EVENTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryMemberEventsEventID: TFDAutoIncField
      DisplayWidth = 5
      FieldName = 'EventID'
      Origin = 'EventID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object qryMemberEventsMemberID: TIntegerField
      DisplayWidth = 5
      FieldName = 'MemberID'
      Origin = 'MemberID'
    end
    object qryMemberEventsFName: TWideStringField
      DisplayWidth = 20
      FieldName = 'FName'
      Origin = 'FName'
      ReadOnly = True
      Required = True
      Size = 257
    end
    object qryMemberEventsEventStr: TWideStringField
      DisplayWidth = 18
      FieldName = 'EventStr'
      Origin = 'EventStr'
      ReadOnly = True
      Required = True
      Size = 257
    end
    object qryMemberEventsRaceTime: TTimeField
      FieldName = 'RaceTime'
      Origin = 'RaceTime'
      DisplayFormat = 'nn:ss.zzz'
    end
    object qryMemberEventsEventDate: TStringField
      FieldName = 'EventDate'
      Origin = 'EventDate'
      ReadOnly = True
      Size = 11
    end
  end
  object qryChart: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvFmtDisplayDateTime]
    FormatOptions.FmtDisplayDateTime = 'dd/mmm/yyyy'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'DECLARE @StrokeID AS INT;'
      'DECLARE @DistanceID AS INT;'
      'DECLARE @MemberID AS INT;'
      'DECLARE @DoCurrSeason AS BIT;'
      'DECLARE @MaxRecords AS INT;'
      ''
      'SET @StrokeID = :STROKEID;'
      'SET @DistanceID = :DISTANCEID;'
      'SET @MemberID = :MEMBERID;'
      'SET @DoCurrSeason = :DOCURRSEASON;'
      'SET @MaxRecords = :MAXRECORDS;'
      ''
      'IF OBJECT_ID('#39'tempdb..#charttemp'#39') IS NOT NULL'
      '    DROP TABLE #charttemp;'
      '    '
      'IF @MaxRecords IS NULL SET @MaxRecords = 26;'
      ''
      ''
      
        'SELECT TOP (@MaxRecords) [dbo].[SwimTimeToString](Lane.RaceTime)' +
        ' AS RaceTimeAsString'
      #9',(DATEPART(MILLISECOND, Lane.RaceTime) / 1000.0) '
      '                + (DATEPART(SECOND, Lane.RaceTime)) '
      
        '                + (DATEPART(MINUTE, Lane.RaceTime) * 60.0) AS Se' +
        'conds'
      ''
      #9',Session.SessionDT'
      #9',Distance.Caption AS cDistance'
      #9',Stroke.Caption AS cStroke'
      ''
      'INTO #charttemp'
      'FROM [dbo].[Lane]'
      'INNER JOIN Heat ON Lane.HeatID = Heat.HeatID'
      'INNER JOIN Event ON Heat.EventID = Event.EventID'
      
        'INNER JOIN Nominee ON Lane.NomineeID = Nominee.NomineeID AND Eve' +
        'nt.EventID = Nominee.EventID'
      'INNER JOIN Session ON Event.SessionID = Session.SessionID'
      'INNER JOIN SwimClub ON Session.SwimClubID = SwimClub.SwimClubID'
      'INNER JOIN Stroke ON Event.StrokeID = Stroke.StrokeID'
      'INNER JOIN Distance ON Event.DistanceID = Distance.DistanceID'
      'WHERE (Event.StrokeID = @StrokeID)'
      #9'AND (Event.DistanceID = @DistanceID) '
      '        AND (Nominee.MemberID = @MemberID) '
      '        AND Lane.RaceTime IS NOT NULL'
      #9#9'-- playing it extra careful'
      #9#9'AND CONVERT(time(0), Lane.RaceTime) > '#39'00:00:00'#39
      '        AND ('
      
        '           (@DoCurrSeason = 1 AND Session.SessionDT >= SwimClub.' +
        'StartOfSwimSeason)'
      '           OR'
      '           (@DoCurrSeason = 0)'
      #9#9' )'
      '        '
      'ORDER BY SessionDT DESC;'
      ''
      'SELECT '
      #9'RaceTimeAsString'
      #9',Seconds'
      #9',SessionDT'
      #9',cDistance'
      #9',cStroke'
      
        ',ROW_NUMBER()OVER (PARTITION BY 1  ORDER BY SessionDT ) AS Chart' +
        'X'
      'FROM'
      '#charttemp'
      'ORDER BY SessionDT ASC;'
      '')
    Left = 496
    Top = 552
    ParamData = <
      item
        Name = 'STROKEID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 2
      end
      item
        Name = 'DISTANCEID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 2
      end
      item
        Name = 'MEMBERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 9
      end
      item
        Name = 'DOCURRSEASON'
        DataType = ftBoolean
        ParamType = ptInput
        Value = False
      end
      item
        Name = 'MAXRECORDS'
        DataType = ftInteger
        ParamType = ptInput
        Value = 26
      end>
  end
  object dsChart: TDataSource
    DataSet = qryChart
    Left = 584
    Top = 552
  end
  object tblSwimClub: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'SwimClubID'
    DetailFields = 'SwimClubID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    TableName = 'SwimClubMeet2..SwimClub'
    Left = 184
    Top = 672
  end
  object dsluSwimClub: TDataSource
    DataSet = tblSwimClub
    Left = 280
    Top = 672
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
    Left = 928
    Top = 88
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
    Left = 1016
    Top = 88
  end
  object qryDataCheckPart: TFDQuery
    SQL.Strings = (
      'DECLARE @SwimClubID AS INteger;'
      'SET @SwimClubID = :SWIMCLUBID;'
      ''
      'SELECT [MemberID]'
      '      ,'#39'No firstname.'#39' as MSG'
      '  FROM [dbo].[Member]'
      'WHERE firstname IS NULL AND SwimClubID = @SwimClubID'
      'ORDER BY MemberID DESC;')
    Left = 928
    Top = 152
    ParamData = <
      item
        Name = 'SWIMCLUBID'
        ParamType = ptInput
      end>
  end
  object dsDataCheckPart: TDataSource
    DataSet = qryDataCheckPart
    Enabled = False
    Left = 1024
    Top = 152
  end
end
