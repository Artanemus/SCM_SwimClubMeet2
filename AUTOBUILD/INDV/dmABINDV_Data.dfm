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
    Top = 192
  end
  object procDeleteHeats: TFDStoredProc
    Connection = SCM2.scmConnection
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    StoredProcName = 'DeleteAllHeats'
    Left = 64
    Top = 80
    ParamData = <
      item
        Position = 1
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        ParamType = ptResult
      end
      item
        Position = 2
        Name = '@EventID'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Position = 3
        Name = '@Exclude'
        DataType = ftBoolean
        ParamType = ptInput
      end>
  end
  object qryUnplacedNominees: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Indexes = <
      item
        Active = True
        Name = 'indxTTB'
        Fields = 'TTB;NomineeID'
        DescFields = 'TTB'
      end
      item
        Active = True
        Name = 'indxTTBGender'
        Fields = 'TTB;GenderID;MemberID'
        DescFields = 'TTB'
      end
      item
        Active = True
        Selected = True
        Name = 'indxPK'
        Fields = 'NomineeID'
      end>
    IndexName = 'indxPK'
    Connection = SCM2.scmConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
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
end
