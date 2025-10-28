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
  Vcl.Grids, Vcl.DBGrids, Vcl.Themes,

  Data.DB,

  FireDAC.Stan.Option,

  dmSCM2, dmIMG, dmCore,  uSettings, uDefines, uSwimClub, AdvUtil, AdvObj,
  BaseGrid, AdvGrid, DBAdvGrid, frFrameSession, frFrameEvent,
  frFrameNominate, frFrameFilterMember

  ;

type
  TMain2 = class(TForm)
    actnMainMenuBar: TActionMainMenuBar;
    actnManager: TActionManager;
    DBTextClubName: TDBText;
    DBTextNickName: TDBText;
    File_Connection: TAction;
    File_Exit: TAction;
    File_ExportClub: TAction;
    File_ImportClub: TAction;
    frSession: TFrameSession;
    Heat_AutoBuild: TAction;
    Heat_BatchBuildHeats: TAction;
    Heat_BatchMarshallReport: TAction;
    Heat_BatchTimeKeeperReport: TAction;
    Heat_Delete: TAction;
    Heat_MarshallReport: TAction;
    Heat_MoveDown: TAction;
    Heat_MoveUp: TAction;
    Heat_NewRecord: TAction;
    Heat_PrintSet: TAction;
    Heat_Renumber: TAction;
    Heat_Report: TAction;
    Heat_TimeKeeperReport: TAction;
    Heat_ToggleStatus: TAction;
    Help_About: TAction;
    Help_LocalHelp: TAction;
    Help_OnlineHelp: TAction;
    Help_Website: TAction;
    Lane_EmptyLane: TAction;
    Lane_MoveDown: TAction;
    Lane_MoveUp: TAction;
    Lane_Renumber: TAction;
    Lane_Strike: TAction;
    Lane_SwapLanes: TAction;
    Members_Export: TAction;
    Members_Import: TAction;
    Members_Manage: TAction;
    PageControl: TPageControl;
    pnlSession: TPanel;
    pnlTitleBar: TTitleBarPanel;
    SCM_ManageMembers: TAction;
    SCM_Refresh: TAction;
    SCM_StatusBar: TAction;
    StatusBar: TStatusBar;
    SwimClub_Houses: TAction;
    SwimClub_Manage: TAction;
    SwimClub_Stats: TAction;
    SwimClub_Switch: TAction;
    tabHeats: TTabSheet;
    tabNominate: TTabSheet;
    tabSession: TTabSheet;
    Team_AddSlot: TAction;
    Team_ClearSlot: TAction;
    Team_MoveDownSlot: TAction;
    Team_MoveUpSlot: TAction;
    Team_RemoveSlot: TAction;
    Team_StrikeSlot: TAction;
    Tools_DisqualifyCodes: TAction;
    Tools_Divisions: TAction;
    Tools_FireDAC: TAction;
    Tools_LeaderBoard: TAction;
    Tools_Preferences: TAction;
    Tools_QualifyTimes: TAction;
    Tools_Score: TAction;
    Tools_Swimmercategory: TAction;
    pnlEvent: TPanel;
    frEvent: TFrameEvent;
    pnlMem: TPanel;
    pnlNominate: TPanel;
    frNominate: TFrameNominate;
    frFilterMember: TFrameFilterMember;
    procedure File_ConnectionExecute(Sender: TObject);
    procedure File_ConnectionUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure frEventactnEv_GridViewExecute(Sender: TObject);
    procedure GenericActionUpdate(Sender: TObject);
    procedure pnlTitleBarCustomButtons0Click(Sender: TObject);
    procedure pnlTitleBarCustomButtons0Paint(Sender: TObject);
    procedure pnlTitleBarCustomButtons1Click(Sender: TObject);
    procedure pnlTitleBarCustomButtons1Paint(Sender: TObject);
    procedure pnlTitleBarPaint(Sender: TObject; Canvas: TCanvas; var ARect: TRect);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const
        Rect: TRect);
    procedure SwimClub_ManageExecute(Sender: TObject);
    procedure SwimClub_SwitchExecute(Sender: TObject);
  private
    procedure DetailTBLs_ApplyMaster;
    procedure DetailTBLs_DisableCNTRLs;
    procedure DetailTBLs_EnableCNTRLs;
  protected
    // Note: don't name procedure same as winapi.message name.
    procedure Msg_SCM_Connect(var Msg: TMessage); message SCM_Connect;
    procedure Msg_SCM_Scroll_Session(var Msg: TMessage); message SCM_SCROLL_SESSION;
    procedure Msg_SCM_Scroll_Event(var Msg: TMessage); message SCM_SCROLL_EVENT;
    procedure Msg_SCM_Scroll_FilterMember(var Msg: TMessage);
      message SCM_SCROLL_FILTERMEMBER;

  end;

var
  Main2: TMain2;

implementation

{$R *.dfm}

uses
  dlgSwimClub_Switch, dlgSwimClub_Manage, dlgLogin, uSession;

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


  frFilterMember.grid.BeginUpdate;
  frEvent.grid.BeginUpdate;
  frSession.grid.BeginUpdate;
  try
    dlg := TLogin.Create(Self); // dlg to connect to the SCM DB.
    dlg.ShowModal;
    dlg.Free;

    // is the state is different and a connection was made?
    if (cState <> SCM2.scmConnection.Connected) and SCM2.scmConnection.Connected
      then
    begin
      if Assigned(Settings) and (Settings.LastSwimClubPK <> 0) then
        uSwimClub.Locate(Settings.LastSwimClubPK); // restore swim club.
      // sets table indexname, icon imageindexes and gird pagemode
      frSession.Initialise;
      frEvent.Initialise;
      frFilterMember.Initialise;
    end;

    // connection state changed?
    if (cState <> SCM2.scmConnection.Connected) then
    begin
      // move to tabsheet 1 and intialise UI.
      if PageControl.ActivePageIndex <> 0 then
        PageControl.ActivePageIndex := 0;
      if frEvent.actnEv_GridView.Checked then
        frEvent.actnEv_GridView.Checked := false; // Collapsed grid view.
      pnlSession.Visible := true;
    end;

    // UI changes needed to track connection state.
    if SCM2.scmConnection.Connected then
    begin
      // Update the TitlePanel dbtext captions and enable custom buttons.
      pnlTitleBar.CustomButtons[0].Enabled := true;
      pnlTitleBar.CustomButtons[1].Enabled := true;
      StatusBar.Panels[0].Text := 'CONNECTED'; // psOwnerDraw
    end
    else
    begin
      pnlTitleBar.CustomButtons[0].Enabled := false;
      pnlTitleBar.CustomButtons[1].Enabled := false;
      StatusBar.Panels[0].Text := 'NOT CONNECTED'; // psOwnerDraw
    end;
  finally
    frSession.grid.EndUpdate;
    frEvent.grid.EndUpdate;
    frFilterMember.grid.EndUpdate;
  end;


end;

procedure TMain2.File_ConnectionUpdate(Sender: TObject);
begin
  // a connection can be made any time during the app life
  // but the SCM2 and CORE datamodules MUST be assigned.
  If Assigned(SCM2) and Assigned(CORE) then TAction(Sender).Enabled := true
  else TAction(Sender).Enabled := false;
end;

procedure TMain2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // ASSERT: close connection on database
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
    SCM2.scmConnection.Close;
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

  StatusBar.Panels[0].Text := 'NOT CONNECTED'; // connection state
  StatusBar.Panels[1].Text := ''; // nominee count
  StatusBar.Panels[2].Text := ''; // entrant count
  StatusBar.Panels[2].Text := ''; // status messages

  Application.ShowHint := true;

  // Assign a handle to the CORE data module - for windows messages
  CORE.MSG_Handle := Self.Handle;

  frSession.Initialise;
  frEvent.Initialise;
  frFilterMember.Initialise;

end;

procedure TMain2.FormDestroy(Sender: TObject);
begin
  if Assigned(Settings) then
  begin
    if SCM2.scmConnection.Connected then
      Settings.LastSwimClubPK := uSwimClub.PK;
    Settings.Free;
  end;
end;

procedure TMain2.FormShow(Sender: TObject);
begin

  if Assigned(Settings) and Settings.DoLoginOnBoot then
  begin
    // fix UI repaint issues with the TMS grids (held within frames).
    // Use a thread to delay the connection dialog
    TThread.CreateAnonymousThread(
      procedure
      begin
        Sleep(250); // Wait 250ms for the form and grids to paint
        TThread.Synchronize(nil,
          procedure
          begin
            PostMessage(Handle, SCM_CONNECT, 0, 0);
          end
        );
      end
    ).Start;
  end;

end;

procedure TMain2.frEventactnEv_GridViewExecute(Sender: TObject);
begin
  frEvent.actnEv_GridViewExecute(Sender); // toggle grid view.
  if frEvent.actnEv_GridView.Checked  then // EXPAND.
    pnlSession.Visible := false
  else  // COLLAPSE.
    pnlSession.Visible := true;
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

procedure TMain2.Msg_SCM_Connect(var Msg: TMessage);
begin
  // already connected.. NOTE: Use TMessage SCM_DISCONNECT to disconnect.
  if SCM2.scmConnection.Connected then exit;
  //  actnManager.ExecuteAction(File_Connection); // doesn't work
  File_Connection.Execute;
end;

procedure TMain2.Msg_SCM_Scroll_Event(var Msg: TMessage);
begin
  // pass message forward to event frame...
  SendMessage(frEvent.Handle, SCM_SCROLL_EVENT, Msg.WParam, Msg.LParam);
end;

procedure TMain2.Msg_SCM_Scroll_FilterMember(var Msg: TMessage);
begin
  // forward message to nominate frame.
  SendMessage(frNominate.Handle, SCM_SCROLL_FILTERMEMBER, Msg.WParam, Msg.LParam);
end;

procedure TMain2.Msg_SCM_Scroll_Session(var Msg: TMessage);
begin
  // pass message forward to session frame...
  SendMessage(frSession.Handle, SCM_SCROLL_SESSION, Msg.WParam, Msg.LParam);
  try // update the status bar with nominee and entrant counts.
    if (uSession.IsLocked) then
    begin // Fast.. gets the pre-calculated params from table.
      StatusBar.Panels[1].Text := IntToStr(uSession.GetSess_NomineeCount);
      StatusBar.Panels[2].Text := IntToStr(uSession.GetSess_EntrantCount);
    end
    else
    begin // Calls ExecSQLScalar .. a little slower, real-time.
      StatusBar.Panels[1].Text := IntToStr(uSession.CalcSess_NomineeCount);
      StatusBar.Panels[2].Text := IntToStr(uSession.CalcSess_EntrantCount);
    end;
    StatusBar.Panels[3].Text := IntToStr(uSession.WeeksSinceSeasonStart);
  except on E: Exception do
    begin
      StatusBar.Panels[1].Text := 'ERR';
      StatusBar.Panels[2].Text := 'ERR';
      StatusBar.Panels[3].Text := 'ERR';
    end;
  end;

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

procedure TMain2.StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
    const Rect: TRect);
var
  FontColor: TColor;
  connected: boolean;
begin
  FontColor := StyleServices.GetStyleFontColor(sfStatusPanelTextNormal);
  connected := SCM2.scmConnection.Connected;
  case Panel.Index of
    0: // CONNECTED/NOT CONNECTED
    begin
      if not connected then
        StatusBar.Canvas.Font.Color := clWebTomato
      else
        StatusBar.Canvas.Font.Color := FontColor;
      StatusBar.Canvas.TextOut(Rect.Left + 4, Rect.Top + 6, Panel.Text );
    end;
    1: // NOMINEE COUNT.
    begin
      IMG.imglstStatusPanel.Draw(StatusBar.Canvas, Rect.Left, Rect.Top  + 4, 0);
      if connected then
      begin
        StatusBar.Canvas.Font.Color := FontColor;
        StatusBar.Canvas.TextOut(Rect.Left + 30, Rect.Top + 6, Panel.Text );
      end;
    end;
    2: // ENTRANT COUNT.
    begin
      IMG.imglstStatusPanel.Draw(StatusBar.Canvas, Rect.Left, Rect.Top  + 4, 1);
      if connected then
      begin
        StatusBar.Canvas.Font.Color := FontColor;
        StatusBar.Canvas.TextOut(Rect.Left + 30, Rect.Top + 6, Panel.Text );
      end;
    end;
    3: // SWIMMING SEASON WEEK COUNT.
    begin
      IMG.imglstStatusPanel.Draw(StatusBar.Canvas, Rect.Left, Rect.Top  + 4, 3);
      if connected then
      begin
        StatusBar.Canvas.Font.Color := FontColor;
        StatusBar.Canvas.TextOut(Rect.Left + 30, Rect.Top + 6, Panel.Text );
      end;
    end;
    4: // SYSTEM MESSAGE
    begin

    end;
  end;
end;

procedure TMain2.SwimClub_ManageExecute(Sender: TObject);
var
  dlg: TSwimClubManage;
begin
  DetailTBLs_DisableCNTRLs;
  try
    dlg := TSwimClubManage.Create(Self);
    try
      dlg.ShowModal;
    finally
      dlg.Free;
    end;
  finally
    DetailTBLs_EnableCNTRLs;
  end;
end;

procedure TMain2.SwimClub_SwitchExecute(Sender: TObject);
var
  dlg: TSwimClubSwitch;
begin
  frSession.grid.BeginUpdate;
  try
  dlg :=  TSwimClubSwitch.Create(Self);
  dlg.ShowModal;
  dlg.Free;
  frSession.Initialise;
  finally
    frSession.grid.EndUpdate;
  end;
end;

end.
