object EditSession: TEditSession
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Edit Session ...'
  ClientHeight = 410
  ClientWidth = 590
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
    Width = 590
    Height = 304
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 0
    ExplicitHeight = 310
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
      ImageIndex = 7
      ImageName = 'plus-box'
      Images = IMG.imglstMiscButtons
      PressedImageIndex = 10
      PressedImageName = 'plus-box_Disabled'
      OnClick = btnPlusClick
    end
    object spbtnMinus: TSpeedButton
      Left = 271
      Top = 140
      Width = 36
      Height = 36
      ImageIndex = 6
      ImageName = 'minus-box'
      Images = IMG.imglstMiscButtons
      PressedImageIndex = 9
      PressedImageName = 'minus-box_Disabled'
      OnClick = btnMinusClick
    end
    object btnToday: TButton
      Tag = 1
      Left = 164
      Top = 47
      Width = 93
      Height = 32
      Hint = 'Clear the house name.'
      Caption = 'Today'
      ImageIndex = 4
      ImageName = 'today'
      TabOrder = 0
      OnClick = btnTodayClick
    end
    object btnDate: TButton
      Tag = 1
      Left = 263
      Top = 47
      Width = 121
      Height = 32
      Hint = 'Clear the house name.'
      Caption = 'Date Picker '
      ImageIndex = 1
      ImageName = 'pick-date'
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
    end
    object btnNow: TButton
      Tag = 1
      Left = 164
      Top = 143
      Width = 101
      Height = 32
      Hint = 'Clear the house name.'
      Caption = 'This Hour'
      ImageIndex = 5
      ImageName = 'clock'
      TabOrder = 4
      OnClick = btnNowClick
    end
    object DBEdit1: TDBEdit
      Left = 8
      Top = 232
      Width = 569
      Height = 32
      AutoSize = False
      DataField = 'Caption'
      DataSource = CORE.dsSession
      TabOrder = 5
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 361
    Width = 590
    Height = 49
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 310
    object btnCancel: TButton
      Left = 213
      Top = 6
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
      Left = 322
      Top = 6
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
    Width = 590
    Height = 57
    Align = alTop
    BevelEdges = [beBottom]
    BevelKind = bkFlat
    BevelOuter = bvSpace
    TabOrder = 2
    object lblWeekNumber: TLabel
      Left = 8
      Top = 9
      Width = 209
      Height = 32
      Caption = 'SESSION - Week 10'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object spbtnAutoDT: TSpeedButton
      Left = 541
      Top = 5
      Width = 36
      Height = 36
      Hint = 'Auto assign date and time.'
      ImageIndex = 11
      ImageName = 'build'
      Images = IMG.imglstMiscButtons
      OnClick = spbtnAutoDTClick
    end
    object spbtnLockState: TSpeedButton
      Left = 415
      Top = 5
      Width = 36
      Height = 36
      Hint = 'Schedule the session.'
      ImageIndex = 14
      ImageName = 'lock-open'
      Images = IMG.imglstMiscButtons
      OnClick = spbtnLockStateClick
    end
    object spbtnSchedule: TSpeedButton
      Left = 499
      Top = 5
      Width = 36
      Height = 36
      Hint = 'Schedule the session.'
      ImageIndex = 12
      ImageName = 'schedule'
      Images = IMG.imglstMiscButtons
      OnClick = spbtnScheduleClick
    end
    object spbtnSeasonStart: TSpeedButton
      Left = 457
      Top = 5
      Width = 36
      Height = 36
      Hint = 'Schedule the session.'
      ImageIndex = 1
      ImageName = 'pick-date'
      Images = IMG.imglstMiscButtons
      OnClick = spbtnSeasonStartClick
    end
  end
end
