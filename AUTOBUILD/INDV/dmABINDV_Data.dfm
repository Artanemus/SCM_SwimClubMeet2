object ABINDV_Data: TABINDV_Data
  OnCreate = DataModuleCreate
  Height = 439
  Width = 321
  object qryGender: TFDQuery
    Connection = SCM2.scmConnection
    SQL.Strings = (
      'USE [SwimClubMeet2];'
      ''
      'SELECT [GenderID]'
      '      ,[Caption]'
      '      ,[ABREV]'
      '  FROM [dbo].[Gender];'
      ''
      '')
    Left = 64
    Top = 88
  end
  object qryUnplacedNominees: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Indexes = <
      item
        Active = True
        Name = 'indxTTB'
        Fields = 'TTB;NomineeID'
      end
      item
        Active = True
        Name = 'indxTTBGender'
        Fields = 'TTB;GenderID;NomineeID'
      end
      item
        Active = True
        Selected = True
        Name = 'indxPK'
        Fields = 'NomineeID'
      end>
    IndexName = 'indxPK'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvFmtDisplayTime]
    FormatOptions.FmtDisplayTime = 'nn:ss.zzz'
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Nominee'
    UpdateOptions.KeyFields = 'NomineeID'
    SQL.Strings = (
      'USE SwimClubMeet2'
      ''
      'DECLARE @EventID AS INT'
      ''
      'SET @EventID = :EVENTID;'
      ''
      '-- LIST OF NOMINEES PLACED IN CLOSED OR RACED HEATS'
      
        '----------------------------------------------------------------' +
        '----'
      '-- Drop a temporary table '
      'IF OBJECT_ID('#39'tempDB..#MembersInClosedHeats'#39', '#39'U'#39') IS NOT NULL'
      '    DROP TABLE #MembersInClosedHeats;'
      '-- Create the temporary table '
      'SELECT Event.EventID'
      '     , Nominee.MemberID'
      'INTO #MembersInClosedHeats'
      'FROM [SwimClubMeet2].[dbo].[Event]'
      '    INNER JOIN Heat'
      '        ON Event.EventID = Heat.EventID'
      '    INNER JOIN Lane'
      '        ON Heat.HeatID = Lane.HeatID'
      '    INNER JOIN Nominee'
      '        ON Lane.NomineeID = Nominee.NomineeID'
      'WHERE ('
      '          Heat.HeatStatusID = 2'
      '          OR Heat.HeatStatusID = 3'
      '      )'
      '      AND (Lane.NomineeID IS NOT NULL);'
      '     '
      '-- LIST OF UNPLACED NOMINEES (THEY DON'#39'T HAVE A LANE.)'
      
        '----------------------------------------------------------------' +
        '----'
      'SELECT '
      '[Nominee].[NomineeID]'
      ',[Nominee].[AGE]'
      ',[Nominee].[TTB]'
      ',[Nominee].[PB]'
      ',[Nominee].[IsEntrant]'
      ',[Nominee].[PBSeedTime]'
      ',[Nominee].[RecordTime]'
      ',[Nominee].[AutoBuildFlag]'
      ',[Nominee].[EventID]'
      ',[Nominee].[MemberID]'
      ',[Member].GenderID'
      'FROM [SwimClubMeet2].[dbo].[Nominee]'
      
        'LEFT OUTER JOIN #MembersInClosedHeats ON #MembersInClosedHeats.M' +
        'emberID = [Nominee].[MemberID]'
      #9'AND #MembersInClosedHeats.EventID = [Nominee].[EventID]'
      'LEFT JOIN [Member] ON [Nominee].MemberID = [Member].MemberID'
      'WHERE ([Nominee].[EventID] = @EventID)'
      #9'AND (#MembersInClosedHeats.MemberID IS NULL)'
      '')
    Left = 64
    Top = 24
    ParamData = <
      item
        Name = 'EVENTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 2
      end>
  end
  object dsUnplacedNominees: TDataSource
    DataSet = qryUnplacedNominees
    Left = 192
    Top = 24
  end
  object qryDivision: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'indxDiv'
        Fields = 'AgeTo;GenderID;DivisionID'
        DescFields = 'GenderID'
      end
      item
        Active = True
        Name = 'indxDivMale'
        Fields = 'GenderID;AgeFrom;DivisionID'
        Filter = 'GenderID = 1'
      end
      item
        Active = True
        Name = 'indxDivFemale'
        Fields = 'GenderID;AgeFrom;DivisionID'
        Filter = 'GenderID = 2'
      end
      item
        Active = True
        Name = 'indxDivMixed'
        Fields = 'GenderID;AgeFrom;DivisionID'
        Filter = 'GenderID = 3'
      end>
    IndexName = 'indxDiv'
    Connection = SCM2.scmConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Division'
    UpdateOptions.KeyFields = 'DivisionID'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'SELECT [DivisionID]'
      '      ,[Caption]'
      '      ,[AgeFrom]'
      '      ,[AgeTo]'
      '      ,[GenderID]'
      '  FROM [SwimClubMeet2].[dbo].[Division]'
      '  ORDER BY GenderID ASC;')
    Left = 64
    Top = 152
  end
end
