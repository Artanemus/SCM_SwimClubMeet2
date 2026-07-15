object Preferences: TPreferences
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'SwimClubMeet Preferences...'
  ClientHeight = 501
  ClientWidth = 695
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  TextHeight = 21
  object Panel2: TPanel
    Left = 0
    Top = 453
    Width = 695
    Height = 48
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      695
      48)
    object btnClose: TButton
      Left = 584
      Top = 8
      Width = 101
      Height = 33
      Anchors = [akTop, akRight]
      Caption = 'Close'
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 695
    Height = 453
    ActivePage = TabSheet7
    Align = alClient
    TabOrder = 1
    object TabSheet2: TTabSheet
      Caption = 'TTB'
      object Label7: TLabel
        Left = 9
        Top = 205
        Width = 398
        Height = 21
        Caption = 'Should the algorithm not be able to calculate a TTB, then...'
      end
      object Label8: TLabel
        Left = 271
        Top = 272
        Width = 333
        Height = 21
        Caption = 'percent. (With consideration to age and gender.)'
      end
      object lbl2: TLabel
        Left = 9
        Top = 19
        Width = 143
        Height = 17
        Caption = 'Entrant'#39's Time To Beat.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
      end
      object lbl1: TLabel
        Left = 56
        Top = 272
        Width = 158
        Height = 21
        Caption = 'average of the bottom '
      end
      object prefAlgorithm: TRadioGroup
        Left = 9
        Top = 66
        Width = 544
        Height = 119
        Caption = 'Algorithm ... '
        ItemIndex = 1
        Items.Strings = (
          'Use the last known race time swum by the nominee.'
          
            'Find the average of the 3 fastest race times swum by the nominee' +
            '.'
          'Use the nominee'#39's personal best as the calculated race time.')
        TabOrder = 0
      end
      object prefcalcDefRT: TCheckBox
        Left = 38
        Top = 232
        Width = 531
        Height = 34
        Caption = 
          'Use the swim club'#39's historical data to calculate a TTB based on ' +
          'the mean'
        Checked = True
        State = cbChecked
        TabOrder = 1
        WordWrap = True
      end
      object prefcalcDefRTpercent: TSpinEdit
        Left = 220
        Top = 272
        Width = 45
        Height = 31
        MaxValue = 100
        MinValue = 0
        TabOrder = 2
        Value = 50
      end
    end
    object tab1: TTabSheet
      Caption = 'AutoBuild'
      ImageIndex = 2
      DesignSize = (
        687
        417)
      object lbl3: TLabel
        Left = 9
        Top = 19
        Width = 110
        Height = 17
        Caption = 'Auto-Build Heats.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
      end
      object infoBugAutoBuild: TSpeedButton
        Left = 139
        Top = 21
        Width = 33
        Height = 33
        Hint = 'Club Members'
        Anchors = [akTop, akRight]
        Flat = True
        Glyph.Data = {
          36090000424D3609000000000000360000002800000018000000180000000100
          2000000000000009000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000004000000330000
          005E000000790000008600000086000000790000005E00000033000000040000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000002F0000007C0000008A0000
          008A0000008A00000089000000890000008A0000008A0000008A0000007C0000
          002F000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000010000004D0000008A0000008A0000006D0000
          003400000011000000010000000100000011000000340000006D0000008A0000
          008A0000004D0000000100000000000000000000000000000000000000000000
          000000000000000000000000004D0000008A0000008500000036000000010000
          0000000000000000000000000000000000000000000000000001000000360000
          00850000008A0000004D00000000000000000000000000000000000000000000
          0000000000000000002F0000008A000000860000002300000000000000000000
          0000000000000000000200000002000000000000000000000000000000000000
          0023000000860000008A0000002F000000000000000000000000000000000000
          0000000000040000007C0000008A000000360000000000000000000000000000
          0000000000000000008800000088000000000000000000000000000000000000
          0000000000360000008A0000007C000000040000000000000000000000000000
          0000000000330000008A0000006D000000010000000000000000000000000000
          0000000000000000008800000088000000000000000000000000000000000000
          0000000000010000006D0000008A000000330000000000000000000000000000
          00000000005E0000008A00000034000000000000000000000000000000000000
          0000000000000000008800000088000000000000000000000000000000000000
          000000000000000000340000008A0000005E0000000000000000000000000000
          0000000000790000008A00000011000000000000000000000000000000000000
          0000000000000000008800000088000000000000000000000000000000000000
          000000000000000000110000008A000000790000000000000000000000000000
          0000000000860000008900000001000000000000000000000000000000000000
          0000000000000000008800000088000000000000000000000000000000000000
          0000000000000000000100000089000000860000000000000000000000000000
          0000000000860000008900000001000000000000000000000000000000000000
          0000000000000000008600000086000000000000000000000000000000000000
          0000000000000000000100000089000000860000000000000000000000000000
          0000000000790000008A00000011000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000110000008A000000790000000000000000000000000000
          00000000005E0000008A00000034000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000340000008A0000005E0000000000000000000000000000
          0000000000330000008A0000006D000000010000000000000000000000000000
          0000000000000000008800000088000000000000000000000000000000000000
          0000000000010000006D0000008A000000330000000000000000000000000000
          0000000000040000007C0000008A000000360000000000000000000000000000
          0000000000000000008800000088000000000000000000000000000000000000
          0000000000360000008A0000007C000000040000000000000000000000000000
          0000000000000000002F0000008A000000850000002300000000000000000000
          0000000000000000000200000002000000000000000000000000000000000000
          0023000000850000008A0000002F000000000000000000000000000000000000
          000000000000000000000000004D0000008A0000008600000036000000010000
          0000000000000000000000000000000000000000000000000001000000360000
          00860000008A0000004D00000000000000000000000000000000000000000000
          00000000000000000000000000010000004D0000008A0000008A0000006D0000
          003400000011000000010000000100000011000000340000006D0000008A0000
          008A0000004D0000000100000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000002F0000007C0000008A0000
          008A0000008A00000089000000890000008A0000008A0000008A0000007C0000
          002F000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000004000000330000
          005E000000790000008600000086000000790000005E00000033000000040000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Layout = blGlyphTop
        Margin = 0
        Visible = False
        OnMouseLeave = infoBugAutoBuildMouseLeave
      end
      object lblSeedDepth2: TLabel
        Left = 513
        Top = 298
        Width = 73
        Height = 21
        Caption = '(Default 3)'
      end
      object lblSeedDepth1: TLabel
        Left = 376
        Top = 298
        Width = 81
        Height = 21
        Caption = 'Seed depth:'
      end
      object lblSeedingDepthAll: TLabel
        Left = 376
        Top = 332
        Width = 185
        Height = 45
        AutoSize = False
        Caption = 'Use seed depth 0 to circle seed all heats.'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object lblListOfLanes: TLabel
        Left = 234
        Top = 100
        Width = 183
        Height = 17
        Caption = '(Use comma seperated values.)'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblBracketMsg: TLabel
        Left = 40
        Top = 284
        Width = 201
        Height = 39
        AutoSize = False
        Caption = 'SCM Divisions: 0-6, 7-8, 9-10, 11-12, 13-14, 15-16, Open'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object prefSeperateGender: TCheckBox
        Left = 9
        Top = 60
        Width = 163
        Height = 26
        Hint = 'Seperate male and female entrants.'
        Caption = 'Seperate gender.'
        TabOrder = 0
      end
      object prefGroupBy: TRadioGroup
        Left = 9
        Top = 147
        Width = 232
        Height = 131
        Hint = 'Broad categories that gather together entants.'
        Caption = 'Group entrants by ...'
        ItemIndex = 0
        Items.Strings = (
          'Don'#39't group.'
          'Custom divisions.'
          'SCM divisions.')
        TabOrder = 1
      end
      object prefSeedMethod: TRadioGroup
        Left = 344
        Top = 147
        Width = 264
        Height = 131
        Hint = 'Decides what lane an entrant is given.'
        Caption = 'Seed Method ...'
        ItemIndex = 0
        Items.Strings = (
          'Standard (default) seeding.'
          'Random seeding.'
          'Circle Seeding to depth.')
        TabOrder = 2
      end
      object prefSeedDepth: TSpinEdit
        Left = 466
        Top = 295
        Width = 41
        Height = 31
        MaxValue = 10
        MinValue = 0
        TabOrder = 3
        Value = 3
      end
      object prefExcludeLanes: TCheckBox
        Left = 9
        Top = 96
        Width = 117
        Height = 17
        Hint = 'Broken lane rope? Use this.'
        Caption = 'Exclude Lanes...'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
      end
      object prefListOfExcludeLanes: TEdit
        Left = 128
        Top = 94
        Width = 100
        Height = 29
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        TextHint = '1,8'
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'AGE'
      ImageIndex = 7
      DesignSize = (
        687
        417)
      object lblMembersAge: TLabel
        Left = 24
        Top = 16
        Width = 162
        Height = 21
        Caption = 'Member'#39's Age in Years.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object lblCustomDate: TLabel
        Left = 24
        Top = 199
        Width = 99
        Height = 21
        Caption = 'Custom Date...'
        Enabled = False
      end
      object spbtnMembersAge: TSpeedButton
        Left = 319
        Top = 51
        Width = 33
        Height = 33
        Hint = 
          'Member'#39's Age'#13#10'Start of swimming season. Assigned in Manage Swim ' +
          'Clubs. Each club has it own '#39'start of season'#39' date. '#13#10'Meet date.' +
          ' Swimming carnivals have multi-session over multi-days. Assigned' +
          ' in Schedule Meet. '#13#10'Session date. Assigned when creating a new ' +
          'session.'#13#10'Current date. Today'#39's date. With each new day, this da' +
          'te changes.'#13#10'Custom date. Pick you own date. This is a global va' +
          'lue and will be used by all swimming clubs.'
        CustomHint = BalloonHintPreferences
        ParentCustomHint = False
        Anchors = [akTop, akRight]
        Flat = True
        Glyph.Data = {
          36090000424D3609000000000000360000002800000018000000180000000100
          2000000000000009000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000004000000330000
          005E000000790000008600000086000000790000005E00000033000000040000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000002F0000007C0000008A0000
          008A0000008A00000089000000890000008A0000008A0000008A0000007C0000
          002F000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000010000004D0000008A0000008A0000006D0000
          003400000011000000010000000100000011000000340000006D0000008A0000
          008A0000004D0000000100000000000000000000000000000000000000000000
          000000000000000000000000004D0000008A0000008500000036000000010000
          0000000000000000000000000000000000000000000000000001000000360000
          00850000008A0000004D00000000000000000000000000000000000000000000
          0000000000000000002F0000008A000000860000002300000000000000000000
          0000000000000000000200000002000000000000000000000000000000000000
          0023000000860000008A0000002F000000000000000000000000000000000000
          0000000000040000007C0000008A000000360000000000000000000000000000
          0000000000000000008800000088000000000000000000000000000000000000
          0000000000360000008A0000007C000000040000000000000000000000000000
          0000000000330000008A0000006D000000010000000000000000000000000000
          0000000000000000008800000088000000000000000000000000000000000000
          0000000000010000006D0000008A000000330000000000000000000000000000
          00000000005E0000008A00000034000000000000000000000000000000000000
          0000000000000000008800000088000000000000000000000000000000000000
          000000000000000000340000008A0000005E0000000000000000000000000000
          0000000000790000008A00000011000000000000000000000000000000000000
          0000000000000000008800000088000000000000000000000000000000000000
          000000000000000000110000008A000000790000000000000000000000000000
          0000000000860000008900000001000000000000000000000000000000000000
          0000000000000000008800000088000000000000000000000000000000000000
          0000000000000000000100000089000000860000000000000000000000000000
          0000000000860000008900000001000000000000000000000000000000000000
          0000000000000000008600000086000000000000000000000000000000000000
          0000000000000000000100000089000000860000000000000000000000000000
          0000000000790000008A00000011000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000110000008A000000790000000000000000000000000000
          00000000005E0000008A00000034000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000340000008A0000005E0000000000000000000000000000
          0000000000330000008A0000006D000000010000000000000000000000000000
          0000000000000000008800000088000000000000000000000000000000000000
          0000000000010000006D0000008A000000330000000000000000000000000000
          0000000000040000007C0000008A000000360000000000000000000000000000
          0000000000000000008800000088000000000000000000000000000000000000
          0000000000360000008A0000007C000000040000000000000000000000000000
          0000000000000000002F0000008A000000850000002300000000000000000000
          0000000000000000000200000002000000000000000000000000000000000000
          0023000000850000008A0000002F000000000000000000000000000000000000
          000000000000000000000000004D0000008A0000008600000036000000010000
          0000000000000000000000000000000000000000000000000001000000360000
          00860000008A0000004D00000000000000000000000000000000000000000000
          00000000000000000000000000010000004D0000008A0000008A0000006D0000
          003400000011000000010000000100000011000000340000006D0000008A0000
          008A0000004D0000000100000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000002F0000007C0000008A0000
          008A0000008A00000089000000890000008A0000008A0000008A0000007C0000
          002F000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000004000000330000
          005E000000790000008600000086000000790000005E00000033000000040000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        Layout = blGlyphTop
        Margin = 0
        ParentShowHint = False
        ShowHint = True
        OnMouseLeave = spbtnMembersAgeMouseLeave
      end
      object rgrpMembersAge: TRadioGroup
        Left = 24
        Top = 43
        Width = 289
        Height = 126
        Caption = 'Age as of...'
        Items.Strings = (
          '31st December rule.'
          'The meet/session date.'
          'Custom date...')
        TabOrder = 0
      end
      object datePickerCustom: TDatePicker
        Left = 24
        Top = 226
        Date = 45889.000000000000000000
        DateFormat = 'dd/mm/yyyy'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        TabOrder = 1
      end
      object btnToday: TButton
        Tag = 1
        Left = 180
        Top = 226
        Width = 93
        Height = 32
        Hint = 'Assign todays date to custom.'
        Caption = 'Today'
        ImageIndex = 4
        ImageName = 'today'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btnTodayClick
      end
      object btnDate: TButton
        Tag = 1
        Left = 279
        Top = 226
        Width = 121
        Height = 32
        Hint = 'Calendar style date picker.'
        Caption = 'Date Picker '
        ImageIndex = 1
        ImageName = 'pick-date'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = btnDateClick
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Switches'
      ImageIndex = 6
      object prefEnableDQcodes: TCheckBox
        Left = 32
        Top = 27
        Width = 649
        Height = 54
        Caption = 
          'Enable World Aquatics disqualification codes. '#13#10'(Else use the si' +
          'mplified method of disqualification.)'
        TabOrder = 0
        OnClick = prefEnableDQcodesClick
      end
      object prefShowDebugInfo: TCheckBox
        Left = 32
        Top = 109
        Width = 633
        Height = 65
        Caption = 
          'Show Debug Information. '#13#10'(Reveals panels showing Primary Keys o' +
          'f selected Session, Event, Heats, etc.) '
        TabOrder = 1
        WordWrap = True
      end
      object CheckBox1: TCheckBox
        Left = 32
        Top = 272
        Width = 97
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 2
      end
      object prefVerbose: TCheckBox
        Left = 32
        Top = 208
        Width = 97
        Height = 17
        Caption = 'Verbose'
        TabOrder = 3
      end
    end
    object ts_Charts: TTabSheet
      Caption = 'Charts'
      ImageIndex = 4
      object Label19: TLabel
        Left = 112
        Top = 11
        Width = 294
        Height = 21
        Caption = 'Number of data points to display in charts.'
      end
      object Label20: TLabel
        Left = 112
        Top = 38
        Width = 430
        Height = 42
        Caption = 
          'Range: 10-1000. Default: 26. '#13#10'Typically: 1 unit = 1 club night.' +
          ' 26 units = 1 swimming season.'
        WordWrap = True
      end
      object prefMemberChartDataPoints: TEdit
        Left = 48
        Top = 8
        Width = 49
        Height = 29
        NumbersOnly = True
        TabOrder = 0
        Text = '26'
      end
    end
  end
  object BalloonHintPreferences: TBalloonHint
    Delay = 0
    Left = 516
    Top = 48
  end
end
