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
    fFieldDisplayLabel: string; // User friendly, descriptive.
    fFieldDisplayWidth: integer; // Design-Time metric..
    fSysColWidth: integer; // Default system width (fall-back).
    fColOrderIndex: integer; // StateString value
    fLastKnowGridWidth: integer; // Last user metrics.
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
    spbtnUp: TSpeedButton;
    spbtnDown: TSpeedButton;
    procedure FormDestroy(Sender: TObject);
    procedure clbLaneClickCheck(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure spbtnCloseClick(Sender: TObject);
    procedure spbtnResetGrigLayoutClick(Sender: TObject);
  private
    { Private declarations }
    ss: TStateString;
    LaneItems: TObjectList;
    function GetStateString(): string;
  protected
    procedure FillCheckBoxList;
    function LookUpSysDefWidth(Index: integer; DataSetName: string): integer;
  public
    { Public declarations }
    procedure Prepare(AGrid: TDBAdvGrid);

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
  LI: TLaneItem;
  width: integer;
begin
  // get the lane item data using the stored fCBLIndex...
  LI := TLaneItem(clbLane.Items.Objects[clbLane.ItemIndex]);
  if LI <> nil then
  begin
    if clbLane.Checked[clbLane.ItemIndex] then
    begin
      width := ss.GetColWidth(LI.fColOrderIndex);
      if width = 0 then
        width := LI.fLastKnowGridWidth;
      if width = 0 then
        width := LI.fFieldDisplayWidth;
      if width = 0 then
        width := LI.fSysColWidth; // Fall-Back.
      if (width < 20) then
        width := 20;
    end
    else
      width := 0;
    // update the state string
    ss.SetColWidth(LI.fColOrderIndex, width);
  end;
end;



procedure TLaneColumnPicker.FillCheckBoxList;
var
  indx, I: integer;
  J: Integer;
  LI: TLaneItem;
begin
  { ADD visible items to the check list box.
      Use the sort order as given in statestring.
      ss.ColCount[0] is primary key LaneID and isn't included in cblLane as
      this would give the user the ability to remove it - the hamberger would
      vanish and the user wouldn't be unable to use the column picker!
  }
  // ADD visible items. They are stacked first.
  for J := 1 to ss.ColCount - 1 do // ommit column 0 (selector)
  begin
    if ss.GetColwidth(j) > 0 then
    begin
      LI := nil;
      for I := 0 to LaneItems.Count - 1 do
      begin
        LI := TLaneItem(LaneItems[I]);
        if LI.fColOrderIndex = j then
          break;
      end;
      if LI<>nil then
      begin
        indx := clbLane.Items.AddObject(LI.fFieldDisplayLabel, LI);
        clbLane.Checked[indx] := true;
      end;
    end;
  end;
  // ADD hidden items to the check list box.
  for J := 1 to ss.ColCount - 1 do // ommit column 0 (selector)
  begin
    if ss.GetColWidth(J) = 0 then
    begin
      LI := nil;
      for I := 0 to LaneItems.Count - 1 do
      begin
        LI := TLaneItem(LaneItems[I]);
        if LI.fColOrderIndex = J then
            break;
      end;
      if LI <> nil then
      begin
        indx := clbLane.Items.AddObject(LI.fFieldDisplayLabel, LI);
        clbLane.Checked[indx] := false;
      end;
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
  result := ss.value;
end;

function TLaneColumnPicker.LookUpSysDefWidth(Index: integer; DataSetName:
    string): integer;
var
  s: string;
  SysStateString: TStateString;
  width: integer;
begin
  result := 64;
  if Assigned(Settings) then
  begin
    if DataSetName = 'qryLane' then
      s := Settings.Ln_ColumnStatesStringSystem
    else if DataSetName = 'qryEvent' then
      s := Settings.Ev_ColumnStatesStringSystem
    else
      exit;

    if not s.IsEmpty then
    begin
      SysStateString := s;
      width := SysStateString.GetColWidth(Index);
      if width > 0 then Result := width;
    end;
  end;
end;

procedure TLaneColumnPicker.Prepare(AGrid: TDBAdvGrid);
var
  J, RealColIndex: Integer;
  fld: TField;
  LI: TLaneItem;
  GI: TDBGridColumnItem;
  DS: TDataSet;
begin

  ss := AGrid.ColumnStatesToString; // StateString TESTED - OK!

  clbLane.Items.Clear;
  DS := AGrid.DataSource.DataSet;

  { Populate the LaneItems array.}
  for J := 0 to ss.ColCount - 1 do
  begin
    RealColIndex := ss.GetColOrder(j); // value held here is the TMS RealColIndex.
    GI := AGrid.Columns[j]; // TMS auto transforms - sort-order index to realcol index.
    fld := DS.FieldByName(GI.FieldName);
    if (fld <> nil) then
    begin
//      if fld.FieldName = 'LaneID' then
//        continue;
      LI := TLaneItem.Create;
      LI.fFieldName := fld.FieldName;
      LI.fFieldDisplayLabel := fld.DisplayLabel;
      LI.fFieldDisplayWidth := fld.DisplayWidth;
      LI.fColOrderIndex := J; // sync point used by CheckBoxList to ref. StateString.
      LI.fLastKnowGridWidth := GI.Width; // last know TMS grid width. 0 = hidden.
      LI.fSysColWidth := LookUpSysDefWidth(RealColIndex, DS.Name); // default 64;
      LaneItems.Add(LI);
    end;
  end;

  FillCheckBoxList;

end;

procedure TLaneColumnPicker.spbtnCloseClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TLaneColumnPicker.spbtnResetGrigLayoutClick(Sender: TObject);
begin
  // use system default layout.
end;

constructor TLaneItem.Create;
begin
  inherited;
  fFieldName := '';
  fSysColWidth := 30;
  fColOrderIndex := -1;
end;

destructor TLaneItem.Destroy;
begin
  inherited;
  // TODO -cMM: TLaneItem.Destroy default body inserted
end;

end.
