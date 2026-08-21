object EventReportC: TEventReportC
  OnCreate = DataModuleCreate
  Height = 355
  Width = 334
  object frxReport1: TfrxReport
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
    ReportOptions.Name = 'Sys-Event-Misc'
    ReportOptions.LastChange = 46253.541073206020000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 248
    Top = 16
    Datasets = <
      item
        DataSet = frxDSReport
        DataSetName = 'frxDS'
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
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        Frame.Typ = []
        Height = 56.692950000000000000
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
          Left = 408.189240000000000000
          Top = 22.677180000000000000
          Width = 306.141930000000000000
          Height = 18.897650000000000000
          DataSet = frxDSReport
          DataSetName = 'frxDS'
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
        Height = 37.795300000000000000
        ParentFont = False
        Top = 136.063080000000000000
        Width = 718.110700000000000000
        Condition = 'frxDS."SessionID"'
        object Memo1: TfrxMemoView
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
        object Memo3: TfrxMemoView
          AllowVectorExport = True
          Left = 52.477736670000000000
          Top = 7.559060000000000000
          Width = 56.972480000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Distance')
        end
        object Memo2: TfrxMemoView
          AllowVectorExport = True
          Left = 113.122140000000000000
          Top = 7.559060000000000000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Stroke')
        end
        object Memo4: TfrxMemoView
          AllowVectorExport = True
          Left = 517.403216670000000000
          Top = 8.059060000000000000
          Width = 32.364819630000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'M,F,X')
          ParentFont = False
        end
        object Memo5: TfrxMemoView
          AllowVectorExport = True
          Left = 552.934756670000000000
          Top = 7.559060000000000000
          Width = 53.531486300000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Round')
          ParentFont = False
        end
        object Memo6: TfrxMemoView
          AllowVectorExport = True
          Left = 229.410946670000000000
          Top = 7.559060000000000000
          Width = 283.212740000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Event Description')
        end
        object Line1: TfrxLineView
          AllowVectorExport = True
          Left = 2.500000000000000000
          Top = 32.736240000000000000
          Width = 714.551640000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
          Frame.Width = 2.000000000000000000
        end
        object Memo9: TfrxMemoView
          AllowVectorExport = True
          Left = 608.500000000000000000
          Top = 7.936920000000000000
          Width = 43.488250000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Status')
          ParentFont = False
        end
        object Picture1: TfrxPictureView
          AllowVectorExport = True
          Left = 523.500000000000000000
          Top = -12.063080000000000000
          Width = 21.488250000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Picture.Data = {
            0A54504E474F626A65637489504E470D0A1A0A0000000D494844520000004000
            0000400806000000AA6971DE000002C14944415478DAED9B4D4854511886EFB4
            32A845466DA3552B75E52252ECCF141D770A516850413F546EAA85CCACD48DBA
            52304525522685DC8D4A52F48369B4AC36D1AA75A24105B552DF8F99D90CCE9C
            73CF39D7EF1BE7BCF0A0DE7BCEBDDF79E6727FCE5C63419927C65D0077BC00EE
            02B8E3057017C01D2F80BB00EE8411701A8C816AEEA215F9026E838F2E05DC03
            23DC230B99073A35EB08A04F7E8D7B348639A3AA5D47C0E740FE615F285F55B5
            EB08D8E61E856562C62BBD002FC00B702D600B8C83A5207372FD995D7E1CD480
            16700B1CD86F0236C065F05AB3FD4530078EEE070149D067D837017A4B59C079
            F0D67200E7C09B5214500F3E580E3E973AB0524A021E81214783CFE521182C05
            01BF40A5E3C1E7B2098E4817D001E62312D00E5E481710F5248BD37A5C0BA093
            5E7DC402E864582755005DEF931AED8E8145509BFDFB136803EB1A7DE9BE2021
            55C055F05CA3DD6F70386FD9DF5D96ED962B20255540335856B4B91014BE256E
            0CD4B7CB4DE0A55401F120736817CB75305564DD5345FF56B02055C05DF044D1
            E614F85664DD7745FF3B6054AA00FA646F6AB49B069D79CB66409746DF09CD7D
            B008D03D9151AE811BD9DF49DC33CD7E7FC021A9022827C18F907D7473C260DB
            7B2E6036C85CAAA248CA60DB2C4F833493B3E978F0F480B561D08F45005D0AE3
            8E05A40DB7C93621A2FC5A2A446CBE9E639D123B08FE5B0EBE02FCB3E8CF2AE0
            15B8642960D9721BECB3C2F4E4D66FD8B7C7A2AF18011493592293D91FB10228
            61A6C86DA7C2450AA0D04CCEAAA20D5D3D5C4DA78B1340390BDE1758D700DE39
            DE9F3801149AFECA7FA6A79B9C7404FB122980428FB4B989117A2A9C8C683F62
            055006B23F1F47B80FD102F6225E8017E005D80928FB1725CBFE5559CA7D30CC
            3D9A90E9D6A939ECEBF2F48A5B15F7C814A1C39E5E97D73A6AFD3F4C7017C01D
            2F80BB00EE7801DC0570C70BE02E803B3B07E38B41C4373E7A0000000049454E
            44AE426082}
          HightQuality = False
          Transparent = False
          TransparentColor = clWhite
        end
        object Memo7: TfrxMemoView
          AllowVectorExport = True
          Left = 653.500000000000000000
          Top = 7.436920000000000000
          Width = 57.988250000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Schedule')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 196.535560000000000000
        Width = 718.110700000000000000
        DataSet = frxDSReport
        DataSetName = 'frxDS'
        RowCount = 0
        object frxDSEventNum: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Width = 37.246753330000000000
          Height = 18.897650000000000000
          DataSet = frxDSReport
          DataSetName = 'frxDS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[<frxDS."EventNum"> #n%3g]')
          ParentFont = False
        end
        object frxDScDistance: TfrxMemoView
          AllowVectorExport = True
          Left = 44.477736670000000000
          Width = 58.972480000000000000
          Height = 18.897650000000000000
          DataSet = frxDSReport
          DataSetName = 'frxDS'
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
        object frxDScStroke: TfrxMemoView
          AllowVectorExport = True
          Left = 111.788806670000000000
          Width = 113.385900000000000000
          Height = 18.897650000000000000
          DataSet = frxDSReport
          DataSetName = 'frxDS'
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDS."Stroke"]')
        end
        object frxDSNomineeCount: TfrxMemoView
          AllowVectorExport = True
          Left = 518.403216670000000000
          Top = 0.500000000000000000
          Width = 30.972426300000000000
          Height = 18.897650000000000000
          DataSet = frxDSReport
          DataSetName = 'frxDS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[frxDS."GenderABREV"]')
          ParentFont = False
        end
        object frxDSHeatCount: TfrxMemoView
          AllowVectorExport = True
          Left = 551.434756670000000000
          Top = 0.500000000000000000
          Width = 53.972426300000000000
          Height = 18.897650000000000000
          DataSet = frxDSReport
          DataSetName = 'frxDS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[frxDS."EventRound"]')
          ParentFont = False
        end
        object frxDScEvent: TfrxMemoView
          AllowVectorExport = True
          Left = 231.910946670000000000
          Top = 0.500000000000000000
          Width = 282.212740000000000000
          Height = 18.897650000000000000
          DataSet = frxDSReport
          DataSetName = 'frxDS'
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
        object frxDSStatus: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 608.000000000000000000
          Top = 1.000000000000000000
          Width = 45.252010000000000000
          Height = 18.897650000000000000
          DataSet = frxDSReport
          DataSetName = 'frxDS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDS."Status"]')
          ParentFont = False
        end
        object frxDSStartTime: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 656.000000000000000000
          Top = 0.464440000000000000
          Width = 54.370130000000000000
          Height = 18.897650000000000000
          DataSet = frxDSReport
          DataSetName = 'frxDS'
          DisplayFormat.FormatStr = 'hh:mm am/pm'
          DisplayFormat.Kind = fkDateTime
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            
              '[IIF(<frxDS."StartTime"> = 0, '#39#39', FormatDateTime('#39'hh:mm am/pm'#39', ' +
              '<frxDS."StartTime">))]')
          ParentFont = False
        end
      end
      object PageFooter1: TfrxPageFooter
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
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'DECLARE @SessionID AS INT;'
      ''
      'SET @SessionID = :SESSIONID;'
      ''
      'SELECT '
      #9'-- event'
      '    Event.EventID,'
      '    Event.SessionID,'
      '    Event.EventNum,'
      '-- distance..stroke'
      #9'SubString(Distance.CalcCaption,1, 8) AS Distance,'
      #9'SubString(Stroke.Caption,1,16) AS Stroke,'#9
      #9'Event.StartTime,'
      #9'dbo.EntrantCount(Event.EventID) AS EntrantCount,'
      #9'dbo.NomineeCount(Event.EventID) AS NomineeCount,'
      #9'dbo.HeatCount(Event.EventID) AS HeatCount,'
      
        #9'SubString(Event.Caption, 1, 64) AS EventDescription, -- 05.06.2' +
        '023'
      #9'SubString(EventStatus.Caption,1,8) AS Status,'
      #9'SubString([Round].Caption, 1, 16) AS EventRound,'
      #9'SubString([EventType].Caption,1, 16) AS EventType, '
      #9'SubString([EventType].ABREV,1, 16) AS EventTypeABREV, '
      #9'[Gender].Caption AS Gender,'
      #9'[Gender].ABREV AS GenderABREV,'
      #9'SubString([EventCategory].Caption, 1, 32) AS EventCategory ,'
      #9'SubString([ParalympicType].Caption, 1, 32) AS ParalympicType,'
      ''
      #9'-- swimclub'
      #9'SubString(SwimClub.NickName, 1, 48) AS NickName,'
      #9'SubString(SwimClub.Caption, 1, 56) AS SwimClub,'
      #9
      #9'-- session'
      #9'Session.SessionDT'
      '         '
      '         '
      'FROM     '
      #9'Event'
      #9'INNER JOIN'#9'Distance'
      #9'ON Event.DistanceID = Distance.DistanceID'
      #9'INNER JOIN Stroke'
      #9'ON Event.StrokeID = Stroke.StrokeID'
      #9'INNER JOIN Session'
      #9'ON Event.SessionID = Session.SessionID'
      #9'INNER JOIN SwimClub'
      #9'ON Session.SwimClubID = SwimClub.SwimClubID'
      #9'INNER JOIN EventStatus'
      #9'ON Event.EventStatusID = EventStatus.EventStatusID'
      '         '
      #9'left join Round on Event.RoundID = Round.RoundID'
      #9'left join Gender on Event.GenderID = Gender.GenderID'
      
        #9'left join EventCategory on Event.[EventCategoryID] = EventCateg' +
        'ory.EventCategoryID'
      
        #9'left join ParalympicType on Event.[ParalympicTypeID] = Paralymp' +
        'icType.ParalympicTypeID'
      
        #9'left join EventType on Event.[EventTypeID] = EventType.EventTyp' +
        'eID'
      '         '
      ''
      'WHERE Event.SessionID = @SessionID'
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
    Left = 80
    Top = 224
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
    Left = 80
    Top = 168
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
    Left = 80
    Top = 112
  end
  object frxDSReport: TfrxDBDataset
    UserName = 'frxDS'
    CloseDataSource = False
    FieldAliases.Strings = (
      'EventID=EventID'
      'SessionID=SessionID'
      'EventNum=EventNum'
      'Distance=Distance'
      'Stroke=Stroke'
      'StartTime=StartTime'
      'EntrantCount=EntrantCount'
      'NomineeCount=NomineeCount'
      'HeatCount=HeatCount'
      'EventDescription=EventDescription'
      'Status=Status'
      'EventRound=EventRound'
      'EventType=EventType'
      'EventTypeABREV=EventTypeABREV'
      'Gender=Gender'
      'GenderABREV=GenderABREV'
      'EventCategory=EventCategory'
      'ParalympicType=ParalympicType'
      'NickName=NickName'
      'SwimClub=SwimClub'
      'SessionDT=SessionDT')
    DataSet = qryReport
    BCDToCurrency = False
    Left = 160
    Top = 16
  end
end
