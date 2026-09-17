unit dlgReportPicker;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Vcl.Grids, AdvObj, BaseGrid,
  AdvGrid, DBAdvGrid, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  dmSCM2, dmCORE, Vcl.VirtualImage, frFrameReport;

type
  TReportPicker = class(TForm)
    pnlFooter: TPanel;
    pnlBody: TPanel;
    btnClose: TButton;
    btnCancel: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    fReportID: integer;
    frReport: TFrameReport;
  public
    property ReportID: integer read FReportID write FReportID;
  end;

var
  ReportPicker: TReportPicker;

implementation

{$R *.dfm}

procedure TReportPicker.btnCloseClick(Sender: TObject);
begin
    fReportID := frReport.ReportID;
    ModalResult := mrOK;
end;

procedure TReportPicker.FormCreate(Sender: TObject);
begin
  fReportID := 0;

  frReport := TFrameReport.Create(Self);
  frReport.Parent := pnlBody;
  frReport.Align := alClient;
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

end.
