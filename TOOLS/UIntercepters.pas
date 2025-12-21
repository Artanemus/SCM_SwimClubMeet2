unit UIntercepters;
{
One Unit Rule: If you have multiple Frames, you don't want to copy-paste the
intercepter into every unit. You can create a "Base" unit
(e.g., UIntercepters.pas), put the TSpeedButton definition there, and then
ensure UIntercepters is the last unit in the uses clause of your Frame units.
}


interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ActnList,
  Vcl.VirtualImageList, Vcl.ImgList;

type
  // 1. THE INTERCEPTER MUST GO HERE (Before the TFrame declaration)
  TSpeedButton = class(Vcl.Buttons.TSpeedButton)
  protected
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
  end;

implementation


{ TSpeedButton Intercepter Logic }
procedure TSpeedButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
var
  SavedImages: TCustomImageList;
  SavedIndex: Integer;
  SavedName: string;
begin
  // Save local state
  SavedImages := Self.Images;
  SavedIndex := Self.ImageIndex;
  SavedName  := Self.ImageName; // Important for TVirtualImageList

  inherited ActionChange(Sender, CheckDefaults);

  // Restore local state
  Self.Images := SavedImages;
  if SavedName <> '' then
    Self.ImageName := SavedName
  else
    Self.ImageIndex := SavedIndex;
end;

end.
