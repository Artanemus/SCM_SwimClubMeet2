unit frmTestFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frFrameSwimClub, frFrameClubGroup, Vcl.ExtCtrls,
  Vcl.StdCtrls,
  uSwimClub;

type
  TTestFrame = class(TForm)
    pnlBody: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    frSwimClub: TFrameSwimClub;
  public
  end;

var
  TestFrame: TTestFrame;

implementation

{$R *.dfm}

procedure TTestFrame.FormCreate(Sender: TObject);
begin
  frSwimClub := TFrameSwimClub.Create(Self);
  frSwimClub.Parent := pnlBody;
  frSwimClub.Align := alClient;
  frSwimClub.Prepare();

end;

procedure TTestFrame.FormDestroy(Sender: TObject);
begin
  // Ask user if they want to save changes
  {
  if frCG.IsChanged then
  begin
    case MessageDlg('Save changes?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrYes:
        frCG.CheckAndSaveData;
      mrCancel:
        // CanClose := False;
    end;
  end;
  }

  // force an update of dbo.ClubGroups if changes have been made.
  frSwimClub.CheckAndSaveData;
end;

end.
