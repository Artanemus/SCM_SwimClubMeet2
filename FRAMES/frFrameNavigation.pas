unit frFrameNavigation;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, AdvNavBar,
  Vcl.WinXPanels, dmIMG, Vcl.VirtualImage, Vcl.StdCtrls, Vcl.ControlList;

type
  TFrameNavigation = class(TFrame)
    ControlList1: TControlList;
    Label1: TLabel;
    VirtualImage1: TVirtualImage;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
