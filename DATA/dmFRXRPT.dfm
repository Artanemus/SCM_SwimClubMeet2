object FRXRPT: TFRXRPT
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
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
    Left = 56
    Top = 288
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
    Left = 144
    Top = 288
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
    Left = 56
    Top = 352
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
    Left = 144
    Top = 352
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
    ReportOptions.LastChange = 46262.500416794000000000
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
    Left = 304
    Top = 288
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
  object rptEvSummary: TfrxReport
    Version = '6.6.11'
    ParentReport = '..\TEMPLATEDIR\Template_Base.fr3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.AllowEdit = False
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 9
    ReportOptions.CreateDate = 46261.499890659700000000
    ReportOptions.Name = 'EventSummary'
    ReportOptions.LastChange = 46262.616183946760000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
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
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
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
        Width = 718.110700000000000000
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
          Left = 411.968770000000000000
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
        Width = 718.110700000000000000
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
        Width = 718.110700000000000000
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
        Width = 718.110700000000000000
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
    Left = 496
    Top = 208
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
    Left = 496
    Top = 152
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
    Left = 496
    Top = 96
  end
end
