object FrameSwimClub: TFrameSwimClub
  Left = 0
  Top = 0
  Width = 620
  Height = 578
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentBackground = False
  ParentFont = False
  TabOrder = 0
  object pcntrlEdit: TPageControl
    Left = 0
    Top = 0
    Width = 620
    Height = 578
    ActivePage = tsMain
    Align = alClient
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    object tsMain: TTabSheet
      Caption = 'Required (*)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      object lblClubName: TLabel
        Left = 48
        Top = 80
        Width = 85
        Height = 21
        Alignment = taRightJustify
        Caption = 'Club Name*'
      end
      object lblNickname: TLabel
        Left = 20
        Top = 112
        Width = 113
        Height = 21
        Alignment = taRightJustify
        Caption = 'Club Nickname*'
      end
      object lblNumOfLanes: TLabel
        Left = 10
        Top = 150
        Width = 123
        Height = 21
        Alignment = taRightJustify
        Caption = 'Number of lanes*'
      end
      object lblPoolLength: TLabel
        Left = 186
        Top = 425
        Width = 100
        Height = 21
        Alignment = taRightJustify
        Caption = 'Length of Pool'
        Enabled = False
      end
      object imgIndxArchive: TSVGIconImage
        Left = 74
        Top = 12
        Width = 43
        Height = 41
        Hint = 'Toogle retirement of the club.'
        AutoSize = False
        ImageList = IMG.imglstSwimClubArchived
        ImageIndex = 0
        ImageName = 'unknown'
      end
      object DBTextPrimaryKey: TDBText
        Left = 172
        Top = 32
        Width = 65
        Height = 21
        DataField = 'SwimClubID'
        DataSource = CORE.dsSwimClub
        Visible = False
      end
      object imgindxGroup: TSVGIconImage
        Left = 123
        Top = 12
        Width = 43
        Height = 41
        Hint = 'Toogle retirement of the club.'
        AutoSize = False
        ImageList = IMG.imglstSwimClubGroup
        ImageIndex = 1
        ImageName = 'group'
        Enabled = False
      end
      object lblClubType: TLabel
        Left = 63
        Top = 320
        Width = 68
        Height = 21
        Alignment = taRightJustify
        Caption = 'Club Type'
      end
      object lblQualifyType: TLabel
        Left = 61
        Top = 358
        Width = 73
        Height = 21
        Alignment = taRightJustify
        Caption = 'Pool Type*'
      end
      object lblUnitType: TLabel
        Left = 139
        Top = 452
        Width = 147
        Height = 21
        Alignment = taRightJustify
        Caption = 'Unit of Measurement'
        Enabled = False
      end
      object lblCourseType: TLabel
        Left = 201
        Top = 398
        Width = 85
        Height = 21
        Alignment = taRightJustify
        Caption = 'Course Type'
        Enabled = False
      end
      object DBTextCourseType: TDBText
        Left = 298
        Top = 398
        Width = 65
        Height = 17
        DataField = 'ABREV'
        DataSource = CORE.dsPoolType
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DBTextLengthOfPool: TDBText
        Left = 298
        Top = 425
        Width = 65
        Height = 21
        DataField = 'LengthOfPool'
        DataSource = CORE.dsPoolType
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DBTextUnitType: TDBText
        Left = 298
        Top = 452
        Width = 65
        Height = 17
        DataField = 'ABREV'
        DataSource = luUnitType
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DBClubName: TDBEdit
        Left = 139
        Top = 77
        Width = 387
        Height = 29
        DataField = 'Caption'
        DataSource = CORE.dsSwimClub
        TabOrder = 0
      end
      object DBNickName: TDBEdit
        Left = 139
        Top = 112
        Width = 387
        Height = 29
        DataField = 'NickName'
        DataSource = CORE.dsSwimClub
        TabOrder = 1
      end
      object DBEditNumOfLanes: TDBEdit
        Left = 139
        Top = 147
        Width = 56
        Height = 29
        DataField = 'NumOfLanes'
        DataSource = CORE.dsSwimClub
        TabOrder = 2
      end
      object dblucmbClubType: TDBLookupComboBox
        Left = 140
        Top = 318
        Width = 338
        Height = 29
        DataField = 'SwimClubTypeID'
        DataSource = CORE.dsSwimClub
        KeyField = 'SwimClubTypeID'
        ListField = 'Caption'
        ListSource = CORE.luSwimClubType
        NullValueKey = 32776
        TabOrder = 4
      end
      object dbcboxArchive: TDBCheckBox
        Left = 74
        Top = 228
        Width = 83
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Archive*'
        DataField = 'IsArchived'
        DataSource = CORE.dsSwimClub
        TabOrder = 3
      end
      object dblucmbPoolType: TDBLookupComboBox
        Left = 140
        Top = 358
        Width = 338
        Height = 29
        DataField = 'PoolTypeID'
        DataSource = CORE.dsSwimClub
        KeyField = 'PoolTypeID'
        ListField = 'Caption'
        ListSource = CORE.luPoolType
        NullValueKey = 32776
        TabOrder = 5
      end
      object btnClearClubType: TButton
        Tag = 1
        Left = 493
        Top = 317
        Width = 92
        Height = 30
        Hint = 'Clear the house name. (Alt+BkSp)'
        Caption = 'Clear'
        ImageIndex = 0
        ImageName = 'clear'
        Images = IMG.imglstMiscButtons
        TabOrder = 6
        TabStop = False
        OnClick = btnClearClubTypeClick
      end
      object btnClearPoolType: TButton
        Tag = 1
        Left = 493
        Top = 357
        Width = 92
        Height = 30
        Hint = 'Clear the house name. (Alt+BkSp)'
        Caption = 'Clear'
        ImageIndex = 0
        ImageName = 'clear'
        Images = IMG.imglstMiscButtons
        TabOrder = 7
        TabStop = False
        Visible = False
        OnClick = btnClearPoolTypeClick
      end
    end
    object tsOptions2: TTabSheet
      Caption = 'Contact Details'
      ImageIndex = 1
      object lblEmail: TLabel
        Left = 79
        Top = 148
        Width = 38
        Height = 21
        Alignment = taRightJustify
        Caption = 'Email'
      end
      object lblWebSite: TLabel
        Left = 60
        Top = 183
        Width = 57
        Height = 21
        Alignment = taRightJustify
        Caption = 'WebSite'
      end
      object lblContactNum: TLabel
        Left = 3
        Top = 113
        Width = 115
        Height = 21
        Alignment = taRightJustify
        Caption = 'Contact Number'
      end
      object lblAddress: TLabel
        Left = 54
        Top = 18
        Width = 56
        Height = 21
        Alignment = taRightJustify
        Caption = 'Address'
      end
      object DBContactNum: TDBEdit
        Left = 123
        Top = 110
        Width = 166
        Height = 29
        Hint = 'Input is Alpha Numerical.'
        DataField = 'ContactNum'
        DataSource = CORE.dsSwimClub
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TextHint = 'MB 018 018 018'
      end
      object DBWebSite: TDBEdit
        Left = 123
        Top = 180
        Width = 486
        Height = 29
        DataField = 'WebSite'
        DataSource = CORE.dsSwimClub
        TabOrder = 3
      end
      object DBEmail: TDBEdit
        Left = 123
        Top = 145
        Width = 486
        Height = 29
        DataField = 'Email'
        DataSource = CORE.dsSwimClub
        TabOrder = 2
      end
      object DBMemoAddress: TDBMemo
        Left = 123
        Top = 15
        Width = 486
        Height = 89
        DataSource = CORE.dsSwimClub
        TabOrder = 0
      end
    end
    object tsLogo: TTabSheet
      Caption = 'Logo'
      ImageIndex = 1
      object lblLogoHintTxt: TLabel
        Left = 32
        Top = 336
        Width = 306
        Height = 49
        Alignment = taCenter
        AutoSize = False
        Caption = 'Max 400x400 pixels.'#13#10'(For best performance)'
      end
      object DBLogo: TDBImage
        Left = 32
        Top = 24
        Width = 306
        Height = 306
        DataField = 'LogoImg'
        DataSource = CORE.dsSwimClub
        Proportional = True
        Stretch = True
        TabOrder = 3
        TabStop = False
      end
      object btnLoadClubLogo: TButton
        Left = 344
        Top = 24
        Width = 101
        Height = 33
        Caption = 'Load'
        TabOrder = 0
        OnClick = btnLoadClubLogoClick
      end
      object btnSaveClubLogo: TButton
        Left = 344
        Top = 63
        Width = 101
        Height = 33
        Caption = 'Save'
        TabOrder = 1
        OnClick = btnSaveClubLogoClick
      end
      object btnClearClubLogo: TButton
        Left = 344
        Top = 102
        Width = 101
        Height = 33
        Caption = 'Clear'
        TabOrder = 2
        OnClick = btnClearClubLogoClick
      end
    end
    object ts_LinkedClubs: TTabSheet
      Caption = 'Group Details'
      ImageIndex = 2
      object pnlCG: TPanel
        Left = 0
        Top = 0
        Width = 612
        Height = 542
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
      end
    end
  end
  object luUnitType: TDataSource
    DataSet = tblUnitType
    Left = 432
    Top = 220
  end
  object tblUnitType: TFDTable
    ActiveStoredUsage = [auDesignTime]
    Active = True
    IndexFieldNames = 'UnitTypeID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.UnitType'
    UpdateOptions.KeyFields = 'UnitTypeID'
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'SwimClubMeet2.dbo.UnitType'
    Left = 360
    Top = 220
  end
  object SaveLogoDlg: TSavePictureDialog
    Left = 360
    Top = 312
  end
  object OpenLogoDlg: TOpenPictureDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Load SCM2 Club Logo'
    Left = 440
    Top = 312
  end
end
