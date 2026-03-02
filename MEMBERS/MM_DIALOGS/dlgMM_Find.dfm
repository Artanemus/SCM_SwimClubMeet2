object MM_Find: TMM_Find
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Manage Members - FIND...'
  ClientHeight = 307
  ClientWidth = 363
  Color = 752556
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  StyleElements = [seFont, seBorder]
  OnKeyDown = FormKeyDown
  TextHeight = 21
  object imgFind: TSVGIconImage
    Left = 88
    Top = 16
    Width = 36
    Height = 36
    AutoSize = False
    Opacity = 128
    ImageList = IMG.imglstMiscButtons
    ImageIndex = 8
    ImageName = 'search'
    Enabled = False
  end
  object lblFind: TLabel
    Left = 138
    Top = 12
    Width = 92
    Height = 45
    Caption = 'Find...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clCadetblue
    Font.Height = -32
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnGotoID: TButton
    Left = 16
    Top = 128
    Width = 321
    Height = 41
    Caption = 'Member'#39's ID'
    TabOrder = 1
    OnClick = btnGotoIDClick
  end
  object btnGotoMembershipNum: TButton
    Left = 16
    Top = 184
    Width = 321
    Height = 41
    Caption = 'Membership Number'
    TabOrder = 2
    OnClick = btnGotoMembershipNumClick
  end
  object btnFindFName: TButton
    Left = 16
    Top = 72
    Width = 321
    Height = 41
    Caption = 'Member by Name'
    Default = True
    TabOrder = 0
    OnClick = btnFindFNameClick
  end
  object btnCancel: TButton
    Left = 16
    Top = 240
    Width = 321
    Height = 41
    Caption = 'CANCEL (ESC)'
    TabOrder = 3
    OnClick = btnCancelClick
  end
end
