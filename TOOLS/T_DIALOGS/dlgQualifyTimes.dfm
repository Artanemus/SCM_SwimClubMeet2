object QualifyTimes: TQualifyTimes
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Qualification Times...'
  ClientHeight = 768
  ClientWidth = 725
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 21
  object pgcntrlMain: TPageControl
    Left = 0
    Top = 0
    Width = 725
    Height = 727
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Setup'
      object tabCntrl: TTabControl
        AlignWithMargins = True
        Left = 3
        Top = 10
        Width = 711
        Height = 159
        Margins.Top = 10
        Align = alTop
        Style = tsButtons
        TabOrder = 0
        Tabs.Strings = (
          'SC'
          'LC'
          'SCY'
          'LCY'
          'CC')
        TabIndex = 1
        OnChange = tabCntrlChange
        object lblCourseDescription: TLabel
          Left = 4
          Top = 35
          Width = 173
          Height = 21
          Caption = 'Qualification Times for ....'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
        end
        object Panel3: TPanel
          Left = 4
          Top = 62
          Width = 703
          Height = 93
          Align = alBottom
          BevelEdges = [beBottom]
          BevelKind = bkFlat
          BevelOuter = bvNone
          TabOrder = 0
          object Label4: TLabel
            Left = 26
            Top = 18
            Width = 62
            Height = 63
            Alignment = taCenter
            Caption = 'The'#13#10'QUALIFY'#13#10'distance.'
            WordWrap = True
          end
          object Label5: TLabel
            Left = 226
            Top = 18
            Width = 60
            Height = 63
            Alignment = taCenter
            Caption = 'The'#13#10'TRIAL'#13#10'distance.'
            WordWrap = True
          end
          object Label6: TLabel
            Left = 530
            Top = 18
            Width = 133
            Height = 63
            Alignment = taCenter
            Caption = 'The TIME the TRIAL distance must be completed in.'
            WordWrap = True
          end
          object Label7: TLabel
            Left = 120
            Top = 18
            Width = 79
            Height = 63
            Alignment = taCenter
            Caption = 'QUALIFY'#13#10'Swimming '#13#10'Stroke'
            WordWrap = True
          end
          object Label8: TLabel
            Left = 443
            Top = 60
            Width = 51
            Height = 21
            Alignment = taCenter
            Caption = 'Gender'
            WordWrap = True
          end
          object lblTrialStroke: TLabel
            Left = 306
            Top = 18
            Width = 73
            Height = 63
            Alignment = taCenter
            Caption = 'TRIAL swimming stroke.'
            WordWrap = True
          end
        end
      end
      object Grid: TDBAdvGrid
        Left = 0
        Top = 172
        Width = 717
        Height = 519
        Cursor = crDefault
        Align = alClient
        Color = clWhite
        ColCount = 7
        DefaultRowHeight = 32
        DrawingStyle = gdsClassic
        FixedColor = clWhite
        RowCount = 2
        FixedRows = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        Options = [goVertLine, goHorzLine, goRangeSelect, goEditing, goFixedRowDefAlign]
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 1
        OnGetEditMask = GridGetEditMask
        OnGetEditText = GridGetEditText
        GridLineColor = 15987699
        GridFixedLineColor = 15987699
        HoverRowCells = [hcNormal, hcSelected]
        OnGetEditorType = GridGetEditorType
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = 4474440
        ActiveCellFont.Height = -12
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
        ActiveCellColor = 11565130
        ActiveCellColorTo = 11565130
        BorderColor = 11250603
        ControlLook.FixedGradientFrom = clWhite
        ControlLook.FixedGradientTo = clWhite
        ControlLook.FixedGradientMirrorFrom = clWhite
        ControlLook.FixedGradientMirrorTo = clWhite
        ControlLook.FixedGradientHoverFrom = clGray
        ControlLook.FixedGradientHoverTo = clWhite
        ControlLook.FixedGradientHoverMirrorFrom = clWhite
        ControlLook.FixedGradientHoverMirrorTo = clWhite
        ControlLook.FixedGradientHoverBorder = 11645361
        ControlLook.FixedGradientDownFrom = clWhite
        ControlLook.FixedGradientDownTo = clWhite
        ControlLook.FixedGradientDownMirrorFrom = clWhite
        ControlLook.FixedGradientDownMirrorTo = clWhite
        ControlLook.FixedGradientDownBorder = 11250603
        ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
        ControlLook.DropDownHeader.Font.Color = clWindowText
        ControlLook.DropDownHeader.Font.Height = -12
        ControlLook.DropDownHeader.Font.Name = 'Tahoma'
        ControlLook.DropDownHeader.Font.Style = []
        ControlLook.DropDownHeader.Visible = True
        ControlLook.DropDownHeader.Buttons = <>
        ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
        ControlLook.DropDownFooter.Font.Color = clWindowText
        ControlLook.DropDownFooter.Font.Height = -12
        ControlLook.DropDownFooter.Font.Name = 'Segoe UI'
        ControlLook.DropDownFooter.Font.Style = []
        ControlLook.DropDownFooter.Visible = True
        ControlLook.DropDownFooter.Buttons = <>
        Filter = <>
        FilterDropDown.Font.Charset = DEFAULT_CHARSET
        FilterDropDown.Font.Color = clWindowText
        FilterDropDown.Font.Height = -12
        FilterDropDown.Font.Name = 'Segoe UI'
        FilterDropDown.Font.Style = []
        FilterDropDown.TextChecked = 'Checked'
        FilterDropDown.TextUnChecked = 'Unchecked'
        FilterDropDownClear = '(All)'
        FilterEdit.TypeNames.Strings = (
          'Starts with'
          'Ends with'
          'Contains'
          'Not contains'
          'Equal'
          'Not equal'
          'Larger than'
          'Smaller than'
          'Clear')
        FixedColWidth = 20
        FixedRowHeight = 0
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clBlack
        FixedFont.Height = -12
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = [fsBold]
        FloatFormat = '%.2f'
        HoverButtons.Buttons = <>
        HoverButtons.Position = hbLeftFromColumnLeft
        HTMLSettings.ImageFolder = 'images'
        HTMLSettings.ImageBaseName = 'img'
        Look = glCustom
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -12
        PrintSettings.Font.Name = 'Segoe UI'
        PrintSettings.Font.Style = []
        PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
        PrintSettings.FixedFont.Color = clWindowText
        PrintSettings.FixedFont.Height = -12
        PrintSettings.FixedFont.Name = 'Segoe UI'
        PrintSettings.FixedFont.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -12
        PrintSettings.HeaderFont.Name = 'Segoe UI'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -12
        PrintSettings.FooterFont.Name = 'Segoe UI'
        PrintSettings.FooterFont.Style = []
        PrintSettings.PageNumSep = '/'
        SearchFooter.ColorTo = clWhite
        SearchFooter.FindNextCaption = 'Find &next'
        SearchFooter.FindPrevCaption = 'Find &previous'
        SearchFooter.Font.Charset = DEFAULT_CHARSET
        SearchFooter.Font.Color = clWindowText
        SearchFooter.Font.Height = -12
        SearchFooter.Font.Name = 'Segoe UI'
        SearchFooter.Font.Style = []
        SearchFooter.HighLightCaption = 'Highlight'
        SearchFooter.HintClose = 'Close'
        SearchFooter.HintFindNext = 'Find next occurrence'
        SearchFooter.HintFindPrev = 'Find previous occurrence'
        SearchFooter.HintHighlight = 'Highlight occurrences'
        SearchFooter.MatchCaseCaption = 'Match case'
        SearchFooter.ResultFormat = '(%d of %d)'
        SelectionColor = 13744549
        SortSettings.DefaultFormat = ssAutomatic
        SortSettings.HeaderColor = clWhite
        SortSettings.HeaderColorTo = clWhite
        SortSettings.HeaderMirrorColor = clWhite
        SortSettings.HeaderMirrorColorTo = clWhite
        Version = '2.5.1.3'
        AutoCreateColumns = True
        AutoRemoveColumns = True
        Columns = <
          item
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = clWindow
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = []
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 3881787
            HeaderFont.Height = -12
            HeaderFont.Name = 'Segoe UI'
            HeaderFont.Style = []
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -12
            PrintFont.Name = 'Segoe UI'
            PrintFont.Style = []
            Width = 20
          end
          item
            Alignment = taCenter
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = clWindow
            EditLength = 20
            FieldName = 'luQDistance'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = []
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 3881787
            HeaderFont.Height = -12
            HeaderFont.Name = 'Segoe UI'
            HeaderFont.Style = []
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -12
            PrintFont.Name = 'Segoe UI'
            PrintFont.Style = []
            Width = 90
          end
          item
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = clWindow
            EditLength = 20
            FieldName = 'luQStroke'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = []
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 3881787
            HeaderFont.Height = -12
            HeaderFont.Name = 'Segoe UI'
            HeaderFont.Style = []
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -12
            PrintFont.Name = 'Segoe UI'
            PrintFont.Style = []
            Width = 110
          end
          item
            Alignment = taCenter
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = clWindow
            EditLength = 20
            FieldName = 'luTDistance'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = []
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 3881787
            HeaderFont.Height = -12
            HeaderFont.Name = 'Segoe UI'
            HeaderFont.Style = []
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -12
            PrintFont.Name = 'Segoe UI'
            PrintFont.Style = []
            Width = 90
          end
          item
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = clWhite
            FieldName = 'luTStroke'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = []
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = clBlack
            HeaderFont.Height = -16
            HeaderFont.Name = 'Segoe UI'
            HeaderFont.Style = []
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clBlack
            PrintFont.Height = -16
            PrintFont.Name = 'Segoe UI'
            PrintFont.Style = []
            Width = 110
          end
          item
            Alignment = taCenter
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = clWindow
            EditLength = 20
            FieldName = 'luGender'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = []
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 3881787
            HeaderFont.Height = -12
            HeaderFont.Name = 'Segoe UI'
            HeaderFont.Style = []
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -12
            PrintFont.Name = 'Segoe UI'
            PrintFont.Style = []
            Width = 90
          end
          item
            Alignment = taCenter
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = clWindow
            EditMask = '!00:00.000;1;0'
            FieldName = 'TrialTime'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = []
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 3881787
            HeaderFont.Height = -12
            HeaderFont.Name = 'Segoe UI'
            HeaderFont.Style = []
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -12
            PrintFont.Name = 'Segoe UI'
            PrintFont.Style = []
            Width = 160
          end>
        DataSource = DSQualify
        InvalidPicture.Data = {
          055449636F6E0000010001002020200000000000A81000001600000028000000
          2000000040000000010020000000000000100000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000006A6A6B256A6A6B606A6A6B946A6A6BC06A6A6BE1
          6A6A6BF86A6A6BF86A6A6BE16A6A6BC06A6A6B946A6A6B606A6A6B2500000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000006A6A6B407575769E787879F19F9F9FF6C0C0C0FDDADADAFFEDEDEEFF
          FBFBFBFFFBFBFBFFEDEDEEFFDADADAFFC0C0C0FD9F9F9FF6787879F17575769E
          6A6A6B4000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000000000000006A6A6B22
          7C7C7C98888889F0BDBDBDFCE9E9EBFED9D9E9FEB5B5DDFE8B8BCDFE595AB7FF
          3739A8FF2B2CA4FF4A49B1FF7171C1FFA1A2D7FFD3D3E8FFEAEAEBFEBEBEBFFC
          888889F07C7C7C986A6A6B220000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000006A6A6B43838383D8
          B7B7B8FAECECEFFEC0C0DFFF7977C4FF2221A0FF12129BFF1010A4FF0C0CA8FF
          0A0AACFF0A0AB4FF0A0AB9FF0D0DBEFF0F0FB1FF1111A6FF5656B8FFAEADDCFF
          ECECEFFEB7B7B8FA838383D86A6A6B4300000000000000000000000000000000
          00000000000000000000000000000000000000006A6A6B4E878788EAD3D3D3FE
          CACAE8FF4443B0FF171799FF11119CFF0C0C98FF0B0B9BFF0B0BA0FF0A0AA6FF
          0909ACFF0909B2FF0808BAFF0707BFFF0B09C8FF0D0DCEFF1111CCFF1010AFFF
          4A49B2FFCFCFEBFFD3D3D3FE878788EA6A6A6B4E000000000000000000000000
          000000000000000000000000000000006A6A6B43878788EAE1E1E1FFA8A8DAFF
          2323A0FF15159CFF0D0D92FF0C0C95FF0C0C99FF0B0B9EFF0B0BA0FF0A0AA6FF
          0909ACFF0909B2FF0808B8FF0808BCFF0808C3FF0C0CC9FF0C0CD0FF0D0DD6FF
          1313CFFF2222A9FFAFAFDEFFE1E1E1FF878788EA6A6A6B430000000000000000
          0000000000000000000000006A6A6B22838383D8D3D3D3FEA8A8D9FF2020A4FF
          13139BFF0C0C92FF0C0C95FF0C0C97FF0C0C99FF0B0B9EFF0B0BA0FF0A0AA4FF
          0A0AA9FF0909B0FF0808B4FF0808BBFF0707C0FF0A0AC6FF0909CCFF0C0CD3FF
          0D0DD8FF1313D3FF1A1AA8FFAEADDEFFD4D4D4FE838383D86A6A6B2200000000
          0000000000000000000000007C7C7C98B7B7B8FACACAE8FF2524A3FF13139FFF
          0C0C97FF0C0C95FF0C0C95FF0C0C91FF0C0C95FF0B0B9EFF0B0BA0FF0A0AA4FF
          0A0AA8FF0909ADFF0909B2FF0808B8FF0808BCFF0707C0FF0808BCFF0707C5FF
          0C0CD3FF0D0DD7FF1212D1FF2020A7FFCDCDEBFFB8B8B9FA7C7C7C9800000000
          00000000000000006A6A6B40888889F0ECECEFFE4545B1FF1616A4FF0B0B9BFF
          0C0C99FF0C0C96FF3333A2FFB9B9D0FF393A9BFF0C0C95FF0B0BA1FF0A0AA4FF
          0A0AA7FF0A0AABFF0909B0FF0808B4FF0808B7FF2F2FC2FFAEAEE2FF4B4BBFFF
          0707BEFF0B0BD1FF0C0CD3FF1413CCFF4848B1FFECECEFFE888889F06A6A6B40
          00000000000000007575769EBFBFBFFD9B9BD5FF1C1CA6FF0C0CA1FF0B0B9FFF
          0B0B9AFF3535A7FFB5B5BEFFE6E6DFFFEDEDEFFF3C3C9CFF0C0C97FF0A0AA4FF
          0A0AA6FF0A0AA9FF0909ADFF0909B0FF2626B5FFCECEDEFFFFFFFBFFEEEEF1FF
          4848BAFF0808BCFF0A0ACDFF0B0BCEFF1111ABFFBEC0E0FFBFC0BFFD7575769E
          000000006A6A6B25787879F1E3E3E5FE4646B2FF1414A8FF0A0AA4FF0B0BA0FF
          2121A9FFBDBDCAFFD0D0C8FFC5C5C5FFE3E3E1FFEDEDEFFF3E3E9EFF0C0C98FF
          0A0AA6FF0A0AA8FF0A0AA9FF2B2BB0FFC0C0CDFFEAEAE2FFEBEBEBFFFEFEF8FF
          EDEDEEFF2828BDFF0707C4FF0809C7FF0F0FC4FF8788CBFFEBEBECFE79797AF1
          6A6A6B256A6A6B609D9E9DF6D6D7E4FF3A3AB3FF1212ADFF0A0AA8FF0A0AA4FF
          1313AAFFABABCFFFD6D6CBFFCACACAFFC6C6C6FFE4E4E0FFEEEEEFFF3F3FA0FF
          0C0C99FF0A0AA6FF2828ABFFB2B2BFFFD8D8CEFFD6D6D8FFE0E0E0FFF6F5EDFF
          D1D1EDFF1E1CC0FF0707BEFF0707BFFF0707C0FF2120AAFFD3D5E9FE9FA0A0F6
          6A6A6B606A6A6B94BDBDBDFBBABBDCFF3A39B7FF2F2FB8FF0909ADFF0A0AA9FF
          0A0AA6FF1515ACFFADADCFFFD6D6CBFFCBCBCAFFC6C6C6FFE4E4E1FFEEEEEFFF
          3838A1FF2222A2FFACABB8FFC8C8C0FFC7C7C8FFCDCDCDFFE1E1D9FFC8CAE1FF
          2424BCFF0808B4FF0808B9FF0808BAFF0808BBFF0F0EABFFA1A2D5FEC0C0C0FC
          6A6A6B946A6A6BC0D9D8D7FE9999D1FF3838BBFF3636BCFF2C2CB7FF0909ADFF
          0A0AA9FF0A0AA4FF1C1CAFFFB1B1CFFFD6D6CBFFCCCCCBFFC7C7C7FFE4E4E1FF
          ECECEEFFACACB7FFC2C2BCFFBEBEBFFFC0C0C0FFCFCFC6FFC1C1D5FF2727B8FF
          0909ACFF0909B2FF0909B2FF0909B4FF0808B4FF0E0EB5FF6E6EBFFFD9D9D9FE
          6A6A6BC06A6A6BE1EBEAEBFF7D7CC7FF3838BFFF3434BEFF3536BEFF2A2AB8FF
          0909B0FF0909ACFF0A0AA8FF1C1CB1FFB2B2D0FFD7D7CCFFCBCBCBFFC7C7C8FF
          C8C8C3FFC6C6C3FFBFBFC1FFBDBDBDFFC5C5BCFFB8B8CEFF2929B5FF0A0AA8FF
          0909ACFF0909ADFF0909AFFF0909AFFF0909AFFF0C0CB0FF4747AFFFECECEDFF
          6A6A6BE16A6A6BF8F9F9F9FF6666C1FF3838C4FF3535C2FF3434C0FF3535BEFF
          3030BCFF1313B4FF0909ADFF0A0AA8FF1E1EB3FFAAAAD0FFD3D3CDFFCCCCCCFF
          C8C8C8FFC3C3C3FFC2C2C1FFC4C4BFFFB2B2CBFF2B2BB4FF0A0AA4FF0A0AA8FF
          0A0AA8FF0A0AA9FF0A0AA9FF0A0AA9FF0A0AA9FF0B0BA9FF3131A6FFFAFAFAFF
          6A6A6BF86A6A6BF8FBFBFBFF5959BEFF3B3BCAFF3A3AC8FF3737C4FF3535C2FF
          3636C0FF3636BEFF2323B8FF0909B1FF0A0AA7FF4949BEFFD6D6D4FFD3D3D1FF
          CDCDCDFFC8C8C8FFC4C4C3FFEDEDEDFF5F5FB3FF0C0C98FF0A0AA7FF0A0AA6FF
          0A0AA6FF0A0AA6FF0A0AA4FF0A0AA6FF0A0AA4FF0B0BA4FF2D2DA6FFFBFBFBFF
          6A6A6BF86A6A6BE1EDEDEEFF7F80CBFF4041CCFF3C3CCAFF3A3AC8FF383AC8FF
          3838C4FF3636C2FF3939C0FF2123B7FF4A4AC2FFCBCBDEFFE0E0DCFFD6D6D6FF
          D2D2D3FFCDCDCEFFC9C9C9FFE2E2E1FFF1F1F2FF4242A3FF0C0C99FF0A0AA4FF
          0A0AA4FF0A0AA4FF0B0BA3FF0B0BA3FF0B0BA1FF0E0EA1FF4443B0FFEDEDEEFF
          6A6A6BE16A6A6BC0DADADAFF9C9BD5FE4949CDFF3E3DD0FF3C3DCEFF3C3CCAFF
          3A3AC8FF3B39C7FF2828BDFF5C5CCCFFE5E5EDFFF4F4EDFFE5E5E6FFDEDEDEFF
          DCDCD9FFD9D9D3FFCDCDCDFFC8C8C8FFE5E5E1FFF1F1F3FF3F3FA0FF0C0C99FF
          0A0AA4FF0B0BA1FF0B0BA0FF0B0BA0FF0B0B9FFF1313A2FF6B6BC0FFDADADAFF
          6A6A6BC06A6A6B94C0C0C0FDBDBAE1FE5655CFFF4141D4FF3F3FD2FF3F3FCEFF
          3D3DCCFF2C2AC3FF5E5ED3FFEBEBF6FFFFFFFAFFF1F1F1FFEDEDEEFFF0F0E9FF
          D2D2E6FFBDBDD6FFDADAD3FFCFCFCFFFC9C9CAFFE5E5E2FFF1F1F3FF3A3AA0FF
          0C0C98FF0B0BA3FF0B0B9FFF0B0B9EFF0B0B9EFF1C1CA4FF9C9CD3FFC1C1C1FD
          6A6A6B946A6A6B609F9F9FF6DAD9EAFF6B6BCFFF4444D7FF4143D6FF4242D3FF
          3434CDFF6464DBFFEFEFFFFFFFFFFFFFFCFCFCFFF6F6F6FFFCFCF4FFE2E1F0FF
          5050CCFF4040C1FFC3C3DBFFE1E1D8FFD4D4D5FFCFCFCFFFE8E8E5FFF2F2F4FF
          4040A2FF0C0C99FF0F0FA2FF0F0FA0FF0F0F9DFF302FA9FFD1D1E8FEA0A0A0F6
          6A6A6B606A6A6B25787879F1E9E9EBFEA7A7DAFF6060DBFF4547DBFF3C3CD6FF
          5857DEFFF2F2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8F8FF5B5BD4FF
          2828BDFF2A2BBDFF4949C5FFC3C3DBFFE4E4DAFFD5D5D5FFCECED0FFE8E8E5FF
          F4F4F4FF4949AFFF2121A6FF2A2AA6FF2C2BA9FF5557B8FFEAEAECFE787879F1
          6A6A6B25000000007575769EBEBEBEFDC9CAE6FF7A79DBFF4C4CDFFF4141DBFF
          5757E0FFEAEAFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E7FFFF5B5BD7FF2E2EC6FF
          3E3EC9FF3A3AC5FF2C2EC1FF4A49C8FFC2C2DDFFE3E3DAFFD5D5D4FFDADAD3FF
          CACBD9FF4747BBFF2525ADFF2C2BACFF3332AEFFA5A4D8FFBFBFBFFD7575769E
          00000000000000006A6A6B40888889F0ECECEFFE9696D6FF7B7BE3FF4D4BE0FF
          4141DBFF5F5FE6FFE7E7FFFFFFFFFFFFE9E9FFFF5A5ADCFF3333CAFF4242CFFF
          4040CBFF3D3DC9FF3D3EC8FF3030C2FF4848C9FFC0C0DDFFECEEDEFFD0D0E0FF
          5554C7FF2828B3FF3232B4FF3434B1FF5453B7FFECECEFFE888889F06A6A6B40
          0000000000000000000000007C7C7C98B7B7B8FAD0D0ECFF8F8FDBFF6868E3FF
          4E4EE2FF3E40DBFF6565E9FFB2B2F7FF6565E4FF393BD2FF4646D7FF4343D4FF
          4343D1FF4242CFFF4040CBFF3F3FCAFF3333C4FF4E4ECBFF9E9EE2FF5C5BCFFF
          292ABAFF3636BCFF3938B8FF3F3EB1FFCBCBE9FFB7B7B8FA7C7C7C9800000000
          0000000000000000000000006A6A6B22838383D8D3D3D3FEB5B5E2FF9E9EE4FF
          6766E2FF4E50E6FF4646E0FF3D3DDAFF4444DCFF4B4BDCFF4848DBFF4847D9FF
          4646D5FF4443D3FF4343D1FF4242CFFF4143CDFF3A3AC8FF312FC5FF3535C3FF
          3C3CC3FF3D3DBEFF403FB5FFACACDCFFD3D3D3FE838383D86A6A6B2200000000
          000000000000000000000000000000006A6A6B43878788EAE1E1E1FFB5B5E2FF
          A7A6E4FF7877E5FF5151E5FF4F4FE4FF4E4EE2FF4D4DE0FF4C4CDEFF4B4BDCFF
          4949DBFF4848D7FF4747D5FF4545D3FF4545D1FF4343CFFF4242CCFF3F3FCBFF
          4343C2FF4645B6FFADADDCFFE1E1E1FF878788EA6A6A6B430000000000000000
          00000000000000000000000000000000000000006A6A6B4E878788EAD3D3D3FE
          D0D0ECFFAAA9DFFFA2A2ECFF6565E3FF5151E6FF4F4FE4FF4F4DE4FF4D4DE0FF
          4D4DDFFF4D4DDCFF4C49DBFF4A4AD8FF4749D6FF4747D4FF4949CBFF4B4BC3FF
          8E8ED0FFCDCCE8FFD3D3D3FE878788EA6A6A6B4E000000000000000000000000
          0000000000000000000000000000000000000000000000006A6A6B43838383D8
          B7B7B8FAECECEFFEC3C2E5FFADAEE1FF9E9DE8FF6F6FE0FF5C5CE1FF5452E2FF
          5051E1FF4F4FDFFF4F4FDBFF5150D6FF5151CFFF5F5FC8FFA1A1D3FEC7C8E0FE
          E4E4E7FEB7B7B8FA838383D86A6A6B4300000000000000000000000000000000
          000000000000000000000000000000000000000000000000000000006A6A6B22
          7C7C7C98888889F0BFBFBFFDEBEBECFED8D9EBFEBDBDE4FEA8A7DCFF9695D7FF
          8886D4FF7F7DCEFF8C8BD2FFA1A2D9FFC0BEE1FED9D9EAFEEAEAECFEBFBFBFFD
          888889F07C7C7C986A6A6B220000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000006A6A6B407575769E787879F19F9F9FF6C0C0C0FDDADADAFFEDEDEEFF
          FBFBFBFFFBFBFBFFEDEDEEFFDADADAFFC0C0C0FD9F9F9FF6787879F17575769E
          6A6A6B4000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000006A6A6B256A6A6B606A6A6B946A6A6BC06A6A6BE1
          6A6A6BF86A6A6BF86A6A6BE16A6A6BC06A6A6B946A6A6B606A6A6B2500000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000FFC003FFFF0000FFFC00003FF800001FF000000FE0000007C0000003
          C000000380000001800000010000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000080000001
          80000001C0000003C0000003E0000007F000000FF800001FFC00003FFF0000FF
          FFC003FF}
        ShowUnicode = False
        ExplicitTop = 171
        ColWidths = (
          20
          90
          110
          90
          110
          90
          160)
        RowHeights = (
          0
          32)
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Reports'
      ImageIndex = 1
      object Label1: TLabel
        Left = 118
        Top = 112
        Width = 513
        Height = 42
        AutoSize = False
        Caption = 
          'Post-Session : Highlight qualified swimmers in the current sessi' +
          'on. Ordered by name.'
        WordWrap = True
      end
      object Label2: TLabel
        Left = 118
        Top = 219
        Width = 514
        Height = 39
        AutoSize = False
        Caption = 
          'Display a qualification report for each club member. Ordered by ' +
          #39'last name'#39'.'
        WordWrap = True
      end
      object Label10: TLabel
        Left = 118
        Top = 270
        Width = 514
        Height = 39
        AutoSize = False
        Caption = 
          'Display a summary of club members who have qualified. Ordered by' +
          ' distance and stroke.'
        WordWrap = True
      end
      object Label12: TLabel
        Left = 118
        Top = 329
        Width = 514
        Height = 26
        AutoSize = False
        Caption = 
          'Prepare a report of the qualification times table, ready for pri' +
          'nting.'
        WordWrap = True
      end
      object Label9: TLabel
        Left = 117
        Top = 43
        Width = 514
        Height = 44
        AutoSize = False
        Caption = 
          'List members who have nominated for events in the current sessio' +
          'n and have been given a lane but are not qualified to swim those' +
          ' events.'
        WordWrap = True
      end
      object Label11: TLabel
        Left = 11
        Top = 20
        Width = 224
        Height = 17
        Caption = 'REPORTS FOR THE CURRENT SESSION'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object Label13: TLabel
        Left = 11
        Top = 196
        Width = 156
        Height = 17
        Caption = 'OTHER GENERAL REPORTS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsUnderline]
        ParentFont = False
      end
      object btnSessionReport: TButton
        Left = 11
        Top = 112
        Width = 90
        Height = 35
        Caption = 'Session'
        TabOrder = 1
        OnClick = btnSessionReportClick
      end
      object btnMemberReport: TButton
        Left = 11
        Top = 219
        Width = 90
        Height = 35
        Caption = 'Member'
        TabOrder = 2
        OnClick = btnMemberReportClick
      end
      object btnDistStrokeReport: TButton
        Left = 11
        Top = 270
        Width = 90
        Height = 35
        Caption = 'Dist:Stroke'
        TabOrder = 3
        OnClick = btnDistStrokeReportClick
      end
      object btnTableReport: TButton
        Left = 11
        Top = 329
        Width = 90
        Height = 35
        Caption = 'Table'
        TabOrder = 4
        OnClick = btnTableReportClick
      end
      object btnNotQualifyReport: TButton
        Left = 11
        Top = 43
        Width = 90
        Height = 47
        Caption = 'Not Qualified'
        TabOrder = 0
        WordWrap = True
        OnClick = btnNotQualifyReportClick
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 727
    Width = 725
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      725
      41)
    object BtnClose: TButton
      Left = 641
      Top = 6
      Width = 77
      Height = 32
      Anchors = [akTop, akRight]
      Caption = 'Close'
      TabOrder = 0
      OnClick = BtnCloseClick
    end
    object navGrid: TDBNavigator
      Left = 7
      Top = 2
      Width = 600
      Height = 39
      Hint = 'Navigator for Qualify Grid'
      DataSource = DSQualify
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
  end
  object qryQualify: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    OnNewRecord = qryQualifyNewRecord
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'indxSort'
        Fields = 'PoolTypeID;GenderID;Laps'
      end>
    IndexName = 'indxSort'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvFmtDisplayTime]
    FormatOptions.FmtDisplayTime = 'nn:ss.zzz'
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.QualifyTime'
    UpdateOptions.KeyFields = 'QualifyTimeID'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'SELECT'
      '  Q.TrialDistID,'
      '  Q.QualifyDistID,'
      '  Q.QualifyStrokeID,'
      '  Q.TrialTime,'
      '  Q.TrialStrokeID,'
      '  Q.QualifyTimeID,'
      '  Q.GenderID,'
      '  Q.PoolTypeID,'
      '  SUBSTRING(P.Caption, 0, 30) AS PoolTypeStr,'
      '  P.ABREV AS ABREV,'
      '  P.LengthOfPool,'
      '  U.ABREV AS UnitTypeStr,'
      '  D.Laps'
      'FROM'
      '  dbo.QualifyTime Q'
      '  INNER JOIN PoolType P ON Q.PoolTypeID = P.PoolTypeID'
      '  LEFT JOIN UnitType U ON P.UnitTypeID = U.UnitTypeID'
      '  LEFT JOIN dbo.Distance D ON Q.QualifyDistID = D.DistanceID'
      '-- WHERE (Q.PoolTypeID = :POOLTYPEID)'
      'ORDER BY Q.PoolTypeID, Q.GenderID, D.Laps ASC; ')
    Left = 104
    Top = 440
    object qryQualifyTrialDistID: TIntegerField
      FieldName = 'TrialDistID'
      Origin = 'TrialDistID'
      Visible = False
    end
    object qryQualifyTrialStrokeID: TIntegerField
      FieldName = 'TrialStrokeID'
      Origin = 'TrialStrokeID'
    end
    object qryQualifyQualifyDistID: TIntegerField
      FieldName = 'QualifyDistID'
      Origin = 'QualifyDistID'
      Visible = False
    end
    object qryQualifyStrokeID: TIntegerField
      FieldName = 'QualifyStrokeID'
      Origin = 'QualifyStrokeID'
      Visible = False
    end
    object qryQualifyGenderID: TIntegerField
      FieldName = 'GenderID'
      Origin = 'GenderID'
      Visible = False
    end
    object qryQualifyQualifyID: TFDAutoIncField
      FieldName = 'QualifyTimeID'
      Origin = 'QualifyTimeID'
      ProviderFlags = [pfInWhere, pfInKey]
      Visible = False
    end
    object qryQualifyluQDistance: TStringField
      Alignment = taRightJustify
      DisplayLabel = 'QDistance'
      DisplayWidth = 9
      FieldKind = fkLookup
      FieldName = 'luQDistance'
      LookupDataSet = qryQualifyDist
      LookupKeyFields = 'DistanceID'
      LookupResultField = 'DistStr'
      KeyFields = 'QualifyDistID'
      Lookup = True
    end
    object qryQualifyluStroke: TStringField
      DisplayLabel = 'Stroke'
      DisplayWidth = 16
      FieldKind = fkLookup
      FieldName = 'luQStroke'
      LookupDataSet = tblQStroke
      LookupKeyFields = 'StrokeID'
      LookupResultField = 'Caption'
      KeyFields = 'QualifyStrokeID'
      Lookup = True
    end
    object qryQualifyluTDistance: TStringField
      Alignment = taRightJustify
      DisplayLabel = 'TDistance'
      DisplayWidth = 9
      FieldKind = fkLookup
      FieldName = 'luTDistance'
      LookupDataSet = qryTrialDist
      LookupKeyFields = 'DistanceID'
      LookupResultField = 'DistStr'
      KeyFields = 'TrialDistID'
      Lookup = True
    end
    object qryQualifyluGender: TStringField
      Alignment = taCenter
      DisplayLabel = 'Gender'
      DisplayWidth = 12
      FieldKind = fkLookup
      FieldName = 'luGender'
      LookupDataSet = luGender
      LookupKeyFields = 'GenderID'
      LookupResultField = 'Caption'
      KeyFields = 'GenderID'
      Lookup = True
    end
    object qryQualifyTrialTime: TTimeField
      Alignment = taRightJustify
      DisplayLabel = 'TIME'
      FieldName = 'TrialTime'
      Origin = 'TrialTime'
      OnGetText = qryQualifyTrialTimeGetText
      OnSetText = qryQualifyTrialTimeSetText
      DisplayFormat = 'nn:ss.zzz'
      EditMask = '!00:00.000;1;0'
    end
    object qryQualifyPoolTypeStr: TWideStringField
      FieldName = 'PoolTypeStr'
      Origin = 'PoolTypeStr'
      ReadOnly = True
      Size = 30
    end
    object qryQualifyluTStroke: TStringField
      FieldKind = fkLookup
      FieldName = 'luTStroke'
      LookupDataSet = tblTStroke
      LookupKeyFields = 'StrokeID'
      LookupResultField = 'Caption'
      KeyFields = 'TrialStrokeID'
      Lookup = True
    end
    object qryQualifyLaps: TFloatField
      FieldName = 'Laps'
      Origin = 'Laps'
    end
    object qryQualifyPoolTypeID: TIntegerField
      FieldName = 'PoolTypeID'
      Origin = 'PoolTypeID'
    end
    object qryQualifyABREV: TWideStringField
      FieldName = 'ABREV'
      Origin = 'ABREV'
      Size = 5
    end
    object qryQualifyLengthOfPool: TFloatField
      FieldName = 'LengthOfPool'
      Origin = 'LengthOfPool'
    end
    object qryQualifyUnitTypeStr: TWideStringField
      FieldName = 'UnitTypeStr'
      Origin = 'UnitTypeStr'
      Size = 16
    end
  end
  object DSQualify: TDataSource
    DataSet = qryQualify
    Left = 184
    Top = 440
  end
  object tblQStroke: TFDTable
    ActiveStoredUsage = [auDesignTime]
    Active = True
    IndexFieldNames = 'StrokeID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'Stroke'
    Left = 364
    Top = 312
  end
  object luGender: TFDTable
    ActiveStoredUsage = [auDesignTime]
    Active = True
    IndexFieldNames = 'GenderID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'Gender'
    Left = 364
    Top = 448
  end
  object tblPoolTypes: TFDTable
    IndexFieldNames = 'PoolTypeID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.PoolType'
    UpdateOptions.KeyFields = 'PoolTypeID'
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'PoolType'
    Left = 100
    Top = 380
  end
  object qryTrialDist: TFDQuery
    Active = True
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'indxSort'
        Fields = 'PoolTypeID;Laps'
      end>
    IndexName = 'indxSort'
    Connection = SCM2.scmConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.PoolType'
    UpdateOptions.KeyFields = 'PoolTypeID'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'DEClARE @APoolTypeID int;'
      'SET @APoolTypeID = :POOLTYPEID;'
      'IF @APoolTypeID IS NULL OR @APoolTypeID=0 SET @APoolTypeID=1;'
      ''
      'SELECT P.PoolTypeID'
      '      ,D.DistanceID'
      '      ,CONCAT(D.Laps * P.LengthOfPool, U.ABREV) AS DistStr'
      '      ,D.Laps'
      '  FROM dbo.PoolType AS P'
      '  INNER JOIN dbo.UnitType AS U'
      '      ON P.UnitTypeID = U.UnitTypeID'
      '  CROSS JOIN dbo.Distance AS D'
      '  WHERE P.PoolTypeID = @APoolTypeID'
      '  ORDER BY D.Laps ASC;'
      '  ;'
      ''
      '')
    Left = 448
    Top = 376
    ParamData = <
      item
        Name = 'POOLTYPEID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryTrialDistPoolTypeID: TFDAutoIncField
      FieldName = 'PoolTypeID'
      Origin = 'PoolTypeID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object qryTrialDistDistanceID: TFDAutoIncField
      FieldName = 'DistanceID'
      Origin = 'DistanceID'
    end
    object qryTrialDistDistStr: TWideStringField
      FieldName = 'DistStr'
      Origin = 'DistStr'
      ReadOnly = True
      Required = True
      Size = 39
    end
    object qryTrialDistLaps: TFloatField
      FieldName = 'Laps'
      Origin = 'Laps'
    end
  end
  object qryQualifyDist: TFDQuery
    Active = True
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'indxSort'
        Fields = 'PoolTypeID;Laps'
      end>
    IndexName = 'indxSort'
    Connection = SCM2.scmConnection
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2.dbo.PoolType'
    UpdateOptions.KeyFields = 'PoolTypeID'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'DEClARE @APoolTypeID int;'
      'SET @APoolTypeID = :POOLTYPEID;'
      'IF @APoolTypeID IS NULL OR @APoolTypeID=0 SET @APoolTypeID=1;'
      ''
      'SELECT P.PoolTypeID'
      '      ,D.DistanceID'
      '      ,CONCAT(D.Laps * P.LengthOfPool, U.ABREV) AS DistStr'
      '      ,D.Laps'
      '  FROM dbo.PoolType AS P'
      '  INNER JOIN dbo.UnitType AS U'
      '      ON P.UnitTypeID = U.UnitTypeID'
      '  CROSS JOIN dbo.Distance AS D'
      '  WHERE P.PoolTypeID = @APoolTypeID'
      '  ORDER BY D.Laps ASC;'
      '')
    Left = 448
    Top = 312
    ParamData = <
      item
        Name = 'POOLTYPEID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryQualifyDistPoolTypeID: TFDAutoIncField
      FieldName = 'PoolTypeID'
      Origin = 'PoolTypeID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object qryQualifyDistDistanceID: TFDAutoIncField
      FieldName = 'DistanceID'
      Origin = 'DistanceID'
    end
    object qryQualifyDistDistStr: TWideStringField
      FieldName = 'DistStr'
      Origin = 'DistStr'
      ReadOnly = True
      Required = True
      Size = 39
    end
    object qryQualifyDistLaps: TFloatField
      FieldName = 'Laps'
      Origin = 'Laps'
    end
  end
  object tblTStroke: TFDTable
    ActiveStoredUsage = [auDesignTime]
    Active = True
    IndexFieldNames = 'StrokeID'
    Connection = SCM2.scmConnection
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    CatalogName = 'SwimClubMeet2'
    SchemaName = 'dbo'
    TableName = 'Stroke'
    Left = 364
    Top = 376
  end
end
