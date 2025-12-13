object FindMember_FName: TFindMember_FName
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Find a Member...'
  ClientHeight = 530
  ClientWidth = 353
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 19
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 353
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object VirtualImage1: TVirtualImage
      Left = 8
      Top = 8
      Width = 34
      Height = 34
      ImageCollection = IMG.CollectionCore
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 67
      ImageName = 'search'
    end
    object vimgClear: TVirtualImage
      Left = 320
      Top = 8
      Width = 34
      Height = 34
      ImageCollection = IMG.CollectionCore
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 53
      ImageName = 'clear'
      OnClick = vimgClearClick
    end
    object Edit1: TEdit
      Left = 48
      Top = 12
      Width = 265
      Height = 27
      TabOrder = 0
      Text = 'Edit1'
      OnChange = Edit1Change
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 479
    Width = 353
    Height = 51
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      353
      51)
    object lblFound: TLabel
      Left = 8
      Top = 16
      Width = 55
      Height = 19
      Caption = 'Found :'
    end
    object btnGotoMember: TButton
      Left = 193
      Top = 10
      Width = 131
      Height = 30
      Anchors = [akTop, akRight]
      Caption = 'Goto Member'
      TabOrder = 0
      OnClick = btnGotoMemberClick
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 49
    Width = 353
    Height = 430
    Align = alClient
    DataSource = dsFindMember
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'MemberID'
        Title.Alignment = taCenter
        Visible = False
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'MembershipNum'
        Title.Alignment = taCenter
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'FName'
        Width = 300
        Visible = True
      end>
  end
  object qryFindMember: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    Active = True
    Filtered = True
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'MemberID'
    Connection = SCM2.scmConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    SQL.Strings = (
      'SELECT        '
      '   Member.MemberID'
      '   , Member.MembershipNum'
      '   , CONCAT(UPPER([LastName]), '#39', '#39', Member.FirstName ) AS FName'
      'FROM            '
      ' dbo.Member '
      'ORDER BY Member.LastName;')
    Left = 137
    Top = 168
  end
  object dsFindMember: TDataSource
    DataSet = qryFindMember
    Left = 233
    Top = 168
  end
end
