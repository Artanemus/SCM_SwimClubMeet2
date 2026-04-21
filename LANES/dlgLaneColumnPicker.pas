unit dlgLaneColumnPicker;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Contnrs,

  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst,
  Vcl.ExtCtrls,  Vcl.Buttons, Vcl.WinXPanels,

  Data.DB,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmSCM2, dmCORE, dmIMG, uDefines, uSettings, uStateString;

type


  TLaneItem = class(TObject)
  private
  protected
    // CORE.qryLane metrics...
    fFieldName: string;   // DB field name
    fFieldIndex: integer;  // DB ABS index
    fFieldVisible: boolean; // Visibility
    fFieldDisplayLabel: string; // User friendly, descriptive.
    // Design time metrics...
    fSysColWidth: integer; // ref fStateStringSystem
    // Run-time TMS TDBAdvgrid.ColumnStateString
    fColIndex: integer; // sync fFieldIndex with fColIndex.
    fColWidth: integer;
  public
    constructor Create;
    destructor Destroy; override;

  end;

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
    fStateString: string;
    LaneItems: TObjectList;
  protected

  public
    { Public declarations }
    procedure Prepare(AStateString: string; AGrid: TDBAdvGrid);

    property DoReset: boolean read FDoReset write FDoReset;
    property StateString: string read fStateString;

  end;

var
  LaneColumnPicker: TLaneColumnPicker;

implementation

{$R *.dfm}


procedure TLaneColumnPicker.FormDestroy(Sender: TObject);
begin
  LaneItems.Clear;
  LaneItems.Free;
end;

procedure TLaneColumnPicker.clbLaneClickCheck(Sender: TObject);
var
  ss: TStateString; // record to deal with TMS's StateStrings.
  LI: TLaneItem;
begin
  ss := fStateString; // note: value here was assigned in Prepare()
  try
    // get the lane item data
    LI := TLaneItem(LaneItems.items[clbLane.ItemIndex]);
    // use the ABS index - the Grid's true column index.
    // toggle visibility   (ABS index, checked/un-checked)
    ss.SetColVisible(LI.fColIndex, clbLane.Checked[clbLane.ItemIndex]);
    if ss.ErrorCode = 0 then
      // update the string.
      fStateString := ss.Value;
  finally
  end;
end;

procedure TLaneColumnPicker.FormCreate(Sender: TObject);
begin
  fDoReset := false;
  clbLane.Items.Clear; // empty any items placed at design-time.
  // system checks
  if not (Assigned(CORE) and CORE.IsActive) or CORE.qryLane.IsEmpty then
  begin
    ModalResult := mrCancel;
    Close;
  end;
  LaneItems := TObjectList.Create(true); // Owns objects.
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

procedure TLaneColumnPicker.Prepare(AStateString: string; AGrid: TDBAdvGrid);
var
  I, J, indx: Integer;
  fld: TField;
  LI: TLaneItem;
  GI: TDBGridColumnItem;
  ss: TStateString;
  DS: TDataSet;
begin
    fStateString := AStateString; // snap-shot of the grids UI

    // Add fields that are visible to the LaneItems array.
    DS := AGrid.DataSource.DataSet;
    for I := 0 to DS.Fields.Count-1 do
    begin
      fld := DS.Fields[I];
      if fld <> nil then
      begin
        if fld.Visible then
        begin
          LI := TLaneItem.Create;
          LI.fFieldName := fld.FieldName;
          LI.fFieldIndex := fld.Index;  // sync reference.
          LI.fFieldVisible := fld.Visible; // Visibility = on the White-List.
          LI.fFieldDisplayLabel := fld.DisplayLabel;
          indx := LaneItems.Add(LI);
        end;
      end;
    end;
    // add the sync data: Grid's ColIndex <--> DataBase FieldIndex.
    for J :=0 to AGrid.Columns.Count-1 do
    begin
      GI := AGrid.Columns[J];
      for I := 0 to LaneItems.Count-1 do
      begin
        LI := TLaneItem(LaneItems.Items[I]);
        if GI.FieldName = LI.fFieldName then
        begin
          LI.fColIndex := j; // sync reference.
          LI.FColWidth := GI.Width; // may be helpful to set a default width.
          continue;
        end;
      end;
    end;

    ss := AStateString; // special record to work with TMS's StateStrings.

    // ... ADD visible items to the check list box.
    for J := 0 to ss.ColCount-1 do
    begin
      //
      indx := ss.GetColOrder(J);
      for I := 0 to LaneItems.Count-1 do
      begin
        LI := TLaneItem(LaneItems.Items[I]);
        if LI.fColIndex = indx then
        begin
          // visible items are stacked at the top of the list
          if LI.fColwidth > 0 then
            // matching sort order as displayed in grid. grid.
            clbLane.AddItem(LI.fFieldDisplayLabel, LI);
        end;
      end;
    end;

    // ... ADD hidden items to the check list box.
    for J := 0 to ss.ColCount-1 do
    begin
      //
      indx := ss.GetColOrder(J);
      for I := 0 to LaneItems.Count-1 do
      begin
        LI := TLaneItem(LaneItems.Items[I]);
        if LI.fColIndex = indx then
        begin
          // hidden items are stacked at the bottom of the list
          if LI.fColwidth = 0 then
            clbLane.AddItem(LI.fFieldDisplayLabel, LI);
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

constructor TLaneItem.Create;
begin
  inherited;
  fFieldName := '';
  fFieldIndex := -1;
  fFieldVisible := true;
  fSysColWidth := 30;
  fColINDEX := -1;
end;

destructor TLaneItem.Destroy;
begin
  inherited;
  // TODO -cMM: TLaneItem.Destroy default body inserted
end;

end.
