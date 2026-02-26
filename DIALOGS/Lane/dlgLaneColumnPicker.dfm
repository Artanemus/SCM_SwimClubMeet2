object LaneColumnPicker: TLaneColumnPicker
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Lane - Column Picker...'
  ClientHeight = 352
  ClientWidth = 268
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 21
  object pnlBody: TPanel
    Left = 0
    Top = 0
    Width = 268
    Height = 352
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 427
    object clbLane: TCheckListBox
      Left = 0
      Top = 0
      Width = 268
      Height = 352
      Align = alClient
      ItemHeight = 21
      TabOrder = 0
      OnClickCheck = clbLaneClickCheck
      ExplicitHeight = 427
    end
  end
end
