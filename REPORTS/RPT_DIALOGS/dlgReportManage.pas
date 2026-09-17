unit dlgReportManage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.WinXPanels,
  dmSCM2, dmCORE, dmIMG, dmRPT, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, AdvUtil, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, DBAdvGrid;

type
  TReportManage = class(TForm)
    pnlHeader: TPanel;
    pnlFooter: TPanel;
    pnlBody: TPanel;
    spnlCNTRL: TStackPanel;
    spbtnNew: TSpeedButton;
    spbtnDelete: TSpeedButton;
    spbtnEdit: TSpeedButton;
    spbtnSave: TSpeedButton;
    spbtnLoad: TSpeedButton;
    spbtnArchive: TSpeedButton;
    qryReport: TFDQuery;
    dsReport: TDataSource;
    spbtnClone: TSpeedButton;
    spbtnSaveAs: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReportManage: TReportManage;

implementation

{$R *.dfm}

end.
