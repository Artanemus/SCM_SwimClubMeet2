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
    ComboBoxEx1: TComboBoxEx;
    qryReportType: TFDQuery;
    procedure btnClearSearchClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
  private
    fReportID: integer;
    function GetReportID: integer;
    procedure SetReportID(const Value: integer);
  protected
    procedure Loaded; override;

  public
    property ReportID: integer read GetReportID write SetReportID;
  end;

implementation

{$R *.dfm}

procedure TFrameReport.btnClearSearchClick(Sender: TObject);
begin
  // changing text generates edtSearchChanged event.
  edtSearch.Text := '';
end;

procedure TFrameReport.edtSearchChange(Sender: TObject);
var
  fs: String;
begin
  // NOTE: CORE.qryFilterMember - filter options [foCaseInsensitive]
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  if not qryReport.Active then exit; // closed dataset.

  fs := '';
  grid.BeginUpdate;
  qryReport.DisableControls;
  try
    begin
      // update filter string ....
      if (Length(edtSearch.Text) > 0) then
      begin
        fs := fs + '[FName] LIKE ' + QuotedStr('%' + edtSearch.Text + '%');
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
    try
      qryReport.Open;
      qryReport.Filtered := false;
      qryReport.Filter := '';
    except
      on E: EFDDBEngineException do
        SCM2.FDGUIxErrorDialog.Execute(E);
    end;
  end;

end;

procedure TFrameReport.SetReportID(const Value: integer);
begin
  // locate reportID.
end;

end.
