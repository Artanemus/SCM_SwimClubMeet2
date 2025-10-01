unit frmMain2;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes,
  System.UITypes, System.Actions, System.ImageList,

  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls,
  Vcl.TitleBarCtrls,  Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls,
  Vcl.ActnMenus, Vcl.BaseImageCollection,
  Vcl.ImageCollection,  Vcl.ImgList, Vcl.VirtualImageList,
  Vcl.Grids, Vcl.DBGrids,

  Data.DB,

  FireDAC.Stan.Option,

  dmSCM2, dmIMG, dmCore,  uSettings, uDefines, uSwimClub, AdvUtil, AdvObj,
  BaseGrid, AdvGrid, DBAdvGrid, frFrameSession

  ;

type
  TMain2 = class(TForm)
    pnlTitleBar: TTitleBarPanel;
    DBTextClubName: TDBText;
    DBTextNickName: TDBText;
    actnManager: TActionManager;
    Help_About: TAction;
    File_ExportClub: TAction;
    File_ImportClub: TAction;
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
    Lane_MoveUp: TAction;
    Lane_MoveDown: TAction;
    Lane_SwapLanes: TAction;
    Lane_EmptyLane: TAction;
    Lane_Strike: TAction;
    Nominate_GotoMemberDetails: TAction;
    Lane_Renumber: TAction;
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
    SCM_ManageMembers: TAction;
    Help_LocalHelp: TAction;
    Help_OnlineHelp: TAction;
    Help_Website: TAction;
    Tools_DisqualifyCodes: TAction;
    Event_AutoSchedule: TAction;
    SCM_StatusBar: TAction;
    Team_ClearSlot: TAction;
    Team_StrikeSlot: TAction;
    Team_AddSlot: TAction;
    Team_RemoveSlot: TAction;
    Team_MoveUpSlot: TAction;
    Team_MoveDownSlot: TAction;
    SwimClub_Switch: TAction;
    SwimClub_Manage: TAction;
    actnMainMenuBar: TActionMainMenuBar;
    File_Connection: TAction;
    Tools_FireDAC: TAction;
    Members_Export: TAction;
    Members_Import: TAction;
    Members_Manage: TAction;
    StatusBar: TStatusBar;
    PageControl: TPageControl;
    tabSession: TTabSheet;
    tabNominate: TTabSheet;
    tabHeats: TTabSheet;
    SwimClub_Houses: TAction;
    SwimClub_Stats: TAction;
    pnlSession: TPanel;
    frgSession: TFrameSession;
    procedure File_ConnectionExecute(Sender: TObject);
    procedure File_ConnectionUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pnlTitleBarCustomButtons0Click(Sender: TObject);
    procedure pnlTitleBarCustomButtons0Paint(Sender: TObject);
    procedure pnlTitleBarCustomButtons1Click(Sender: TObject);
    procedure pnlTitleBarCustomButtons1Paint(Sender: TObject);
    procedure pnlTitleBarPaint(Sender: TObject; Canvas: TCanvas; var ARect: TRect);
    procedure GenericActionUpdate(Sender: TObject);
    procedure SwimClub_ManageExecute(Sender: TObject);
    procedure SwimClub_SwitchExecute(Sender: TObject);
  private
    { Private declarations }
    procedure DetailTBLs_DisableCNTRLs;
    procedure DetailTBLs_ApplyMaster;
    procedure DetailTBLs_EnableCNTRLs;

  protected
    // Note: don't name procedure same as winapi.message name.
    procedure Msg_SCM_Connect(var Msg: TMessage); message SCM_Connect;

  public
    { Public declarations }
  end;

var
  Main2: TMain2;

implementation

{$R *.dfm}

uses
  dlgSwimClub_Switch, dlgSwimClub_Manage, dlgLogin;

procedure TMain2.DetailTBLs_ApplyMaster;
begin
  // FireDAC throws exception error if Master is empty?
  if CORE.qrySwimClub.RecordCount <> 0 then
  begin
    CORE.qrySession.ApplyMaster;
    if CORE.qrySession.RecordCount <> 0 then
    begin
      CORE.qryEvent.ApplyMaster;
      if CORE.qryEvent.RecordCount <> 0 then
      begin
        CORE.qryHeat.ApplyMaster;
        if CORE.qryHeat.RecordCount <> 0 then
        begin
          CORE.qryLane.ApplyMaster;
          if CORE.qryLane.RecordCount <> 0 then
          begin
            CORE.qryWatchTime.ApplyMaster;
            CORE.qrySplitTime.ApplyMaster;
            CORE.qryTeam.ApplyMaster;
          end;
        end;
      end;
    end;
  end;
end;

procedure TMain2.DetailTBLs_DisableCNTRLs;
begin
  CORE.qryTeamLink.DisableControls;
  CORE.qryTeam.DisableControls;
  CORE.qrySplitTime.DisableControls;
  CORE.qryWatchTime.DisableControls;
  CORE.qryLane.DisableControls;
  CORE.qryHeat.DisableControls;
  CORE.qryEvent.DisableControls;
  CORE.qrySession.DisableControls;
end;

procedure TMain2.DetailTBLs_EnableCNTRLs;
begin
  CORE.qrySession.EnableControls;
  CORE.qryEvent.EnableControls;
  CORE.qryHeat.EnableControls;
  CORE.qryLane.EnableControls;
  CORE.qryWatchTime.EnableControls;
  CORE.qrySplitTime.EnableControls;
  CORE.qryTeam.EnableControls;
  CORE.qryTeamLink.DisableControls;
end;

procedure TMain2.File_ConnectionExecute(Sender: TObject);
var
  dlg: TLogin;
  cState: boolean;
begin
  // NOTE: strange title bar colouration.

  // store connection state..
  cState := SCM2.scmConnection.Connected;
  // store the current swim club's Primary Key.
  if CORE.IsActive and Assigned(Settings) then
    Settings.LastSwimClubPK := uSwimClub.PK;

  dlg := TLogin.Create(Self); // dlg to connect to the SCM DB.
  {TODO -oBSA -cUI : take grids offline with beginupdate }
  (*
    gSession.BeginUpdate;
    gEvent.BeginUpdate;
    gMember.BeginUpdate;
    gHeat.BeginUpdate;
    gLane.BeginUpdate;
  *)
  dlg.ShowModal;
  dlg.Free;

  // is the state is different and a connection was made?
  if (cState <> SCM2.scmConnection.Connected) and SCM2.scmConnection.Connected
    then
  begin
    if Assigned(Settings) and (Settings.LastSwimClubPK <> 0) then
      {TODO -oBSA -cERROR : Can a locate be performed on an empty table?}
      uSwimClub.Locate(Settings.LastSwimClubPK); // goto the last viewed swim club.
  end;

  // UI changes needed to track connection state.
  if SCM2.scmConnection.Connected then
  begin
    // Update the TitlePanel dbtext captions and enable custom buttons.
    pnlTitleBar.CustomButtons[0].Enabled := true;
    pnlTitleBar.CustomButtons[1].Enabled := true;
    StatusBar.Panels[0].Text := ' CONNECTED';
  end
  else
  begin
    pnlTitleBar.CustomButtons[0].Enabled := false;
    pnlTitleBar.CustomButtons[1].Enabled := false;
    StatusBar.Panels[0].Text := ' NOT CONNECTED';
  end;

  {TODO -oBSA -cUI : take grids online with endupdate }
  (*
    gSession.EndUpdate;
    gEvent.EndUpdate;
    gMember.EndUpdate;
    gHeat.EndUpdate;
    gLane.EndUpdate;
  *)
end;

procedure TMain2.File_ConnectionUpdate(Sender: TObject);
begin
  // a connection can be made any time during the app life
  // but the SCM2 and CORE datamodules MUST be assigned.
  If Assigned(SCM2) and Assigned(CORE) then TAction(Sender).Enabled := true
  else TAction(Sender).Enabled := false;
end;

procedure TMain2.FormCreate(Sender: TObject);
begin
  // Setting font size at design time is ignored.
  Screen.MenuFont.Name := 'Segoe UI Semibold';
  Screen.MenuFont.Size := 12;

  // Database modules IMG, SCM and CORE have been set to AutoCreate
  // prior to form creation. Kills the app if missing!
  if not (Assigned(IMG) and Assigned(SCM2) and Assigned(CORE)) then
  begin
    MessageDlg('Error creating Data module!', mtError,  [mbOK], 0);
    Application.Terminate();
  end;

  { A Class that uses JSON to read and write application configuration.

    The overloaded contructor will auto-load the default preference.json file
    HOMEPATH = C:Users\<username>\AppData\Roaming (WINDOWS)
    DEFSETTINGSSUBPATH = 'Artanemus\SCM2\SwimClubMeet';
    DEFSETTINGSFILENAME = 'scmPref.json';
  }
  Settings := TAppSetting.Create(true);

  // -------------------------------------
  // DEBUG :::: REMOVE.🔻
  // -------------------------------------
  Settings.DoLoginOnBoot := true;
  // -------------------------------------

  // Checks for default state of data and controls.
  SCM2.scmConnection.Connected := false;
  pnlTitleBar.CustomButtons[0].Enabled := false; // title bar Members btn.
  pnlTitleBar.CustomButtons[1].Enabled := false; // title bar Refresh btn.
  Caption := 'SwimClubMeet2'; // with no connection... a basic caption.

  StatusBar.Panels[0].Text := ' OFFLINE'; // connection state
  StatusBar.Panels[1].Text := ''; // nominee count
  StatusBar.Panels[2].Text := ''; // entrant count
  StatusBar.Panels[2].Text := ''; // status messages

  Application.ShowHint := true;

  // for Debug only


end;

procedure TMain2.FormShow(Sender: TObject);
begin
  if Assigned(Settings) and Settings.DoLoginOnBoot then
    PostMessage(Handle, SCM_CONNECT, 0, 0);
end;

procedure TMain2.GenericActionUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and CORE.IsActive then
    DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TMain2.pnlTitleBarCustomButtons0Click(Sender: TObject);
begin
  MessageBox(Handle, PChar('Open the Member Management Tool.'),
    PChar('CustomBar OnClick'), MB_ICONINFORMATION or MB_OK);
end;

procedure TMain2.pnlTitleBarCustomButtons0Paint(Sender: TObject);
begin
  if TSystemTitlebarButton(Sender).Enabled then
    IMG.imglstTitleBar.Draw(TSystemTitlebarButton(Sender).Canvas, 0, 2, 0)
  else
    IMG.imglstTitleBar.Draw(TSystemTitlebarButton(Sender).Canvas, 0, 2, 1);
end;

procedure TMain2.pnlTitleBarCustomButtons1Click(Sender: TObject);
begin
  MessageBox(Handle, PChar('Refresh the database tables.'),
    PChar('CustomBar OnClick'), MB_ICONINFORMATION or MB_OK);
end;

procedure TMain2.pnlTitleBarCustomButtons1Paint(Sender: TObject);
begin
  if TSystemTitlebarButton(Sender).Enabled then
    IMG.imglstTitleBar.Draw(TSystemTitlebarButton(Sender).Canvas, 0, 2, 2)
  else
    IMG.imglstTitleBar.Draw(TSystemTitlebarButton(Sender).Canvas, 0, 2, 3);
end;

procedure TMain2.pnlTitleBarPaint(Sender: TObject; Canvas: TCanvas; var ARect:
  TRect);
begin
  if Assigned(SCM2) and SCM2.scmConnection.Connected and CORE.qrySwimClub.Active
    then
  begin
    CustomTitleBar.ShowCaption := false;
    CustomTitleBar.ShowIcon := false;
    DBTextClubName.Visible := true;
    DBTextNickName.Visible := true;
  end
  else
  begin
    DBTextClubName.Visible := false;
    DBTextNickName.Visible := false;
    CustomTitleBar.ShowCaption := true;
    CustomTitleBar.ShowIcon := true;
  end;
  inherited;
end;

procedure TMain2.Msg_SCM_Connect(var Msg: TMessage);
begin
  // already connected..
  if SCM2.scmConnection.Connected then exit;
  //  actnManager.ExecuteAction(File_Connection); // doesn't work
  File_Connection.Execute;
end;

procedure TMain2.SwimClub_ManageExecute(Sender: TObject);
var
  dlg: TSwimClubManage;
begin
  DetailTBLs_EnableCNTRLs;
  try
    dlg := TSwimClubManage.Create(Self);
    try
      dlg.ShowModal;
    finally
      dlg.Free;
    end;
  finally
    DetailTBLs_DisableCNTRLs;
  end;
end;

procedure TMain2.SwimClub_SwitchExecute(Sender: TObject);
var
  dlg: TSwimClubSwitch;
begin
  dlg :=  TSwimClubSwitch.Create(Self);
  dlg.ShowModal;
  dlg.Free;
end;


end.
