unit dlgLaneColumnPicker;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Contnrs,

  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.WinXPanels,

  Data.DB,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmSCM2, dmCORE, dmIMG, uDefines, uSettings, uStateString, Vcl.WinXCtrls,
  System.ImageList, Vcl.ImgList, Vcl.VirtualImageList, SVGIconVirtualImageList;

type

  TLaneItem = class(TObject)
  private
  protected
    // CORE.qryLane metrics...
    fFieldName: string; // DB field name
    fFieldIndex: integer; // DB ABS index
    fFieldVisible: boolean; // Visibility
    fFieldDisplayLabel: string; // User friendly, descriptive.
    fFieldDisplayWidth: integer;
    // Design time metrics...
    fSysColWidth: integer; // ref fStateStringSystem
    // Run-time TMS TDBAdvgrid.ColumnStateString
    fColIndex: integer; // sync fFieldIndex with fColIndex.
    fColWidth: integer;
    fCBLIndex: integer;
  public
    constructor Create;
    destructor Destroy; override;

  end;

  TLaneColumnPicker = class(TForm)
    pnlBody: TPanel;
    clbLane: TCheckListBox;
    spbtnSaveGridMetrics: TSpeedButton;
    spbtnLoadGridMetrics: TSpeedButton;
    spbtnResetGrigLayout: TSpeedButton;
    spbtnClose: TSpeedButton;
    rpnlCntrl: TRelativePanel;
    SVGList: TSVGIconVirtualImageList;
    spbtnUpdate: TSpeedButton;
    FileOpenDlg: TFileOpenDialog;
    FileSaveDlg: TFileSaveDialog;
    procedure FormDestroy(Sender: TObject);
    procedure clbLaneClickCheck(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure spbtnCloseClick(Sender: TObject);
    procedure spbtnResetGrigLayoutClick(Sender: TObject);
  private
    { Private declarations }
    fStateString: string;
    LaneItems: TObjectList;
    function GetStateString(): string;
  protected
    procedure FillCheckBoxList(AStateString: string);

    {indxType
      0-fcolindx
      1-ffieldindx
      2-cblindex}
    function LookUpLaneItem(indx: integer; LaneItems: TObjectList; indxType:
      Integer = 0): TLaneItem;
  public
    { Public declarations }
    procedure Prepare(AStateString: string; AGrid: TDBAdvGrid);

    property StateString: string read GetStateString;

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
  width: integer;
begin
  ss := fStateString; // note: value here was assigned in Prepare()
  // get the lane item data using the stored fCBLIndex...
  LI := LookUpLaneItem(clbLane.ItemIndex, LaneItems, 2);
  if LI <> nil then
  begin
    width := LI.fColWidth;
    if width = 0 then
      width := LI.fFieldDisplayWidth;
    if width = 0 then
      width := LI.fSysColWidth;
    if (width < 20) then
      width := 20;
    // use the Grid's column index.
    // toggle visibility   (ABS index, checked/un-checked)
    ss.SetColVisible(LI.fColIndex, clbLane.Checked[clbLane.ItemIndex], width);
    if ss.ErrorCode = 0 then
      // update the string.
      fStateString := ss.Value;
  end;
end;

function TLaneColumnPicker.LookUpLaneItem(indx: integer; LaneItems:
  TObjectList; indxType: Integer = 0): TLaneItem;
var
  LI: TLaneItem;
  I: integer;
begin
  result := nil;
  for I := 0 to LaneItems.Count - 1 do
  begin
    LI := TLaneItem(LaneItems.Items[I]);
    case indxType of
      0:
        if LI.fColIndex = indx then
        begin
          result := LI;
          break;
        end;
      1:
        if LI.fFieldIndex = indx then
        begin
          result := LI;
          break;
        end;
      2:
        if LI.fCBLIndex = indx then
        begin
          result := LI;
          break;
        end;
    end;
  end;
end;

procedure TLaneColumnPicker.FillCheckBoxList(AStateString: string);
var
  indx: integer;
  J: Integer;
  LI: TLaneItem;
  ss: TStateString;

begin
  ss := AStateString; // special record to work with TMS's StateStrings.


  { Use sort order as given in statestring. }

  // ... ADD visible items to the check list box.
  for J := 0 to ss.ColCount - 1 do
  begin
    indx := ss.GetColOrder(J);
    if indx = -1 then continue;
    LI := LookUpLaneItem(indx, LaneItems, 0);
    if LI = nil then continue;

    if LI.fColwidth > 0 then // visible items are stacked first.
    begin
      indx := clbLane.Items.AddObject(LI.fFieldDisplayLabel, LI);
      clbLane.Checked[indx] := true;
      LI.fCBLIndex := indx;
    end;
  end;
  // ... ADD hidden items to the check list box.
  for J := 0 to ss.ColCount - 1 do
  begin
    indx := ss.GetColOrder(J);
    if indx = -1 then continue;
    LI := LookUpLaneItem(indx, LaneItems, 0);
    if LI = nil then continue;
    if LI.fColwidth = 0 then // invisible items are stacked last.
    begin
      indx := clbLane.Items.AddObject(LI.fFieldDisplayLabel, LI);
      clbLane.Checked[indx] := false;
      LI.fCBLIndex := indx;
    end;
  end;
end;

procedure TLaneColumnPicker.FormCreate(Sender: TObject);
begin
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
    ModalResult := mrOk;
  end;
end;

function TLaneColumnPicker.GetStateString: string;
begin
  { This ensures that columns with width = 0 are invisible.}
  result := fStateString;
end;

procedure TLaneColumnPicker.Prepare(AStateString: string; AGrid: TDBAdvGrid);
var
  J: Integer;
  fld: TField;
  LI: TLaneItem;
  GI: TDBGridColumnItem;
  DS: TDataSet;
begin
  fStateString := AStateString; // store.

  clbLane.Items.Clear;
  DS := AGrid.DataSource.DataSet;
  // Populate the LaneItems array.
  for J := 0 to AGrid.Columns.Count - 1 do
  begin
    GI := AGrid.Columns[J];
    fld := DS.FieldByName(AGrid.Columns[J].FieldName);
    if fld <> nil then
    begin
      LI := TLaneItem.Create;
      LI.fFieldName := fld.FieldName;
      LI.fFieldIndex := fld.Index; // sync reference. ABS
      LI.fFieldVisible := fld.Visible; // Visibility = on the White-List.
      LI.fFieldDisplayLabel := fld.DisplayLabel;
      LI.fFieldDisplayWidth := fld.DisplayWidth;
      LI.fColIndex := AGrid.RealColIndex(J); // sync reference. ABS?
      LI.FColWidth := GI.Width; // last know width. 0=hidden.
      LI.fSysColWidth := 0;  // obtain from Settings.Ln_ColumnStateStringSys
      LaneItems.Add(LI);
    end;
  end;

  FillCheckBoxList(AStateString);

end;

procedure TLaneColumnPicker.spbtnCloseClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TLaneColumnPicker.spbtnResetGrigLayoutClick(Sender: TObject);
var
  s: string;
begin
  if Assigned(Settings) then
  begin
    s := Settings.Ln_ColumnStatesStringSystem;
    FillCheckBoxList(s);
  end;
end;

constructor TLaneItem.Create;
begin
  inherited;
  fFieldName := '';
  fFieldIndex := -1;
  fFieldVisible := true;
  fSysColWidth := 30;
  fColINDEX := -1;
  fCBLIndex := -1;
end;

destructor TLaneItem.Destroy;
begin
  inherited;
  // TODO -cMM: TLaneItem.Destroy default body inserted
end;

end.

