unit dlgSwimCategory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  dmSCM2, AdvUtil, Vcl.StdCtrls, Vcl.Buttons, Vcl.DBCtrls, Vcl.ExtCtrls,
  Vcl.Grids, AdvObj, BaseGrid, AdvGrid, DBAdvGrid;

type
  TSwimCategory = class(TForm)
    qrySwimCategories: TFDQuery;
    qrySwimCategoriesSwimClubTypeID: TFDAutoIncField;
    qrySwimCategoriesCaption: TWideStringField;
    qrySwimCategoriesShortCaption: TWideStringField;
    qrySwimCategoriesABREV: TWideStringField;
    qrySwimCategoriesIsArchived: TBooleanField;
    qrySwimCategoriesIsActive: TBooleanField;
    dsSwimCategories: TDataSource;
    Grid: TDBAdvGrid;
    pnlHeader: TPanel;
    pnlFooter: TPanel;
    pnlBody: TPanel;
    Nav: TDBNavigator;
    lblHeader: TLabel;
    btnExit: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SwimCategory: TSwimCategory;

implementation

{$R *.dfm}

end.
