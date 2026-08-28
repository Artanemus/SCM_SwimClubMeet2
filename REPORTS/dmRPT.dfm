object RPT: TRPT
  OnCreate = DataModuleCreate
  Height = 608
  Width = 974
  object rptEvSummary: TfrxReport
    Version = '6.6.11'
    ParentReport = '..\TEMPLATEDIR\Template_Base.fr3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.AllowEdit = False
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 46261.499890659700000000
    ReportOptions.Name = 'TemplateBannerr'
    ReportOptions.LastChange = 46262.599919710700000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      '  '
      'end.          '
      ''
      '{'
      '// **********Script from parent report**********'
      'var'
      '  EnablePrintClubLogo: Boolean;'
      ''
      'procedure Page1OnBeforePrint(Sender: TfrxComponent);'
      'begin'
      
        '  // Set default coordinates (using fr1cm to convert 1.75 cm to ' +
        'pixels)'
      '  FClubName.Left := 0;'
      '  FClubName.Top := 0;'
      '  FNickName.Left := 0;'
      ''
      
        '  // Reference the script variable directly as a boolean (no bra' +
        'ckets)'
      '  if (EnablePrintClubLogo = true) then'
      '  begin'
      '    // Check if the database BLOB field is Null [6]'
      '    if <SwimClub."LogoImg"> = Null then'
      '    begin'
      '      FLogo.Visible := False;'
      '    end'
      '    else'
      '    begin'
      '      FLogo.Visible := True;'
      '      FClubName.Left := 1.52 * fr1cm;'
      '      FNickName.Left := 1.52 * fr1cm;'
      '    end;'
      '  end'
      '  else'
      '  begin'
      '    FLogo.Visible := false;'
      '  end;'
      'end;'
      ''
      'begin'
      
        '  EnablePrintClubLogo := true; // Sett to True to display the cl' +
        'ub logo'
      'end.'
      '}    '
      '')
    Left = 288
    Top = 16
    Datasets = <
      item
        DataSet = dsfrxSession
        DataSetName = 'Session'
      end
      item
        DataSet = dsfrxSwimClub
        DataSetName = 'SwimClub'
      end
      item
        DataSet = dsEvSummary
        DataSetName = 'EventSummary'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 215.900000000000000000
      PaperHeight = 279.400000000000000000
      PaperSize = 1
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      Frame.Typ = []
      MirrorMode = []
      OnBeforePrint = 'Page1OnBeforePrint'
      object scmHeader: TfrxPageHeader
        FillType = ftBrush
        Frame.Typ = []
        Height = 57.343846670000000000
        Top = 18.897650000000000000
        Width = 740.409927000000000000
        object FClubName: TfrxMemoView
          AllowVectorExport = True
          Left = 57.500000010000000000
          Top = 1.000000000000000000
          Width = 497.130180000000000000
          Height = 30.236240000000000000
          AutoWidth = True
          DataSetName = 'FDQuery1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[SwimClub."ClubName"]')
          ParentFont = False
        end
        object FNickName: TfrxMemoView
          AllowVectorExport = True
          Left = 57.000000010000000000
          Top = 23.677180000000000000
          Width = 335.130180000000000000
          Height = 18.897650000000000000
          DataSetName = 'FDQuery1'
          Frame.Typ = []
          Memo.UTF8W = (
            '[SwimClub."NickName"]')
        end
        object FSessionDT: TfrxMemoView
          Align = baRight
          AllowVectorExport = True
          Left = 434.267997000000000000
          Top = 22.677180000000000000
          Width = 306.141930000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              'Session Date: [<Session."SessionDT"> #dddd dd mmm yyyy HH:MM AM/' +
              'PM]')
          ParentFont = False
        end
        object FLogo: TfrxPictureView
          Description = 'SwimClub Logo'
          Align = baLeft
          AllowVectorExport = True
          Top = 0.602350000000000000
          Width = 53.291338580000000000
          Height = 53.338582680000000000
          Center = True
          DataField = 'LogoImg'
          DataSet = dsfrxSwimClub
          DataSetName = 'SwimClub'
          Frame.Typ = []
          HightQuality = True
          Transparent = True
          TransparentColor = clWhite
        end
      end
      object scmFooter: TfrxPageFooter
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 279.685220000000000000
        Width = 740.409927000000000000
        object TotalPages: TfrxMemoView
          AllowVectorExport = True
          Left = 268.456865000000000000
          Top = 0.603586670000000000
          Width = 185.196970000000000000
          Height = 18.897650000000000000
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Page [Page#] of [TotalPages#]')
          ParentFont = False
          Formats = <
            item
            end
            item
            end>
        end
        object Date: TfrxMemoView
          AllowVectorExport = True
          Left = 2.000000000000000000
          Top = 0.603586670000000000
          Width = 264.567100000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Printed On: [Date]')
        end
      end
      object GroupHeader1: TfrxGroupHeader
        FillType = ftBrush
        Frame.Typ = []
        Height = 36.010513330000000000
        Top = 136.063080000000000000
        Width = 740.409927000000000000
        Condition = 'EventSummary."SessionID"'
        object MemoEv: TfrxMemoView
          AllowVectorExport = True
          Left = 2.612863330000000000
          Width = 38.359616670000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Ev#')
          ParentFont = False
        end
        object MemoDistance: TfrxMemoView
          AllowVectorExport = True
          Left = 47.311070000000000000
          Width = 56.972480000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Distance')
        end
        object MemoStroke: TfrxMemoView
          AllowVectorExport = True
          Left = 107.955473330000000000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Stroke')
        end
        object MemoNominees: TfrxMemoView
          AllowVectorExport = True
          Left = 512.236550000000000000
          Top = 0.500000000000000000
          Width = 54.864819630000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Nominees')
          ParentFont = False
        end
        object MemoEntrants: TfrxMemoView
          AllowVectorExport = True
          Left = 569.768090000000000000
          Top = 0.500000000000000000
          Width = 44.031486300000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Entrants')
          ParentFont = False
        end
        object MemoHeats: TfrxMemoView
          AllowVectorExport = True
          Left = 615.632963330000000000
          Top = 0.500000000000000000
          Width = 35.031486300000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Heats')
          ParentFont = False
        end
        object MemoEvdescription: TfrxMemoView
          AllowVectorExport = True
          Left = 224.244280000000000000
          Width = 283.212740000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Event Description')
        end
        object MemoStatus: TfrxMemoView
          AllowVectorExport = True
          Left = 651.833333330000000000
          Top = 0.377860000000000000
          Width = 43.488250000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Status')
          ParentFont = False
        end
        object LineGroupHeader: TfrxLineView
          AllowVectorExport = True
          Left = 4.000000000000000000
          Top = 25.035250000000000000
          Width = 714.551640000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
          Frame.Width = 2.000000000000000000
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 196.535560000000000000
        Width = 740.409927000000000000
        DataSet = dsEvSummary
        DataSetName = 'EventSummary'
        RowCount = 0
        object frxDistance: TfrxMemoView
          AllowVectorExport = True
          Left = 36.698206670000000000
          Top = 0.684910000000000000
          Width = 58.972480000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[EventSummary."Distance"]')
          ParentFont = False
        end
        object frxStroke: TfrxMemoView
          AllowVectorExport = True
          Left = 104.009276670000000000
          Top = 0.684910000000000000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Frame.Typ = []
          Memo.UTF8W = (
            '[EventSummary."Stroke"]')
        end
        object frxNomineeCount: TfrxMemoView
          AllowVectorExport = True
          Left = 509.623686670000000000
          Top = 1.184910000000000000
          Width = 55.472426300000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            
              '[IIF(<EventSummary."NomineeCount"> = 0 ,0,<EventSummary."Nominee' +
              'Count">) #n%3.0f]')
          ParentFont = False
        end
        object frxEntrantCount: TfrxMemoView
          AllowVectorExport = True
          Left = 567.155226670000000000
          Top = 0.684910000000000000
          Width = 43.472426300000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            
              '[IIF(<EventSummary."EntrantCount"> = 0 ,0,<EventSummary."Entrant' +
              'Count">) #n%3.0f]')
          ParentFont = False
        end
        object frxHeatCount: TfrxMemoView
          AllowVectorExport = True
          Left = 612.186766670000000000
          Top = 1.184910000000000000
          Width = 34.472426300000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[EventSummary."HeatCount" #n%3.0f]')
          ParentFont = False
        end
        object frxEvent: TfrxMemoView
          AllowVectorExport = True
          Left = 224.131416670000000000
          Top = 1.184910000000000000
          Width = 282.212740000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[EventSummary."EventDescription"]')
          ParentFont = False
        end
        object frxStatus: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 649.220470000000000000
          Top = 0.684910000000000000
          Width = 45.252010000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[EventSummary."EventStatus"]')
          ParentFont = False
        end
        object frxEventNum: TfrxMemoView
          AllowVectorExport = True
          Left = 2.666666670000000000
          Top = 0.718923330000000000
          Width = 31.913420000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[<EventSummary."EventNum"> #n%3g]')
          ParentFont = False
        end
      end
    end
  end
  object qryEvSummary: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Active = True
    IndexFieldNames = 'SessionID'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvFmtDisplayTime]
    FormatOptions.FmtDisplayTime = 'hh:nn'
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.KeyFields = 'EventID'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'DECLARE @SessionID AS INT;'
      ''
      'SET @SessionID = :SESSIONID;'
      ''
      'SELECT   Event.EventID,'
      '         Event.EventNum,'
      '         SubString(Distance.CalcCaption,1, 8) AS Distance,'
      '         SubString(Stroke.Caption,1,16) AS Stroke,'
      '         dbo.EntrantCount(Event.EventID) AS EntrantCount,'
      '         dbo.NomineeCount(Event.EventID) AS NomineeCount,'
      '         dbo.HeatCount(Event.EventID) AS HeatCount,'
      '         Session.SessionDT,'
      '         Event.SessionID,'
      '         SubString(Event.Caption, 1, 64) AS EventDescription, '
      '         Event.StartTime,'
      '         SubString(EventStatus.Caption,1,8) AS EventStatus'
      'FROM     Event'
      '         INNER JOIN'
      '         Distance'
      '         ON Event.DistanceID = Distance.DistanceID'
      '         INNER JOIN'
      '         Stroke'
      '         ON Event.StrokeID = Stroke.StrokeID'
      '         INNER JOIN'
      '         Session'
      '         ON Event.SessionID = Session.SessionID'
      '         INNER JOIN'
      '         EventStatus'
      '         ON Event.EventStatusID = EventStatus.EventStatusID'
      ''
      'WHERE    Event.SessionID = @SessionID'
      'ORDER BY Event.EventNum;'
      ''
      ''
      '')
    Left = 72
    Top = 16
    ParamData = <
      item
        Name = 'SESSIONID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end>
  end
  object frxXLSExport1: TfrxXLSExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    ExportEMF = True
    AsText = False
    Background = True
    FastExport = True
    PageBreaks = True
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 640
    Top = 248
  end
  object frxHTMLExport1: TfrxHTMLExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    OpenAfterExport = False
    FixedWidth = True
    Background = False
    Centered = False
    EmptyLines = True
    Print = False
    PictureType = gpPNG
    Left = 640
    Top = 192
  end
  object frxPDFExport1: TfrxPDFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    OpenAfterExport = False
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Quality = 95
    Transparency = False
    Author = 'FastReport'
    Subject = 'FastReport PDF export'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    PdfA = False
    PDFStandard = psNone
    PDFVersion = pv17
    Left = 640
    Top = 136
  end
  object dsEvSummary: TfrxDBDataset
    UserName = 'EventSummary'
    CloseDataSource = False
    FieldAliases.Strings = (
      'EventID=EventID'
      'EventNum=EventNum'
      'Distance=Distance'
      'Stroke=Stroke'
      'EntrantCount=EntrantCount'
      'NomineeCount=NomineeCount'
      'HeatCount=HeatCount'
      'SessionDT=SessionDT'
      'SessionID=SessionID'
      'EventDescription=EventDescription'
      'StartTime=StartTime'
      'EventStatus=EventStatus')
    DataSet = qryEvSummary
    BCDToCurrency = False
    Left = 168
    Top = 16
  end
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
      '--      ,[Address]   '
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
  object rptEvDetailed: TfrxReport
    Version = '6.6.11'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.AllowEdit = False
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.Author = 'Ben Ambrose'
    ReportOptions.CreateDate = 43428.811813125000000000
    ReportOptions.Name = 'Sys-Event-Detailed'
    ReportOptions.LastChange = 46262.486124062500000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'var'
      ' EnablePrintClubLogo: boolean;'
      '   '
      'procedure Page1OnBeforePrint(Sender: TfrxComponent);'
      'begin'
      
        '    // Set default coordinates (using fr1cm to convert 1.75 cm t' +
        'o pixels)'
      '  FClubName.Left := 0;'
      
        '  FNickName.Left := 0;                                          ' +
        '                      '
      '  '
      
        '  // Reference the script variable directly as a boolean (no bra' +
        'ckets)'
      '  if (EnablePrintClubLogo = true) then'
      '  begin              '
      '    // Check if the database BLOB field is Null [6]'
      '    if <SwimClub."LogoImg"> = Null then'
      '    begin                '
      '      FLogo.Visible := False;'
      '    end                '
      '    else'
      '    begin              '
      '      FLogo.Visible := True;'
      '      FClubName.Left := 1.75 * fr1cm;'
      
        '      FNickName.Left := 1.75 * fr1cm;                           ' +
        '                                     '
      '    end;'
      '  end'
      '  else'
      '  begin'
      '    FLogo.Visible := false;      '
      '  end;  '
      'end;'
      ''
      'begin'
      
        ' EnablePrintClubLogo := false;                                  ' +
        '                                                    '
      'end.')
    Left = 288
    Top = 88
    Datasets = <
      item
        DataSet = dsEvSummary
        DataSetName = 'EventSummary'
      end
      item
        DataSet = dsfrxSession
        DataSetName = 'Session'
      end
      item
        DataSet = dsfrxSwimClub
        DataSetName = 'SwimClub'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      Frame.Typ = []
      EndlessWidth = True
      MirrorMode = []
      OnBeforePrint = 'Page1OnBeforePrint'
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        Frame.Typ = []
        Height = 68.031540000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object FNickName: TfrxMemoView
          AllowVectorExport = True
          Left = 58.666666670000000000
          Top = 19.343846670000000000
          Width = 400.630180000000000000
          Height = 18.897650000000000000
          DataSetName = 'FDQuery1'
          Frame.Typ = []
          Memo.UTF8W = (
            '[SwimClub."NickName"]')
        end
        object FSessionDT: TfrxMemoView
          AllowVectorExport = True
          Left = 404.409710000000000000
          Top = 22.677180000000000000
          Width = 306.141930000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              'Session Date: [<Session."SessionDT"> #dddd dd mmm yyyy HH:MM AM/' +
              'PM]')
          ParentFont = False
        end
        object FClubName: TfrxMemoView
          AllowVectorExport = True
          Left = 58.666666660000000000
          Top = -0.666666670000000000
          Width = 400.630180000000000000
          Height = 30.236240000000000000
          AutoWidth = True
          DataSetName = 'FDQuery1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[SwimClub."ClubName"]')
          ParentFont = False
        end
        object FLogo: TfrxPictureView
          Description = 'SwimClub Logo'
          AllowVectorExport = True
          Left = 2.000000000000000000
          Top = -0.230983330000000000
          Width = 53.291338580000000000
          Height = 53.338582680000000000
          Center = True
          DataField = 'LogoImg'
          DataSet = dsfrxSwimClub
          DataSetName = 'SwimClub'
          Frame.Typ = []
          HightQuality = True
          Transparent = True
          TransparentColor = clWhite
        end
        object SessionSessionStatus: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 505.333333330000000000
          Top = 35.769016670000000000
          Width = 257.008040000000000000
          Height = 18.897650000000000000
          DataField = 'SessionStatus'
          DataSet = dsfrxSession
          DataSetName = 'Session'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[Session."SessionStatus"]')
          ParentFont = False
        end
      end
      object GroupHeader1: TfrxGroupHeader
        FillType = ftBrush
        Fill.BackColor = 15461355
        Frame.Typ = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Height = 30.236240000000000000
        ParentFont = False
        Top = 147.401670000000000000
        Width = 718.110700000000000000
        Condition = 'Event."SessionID"'
        object MemoEventNum: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 8.456710000000000000
          Width = 49.133890000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Event #')
          ParentFont = False
        end
        object MemoDistance: TfrxMemoView
          AllowVectorExport = True
          Left = 60.472480000000000000
          Top = 8.456710000000000000
          Width = 68.031540000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            'Distance')
          ParentFont = False
        end
        object MemoStroke: TfrxMemoView
          AllowVectorExport = True
          Left = 133.842610000000000000
          Top = 8.456710000000000000
          Width = 102.047310000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Stroke')
        end
        object MemoNominees: TfrxMemoView
          AllowVectorExport = True
          Left = 506.457020000000000000
          Top = 8.456710000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Nominees')
          ParentFont = False
        end
        object MemoEntrants: TfrxMemoView
          AllowVectorExport = True
          Left = 574.488560000000000000
          Top = 8.456710000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Entrants')
          ParentFont = False
        end
        object MemoHeats: TfrxMemoView
          AllowVectorExport = True
          Left = 642.520100000000000000
          Top = 8.456710000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Heats')
          ParentFont = False
        end
        object MemoEvDescription: TfrxMemoView
          AllowVectorExport = True
          Left = 238.110390000000000000
          Top = 8.456710000000000000
          Width = 245.669450000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Event Description')
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Frame.Typ = []
        Height = 49.133890000000000000
        Top = 200.315090000000000000
        Width = 718.110700000000000000
        DataSet = dsEvSummary
        DataSetName = 'EventSummary'
        RowCount = 0
        object FEventNum: TfrxMemoView
          AllowVectorExport = True
          Top = 2.000000000000000000
          Width = 52.913420000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[<Event."EventNum"> #n%3.0g]')
          ParentFont = False
        end
        object FDistance: TfrxMemoView
          AllowVectorExport = True
          Left = 68.031540000000000000
          Top = 2.000000000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[Event."Distance"]')
          ParentFont = False
        end
        object FStroke: TfrxMemoView
          AllowVectorExport = True
          Left = 133.842610000000000000
          Top = 2.000000000000000000
          Width = 102.047310000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Frame.Typ = []
          Memo.UTF8W = (
            '[Event."Stroke"]')
        end
        object FNominees: TfrxMemoView
          AllowVectorExport = True
          Left = 506.457020000000000000
          Top = 2.000000000000000000
          Width = 60.472426300000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            
              '[IIF(<Event."NomineeCount"> = 0 ,0,<Event."NomineeCount">) #n%3.' +
              '0g]')
          ParentFont = False
        end
        object FEntrants: TfrxMemoView
          AllowVectorExport = True
          Left = 574.488560000000000000
          Top = 2.000000000000000000
          Width = 60.472426300000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            
              '[IIF(<Event."EntrantCount"> = 0 ,0,<Event."EntrantCount">) #n%3.' +
              '0g]')
          ParentFont = False
        end
        object FHeats: TfrxMemoView
          AllowVectorExport = True
          Left = 642.520100000000000000
          Top = 2.000000000000000000
          Width = 60.472426300000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[Event."HeatCount" #n%3.0g]')
          ParentFont = False
        end
        object FEvDescription: TfrxMemoView
          AllowVectorExport = True
          Left = 238.110390000000000000
          Top = 1.333333330000000000
          Width = 245.669450000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[Event."EventDescription"]')
          ParentFont = False
        end
      end
      object PageFooter1: TfrxPageFooter
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 483.779840000000000000
        Width = 718.110700000000000000
        object TotalPages: TfrxMemoView
          AllowVectorExport = True
          Left = 266.456865000000000000
          Top = 1.889765000000010000
          Width = 185.196970000000000000
          Height = 18.897650000000000000
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Page [Page#] of [TotalPages#]')
          ParentFont = False
          Formats = <
            item
            end
            item
            end>
        end
        object Date: TfrxMemoView
          AllowVectorExport = True
          Top = 1.889765000000010000
          Width = 264.567100000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Printed On: [Date]')
        end
      end
      object DetailData1: TfrxDetailData
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 359.055350000000000000
        Width = 718.110700000000000000
        Columns = 3
        ColumnWidth = 238.110236220472000000
        ColumnGap = 3.779527559055120000
        DataSet = dsEvSummary
        DataSetName = 'EventSummary'
        RowCount = 0
        object FNominee: TfrxMemoView
          AllowVectorExport = True
          Left = 29.472480000000000000
          Top = -0.666666670000000000
          Width = 132.283550000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Frame.Typ = []
          Memo.UTF8W = (
            '[Event."MemberName"]')
        end
        object FRaceTime: TfrxMemoView
          AllowVectorExport = True
          Left = 167.299320000000000000
          Width = 68.031540000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Frame.Typ = []
          Memo.UTF8W = (
            '[Event."RaceTime"]')
        end
        object frxDSLane: TfrxMemoView
          AllowVectorExport = True
          Left = 2.779530000000000000
          Width = 22.677180000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[Event."LaneNum" #n%2.0f]')
          ParentFont = False
        end
      end
      object GroupHeader2: TfrxGroupHeader
        FillType = ftBrush
        Frame.Typ = []
        Height = 64.252010000000000000
        Top = 272.126160000000000000
        Width = 718.110700000000000000
        Condition = 'Event."HeatNum"'
        object Shape1: TfrxShapeView
          AllowVectorExport = True
          Top = 11.338590000000000000
          Width = 718.110700000000000000
          Height = 30.236240000000000000
          Fill.BackColor = cl3DLight
          Frame.Color = clNone
          Frame.Typ = []
        end
        object MemoHeatGrp2: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 18.897650000000000000
          Width = 143.622140000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'HEAT : [Event."HeatNum"]')
          ParentFont = False
        end
        object LineGrpr2: TfrxLineView
          AllowVectorExport = True
          Left = 1.779530000000000000
          Top = 37.795300000000000000
          Width = 714.331170000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
          Frame.Width = 2.000000000000000000
        end
        object MemoRaceTime: TfrxMemoView
          AllowVectorExport = True
          Left = 166.039476670000000000
          Top = 42.614203330000000000
          Width = 69.291383330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'RaceTime')
          ParentFont = False
        end
        object MemoEntrant: TfrxMemoView
          AllowVectorExport = True
          Left = 29.472480000000000000
          Top = 42.354360000000000000
          Width = 133.543393330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Entrant')
          ParentFont = False
        end
        object MemoLane: TfrxMemoView
          AllowVectorExport = True
          Left = 0.740156670000000000
          Top = 42.354360000000000000
          Width = 27.716553330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Lane')
          ParentFont = False
        end
        object MemoRaceTimeC2: TfrxMemoView
          AllowVectorExport = True
          Left = 407.189240000000000000
          Top = 41.834673330000000000
          Width = 69.291383330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'RaceTime')
          ParentFont = False
        end
        object MemoEntrantC2: TfrxMemoView
          AllowVectorExport = True
          Left = 270.622243330000000000
          Top = 41.574830000000000000
          Width = 133.543393330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Entrant')
          ParentFont = False
        end
        object MemoLaneC2: TfrxMemoView
          AllowVectorExport = True
          Left = 241.889920000000000000
          Top = 41.574830000000000000
          Width = 27.716553330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Lane')
          ParentFont = False
        end
        object MemoRaceTimeCc2: TfrxMemoView
          AllowVectorExport = True
          Left = 649.079160000000000000
          Top = 41.834673330000000000
          Width = 69.291383330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'RaceTime')
          ParentFont = False
        end
        object FEntrantC3: TfrxMemoView
          AllowVectorExport = True
          Left = 512.512163330000000000
          Top = 41.574830000000000000
          Width = 133.543393330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Entrant')
          ParentFont = False
        end
        object MemoLaneC3: TfrxMemoView
          AllowVectorExport = True
          Left = 483.779840000000000000
          Top = 41.574830000000000000
          Width = 27.716553330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Lane')
          ParentFont = False
        end
        object LineC2: TfrxLineView
          AllowVectorExport = True
          Left = 482.000310000000000000
          Top = 37.015770000000000000
          Height = 101.811070000000000000
          Color = clBlack
          Frame.Typ = [ftLeft]
          Frame.Width = 2.000000000000000000
        end
        object LineC3: TfrxLineView
          AllowVectorExport = True
          Left = 240.110390000000000000
          Top = 37.795300000000000000
          Height = 100.311070000000000000
          Color = clBlack
          Frame.Typ = [ftLeft]
          Frame.Width = 2.000000000000000000
        end
      end
      object GroupFooter1: TfrxGroupFooter
        FillType = ftBrush
        Frame.Typ = []
        Height = 18.897650000000000000
        Top = 404.409710000000000000
        Width = 718.110700000000000000
      end
    end
  end
  object rptEventMisc: TfrxReport
    Version = '6.6.11'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.AllowEdit = False
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 46261.484910520830000000
    ReportOptions.LastChange = 46261.484910520830000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      'begin'
      ''
      'end.')
    Left = 288
    Top = 240
    Datasets = <
      item
        DataSet = dsEvMisc
        DataSetName = 'EventMisc'
      end
      item
        DataSet = dsfrxSession
        DataSetName = 'Session'
      end
      item
        DataSet = dsfrxSwimClub
        DataSetName = 'SwimClub'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      Frame.Typ = []
      MirrorMode = []
      object ReportTitle1: TfrxReportTitle
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 102.047310000000000000
        Width = 718.110700000000000000
        RowCount = 0
      end
      object PageFooter1: TfrxPageFooter
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 185.196970000000000000
        Width = 718.110700000000000000
        object Memo1: TfrxMemoView
          AllowVectorExport = True
          Left = 642.520100000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[Page#]')
        end
      end
    end
  end
  object rptEvDetailedEx: TfrxReport
    Version = '6.6.11'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.AllowEdit = False
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.Author = 'Ben Ambrose'
    ReportOptions.CreateDate = 43428.811813125000000000
    ReportOptions.Name = 'Sys-Event-Detailed'
    ReportOptions.LastChange = 46261.459876354200000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'var'
      ' EnablePrintClubLogo: boolean;'
      '   '
      'procedure Page1OnBeforePrint(Sender: TfrxComponent);'
      'begin'
      
        '    // Set default coordinates (using fr1cm to convert 1.75 cm t' +
        'o pixels)'
      '  FClubName.Left := 0;'
      
        '  FNickName.Left := 0;                                          ' +
        '                      '
      '  '
      
        '  // Reference the script variable directly as a boolean (no bra' +
        'ckets)'
      '  if (EnablePrintClubLogo = true) then'
      '  begin              '
      '    // Check if the database BLOB field is Null [6]'
      '    if <SwimClub."LogoImg"> = Null then'
      '    begin                '
      '      FLogo.Visible := False;'
      '    end                '
      '    else'
      '    begin              '
      '      FLogo.Visible := True;'
      '      FClubName.Left := 1.75 * fr1cm;'
      
        '      FNickName.Left := 1.75 * fr1cm;                           ' +
        '                                     '
      '    end;'
      '  end'
      '  else'
      '  begin'
      '    FLogo.Visible := false;      '
      '  end;  '
      'end;'
      ''
      'begin'
      
        ' EnablePrintClubLogo := false;                                  ' +
        '                                                    '
      'end.')
    Left = 288
    Top = 168
    Datasets = <
      item
        DataSet = dsEvSummary
        DataSetName = 'EventSummary'
      end
      item
        DataSet = dsfrxSession
        DataSetName = 'Session'
      end
      item
        DataSet = dsfrxSwimClub
        DataSetName = 'SwimClub'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      Frame.Typ = []
      EndlessWidth = True
      MirrorMode = []
      OnBeforePrint = 'Page1OnBeforePrint'
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        Frame.Typ = []
        Height = 68.031540000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object FNickName: TfrxMemoView
          AllowVectorExport = True
          Left = 58.666666670000000000
          Top = 19.343846670000000000
          Width = 400.630180000000000000
          Height = 18.897650000000000000
          DataSetName = 'FDQuery1'
          Frame.Typ = []
          Memo.UTF8W = (
            '[SwimClub."NickName"]')
        end
        object FSessionDT: TfrxMemoView
          AllowVectorExport = True
          Left = 404.409710000000000000
          Top = 22.677180000000000000
          Width = 306.141930000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              'Session Date: [<Session."SessionDT"> #dddd dd mmm yyyy HH:MM AM/' +
              'PM]')
          ParentFont = False
        end
        object FClubName: TfrxMemoView
          AllowVectorExport = True
          Left = 58.666666660000000000
          Top = -0.666666670000000000
          Width = 400.630180000000000000
          Height = 30.236240000000000000
          AutoWidth = True
          DataSetName = 'FDQuery1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[SwimClub."ClubName"]')
          ParentFont = False
        end
        object FLogo: TfrxPictureView
          Description = 'SwimClub Logo'
          AllowVectorExport = True
          Left = 2.000000000000000000
          Top = -0.230983330000000000
          Width = 53.291338580000000000
          Height = 53.338582680000000000
          Center = True
          DataField = 'LogoImg'
          DataSet = dsfrxSwimClub
          DataSetName = 'SwimClub'
          Frame.Typ = []
          HightQuality = True
          Transparent = True
          TransparentColor = clWhite
        end
        object SessionSessionStatus: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 505.333333330000000000
          Top = 35.769016670000000000
          Width = 257.008040000000000000
          Height = 18.897650000000000000
          DataField = 'SessionStatus'
          DataSet = dsfrxSession
          DataSetName = 'Session'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[Session."SessionStatus"]')
          ParentFont = False
        end
      end
      object GroupHeader1: TfrxGroupHeader
        FillType = ftBrush
        Fill.BackColor = 15461355
        Frame.Typ = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Height = 30.236240000000000000
        ParentFont = False
        Top = 192.756030000000000000
        Width = 718.110700000000000000
        Condition = 'Event."EventID"'
        object MemoEventNum: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 8.456710000000000000
          Width = 49.133890000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Event #')
          ParentFont = False
        end
        object MemoDistance: TfrxMemoView
          AllowVectorExport = True
          Left = 60.472480000000000000
          Top = 8.456710000000000000
          Width = 68.031540000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            'Distance')
          ParentFont = False
        end
        object MemoStroke: TfrxMemoView
          AllowVectorExport = True
          Left = 133.842610000000000000
          Top = 8.456710000000000000
          Width = 102.047310000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Stroke')
        end
        object MemoNominees: TfrxMemoView
          AllowVectorExport = True
          Left = 506.457020000000000000
          Top = 8.456710000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Nominees')
          ParentFont = False
        end
        object MemoEntrants: TfrxMemoView
          AllowVectorExport = True
          Left = 574.488560000000000000
          Top = 8.456710000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Entrants')
          ParentFont = False
        end
        object MemoHeats: TfrxMemoView
          AllowVectorExport = True
          Left = 642.520100000000000000
          Top = 8.456710000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Heats')
          ParentFont = False
        end
        object MemoEvDescription: TfrxMemoView
          AllowVectorExport = True
          Left = 238.110390000000000000
          Top = 8.456710000000000000
          Width = 245.669450000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Event Description')
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Frame.Typ = []
        Height = 49.133890000000000000
        Top = 245.669450000000000000
        Width = 718.110700000000000000
        DataSet = dsEvSummary
        DataSetName = 'EventSummary'
        RowCount = 0
        object FEventNum: TfrxMemoView
          AllowVectorExport = True
          Top = 2.000000000000000000
          Width = 52.913420000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[<Event."EventNum"> #n%3.0g]')
          ParentFont = False
        end
        object FDistance: TfrxMemoView
          AllowVectorExport = True
          Left = 68.031540000000000000
          Top = 2.000000000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[Event."Distance"]')
          ParentFont = False
        end
        object FStroke: TfrxMemoView
          AllowVectorExport = True
          Left = 133.842610000000000000
          Top = 2.000000000000000000
          Width = 102.047310000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Frame.Typ = []
          Memo.UTF8W = (
            '[Event."Stroke"]')
        end
        object FNominees: TfrxMemoView
          AllowVectorExport = True
          Left = 506.457020000000000000
          Top = 2.000000000000000000
          Width = 60.472426300000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            
              '[IIF(<Event."NomineeCount"> = 0 ,0,<Event."NomineeCount">) #n%3.' +
              '0g]')
          ParentFont = False
        end
        object FEntrants: TfrxMemoView
          AllowVectorExport = True
          Left = 574.488560000000000000
          Top = 2.000000000000000000
          Width = 60.472426300000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            
              '[IIF(<Event."EntrantCount"> = 0 ,0,<Event."EntrantCount">) #n%3.' +
              '0g]')
          ParentFont = False
        end
        object FHeats: TfrxMemoView
          AllowVectorExport = True
          Left = 642.520100000000000000
          Top = 2.000000000000000000
          Width = 60.472426300000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[Event."HeatCount" #n%3.0g]')
          ParentFont = False
        end
        object FEvDescription: TfrxMemoView
          AllowVectorExport = True
          Left = 238.110390000000000000
          Top = 1.333333330000000000
          Width = 245.669450000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[Event."EventDescription"]')
          ParentFont = False
        end
      end
      object PageFooter1: TfrxPageFooter
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 574.488560000000000000
        Width = 718.110700000000000000
        object TotalPages: TfrxMemoView
          AllowVectorExport = True
          Left = 266.456865000000000000
          Top = 1.889765000000010000
          Width = 185.196970000000000000
          Height = 18.897650000000000000
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Page [Page#] of [TotalPages#]')
          ParentFont = False
          Formats = <
            item
            end
            item
            end>
        end
        object Date: TfrxMemoView
          AllowVectorExport = True
          Top = 1.889765000000010000
          Width = 264.567100000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Printed On: [Date]')
        end
      end
      object DetailData1: TfrxDetailData
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 404.409710000000000000
        Width = 718.110700000000000000
        Columns = 3
        ColumnWidth = 238.110236220472000000
        ColumnGap = 3.779527559055120000
        DataSet = dsEvSummary
        DataSetName = 'EventSummary'
        RowCount = 0
        object FNominee: TfrxMemoView
          AllowVectorExport = True
          Left = 29.472480000000000000
          Top = -0.666666670000000000
          Width = 132.283550000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Frame.Typ = []
          Memo.UTF8W = (
            '[Event."MemberName"]')
        end
        object FRaceTime: TfrxMemoView
          AllowVectorExport = True
          Left = 167.299320000000000000
          Width = 68.031540000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Frame.Typ = []
          Memo.UTF8W = (
            '[Event."RaceTime"]')
        end
        object frxDSLane: TfrxMemoView
          AllowVectorExport = True
          Left = 2.779530000000000000
          Width = 22.677180000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[Event."LaneNum" #n%2.0f]')
          ParentFont = False
        end
      end
      object GroupHeader2: TfrxGroupHeader
        FillType = ftBrush
        Frame.Typ = []
        Height = 64.252010000000000000
        Top = 317.480520000000000000
        Width = 718.110700000000000000
        Condition = 'Event."HeatNum"'
        object Shape1: TfrxShapeView
          AllowVectorExport = True
          Top = 11.338590000000000000
          Width = 718.110700000000000000
          Height = 30.236240000000000000
          Fill.BackColor = cl3DLight
          Frame.Color = clNone
          Frame.Typ = []
        end
        object MemoHeatGrp2: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 18.897650000000000000
          Width = 143.622140000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'HEAT : [Event."HeatNum"]')
          ParentFont = False
        end
        object LineGrpr2: TfrxLineView
          AllowVectorExport = True
          Left = 1.779530000000000000
          Top = 37.795300000000000000
          Width = 714.331170000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
          Frame.Width = 2.000000000000000000
        end
        object MemoRaceTime: TfrxMemoView
          AllowVectorExport = True
          Left = 166.039476670000000000
          Top = 42.614203330000000000
          Width = 69.291383330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'RaceTime')
          ParentFont = False
        end
        object MemoEntrant: TfrxMemoView
          AllowVectorExport = True
          Left = 29.472480000000000000
          Top = 42.354360000000000000
          Width = 133.543393330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Entrant')
          ParentFont = False
        end
        object MemoLane: TfrxMemoView
          AllowVectorExport = True
          Left = 0.740156670000000000
          Top = 42.354360000000000000
          Width = 27.716553330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Lane')
          ParentFont = False
        end
        object MemoRaceTimeC2: TfrxMemoView
          AllowVectorExport = True
          Left = 407.189240000000000000
          Top = 41.834673330000000000
          Width = 69.291383330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'RaceTime')
          ParentFont = False
        end
        object MemoEntrantC2: TfrxMemoView
          AllowVectorExport = True
          Left = 270.622243330000000000
          Top = 41.574830000000000000
          Width = 133.543393330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Entrant')
          ParentFont = False
        end
        object MemoLaneC2: TfrxMemoView
          AllowVectorExport = True
          Left = 241.889920000000000000
          Top = 41.574830000000000000
          Width = 27.716553330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Lane')
          ParentFont = False
        end
        object MemoRaceTimeCc2: TfrxMemoView
          AllowVectorExport = True
          Left = 649.079160000000000000
          Top = 41.834673330000000000
          Width = 69.291383330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'RaceTime')
          ParentFont = False
        end
        object FEntrantC3: TfrxMemoView
          AllowVectorExport = True
          Left = 512.512163330000000000
          Top = 41.574830000000000000
          Width = 133.543393330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Entrant')
          ParentFont = False
        end
        object MemoLaneC3: TfrxMemoView
          AllowVectorExport = True
          Left = 483.779840000000000000
          Top = 41.574830000000000000
          Width = 27.716553330000000000
          Height = 13.858276670000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Lane')
          ParentFont = False
        end
        object LineC2: TfrxLineView
          AllowVectorExport = True
          Left = 482.000310000000000000
          Top = 37.015770000000000000
          Height = 101.811070000000000000
          Color = clBlack
          Frame.Typ = [ftLeft]
          Frame.Width = 2.000000000000000000
        end
        object LineC3: TfrxLineView
          AllowVectorExport = True
          Left = 240.110390000000000000
          Top = 37.795300000000000000
          Height = 100.311070000000000000
          Color = clBlack
          Frame.Typ = [ftLeft]
          Frame.Width = 2.000000000000000000
        end
      end
      object GroupFooter1: TfrxGroupFooter
        FillType = ftBrush
        Frame.Typ = []
        Height = 18.897650000000000000
        Top = 449.764070000000000000
        Width = 718.110700000000000000
      end
      object GroupHeader3: TfrxGroupHeader
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 147.401670000000000000
        Width = 718.110700000000000000
        Condition = 'Event."SessionID"'
      end
      object GroupFooter2: TfrxGroupFooter
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 491.338900000000000000
        Width = 718.110700000000000000
      end
    end
  end
  object qryEvDetailed: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    IndexesActive = False
    IndexFieldNames = 'EventID'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvFmtDisplayDateTime, fvFmtDisplayTime]
    FormatOptions.FmtDisplayDateTime = 'dd mmm YYYY'
    FormatOptions.FmtDisplayTime = 'nn:ss.zzz'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'DECLARE @EventID AS INT;'
      ''
      'SET @EventID = :EVENTID;'
      ''
      'SELECT   Event.EventID,'
      '         Event.EventNum,'
      '         SubString(Distance.CalcCaption,1, 8) AS Distance,'
      '         SubString(Stroke.Caption,1,16) AS Stroke,'
      '         SubString(Event.Caption, 1, 64) AS EventDescription,'
      '         dbo.EntrantCount(Event.EventID) AS EntrantCount,'
      '         dbo.NomineeCount(Event.EventID) AS NomineeCount,'
      '         dbo.HeatCount(Event.EventID) AS HeatCount,'
      '         Event.SessionID,'
      '         Event.StartTime,'
      '         Member.MemberID,'
      
        '         SUBSTRING(dbo.GetMemberFullName(Member.memberID), 1, 32' +
        ') AS MemberName,'
      '         Lane.HeatID,'
      '         dbo.SwimTimeToString(Lane.RaceTime) AS RaceTime,'
      '         Heat.HeatNum,'
      '         Lane.LaneNum,'
      '         SubString(EventStatus.Caption,1,8) AS EventStatus'
      ''
      'FROM     Event'
      '         INNER JOIN'
      '         Heat'
      '         ON Event.EventID = Heat.EventID'
      '         INNER JOIN'
      '         Lane'
      '         ON Heat.HeatID = Lane.HeatID'
      '         LEFT OUTER JOIN'
      '         Nominee'
      '         ON Lane.NomineeId = Nominee.NomineeID'
      '         LEFT OUTER JOIN'
      '         Member'
      '         ON Nominee.MemberID = Member.MemberID'
      '         INNER JOIN'
      '         Distance'
      '         ON Event.DistanceID = Distance.DistanceID'
      '         INNER JOIN'
      '         Stroke'
      '         ON Event.StrokeID = Stroke.StrokeID'
      '         INNER JOIN'
      '         EventStatus'
      '         ON Event.EventStatusID = EventStatus.EventStatusID'
      ''
      'WHERE    Event.EventID = @EventID'
      'ORDER BY HeatNum, LaneNum;')
    Left = 72
    Top = 88
    ParamData = <
      item
        Name = 'EVENTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 20
      end>
  end
  object dsEvDetailed: TfrxDBDataset
    UserName = 'EventDetailed'
    CloseDataSource = False
    FieldAliases.Strings = (
      'EventID=EventID'
      'EventNum=EventNum'
      'Distance=Distance'
      'Stroke=Stroke'
      'EventDescription=EventDescription'
      'EntrantCount=EntrantCount'
      'NomineeCount=NomineeCount'
      'HeatCount=HeatCount'
      'SessionID=SessionID'
      'StartTime=StartTime'
      'MemberID=MemberID'
      'MemberName=MemberName'
      'HeatID=HeatID'
      'RaceTime=RaceTime'
      'HeatNum=HeatNum'
      'LaneNum=LaneNum'
      'EventStatus=EventStatus')
    DataSet = qryEvDetailed
    BCDToCurrency = False
    Left = 168
    Top = 88
  end
  object qryEvMisc: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Active = True
    IndexesActive = False
    IndexFieldNames = 'EventID'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvFmtDisplayDateTime, fvFmtDisplayTime]
    FormatOptions.FmtDisplayDateTime = 'dd mmm YYYY'
    FormatOptions.FmtDisplayTime = 'nn:ss.zzz'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'DECLARE @EventID AS INT;'
      ''
      'SET @EventID = :EVENTID;'
      ''
      'SELECT   Event.EventID,'
      '         Event.EventNum,'
      '         SubString(Distance.CalcCaption,1, 8) AS Distance,'
      '         SubString(Stroke.Caption,1,16) AS Stroke,'
      '         SubString(Event.Caption, 1, 64) AS EventDescription,'
      '         dbo.EntrantCount(Event.EventID) AS EntrantCount,'
      '         dbo.NomineeCount(Event.EventID) AS NomineeCount,'
      '         dbo.HeatCount(Event.EventID) AS HeatCount,'
      '         Event.SessionID,'
      '         Event.StartTime,'
      '         Member.MemberID,'
      
        '         SUBSTRING(dbo.GetMemberFullName(Member.memberID), 1, 32' +
        ') AS MemberName,'
      '         Lane.HeatID,'
      '         dbo.SwimTimeToString(Lane.RaceTime) AS RaceTime,'
      '         Heat.HeatNum,'
      '         Lane.LaneNum,'
      '         SubString(EventStatus.Caption,1,8) AS EventStatus'
      ''
      'FROM     Event'
      '         INNER JOIN'
      '         Heat'
      '         ON Event.EventID = Heat.EventID'
      '         INNER JOIN'
      '         Lane'
      '         ON Heat.HeatID = Lane.HeatID'
      '         LEFT OUTER JOIN'
      '         Nominee'
      '         ON Lane.NomineeId = Nominee.NomineeID'
      '         LEFT OUTER JOIN'
      '         Member'
      '         ON Nominee.MemberID = Member.MemberID'
      '         INNER JOIN'
      '         Distance'
      '         ON Event.DistanceID = Distance.DistanceID'
      '         INNER JOIN'
      '         Stroke'
      '         ON Event.StrokeID = Stroke.StrokeID'
      '         INNER JOIN'
      '         EventStatus'
      '         ON Event.EventStatusID = EventStatus.EventStatusID'
      ''
      'WHERE    Event.EventID = @EventID'
      'ORDER BY HeatNum, LaneNum;')
    Left = 72
    Top = 240
    ParamData = <
      item
        Name = 'EVENTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 20
      end>
  end
  object dsEvMisc: TfrxDBDataset
    UserName = 'EventMisc'
    CloseDataSource = False
    FieldAliases.Strings = (
      'EventID=EventID'
      'EventNum=EventNum'
      'Distance=Distance'
      'Stroke=Stroke'
      'EventDescription=EventDescription'
      'EntrantCount=EntrantCount'
      'NomineeCount=NomineeCount'
      'HeatCount=HeatCount'
      'SessionID=SessionID'
      'StartTime=StartTime'
      'MemberID=MemberID'
      'MemberName=MemberName'
      'HeatID=HeatID'
      'RaceTime=RaceTime'
      'HeatNum=HeatNum'
      'LaneNum=LaneNum'
      'EventStatus=EventStatus')
    DataSet = qryEvMisc
    BCDToCurrency = False
    Left = 168
    Top = 240
  end
  object rptTemplate_Base: TfrxReport
    Version = '6.6.11'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 46261.499890659700000000
    ReportOptions.Name = 'Template_Base'
    ReportOptions.LastChange = 46262.500416793980000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'var'
      '  EnablePrintClubLogo: Boolean;   '
      ''
      'procedure Page1OnBeforePrint(Sender: TfrxComponent);'
      'begin'
      
        '  // Set default coordinates (using fr1cm to convert 1.75 cm to ' +
        'pixels)'
      '  FClubName.Left := 0;'
      '  FClubName.Top := 0;'
      
        '  FNickName.Left := 0;                                          ' +
        '                      '
      '  '
      
        '  // Reference the script variable directly as a boolean (no bra' +
        'ckets)'
      '  if (EnablePrintClubLogo = true) then'
      '  begin              '
      '    // Check if the database BLOB field is Null [6]'
      '    if <SwimClub."LogoImg"> = Null then'
      '    begin                '
      '      FLogo.Visible := False;'
      '    end                '
      '    else'
      '    begin              '
      '      FLogo.Visible := True;'
      '      FClubName.Left := 1.52 * fr1cm;'
      
        '      FNickName.Left := 1.52 * fr1cm;                           ' +
        '                                     '
      '    end;'
      '  end'
      '  else'
      '  begin'
      '    FLogo.Visible := false;      '
      '  end;  '
      'end;'
      ''
      'begin'
      
        '  EnablePrintClubLogo := true; // Sett to True to display the cl' +
        'ub logo                                 '
      'end.')
    Left = 440
    Top = 384
    Datasets = <
      item
        DataSet = dsfrxSession
        DataSetName = 'Session'
      end
      item
        DataSet = dsfrxSwimClub
        DataSetName = 'SwimClub'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 215.900000000000000000
      PaperHeight = 279.400000000000000000
      PaperSize = 1
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      Frame.Typ = []
      MirrorMode = []
      OnBeforePrint = 'Page1OnBeforePrint'
      object scmHeader: TfrxPageHeader
        FillType = ftBrush
        Frame.Typ = []
        Height = 57.343846670000000000
        Top = 18.897650000000000000
        Width = 740.409927000000000000
        object FClubName: TfrxMemoView
          AllowVectorExport = True
          Left = 57.500000010000000000
          Top = 1.000000000000000000
          Width = 497.130180000000000000
          Height = 30.236240000000000000
          AutoWidth = True
          DataSetName = 'FDQuery1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[SwimClub."ClubName"]')
          ParentFont = False
        end
        object FNickName: TfrxMemoView
          AllowVectorExport = True
          Left = 57.000000010000000000
          Top = 23.677180000000000000
          Width = 335.130180000000000000
          Height = 18.897650000000000000
          DataSetName = 'FDQuery1'
          Frame.Typ = []
          Memo.UTF8W = (
            '[SwimClub."NickName"]')
        end
        object FSessionDT: TfrxMemoView
          Align = baRight
          AllowVectorExport = True
          Left = 434.267997000000000000
          Top = 22.677180000000000000
          Width = 306.141930000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              'Session Date: [<Session."SessionDT"> #dddd dd mmm yyyy HH:MM AM/' +
              'PM]')
          ParentFont = False
        end
        object FLogo: TfrxPictureView
          Description = 'SwimClub Logo'
          Align = baLeft
          AllowVectorExport = True
          Top = 0.602350000000000000
          Width = 53.291338580000000000
          Height = 53.338582680000000000
          Center = True
          DataField = 'LogoImg'
          DataSet = dsfrxSwimClub
          DataSetName = 'SwimClub'
          Frame.Typ = []
          HightQuality = True
          Transparent = True
          TransparentColor = clWhite
        end
      end
      object scmFooter: TfrxPageFooter
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 136.063080000000000000
        Width = 740.409927000000000000
        object TotalPages: TfrxMemoView
          AllowVectorExport = True
          Left = 268.456865000000000000
          Top = 0.603586670000000000
          Width = 185.196970000000000000
          Height = 18.897650000000000000
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Page [Page#] of [TotalPages#]')
          ParentFont = False
          Formats = <
            item
            end
            item
            end>
        end
        object Date: TfrxMemoView
          AllowVectorExport = True
          Left = 2.000000000000000000
          Top = 0.603586670000000000
          Width = 264.567100000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Printed On: [Date]')
        end
      end
    end
  end
  object qryEvDetailedEx: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    IndexesActive = False
    IndexFieldNames = 'EventID'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvFmtDisplayDateTime, fvFmtDisplayTime]
    FormatOptions.FmtDisplayDateTime = 'dd mmm YYYY'
    FormatOptions.FmtDisplayTime = 'nn:ss.zzz'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'DECLARE @EventID AS INT;'
      ''
      'SET @EventID = :EVENTID;'
      ''
      'SELECT   Event.EventID,'
      '         Event.EventNum,'
      '         SubString(Distance.CalcCaption,1, 8) AS Distance,'
      '         SubString(Stroke.Caption,1,16) AS Stroke,'
      '         SubString(Event.Caption, 1, 64) AS EventDescription,'
      '         dbo.EntrantCount(Event.EventID) AS EntrantCount,'
      '         dbo.NomineeCount(Event.EventID) AS NomineeCount,'
      '         dbo.HeatCount(Event.EventID) AS HeatCount,'
      '         Event.SessionID,'
      '         Event.StartTime,'
      '         Member.MemberID,'
      
        '         SUBSTRING(dbo.GetMemberFullName(Member.memberID), 1, 32' +
        ') AS MemberName,'
      '         Lane.HeatID,'
      '         dbo.SwimTimeToString(Lane.RaceTime) AS RaceTime,'
      '         Heat.HeatNum,'
      '         Lane.LaneNum,'
      '         SubString(EventStatus.Caption,1,8) AS EventStatus'
      ''
      'FROM     Event'
      '         INNER JOIN'
      '         Heat'
      '         ON Event.EventID = Heat.EventID'
      '         INNER JOIN'
      '         Lane'
      '         ON Heat.HeatID = Lane.HeatID'
      '         LEFT OUTER JOIN'
      '         Nominee'
      '         ON Lane.NomineeId = Nominee.NomineeID'
      '         LEFT OUTER JOIN'
      '         Member'
      '         ON Nominee.MemberID = Member.MemberID'
      '         INNER JOIN'
      '         Distance'
      '         ON Event.DistanceID = Distance.DistanceID'
      '         INNER JOIN'
      '         Stroke'
      '         ON Event.StrokeID = Stroke.StrokeID'
      '         INNER JOIN'
      '         EventStatus'
      '         ON Event.EventStatusID = EventStatus.EventStatusID'
      ''
      'WHERE    Event.EventID = @EventID'
      'ORDER BY HeatNum, LaneNum;')
    Left = 72
    Top = 168
    ParamData = <
      item
        Name = 'EVENTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 20
      end>
  end
  object dsEvDetailedEx: TfrxDBDataset
    UserName = 'EventDetailedEx'
    CloseDataSource = False
    FieldAliases.Strings = (
      'EventID=EventID'
      'EventNum=EventNum'
      'Distance=Distance'
      'Stroke=Stroke'
      'EventDescription=EventDescription'
      'EntrantCount=EntrantCount'
      'NomineeCount=NomineeCount'
      'HeatCount=HeatCount'
      'SessionID=SessionID'
      'StartTime=StartTime'
      'MemberID=MemberID'
      'MemberName=MemberName'
      'HeatID=HeatID'
      'RaceTime=RaceTime'
      'HeatNum=HeatNum'
      'LaneNum=LaneNum'
      'EventStatus=EventStatus')
    DataSet = qryEvDetailed
    BCDToCurrency = False
    Left = 168
    Top = 168
  end
  object frxReportWIP: TfrxReport
    Version = '6.6.11'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 46261.499890659700000000
    ReportOptions.Name = 'Template_Base'
    ReportOptions.LastChange = 46262.500416794000000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'var'
      '  EnablePrintClubLogo: Boolean;'
      ''
      'procedure Page1OnBeforePrint(Sender: TfrxComponent);'
      'begin'
      
        '  // Set default coordinates (using fr1cm to convert 1.75 cm to ' +
        'pixels)'
      '  FClubName.Left := 0;'
      '  FClubName.Top := 0;'
      '  FNickName.Left := 0;'
      ''
      
        '  // Reference the script variable directly as a boolean (no bra' +
        'ckets)'
      '  if (EnablePrintClubLogo = true) then'
      '  begin'
      '    // Check if the database BLOB field is Null [6]'
      '    if <SwimClub."LogoImg"> = Null then'
      '    begin'
      '      FLogo.Visible := False;'
      '    end'
      '    else'
      '    begin'
      '      FLogo.Visible := True;'
      '      FClubName.Left := 1.52 * fr1cm;'
      '      FNickName.Left := 1.52 * fr1cm;'
      '    end;'
      '  end'
      '  else'
      '  begin'
      '    FLogo.Visible := false;'
      '  end;'
      'end;'
      ''
      'begin'
      
        '  EnablePrintClubLogo := true; // Sett to True to display the cl' +
        'ub logo'
      'end.')
    Left = 640
    Top = 40
    Datasets = <
      item
        DataSet = dsfrxSession
        DataSetName = 'Session'
      end
      item
        DataSet = dsfrxSwimClub
        DataSetName = 'SwimClub'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 215.900000000000000000
      PaperHeight = 279.400000000000000000
      PaperSize = 1
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      Frame.Typ = []
      MirrorMode = []
      OnBeforePrint = 'Page1OnBeforePrint'
      object scmHeader: TfrxPageHeader
        FillType = ftBrush
        Frame.Typ = []
        Height = 57.343846670000000000
        Top = 18.897650000000000000
        Width = 740.409927000000000000
        object FClubName: TfrxMemoView
          AllowVectorExport = True
          Left = 57.500000010000000000
          Top = 1.000000000000000000
          Width = 497.130180000000000000
          Height = 30.236240000000000000
          AutoWidth = True
          DataSetName = 'FDQuery1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[SwimClub."ClubName"]')
          ParentFont = False
        end
        object FNickName: TfrxMemoView
          AllowVectorExport = True
          Left = 57.000000010000000000
          Top = 23.677180000000000000
          Width = 335.130180000000000000
          Height = 18.897650000000000000
          DataSetName = 'FDQuery1'
          Frame.Typ = []
          Memo.UTF8W = (
            '[SwimClub."NickName"]')
        end
        object FSessionDT: TfrxMemoView
          Align = baRight
          AllowVectorExport = True
          Left = 434.267997000000000000
          Top = 22.677180000000000000
          Width = 306.141930000000000000
          Height = 18.897650000000000000
          DataSet = dsEvSummary
          DataSetName = 'EventSummary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              'Session Date: [<Session."SessionDT"> #dddd dd mmm yyyy HH:MM AM/' +
              'PM]')
          ParentFont = False
        end
        object FLogo: TfrxPictureView
          Description = 'SwimClub Logo'
          Align = baLeft
          AllowVectorExport = True
          Top = 0.602350000000000000
          Width = 53.291338580000000000
          Height = 53.338582680000000000
          Center = True
          DataField = 'LogoImg'
          DataSet = dsfrxSwimClub
          DataSetName = 'SwimClub'
          Frame.Typ = []
          HightQuality = True
          Transparent = True
          TransparentColor = clWhite
        end
      end
      object scmFooter: TfrxPageFooter
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 136.063080000000000000
        Width = 740.409927000000000000
        object TotalPages: TfrxMemoView
          AllowVectorExport = True
          Left = 268.456865000000000000
          Top = 0.603586670000000000
          Width = 185.196970000000000000
          Height = 18.897650000000000000
          AutoWidth = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Page [Page#] of [TotalPages#]')
          ParentFont = False
          Formats = <
            item
            end
            item
            end>
        end
        object Date: TfrxMemoView
          AllowVectorExport = True
          Left = 2.000000000000000000
          Top = 0.603586670000000000
          Width = 264.567100000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Printed On: [Date]')
        end
      end
    end
  end
end
