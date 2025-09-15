object SCM2: TSCM2
  Height = 381
  Width = 376
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
    Caption = 'SwimClubMeet Version 2'
    Left = 72
    Top = 264
  end
end
