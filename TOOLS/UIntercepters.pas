unit uIntercepters;
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
  private
    procedure FixSessionBtns();
  protected
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
  end;

implementation


{ TSpeedButton Intercepter Logic }
procedure TSpeedButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
var
  SavedImages: TCustomImageList;
  SavedIndex: Integer;
  SavedName, objName, imglstName: string;
begin
  // Save local state
  if Assigned(Self.Images) then
  begin
    SavedImages := Self.Images;
    SavedIndex := Self.ImageIndex;
    SavedName  := Self.ImageName; // Important for TVirtualImageList
    objName := Self.Name;
    imglstName := SavedImages.Name;

    inherited ActionChange(Sender, CheckDefaults);

    // Restore local state
    Self.Images := SavedImages;

    if objName.Contains('spbtnSess')  then
      FixSessionBtns
    else
      begin
      if SavedName <> '' then
        Self.ImageName := SavedName
      else
        if Self.ImageIndex = -1 then
          Self.ImageIndex := TSpeedButton(Sender).Tag
        else
          Self.ImageIndex := SavedIndex;
      end;
  end
  else
    inherited ActionChange(Sender, CheckDefaults);

end;

procedure TSpeedButton.FixSessionBtns();
begin
  Self.ImageIndex := Self.Tag;
end;

end.
