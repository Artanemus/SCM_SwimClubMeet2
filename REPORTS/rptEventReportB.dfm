object EventReportB: TEventReportB
  OnCreate = DataModuleCreate
  Height = 375
  Width = 352
  object frxrptEventDetailed: TfrxReport
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
    ReportOptions.LastChange = 46252.472540069400000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 256
    Top = 16
    Datasets = <
      item
        DataSet = frxdsReport
        DataSetName = 'Event'
      end
      item
        DataSet = frxdsSwimClub
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
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        Frame.Typ = []
        Height = 68.031540000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object FDQuery1cSwimClub: TfrxMemoView
          AllowVectorExport = True
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
            '[frxDS."SwimClub"]')
          ParentFont = False
        end
        object FDQuery1NickName: TfrxMemoView
          AllowVectorExport = True
          Top = 22.677180000000000000
          Width = 400.630180000000000000
          Height = 18.897650000000000000
          DataSetName = 'FDQuery1'
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDS."NickName"]')
        end
        object frxDSSessionStart: TfrxMemoView
          AllowVectorExport = True
          Left = 404.409710000000000000
          Top = 22.677180000000000000
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
            
              'Session Date: [<frxDS."SessionDT"> #dddd dd mmm yyyy HH:MM AM/PM' +
              ']')
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
        Condition = 'frxDS."SessionID"'
        object Memo1: TfrxMemoView
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
        object Memo3: TfrxMemoView
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
        object Memo2: TfrxMemoView
          AllowVectorExport = True
          Left = 133.842610000000000000
          Top = 8.456710000000000000
          Width = 102.047310000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Stroke')
        end
        object Memo4: TfrxMemoView
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
        object Memo5: TfrxMemoView
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
        object Memo7: TfrxMemoView
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
        object Memo15: TfrxMemoView
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
        DataSet = frxdsReport
        DataSetName = 'Event'
        RowCount = 0
        object Memo9: TfrxMemoView
          AllowVectorExport = True
          Top = 2.000000000000000000
          Width = 52.913420000000000000
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
            '[<frxDS."EventNum"> #n%3.0g]')
          ParentFont = False
        end
        object Memo10: TfrxMemoView
          AllowVectorExport = True
          Left = 68.031540000000000000
          Top = 2.000000000000000000
          Width = 60.472480000000000000
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
            '[frxDS."Distance"]')
          ParentFont = False
        end
        object Memo11: TfrxMemoView
          AllowVectorExport = True
          Left = 133.842610000000000000
          Top = 2.000000000000000000
          Width = 102.047310000000000000
          Height = 18.897650000000000000
          DataSet = frxdsReport
          DataSetName = 'Event'
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDS."Stroke"]')
        end
        object Memo12: TfrxMemoView
          AllowVectorExport = True
          Left = 506.457020000000000000
          Top = 2.000000000000000000
          Width = 60.472426300000000000
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
            
              '[IIF(<frxDS."NomineeCount"> = 0 ,0,<frxDS."NomineeCount">) #n%3.' +
              '0g]')
          ParentFont = False
        end
        object Memo13: TfrxMemoView
          AllowVectorExport = True
          Left = 574.488560000000000000
          Top = 2.000000000000000000
          Width = 60.472426300000000000
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
            
              '[IIF(<frxDS."EntrantCount"> = 0 ,0,<frxDS."EntrantCount">) #n%3.' +
              '0g]')
          ParentFont = False
        end
        object Memo14: TfrxMemoView
          AllowVectorExport = True
          Left = 642.520100000000000000
          Top = 2.000000000000000000
          Width = 60.472426300000000000
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
            '[frxDS."HeatCount" #n%3.0g]')
          ParentFont = False
        end
        object frxDScEvent: TfrxMemoView
          AllowVectorExport = True
          Left = 238.110390000000000000
          Top = 2.000000000000000000
          Width = 245.669450000000000000
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
            '[frxDS."EventDescription"]')
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
        DataSet = frxdsReport
        DataSetName = 'Event'
        RowCount = 0
        object frxDSNominee: TfrxMemoView
          AllowVectorExport = True
          Left = 29.472480000000000000
          Width = 132.283550000000000000
          Height = 18.897650000000000000
          DataSet = frxdsReport
          DataSetName = 'Event'
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDS."MemberName"]')
        end
        object frxDSRaceTime: TfrxMemoView
          AllowVectorExport = True
          Left = 167.299320000000000000
          Width = 68.031540000000000000
          Height = 18.897650000000000000
          DataSet = frxdsReport
          DataSetName = 'Event'
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDS."RaceTime"]')
        end
        object frxDSLane: TfrxMemoView
          AllowVectorExport = True
          Left = 2.779530000000000000
          Width = 22.677180000000000000
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
            '[frxDS."LaneNum" #n%2.0f]')
          ParentFont = False
        end
      end
      object GroupHeader2: TfrxGroupHeader
        FillType = ftBrush
        Frame.Typ = []
        Height = 64.252010000000000000
        Top = 272.126160000000000000
        Width = 718.110700000000000000
        Condition = 'frxDS."HeatNum"'
        object Shape1: TfrxShapeView
          AllowVectorExport = True
          Top = 11.338590000000000000
          Width = 718.110700000000000000
          Height = 30.236240000000000000
          Fill.BackColor = cl3DLight
          Frame.Color = clNone
          Frame.Typ = []
        end
        object Memo6: TfrxMemoView
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
            'HEAT : [frxDS."HeatNum"]')
          ParentFont = False
        end
        object Line1: TfrxLineView
          AllowVectorExport = True
          Left = 1.779530000000000000
          Top = 37.795300000000000000
          Width = 714.331170000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
          Frame.Width = 2.000000000000000000
        end
        object Memo8: TfrxMemoView
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
        object Memo16: TfrxMemoView
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
        object Memo17: TfrxMemoView
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
        object Memo18: TfrxMemoView
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
        object Memo19: TfrxMemoView
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
        object Memo20: TfrxMemoView
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
        object Memo21: TfrxMemoView
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
        object Memo22: TfrxMemoView
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
        object Memo23: TfrxMemoView
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
        object Line2: TfrxLineView
          AllowVectorExport = True
          Left = 482.000310000000000000
          Top = 37.015770000000000000
          Height = 101.811070000000000000
          Color = clBlack
          Frame.Typ = [ftLeft]
          Frame.Width = 2.000000000000000000
        end
        object Line3: TfrxLineView
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
  object qryReport: TFDQuery
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
      '         dbo.EntrantCount(Event.EventID) AS EntrantCount,'
      '         dbo.NomineeCount(Event.EventID) AS NomineeCount,'
      '         dbo.HeatCount(Event.EventID) AS HeatCount,'
      
        '         SUBSTRING(dbo.GetMemberFullName(Member.memberID), 1, 32' +
        ') AS MemberName,'
      '         Member.MemberID,'
      '         Session.SessionDT,'
      '         Event.EventNum,'
      '         Event.SessionID,'
      '         Lane.HeatID,'
      '         dbo.SwimTimeToString(Lane.RaceTime) AS RaceTime,'
      '         SUBSTRING(Distance.CalcCaption, 0, 8) AS Distance,'
      '         SUBSTRING(Stroke.Caption, 0, 12) AS Stroke,'
      '         Heat.HeatNum,'
      '         Lane.LaneNum,'
      '         SwimClub.NickName,'
      '         SwimClub.Caption AS SwimClub,'
      '         Event.Caption AS EventDescription'
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
      '         Session'
      '         ON Session.SessionID = Event.SessionID'
      '         INNER JOIN'
      '         SwimClub'
      '         ON Session.SwimClubID = SwimClub.SwimClubID'
      'WHERE    Event.EventID = @EventID'
      'ORDER BY HeatNum, LaneNum;')
    Left = 56
    Top = 16
    ParamData = <
      item
        Name = 'EVENTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 20
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
    Left = 104
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
    Left = 104
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
    Left = 104
    Top = 168
  end
  object frxdsReport: TfrxDBDataset
    UserName = 'Event'
    CloseDataSource = False
    FieldAliases.Strings = (
      'EventID=EventID'
      'EntrantCount=EntrantCount'
      'NomineeCount=NomineeCount'
      'HeatCount=HeatCount'
      'MemberName=MemberName'
      'MemberID=MemberID'
      'SessionDT=SessionDT'
      'EventNum=EventNum'
      'SessionID=SessionID'
      'HeatID=HeatID'
      'RaceTime=RaceTime'
      'Distance=Distance'
      'Stroke=Stroke'
      'HeatNum=HeatNum'
      'LaneNum=LaneNum'
      'NickName=NickName'
      'SwimClub=SwimClub'
      'EventDescription=EventDescription')
    DataSet = qryReport
    BCDToCurrency = False
    Left = 144
    Top = 16
  end
  object qrySwimClub: TFDQuery
    Connection = SCM2.scmConnection
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'DECLARE @SwimClubID AS INTEGER;'
      'SET @SwimClubID = :SWIMCLUBID;'
      ''
      'SELECT [SwimClubID]'
      '      ,[GUID]'
      '      ,[NickName]'
      '      ,[Caption] AS ClubName'
      '      ,[Email]'
      '      ,[ContactNum]'
      '      ,[WebSite]'
      '      ,[HeatAlgorithm]'
      '      ,[EnableSimpleDQ]'
      '      ,[NumOfLanes]'
      '      ,[LenOfPool]'
      '      ,[DefTeamSize]'
      '      ,[CreatedOn]'
      '      ,[LogoImg]'
      '      ,[IsArchived]'
      '      ,[IsClubGroup]'
      '      ,[SwimClubTypeID]'
      '      ,[PoolTypeID]'
      '  FROM [SwimClubMeet2].[dbo].[SwimClub]'
      '  WHERE SwimCLubID = @SwimClubID;')
    Left = 56
    Top = 88
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
    Left = 144
    Top = 88
  end
end
