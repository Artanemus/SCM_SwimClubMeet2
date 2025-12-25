unit dlgMM_FilterByParam;

interface

uses
  Winapi.Messages,
  Winapi.Windows,
  System.Actions,
  System.Classes,
  System.ImageList,
  System.SysUtils,
  System.Variants,
  Vcl.ActnList,
  Vcl.ActnMan,
  Vcl.AppEvnts,
  Vcl.BaseImageCollection,
  Vcl.ButtonGroup,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.ImageCollection,
  Vcl.ImgList,
  Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.StdCtrls,
  Vcl.VirtualImageList,
  SVGIconVirtualImageList,

  dmIMG,
  uUtility,
  uDefines,
  uSettings;

type

  TMM_FilterByParam = class(TForm)
    grpF: TButtonGroup;
    imglstFilterParam: TSVGIconVirtualImageList;
    procedure FormDestroy(Sender: TObject);
    procedure actnClearExecute(Sender: TObject);
    procedure actnHideArchivedExecute(Sender: TObject);
    procedure actnHideInActiveExecute(Sender: TObject);
    procedure actnHideNonSwimmerExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    fMouseLeave: Boolean;
    procedure SetIconDisplayState();
  public
    procedure SendFilterStateMsg;

  end;

var
  MM_FilterByParam: TMM_FilterByParam;

implementation

{$R *.dfm}

Uses IniFiles;

procedure TMM_FilterByParam.FormDestroy(Sender: TObject);
begin
  SendFilterStateMsg;
end;

procedure TMM_FilterByParam.actnClearExecute(Sender: TObject);
begin
  if Assigned(Settings) then
  begin
    Settings.mm_HideArchived := false;
    Settings.mm_HideInActive := false;
    Settings.mm_HideNonSwimmer := false;
  end;
  SetIconDisplayState;
  SendFilterStateMsg;
end;

procedure TMM_FilterByParam.actnHideArchivedExecute(Sender: TObject);
begin
  if Assigned(Settings) then
  begin
    Settings.mm_HideArchived := not Settings.mm_HideArchived;
    SetIconDisplayState;
    SendFilterStateMsg;
  end;
end;

procedure TMM_FilterByParam.actnHideInActiveExecute(Sender: TObject);
begin
  if Assigned(Settings) then
  begin
    Settings.mm_HideInActive := not Settings.mm_HideInActive;
    SetIconDisplayState;
    SendFilterStateMsg;
  end;
end;

procedure TMM_FilterByParam.actnHideNonSwimmerExecute(Sender: TObject);
begin
  if Assigned(Settings) then
  begin
    Settings.mm_HideNonSwimmer := not Settings.mm_HideNonSwimmer;
    SetIconDisplayState;
    SendFilterStateMsg;
  end;
end;

procedure TMM_FilterByParam.FormClose(Sender: TObject; var Action:
    TCloseAction);
begin
  // This tells the VCL to free the memory of the form instance
  // immediately after the window closes.
  Action := caFree;
end;

procedure TMM_FilterByParam.FormCreate(Sender: TObject);
begin
  fMouseLeave := false;
  SetIconDisplayState;
end;

procedure TMM_FilterByParam.FormDeactivate(Sender: TObject);
begin
  // As soon as focus leaves this window (user clicks outside), close it.
  // This will trigger the OnClose event, which triggers caFree.
  Close();
end;

procedure TMM_FilterByParam.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TMM_FilterByParam.SendFilterStateMsg;
begin
  SendMessage(TForm(Owner).Handle, SCM_MEMBER_FILTER_CHANGED, 0, 0);
end;

procedure TMM_FilterByParam.SetIconDisplayState;
begin
  if Assigned(Settings) then
  begin
    // checkbox-blank = 0 .. checkbox (ticked) = 1
    grpf.items[0].ImageIndex := ORD(Settings.mm_HideArchived);
    grpf.items[1].ImageIndex := ORD(Settings.mm_HideInActive);
    grpf.items[2].ImageIndex := ORD(Settings.mm_HideNonSwimmer);

    if not Settings.mm_HideArchived and not Settings.mm_HideInActive and not
      Settings.mm_HideNonSwimmer then
      grpf.items[3].ImageName := 'filter_off'
    else
      grpf.items[3].ImageName := 'filter';
  end
  else
  begin
    grpf.items[0].ImageIndex := 0;
    grpf.items[1].ImageIndex := 0;
    grpf.items[2].ImageIndex := 0;
    grpf.items[3].ImageName := 'filter_off';
  end;

end;



end.
