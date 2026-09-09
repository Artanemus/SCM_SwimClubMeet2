unit dlgReportPicker;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Vcl.Grids, AdvObj, BaseGrid,
  AdvGrid, DBAdvGrid, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  dmSCM2, dmCORE;

type
  TReportPicker = class(TForm)
    pnlHeader: TPanel;
    pnlFooter: TPanel;
    pnlBody: TPanel;
    btnClose: TButton;
    grid: TDBAdvGrid;
    qryReport: TFDQuery;
    dsReport: TDataSource;
    btnAllReports: TButton;
    btnRestore: TButton;
    btnBackUp: TButton;
    btnEdit: TButton;
    btnExecute: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReportPicker: TReportPicker;

implementation

{$R *.dfm}

end.
