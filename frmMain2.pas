unit frmMain2;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  System.UITypes, System.Actions, System.ImageList,

  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls,
  Vcl.TitleBarCtrls,
  Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls,
  Vcl.ActnMenus, Vcl.BaseImageCollection,
  Vcl.ImageCollection,  Vcl.ImgList, Vcl.VirtualImageList,

  dmSCM2, dmIMG, dmCore

  ;

type
  TMain2 = class(TForm)
    pnlTitleBar: TTitleBarPanel;
    DBTextClubName: TDBText;
    DBTextNickName: TDBText;
    actnMenuBar: TActionMainMenuBar;
    CollectionMenuBar: TImageCollection;
    ImageListMenuBar: TVirtualImageList;
    actnManager: TActionManager;
    Help_About: TAction;
    File_ExportSession: TAction;
    File_ExportCarnival: TAction;
    File_ImportCarnival: TAction;
    File_Exit: TAction;
    Session_ToggleVisible: TAction;
    Session_ToggleLock: TAction;
    Session_New: TAction;
    Session_Edit: TAction;
    Session_Delete: TAction;
    Session_Report: TAction;
    Session_Export: TAction;
    Nominate_SortMembers: TAction;
    Nominate_Report: TAction;
    Event_ToggleGridView: TAction;
    Event_MoveUp: TAction;
    Event_MoveDown: TAction;
    Tools_QualifyTimes: TAction;
    Event_NewRecord: TAction;
    Event_Delete: TAction;
    Event_Report: TAction;
    Grid_MoveUp: TAction;
    Grid_MoveDown: TAction;
    Grid_SwapLanes: TAction;
    Grid_EmptyLane: TAction;
    Grid_Strike: TAction;
    Nominate_GotoMemberDetails: TAction;
    Grid_Renumber: TAction;
    Heat_MoveUp: TAction;
    Heat_MoveDown: TAction;
    Heat_ToggleStatus: TAction;
    Heat_NewRecord: TAction;
    SCM_Refresh: TAction;
    Heat_Delete: TAction;
    Heat_AutoBuild: TAction;
    Heat_MarshallReport: TAction;
    Heat_TimeKeeperReport: TAction;
    Tools_Swimmercategory: TAction;
    Heat_PrintSet: TAction;
    Heat_Report: TAction;
    Tools_House: TAction;
    Nominate_MemberDetails: TAction;
    Nominate_ClearEventNominations: TAction;
    Nominate_ClearSessionNominations: TAction;
    Event_BuildFinals: TAction;
    Event_BuildSemiFinals: TAction;
    Event_BuildQuarterFinals: TAction;
    Event_Renumber: TAction;
    Heat_BatchBuildHeats: TAction;
    Heat_BatchMarshallReport: TAction;
    Heat_BatchTimeKeeperReport: TAction;
    Heat_Renumber: TAction;
    Session_Import: TAction;
    Session_Clone: TAction;
    Session_Sort: TAction;
    Tools_Score: TAction;
    Tools_Divisions: TAction;
    Tools_LeaderBoard: TAction;
    Tools_Preferences: TAction;
    Tools_ConnectionManager: TAction;
    SCM_ManageMembers: TAction;
    Help_LocalHelp: TAction;
    Help_OnlineHelp: TAction;
    Help_Website: TAction;
    Tools_DisqualifyCodes: TAction;
    Event_AutoSchedule: TAction;
    SCM_StatusBar: TAction;
    actnClearSlot: TAction;
    actnStrikeSlot: TAction;
    actnAddSlot: TAction;
    actnRemoveSlot: TAction;
    actnMoveUpSlot: TAction;
    actnMoveDownSlot: TAction;
    SwimClub_Switch: TAction;
    SwimClub_Manage: TAction;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main2: TMain2;

implementation

{$R *.dfm}

procedure TMain2.FormCreate(Sender: TObject);
begin
  {
    Sort out the menubar font height - so tiny!

    The font of the MenuItemTextNormal element (or any other) in the style
    designer has no effect, this is because the Vcl Style Engine simply
    ignores the font-size and font-name, and just uses the font color defined in
    the vcl style file.

    S O L U T I O N :

    Define and register a new TActionBarStyleEx descendent and override
    the DrawText methods of the TCustomMenuItem and TCustomMenuButton
    classes, using the values of the Screen.MenuFont to draw the menu
  }

  Screen.MenuFont.Name := 'Segoe UI Semibold';
  Screen.MenuFont.Size := 12;

  // Auto-Created forms
  if not Assigned(IMG) then
  begin
    MessageDlg('Error creating IMG data module!', mtError,  [mbOK], 0);
    Application.Terminate();
  end;
  if not Assigned(SCM2) then
  begin
    MessageDlg('Error creating SCM2 data module!', mtError,  [mbOK], 0);
    Application.Terminate();
  end;
  if not Assigned(CORE) then
  begin
    MessageDlg('Error creating CORE data module!', mtError,  [mbOK], 0);
    Application.Terminate();
  end;


end;

end.
