object EventReportA: TEventReportA
  OnCreate = DataModuleCreate
  Height = 366
  Width = 485
  object frxrptEventSummary: TfrxReport
    Version = '6.6.11'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.AllowEdit = False
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 9
    ReportOptions.Author = 'Ben Ambrose'
    ReportOptions.CreateDate = 43428.811813125000000000
    ReportOptions.Description.Strings = (
      'Event Summary. '
      'Basic report, outlining event number, distancce and stroke.')
    ReportOptions.Name = 'Sys-Event-Summary'
    ReportOptions.LastChange = 46257.511005370370000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'var'
      '  EnablePrintClubLogo: Boolean;   '
      ''
      'procedure FLogoOnBeforePrint(Sender: TfrxComponent);'
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
      '      FClubName.Left := 1.75 * fr1cm;'
      
        '      FNickName.Left := 1.75 * fr1cm;                           ' +
        '                                     '
      '    end;'
      '  end'
      '  else'
      '  begin'
      '    FLogo.Visible := false;      '
      '  end;'
      'end;'
      ''
      'begin'
      
        '  EnablePrintClubLogo := true; // Sett to True to display the cl' +
        'ub logo                                 '
      'end.                                                ')
    Left = 288
    Top = 16
    Datasets = <
      item
        DataSet = frxdsReport
        DataSetName = 'Event'
      end
      item
        DataSet = frxdsSession
        DataSetName = 'Session'
      end
      item
        DataSet = frxdsSwimClub
        DataSetName = 'SwimClub'
      end>
    Variables = <
      item
        Name = ' SCM'
        Value = Null
      end
      item
        Name = 'EnablePrintClubLogo'
        Value = 'false '
      end>
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
      object EvPageHeader: TfrxPageHeader
        FillType = ftBrush
        Frame.Typ = []
        Height = 56.692950000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object FNickName: TfrxMemoView
          AllowVectorExport = True
          Left = 66.000000000000000000
          Top = 22.677180000000000000
          Width = 335.130180000000000000
          Height = 18.897650000000000000
          DataSetName = 'FDQuery1'
          Frame.Typ = []
          Memo.UTF8W = (
            '[SwimClub."NickName"]')
        end
        object FSessionStart: TfrxMemoView
          AllowVectorExport = True
          Left = 408.189240000000000000
          Top = 22.010513330000000000
          Width = 306.141930000000000000
          Height = 18.897650000000000000
          DataSet = frxdsReport
          DataSetName = 'Event'
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
          AllowVectorExport = True
          Left = 4.000000000000000000
          Top = 0.602350000000000000
          Width = 53.291338580000000000
          Height = 53.338582680000000000
          OnBeforePrint = 'FLogoOnBeforePrint'
          Center = True
          DataField = 'LogoImg'
          DataSet = frxdsSwimClub
          DataSetName = 'SwimClub'
          Frame.Typ = []
          HightQuality = True
          Transparent = True
          TransparentColor = clWhite
        end
        object FClubName: TfrxMemoView
          AllowVectorExport = True
          Left = 66.500000000000000000
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
      end
      object EvGroupHeader: TfrxGroupHeader
        FillType = ftBrush
        Fill.BackColor = 15461355
        Frame.Typ = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Height = 37.795300000000000000
        ParentFont = False
        Top = 136.063080000000000000
        Width = 718.110700000000000000
        Condition = 'Event."SessionID"'
        object MemoEv: TfrxMemoView
          AllowVectorExport = True
          Left = 7.779530000000000000
          Top = 7.559060000000000000
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
          Left = 52.477736670000000000
          Top = 7.559060000000000000
          Width = 56.972480000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Distance')
        end
        object MemoStroke: TfrxMemoView
          AllowVectorExport = True
          Left = 113.122140000000000000
          Top = 7.559060000000000000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Stroke')
        end
        object MemoNominees: TfrxMemoView
          AllowVectorExport = True
          Left = 517.403216670000000000
          Top = 8.059060000000000000
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
          Left = 574.934756670000000000
          Top = 8.059060000000000000
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
          Left = 620.799630000000000000
          Top = 8.059060000000000000
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
          Left = 229.410946670000000000
          Top = 7.559060000000000000
          Width = 283.212740000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Event Description')
        end
        object LineGroupHeader: TfrxLineView
          AllowVectorExport = True
          Left = 2.500000000000000000
          Top = 32.736240000000000000
          Width = 714.551640000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
          Frame.Width = 2.000000000000000000
        end
        object MemoStatus: TfrxMemoView
          AllowVectorExport = True
          Left = 657.000000000000000000
          Top = 7.936920000000000000
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
      end
      object EvMasterData: TfrxMasterData
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 196.535560000000000000
        Width = 718.110700000000000000
        DataSet = frxdsReport
        DataSetName = 'Event'
        RowCount = 0
        object frxEventNum: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Width = 37.246753330000000000
          Height = 18.897650000000000000
          DataSet = frxdsReport
          DataSetName = 'Event'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[<Event."EventNum"> #n%3g]')
          ParentFont = False
        end
        object frxDistance: TfrxMemoView
          AllowVectorExport = True
          Left = 44.477736670000000000
          Width = 58.972480000000000000
          Height = 18.897650000000000000
          DataSet = frxdsReport
          DataSetName = 'Event'
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
        object frxStroke: TfrxMemoView
          AllowVectorExport = True
          Left = 111.788806670000000000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          DataSet = frxdsReport
          DataSetName = 'Event'
          Frame.Typ = []
          Memo.UTF8W = (
            '[Event."Stroke"]')
        end
        object frxNomineeCount: TfrxMemoView
          AllowVectorExport = True
          Left = 517.403216670000000000
          Top = 0.500000000000000000
          Width = 55.472426300000000000
          Height = 18.897650000000000000
          DataSet = frxdsReport
          DataSetName = 'Event'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            
              '[IIF(<Event."NomineeCount"> = 0 ,0,<Event."NomineeCount">) #n%3.' +
              '0f]')
          ParentFont = False
        end
        object frxEntrantCount: TfrxMemoView
          AllowVectorExport = True
          Left = 574.934756670000000000
          Width = 43.472426300000000000
          Height = 18.897650000000000000
          DataSet = frxdsReport
          DataSetName = 'Event'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            
              '[IIF(<Event."EntrantCount"> = 0 ,0,<Event."EntrantCount">) #n%3.' +
              '0f]')
          ParentFont = False
        end
        object frxHeatCount: TfrxMemoView
          AllowVectorExport = True
          Left = 619.966296670000000000
          Top = 0.500000000000000000
          Width = 34.472426300000000000
          Height = 18.897650000000000000
          DataSet = frxdsReport
          DataSetName = 'Event'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[Event."HeatCount" #n%3.0f]')
          ParentFont = False
        end
        object frxEvent: TfrxMemoView
          AllowVectorExport = True
          Left = 231.910946670000000000
          Top = 0.500000000000000000
          Width = 282.212740000000000000
          Height = 18.897650000000000000
          DataSet = frxdsReport
          DataSetName = 'Event'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[Event."Event_Description"]')
          ParentFont = False
        end
        object frxStatus: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 657.000000000000000000
          Width = 45.252010000000000000
          Height = 18.897650000000000000
          DataSet = frxdsReport
          DataSetName = 'Event'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[Event."Status"]')
          ParentFont = False
        end
      end
      object EvPageFooter: TfrxPageFooter
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 279.685220000000000000
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
    end
  end
  object qryReport: TFDQuery
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
      
        '         SubString(Event.Caption, 1, 64) AS Event_Description, -' +
        '- 05.06.2023'
      '         Event.StartTime,'
      '         SubString(EventStatus.Caption,1,8) AS Status'
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
    Left = 352
    Top = 280
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
    Left = 352
    Top = 224
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
    Left = 352
    Top = 168
  end
  object frxdsReport: TfrxDBDataset
    UserName = 'Event'
    CloseDataSource = False
    FieldAliases.Strings = (
      'EventID=EventID'
      'EventNum=EventNum'
      'Distance=Distance'
      'Stroke=Stroke'
      'EntrantCount=EntrantCount'
      'NomineeCount=NomineeCount'
      'HeatCount=HeatCount'
      'NickName=NickName'
      'SwimClub=SwimClub'
      'SessionDT=SessionDT'
      'SessionID=SessionID'
      'Event_Description=Event_Description'
      'StartTime=StartTime'
      'Status=Status')
    DataSet = qryReport
    BCDToCurrency = False
    Left = 160
    Top = 16
  end
  object qrySwimClub: TFDQuery
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
      '      ,[SwimClubType].Caption AS SwimClub_Type '
      '--      ,[SwimClub].[PoolTypeID]'
      '      ,[PoolType].Caption AS Pool_Type '
      '  FROM [SwimClubMeet2].[dbo].[SwimClub]'
      '  LEFT JOIN [SwimClubType] '
      
        '      ON [SwimClub].[SwimClubTypeID] = [SwimClubType].[SwimClubT' +
        'ypeID]'
      '  LEFT JOIN [PoolType] '
      '      ON [SwimClub].[PoolTypeID] = [PoolType].[PoolTypeID]'
      '  WHERE SwimCLubID = @SwimClubID;')
    Left = 72
    Top = 80
    ParamData = <
      item
        Name = 'SWIMCLUBID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end>
  end
  object frxdsSwimClub: TfrxDBDataset
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
      'HeatAlgorithm=HeatAlgorithm'
      'EnableSimpleDQ=EnableSimpleDQ'
      'NumOfLanes=NumOfLanes'
      'LenOfPool=LenOfPool'
      'DefTeamSize=DefTeamSize'
      'CreatedOn=CreatedOn'
      'LogoImg=LogoImg'
      'IsArchived=IsArchived'
      'IsClubGroup=IsClubGroup'
      'SwimClubTypeID=SwimClubTypeID'
      'PoolTypeID=PoolTypeID')
    DataSet = qrySwimClub
    BCDToCurrency = False
    Left = 160
    Top = 80
  end
  object qrySession: TFDQuery
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
      '      ,[Session].[Caption] AS Session_Descrption'
      '      ,[SessionDT]'
      '      ,[Session].[CreatedOn]'
      '      ,[Session].[ModifiedOn]'
      '      ,[NomineeCount]'
      '      ,[EntrantCount]'
      '      ,[SwimClubID]'
      '      --,[Session].[SessionStatusID]'
      '      ,[SessionStatus].Caption AS Session_Status'
      '      --,[Session].[MeetID]'
      '      ,[Meet].Caption AS Meet_Description'
      '  FROM [SwimClubMeet2].[dbo].[Session]'
      '  LEFT JOIN [SessionStatus] ON '
      
        '    [Session].[SessionStatusID] =[SessionStatus].[SessionStatusI' +
        'D]'
      '  LEFT JOIN [Meet] ON '
      '    [Session].[MeetID] = [Meet].[MeetID]'
      'WHERE [Session].SessionID = @SessionID;')
    Left = 72
    Top = 144
    ParamData = <
      item
        Name = 'SESSIONID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object frxdsSession: TfrxDBDataset
    UserName = 'Session'
    CloseDataSource = False
    FieldAliases.Strings = (
      'SessionID=SessionID'
      'Session_Descrption=Session_Descrption'
      'SessionDT=SessionDT'
      'CreatedOn=CreatedOn'
      'ModifiedOn=ModifiedOn'
      'NomineeCount=NomineeCount'
      'EntrantCount=EntrantCount'
      'SwimClubID=SwimClubID'
      'Session_Status=Session_Status'
      'Meet_Description=Meet_Description')
    DataSet = qrySession
    BCDToCurrency = False
    Left = 160
    Top = 144
  end
end
