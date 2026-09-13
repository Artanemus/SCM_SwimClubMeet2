unit dlgReportPicker;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Vcl.Grids, AdvObj, BaseGrid,
  AdvGrid, DBAdvGrid, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  dmSCM2, dmCORE, Vcl.VirtualImage;

type
  TReportPicker = class(TForm)
    pnlFooter: TPanel;
    pnlBody: TPanel;
    btnClose: TButton;
    grid: TDBAdvGrid;
    qryReport: TFDQuery;
    dsReport: TDataSource;
    pnHeaderl: TGridPanel;
    vimgSearch: TVirtualImage;
    edtSearch: TEdit;
    btnClearSearch: TButton;
    btnCancel: TButton;
    procedure btnClearSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure gridDblClick(Sender: TObject);
  private
    fReportID: integer;
  public
    { Public declarations }
  end;

var
  ReportPicker: TReportPicker;

implementation

{$R *.dfm}

procedure TReportPicker.btnClearSearchClick(Sender: TObject);
begin
  // changing text generates edtSearchChanged event.
  edtSearch.Text := '';
end;

procedure TReportPicker.FormCreate(Sender: TObject);
begin
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

procedure TReportPicker.edtSearchChange(Sender: TObject);
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

procedure TReportPicker.FormKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if Key=VK_ESCAPE then
  begin
    Key := 0;
    fReportID := 0;
    ModalResult := mrCancel;
  end;
end;

procedure TReportPicker.gridDblClick(Sender: TObject);
begin
    fReportID := qryReport.FieldByName('ReportID').AsInteger;
    ModalResult := mrOK;
end;

end.
