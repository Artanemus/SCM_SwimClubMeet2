unit frFrameReport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.VirtualImage, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, AdvUtil, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, DBAdvGrid,
  dmSCM2, dmCORE, Vcl.ComCtrls;

type
  TFrameReport = class(TFrame)
    pnHeaderl: TGridPanel;
    vimgSearch: TVirtualImage;
    edtSearch: TEdit;
    btnClearSearch: TButton;
    dsReport: TDataSource;
    qryReport: TFDQuery;
    pnlBody: TPanel;
    grid: TDBAdvGrid;
    cmboxReportTypes: TComboBoxEx;
    qryReportType: TFDQuery;
    procedure btnClearSearchClick(Sender: TObject);
    procedure cmboxReportTypesSelect(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
  private
    fReportID: integer;
    function GetReportID: integer;
    procedure SetReportID(const Value: integer);
    function GetReportTypeID: integer;
    procedure SetReportTypeID(const Value: integer);
  protected
    procedure Loaded; override;

  public
    property ReportID: integer read GetReportID write SetReportID;
    property ReportTypeID: integer read GetReportTypeID write SetReportTypeID;
  end;

implementation

{$R *.dfm}

procedure TFrameReport.btnClearSearchClick(Sender: TObject);
begin
  // changing text generates edtSearchChanged event.
  edtSearch.Text := '';
end;

procedure TFrameReport.cmboxReportTypesSelect(Sender: TObject);
begin
  edtSearchChange(Self);
end;

procedure TFrameReport.edtSearchChange(Sender: TObject);
var
  fs: String;
  i: integer;
begin
  // NOTE: CORE.qryFilterMember - filter options [foCaseInsensitive]
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  if not qryReport.Active then exit; // closed dataset.

  fs := '';
  grid.BeginUpdate;
  qryReport.DisableControls;
  try
    begin

      // filter by report type.
      if cmboxReportTypes.ItemIndex > 0  then
      begin
        i := integer(cmboxReportTypes.Items.Objects[cmboxReportTypes.ItemIndex]);
        fs := fs + '[ReportTypeID] = ' + IntToStr(i);
      end;

      // update filter string ....
      if (Length(edtSearch.Text) > 0) then
      begin
        if not fs.IsEmpty then fs := fs + ' AND ';
        fs := fs + '[Caption] LIKE ' + QuotedStr('%' + edtSearch.Text + '%');
      end;

      // assign filter
      if fs.IsEmpty then qryReport.Filtered := false
      else
      begin
        qryReport.Filter := fs;
        if not qryReport.Filtered then
          qryReport.Filtered := true;
      end;
    end;
  finally
    qryReport.EnableControls;
    grid.EndUpdate;
  end;
end;

function TFrameReport.GetReportID: integer;
begin
  fReportID := qryReport.FieldByName('ReportID').AsInteger;
  Result := FReportID;
end;

function TFrameReport.GetReportTypeID: integer;
begin
  result := integer(cmboxReportTypes.Items.Objects[cmboxReportTypes.ItemIndex]);
end;

procedure TFrameReport.gridDblClick(Sender: TObject);
begin
    fReportID := qryReport.FieldByName('ReportID').AsInteger;
end;

procedure TFrameReport.Loaded;
begin
  inherited;
  grid.RowCount := grid.FixedRows + 1; // rule: row count > fixed row.
  edtSearch.Text := '';
  fReportID := 0;

  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin

    qryReport.Connection := SCM2.scmConnection;
    qryReportType.Connection := SCM2.scmConnection;
    try
      qryReport.Open;
      qryReport.Filtered := false;
      qryReport.Filter := '';
      qryReportType.Open;

    except
      on E: EFDDBEngineException do
      begin
        SCM2.FDGUIxErrorDialog.Execute(E);
        exit;
      end;
    end;

    // Populate the comboBox with report types
    cmboxReportTypes.Clear;
    cmboxReportTypes.AddItem('Show all types.', TObject(0));
    While not qryReportType.EOF do
    begin
      cmboxReportTypes.AddItem(
      qryReportType.FieldByName('Caption').AsString,
      TObject(qryReportType.FieldByName('ReportTypeID').AsInteger));
      qryReportType.Next;
    end;
    if cmboxReportTypes.Items.Count > 0 then
      cmboxReportTypes.ItemIndex := 0;
  end;

end;

procedure TFrameReport.SetReportID(const Value: integer);
var
  SearchOptions: TLocateOptions;
begin
  if qryReport.IsEmpty then exit;
  SearchOptions := [];
  if qryReport.Locate('ReportID', Value,  SearchOptions) then
  begin
//    grid.Reload;
//    qryReport.Refresh;
  end;
end;

procedure TFrameReport.SetReportTypeID(const Value: integer);
var
  i: integer;
begin
  // locate the report type in the combobox and assign itemindex
  for i := 0 to cmboxReportTypes.Items.Count - 1 do
  begin
    if integer(cmboxReportTypes.Items.Objects[i]) = Value then
    begin
      if cmboxReportTypes.ItemIndex <> i then
        cmboxReportTypes.ItemIndex := i;
      exit;
    end;
  end;
end;

end.
