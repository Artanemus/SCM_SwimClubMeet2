object FindMember_Membership: TFindMember_Membership
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Goto member using membership number...'
  ClientHeight = 200
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 19
  object Panel1: TPanel
    Left = 0
    Top = 147
    Width = 432
    Height = 53
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnGoto: TButton
      Left = 91
      Top = 12
      Width = 250
      Height = 29
      Caption = 'Goto Membership Number'
      TabOrder = 0
      OnClick = btnGotoClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 432
    Height = 147
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 136
      Top = 41
      Width = 140
      Height = 19
      Caption = 'Enter Membership#'
    end
    object lblErrMsg: TLabel
      Left = 136
      Top = 84
      Width = 323
      Height = 19
      AutoSize = False
      Caption = 'The Membership number doesn'#39't exist.'
      WordWrap = True
    end
    object vimgMember: TVirtualImage
      Left = 25
      Top = 0
      Width = 105
      Height = 105
      ImageCollection = IMG.CollectionCore
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 73
      ImageName = 'user'
    end
    object vimgGoto: TVirtualImage
      Left = 40
      Top = 30
      Width = 105
      Height = 105
      ImageCollection = IMG.CollectionCore
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 110
      ImageName = 'goto'
    end
    object Edit1: TEdit
      Left = 285
      Top = 38
      Width = 74
      Height = 27
      NumbersOnly = True
      TabOrder = 0
      Text = 'Edit1'
      OnChange = Edit1Change
    end
  end
end
