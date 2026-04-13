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
    fSysStateString: string;
    fColumns: TDBGridColumnCollection;
    TAStateString: TStateString; // Columns count, width, order, visibility.

  protected

  public
    { Public declarations }
    procedure Prepare(AStateString: string; const ASysStateString: string; AGrid:
        TDBAdvGrid);

    property DoReset: boolean read FDoReset write FDoReset;

  end;

var
  LaneColumnPicker: TLaneColumnPicker;

implementation

{$R *.dfm}

procedure TLaneColumnPicker.FormDestroy(Sender: TObject);
begin

  TAStateString.Free;
end;

procedure TLaneColumnPicker.clbLaneClickCheck(Sender: TObject);
var
  fld: TField;
  ABSindx, indx: integer;
  TempStateString: TStateString;
begin
  if Assigned(TAStateString) then
  begin
    TAStateString.fColVisible[clbLane.ItemIndex] :=
      clbLane.Checked[clbLane.ItemIndex].ToInteger;

    // calculate a width for the column using fSysStateString.
    TempStateString := TStateString.Create;
    TempStateString.StateString := fSysStateString;

    ABSindx := TAStateString.fColOrder[clbLane.ItemIndex];
    // locate ABSIndex in
    indx := TempStateString.LookUpREFindex(ABSindx);
    if TempStateString.fColWidth[indx] <> 0 then
      TAStateString.fColWidth[clbLane.ItemIndex] :=
        TempStateString.fColWidth[indx];

    TempStateString.Free;
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

  TAStateString := TStateString.Create;
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
    ASysStateString: string; AGrid: TDBAdvGrid);
var
  fld: TField;
  I, ABSindx: Integer;
begin
  if Assigned(TAStateString) then
  begin
    TAStateString.StateString := AStateString;

    fSysStateString := ASysStateString;
    for I := 0 to TAStateString.ColCount-1 do
    begin
      ABSindx := TAStateString.fColOrder[I];

      // BlackListed if invisible....
      if AGrid.Fields[ABSindx].Visible then
      begin
        clbLane.AddItem(AGrid.Columns[ABSindx].Header, AGrid.Fields[ABSindx]);
        if TAStateString.fColWidth[I] <> 0 then
          clbLane.Checked[i] := true else clbLane.Checked[i] := false;
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
