unit dlgSwimClub_Edit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  dmSCM2, dmCORE, frFrameSwimClub;

type
  TSwimClubEdit = class(TForm)
    pnlFooter: TPanel;
    pnlBody: TPanel;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    frSwimClub: TFrameSwimClub;
  public
    procedure Prepare();
  end;

var
  SwimClubEdit: TSwimClubEdit;

implementation

{$R *.dfm}

procedure TSwimClubEdit.FormDestroy(Sender: TObject);
begin
  frSwimClub.CheckAndSaveData;
  if Assigned(frSwimClub) then
    FreeAndNil(frSwimClub);
end;

procedure TSwimClubEdit.Prepare;
begin
  if Assigned(frSwimClub) then
  begin
    frSwimClub.Parent := pnlBody;
    frSwimClub.Align := alClient;
    frSwimClub.Prepare();
  end;
end;

procedure TSwimClubEdit.FormCreate(Sender: TObject);
begin
  frSwimClub := TFrameSwimClub.Create(Self);
end;

end.
