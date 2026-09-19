object ReportManage: TReportManage
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ReportManage'
  ClientHeight = 683
  ClientWidth = 696
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 21
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 696
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 642
    Width = 696
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
  end
  object pnlBody: TPanel
    Left = 153
    Top = 41
    Width = 543
    Height = 601
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
  end
  object spnlCNTRL: TStackPanel
    Left = 0
    Top = 41
    Width = 153
    Height = 601
    Align = alLeft
    ControlCollection = <
      item
        Control = spbtnEdit
      end
      item
        Control = spbtnNew
        HorizontalPositioning = sphpCenter
      end
      item
        Control = spbtnClone
      end
      item
        Control = spbtnArchive
      end
      item
        Control = spbtnDelete
        HorizontalPositioning = sphpCenter
      end
      item
        Control = spbtnSave
      end
      item
        Control = spbtnLoad
      end>
    HorizontalPositioning = sphpCenter
    Padding.Top = 10
    Spacing = 4
    TabOrder = 3
    object spbtnEdit: TSpeedButton
      Left = 16
      Top = 11
      Width = 120
      Height = 48
      Caption = 'Edit'
      ImageIndex = 0
      ImageName = 'edit'
      Images = IMG.imglstReportCntrl
      Margin = 10
    end
    object spbtnNew: TSpeedButton
      Left = 16
      Top = 63
      Width = 120
      Height = 48
      Caption = 'New'
      ImageIndex = 1
      ImageName = 'new'
      Images = IMG.imglstReportCntrl
      Margin = 10
    end
    object spbtnClone: TSpeedButton
      Left = 16
      Top = 115
      Width = 120
      Height = 48
      Caption = 'Clone'
      ImageIndex = 3
      ImageName = 'clone'
      Images = IMG.imglstReportCntrl
      Margin = 10
    end
    object spbtnArchive: TSpeedButton
      Left = 16
      Top = 167
      Width = 120
      Height = 48
      Caption = 'Archive'
      ImageIndex = 4
      ImageName = 'archive'
      Images = IMG.imglstReportCntrl
      Margin = 10
    end
    object spbtnDelete: TSpeedButton
      Left = 16
      Top = 219
      Width = 120
      Height = 48
      Caption = 'Delete'
      ImageIndex = 2
      ImageName = 'delete'
      Images = IMG.imglstReportCntrl
      Margin = 10
    end
    object spbtnSave: TSpeedButton
      Left = 16
      Top = 271
      Width = 120
      Height = 48
      Caption = 'Export'
      ImageIndex = 7
      ImageName = 'download-file'
      Images = IMG.imglstReportCntrl
      Margin = 10
    end
    object spbtnLoad: TSpeedButton
      Left = 16
      Top = 323
      Width = 120
      Height = 48
      Caption = 'Import'
      ImageIndex = 6
      ImageName = 'upload-file'
      Images = IMG.imglstReportCntrl
      Margin = 10
    end
  end
end
