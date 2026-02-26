unit dlgLaneColumnPicker;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,

  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst,
  Vcl.ExtCtrls,

  Data.DB,

  dmSCM2, dmCORE, dmIMG, uDefines, uSettings;

type
  TLaneColumnPicker = class(TForm)
    pnlBody: TPanel;
    clbLane: TCheckListBox;
    procedure clbLaneClickCheck(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LaneColumnPicker: TLaneColumnPicker;

implementation

{$R *.dfm}

procedure TLaneColumnPicker.clbLaneClickCheck(Sender: TObject);
var
  fld: TField;
begin
  fld := TField(clbLane.Items.Objects[clbLane.ItemIndex]);
  fld.Visible := clbLane.Checked[clbLane.ItemIndex];
end;

procedure TLaneColumnPicker.FormCreate(Sender: TObject);
var
  fld: TField;
  I, indx: Integer;
begin
  // Fill list check-box
  if CORE.qryLane.IsEmpty then exit;

  for I := 0 to CORE.qryLane.Fields.Count-1 do
  begin
    // filter out PK and FK
    fld := CORE.qryLane.Fields[I];
    if fld.FieldName = 'LaneID' then continue;
    if fld.FieldName = 'HeatID' then continue;
    if fld.FieldName = 'TeamID' then continue;
    if fld.FieldName = 'NomineeID' then continue;


    // if fld.FieldName = 'EventTypeID' then continue;

    // filter out DQ/simplified disqualification
    if Assigned(Settings) and Settings.EnableDQcodes then
    begin
      if (fld.FieldName = 'IsDisqualified')
        OR (fld.FieldName = 'IsScratched') then continue;
    end
    else
    begin
      if (fld.FieldName = 'luDQ')
        OR  (fld.FieldName = 'DisqualifyCodeID') then continue;
    end;
    // filter MISC, unused.
    if fld.FieldName = 'Stat' then continue;

    clbLane.AddItem(fld.DisplayLabel, fld);
  end;

  for I := 0 to clbLane.Items.Count-1 do
  begin
    fld := TField(clbLane.Items.Objects[I]);
    if Assigned(fld) then
      clbLane.Checked[i] := fld.Visible;
  end;

end;

procedure TLaneColumnPicker.FormKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrOk;
  end;
end;

end.
