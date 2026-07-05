object SCM2: TSCM2
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 383
  Width = 610
  object scmConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=MSSQL_SCM2')
    ConnectedStoredUsage = [auDesignTime]
    Connected = True
    LoginPrompt = False
    Left = 80
    Top = 24
  end
  object qrySCMSystem: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.SCMSystem'
    UpdateOptions.KeyFields = 'SCMSystemID'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'SET ANSI_NULLS ON;'
      'SET QUOTED_IDENTIFIER ON;'
      ''
      'SELECT '
      '  [SCMSystemID]'
      '      ,[DBVersion]'
      '      ,[Major]'
      '      ,[Minor]'
      '      ,[Build]'
      '  FROM [SwimClubMeet2].[dbo].[SCMSystem]')
    Left = 72
    Top = 240
  end
  object FDGUIxErrorDialog: TFDGUIxErrorDialog
    Provider = 'Forms'
    Caption = 'SwimClubMeet FireDAC Error'
    Enabled = False
    Left = 80
    Top = 96
  end
  object procRenumberHeats: TFDStoredProc
    Connection = scmConnection
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Heat'
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    StoredProcName = 'SwimClubMeet2.dbo.RenumberHeats'
    Left = 280
    Top = 85
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
      end>
  end
  object procRenumberEvents: TFDStoredProc
    Connection = scmConnection
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Event'
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    StoredProcName = 'SwimClubMeet2.dbo.RenumberEvents'
    Left = 280
    Top = 29
    ParamData = <
      item
        Position = 1
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        ParamType = ptResult
        Value = 0
      end
      item
        Position = 2
        Name = '@SessionID'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object procRenumberLanes: TFDStoredProc
    Connection = scmConnection
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Lane'
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    StoredProcName = 'SwimClubMeet2.dbo.RenumberLanes'
    Left = 280
    Top = 141
    ParamData = <
      item
        Position = 1
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        ParamType = ptResult
      end
      item
        Position = 2
        Name = '@HeatID'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object procDeleteHeats: TFDStoredProc
    Connection = scmConnection
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    StoredProcName = 'DeleteHeat'
    Left = 464
    Top = 96
    ParamData = <
      item
        Position = 1
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        ParamType = ptResult
      end
      item
        Position = 2
        Name = '@HeatID'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object ProcDeleteALLHeats: TFDStoredProc
    Connection = scmConnection
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    StoredProcName = 'DeleteAllHeats'
    Left = 464
    Top = 32
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
end
