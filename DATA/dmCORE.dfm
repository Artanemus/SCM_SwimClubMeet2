object CORE: TCORE
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 782
  Width = 1135
  object dsSwimClub: TDataSource
    DataSet = qrySwimClub
    Left = 112
    Top = 40
  end
  object dsSession: TDataSource
    DataSet = qrySession
    Left = 240
    Top = 72
  end
  object dsEvent: TDataSource
    DataSet = qryEvent
    Left = 240
    Top = 128
  end
  object dsHeat: TDataSource
    DataSet = qryHeat
    Left = 368
    Top = 216
  end
  object qrySession: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    BeforePost = qrySessionBeforePost
    AfterPost = qrySessionAfterPost
    AfterScroll = qrySessionAfterScroll
    OnNewRecord = qrySessionNewRecord
    Indexes = <
      item
        Active = True
        Name = 'indxHideLocked'
        Fields = 'SwimClubID'
        Filter = 'SessionStatusID = 1'
      end
      item
        Active = True
        Selected = True
        Name = 'indxShowAll'
        Fields = 'SwimClubID'
      end>
    IndexName = 'indxShowAll'
    MasterSource = dsSwimClub
    MasterFields = 'SwimClubID'
    DetailFields = 'SwimClubID'
    FormatOptions.AssignedValues = [fvFmtDisplayDateTime]
    FormatOptions.FmtDisplayDateTime = 'YYYY-MM-DD hh:nn'
    UpdateOptions.AssignedValues = [uvEInsert]
    UpdateOptions.UpdateTableName = 'SwimClubMeet2..Session'
    UpdateOptions.KeyFields = 'SessionID'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'SELECT [SessionID]'
      '      ,[SessionDT]'
      '      ,[Caption]'
      '      ,[NomineeCount]'
      '      ,[EntrantCount]'
      '      ,[CreatedOn]'
      '      ,[ModifiedOn]'
      '      ,[SwimClubID]'
      '      ,[SessionStatusID]'
      '  FROM [SwimClubMeet2].[dbo].[Session]'
      '  ORDER BY SessionID DESC;'
      ''
      '/*'
      'DECLARE @Toggle AS BIT'
      'SET @Toggle = :TOGGLE'
      ''
      'if @Toggle = 0'
      ''
      'SELECT Session.SessionID, '
      'Session.SessionStart, '
      'Session.SwimClubID, '
      'Session.SessionStatusID, '
      'Session.ClosedDT, '
      'SessionStatus.Caption AS Status, '
      'Session.Caption'
      'FROM [dbo].[Session] '
      
        'LEFT OUTER JOIN SessionStatus ON Session.SessionStatusID = Sessi' +
        'onStatus.SessionStatusID'
      'ORDER BY Session.SessionStart DESC'
      ''
      'else'
      ''
      'SELECT Session.SessionID, '
      'Session.SessionStart, '
      'Session.SwimClubID, '
      'Session.SessionStatusID,  '
      'Session.ClosedDT, '
      'SessionStatus.Caption AS Status, '
      'Session.Caption'
      'FROM [dbo].[Session] '
      
        'LEFT OUTER JOIN SessionStatus ON Session.SessionStatusID = Sessi' +
        'onStatus.SessionStatusID'
      'WHERE Session.SessionStatusID = 1'
      'ORDER BY Session.SessionStart DESC'
      '*/')
    Left = 176
    Top = 72
    object qrySessionSessionID: TFDAutoIncField
      FieldName = 'SessionID'
      Origin = 'SessionID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object qrySessionSessionDT: TSQLTimeStampField
      FieldName = 'SessionDT'
      Origin = 'SessionDT'
      OnGetText = qrySessionSessionDTGetText
      OnSetText = qrySessionSessionDTSetText
      DisplayFormat = 'YYYY-MM-DD hh:nn'
      EditMask = '!9999-90-00 90:99;1;0'
    end
    object qrySessionCaption: TWideStringField
      FieldName = 'Caption'
      Origin = 'Caption'
      Size = 128
    end
    object qrySessionNomineeCount: TIntegerField
      FieldName = 'NomineeCount'
      Origin = 'NomineeCount'
    end
    object qrySessionEntrantCount: TIntegerField
      FieldName = 'EntrantCount'
      Origin = 'EntrantCount'
    end
    object qrySessionCreatedOn: TSQLTimeStampField
      FieldName = 'CreatedOn'
      Origin = 'CreatedOn'
      DisplayFormat = 'YYYY-MM-DD hh:nn'
    end
    object qrySessionModifiedOn: TSQLTimeStampField
      FieldName = 'ModifiedOn'
      Origin = 'ModifiedOn'
      DisplayFormat = 'YYYY-MM-DD hh:nn'
    end
    object qrySessionSwimClubID: TIntegerField
      FieldName = 'SwimClubID'
      Origin = 'SwimClubID'
    end
    object qrySessionSessionStatusID: TIntegerField
      FieldName = 'SessionStatusID'
      Origin = 'SessionStatusID'
    end
  end
  object qryEvent: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    AfterEdit = qryEventAfterEdit
    AfterScroll = qryEventAfterScroll
    OnNewRecord = qryEventNewRecord
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'indxSession_DESC'
        Fields = 'SessionID'
        DescFields = 'SessionID'
      end>
    IndexFieldNames = 'SessionID'
    MasterSource = dsSession
    MasterFields = 'SessionID'
    DetailFields = 'SessionID'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvFmtDisplayTime]
    FormatOptions.FmtDisplayTime = 'hh:nn'
    UpdateOptions.UpdateTableName = 'SwimClubMeet2..Event'
    UpdateOptions.KeyFields = 'EventID'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'SELECT [Event].[EventID]'
      '      ,[Event].[EventNum]'
      '      ,[Event].[Caption]'
      '      ,[StartTime]'
      
        '      ,[Event].[NomineeCount]  --, dbo.NomineeCount([Event].[Eve' +
        'ntID]) AS NomineeCount'
      
        '      ,[Event].[EntrantCount]  --, dbo.EntrantCount([Event].[Eve' +
        'ntID]) AS EntrantCount'
      '      ,[Event].[SessionID]'
      '      ,[Event].[StrokeID]'
      '      ,[Event].[DistanceID]'
      '      ,[EventStatusID]'
      '      ,[Event].[RoundID]'
      '      ,[Event].[GenderID]'
      '      ,[Event].[EventCategoryID]'
      '      ,[Event].[ParalympicTypeID]'
      '      ,[Event].[EventTypeID] '
      
        '      ,LEFT([Distance].[Caption],8) AS DistanceStr -- use LookUp' +
        ' value?'
      
        '      ,LEFT([Stroke].[Caption],16) AS StrokeStr -- use LookUp va' +
        'lue?'
      '      ,LEFT('
      '       CONCAT('#39'#'#39', Event.EventNum, '#39' - '#39', '
      '         Distance.Caption, '#39' '#39', '
      '         Stroke.Caption, '#39'  '#39' ,'
      '         UPPER(EventType.ABREV) )'
      '         ,30) AS ShortCaption'
      '      ,[Distance].Meters'
      '      ,[EventType].ABREV'
      'FROM [SwimClubMeet2].[dbo].[Event]'
      '    LEFT OUTER JOIN Stroke'
      '        ON Stroke.StrokeID = Event.StrokeID'
      '    LEFT OUTER JOIN Distance'
      '        ON Distance.DistanceID = Event.DistanceID'
      '    LEFT OUTER JOIN EventType'
      '        ON EventType.EventTypeID = Event.EventTypeID'
      'ORDER BY Event.EventNum;'
      ''
      '')
    Left = 176
    Top = 128
    object qryEventEventID: TFDAutoIncField
      FieldName = 'EventID'
      Origin = 'EventID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object qryEventEventNum: TIntegerField
      DisplayLabel = ' Ev#'
      DisplayWidth = 5
      FieldName = 'EventNum'
      Origin = 'EventNum'
    end
    object qryEventCaption: TWideStringField
      DisplayLabel = 'Event Description'
      DisplayWidth = 60
      FieldName = 'Caption'
      Origin = 'Caption'
      Size = 128
    end
    object qryEventShortCaption: TWideStringField
      FieldName = 'ShortCaption'
      Origin = 'ShortCaption'
      Size = 273
    end
    object qryEventStartTime: TTimeField
      FieldName = 'StartTime'
      Origin = 'StartTime'
      DisplayFormat = 'hh:nn'
    end
    object qryEventNomineeCount: TIntegerField
      FieldName = 'NomineeCount'
      Origin = 'NomineeCount'
    end
    object qryEventEntrantCount: TIntegerField
      FieldName = 'EntrantCount'
      Origin = 'EntrantCount'
    end
    object qryEventSessionID: TIntegerField
      FieldName = 'SessionID'
      Origin = 'SessionID'
    end
    object qryEventStrokeID: TIntegerField
      FieldName = 'StrokeID'
      Origin = 'StrokeID'
    end
    object qryEventDistanceID: TIntegerField
      FieldName = 'DistanceID'
      Origin = 'DistanceID'
    end
    object qryEventEventStatusID: TIntegerField
      FieldName = 'EventStatusID'
      Origin = 'EventStatusID'
    end
    object qryEventRoundID: TIntegerField
      FieldName = 'RoundID'
      Origin = 'RoundID'
    end
    object qryEventGenderID: TIntegerField
      FieldName = 'GenderID'
      Origin = 'GenderID'
    end
    object qryEventParalympicTypeID: TIntegerField
      FieldName = 'ParalympicTypeID'
      Origin = 'ParalympicTypeID'
    end
    object qryEventEventTypeID: TIntegerField
      FieldName = 'EventTypeID'
      Origin = 'EventTypeID'
    end
    object qryEventEventCategoryID: TIntegerField
      FieldName = 'EventCategoryID'
      Origin = 'EventCategoryID'
    end
    object qryEventDistanceStr: TWideStringField
      FieldName = 'DistanceStr'
      Origin = 'DistanceStr'
      ProviderFlags = []
      Size = 128
    end
    object qryEventStrokeStr: TWideStringField
      FieldName = 'StrokeStr'
      Origin = 'StrokeStr'
      ProviderFlags = []
      Size = 128
    end
    object LookUpStroke: TStringField
      DisplayLabel = 'Stroke'
      DisplayWidth = 14
      FieldKind = fkLookup
      FieldName = 'luStroke'
      LookupDataSet = tblStroke
      LookupKeyFields = 'StrokeID'
      LookupResultField = 'Caption'
      KeyFields = 'StrokeID'
      LookupCache = True
      Lookup = True
    end
    object LookUpDistance: TStringField
      DisplayLabel = 'Distance'
      DisplayWidth = 12
      FieldKind = fkLookup
      FieldName = 'luDistance'
      LookupDataSet = tblDistance
      LookupKeyFields = 'DistanceID'
      LookupResultField = 'Caption'
      KeyFields = 'DistanceID'
      LookupCache = True
      Lookup = True
    end
    object LookUpEventType: TStringField
      DisplayLabel = 'EventType'
      FieldKind = fkLookup
      FieldName = 'luEventType'
      LookupDataSet = tblEventType
      LookupKeyFields = 'EventTypeID'
      LookupResultField = 'ABREV'
      KeyFields = 'EventTypeID'
      LookupCache = True
      Lookup = True
    end
    object LookUpGender: TStringField
      FieldKind = fkLookup
      FieldName = 'luGender'
      LookupDataSet = tblGender
      LookupKeyFields = 'GenderID'
      LookupResultField = 'ABREV'
      KeyFields = 'GenderID'
      LookupCache = True
      Size = 4
      Lookup = True
    end
    object LookUpRound: TStringField
      DisplayLabel = 'Round'
      FieldKind = fkLookup
      FieldName = 'luRound'
      LookupDataSet = tblRound
      LookupKeyFields = 'RoundID'
      LookupResultField = 'CaptionShort'
      KeyFields = 'RoundID'
      LookupCache = True
      Size = 8
      Lookup = True
    end
    object LookUpParalympicType: TStringField
      FieldKind = fkLookup
      FieldName = 'luParalympicType'
      LookupDataSet = tblParalympicType
      LookupKeyFields = 'ParalympicTypeID'
      LookupResultField = 'Caption'
      KeyFields = 'ParalympicTypeID'
      LookupCache = True
      Size = 24
      Lookup = True
    end
    object LookUpEventCat: TStringField
      FieldKind = fkLookup
      FieldName = 'luEventCat'
      LookupDataSet = tblEventCat
      LookupKeyFields = 'EventCategoryID'
      LookupResultField = 'ABREV'
      KeyFields = 'EventCategoryID'
      LookupCache = True
      Size = 10
      Lookup = True
    end
    object qryEventMeters: TIntegerField
      FieldName = 'Meters'
      Origin = 'Meters'
      ProviderFlags = []
    end
    object qryEventABREV: TWideStringField
      FieldName = 'ABREV'
      Origin = 'ABREV'
      Size = 5
    end
  end
  object qryHeat: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    AfterPost = qryHeatAfterPost
    AfterScroll = qryHeatAfterScroll
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'indxEvent_DESC'
        Fields = 'EventID'
        DescFields = 'EventID'
      end
      item
        Name = 'indxRenumberHeats'
        Fields = 'EventID;HeatID;HeatNum'
        Options = [soDescNullLast]
      end>
    IndexName = 'indxEvent_DESC'
    MasterSource = dsEvent
    MasterFields = 'EventID'
    DetailFields = 'EventID'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvFmtDisplayTime]
    FormatOptions.FmtDisplayTime = 'hh.nn'
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2..Heat'
    UpdateOptions.KeyFields = 'HeatID'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'SELECT [Heat].[HeatID]'
      '      ,[Heat].[HeatNum]'
      '      ,[Heat].[Caption]'
      '      ,[Heat].[StartTime]'
      '      ,[Heat].[EventID]'
      '      ,[Heat].[HeatTypeID]'
      '      ,[Heat].[HeatStatusID]'
      
        '  ,[Event].[StrokeID] -- needed to paint coloured circle in grid' +
        'Heat.'
      ''
      'FROM'
      '  [SwimClubMeet2].[dbo].[Heat]'
      
        '  LEFT JOIN HeatStatus ON Heat.HeatStatusID = HeatStatus.HeatSta' +
        'tusID'
      
        '  INNER JOIN [dbo].[Event] ON [Heat].[EventID] = [Event].[EventI' +
        'D]'
      '  -- WHERE [Heat].[EventID] = 1672'
      '  '
      'ORDER BY'
      '  Heat.HeatNum;'
      '    ')
    Left = 296
    Top = 216
    object qryHeatHeatID: TFDAutoIncField
      FieldName = 'HeatID'
      Origin = 'HeatID'
      ProviderFlags = [pfInWhere, pfInKey]
      Visible = False
    end
    object qryHeatHeatNum: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Heat#'
      DisplayWidth = 6
      FieldName = 'HeatNum'
      Origin = 'HeatNum'
      ReadOnly = True
    end
    object qryHeatHeatStatusID: TIntegerField
      FieldName = 'HeatStatusID'
      Origin = 'HeatStatusID'
      Visible = False
    end
    object qryHeatHeatTypeID: TIntegerField
      FieldName = 'HeatTypeID'
      Origin = 'HeatTypeID'
      Visible = False
    end
    object qryHeatStrokeID: TIntegerField
      FieldName = 'StrokeID'
      Origin = 'StrokeID'
      ProviderFlags = []
    end
    object qryHeatEventID: TIntegerField
      FieldName = 'EventID'
      Origin = 'EventID'
      Visible = False
    end
    object qryHeatCaption: TWideStringField
      FieldName = 'Caption'
      Origin = 'Caption'
      Size = 128
    end
    object qryHeatStartTime: TTimeField
      FieldName = 'StartTime'
      Origin = 'StartTime'
    end
  end
  object qrySwimClub: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    OnNewRecord = qrySwimClubNewRecord
    Filter = 'IsArchived <> 1'
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'indxHideArchived'
        Fields = 'SwimClubID'
        Filter = 'IsArchived <> 1'
      end
      item
        Active = True
        Name = 'indxShowAll'
        Fields = 'SwimClubID'
      end>
    IndexName = 'indxHideArchived'
    UpdateOptions.UpdateTableName = 'SwimClubMeet2..SwimClub'
    UpdateOptions.KeyFields = 'SwimClubID'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'SELECT [SwimClubID]'
      '      ,[NickName]'
      '      ,[Caption]'
      '      ,[Email]'
      '      ,[ContactNum]'
      '      ,[WebSite]'
      '      ,[HeatAlgorithm]'
      '      ,[EnableSimpleDQ]'
      '      ,[NumOfLanes]'
      '      ,[DefTeamSize]'
      '      ,[LenOfPool]'
      '      ,[StartOfSwimSeason]'
      '      ,[CreatedOn]'
      '      ,[LogoImg]'
      '      ,[PoolTypeID]'
      '      ,[SwimClubTypeID]'
      '      ,[IsArchived]'
      '      ,[IsClubGroup]'
      '      ,Cast([IsArchived] as integer) AS imgIndxArchived'
      '      ,Cast([IsClubGroup] as integer) AS imgIndGroup'
      '  FROM [SwimClubMeet2].[dbo].[SwimClub]'
      '  ORDER BY [SwimClubID];'
      ''
      ''
      ''
      '')
    Left = 48
    Top = 40
  end
  object qryLane: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    BeforePost = qryLaneBeforePost
    AfterScroll = qryLaneAfterScroll
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'indxHeat_DESC'
        Fields = 'HeatID'
        DescFields = 'HeatID'
      end>
    IndexName = 'indxHeat_DESC'
    MasterSource = dsHeat
    MasterFields = 'HeatID'
    DetailFields = 'HeatID'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvDefaultParamDataType, fvFmtDisplayTime]
    FormatOptions.FmtDisplayTime = 'nn:ss.zzz'
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Lane'
    UpdateOptions.KeyFields = 'LaneID'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'SELECT L.[LaneID]'
      '      ,L.[LaneNum]'
      '      ,L.[RaceTime]'
      '      ,L.[ClubRecord]'
      '      ,L.[IsDisqualified]'
      '      ,L.[IsScratched]'
      '      ,L.[HeatID]'
      '      ,L.[DisqualifyCodeID]'
      '      ,L.[TeamID]'
      '      ,L.[NomineeID]'
      ''
      '     , CASE'
      '           WHEN l.[NomineeID] IS NOT NULL THEN'
      '               LEFT(CONCAT('
      '                        Member.FirstName'
      '                       , '#39' '#39
      '                       , UPPER(Member.LastName)'
      '                     ),48)'
      '           WHEN L.[TeamID] IS NOT NULL THEN'
      '           Team.TeamName'
      ''
      '       END AS FullName'
      '       ,'
      '        '
      '       CASE'
      
        '           WHEN E.EventTypeID = 1 AND L.[NomineeID] IS NOT NULL ' +
        'THEN'
      '               LEFT(CONCAT('
      '                         FORMAT(Nominee.AGE, '#39'00'#39')'
      '                       , '#39'.'#39
      
        '                       , dbo.SwimmerGenderToString(Nominee.Membe' +
        'rID)'
      '                     ), 12)'
      
        '           WHEN E.EventTypeID = 2 AND L.[TeamID] IS NOT NULL THE' +
        'N'
      '             Team.ABREV'
      '            ELSE NULL'
      '       END AS Stat'
      '       '
      '     , CASE'
      
        '           WHEN E.EventTypeID = 1 AND L.[NomineeID] IS NOT NULL ' +
        'THEN'
      '               [Nominee].TTB'
      
        '           WHEN E.EventTypeID = 2 AND L.[TeamID] IS NOT NULL THE' +
        'N'
      '               [Team].TTB'
      '           ELSE NULL '
      '           '
      '       END AS TTB       '
      '     , CASE'
      
        '           WHEN E.EventTypeID = 1 AND L.[NomineeID] IS NOT NULL ' +
        'THEN'
      '               [Nominee].PB'
      
        '           WHEN E.EventTypeID = 2 AND L.[TeamID] IS NOT NULL THE' +
        'N'
      '               [Team].PB'
      '            ELSE NULL'
      '       END AS PB       '
      '     '
      '       '
      '  FROM [SwimClubMeet2].[dbo].[Lane] AS L'
      '  LEFT JOIN Nominee ON l.NomineeID = Nominee.NomineeID'
      '  LEFT JOIN [Member] ON Nominee.MemberID = [Member].Memberid'
      '  LEFT JOIN [Team] ON l.Teamid = Team.teamid'
      '  LEFT JOIN [Heat] ON l.HeatID = [Heat].HeatID'
      '  LEFT JOIN [Event] AS E ON [Heat].EventID = E.EventID')
    Left = 416
    Top = 248
    object qryLaneLaneID: TFDAutoIncField
      FieldName = 'LaneID'
      Origin = 'LaneID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object qryLaneLaneNum: TIntegerField
      FieldName = 'LaneNum'
      Origin = 'LaneNum'
    end
    object qryLaneRaceTime: TTimeField
      DisplayWidth = 10
      FieldName = 'RaceTime'
      Origin = 'RaceTime'
      OnGetText = qryLaneRaceTimeGetText
      OnSetText = qryLaneRaceTimeSetText
      DisplayFormat = 'nn:ss.zzz'
      EditMask = '!00:00.000;1;0'
    end
    object qryLaneTTB: TTimeField
      DisplayWidth = 10
      FieldName = 'TTB'
      Origin = 'TTB'
      ReadOnly = True
      OnGetText = qryLaneTTBGetText
      DisplayFormat = 'nn:ss.zzz'
      EditMask = '!00:00.000;1;0'
    end
    object qryLanePB: TTimeField
      DisplayWidth = 10
      FieldName = 'PB'
      Origin = 'PB'
      ReadOnly = True
      OnGetText = qryLanePBGetText
      DisplayFormat = 'nn:ss.zzz'
      EditMask = '!00:00.000;1;0'
    end
    object qryLaneIsDisqualified: TBooleanField
      FieldName = 'IsDisqualified'
      Origin = 'IsDisqualified'
    end
    object qryLaneIsScratched: TBooleanField
      FieldName = 'IsScratched'
      Origin = 'IsScratched'
    end
    object qryLaneDisqualifyCodeID: TIntegerField
      FieldName = 'DisqualifyCodeID'
      Origin = 'DisqualifyCodeID'
    end
    object qryLaneClubRecord: TTimeField
      DisplayWidth = 10
      FieldName = 'ClubRecord'
      Origin = 'ClubRecord'
      DisplayFormat = 'nn:ss.zzz'
      EditMask = '!00:00.000;1;0'
    end
    object qryLaneHeatID: TIntegerField
      FieldName = 'HeatID'
      Origin = 'HeatID'
    end
    object qryLaneTeamID: TIntegerField
      FieldName = 'TeamID'
      Origin = 'TeamID'
    end
    object qryLaneNomineeID: TIntegerField
      FieldName = 'NomineeID'
      Origin = 'NomineeID'
    end
    object qryLaneFullName: TWideStringField
      FieldName = 'FullName'
      Origin = 'FullName'
      Size = 257
    end
    object qryLaneStat: TWideStringField
      FieldName = 'Stat'
      Origin = 'Stat'
      ReadOnly = True
      Size = 4000
    end
    object qryLaneluDQ: TStringField
      FieldKind = fkLookup
      FieldName = 'luDQ'
      LookupDataSet = tblDisqualifyCode
      LookupKeyFields = 'DisqualifyCodeID'
      LookupResultField = 'ABREV'
      KeyFields = 'DisqualifyCodeID'
      Lookup = True
    end
  end
  object dsLane: TDataSource
    DataSet = qryLane
    Left = 480
    Top = 248
  end
  object qryNominee: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    OnNewRecord = qryNomineeNewRecord
    Indexes = <
      item
        Active = True
        Name = 'indxEvent_DESC'
        Fields = 'EventID'
        DescFields = 'EventID'
      end>
    IndexFieldNames = 'NomineeID'
    FormatOptions.AssignedValues = [fvFmtDisplayTime]
    FormatOptions.FmtDisplayTime = 'nn.ss.zzz'
    UpdateOptions.UpdateTableName = 'SwimClubMeet2..Nominee'
    UpdateOptions.KeyFields = 'NomineeID'
    SQL.Strings = (
      'USE [SwimClubMeet2];'
      ''
      'SELECT [NomineeID]'
      '      ,[AGE]'
      '      ,[TTB]'
      '      ,[PB]'
      '      ,[IsEntrant]'
      '      ,[SeedTime]'
      '      ,[AutoBuildFlag]'
      '      ,[Nominee].[EventID]'
      '      ,[Nominee].[MemberID]'
      '      ,SUBSTRING(CONCAT ('
      #9'[FirstName]'
      #9','#39', '#39
      #9',UPPER([LastName])'
      #9'), 0, 48) AS FullName '
      '  FROM [SwimClubMeet2].[dbo].[Nominee]'
      
        '  LEFT JOIN [Member] ON [Nominee].[MemberID] = [Member].[MemberI' +
        'D]'
      '')
    Left = 848
    Top = 216
  end
  object dsNominee: TDataSource
    DataSet = qryNominee
    Left = 960
    Top = 216
  end
  object qryTeam: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'mcLane_DESC'
        Fields = 'LaneID'
        DescFields = 'LaneID'
      end>
    IndexName = 'mcLane_DESC'
    MasterSource = dsLane
    MasterFields = 'LaneID'
    DetailFields = 'LaneID'
    FormatOptions.AssignedValues = [fvFmtDisplayDateTime, fvFmtDisplayTime]
    FormatOptions.FmtDisplayTime = 'nn:ss.zzz'
    UpdateOptions.AssignedValues = [uvEInsert, uvCheckRequired]
    UpdateOptions.EnableInsert = False
    UpdateOptions.CheckRequired = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Team'
    UpdateOptions.KeyFields = 'TeamID'
    SQL.Strings = (
      '-- Format of TTime occurs in OnGetText() '#39'nn:ss.zzz'#39
      ''
      'USE SwimClubMeet2'
      ''
      'SELECT Team.TeamID'
      '     , Team.Caption'
      '     , Team.TeamName'
      '     , Team.ABREV'
      '     , Team.TTB'
      '     , Team.PB'
      '     , Team.SeedTime'
      'FROM Team'
      ''
      ''
      '')
    Left = 528
    Top = 392
  end
  object dsTeam: TDataSource
    DataSet = qryTeam
    Left = 616
    Top = 392
  end
  object dsSplitTime: TDataSource
    Left = 616
    Top = 336
  end
  object dsWatchTime: TDataSource
    Left = 616
    Top = 280
  end
  object qrySplitTime: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'mcLane_DESC'
        Fields = 'LaneID'
        DescFields = 'LaneID'
      end>
    IndexName = 'mcLane_DESC'
    MasterSource = dsLane
    MasterFields = 'LaneID'
    DetailFields = 'LaneID'
    FormatOptions.AssignedValues = [fvFmtDisplayTime]
    FormatOptions.FmtDisplayTime = 'nn:ss:.zzz'
    SQL.Strings = (
      'SELECT [SplitTimeID]'
      '      ,[WatchNum]'
      '      ,[Caption]'
      '      ,[Time]'
      '      ,[LaneID]'
      '  FROM [dbo].[SplitTime]'
      ''
      'GO'
      ''
      '')
    Left = 528
    Top = 336
  end
  object qryWatchTime: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'indxLane_DESC'
        Fields = 'LaneID'
        DescFields = 'LaneID'
      end>
    IndexName = 'indxLane_DESC'
    MasterSource = dsLane
    MasterFields = 'LaneID'
    DetailFields = 'LaneID'
    FormatOptions.AssignedValues = [fvFmtDisplayTime]
    FormatOptions.FmtDisplayTime = 'nn:ss:.zzz'
    SQL.Strings = (
      ''
      ''
      'SELECT [WatchTimeID]'
      '      ,[WatchNum]'
      '      ,[Caption]'
      '      ,[Time]'
      '      ,[LaneID]'
      '  FROM [dbo].[WatchTime]'
      ''
      'GO'
      ''
      '')
    Left = 528
    Top = 280
  end
  object qryTeamLink: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'mcTeam_DESC'
        Fields = 'TeamID'
        DescFields = 'TeamID'
      end>
    IndexName = 'mcTeam_DESC'
    SQL.Strings = (
      'DECLARE @TeamID AS INTEGER;'
      'SET @TeamID = :TEAMID;'
      ''
      ''
      'SELECT'
      'TeamID, '
      'NomineeID, '
      'SwimOrder'
      ''
      'FROM TeamLink'
      'WHERE TeamID = @TeamID;')
    Left = 616
    Top = 544
    ParamData = <
      item
        Name = 'TEAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object tblStroke: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'StrokeID'
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.UpdateTableName = 'SwimClubMeet2..Stroke'
    UpdateOptions.KeyFields = 'StrokeID'
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2..Stroke'
    Left = 72
    Top = 264
  end
  object tblDistance: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'DistanceID'
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.UpdateTableName = 'SwimClubMeet2..Distance'
    UpdateOptions.KeyFields = 'DistanceID'
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2..Distance'
    Left = 72
    Top = 312
  end
  object luStroke: TDataSource
    DataSet = tblStroke
    Left = 176
    Top = 264
  end
  object luDistance: TDataSource
    DataSet = tblDistance
    Left = 176
    Top = 312
  end
  object dsTeamLink: TDataSource
    DataSet = qryTeamLink
    Left = 704
    Top = 544
  end
  object qryMember: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'indxMember'
        Fields = 'MemberID'
      end>
    IndexName = 'indxMember'
    MasterSource = dsMemberLink
    MasterFields = 'MemberID'
    DetailFields = 'MemberID'
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Member'
    UpdateOptions.KeyFields = 'MemberID'
    SQL.Strings = (
      'DECLARE @Toggle AS BIT;'
      'DECLARE @SessionStart  AS DATETIME;'
      ''
      'SET @SessionStart = :SESSIONSTART;'
      'SET @Toggle = :TOGGLE;'
      ''
      'if @SessionStart IS NULL SET @SessionStart = GetDate();'
      'IF @Toggle IS NULL SET @Toggle = 1;'
      'IF @Toggle NOT IN (0, 1) SET @Toggle = 1;'
      ''
      'SELECT'
      'CASE '
      '    WHEN @Toggle = 0 THEN'
      #9'   CONCAT ('
      #9#9#9'   SUBSTRING(CONCAT ('
      #9#9#9#9#9'   UPPER([LastName])'
      #9#9#9#9#9'   ,'#39', '#39
      #9#9#9#9#9'   ,[FirstName]'
      #9#9#9#9#9'   ), 0, 30)'
      #9#9#9'   ,'#39' ('#39
      #9#9#9'   ,dbo.SwimmerAge(@SessionStart, DOB)'
      #9#9#9'   ,'#39')'#39
      #9#9#9'   )'
      '    WHEN @Toggle = 1 THEN'
      #9'   CONCAT ('
      #9#9#9'   SUBSTRING(CONCAT ('
      #9#9#9#9#9'   [FirstName]'
      #9#9#9#9#9'   ,'#39', '#39
      #9#9#9#9#9'   ,UPPER([LastName])'
      #9#9#9#9#9'   ), 0, 30)'
      #9#9#9'   ,'#39' ('#39
      #9#9#9'   ,dbo.SwimmerAge(@SessionStart, DOB)'
      #9#9#9'   ,'#39')'#39
      #9#9#9'   )  '
      'END  AS FName'
      ''
      ',Member.MemberID'
      ',Member.GenderID'
      '        '
      ',SUBSTRING(CONCAT ('
      #9#9#9#9#9'   [FirstName]'
      #9#9#9#9#9'   ,'#39', '#39
      #9#9#9#9#9'   ,UPPER([LastName])'
      #9#9#9#9#9'   ), 0, 48) AS FullName'
      ''
      'FROM Member'
      
        'WHERE (Member.IsArchived <> 1) AND (Member.IsActive = 1) AND (Me' +
        'mber.IsSwimmer = 1)'
      'Order by FName;'
      ''
      ''
      ''
      '/*'
      'SELECT [MemberID]'
      '      ,[MembershipNum]'
      '      ,[MembershipStr]'
      '      ,[FirstName]'
      '      ,[MiddleInitial]'
      '      ,[LastName]'
      '      ,[RegisterNum]'
      '      ,[RegisterStr]'
      '      ,[DOB]'
      '      ,[IsArchived]'
      '      ,[IsActive]'
      '      ,[IsSwimmer]'
      '      ,[Email]'
      '      ,[CreatedOn]'
      '      ,[ArchivedOn]'
      '      ,[EnableEmailOut]'
      '      ,[EnableEmailNomineeForm]'
      '      ,[EnableEmailSessionReport]'
      '      ,[TAGS]'
      '      ,[GenderID]'
      '  FROM [SwimClubMeet2].[dbo].[Member]'
      '  ORDER BY [LastName]'
      '*/ ')
    Left = 384
    Top = 136
    ParamData = <
      item
        Name = 'SESSIONSTART'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'TOGGLE'
        DataType = ftBytes
        ParamType = ptInput
        Value = Null
      end>
  end
  object dsMemberLink: TDataSource
    DataSet = qryMemberLink
    Left = 448
    Top = 72
  end
  object dsMember: TDataSource
    DataSet = qryMember
    Left = 480
    Top = 136
  end
  object qryMemberLink: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    MasterSource = dsSwimClub
    MasterFields = 'SwimClubID'
    DetailFields = 'SwimClubID'
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.MemberLink'
    UpdateOptions.KeyFields = 'SwimClubID;MemberID'
    SQL.Strings = (
      'SELECT [MemberID]'
      '      ,[SwimClubID]'
      '      ,[HouseID]'
      '  FROM [SwimClubMeet2].[dbo].[MemberLink]')
    Left = 352
    Top = 72
  end
  object tblEventType: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'EventTypeID'
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2.dbo.EventType'
    Left = 72
    Top = 360
  end
  object luEventType: TDataSource
    DataSet = tblEventType
    Left = 176
    Top = 360
  end
  object tblGender: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'GenderID'
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2.dbo.Gender'
    Left = 72
    Top = 472
  end
  object tblRound: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'RoundID'
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2.dbo.Round'
    Left = 72
    Top = 528
  end
  object tblEventCat: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'EventCategoryID'
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2.dbo.EventCategory'
    Left = 72
    Top = 416
  end
  object tblParalympicType: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'ParalympicTypeID'
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2.dbo.ParalympicType'
    Left = 72
    Top = 584
  end
  object luEventCat: TDataSource
    DataSet = tblEventCat
    Left = 176
    Top = 416
  end
  object luGender: TDataSource
    DataSet = tblGender
    Left = 176
    Top = 472
  end
  object luRound: TDataSource
    DataSet = tblRound
    Left = 176
    Top = 528
  end
  object luParalympicType: TDataSource
    DataSet = tblParalympicType
    Left = 176
    Top = 584
  end
  object qryFilterMember: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    AfterScroll = qryFilterMemberAfterScroll
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'MemberID'
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      '-- create temporary table to hold results'
      'IF OBJECT_ID('#39'tempdb..#SwimClubMembers'#39') IS NOT NULL'
      '    DROP TABLE #SwimClubMembers;    '
      ''
      'DECLARE @SwimClubID INT = :SWIMCLUBID;'
      'DECLARE @SortOn INT = :SORTON;'
      'DECLARE @SeedDate DATETIME = :SEEDDATE;'
      ''
      'if @SortOn IS NULL SET @SortOn = 0; '
      'if @SeedDate IS NULL SET @SeedDate = GETDATE(); '
      ''
      'CREATE TABLE #SwimClubMembers'
      '('
      '    SwimClubID INT,'
      '    MemberID   INT'
      ');  '
      ''
      
        '-- insert members from the parent club (distinct, skip if Member' +
        'ID already in temp)'
      'INSERT INTO #SwimClubMembers (SwimClubID, MemberID)'
      'SELECT DISTINCT sc.SwimClubID, mm.MemberID'
      'FROM SWimClubMeet2.dbo.SwimClub AS sc'
      'INNER JOIN dbo.MemberLink AS ml ON sc.SwimClubID = ml.SwimClubID'
      'INNER JOIN dbo.Member AS mm ON ml.MemberID = mm.MemberID'
      'WHERE sc.SwimClubID = @SwimClubID'
      
        '  AND NOT EXISTS (SELECT 1 FROM #SwimClubMembers m WHERE m.Membe' +
        'rID = mm.MemberID);'
      ''
      
        '-- insert members from child clubs (distinct, skip if MemberID a' +
        'lready in temp)'
      'INSERT INTO #SwimClubMembers (SwimClubID, MemberID)'
      'SELECT DISTINCT sg.ChildClubID, mm.MemberID'
      'FROM SwimClubMeet2.dbo.SwimClubGroup AS sg'
      
        'INNER JOIN dbo.MemberLink AS ml ON sg.ChildClubID = ml.SwimClubI' +
        'D'
      'INNER JOIN dbo.Member AS mm ON ml.MemberID = mm.MemberID'
      'WHERE sg.ParentClubID = @SwimClubID'
      
        '  AND NOT EXISTS (SELECT 1 FROM #SwimClubMembers m WHERE m.Membe' +
        'rID = mm.MemberID);'
      ''
      '-- final result from the temp table (no duplicate MemberID rows)'
      'SELECT'
      '    mlist.SwimClubID,'
      '    mlist.MemberID,'
      '    mm.FirstName,'
      '    mm.MiddleName,'
      '    mm.LastName,'
      '    scc.NickName,'
      '    dbo.SwimmerAge(@SeedDate, mm.DOB) AS Age,'
      #9'gender.ABREV,'
      #9'CASE WHEN @SortOn = 0 then'
      #9#9'CASE '
      #9#9'WHEN (mm.MiddleName IS NULL) THEN'
      #9#9#9'CONCAT(mm.FirstName, '#39' '#39', UPPER(mm.LastName))'
      #9#9'ELSE'
      
        #9#9#9'CONCAT(mm.FirstName, '#39' '#39', LEFT(mm.MiddleName,1), '#39'. '#39', UPPER(' +
        'mm.LastName))'
      #9#9'END '
      #9'ELSE'#9
      #9#9'CASE '
      #9#9'WHEN (mm.MiddleName IS NULL) THEN'
      #9#9#9'CONCAT(UPPER(mm.LastName), '#39', '#39', mm.FirstName)'
      #9#9'ELSE'
      
        #9#9#9'CONCAT(UPPER(mm.LastName), '#39', '#39', mm.FirstName, '#39' .'#39', LEFT(mm.' +
        'MiddleName, 1) )'
      #9#9'END '#9
      #9'END'#9'as FName '
      'FROM #SwimClubMembers AS mlist'
      'INNER JOIN dbo.Member AS mm ON mlist.MemberID = mm.MemberID'
      
        'INNER JOIN dbo.SwimClub AS scc ON mlist.SwimClubID = scc.SwimClu' +
        'bID'
      'INNER JOIN dbo.Gender ON mm.GenderID = Gender.GenderID'
      'ORDER BY '
      #9'CASE WHEN (@SortOn = 1) THEN mm.LastName ELSE mm.FirstName END '
      ';'
      ''
      'DROP TABLE #SwimClubMembers;'
      ''
      ''
      ''
      '/*'
      ''
      ''
      'DECLARE @SwimClubID AS INT = 1 ;'
      'DECLARE @SortON AS INT = 0;'
      'DECLARE @SeedDate AS DATETIME = GETDATE();'
      ''
      ''
      ''
      '-- DECLARE @SwimClubID INT = :SWIMCLUBID;'
      '-- DECLARE @SortOn INT = :SORTON;'
      '-- DECLARE @SeedDate DATETIME = :SEEDDATE;'
      ''
      'IF @SortOn IS NULL SET @SortOn = 0; '
      'IF @SeedDate IS NULL SET @SeedDate = GETDATE();'
      ''
      'WITH'
      'Clubs AS ( '
      #9'-- parent club + direct child clubs '
      #9'SELECT @SwimClubID AS SwimClubID  '
      ''
      #9'UNION ALL '
      ''
      #9'SELECT sg.ChildClubID '
      #9'FROM dbo.SwimClubGroup AS sg '
      #9'WHERE sg.ParentClubID = @SwimClubID ),'
      ''
      'ClubMembers AS ( '
      #9'-- distinct MemberIDs for any of the clubs above '
      #9'SELECT DISTINCT '
      #9#9'c.SwimClubID, '
      #9#9'ml.MemberID '
      #9'FROM Clubs c '
      
        #9'INNER JOIN dbo.MemberLink AS ml ON ml.SwimClubID = c.SwimClubID' +
        ' ) '
      ''
      ''
      'SELECT cm.SwimClubID, '
      'cm.MemberID, '
      'mm.FirstName, '
      'mm.MiddleName, '
      'mm.LastName, '
      'scc.NickName, '
      'dbo.SwimmerAge(@SeedDate, mm.DOB) AS Age, '
      'g.ABREV AS GenderAbbrev, '
      'CASE WHEN @SortOn = 0 THEN '
      #9'CASE WHEN mm.MiddleName IS NULL OR mm.MiddleName = '#39#39' THEN '
      #9#9'CONCAT(mm.FirstName, '#39' '#39', UPPER(mm.LastName)) ELSE '
      
        #9#9'CONCAT(mm.FirstName, '#39' '#39', LEFT(mm.MiddleName,1), '#39'. '#39', UPPER(m' +
        'm.LastName)) '
      #9#9'END '
      #9'ELSE '
      #9'CASE WHEN mm.MiddleName IS NULL OR mm.MiddleName = '#39#39' THEN '
      #9#9'CONCAT(UPPER(mm.LastName), '#39', '#39', mm.FirstName) ELSE '
      
        #9#9'CONCAT(UPPER(mm.LastName), '#39', '#39', mm.FirstName, '#39' '#39', LEFT(mm.Mi' +
        'ddleName,1), '#39'.'#39') '
      #9#9'END '
      #9'END AS FName'
      #9#9
      'FROM ClubMembers AS cm '
      'INNER JOIN dbo.Member AS mm ON cm.MemberID = mm.MemberID '
      
        'INNER JOIN dbo.SwimClub AS scc ON cm.SwimClubID = scc.SwimClubID' +
        ' '
      'INNER JOIN dbo.Gender AS g ON mm.GenderID = g.GenderID '
      'ORDER BY '
      #9'CASE WHEN (@SortOn = 1) THEN '
      #9'mm.LastName '
      #9'ELSE '
      #9'mm.FirstName '
      #9'END '
      ''
      ''
      ''
      '*/')
    Left = 848
    Top = 72
    ParamData = <
      item
        Name = 'SWIMCLUBID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end
      item
        Name = 'SORTON'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'SEEDDATE'
        DataType = ftDate
        ParamType = ptInput
        Value = Null
      end>
    object qryFilterMemberSwimClubID: TIntegerField
      FieldName = 'SwimClubID'
      Origin = 'SwimClubID'
    end
    object qryFilterMemberMemberID: TIntegerField
      FieldName = 'MemberID'
      Origin = 'MemberID'
    end
    object qryFilterMemberFirstName: TWideStringField
      FieldName = 'FirstName'
      Origin = 'FirstName'
      Size = 128
    end
    object qryFilterMemberMiddleName: TWideStringField
      FieldName = 'MiddleName'
      Origin = 'MiddleName'
      Size = 128
    end
    object qryFilterMemberLastName: TWideStringField
      FieldName = 'LastName'
      Origin = 'LastName'
      Size = 128
    end
    object qryFilterMemberNickName: TWideStringField
      FieldName = 'NickName'
      Origin = 'NickName'
      Size = 128
    end
    object qryFilterMemberAge: TIntegerField
      FieldName = 'Age'
      Origin = 'Age'
      ReadOnly = True
    end
    object qryFilterMemberABREV: TWideStringField
      FieldName = 'ABREV'
      Origin = 'ABREV'
      Size = 16
    end
    object qryFilterMemberFName: TWideStringField
      FieldName = 'FName'
      Origin = 'FName'
      ReadOnly = True
      Required = True
      Size = 263
    end
  end
  object dsFilterMember: TDataSource
    DataSet = qryFilterMember
    Left = 944
    Top = 72
  end
  object qryNominate: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      
        'SET NOCOUNT ON;  -- Prevents extra result sets from interfering ' +
        'with SELECT statements'
      ''
      'DECLARE @MemberID integer = :MEMBERID; --108;'
      'DECLARE @SessionID integer = :SESSIONID; --144;'
      'DECLARE @SeedDate DateTime = :SEEDDATE;'
      'DECLARE @IsShortCourse BIT = :ISSHORTCOURSE;'
      ''
      'IF @SeedDate IS NULL SET @SeedDate = GETDATE();'
      'IF @IsShortCourse IS NULL SET @IsShortCourse = 0;'
      ''
      '--  check if temporary table exists and drop it'
      'IF OBJECT_ID('#39'tempdb..#ev'#39') IS NOT NULL'
      '    DROP TABLE #ev;'
      ''
      'CREATE TABLE #ev ('
      '    EventID integer,    '
      '    Caption nvarchar(100),'
      '    EventNum integer,'
      '    EventTypeID integer,'
      '    SubText nvarchar(40),'
      '    SessionID integer,'
      '    Nominated integer,'
      '    Qualified integer,'
      '    StrokeID integer,'
      '    DistanceID integer,'
      '    Meters integer'
      ');  '
      ''
      'INSERT INTO #ev '
      
        '   (EventID, Caption, EventNum, EventTypeID, SubText, SessionID,' +
        ' Nominated, Qualified, StrokeID, DistanceID, Meters)'
      'SELECT ee.EventID,  '
      '    ee.Caption,'
      '    ee.EventNum,'
      '    ee.EventTypeID,'
      '    CONCAT(d.Caption, '#39' '#39', s.Caption) as SubText,'
      '    ee.SessionID,'
      '    CASE WHEN n.MemberID = @MemberID then 1 else 0 end,'
      
        '  dbo.IsMemberQualified(@MemberID, @SeedDate, ee.DistanceID, ee.' +
        'StrokeID, @IsShortCourse),'
      '   s.StrokeID,'
      '   d.DistanceID,'
      '   d.Meters'
      ''
      'FROM [dbo].[EVENT] ee '
      'INNER JOIN [dbo].[Distance] d ON ee.DistanceID = d.DistanceID'
      'INNER JOIN [dbo].[Stroke] s on ee.StrokeID = s.StrokeID'
      
        'LEFT JOIN [dbo].[Nominee] n ON ee.EventID = n.EventID and n.Memb' +
        'erID = @Memberid'
      'WHERE ee.SessionID = @SessionID;'
      ''
      'SELECT * FROM #ev'
      'ORDER BY EventNum ASC;'
      ''
      'DROP TABLE #ev;'
      ''
      ''
      ''
      '')
    Left = 848
    Top = 24
    ParamData = <
      item
        Name = 'MEMBERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 108
      end
      item
        Name = 'SESSIONID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 144
      end
      item
        Name = 'SEEDDATE'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ISSHORTCOURSE'
        DataType = ftByte
        ParamType = ptInput
        Value = 0
      end>
    object qryNominateEventID: TIntegerField
      FieldName = 'EventID'
      Origin = 'EventID'
    end
    object qryNominateCaption: TWideStringField
      FieldName = 'Caption'
      Origin = 'Caption'
      Size = 100
    end
    object qryNominateEventNum: TIntegerField
      FieldName = 'EventNum'
      Origin = 'EventNum'
    end
    object qryNominateEventTypeID: TIntegerField
      FieldName = 'EventTypeID'
      Origin = 'EventTypeID'
    end
    object qryNominateSubText: TWideStringField
      FieldName = 'SubText'
      Origin = 'SubText'
      ProviderFlags = []
      Size = 200
    end
    object qryNominateSessionID: TIntegerField
      FieldName = 'SessionID'
      Origin = 'SessionID'
    end
    object qryNominateNominated: TIntegerField
      FieldName = 'Nominated'
      Origin = 'Nominated'
    end
    object qryNominateQualified: TIntegerField
      FieldName = 'Qualified'
      Origin = 'Qualified'
    end
    object qryNominateStrokeID: TIntegerField
      FieldName = 'StrokeID'
      Origin = 'StrokeID'
    end
    object qryNominateDistanceID: TIntegerField
      FieldName = 'DistanceID'
      Origin = 'DistanceID'
    end
    object qryNominateMeters: TIntegerField
      FieldName = 'Meters'
      Origin = 'Meters'
    end
  end
  object dsNominate: TDataSource
    DataSet = qryNominate
    Left = 944
    Top = 24
  end
  object qryMemberMetrics: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'DECLARE @MemberID INTEGER = :MEMBERID;  -- :MEMBERID'
      'DECLARE @SeedDate DATETIME = :SeedDate;'
      'DECLARE @EventID INTEGER = :EVENTID;'
      'DECLARE @Algorithm INTEGER = :ALGORITHM; -- 1; -- '
      'DECLARE @CalcDefRT INTEGER = :CALCDEFRT;  --1; -- '
      'DECLARE @Percent FLOAT = :PERCENT; ---50.0;'
      ''
      'DECLARE @DistanceID INTEGER;'
      'DECLARE @StrokeID INTEGER;'
      ''
      
        'SET @DistanceID = (SELECT DistanceID FROM dbo.Event WHERE [Event' +
        '].EventID = @EventID);'
      
        'SET @StrokeID = (SELECT StrokeID FROM dbo.Event WHERE [Event].Ev' +
        'entID = @EventID);'
      ''
      'if @SeedDate IS NULL SET @SeedDate = GETDATE();'
      ''
      'SELECT m.MemberID,'
      '  dbo.SwimmerAge(@SeedDate, m.DOB) AS DOB,'
      
        '  dbo.TimeToBeat(@Algorithm, @CalcDefRT, @Percent, m.MemberID, @' +
        'DistanceID, @StrokeID, @SeedDate) AS TTB,'
      
        '  dbo.PersonalBest(m.MemberID, @DistanceID, @StrokeID, @SeedDate' +
        ') AS PB,'
      '  dbo.SwimmerAge(@SeedDate,m.DOB) AS Age, '
      '  PBT.[RaceTime] AS SeedTime'
      'FROM [SwimClubMeet2].[dbo].[Member] m'
      
        'LEFT JOIN [dbo].[PB] AS PBT ON m.MemberID = PBT.MemberID AND PBT' +
        '.DistanceID = @DistanceID AND PBT.StrokeID = @StrokeID'
      'WHERE m.MemberID = @MemberID;')
    Left = 848
    Top = 152
    ParamData = <
      item
        Name = 'MEMBERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'SEEDDATE'
        DataType = ftDateTime
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'EVENTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ALGORITHM'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end
      item
        Name = 'CALCDEFRT'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end
      item
        Name = 'PERCENT'
        DataType = ftFloat
        ParamType = ptInput
        Value = 50.000000000000000000
      end>
  end
  object tblDisqualifyCode: TFDTable
    Active = True
    IndexFieldNames = 'DisqualifyCodeID'
    DetailFields = 'DisqualifyCodeID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.DisqualifyCode'
    UpdateOptions.KeyFields = 'DisqualifyCodeID'
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'DisqualifyCode'
    Left = 72
    Top = 640
  end
  object luDisqualifyCode: TDataSource
    DataSet = tblDisqualifyCode
    Left = 176
    Top = 640
  end
end
