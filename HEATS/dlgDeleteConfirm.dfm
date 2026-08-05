object DeleteConfirm: TDeleteConfirm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Delete All Heats - Confirm.'
  ClientHeight = 140
  ClientWidth = 432
  Color = clBtnFace
  CustomTitleBar.Height = 32
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  GlassFrame.Top = 32
  KeyPreview = True
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  TextHeight = 21
  object pnlBody: TPanel
    Left = 0
    Top = 0
    Width = 432
    Height = 99
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblDeleteConfirm: TLabel
      Left = 55
      Top = 7
      Width = 321
      Height = 42
      Alignment = taCenter
      AutoSize = False
      Caption = 
        'Do you really want to delete ALL heats in the current selected e' +
        'vent?'
      WordWrap = True
    end
    object lblMsg: TLabel
      Left = 10
      Top = 55
      Width = 411
      Height = 21
      Caption = '(Closed or Raced heats are ignored and will not be deleted.)'
      Enabled = False
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 99
    Width = 432
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnYes: TButton
      Left = 223
      Top = 6
      Width = 85
      Height = 32
      Caption = 'Yes'
      ModalResult = 1
      TabOrder = 1
      OnClick = btnYesClick
    end
    object btnNo: TButton
      Left = 123
      Top = 6
      Width = 85
      Height = 32
      Caption = 'No'
      Default = True
      ModalResult = 7
      TabOrder = 0
      OnClick = btnNoClick
    end
  end
end
