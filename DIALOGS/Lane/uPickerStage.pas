unit uPickerStage;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes,
  System.UITypes, System.Actions, System.ImageList,

  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls,

  uDefines;

type

  TPickerStage = class(TComponent)
  private
    fEventType: scmEventType;
  public
    function Stage(AEventType: scmEventType; ALaneID: Integer; DoAltMethod:
        Boolean): Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


implementation

uses
  dlgEntrantPickerCTRL, dlgEntrantPicker, dlgTeamPickerCTRL, dlgTeamPicker;

function TPickerStage.Stage(AEventType: scmEventType; ALaneID: Integer;
    DoAltMethod: Boolean): Boolean;
var
mr: TModalResult;
begin
  // TODO -cMM: Stage default body inserted
  Result := false;
  case AEventType of
    etUnknown: ;
    etINDV:
    begin
      if DoAltMethod then
      begin
        var dlg: TEntrantPickerCTRL;
        dlg := TEntrantPickerCTRL.Create(Self);
        dlg.Prepare(ALaneID);
        dlg.ShowModal;
        dlg.Free;
      end
      else
      begin
        var dlg: TEntrantPicker;
        dlg := TEntrantPicker.Create(Self);
        dlg.Prepare(ALaneID);
        mr := dlg.ShowModal;
        if IsPositiveResult(mr) then
          result := true;
        dlg.Free;
      end;
      ;
    end;
    etTEAM:
    begin
      if DoAltMethod then
      begin
        var dlg: TTeamPickerCTRL;
        dlg := TTeamPickerCTRL.Create(Self);
        dlg.Prepare(ALaneID);
        dlg.ShowModal;
        dlg.Free;
      end
      else
      begin
        var dlg: TTeamPicker;
        dlg := TTeamPicker.Create(Self);
        dlg.Prepare(ALaneID);
        mr := dlg.ShowModal;
        if IsPositiveResult(mr) then
          result := true;
        dlg.Free;
      end;
      ;
    end;
  end;

end;

constructor TPickerStage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // TODO -cMM: TPickerStage.Create default body inserted
end;

destructor TPickerStage.Destroy;
begin
  inherited Destroy;
  // TODO -cMM: TPickerStage.Destroy default body inserted
end;

end.
