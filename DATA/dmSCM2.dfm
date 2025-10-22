object SCM2: TSCM2
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 383
  Width = 414
  object scmConnection: TFDConnection
    Params.Strings = (
      'ApplicationName=SwimClubMeet2.exe'
      'ConnectionDef=MSSQL_SwimClubMeet2')
    ConnectedStoredUsage = [auDesignTime]
    Connected = True
    LoginPrompt = False
    AfterConnect = scmConnectionAfterConnect
    AfterDisconnect = scmConnectionAfterDisconnect
    Left = 80
    Top = 32
  end
  object qrySCMSystem: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Connection = scmConnection
    SQL.Strings = (
      'SELECT '
      '  [SCMSystemID]'
      '      ,[DBVersion]'
      '      ,[Major]'
      '      ,[Minor]'
      '      ,[Build]'
      '  FROM [SwimClubMeet2].[dbo].[SCMSystem]')
    Left = 80
    Top = 104
  end
  object scmFDManager: TFDManager
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 80
    Top = 184
  end
  object FDGUIxErrorDialog: TFDGUIxErrorDialog
    Provider = 'Forms'
    Caption = 'SwimClubMeet FireDAC Error'
    Enabled = False
    Left = 72
    Top = 264
  end
  object procRenumberHeats: TFDStoredProc
    Connection = scmConnection
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
    StoredProcName = 'SwimClubMeet2.dbo.RenumberEvents'
    Left = 280
    Top = 29
    ParamData = <
      item
        Position = 1
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        ParamType = ptResult
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
    StoredProcName = 'SwimClubMeet2.dbo.RenumberLanes'
    Left = 280
    Top = 149
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
end
