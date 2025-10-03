object NewSession: TNewSession
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'New Session ...'
  ClientHeight = 288
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
    Top = 0
    Width = 590
    Height = 239
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 310
    object Label1: TLabel
      Left = 0
      Top = 164
      Width = 149
      Height = 21
      Caption = 'Session Description ...'
    end
    object Label2: TLabel
      Left = 0
      Top = 11
      Width = 89
      Height = 21
      Caption = 'Session Date'
    end
    object Label3: TLabel
      Left = 0
      Top = 89
      Width = 91
      Height = 21
      Caption = 'Session Time'
    end
    object spbtnPlus: TSpeedButton
      Left = 305
      Top = 115
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
      Left = 263
      Top = 115
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
      Left = 156
      Top = 38
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
      Left = 255
      Top = 38
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
      Left = 0
      Top = 38
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
      Left = 0
      Top = 116
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
      Left = 156
      Top = 118
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
      Left = 0
      Top = 191
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
    Top = 239
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
end
