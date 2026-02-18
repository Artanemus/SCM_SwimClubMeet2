object MM_FilterByParam: TMM_FilterByParam
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Filter Members'
  ClientHeight = 151
  ClientWidth = 225
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  TextHeight = 21
  object grpF: TButtonGroup
    Left = 0
    Top = 0
    Width = 225
    Height = 151
    Align = alClient
    ButtonHeight = 34
    ButtonOptions = [gboFullSize, gboShowCaptions]
    Images = imglstFilterParam
    Items = <
      item
        Caption = 'Hide Archived Members'
        ImageIndex = 0
        ImageName = 'checkbox-blank'
        OnClick = actnHideArchivedExecute
      end
      item
        Caption = 'Hide In-Active Members'
        ImageIndex = 0
        ImageName = 'checkbox-blank'
        OnClick = actnHideInActiveExecute
      end
      item
        Caption = 'Hide Non Swimmers'
        ImageIndex = 0
        ImageName = 'checkbox-blank'
        OnClick = actnHideNonSwimmerExecute
      end
      item
        Caption = 'Clear All Filters'
        ImageIndex = 4
        ImageName = 'filter-off'
        OnClick = actnClearExecute
      end>
    TabOrder = 0
    ExplicitWidth = 260
    ExplicitHeight = 174
  end
  object imglstFilterParam: TSVGIconVirtualImageList
    Images = <
      item
        CollectionIndex = 43
        CollectionName = 'checkbox-blank'
        Name = 'checkbox-blank'
      end
      item
        CollectionIndex = 44
        CollectionName = 'checkbox'
        Name = 'checkbox'
      end
      item
        CollectionIndex = 50
        CollectionName = 'out'
        Name = 'out'
      end
      item
        CollectionIndex = 113
        CollectionName = 'filter'
        Name = 'filter'
      end
      item
        CollectionIndex = 114
        CollectionName = 'filter-off'
        Name = 'filter-off'
      end>
    ImageCollection = IMG.CollectionCore
    Width = 32
    Height = 32
    Size = 32
    Left = 133
    Top = 19
  end
end
