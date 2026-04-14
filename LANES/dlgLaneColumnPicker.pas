unit dlgLaneColumnPicker;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,

  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst,
  Vcl.ExtCtrls,  Vcl.Buttons, Vcl.WinXPanels,

  Data.DB,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmSCM2, dmCORE, dmIMG, uDefines, uSettings, uStateString;

type
  TLaneColumnPicker = class(TForm)
    pnlBody: TPanel;
    clbLane: TCheckListBox;
    spnlFooter: TStackPanel;
    spbtnSaveGridMetrics: TSpeedButton;
    spbtnLoadGridMetrics: TSpeedButton;
    spbtnResetGrigLayout: TSpeedButton;
    spbtnClose: TSpeedButton;
    procedure FormDestroy(Sender: TObject);
    procedure clbLaneClickCheck(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure spbtnCloseClick(Sender: TObject);
    procedure spbtnResetGrigLayoutClick(Sender: TObject);
  private
    { Private declarations }
    fDoReset: boolean;
    fStateStringSystem: string;
    MyStateString: TStateString; // Columns count, width, order, visibility.

  protected
    function GetStateString(): string;

  public
    { Public declarations }
    procedure Prepare(AStateString: string; const AStateStringSystem: string;
        AGrid: TDBAdvGrid);

    property DoReset: boolean read FDoReset write FDoReset;
    property StateString: string read GetStateString;

  end;

var
  LaneColumnPicker: TLaneColumnPicker;

implementation

{$R *.dfm}

procedure TLaneColumnPicker.FormDestroy(Sender: TObject);
begin

  MyStateString.Free;
end;

procedure TLaneColumnPicker.clbLaneClickCheck(Sender: TObject);
var
  REFindx: integer;
  TempStateString: TStateString;
  fld: TField;
  width: integer;
begin
  if Assigned(MyStateString) then
  begin
    // toggle visibility
    MyStateString.fColVisible[clbLane.ItemIndex] :=
      clbLane.Checked[clbLane.ItemIndex].ToInteger;
    // Set column width using system state string.

    fld := TField(clbLane.Items.Objects[clbLane.ItemIndex]);
    if fld<>nil then
    begin
      // calculate a width for the column using fStateStringSystem.
      TempStateString := TStateString.Create;
      TempStateString.StateString := fStateStringSystem;
      REFindx := TempStateString.LookUpREFindex(fld.Index);
      if REFindx <> -1 then
      begin
        width := TempStateString.fColWidth[REFindx];
        width := TempStateString.GetColWidth(fld.index);
        MyStateString.fColWidth[clbLane.ItemIndex] := width;
      end;
      TempStateString.Free;
    end;

  end;
end;

procedure TLaneColumnPicker.FormCreate(Sender: TObject);
begin
  fDoReset := false;
  // empty any items placed at design-time for UI calibration.
  clbLane.Items.Clear;
  // system checks
  if not (Assigned(CORE) and CORE.IsActive) or CORE.qryLane.IsEmpty then
  begin
    ModalResult := mrCancel;
    Close;
  end;

  MyStateString := TStateString.Create;
end;

procedure TLaneColumnPicker.FormKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    fDoReset := false;
    ModalResult := mrOk;
  end;
end;

function TLaneColumnPicker.GetStateString: string;
begin
  result := '';
  if Assigned(MyStateString) then
  begin
    result := MyStateString.StateString;
  end;
end;

function BlackList(Name: string): boolean;
begin
  result := true;
  { 1. filter out PK and FK}
  if Name = 'LaneID' then exit;
  if Name = 'HeatID' then exit;
  if Name = 'TeamID' then exit;
  if Name = 'NomineeID' then exit;
  if Name = 'DisqualifyCodeID' then exit;
  // Include EventTypeID in list...
  // if Name = 'EventTypeID' then exit;

  { 2. filter out either DQ or simplified fields based on
      the disqualification flag in settings...}
  if Assigned(Settings) and Settings.EnableDQcodes then
  begin
    if (Name = 'IsDisqualified')
      OR (Name = 'IsScratched') then exit;
  end
  else
  begin
    if (Name = 'luDQ') then exit;
  end;
  result := false;
end;

procedure TLaneColumnPicker.Prepare(AStateString: string; const
    AStateStringSystem: string; AGrid: TDBAdvGrid);
var
  I: Integer;
  fld: TField;
begin
  if Assigned(MyStateString) then
  begin
    MyStateString.StateString := AStateString;

    fStateStringSystem := AStateStringSystem;
    for I := 0 to MyStateString.ColCount-1 do
    begin
      // Black-Listif field not assigned....
      fld := AGrid.FieldAtColumn[I];
      if fld <> nil then
      begin
        // Black-List if special system field - not available to user.
        if not BlackList(fld.FieldName) then
        begin
          clbLane.AddItem(fld.DisplayLabel, fld);
          { Set check box here - bounds error. }
        end;
      end;
    end;

    // required second pass - else out-of-bounds errors
    for I := 0 to MyStateString.ColCount-1 do
    begin
      if (I >= 0) and (I < clbLane.Count) then
      begin
        if MyStateString.fColWidth[I] <> 0 then
          clbLane.Checked[i] := true
        else
          clbLane.Checked[i] := false;
        end;
    end;

  end;
end;

procedure TLaneColumnPicker.spbtnCloseClick(Sender: TObject);
begin
  fDoReset := false;
  ModalResult := mrOK;
end;

procedure TLaneColumnPicker.spbtnResetGrigLayoutClick(Sender: TObject);
begin
  fDoReset := true;
  ModalResult := mrOK;
end;

end.
