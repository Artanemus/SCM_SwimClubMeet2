unit dlgTeamPickerCTRL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TTeamPickerCTRL = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
    function Prepare(LaneID: Integer): boolean;
  end;

var
  TeamPickerCTRL: TTeamPickerCTRL;

implementation

{$R *.dfm}

{ TTeamPickerCTRL }

function TTeamPickerCTRL.Prepare(LaneID: Integer): boolean;
begin
  ;
end;

end.
