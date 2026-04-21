unit frmReportManTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Datasnap.Provider, Datasnap.DBClient,
  Data.DB,

  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,

  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Graphics,

  rpcompobase, rpmdesignervcl,
  rpvclreport, rpalias;

type
  TReportManTest = class(TForm)
    RpDesignerVCL1: TRpDesignerVCL;
    FDConnection1: TFDConnection;
    dsSwimClub: TDataSource;
    RpAlias1: TRpAlias;
    VCLReport1: TVCLReport;
    tblSwimClub: TFDTable;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReportManTest: TReportManTest;

implementation

{$R *.dfm}


end.
