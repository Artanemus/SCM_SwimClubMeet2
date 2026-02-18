object FindMember_ID: TFindMember_ID
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Goto member using member'#39's unique ID...'
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
    Top = 144
    Width = 432
    Height = 56
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnGoto: TButton
      Left = 124
      Top = 13
      Width = 184
      Height = 29
      Caption = 'Goto Member ID'
      TabOrder = 0
      OnClick = btnGotoClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 432
    Height = 144
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 142
      Top = 40
      Width = 131
      Height = 19
      Caption = 'Enter Member'#39's ID'
    end
    object lblErrMsg: TLabel
      Left = 142
      Top = 83
      Width = 263
      Height = 27
      AutoSize = False
      Caption = 'The member'#39's ID doesn'#39't exist.'
    end
    object vimgMember: TVirtualImage
      Left = 16
      Top = 5
      Width = 105
      Height = 105
      ImageCollection = IMG.CollectionCore
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 73
      ImageName = 'user'
    end
    object vimgGoto: TVirtualImage
      Left = 31
      Top = 35
      Width = 105
      Height = 105
      ImageCollection = IMG.CollectionCore
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 110
      ImageName = 'goto'
    end
    object Edit1: TEdit
      Left = 275
      Top = 37
      Width = 78
      Height = 27
      NumbersOnly = True
      TabOrder = 0
      Text = 'Edit1'
      OnChange = Edit1Change
    end
  end
end
