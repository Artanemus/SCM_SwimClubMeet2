object ReportManage: TReportManage
  Left = 0
  Top = 0
  Caption = 'ReportManage'
  ClientHeight = 683
  ClientWidth = 660
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 21
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 660
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 764
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 642
    Width = 660
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 764
  end
  object pnlBody: TPanel
    Left = 153
    Top = 41
    Width = 507
    Height = 601
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 611
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
        Control = spbtnSaveAs
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
      Caption = 'Save'
      ImageIndex = 7
      ImageName = 'download-file'
      Images = IMG.imglstReportCntrl
      Margin = 10
    end
    object spbtnSaveAs: TSpeedButton
      Left = 16
      Top = 323
      Width = 120
      Height = 48
      Caption = 'Save As'
      ImageIndex = 7
      ImageName = 'download-file'
      Images = IMG.imglstReportCntrl
      Margin = 10
    end
    object spbtnLoad: TSpeedButton
      Left = 16
      Top = 375
      Width = 120
      Height = 48
      Caption = 'Load'
      ImageIndex = 6
      ImageName = 'upload-file'
      Images = IMG.imglstReportCntrl
      Margin = 10
    end
  end
  object qryReport: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Active = True
    IndexFieldNames = 'ReportID'
    Connection = SCM2.scmConnection
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.Report'
    UpdateOptions.KeyFields = 'ReportID'
    SQL.Strings = (
      'USE [SwimClubMeet2];'
      ''
      'DECLARE @ReportGroupID AS INT;'
      ''
      'SET @ReportGroupID = :REPORTGROUPID;'
      ''
      'SELECT [Report].[ReportID],'
      '       [Report].[Caption],'
      '       [Report].[Description],'
      '       [Report].[IsActive],'
      '       [Report].[IsArchived],'
      '       [Report].[IsPrimary],'
      '       [Report].[CreatedOn],'
      '       [Report].[ModifiedOn],'
      '       [Report].[FilePath],'
      '       [Report].[FileName],'
      '       [Report].[Blob],'
      '       [Report].[ReportTypeID],'
      '       [Report].[ReportGroupID],'
      '       ReportType.CaptionShort AS ReportType,'
      '       ReportGroup.Caption AS ReportGroup'
      'FROM   [dbo].[Report]'
      '       LEFT OUTER JOIN'
      '       ReportType'
      '       ON [Report].ReportTypeID = ReportType.ReportTypeID'
      '       LEFT OUTER JOIN'
      '       ReportGroup'
      '       ON [Report].ReportGroupID = ReportGroup.ReportGroupID'
      'WHERE ( @ReportGroupID = 0 AND [Report].[ReportGroupID] > 0 )'
      
        '   OR ( @ReportGroupID <> 0 AND [Report].[ReportGroupID] = @Repo' +
        'rtGroupID );'
      ''
      ''
      '')
    Left = 264
    Top = 392
    ParamData = <
      item
        Name = 'REPORTGROUPID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 2
      end>
  end
  object dsReport: TDataSource
    DataSet = qryReport
    Left = 344
    Top = 392
  end
end
