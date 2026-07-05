unit dlgABDebug;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids, dmABINDV_Data;

type
  TABDebug = class(TForm)
    grid: TDBGrid;
    pnlFooter: TPanel;
    pnlBody: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ABDebug: TABDebug;

implementation

{$R *.dfm}

end.
