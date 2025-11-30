object SwimClub_Reports: TSwimClub_Reports
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Swimming Club Reports...'
  ClientHeight = 414
  ClientWidth = 741
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 21
  object Label20: TLabel
    Left = 257
    Top = 157
    Width = 253
    Height = 25
    Caption = ' Swimming Club Members ...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object Label9: TLabel
    Left = 257
    Top = 293
    Width = 449
    Height = 42
    Caption = 'Prepare a compact list of club members. '
    WordWrap = True
  end
  object Label17: TLabel
    Left = 258
    Top = 240
    Width = 448
    Height = 42
    AutoSize = False
    Caption = 'Prepare a detailed report of all the club members.'
    WordWrap = True
  end
  object Label16: TLabel
    Left = 258
    Top = 188
    Width = 447
    Height = 42
    AutoSize = False
    Caption = 'Prepare a summary of all the club members (3 columns per page).'
    WordWrap = True
  end
  object lblDashboard: TLabel
    Left = 257
    Top = 20
    Width = 447
    Height = 42
    AutoSize = False
    Caption = 'Print the club'#39's dashboard to a image file.'
    WordWrap = True
  end
  object btnClubMembersSummary: TButton
    Left = 18
    Top = 188
    Width = 218
    Height = 38
    Caption = 'Club Members Summary'
    TabOrder = 0
    OnClick = btnClubMembersSummaryClick
  end
  object btnClubMembersList: TButton
    Left = 18
    Top = 284
    Width = 218
    Height = 38
    Caption = 'Club Members List'
    TabOrder = 1
    OnClick = btnClubMembersListClick
  end
  object btnClubMembersDetailed: TButton
    Left = 18
    Top = 240
    Width = 218
    Height = 38
    Caption = 'Club Members Detailed'
    TabOrder = 2
    OnClick = btnClubMembersDetailedClick
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 360
    Width = 741
    Height = 54
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object btnClose: TButton
      Left = 666
      Top = 9
      Width = 75
      Height = 32
      Caption = 'Close'
      TabOrder = 0
    end
  end
  object btnClub_Dashboard: TButton
    Left = 17
    Top = 20
    Width = 218
    Height = 38
    Caption = 'Dashboard'
    Enabled = False
    TabOrder = 4
    OnClick = btnClubMembersSummaryClick
  end
end
