object EditSession: TEditSession
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Edit Session ...'
  ClientHeight = 443
  ClientWidth = 672
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 21
  object Panel1: TPanel
    Left = 0
    Top = 57
    Width = 672
    Height = 337
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 430
    object Label1: TLabel
      Left = 8
      Top = 205
      Width = 149
      Height = 21
      Caption = 'Session Description ...'
      Enabled = False
    end
    object Label2: TLabel
      Left = 8
      Top = 20
      Width = 89
      Height = 21
      Caption = 'Session Date'
      Enabled = False
    end
    object Label3: TLabel
      Left = 8
      Top = 114
      Width = 91
      Height = 21
      Caption = 'Session Time'
      Enabled = False
    end
    object spbtnPlus: TSpeedButton
      Left = 313
      Top = 140
      Width = 36
      Height = 36
      Hint = 'Add 15mins to time.'
      ImageIndex = 7
      ImageName = 'plus-box'
      Images = IMG.imglstMiscButtons
      ParentShowHint = False
      PressedImageIndex = 10
      PressedImageName = 'plus-box_Disabled'
      ShowHint = True
      OnClick = btnPlusClick
    end
    object spbtnMinus: TSpeedButton
      Left = 271
      Top = 140
      Width = 36
      Height = 36
      Hint = 'Subtract 15mins from time.'
      ImageIndex = 6
      ImageName = 'minus-box'
      Images = IMG.imglstMiscButtons
      ParentShowHint = False
      PressedImageIndex = 9
      PressedImageName = 'minus-box_Disabled'
      ShowHint = True
      OnClick = btnMinusClick
    end
    object lblNominees: TLabel
      Left = 8
      Top = 288
      Width = 78
      Height = 21
      Caption = 'Nominees: '
      Enabled = False
    end
    object lblEntrants: TLabel
      Left = 119
      Top = 288
      Width = 64
      Height = 21
      Caption = 'Entrants: '
      Enabled = False
    end
    object lblEvents: TLabel
      Left = 225
      Top = 288
      Width = 52
      Height = 21
      Caption = 'Events: '
      Enabled = False
    end
    object lblWeek: TLabel
      Left = 339
      Top = 288
      Width = 45
      Height = 21
      Caption = 'Week: '
      Enabled = False
    end
    object DBTextNominees: TDBText
      Left = 92
      Top = 288
      Width = 24
      Height = 17
      DataField = 'NomineeCount'
      DataSource = CORE.dsSession
      Enabled = False
    end
    object DBTextEntrants: TDBText
      Left = 189
      Top = 288
      Width = 30
      Height = 17
      DataField = 'EntrantCount'
      DataSource = CORE.dsSession
      Enabled = False
    end
    object lblEventCount: TLabel
      Left = 283
      Top = 288
      Width = 36
      Height = 21
      Caption = '0000'
      Enabled = False
    end
    object lblWeekCount: TLabel
      Left = 390
      Top = 288
      Width = 27
      Height = 21
      Caption = '000'
      Enabled = False
    end
    object btnToday: TButton
      Tag = 1
      Left = 164
      Top = 47
      Width = 93
      Height = 32
      Hint = 'Assign todays date to session.'
      Caption = 'Today'
      ImageIndex = 4
      ImageName = 'today'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnTodayClick
    end
    object btnDate: TButton
      Tag = 1
      Left = 263
      Top = 47
      Width = 121
      Height = 32
      Hint = 'Calendar style date picker.'
      Caption = 'Date Picker '
      ImageIndex = 1
      ImageName = 'pick-date'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnDateClick
    end
    object datePickerSess: TDatePicker
      Left = 8
      Top = 47
      Date = 45889.000000000000000000
      DateFormat = 'dd/mm/yyyy'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      TabOrder = 2
      OnChange = DTPickerSessChange
    end
    object timePickerSess: TTimePicker
      Left = 8
      Top = 141
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      TabOrder = 3
      Time = 44163.440787812500000000
      TimeFormat = 'h:mm AMPM'
      OnChange = DTPickerSessChange
    end
    object btnNow: TButton
      Tag = 1
      Left = 164
      Top = 143
      Width = 101
      Height = 32
      Hint = 'Assign the current hour.'
      Caption = 'This Hour'
      ImageIndex = 5
      ImageName = 'clock'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btnThisHourClick
    end
    object DBEdit1: TDBEdit
      Left = 8
      Top = 232
      Width = 649
      Height = 32
      Hint = 'Describe what this session is all about.'#13#10'(Used in search mode.)'
      AutoSize = False
      DataField = 'Caption'
      DataSource = CORE.dsSession
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 394
    Width = 672
    Height = 49
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 487
    object btnCancel: TButton
      Left = 236
      Top = 5
      Width = 90
      Height = 39
      Cancel = True
      Caption = 'Cancel'
      ImageIndex = 3
      ImageName = 'cancel-circle2'
      ModalResult = 2
      TabOrder = 0
      OnClick = btnCancelClick
    end
    object btnPost: TButton
      Left = 345
      Top = 5
      Width = 90
      Height = 39
      Caption = 'Post'
      Default = True
      ImageIndex = 2
      ImageName = 'post-circle2'
      ImageMargins.Left = 6
      ImageMargins.Right = -4
      ModalResult = 1
      TabOrder = 1
      OnClick = btnPostClick
    end
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 672
    Height = 57
    Align = alTop
    BevelEdges = [beBottom]
    BevelKind = bkFlat
    BevelOuter = bvNone
    TabOrder = 2
    object lblWeekNumber: TLabel
      Left = 8
      Top = 9
      Width = 105
      Height = 32
      Caption = 'SESSION :'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object spbtnAutoDT: TSpeedButton
      Left = 629
      Top = 9
      Width = 36
      Height = 36
      Hint = 'Auto assign date and time.'
      ImageIndex = 11
      ImageName = 'build'
      Images = IMG.imglstMiscButtons
      ParentShowHint = False
      ShowHint = True
      OnClick = spbtnAutoDTClick
    end
    object spbtnLockState: TSpeedButton
      Left = 503
      Top = 9
      Width = 36
      Height = 36
      Hint = 'Schedule the session.'
      ImageIndex = 14
      ImageName = 'lock-open'
      Images = IMG.imglstMiscButtons
      ParentShowHint = False
      ShowHint = True
      OnClick = spbtnLockStateClick
    end
    object spbtnSchedule: TSpeedButton
      Left = 587
      Top = 9
      Width = 36
      Height = 36
      Hint = 'Schedule the session.'
      ImageIndex = 12
      ImageName = 'schedule'
      Images = IMG.imglstMiscButtons
      ParentShowHint = False
      ShowHint = True
      OnClick = spbtnScheduleClick
    end
    object spbtnSeasonStart: TSpeedButton
      Left = 545
      Top = 9
      Width = 36
      Height = 36
      Hint = 'Schedule the session.'
      ImageIndex = 1
      ImageName = 'pick-date'
      Images = IMG.imglstMiscButtons
      ParentShowHint = False
      ShowHint = True
      OnClick = spbtnSeasonStartClick
    end
    object lblLongDate: TLabel
      Left = 119
      Top = 9
      Width = 210
      Height = 32
      Caption = 'LONG DATE STRING'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
end
