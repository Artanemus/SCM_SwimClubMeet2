unit frFrameMember;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.StdCtrls, Vcl.VirtualImage,

  dmSCM2, dmIMG, dmCORE, uDefines, Vcl.Buttons, AdvUtil, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, DBAdvGrid
  ;

type
  TFrameMember = class(TFrame)
    rpnlCntrl: TRelativePanel;
    pnlBody: TPanel;
    pnlList: TPanel;
    vimgSearch: TVirtualImage;
    edtSearch: TEdit;
    btnClearSearch: TButton;
    rpnlSearch: TRelativePanel;
    spbtnMemSort: TSpeedButton;
    ShapeMemBar1: TShape;
    spbtnMemReport: TSpeedButton;
    lblNomWarning: TLabel;
    grid: TDBAdvGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
