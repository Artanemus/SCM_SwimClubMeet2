object FrameNavEv: TFrameNavEv
  Left = 0
  Top = 0
  Width = 794
  Height = 98
  TabOrder = 0
  StyleElements = [seClient, seBorder]
  object rpnlBody: TRelativePanel
    Left = 0
    Top = 0
    Width = 794
    Height = 98
    ControlCollection = <
      item
        Control = spbtnNavLeft
        AlignBottomWithPanel = True
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = True
        AlignRightWithPanel = False
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = True
      end
      item
        Control = spbtnNavRight
        AlignBottomWithPanel = True
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = True
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = True
      end>
    Align = alClient
    BevelOuter = bvNone
    Caption = 'No swimming events to display.'
    TabOrder = 0
    DesignSize = (
      794
      98)
    object spbtnNavLeft: TSpeedButton
      Left = 0
      Top = 0
      Width = 48
      Height = 98
      Anchors = []
      ImageIndex = 8
      ImageName = 'arrow-left'
      Images = IMG.imglstEventCntrl
      OnClick = spbtnNavLeftClick
    end
    object spbtnNavRight: TSpeedButton
      Left = 746
      Top = 0
      Width = 48
      Height = 98
      Anchors = []
      ImageIndex = 9
      ImageName = 'arrow-right'
      Images = IMG.imglstEventCntrl
      OnClick = spbtnNavRightClick
    end
  end
  object scrBox: TScrollBox
    AlignWithMargins = True
    Left = 48
    Top = 0
    Width = 698
    Height = 98
    Margins.Left = 48
    Margins.Top = 0
    Margins.Right = 48
    Margins.Bottom = 0
    HorzScrollBar.Smooth = True
    HorzScrollBar.Size = 4
    HorzScrollBar.Style = ssFlat
    HorzScrollBar.ThumbSize = 10
    HorzScrollBar.Tracking = True
    VertScrollBar.Visible = False
    Align = alClient
    Anchors = []
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    UseWheelForScrolling = True
  end
end
