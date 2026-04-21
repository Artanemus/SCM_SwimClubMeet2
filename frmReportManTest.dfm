object ReportManTest: TReportManTest
  Left = 0
  Top = 0
  Caption = 'ReportManTest'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object RpDesignerVCL1: TRpDesignerVCL
    Left = 112
    Top = 64
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'ConnectionDef=MSSQL_SCM2')
    Connected = True
    LoginPrompt = False
    Left = 376
    Top = 88
  end
  object dsSwimClub: TDataSource
    DataSet = tblSwimClub
    Left = 376
    Top = 232
  end
  object RpAlias1: TRpAlias
    List = <
      item
        Alias = 'SWIMCLUB'
        Dataset = tblSwimClub
      end>
    Connections = <
      item
        Alias = 'MSSQL_SCM2'
        ConfigFile = 
          'C:\Users\Public\Documents\Embarcadero\Studio\FireDAC\FDConnectio' +
          'nDefs.ini'
        LoadParams = False
        LoadDriverParams = False
        LoginPrompt = False
        Driver = rpfiredac
        ADOConnectionString = ''
      end>
    Left = 88
    Top = 136
  end
  object VCLReport1: TVCLReport
    AsyncExecution = False
    PDFConformance = SetPDFDefault
    AliasList = RpAlias1
    Left = 152
    Top = 136
  end
  object tblSwimClub: TFDTable
    IndexFieldNames = 'SwimClubID'
    DetailFields = 'SwimClubID'
    Connection = FDConnection1
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2.dbo.SwimClub'
    Left = 376
    Top = 160
  end
end
