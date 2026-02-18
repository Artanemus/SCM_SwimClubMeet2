unit frmMM_ParaOlympic;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, frFrameMM_ListMember,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Buttons, Vcl.DBCtrls, Vcl.StdCtrls,
  Vcl.VirtualImage;

type
  TMM_ParaOlympic = class(TForm)
    vimgParaCodesInfo: TVirtualImage;
    lblParaCodes: TLabel;
    navParaCodes: TDBNavigator;
    dbgParaCode: TDBGrid;
    TFrameMM_ListMember1: TFrameMM_ListMember;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MM_ParaOlympic: TMM_ParaOlympic;

implementation

{$R *.dfm}

end.
