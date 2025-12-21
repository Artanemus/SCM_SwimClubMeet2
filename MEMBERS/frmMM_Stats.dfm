object ManageMember_Stats: TManageMember_Stats
  Left = 0
  Top = 0
  Caption = 'Member'#39's Stats...'
  ClientHeight = 791
  ClientWidth = 1102
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 21
  object rpnlHeader: TRelativePanel
    Left = 0
    Top = 0
    Width = 1102
    Height = 45
    ControlCollection = <
      item
        Control = DBTextMemberName
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = False
      end>
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      1102
      45)
    object DBTextMemberName: TDBText
      Left = 4
      Top = 12
      Width = 164
      Height = 21
      Anchors = []
      AutoSize = True
      DataField = 'FName'
      DataSource = dsMember
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlBody: TPanel
    Left = 0
    Top = 45
    Width = 1102
    Height = 696
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pcntrlStats: TPageControl
      Left = 0
      Top = 0
      Width = 1102
      Height = 696
      ActivePage = tsMemberStats
      Align = alClient
      TabOrder = 0
      object tsDash: TTabSheet
        Caption = 'Dashboard'
      end
      object tsMemberStats: TTabSheet
        Caption = 'PB && History'
        object lblPB: TLabel
          Left = 3
          Top = 15
          Width = 21
          Height = 118
          Alignment = taCenter
          Caption = 'PERSONAL BEST'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Orientation = 900
          Font.Style = []
          ParentFont = False
        end
        object lblEventsSwum: TLabel
          Left = 316
          Top = 17
          Width = 21
          Height = 108
          Alignment = taRightJustify
          Caption = 'EVENTS SWUM'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Orientation = 900
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
        end
        object dbgPB: TDBGrid
          Left = 30
          Top = 17
          Width = 283
          Height = 573
          DataSource = dsPB
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -16
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'EventStr'
              Title.Caption = 'Event'
              Width = 155
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PB'
              Width = 90
              Visible = True
            end>
        end
        object dbgEventsSwum: TDBGrid
          Left = 343
          Top = 17
          Width = 442
          Height = 576
          DataSource = dsEventsSwum
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -16
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'EventStr'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'RaceTime'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'EventDate'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'EventID'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'MemberID'
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'FName'
              Visible = False
            end>
        end
      end
      object tsMemberChart: TTabSheet
        Caption = 'Chart'
        ImageIndex = 1
        object pnlChartPick: TPanel
          Left = 0
          Top = 0
          Width = 1094
          Height = 41
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            1094
            41)
          object Label27: TLabel
            Left = 24
            Top = 11
            Width = 59
            Height = 21
            Alignment = taRightJustify
            Caption = 'Distance'
          end
          object Label28: TLabel
            Left = 335
            Top = 11
            Width = 44
            Height = 21
            Alignment = taRightJustify
            Caption = 'Stroke'
          end
          object cmboDistance: TComboBox
            Left = 89
            Top = 8
            Width = 183
            Height = 29
            TabOrder = 0
            Text = 'cmboDistance'
            OnChange = cmboDistanceChange
          end
          object cmboStroke: TComboBox
            Left = 385
            Top = 8
            Width = 184
            Height = 29
            TabOrder = 1
            Text = 'cmboStroke'
            OnChange = cmboStrokeChange
          end
          object chkbDoCurrSeason: TCheckBox
            Left = 616
            Top = 11
            Width = 225
            Height = 17
            Caption = 'Current swimming season.'
            Checked = True
            State = cbChecked
            TabOrder = 2
            OnClick = chkbDoCurrSeasonClick
          end
          object btmPrintChart: TButton
            Left = 1405
            Top = 8
            Width = 129
            Height = 25
            Anchors = [akTop, akRight]
            Caption = 'Print Chart'
            TabOrder = 3
          end
        end
        object DBChart: TDBChart
          Left = 0
          Top = 41
          Width = 1094
          Height = 619
          Title.Text.Strings = (
            'TDBChart')
          BottomAxis.ExactDateTime = False
          BottomAxis.Increment = 1.000000000000000000
          Legend.Title.Alignment = taCenter
          Legend.Title.Text.Strings = (
            'Race Time & Date')
          View3D = False
          OnGetLegendText = DBChartGetLegendText
          Align = alClient
          TabOrder = 1
          DefaultCanvas = 'TGDIPlusCanvas'
          PrintMargins = (
            15
            24
            15
            24)
          ColorPaletteIndex = 13
          object Series2: TLineSeries
            HoverElement = [heCurrent]
            DataSource = qryChart
            XLabelsSource = 'ChartX'
            Brush.BackColor = clDefault
            Pointer.Brush.Gradient.EndColor = 10708548
            Pointer.Gradient.EndColor = 10708548
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = True
            XValues.Name = 'X'
            XValues.Order = loAscending
            XValues.ValueSource = 'ChartX'
            YValues.Name = 'Y'
            YValues.Order = loNone
            YValues.ValueSource = 'Seconds'
          end
        end
      end
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 741
    Width = 1102
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnOK: TButton
      Left = 992
      Top = 6
      Width = 75
      Height = 33
      Caption = 'Close'
      TabOrder = 0
    end
    object btnPickMember: TButton
      Left = 849
      Top = 6
      Width = 137
      Height = 33
      Caption = 'Select Member'
      TabOrder = 1
    end
  end
  object dsPB: TDataSource
    DataSet = qryPB
    Left = 409
    Top = 264
  end
  object qryPB: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'MemberID'
    MasterSource = dsMember
    MasterFields = 'MemberID'
    DetailFields = 'MemberID'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvFmtDisplayTime]
    FormatOptions.FmtDisplayTime = 'nn:ss.zzz'
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2..Member'
    UpdateOptions.KeyFields = 'MemberID'
    SQL.Strings = (
      ''
      ''
      'DECLARE @memberid as int'
      'SET @memberid = :MEMBERID'
      ''
      'SELECT DISTINCT Member.MemberID'
      #9',Distance.DistanceID'
      #9',Stroke.StrokeID'
      
        #9',dbo.PersonalBest(MemberID, DistanceID, StrokeID, GETDATE()) AS' +
        ' PB'
      #9',('
      #9#9'CONCAT ('
      #9#9#9'distance.caption'
      #9#9#9','#39' '#39
      #9#9#9',stroke.caption'
      #9#9#9')'
      #9#9') AS EventStr'
      'FROM Distance'
      'CROSS JOIN Stroke'
      'CROSS JOIN Member'
      
        'WHERE Member.MemberID = @memberid AND dbo.PersonalBest(MemberID,' +
        ' DistanceID, StrokeID, GETDATE()) IS NOT NULL'
      'ORDER BY MemberID'
      #9',DistanceID'
      #9',StrokeID'
      #9',PB ASC'
      ';')
    Left = 305
    Top = 264
    ParamData = <
      item
        Name = 'MEMBERID'
        DataType = ftAutoInc
        ParamType = ptInput
        Value = 50
      end>
    object qryPBEventStr: TWideStringField
      FieldName = 'EventStr'
      Origin = 'EventStr'
      ReadOnly = True
      Required = True
      Size = 257
    end
    object qryPBPB: TTimeField
      FieldName = 'PB'
      Origin = 'PB'
      ReadOnly = True
      DisplayFormat = 'nn:ss.zzz'
    end
    object qryPBMemberID: TFDAutoIncField
      FieldName = 'MemberID'
      Origin = 'MemberID'
      ProviderFlags = [pfInWhere, pfInKey]
      Visible = False
    end
    object qryPBDistanceID: TFDAutoIncField
      FieldName = 'DistanceID'
      Origin = 'DistanceID'
      Visible = False
    end
    object qryPBStrokeID: TFDAutoIncField
      FieldName = 'StrokeID'
      Origin = 'StrokeID'
      Visible = False
    end
  end
  object qryChart: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Active = True
    IndexFieldNames = 'MemberID'
    MasterSource = dsMember
    MasterFields = 'MemberID'
    DetailFields = 'MemberID'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvFmtDisplayDateTime]
    FormatOptions.FmtDisplayDateTime = 'dd/mmm/yyyy'
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'DECLARE @StrokeID AS INT;'
      'DECLARE @DistanceID AS INT;'
      'DECLARE @MemberID AS INT;'
      'DECLARE @DoCurrSeason AS BIT;'
      'DECLARE @MaxRecords AS INT;'
      ''
      'SET @StrokeID = :STROKEID;'
      'SET @DistanceID = :DISTANCEID;'
      'SET @MemberID = :MEMBERID;'
      'SET @DoCurrSeason = :DOCURRSEASON;'
      'SET @MaxRecords = :MAXRECORDS;'
      ''
      'IF OBJECT_ID('#39'tempdb..#charttemp'#39') IS NOT NULL'
      '    DROP TABLE #charttemp;'
      '    '
      'IF @MaxRecords IS NULL SET @MaxRecords = 26;'
      ''
      'if @MemberID IS NULL SET @MemberID = 0;'
      ''
      ''
      
        'SELECT TOP (@MaxRecords) [dbo].[SwimTimeToString](Lane.RaceTime)' +
        ' AS RaceTimeAsString'
      #9',(DATEPART(MILLISECOND, Lane.RaceTime) / 1000.0) '
      '                + (DATEPART(SECOND, Lane.RaceTime)) '
      
        '                + (DATEPART(MINUTE, Lane.RaceTime) * 60.0) AS Se' +
        'conds'
      ''
      #9',Session.SessionDT'
      #9',Distance.Caption AS cDistance'
      #9',Stroke.Caption AS cStroke'
      ''
      'INTO #charttemp'
      'FROM [dbo].[Lane]'
      'INNER JOIN Heat ON Lane.HeatID = Heat.HeatID'
      'INNER JOIN Event ON Heat.EventID = Event.EventID'
      
        'INNER JOIN Nominee ON Lane.NomineeID = Nominee.NomineeID AND Eve' +
        'nt.EventID = Nominee.EventID'
      'INNER JOIN Session ON Event.SessionID = Session.SessionID'
      'INNER JOIN SwimClub ON Session.SwimClubID = SwimClub.SwimClubID'
      'INNER JOIN Stroke ON Event.StrokeID = Stroke.StrokeID'
      'INNER JOIN Distance ON Event.DistanceID = Distance.DistanceID'
      'WHERE (Event.StrokeID = @StrokeID)'
      #9'AND (Event.DistanceID = @DistanceID) '
      '        AND (Nominee.MemberID = @MemberID) '
      '        AND Lane.RaceTime IS NOT NULL'
      #9#9'-- playing it extra careful'
      #9#9'AND CONVERT(time(0), Lane.RaceTime) > '#39'00:00:00'#39
      '        AND ('
      
        '           (@DoCurrSeason = 1 AND Session.SessionDT >= SwimClub.' +
        'StartOfSwimSeason)'
      '           OR'
      '           (@DoCurrSeason = 0)'
      #9#9' )'
      '        '
      'ORDER BY SessionDT DESC;'
      ''
      'SELECT '
      #9'RaceTimeAsString'
      #9',Seconds'
      #9',SessionDT'
      #9',cDistance'
      #9',cStroke'
      ' ,@MemberID as MemberID'
      
        ',ROW_NUMBER()OVER (PARTITION BY 1  ORDER BY SessionDT ) AS Chart' +
        'X'
      'FROM'
      '#charttemp'
      'ORDER BY SessionDT ASC;'
      '')
    Left = 304
    Top = 328
    ParamData = <
      item
        Name = 'STROKEID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end
      item
        Name = 'DISTANCEID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 2
      end
      item
        Name = 'MEMBERID'
        DataType = ftAutoInc
        ParamType = ptInput
        Value = 2
      end
      item
        Name = 'DOCURRSEASON'
        DataType = ftBoolean
        ParamType = ptInput
        Value = False
      end
      item
        Name = 'MAXRECORDS'
        DataType = ftInteger
        ParamType = ptInput
        Value = 26
      end>
    object qryChartRaceTimeAsString: TWideStringField
      FieldName = 'RaceTimeAsString'
      Origin = 'RaceTimeAsString'
      Size = 12
    end
    object qryChartSeconds: TFMTBCDField
      FieldName = 'Seconds'
      Origin = 'Seconds'
      Precision = 20
      Size = 6
    end
    object qryChartSessionDT: TSQLTimeStampField
      FieldName = 'SessionDT'
      Origin = 'SessionDT'
      DisplayFormat = 'dd/mmm/yyyy'
    end
    object qryChartcDistance: TWideStringField
      FieldName = 'cDistance'
      Origin = 'cDistance'
      Size = 128
    end
    object qryChartcStroke: TWideStringField
      FieldName = 'cStroke'
      Origin = 'cStroke'
      Size = 128
    end
    object qryChartChartX: TLargeintField
      FieldName = 'ChartX'
      Origin = 'ChartX'
      ReadOnly = True
    end
    object qryChartMemberID: TIntegerField
      FieldName = 'MemberID'
      Origin = 'MemberID'
      ReadOnly = True
    end
  end
  object dsChart: TDataSource
    DataSet = qryChart
    Left = 408
    Top = 320
  end
  object dsEventsSwum: TDataSource
    DataSet = qryEventsSwum
    Left = 408
    Top = 208
  end
  object qryEventsSwum: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'MemberID'
    MasterSource = dsMember
    MasterFields = 'MemberID'
    DetailFields = 'MemberID'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvFmtDisplayTime]
    FormatOptions.FmtDisplayTime = 'nn:ss.zzz'
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Event'
    UpdateOptions.KeyFields = 'EventID'
    SQL.Strings = (
      'DECLARE @EventID AS INteger;'
      'SET @EventID = :EVENTID;'
      ''
      ''
      'SELECT '
      '[Event].EventID'
      ',Nominee.MemberID '
      '--,Concat(Member.FirstName, '#39' '#39', Member.LastName) AS FName'
      
        ',SubString(Concat(Distance.Caption, '#39' '#39', Stroke.Caption), 0, 32)' +
        ' AS EventStr'
      ',Lane.RaceTime'
      ', CONVERT(VARCHAR(11), Session.SessionDT, 106) AS EventDate '
      ''
      'FROM [Event]'
      'INNER JOIN Session ON [Event].SessionID = Session.SessionID'
      'INNER JOIN Stroke ON [Event].StrokeID = Stroke.StrokeID'
      'INNER JOIN Distance ON [Event].DistanceID = Distance.DistanceID'
      'INNER JOIN Heat ON [Event].EventID = Heat.EventID'
      'INNER JOIN Lane ON [Heat].HeatID = Lane.HeatID'
      
        'INNER JOIN Nominee ON Lane.NomineeID = Nominee.NomineeID AND [Ev' +
        'ent].EventID = Nominee.EventID'
      
        '--INNER JOIN Member ON Nominee.MemberID = Member.MemberID AND [E' +
        'vent].[EventID] = Nominee.EventID'
      
        'WHERE (RaceTime IS NOT NULL OR (dbo.SwimTimeToMilliseconds(RaceT' +
        'ime) > 0))'
      'ORDER BY Session.SessionDT ASC, Distance.Meters, Stroke.StrokeID'
      ';')
    Left = 304
    Top = 208
    ParamData = <
      item
        Name = 'EVENTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryEventsSwumEventID: TFDAutoIncField
      DisplayWidth = 5
      FieldName = 'EventID'
      Origin = 'EventID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object qryEventsSwumMemberID: TIntegerField
      DisplayWidth = 5
      FieldName = 'MemberID'
      Origin = 'MemberID'
    end
    object qryEventsSwumFName: TWideStringField
      DisplayWidth = 20
      FieldName = 'FName'
      Origin = 'FName'
      ReadOnly = True
      Required = True
      Size = 257
    end
    object qryEventsSwumEventStr: TWideStringField
      DisplayWidth = 18
      FieldName = 'EventStr'
      Origin = 'EventStr'
      ReadOnly = True
      Required = True
      Size = 257
    end
    object qryEventsSwumRaceTime: TTimeField
      FieldName = 'RaceTime'
      Origin = 'RaceTime'
      DisplayFormat = 'nn:ss.zzz'
    end
    object qryEventsSwumEventDate: TStringField
      FieldName = 'EventDate'
      Origin = 'EventDate'
      ReadOnly = True
      Size = 11
    end
  end
  object dsMember: TDataSource
    DataSet = qryMember
    Left = 304
    Top = 136
  end
  object qryMember: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'MemberID'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvStrsTrim2Len]
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Member'
    UpdateOptions.KeyFields = 'MemberID'
    SQL.Strings = (
      ''
      'DECLARE @MemberID INTEGER;'
      ''
      'SET @MemberID = :MEMBERID;'
      ''
      'SELECT'
      '    m.[MemberID],'
      '    m.[MembershipNum],'
      '    m.[MembershipStr],'
      '    m.[FirstName],'
      '    m.[MiddleName],'
      '    m.[LastName],'
      '    m.[DOB],'
      '    m.[IsActive],'
      '    m.IsSwimmer,'
      '    m.IsArchived,'
      '    m.[Email],'
      '    m.[GenderID],'
      '    TRIM(CONCAT('
      '        m.[FirstName],'
      '        '#39' '#39','
      '        IIF('
      
        '            m.[MiddleName] IS NULL OR LEN(LTRIM(RTRIM(m.[MiddleN' +
        'ame]))) = 0,'
      '            '#39#39','
      
        '            CONCAT(UPPER(LEFT(LTRIM(RTRIM(m.[MiddleName])),1)), ' +
        #39'. '#39')'
      '        ),'
      '        UPPER(m.[LastName])'
      '    )) AS FName,'
      '    m.CreatedOn,'
      '    m.ArchivedOn,'
      '    m.TAGS'
      'FROM [dbo].[Member] AS m'
      'WHERE (@MemberID = 0 AND m.MemberID > 0)'
      '   OR (@MemberID <> 0 AND m.MemberID = @MemberID);'
      ''
      ''
      ''
      '')
    Left = 200
    Top = 136
    ParamData = <
      item
        Name = 'MEMBERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 2
      end>
    object qryMemberMemberID: TFDAutoIncField
      Alignment = taCenter
      DisplayLabel = 'ID'
      DisplayWidth = 4
      FieldName = 'MemberID'
      Origin = 'MemberID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object qryMemberMembershipNum: TIntegerField
      Alignment = taLeftJustify
      DisplayLabel = 'Num#'
      DisplayWidth = 4
      FieldName = 'MembershipNum'
      Origin = 'MembershipNum'
    end
    object qryMemberMembershipStr: TWideStringField
      FieldName = 'MembershipStr'
      Origin = 'MembershipStr'
      Size = 24
    end
    object qryMemberFirstName: TWideStringField
      DisplayLabel = 'First Name'
      DisplayWidth = 18
      FieldName = 'FirstName'
      Origin = 'FirstName'
      Size = 128
    end
    object qryMemberLastName: TWideStringField
      DisplayLabel = 'Last Name'
      DisplayWidth = 18
      FieldName = 'LastName'
      Origin = 'LastName'
      Size = 128
    end
    object qryMemberFName: TWideStringField
      FieldName = 'FName'
      Origin = 'FName'
      ReadOnly = True
      Required = True
      Visible = False
      Size = 257
    end
    object qryMemberDOB: TSQLTimeStampField
      DisplayWidth = 12
      FieldName = 'DOB'
      Origin = 'DOB'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object qryMemberIsActive: TBooleanField
      Alignment = taCenter
      DisplayLabel = 'Active'
      FieldName = 'IsActive'
      Origin = 'IsActive'
    end
    object qryMemberIsSwimmer: TBooleanField
      FieldName = 'IsSwimmer'
      Origin = 'IsSwimmer'
    end
    object qryMemberIsArchived: TBooleanField
      FieldName = 'IsArchived'
      Origin = 'IsArchived'
    end
    object qryMemberEmail: TWideStringField
      DisplayWidth = 50
      FieldName = 'Email'
      Origin = 'Email'
      Size = 256
    end
    object qryMemberCreatedOn: TSQLTimeStampField
      FieldName = 'CreatedOn'
      Origin = 'CreatedOn'
    end
    object qryMemberArchivedOn: TSQLTimeStampField
      FieldName = 'ArchivedOn'
      Origin = 'ArchivedOn'
    end
    object qryMemberGenderID: TIntegerField
      FieldName = 'GenderID'
      Origin = 'GenderID'
      Visible = False
    end
    object qryMemberTAGS: TWideMemoField
      FieldName = 'TAGS'
      Origin = 'TAGS'
      BlobType = ftWideMemo
    end
  end
  object tblDistance: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'DistanceID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Distance'
    UpdateOptions.KeyFields = 'DistanceID'
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2.dbo.Distance'
    Left = 360
    Top = 416
  end
  object tblStroke: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'StrokeID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Stroke'
    UpdateOptions.KeyFields = 'StrokeID'
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2.dbo.Stroke'
    Left = 360
    Top = 472
  end
end
