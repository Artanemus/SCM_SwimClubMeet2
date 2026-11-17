object RPT: TRPT
  OnCreate = DataModuleCreate
  Height = 608
  Width = 974
  object rptEvSummary: TfrxReport
    Version = '6.6.11'
    ParentReport = '..\RPT_TEMPLATES\Base_v1.fr3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.AllowEdit = False
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 46343.604483344910000000
    ReportOptions.LastChange = 46343.604483344910000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 288
    Top = 16
    Datasets = <>
    Variables = <>
    Style = <>
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
    Left = 632
    Top = 240
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
    Left = 632
    Top = 184
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
    Left = 632
    Top = 128
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
  object rptEvDetailed: TfrxReport
    Version = '6.6.11'
    ParentReport = '..\RPT_TEMPLATES\Base_v1.fr3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.AllowEdit = False
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 46343.604576331020000000
    ReportOptions.LastChange = 46343.604576331020000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 288
    Top = 88
    Datasets = <>
    Variables = <>
    Style = <>
  end
  object rptEventMisc: TfrxReport
    Version = '6.6.11'
    ParentReport = '..\RPT_TEMPLATES\Base_v1.fr3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.AllowEdit = False
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 46343.604736087960000000
    ReportOptions.LastChange = 46343.604736087960000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 288
    Top = 240
    Datasets = <>
    Variables = <>
    Style = <>
  end
  object rptEvDetailedEx: TfrxReport
    Version = '6.6.11'
    ParentReport = '..\RPT_TEMPLATES\Base_v1.fr3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.AllowEdit = False
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 46343.604664131940000000
    ReportOptions.LastChange = 46343.604664131940000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 288
    Top = 168
    Datasets = <>
    Variables = <>
    Style = <>
  end
  object qryEvDetailed: TFDQuery
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
    UserName = 'Event'
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
      '                          '
      'SELECT   [Event].EventID,'
      '         [Event].EventNum,'
      '         SubString([Event].Caption, 1, 64) AS EventDescription,'
      '         [Event].StartTime,'
      '         dbo.NomineeCount([Event].EventID) AS NomineeCount,'
      '         dbo.EntrantCount([Event].EventID) AS EntrantCount,'
      '         [Event].SessionID,'
      '         '
      '         SubString(Stroke.Caption,1,16) AS Stroke,'
      '         -- SubString(Distance.CalcCaption,1, 8) AS Distance,'
      '         -- recalculate ...'
      
        '         SubString(dbo.DistanceToString([Event].DistanceID, Swim' +
        'Club.PoolTypeID),1,8) AS Distance,'
      '         SubString(EventStatus.Caption,1,8) AS EventStatus,'
      '         '
      '         -- Params to list Heat , lane, swimmer, etc... '
      '         dbo.HeatCount([Event].EventID) AS HeatCount,'
      '         [Member].MemberID,'
      
        '         SUBSTRING(dbo.GetMemberFullName([Member].memberID), 1, ' +
        '32) AS MemberName,'
      '         Lane.HeatID,'
      '         dbo.SwimTimeToString(Lane.RaceTime) AS RaceTime,'
      '         Heat.HeatNum,'
      '         Lane.LaneNum,'
      ''
      '         -- MISC'
      '         SubString(Round.Caption,1,16) AS RoundCaption,'
      '         SubString(Round.CaptionShort,1,16) AS RoundABREV,'
      '         SubString([Gender].Caption,1,16) AS EventGender,'
      '         SubString([Gender].ABREV,1,8) AS EventGenderABREV,'
      '         SubString(EventCategory.Caption,1,24) AS Category,'
      '         SubString(EventCategory.ABREV,1,8) AS CategoryBREV,'
      '         SubString(ParalympicType.Caption,1,24) AS Paralympic,'
      '         SubString(EventType.Caption,1,12) AS EventType,'
      '         SubString(EventType.ABREV,1,8) AS EventTypeABREV'
      '         '
      'FROM     [Event]'
      '         INNER JOIN'
      '         Heat'
      '         ON [Event].EventID = Heat.EventID'
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
      '         ON [Event].DistanceID = Distance.DistanceID'
      '         INNER JOIN'
      '         Stroke'
      '         ON [Event].StrokeID = Stroke.StrokeID'
      '         INNER JOIN'
      '         EventStatus'
      '         ON [Event].EventStatusID = EventStatus.EventStatusID'
      '         INNER JOIN Session'
      '         ON [Event].SessionID = Session.SessionID'
      '         INNER JOIN SwimClub'
      '         ON [Session].SwimClubID = SwimClub.SwimClubID'
      '         LEFT OUTER JOIN '
      '         [Round] '
      '         ON [Event].RoundID = Round.RoundID'
      '         LEFT OUTER JOIN '
      '         Gender '
      '         ON [Event].GenderID = Gender.GenderID'
      '         LEFT OUTER JOIN'
      '         EventCategory'
      
        '         ON [Event].EventCategoryID = EventCategory.EventCategor' +
        'yID'
      '         LEFT OUTER JOIN'
      '         ParalympicType'
      
        '         ON [Event].ParalympicTypeID = ParalympicType.Paralympic' +
        'TypeID'
      '         LEFT OUTER JOIN'
      '         EventType'
      '         ON [Event].EventTypeID = EventType.EventTypeID'
      ''
      '         '
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
        Value = 100
      end>
  end
  object dsEvMisc: TfrxDBDataset
    UserName = 'EventMisc'
    CloseDataSource = False
    FieldAliases.Strings = (
      'EventID=EventID'
      'EventNum=EventNum'
      'EventDescription=EventDescription'
      'StartTime=StartTime'
      'NomineeCount=NomineeCount'
      'EntrantCount=EntrantCount'
      'SessionID=SessionID'
      'Stroke=Stroke'
      'Distance=Distance'
      'EventStatus=EventStatus'
      'HeatCount=HeatCount'
      'MemberID=MemberID'
      'MemberName=MemberName'
      'HeatID=HeatID'
      'RaceTime=RaceTime'
      'HeatNum=HeatNum'
      'LaneNum=LaneNum'
      'RoundCaption=RoundCaption'
      'RoundABREV=RoundABREV'
      'EventGender=EventGender'
      'EventGenderABREV=EventGenderABREV'
      'Category=Category'
      'CategoryBREV=CategoryBREV'
      'Paralympic=Paralympic'
      'EventType=EventType'
      'EventTypeABREV=EventTypeABREV')
    DataSet = qryEvMisc
    BCDToCurrency = False
    Left = 168
    Top = 240
  end
  object rptBase_v1: TfrxReport
    Version = '6.6.11'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.Author = 'SwimClubMeet2'
    ReportOptions.CreateDate = 46261.499890659700000000
    ReportOptions.Name = 'Base_v1'
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
    Left = 624
    Top = 16
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
    Active = True
    Indexes = <
      item
        Active = True
        Name = 'indxEvent'
        Fields = 'LaneNum;HeatNum;EventID'
      end>
    IndexesActive = False
    IndexFieldNames = 'EventID;HeatID;LaneID'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvFmtDisplayDateTime, fvFmtDisplayTime]
    FormatOptions.FmtDisplayDateTime = 'dd mmm YYYY'
    FormatOptions.FmtDisplayTime = 'nn:ss.zzz'
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Event'
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
      '         Lane.LaneID,'
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
      'WHERE    Event.SessionID = @SessionID'
      'ORDER BY EventID, HeatNum, LaneNum;')
    Left = 72
    Top = 168
    ParamData = <
      item
        Name = 'SESSIONID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 100
      end>
  end
  object dsEvDetailedEx: TfrxDBDataset
    UserName = 'Event'
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
    DataSet = qryEvDetailedEx
    BCDToCurrency = False
    Left = 168
    Top = 168
  end
  object frxReportWIP: TfrxReport
    Version = '6.6.11'
    ParentReport = '..\RPT_TEMPLATES\Base_v1.fr3'
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
    Left = 808
    Top = 16
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
  object rptReport: TfrxReport
    Version = '6.6.11'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 46276.460923784730000000
    ReportOptions.LastChange = 46276.460923784730000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 704
    Top = 16
    Datasets = <>
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
    end
  end
end
