unit frmMM_MetaData;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, frFrameMM_ListMember;

type
  TMM_MetaData = class(TForm)
    pnlList: TPanel;
    MMframe: TFrameMM_ListMember;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MM_MetaData: TMM_MetaData;

implementation

{$R *.dfm}

end.
