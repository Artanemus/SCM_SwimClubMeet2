unit frFrameLane;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.Grids, Vcl.ImgList,

  AdvUtil,
  AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmIMG, dmSCM2, dmCORE, System.Actions, Vcl.ActnList, Vcl.Menus, Vcl.Buttons,

  uSession, uEvent, uHeat,

  // THE INTERCEPTER MUST GO HERE - last in uses list
  UIntercepters;

type
  TFrameLane = class(TFrame)
    rpnlCntrl: TRelativePanel;
    spbtnMoveUp: TSpeedButton;
    actnlistLane: TActionList;
    pumenuLane: TPopupMenu;
    pnlBody: TPanel;
    grid: TDBAdvGrid;
    spbtnMoveDown: TSpeedButton;
    spbtnSwitch: TSpeedButton;
    spbtnDelete: TSpeedButton;
    spbtnDeleteForever: TSpeedButton;
    actnMoveUp: TAction;
    actnMoveDown: TAction;
    actnSwap: TAction;
    actnDelete: TAction;
    actnDeleteForever: TAction;
    actnReport: TAction;
    ShapeLnBar1: TShape;
    spbtnReport: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
