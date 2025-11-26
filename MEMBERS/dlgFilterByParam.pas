unit dlgFilterByParam;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  Vcl.StdCtrls, Vcl.ButtonGroup, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, SCMUtils, uDefines;

type
  PFilterState = ^TFilterState;
  TFilterState = record
    HideArchived: Boolean;
    HideInactive: Boolean;
    HideNonSwimmer: Boolean;
  end;

  TFilterByParam = class(TForm)
    btngrpFilter: TButtonGroup;
    filterImageCollection: TImageCollection;
    filterImageList32x32: TVirtualImageList;
    filterActionManager: TActionManager;
    actnHideArchived: TAction;
    actnHideInActive: TAction;
    actnHideNonSwimmer: TAction;
    actnClose: TAction;
    actnClear: TAction;
    procedure actnClearExecute(Sender: TObject);
    procedure actnClearUpdate(Sender: TObject);
    procedure actnCloseExecute(Sender: TObject);
    procedure actnHideArchivedExecute(Sender: TObject);
    procedure actnHideArchivedUpdate(Sender: TObject);
    procedure actnHideInActiveExecute(Sender: TObject);
    procedure actnHideInActiveUpdate(Sender: TObject);
    procedure actnHideNonSwimmerExecute(Sender: TObject);
    procedure actnHideNonSwimmerUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure SendFilterDataPacket();
  private
    fFilterState: TFilterState;
    procedure ReadPreferences();
    procedure WritePreferences();
    procedure SetIconDisplayState();
  public
    { Public declarations }
    // property HideArchived: boolean read FHideArchived write FHideArchived;
    // property HideInActive: boolean read fHideInActive write fHideInActive;
    // property HideNonSwimmer: boolean read fHideNonSwimmer write fHideNonSwimmer;
  end;

const
  INIFILE_SECTION = 'SCM_Member';

var
  FilterByParam: TFilterByParam;

implementation

{$R *.dfm}

Uses IniFiles;

procedure TFilterByParam.actnClearExecute(Sender: TObject);
begin
  actnHideArchived.Checked := false;
  actnHideInActive.Checked := false;
  actnHideNonSwimmer.Checked := false;
  SetIconDisplayState;
  SendFilterDataPacket;
end;

procedure TFilterByParam.actnClearUpdate(Sender: TObject);
begin
  if actnHideArchived.Checked or actnHideInActive.Checked or actnHideNonSwimmer.Checked
  then TAction(Sender).ImageName := 'filter_alt'
  else TAction(Sender).ImageName := 'filter_alt_off';
end;

procedure TFilterByParam.actnCloseExecute(Sender: TObject);
begin
  WritePreferences;
  ModalResult := mrOK;
end;

procedure TFilterByParam.actnHideArchivedExecute(Sender: TObject);
begin
  TAction(Sender).Checked := not TAction(Sender).Checked;
  SetIconDisplayState;
  SendFilterDataPacket;
end;

procedure TFilterByParam.actnHideArchivedUpdate(Sender: TObject);
begin
  if TAction(Sender).Checked then TAction(Sender).ImageName := 'Checked'
  else TAction(Sender).ImageName := 'UnChecked';
end;

procedure TFilterByParam.actnHideInActiveExecute(Sender: TObject);
begin
  TAction(Sender).Checked := not TAction(Sender).Checked;
  SetIconDisplayState;
  SendFilterDataPacket;
end;

procedure TFilterByParam.actnHideInActiveUpdate(Sender: TObject);
begin
  if TAction(Sender).Checked then TAction(Sender).ImageName := 'Checked'
  else TAction(Sender).ImageName := 'UnChecked';
end;

procedure TFilterByParam.actnHideNonSwimmerExecute(Sender: TObject);
begin
  TAction(Sender).Checked := not TAction(Sender).Checked;
  SetIconDisplayState;
  SendFilterDataPacket;
end;

procedure TFilterByParam.actnHideNonSwimmerUpdate(Sender: TObject);
begin
  if TAction(Sender).Checked then TAction(Sender).ImageName := 'Checked'
  else TAction(Sender).ImageName := 'UnChecked';
end;

procedure TFilterByParam.FormCreate(Sender: TObject);
begin
  actnHideArchived.Checked := false;
  actnHideInActive.Checked := false;
  actnHideNonSwimmer.Checked := false;
end;

procedure TFilterByParam.FormDeactivate(Sender: TObject);
begin
  WritePreferences; // record filter state
  PostMessage(TForm(Owner).Handle, SCM_MEMBER_FILTER_DEACTIVATED, 0, 0);
end;

procedure TFilterByParam.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    FormDeactivate(Self);
end;

procedure TFilterByParam.FormShow(Sender: TObject);
begin
  ReadPreferences;
  SetIconDisplayState;
end;

{ TMemberFilter }

procedure TFilterByParam.ReadPreferences;
var
  iFile: TIniFile;
  iniFileName: string;
begin
  iniFileName := SCMUtils.GetSCMPreferenceFileName;
  if not FileExists(iniFileName) then exit;
  iFile := TIniFile.Create(iniFileName);
  actnHideArchived.Checked := iFile.ReadBool(INIFILE_SECTION,
    'HideArchived', false);
  actnHideInActive.Checked := iFile.ReadBool(INIFILE_SECTION,
    'HideInActive', false);
  actnHideNonSwimmer.Checked := iFile.ReadBool(INIFILE_SECTION,
    'HideNonSwimmer', false);
  iFile.Free;
end;

procedure TFilterByParam.SendFilterDataPacket;
var
  Buffer: TMemoryStream;
  CopyData: TCopyDataStruct;
begin
  // fill record
  fFilterState.HideArchived := actnHideArchived.Checked;
  fFilterState.HideInActive := actnHideInActive.Checked;
  fFilterState.HideNonSwimmer := actnHideNonSwimmer.Checked;
  Buffer := TMemoryStream.Create;
  try
    // fill memory stream
    Buffer.WriteBuffer(fFilterState, SizeOf(TFilterState));
    CopyData.dwData := 0;
    CopyData.cbData := Buffer.Size;
    CopyData.lpData := Buffer.Memory;
    // run filter on form
    SendMessage(TForm(Owner).Handle, SCM_MEMBER_FILTER_CHANGED, 0, LParam(@CopyData));

  finally
    Buffer.free;
  end;
end;

procedure TFilterByParam.SetIconDisplayState;
begin
  // The TAction's state must change else OnActionUpdate isn't called.
  // Programmatically assigning TAction.Checked with a value does not
  // produce a change in it's state.
  // Here we sync the icon states manaually.
  if actnHideArchived.Checked then actnHideArchived.ImageName := 'Checked'
  else actnHideArchived.ImageName := 'UnChecked';
  if actnHideInActive.Checked then actnHideInActive.ImageName := 'Checked'
  else actnHideInActive.ImageName := 'UnChecked';
  if actnHideNonSwimmer.Checked then actnHideNonSwimmer.ImageName := 'Checked'
  else actnHideNonSwimmer.ImageName := 'UnChecked';
  if actnHideArchived.Checked or actnHideInActive.Checked or actnHideNonSwimmer.Checked
  then actnClear.ImageName := 'filter_alt'
  else actnClear.ImageName := 'filter_alt_off';
end;

procedure TFilterByParam.WritePreferences;
var
  iFile: TIniFile;
  iniFileName: string;
begin
  iniFileName := SCMUtils.GetSCMPreferenceFileName;
  if not FileExists(iniFileName) then exit;
  iFile := TIniFile.Create(iniFileName);
  iFile.WriteBool(INIFILE_SECTION, 'HideArchived', actnHideArchived.Checked);
  iFile.WriteBool(INIFILE_SECTION, 'HideInActive', actnHideInActive.Checked);
  iFile.WriteBool(INIFILE_SECTION, 'HideNonSwimmer',
    actnHideNonSwimmer.Checked);
  iFile.Free;
end;

end.
