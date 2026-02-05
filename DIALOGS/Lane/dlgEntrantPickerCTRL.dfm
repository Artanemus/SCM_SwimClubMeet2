object EntrantPickerCTRL: TEntrantPickerCTRL
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Quick-Pick from Active Members ,,,'
  ClientHeight = 701
  ClientWidth = 818
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 19
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 818
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object VirtualImage2: TVirtualImage
      Left = 8
      Top = 2
      Width = 34
      Height = 39
      ImageCollection = IMG.CollectionCore
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 67
      ImageName = 'Search'
      Enabled = False
    end
    object Nominate_Edit: TEdit
      Left = 48
      Top = 11
      Width = 249
      Height = 27
      TabOrder = 0
      OnChange = Nominate_EditChange
    end
  end
  object pnlBody: TPanel
    Left = 0
    Top = 45
    Width = 818
    Height = 656
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitHeight = 588
    object pnlCntrl: TPanel
      Left = 696
      Top = 0
      Width = 122
      Height = 656
      Align = alRight
      BevelOuter = bvNone
      Color = clDarkslategray
      ParentBackground = False
      TabOrder = 0
      ExplicitHeight = 588
      object btnCancel: TButton
        Left = 10
        Top = 47
        Width = 106
        Height = 35
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 0
        OnClick = btnCancelClick
      end
      object btnPost: TButton
        Left = 10
        Top = 6
        Width = 106
        Height = 35
        Caption = 'Post'
        ModalResult = 1
        TabOrder = 1
        OnClick = btnPostClick
      end
      object btnToggleName: TButton
        Left = 10
        Top = 88
        Width = 106
        Height = 35
        Caption = 'Toggle Name'
        TabOrder = 2
        OnClick = btnToggleNameClick
      end
    end
    object pnlGrid: TPanel
      Left = 0
      Top = 0
      Width = 696
      Height = 656
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitHeight = 588
      object Grid: TDBAdvGrid
        Left = 0
        Top = 0
        Width = 696
        Height = 656
        Cursor = crDefault
        Align = alClient
        Color = clWhite
        ColCount = 6
        DefaultRowHeight = 30
        DrawingStyle = gdsClassic
        FixedColor = clWhite
        RowCount = 2
        FixedRows = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        Options = [goVertLine, goHorzLine, goRangeSelect, goRowSelect, goFixedRowDefAlign]
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        GridLineColor = 15987699
        GridFixedLineColor = 15987699
        HoverRowCells = [hcNormal, hcSelected]
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
        FixedRowHeight = 30
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
        SortSettings.IgnoreBlanks = True
        SortSettings.BlankPos = blLast
        SortSettings.IgnoreCase = True
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
            FieldName = 'NomineeID'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = []
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 3881787
            HeaderFont.Height = -16
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
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = clWindow
            FieldName = 'FName'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Tahoma'
            Font.Style = []
            Header = 'Nominee'
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 3881787
            HeaderFont.Height = -16
            HeaderFont.Name = 'Tahoma'
            HeaderFont.Style = []
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -16
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            Width = 265
          end
          item
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = clWindow
            FieldName = 'TTB'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Tahoma'
            Font.Style = []
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 3881787
            HeaderFont.Height = -16
            HeaderFont.Name = 'Tahoma'
            HeaderFont.Style = []
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -16
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            Width = 112
          end
          item
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = clWindow
            FieldName = 'PB'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Tahoma'
            Font.Style = []
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 3881787
            HeaderFont.Height = -16
            HeaderFont.Name = 'Tahoma'
            HeaderFont.Style = []
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -16
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            Width = 112
          end
          item
            Alignment = taCenter
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = clWindow
            FieldName = 'AGE'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Tahoma'
            Font.Style = []
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 3881787
            HeaderFont.Height = -16
            HeaderFont.Name = 'Tahoma'
            HeaderFont.Style = []
            HeaderAlignment = taCenter
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clWindowText
            PrintFont.Height = -16
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            Width = 55
          end
          item
            Borders = []
            BorderPen.Color = clSilver
            ButtonHeight = 18
            CheckFalse = 'N'
            CheckTrue = 'Y'
            Color = clWhite
            FieldName = 'GenderStr'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -16
            Font.Name = 'Tahoma'
            Font.Style = []
            Header = ' '
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = 3881787
            HeaderFont.Height = -16
            HeaderFont.Name = 'Tahoma'
            HeaderFont.Style = []
            PrintBorders = [cbTop, cbLeft, cbRight, cbBottom]
            PrintFont.Charset = DEFAULT_CHARSET
            PrintFont.Color = clBlack
            PrintFont.Height = -16
            PrintFont.Name = 'Tahoma'
            PrintFont.Style = []
            Width = 64
          end>
        DataSource = dsQuickPick
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
        ExplicitHeight = 588
        ColWidths = (
          20
          265
          112
          112
          55
          64)
        RowHeights = (
          30
          30)
      end
    end
  end
  object dsQuickPickCtrl: TDataSource
    DataSet = qryQuickPickCtrl
    Left = 263
    Top = 280
  end
  object qryQuickPickCtrl: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    FilterOptions = [foCaseInsensitive]
    Filter = '[FName] LIKE '#39'%b%'#39
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxMemberFName'
        Fields = 'FName'
      end
      item
        Active = True
        Name = 'idxMemberFNameDESC'
        Fields = 'FName'
        DescFields = 'FName'
        Options = [soDescNullLast, soDescending]
      end
      item
        Active = True
        Name = 'idxTTB'
        Fields = 'TTB'
      end
      item
        Active = True
        Name = 'idxTTBDESC'
        Fields = 'TTB'
        DescFields = 'TTB'
        Options = [soDescending]
      end
      item
        Active = True
        Name = 'idxPB'
        Fields = 'PB'
      end
      item
        Active = True
        Name = 'idxPBDESC'
        Fields = 'PB'
        DescFields = 'PB'
        Options = [soDescending]
      end
      item
        Active = True
        Name = 'idxAge'
        Fields = 'AGE'
      end
      item
        Active = True
        Name = 'idxAgeDESC'
        Fields = 'AGE'
        Options = [soDescNullLast, soDescending]
      end
      item
        Active = True
        Name = 'idxGender'
        Fields = 'GenderID'
      end
      item
        Active = True
        Name = 'idxGenderDESC'
        Fields = 'GenderID'
        Options = [soDescNullLast, soDescending]
      end>
    IndexName = 'idxMemberFName'
    DetailFields = 'MemberID'
    FormatOptions.AssignedValues = [fvFmtDisplayTime]
    FormatOptions.FmtDisplayTime = 'nn:ss.zzz'
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet..Member'
    UpdateOptions.KeyFields = 'MemberID'
    SQL.Strings = (
      'USE SwimClubMeet'
      ''
      'DECLARE @EventID INT;'
      'DECLARE @Algorithm INT;'
      'DECLARE @DistanceID INT;'
      'DECLARE @StrokeID INT;'
      'DECLARE @SessionStart DATETIME;'
      'DECLARE @ToggleName BIT;'
      'DECLARE @Order INT;'
      'DECLARE @CalcDefault INT;'
      'DECLARE @BottomPercent FLOAT;'
      'DECLARE @EventType INT;'
      ''
      'SET @EventID = :EVENTID;'
      'SET @Algorithm = :ALGORITHM;'
      'SET @ToggleName = :TOGGLENAME;'
      'SET @CalcDefault = :CALCDEFAULT;'
      'SET @BottomPercent = :BOTTOMPERCENT;'
      'SET @EventType = :EVENTTYPE;'
      'SET @DistanceID = :DISTANCEID;'
      ''
      '/*'
      'SET @DistanceID ='
      '('
      '    SELECT DistanceID FROM Event WHERE Event.EventID = @EventID'
      ');'
      '*/'
      ''
      'SET @StrokeID ='
      '('
      '    SELECT StrokeID FROM Event WHERE Event.EventID = @EventID'
      ');'
      'SET @SessionStart ='
      '('
      '    SELECT Session.SessionStart'
      '    FROM Event'
      '        INNER JOIN Session'
      '            ON Event.SessionID = Session.SessionID'
      '    WHERE Event.EventID = @EventID'
      ');'
      ''
      '-- Drop a temporary table called '#39'#tmpID'#39
      'IF OBJECT_ID('#39'tempDB..#tmpID'#39', '#39'U'#39') IS NOT NULL'
      '    DROP TABLE #tmpID;'
      ''
      'CREATE TABLE #tmpID'
      '('
      '    MemberID INT'
      '  --,TeamEntrant.TeamEntrantID AS ID'
      '  , GenderID INT'
      ')'
      ''
      'IF @EventType = 1'
      'BEGIN'
      '    INSERT INTO #tmpID'
      '    SELECT Entrant.MemberID'
      '         , Member.GenderID'
      '    FROM Entrant'
      '        INNER JOIN HeatIndividual'
      '            ON Entrant.HeatID = HeatIndividual.HeatID'
      '        INNER JOIN Event'
      '            ON HeatIndividual.EventID = Event.EventID'
      '        INNER JOIN Session'
      '            ON Event.SessionID = Session.SessionID'
      '        INNER JOIN Member'
      '            ON Entrant.MemberID = Member.MemberID'
      '    WHERE (HeatIndividual.EventID = @EventID)'
      '          AND (Entrant.MemberID IS NOT NULL);'
      'END'
      'ELSE'
      'BEGIN'
      '    INSERT INTO #tmpID'
      '    SELECT TeamEntrant.MemberID'
      '         , Member.GenderID'
      '    FROM TeamEntrant'
      '        INNER JOIN TEAM'
      '            ON TeamEntrant.TeamID = Team.TeamID'
      '        INNER JOIN HeatIndividual'
      '            ON Team.HeatID = HeatIndividual.HeatID'
      '        INNER JOIN Event'
      '            ON HeatIndividual.EventID = Event.EventID'
      '        INNER JOIN Session'
      '            ON Event.SessionID = Session.SessionID'
      '        INNER JOIN Member'
      '            ON TeamEntrant.MemberID = Member.MemberID'
      '    WHERE (HeatIndividual.EventID = @EventID)'
      '          AND (TeamEntrant.MemberID IS NOT NULL);'
      'END'
      ''
      
        '-- ALL OTHER Members who have not been placed in the current sel' +
        'ected event'
      'SELECT Member.MemberID'
      '     , Member.GenderID'
      '     , dbo.SwimmerAge(@SessionStart, Member.DOB) AS AGE'
      '     , dbo.SwimmerGenderToString(Member.MemberID) AS Gender'
      
        '     , dbo.TimeToBeat(@Algorithm, @CalcDefault, @BottomPercent, ' +
        'Member.MemberID, @DistanceID, @StrokeID, @SessionStart) AS TTB'
      
        '     , dbo.PersonalBest(Member.MemberID, @DistanceID, @StrokeID,' +
        ' @SessionStart) AS PB'
      '     , CASE'
      '           WHEN @ToggleName = 0 THEN'
      
        '               SUBSTRING(CONCAT(UPPER([LastName]), '#39', '#39', [FirstN' +
        'ame]), 0, 30)'
      '           WHEN @ToggleName = 1 THEN'
      
        '               SUBSTRING(CONCAT([FirstName], '#39', '#39', UPPER([LastNa' +
        'me])), 0, 48)'
      '       END AS FName'
      'FROM Member'
      '    LEFT OUTER JOIN #tmpID'
      '        ON #tmpID.MemberID = Member.MemberID'
      'WHERE #tmpID.MemberID IS NULL'
      
        '      AND Member.IsActive = 1 AND Member.IsSwimmer = 1 AND NOT M' +
        'ember.IsArchived = 1')
    Left = 136
    Top = 272
    ParamData = <
      item
        Name = 'EVENTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 350
      end
      item
        Name = 'ALGORITHM'
        DataType = ftInteger
        ParamType = ptInput
        Value = 2
      end
      item
        Name = 'TOGGLENAME'
        DataType = ftBoolean
        ParamType = ptInput
        Value = True
      end
      item
        Name = 'CALCDEFAULT'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end
      item
        Name = 'BOTTOMPERCENT'
        DataType = ftFloat
        ParamType = ptInput
        Value = 50.000000000000000000
      end
      item
        Name = 'EVENTTYPE'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end
      item
        Name = 'DISTANCEID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryQuickPickCtrlFName: TWideStringField
      DisplayLabel = 'Member'#39's Name'
      DisplayWidth = 30
      FieldName = 'FName'
      Origin = 'FName'
      ReadOnly = True
      Size = 48
    end
    object qryQuickPickCtrlTTB: TTimeField
      Alignment = taCenter
      DisplayLabel = 'TimeToBeat'
      DisplayWidth = 12
      FieldName = 'TTB'
      Origin = 'TTB'
      ReadOnly = True
      DisplayFormat = 'nn:ss.zzz'
    end
    object qryQuickPickCtrlPB: TTimeField
      Alignment = taCenter
      DisplayLabel = 'Personal Best'
      DisplayWidth = 12
      FieldName = 'PB'
      Origin = 'PB'
      ReadOnly = True
      DisplayFormat = 'nn:ss.zzz'
    end
    object qryQuickPickCtrlAGE: TIntegerField
      Alignment = taCenter
      DisplayLabel = '  AGE'
      DisplayWidth = 5
      FieldName = 'AGE'
      Origin = 'AGE'
      ReadOnly = True
      DisplayFormat = '##0'
    end
    object qryQuickPickCtrlGender: TWideStringField
      Alignment = taCenter
      DisplayWidth = 9
      FieldName = 'Gender'
      Origin = 'Gender'
      ReadOnly = True
      Size = 2
    end
    object qryQuickPickCtrlMemberID: TFDAutoIncField
      FieldName = 'MemberID'
      Origin = 'MemberID'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object qryQuickPickCtrlGenderID: TIntegerField
      FieldName = 'GenderID'
      Origin = 'GenderID'
    end
  end
  object FDCommandUpdateEntrant: TFDCommand
    CommandText.Strings = (
      'USE [SwimClubMeet2];'
      ''
      'DECLARE @MemberID AS Integer;'
      'DECLARE @ID AS Integer;'
      'DECLARE @TTB AS DateTime;'
      'DECLARE @PB AS DateTime;'
      'DECLARE @EventType AS INT;'
      ''
      'SET @MemberID = :MEMBERID;'
      'SET @ID = :ID;'
      'SET @TTB = :TTB;'
      'SET @PB = :PB;'
      'SET @EventType = :EVENTTYPE;'
      ''
      'IF @EventType = 1'
      'BEGIN'
      'UPDATE [SwimClubMeet2].[dbo].[Lane]'
      '   SET [NomineeID] = @NomineeID'
      '      ,[RaceTime] = NULL'
      '      ,[TimeToBeat] = @TTB'
      '      ,[PersonalBest] = @PB'
      '      ,[IsDisqualified] = 0'
      '      ,[IsScratched] = 0'
      '      ,[DisqualifyCodeID] = NULL'
      ' WHERE EntrantID = @ID;'
      'END'
      ''
      '')
    ParamData = <
      item
        Name = 'MEMBERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'TTB'
        DataType = ftTime
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PB'
        DataType = ftTime
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'EVENTTYPE'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end>
    Left = 152
    Top = 128
  end
  object ImageCollection1: TImageCollection
    Images = <
      item
        Name = 'Search'
        SourceImages = <
          item
            Image.Data = {
              89504E470D0A1A0A0000000D49484452000000300000003008060000005702F9
              87000000017352474200AECE1CE9000002A1494441546843ED99E151D6401086
              5F2AD00EC00A900A900A1C2B502B102A502A102A502B502B502AD00EB403A002
              9867E696593249EE2E7BE14B66727FC27CDC77B7CFBDEFEE6D604F2B1F7B2B8F
              5F1BC0AE15DC1458B302AF25BD92F4323D8DE546D25F49BF25FD4C3FCFC639C5
              426F257D927450181520EF25FD2F9C5F35AD06E0B9A4EF9DD3AED9EC54D265CD
              174AE6960260932FC92EB6EEADA4AFC9229C2E270DA4598A2736F383F9A8D16C
              940010D4AF4EF05792DE15D8821CF921E9998B181550A3C928012078026170EA
              F8FFA262770E8093F76ABC496015CBF44FCD0170CA58C7C65965F07E572AD361
              FA804AF54212CFD0C801FC73D506DB981253362527C813B3D3795273CA5A0FDF
              19032058EC63D621806829C4FB9FD39AAC850AA1310680CF3FA4D5BFA5A40D6D
              96BE7CE716012074286300C87D9C368B78BF0BED7321BCEE18C075AAEB047092
              FCDB42012A12B739239C0763005EEA5CB2D78051863F3E3540D8AB8EF0C900BC
              579B5D3CC98A965BB35A8816C06ECFF0464E81A6B935E66D7F0BA3C6518DD107
              E6D2827339DA08E7D6D802DDCDC2252F5D8C769B37B95B7227E04B1E7D0B2A4C
              BD787CF2A24093C290034005EC63FD0B971B095DDB84D186FC71D669D652E700
              D8B3DB91A2002F25C0940C6A3EA76FA35927CA822500CCEBCACF67F44A54A721
              35FADEE20CA2D99B5929409F12160C8AF4BD5276D5E165C8BF993581A8012020
              2A081BEF9778C7CDA1E2D04AA39AF541FC3A0C510B6031911704646F58433C04
              4ED014026F9F661053012C18FF57080F41828F25B92FCF2125A200954E7A34BD
              09C42E01ECE44376DA3540186209002188A5004C865812C02488A50154432C11
              A00F62B07B5D2A8087A087A285F1B7F9C385B26400EB78ED7F10BD97E6D201B2
              37FD06903DA299276C0ACC7CC0D9E557AFC03D711588316245F5CB0000000049
              454E44AE426082}
          end>
      end>
    Left = 464
    Top = 216
  end
  object qryQuickPick: TFDQuery
    ActiveStoredUsage = [auDesignTime]
    FilterOptions = [foCaseInsensitive]
    Filter = '[FName] LIKE '#39'%b%'#39
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxMemberFName'
        Fields = 'FName'
      end
      item
        Active = True
        Name = 'idxMemberFNameDESC'
        Fields = 'FName'
        DescFields = 'FName'
        Options = [soDescNullLast, soDescending]
      end
      item
        Active = True
        Name = 'idxTTB'
        Fields = 'TTB'
      end
      item
        Active = True
        Name = 'idxTTBDESC'
        Fields = 'TTB'
        DescFields = 'TTB'
        Options = [soDescending]
      end
      item
        Active = True
        Name = 'idxPB'
        Fields = 'PB'
      end
      item
        Active = True
        Name = 'idxPBDESC'
        Fields = 'PB'
        DescFields = 'PB'
        Options = [soDescending]
      end
      item
        Active = True
        Name = 'idxAge'
        Fields = 'AGE'
      end
      item
        Active = True
        Name = 'idxAgeDESC'
        Fields = 'AGE'
        Options = [soDescNullLast, soDescending]
      end
      item
        Active = True
        Name = 'idxGender'
        Fields = 'GenderID'
      end
      item
        Active = True
        Name = 'idxGenderDESC'
        Fields = 'GenderID'
        Options = [soDescNullLast, soDescending]
      end>
    IndexName = 'idxMemberFName'
    DetailFields = 'MemberID'
    Connection = SCM2.scmConnection
    FormatOptions.AssignedValues = [fvFmtDisplayTime]
    FormatOptions.FmtDisplayTime = 'nn:ss.zzz'
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate, uvCheckReadOnly]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.CheckReadOnly = False
    UpdateOptions.UpdateTableName = 'SwimClubMeet2..Nominee'
    UpdateOptions.KeyFields = 'NomineeID'
    SQL.Strings = (
      'USE SwimClubMeet2;'
      ''
      'DECLARE @EventID AS INT;'
      'DECLARE @ToggleName BIT;'
      ''
      'SET @EventID = :EVENTID;'
      'SET @ToggleName = :TOGGLENAME;'
      ''
      '-- Drop a temporary table called '#39'#tmpID'#39
      'IF OBJECT_ID('#39'tempDB..#tmpID'#39', '#39'U'#39') IS NOT NULL'
      '    DROP TABLE #tmpID;'
      ''
      'CREATE TABLE #tmpID'
      '('
      '    MemberID INT'
      ')'
      ''
      '-- Members given a swimming lane in the given event '
      '    INSERT INTO #tmpID'
      '    SELECT Nominee.MemberID'
      '    FROM [SwimClubMeet2].[dbo].[Heat]'
      '        INNER JOIN Lane'
      '            ON Lane.HeatID = Heat.HeatID'
      '        LEFT JOIN Nominee'
      '            ON Lane.NomineeID = Nominee.NomineeID'
      
        '    WHERE Heat.EventID = @EventID AND Lane.NomineeID IS NOT NULL' +
        ';'
      ''
      'SELECT '
      '       Nominee.NomineeID'
      '     , Nominee.EventID'
      '     , Nominee.MemberID'
      '     , Member.GenderID'
      '     , Nominee.AGE'
      '     , dbo.SwimmerGenderToString(Member.MemberID) AS GenderABREV'
      '     , Nominee.TTB'
      '     , Nominee.PB'
      '     , CASE'
      '           WHEN @ToggleName = 0 THEN'
      
        '               SUBSTRING(CONCAT(UPPER([LastName]), '#39', '#39', [FirstN' +
        'ame]), 0, 48)'
      '           WHEN @ToggleName = 1 THEN'
      
        '               SUBSTRING(CONCAT([FirstName], '#39', '#39', UPPER([LastNa' +
        'me])), 0, 48)'
      '       END AS FName'
      'FROM Nominee'
      '    LEFT OUTER JOIN #tmpID'
      '        ON #tmpID.MemberID = Nominee.MemberID'
      '    LEFT OUTER JOIN Member'
      '        ON Nominee.MemberID = Member.MemberID'
      'WHERE Nominee.EventID = @EventID'
      '      AND #tmpID.MemberID IS NULL ;'
      '')
    Left = 144
    Top = 384
    ParamData = <
      item
        Name = 'EVENTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 65
      end
      item
        Name = 'TOGGLENAME'
        DataType = ftBoolean
        ParamType = ptInput
        Value = True
      end>
    object qryQuickPickFName: TWideStringField
      DisplayLabel = 'Nominees'
      DisplayWidth = 30
      FieldName = 'FName'
      Origin = 'FName'
      ReadOnly = True
      Size = 60
    end
    object qryQuickPickTTB: TTimeField
      Alignment = taCenter
      DisplayLabel = 'TimeToBeat'
      DisplayWidth = 12
      FieldName = 'TTB'
      Origin = 'TTB'
      ReadOnly = True
      DisplayFormat = 'nn:ss.zzz'
    end
    object qryQuickPickPB: TTimeField
      Alignment = taCenter
      DisplayLabel = 'Personal Best'
      DisplayWidth = 12
      FieldName = 'PB'
      Origin = 'PB'
      ReadOnly = True
      DisplayFormat = 'nn:ss.zzz'
    end
    object qryQuickPickAGE: TIntegerField
      Alignment = taLeftJustify
      DisplayLabel = '  AGE'
      DisplayWidth = 5
      FieldName = 'AGE'
      Origin = 'AGE'
      ReadOnly = True
      DisplayFormat = '##0'
    end
    object qryQuickPickMemberID: TIntegerField
      FieldName = 'MemberID'
      Origin = 'MemberID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object qryQuickPickEventID: TIntegerField
      FieldName = 'EventID'
      Origin = 'EventID'
    end
    object qryQuickPickGenderID: TIntegerField
      FieldName = 'GenderID'
      Origin = 'GenderID'
    end
    object qryQuickPickGenderABREV: TWideStringField
      DisplayLabel = 'Gender'
      FieldName = 'GenderABREV'
      Origin = 'GenderABREV'
      ReadOnly = True
      Size = 2
    end
    object qryQuickPickNomineeID: TFDAutoIncField
      FieldName = 'NomineeID'
      Origin = 'NomineeID'
    end
  end
  object dsQuickPick: TDataSource
    DataSet = qryQuickPick
    Left = 232
    Top = 384
  end
end
