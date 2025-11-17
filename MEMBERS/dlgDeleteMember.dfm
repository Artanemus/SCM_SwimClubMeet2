object DeleteMember: TDeleteMember
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Delete Member'
  ClientHeight = 391
  ClientWidth = 544
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 21
  object RelativePanel1: TRelativePanel
    Left = 0
    Top = 0
    Width = 544
    Height = 328
    ControlCollection = <
      item
        Control = VirtualImage1
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = True
        AlignRightWithPanel = False
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = False
      end
      item
        Control = lblTitle
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWith = VirtualImage1
        AlignVerticalCenterWithPanel = False
      end
      item
        Control = lblDetails
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWith = lblTitle
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = False
        Below = lblTitle
      end
      item
        Control = VirtualImage2
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = False
      end
      item
        Control = lblDetailEx
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWith = VirtualImage2
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = False
      end
      item
        Control = vimgWarningTape
        AlignBottomWithPanel = True
        AlignHorizontalCenterWithPanel = True
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = False
      end
      item
        Control = vimgWarningTapeTop
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = True
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = False
      end>
    BevelEdges = []
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      544
      328)
    object VirtualImage1: TVirtualImage
      AlignWithMargins = True
      Left = 20
      Top = 40
      Width = 105
      Height = 105
      Margins.Left = 20
      Margins.Top = 40
      Anchors = []
      ImageCollection = IMG.CollectionCore
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 73
      ImageName = 'user'
    end
    object lblTitle: TLabel
      Left = 152
      Top = 67
      Width = 369
      Height = 50
      Anchors = []
      AutoSize = False
      Caption = 'Delete member from database ?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object lblDetails: TLabel
      Left = 152
      Top = 117
      Width = 231
      Height = 21
      Anchors = []
      Caption = 'All member'#39's history will be lost! '
      WordWrap = True
    end
    object VirtualImage2: TVirtualImage
      AlignWithMargins = True
      Left = 20
      Top = 172
      Width = 105
      Height = 105
      Margins.Left = 20
      Margins.Top = 20
      Anchors = []
      ImageCollection = IMG.CollectionCore
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 111
      ImageName = 'warning-triangle'
    end
    object lblDetailEx: TLabel
      Left = 152
      Top = 172
      Width = 313
      Height = 84
      Anchors = []
      Caption = 
        'Remove contact numbers, team and indivual entrant data,  team an' +
        'd indivual nominations, sessions attendance, events swum and rac' +
        'e times!'
      WordWrap = True
    end
    object vimgWarningTape: TVirtualImage
      Left = 0
      Top = 302
      Width = 544
      Height = 26
      Align = alBottom
      ImageCollection = IMG.CollectionCore
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 112
      ImageName = 'Warning_Tape'
      Proportional = False
    end
    object vimgWarningTapeTop: TVirtualImage
      Left = 0
      Top = 0
      Width = 544
      Height = 26
      Align = alBottom
      ImageCollection = IMG.CollectionCore
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 112
      ImageName = 'Warning_Tape'
      Proportional = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 328
    Width = 544
    Height = 63
    Align = alBottom
    BevelEdges = [beTop]
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      544
      63)
    object btnYes: TButton
      Left = 181
      Top = 17
      Width = 80
      Height = 28
      Anchors = []
      Caption = 'Yes'
      ModalResult = 6
      TabOrder = 0
      OnClick = btnYesClick
      ExplicitTop = 16
    end
    object btnNo: TButton
      Left = 283
      Top = 17
      Width = 80
      Height = 28
      Anchors = []
      Caption = 'No'
      Default = True
      ModalResult = 7
      TabOrder = 1
      OnClick = btnNoClick
      ExplicitTop = 16
    end
  end
end
