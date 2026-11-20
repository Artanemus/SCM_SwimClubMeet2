object RPTTemplate: TRPTTemplate
  OnCreate = DataModuleCreate
  Height = 577
  Width = 726
  object qryfrxSwimClub: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Active = True
    Connection = SCM2.scmConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.KeyFields = 'SwimClubID'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'DECLARE @SwimClubID AS INTEGER;'
      'SET @SwimClubID = :SWIMCLUBID;'
      ''
      'SELECT [SwimClubID]'
      '      ,[GUID]'
      '      ,[NickName]'
      '      ,[SwimClub].[Caption] AS ClubName'
      '      ,[Email]'
      '      ,[ContactNum]'
      '      ,[WebSite]'
      '      ,[Address]   '
      '--      ,[HeatAlgorithm]'
      '--      ,[EnableSimpleDQ]'
      '      ,[NumOfLanes]'
      '      ,[LenOfPool]'
      '--      ,[DefTeamSize]'
      '      ,[CreatedOn]'
      '      ,[LogoImg]'
      '      ,[SwimClub].[IsArchived]'
      '      ,[IsClubGroup]'
      '--      ,[SwimClub].[SwimClubTypeID]'
      '      ,[SwimClubType].Caption AS SwimClubType '
      '--      ,[SwimClub].[PoolTypeID]'
      '      ,[PoolType].Caption AS PoolType '
      '  FROM [SwimClubMeet2].[dbo].[SwimClub]'
      '  LEFT JOIN [SwimClubType] '
      
        '      ON [SwimClub].[SwimClubTypeID] = [SwimClubType].[SwimClubT' +
        'ypeID]'
      '  LEFT JOIN [PoolType] '
      '      ON [SwimClub].[PoolTypeID] = [PoolType].[PoolTypeID]'
      '  WHERE SwimCLubID = @SwimClubID;')
    Left = 72
    Top = 384
    ParamData = <
      item
        Name = 'SWIMCLUBID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end>
  end
  object dsfrxSwimClub: TfrxDBDataset
    UserName = 'SwimClub'
    CloseDataSource = False
    FieldAliases.Strings = (
      'SwimClubID=SwimClubID'
      'GUID=GUID'
      'NickName=NickName'
      'ClubName=ClubName'
      'Email=Email'
      'ContactNum=ContactNum'
      'WebSite=WebSite'
      'NumOfLanes=NumOfLanes'
      'LenOfPool=LenOfPool'
      'CreatedOn=CreatedOn'
      'LogoImg=LogoImg'
      'IsArchived=IsArchived'
      'IsClubGroup=IsClubGroup'
      'SwimClubType=SwimClubType'
      'PoolType=PoolType')
    DataSet = qryfrxSwimClub
    BCDToCurrency = False
    Left = 160
    Top = 384
  end
  object qryfrxSession: TFDQuery
    Active = True
    Connection = SCM2.scmConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.KeyFields = 'SessionID'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      'DECLARE @SessionID AS INTEGER;'
      'SET @SessionID = :SESSIONID;'
      'SELECT [SessionID]'
      '      ,[Session].[Caption] AS SessionDescrption'
      '      ,[SessionDT]'
      '      ,[Session].[CreatedOn]'
      '      ,[Session].[ModifiedOn]'
      '      ,[NomineeCount]'
      '      ,[EntrantCount]'
      '      ,[SwimClubID]'
      '      --,[Session].[SessionStatusID]'
      '      ,[SessionStatus].Caption AS SessionStatus'
      '      --,[Session].[MeetID]'
      '      ,[Meet].Caption AS MeetDescription'
      '  FROM [SwimClubMeet2].[dbo].[Session]'
      '  LEFT JOIN [SessionStatus] ON '
      
        '    [Session].[SessionStatusID] =[SessionStatus].[SessionStatusI' +
        'D]'
      '  LEFT JOIN [Meet] ON '
      '    [Session].[MeetID] = [Meet].[MeetID]'
      'WHERE [Session].SessionID = @SessionID;')
    Left = 72
    Top = 456
    ParamData = <
      item
        Name = 'SESSIONID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object dsfrxSession: TfrxDBDataset
    UserName = 'Session'
    CloseDataSource = False
    FieldAliases.Strings = (
      'SessionID=SessionID'
      'SessionDescrption=SessionDescrption'
      'SessionDT=SessionDT'
      'CreatedOn=CreatedOn'
      'ModifiedOn=ModifiedOn'
      'NomineeCount=NomineeCount'
      'EntrantCount=EntrantCount'
      'SwimClubID=SwimClubID'
      'SessionStatus=SessionStatus'
      'MeetDescription=MeetDescription')
    DataSet = qryfrxSession
    BCDToCurrency = False
    Left = 160
    Top = 456
  end
end
