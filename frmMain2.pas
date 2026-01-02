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

  dmSCM2, dmIMG, dmCore,  uSettings, uDefines, uSwimClub, uUtility,

  { TMS }
  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  { FRAMES }
  frFrameSession,
  frFrameEvent,
  frFrameNominate,
  frFrameFilterMember,
  frFrameNavEv,
  frFrameNavEvItem,
  frFrameHeat,
  frFrameLane;

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
    pnlFilterMember: TPanel;
    pnlNominate: TPanel;
    frFilterMember: TFrameFilterMember;
    Member_Stats: TAction;
    Member_CheckData: TAction;
    SwimClub_Reports: TAction;
    frNominate: TFrameNominate;
    pnlHeader: TPanel;
    pnlBody: TPanel;
    pnlHeat: TPanel;
    frHeat: TFrameHeat;
    frSession: TFrameSession;
    pnlLane: TPanel;
    frLane: TFrameLane;
    frNavEv: TFrameNavEv;
    procedure File_ConnectionExecute(Sender: TObject);
    procedure File_ConnectionUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure frEventactnEv_GridViewExecute(Sender: TObject);
    procedure GenericActionUpdate(Sender: TObject);
    procedure Members_ManageExecute(Sender: TObject);
    procedure Members_ManageUpdate(Sender: TObject);
    procedure Member_StatsExecute(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure pnlTitleBarCustomButtons0Click(Sender: TObject);
    procedure pnlTitleBarCustomButtons0Paint(Sender: TObject);
    procedure pnlTitleBarCustomButtons1Click(Sender: TObject);
    procedure pnlTitleBarCustomButtons1Paint(Sender: TObject);
    procedure pnlTitleBarPaint(Sender: TObject; Canvas: TCanvas; var ARect: TRect);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const
        Rect: TRect);
    procedure SwimClub_ManageExecute(Sender: TObject);
    procedure SwimClub_ReportsExecute(Sender: TObject);
    procedure SwimClub_SwitchExecute(Sender: TObject);
    procedure Tools_PreferencesExecute(Sender: TObject);
  private

    fscmIsConnecting: boolean;
    fCueToMemberID: integer;

//    procedure DetailTBLs_ApplyMaster;

    procedure DetailTBLs_DisableCNTRLs;
    procedure DetailTBLs_EnableCNTRLs;

//    procedure HandleNavEvItemSelected(Sender: TObject; EventID: Integer;
//      NavEvItem: TFrameNavEvItem);

    procedure UpdateFrameVisibility();

  protected
    // Note: don't name procedure same as winapi.message name.
    // SCROLL MESSAGES LISTED HERE PERFORM UI changes - not DB stuff.
    procedure Msg_SCM_Connect(var Msg: TMessage); message SCM_Connect;
    procedure Msg_SCM_Scroll_Session(var Msg: TMessage); message SCM_SCROLL_SESSION;
    procedure Msg_SCM_Scroll_Event(var Msg: TMessage); message SCM_SCROLL_EVENT;
    procedure Msg_SCM_Scroll_Heat(var Msg: TMessage); message SCM_SCROLL_HEAT;
    procedure Msg_SCM_Scroll_FilterMember(var Msg: TMessage);
      message SCM_SCROLL_NOMINATE_FILTERMEMBER;
  end;

var
  Main2: TMain2;

implementation

{$R *.dfm}

uses
  dlgSwimClub_Switch, dlgSwimClub_Manage, dlgLogin, uSession, dlgPreferences,
  frmManageMember, dlgSwimClub_Reports, frmMM_Stats, uEvent;

{
  // Add handler:
procedure TMain2.HandleNavEvItemSelected(Sender: TObject; EventID: Integer;
    NavEvItem: TFrameNavEvItem);
    begin
      if (CORE.qryEvent.State in [dsOpening]) then exit;
      if (EventID = 0) then exit;
      if (uEvent.PK() <> EventID) then
            uEvent.Locate(EventID); // generates a DB scroll event.
    end;
}



{
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
}

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
  fscmIsConnecting := true;
  frNominate.grid.BeginUpdate;
  frFilterMember.grid.BeginUpdate;
   {frLane.grid.BeginUpdate;}
  frHeat.grid.BeginUpdate;
  frEvent.grid.BeginUpdate;
  frSession.grid.BeginUpdate;
  try
    dlg := TLogin.Create(Self); // dlg to connect to the SCM2 DB.
    dlg.ShowModal;
    dlg.Free;

    // is the state is different and a connection was made?
    if (cState <> SCM2.scmConnection.Connected) and SCM2.scmConnection.Connected
      then
    begin
      if Assigned(Settings) and (Settings.LastSwimClubPK <> 0) then
        uSwimClub.Locate(Settings.LastSwimClubPK); // restore swim club.
      // gird pagemode - amoung other things
      frSession.Initialise;
      frEvent.Initialise;
      frFilterMember.Initialise;
      frNominate.Initialise;
      {
        frNavEvent.Initialise;
        frHeat.Initialise;
        frLane.Initialise;
      }
    end;

    // connection state changed?
    if (cState <> SCM2.scmConnection.Connected) then
    begin
      // move to tabsheet 1 and intialise UI.
      if PageControl.ActivePageIndex <> 0 then
        PageControl.ActivePageIndex := 0;
      if frEvent.actnEv_GridView.Checked then
        frEvent.actnEv_GridView.Checked := false; // Collapsed grid view.
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
    frHeat.grid.EndUpdate;
    {frLane.grid.EndUpdate;}
    frFilterMember.grid.EndUpdate;
    frNominate.grid.EndUpdate;
    UpdateFrameVisibility;
    fscmIsConnecting := false;
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

  // Database modules IMG, SCM2 and CORE have been set to AutoCreate
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
  StatusBar.Panels[3].Text := ''; // week of...
  StatusBar.Panels[4].Text := ''; // week of...

  Application.ShowHint := true;

  // Assign a handle to the CORE data module - for windows messages
  CORE.MSG_Handle := Self.Handle;

  frSession.Initialise;
  frEvent.Initialise;
  frFilterMember.Initialise;
  frNominate.Initialise;
//  frNavEv.FOnNavEvItemSelected := Self.HandleNavEvItemSelected;

  // No connection established ...initialize UI state...
  PageControl.ActivePageIndex := 0; // tabsheet 0
  frEvent.actnEv_GridView.Checked := false; // default: collapsed gridview.
  UpdateFrameVisibility(); // hide all panels displaying frames.

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
  end
  else
    UpdateFrameVisibility;
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

procedure TMain2.Members_ManageExecute(Sender: TObject);
var
  dlg: TManageMember;
begin
  if Assigned(SCM2) and SCM2.scmConnection.Connected then // Assert state
  begin
    dlg := TManageMember.Create(self);
    try
      if (fCueToMemberID > 0) then
        dlg.Locate_MemberID(fCueToMemberID);
      dlg.ShowModal();
    finally
      dlg.Free;
    end;
    {
      requery on dmSCM2 members
     count the number of members in DB prior to PostMessage
     Assert the 'No Members' Caption in TLabel lblNomWarning
     refresh all controls and labels on active tabsheet
     via page control - it also actions SCM_TABSHEETDISPLAYSTATE
    }
//    Refresh_Nominate;
//    fCountOfMembers := SCM2.Members_Count;
//    PageControl1Change(PageControl1);
  end;
end;

procedure TMain2.Members_ManageUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
    DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TMain2.Member_StatsExecute(Sender: TObject);
var
  dlg: TManageMember_Stats;
  AMemberID: integer;
begin
  if not Assigned(CORE) or (CORE.IsActive = false) then exit;

  dlg := TManageMember_Stats.Create(Self);
  case PageControl.ActivePageIndex of
    0:
      dlg.Prepare(0); // forces prompt for member's ID
    1:
    begin
        AMemberID := CORE.dsFilterMember.DataSet.FieldByName('MemberID').AsInteger;
        dlg.Prepare(AMemberID);
    end;
    2:
    begin
      {TODO -oBSA -cGeneral : use member's ID from current selected lane}
    end
    else dlg.Prepare(0);
  end;
  dlg.ShowModal;
  dlg.Free;
end;

procedure TMain2.Msg_SCM_Connect(var Msg: TMessage);
begin
  // already connected.. NOTE: Use TMessage SCM_DISCONNECT to disconnect.
  if Assigned(SCM2) and not SCM2.scmConnection.Connected then
  begin
    //  actnManager.ExecuteAction(File_Connection); // doesn't work
    File_Connection.Execute;
    exit;
  end;

  UpdateFrameVisibility;

end;

procedure TMain2.Msg_SCM_Scroll_Event(var Msg: TMessage);
var
  PK: integer;
begin
  // pass message forward to event frame...
  // Msg.WParam contains Event.EventID - used by frNavEv.
  if fscmIsConnecting then exit;
  PK := uEvent.PK;
  SendMessage(frEvent.Handle, SCM_SCROLL_EVENT, WPARAM(PK), Msg.LParam);
  PostMessage(frHeat.Handle, SCM_SCROLL_EVENT, WPARAM(PK), Msg.LParam);
  PostMessage(frNavEv.Handle, SCM_SCROLL_EVENT, WPARAM(PK), Msg.LParam);
end;

procedure TMain2.Msg_SCM_Scroll_FilterMember(var Msg: TMessage);
begin
  // forward message to nominate frame.
  if fscmIsConnecting then exit;
  SendMessage(frNominate.Handle, SCM_SCROLL_NOMINATE_FILTERMEMBER, Msg.WParam, Msg.LParam);
end;

procedure TMain2.Msg_SCM_Scroll_Heat(var Msg: TMessage);
begin
  // pass message forward to Heat frame...
  if fscmIsConnecting then exit;
  SendMessage(frHeat.Handle, SCM_SCROLL_HEAT, Msg.WParam, Msg.LParam);
end;

procedure TMain2.Msg_SCM_Scroll_Session(var Msg: TMessage);
var
  i: integer;
begin
  if fscmIsConnecting then exit;
  // update the list of events in nominate frame...
  //  SendMessage(frNominate.Handle, SCM_SCROLL_SESSION, Msg.WParam, Msg.LParam);
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
    i := uSession.WeeksSinceSeasonStart;
    if (i < 28) and (i > 0) then
      StatusBar.Panels[3].Text := IntToStr(i)
    else
      StatusBar.Panels[3].Text := '';
  except on E: Exception do
    begin
      StatusBar.Panels[1].Text := 'ERR';
      StatusBar.Panels[2].Text := 'ERR';
      StatusBar.Panels[3].Text := 'ERR';
    end;
  end;
    // pass message forward to session frame... UI changes
    PostMessage(frSession.Handle, SCM_SCROLL_SESSION, Msg.WParam, Msg.LParam);
    // Manually re-fill the NavEv with NavEvItems...
    // Uses CORE.qryEvent. After iteration, relocates to orginal record.
    PostMessage(frNavEv.Handle, SCM_FRAME_RESET, 0, 0); // UI UPDATE
    // positions to first record.
    // triggers event scroll - which intern triggers NavEv scroll ...
    PostMessage(frEvent.Handle, SCM_SCROLL_SESSION, 0, 0); // UI UPDATE
end;

procedure TMain2.PageControlChange(Sender: TObject);
begin
  case PageControl.ActivePageIndex of
    0:  // Session - Event.
      begin
        ;
      end;
    1: // Nominate Tab-sheet.
      begin
        frNominate.UpdateQryNominate;
        if frFilterMember.edtSearch.CanFocus then
          frFilterMember.edtSearch.SetFocus;
      end;
    2: // Heat.Lane.INDV.RELAY...
      begin
        ;
      end;
  end;
end;

procedure TMain2.pnlTitleBarCustomButtons0Click(Sender: TObject);
begin
  fCueToMemberID := 0;

  if PageControl.ActivePageIndex = 1 then // Nominate...
    fCueToMemberID := frFilterMember.Grid.DataSource.DataSet.FieldByName('MemberID').AsInteger;
  {
  if PageControl.ActivePageIndex = 2 then // Heat/Lane
  begin
    ID := frLane.Grid.DataSource.DataSet.FieldByName('NomineeID').AsInteger;
    fCueToMemberID := uNominate.GetMemberID(NomineeID);
  end;
  }

  Members_Manage.Execute();
  {
  MessageBox(Handle, PChar('Open the Member Management Tool.'),
    PChar('CustomBar OnClick'), MB_ICONINFORMATION or MB_OK);
  }
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
      if not Panel.Text.IsEmpty  then
      begin
        IMG.imglstStatusPanel.Draw(StatusBar.Canvas, Rect.Left, Rect.Top  + 4, 3);
        if connected then
        begin
          StatusBar.Canvas.Font.Color := FontColor;
          StatusBar.Canvas.TextOut(Rect.Left + 30, Rect.Top + 6, Panel.Text );
        end;
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
  PK1, PK2: integer;
begin
  frNominate.grid.BeginUpdate;
  frFilterMember.grid.BeginUpdate;
  frEvent.grid.BeginUpdate;
  frSession.grid.BeginUpdate;
  DetailTBLs_DisableCNTRLs;
  try
    PK1 := CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;
    dlg := TSwimClubManage.Create(Self);
    try
      dlg.ShowModal;
    finally
      dlg.Free;
      PK2 := CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;
    end;

    if (PK1 <> PK2) then // switched to different club..
    begin
      frSession.Initialise;
      frEvent.Initialise;
      frFilterMember.Initialise;
      frNominate.Initialise;
      // initialize UI state tabsheet 0 and Collapsed grid view.
      PageControl.ActivePageIndex := 0;
      frEvent.actnEv_GridView.Checked := false;
      pnlSession.Visible := true;
    end;

  finally
    DetailTBLs_EnableCNTRLs;
    frSession.grid.EndUpdate;
    frEvent.grid.EndUpdate;
    frFilterMember.grid.EndUpdate;
    frNominate.grid.EndUpdate;
  end;
end;

procedure TMain2.SwimClub_ReportsExecute(Sender: TObject);
var
  dlg: TSwimClub_Reports;
begin
  dlg := TSwimClub_Reports.Create(Self);
  dlg.SwimClubID := uSwimClub.PK;
  dlg.ShowModal;
  dlg.Free;
end;

procedure TMain2.SwimClub_SwitchExecute(Sender: TObject);
var
  dlg: TSwimClubSwitch;
  PK1, PK2: integer;
begin
  frNominate.grid.BeginUpdate;
  frFilterMember.grid.BeginUpdate;
  frEvent.grid.BeginUpdate;
  frSession.grid.BeginUpdate;
  try
    PK1 := CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;
    dlg :=  TSwimClubSwitch.Create(Self);
    dlg.ShowModal;
    dlg.Free;
    PK2 := CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;

    if (PK1 <> PK2) then // switched to different club..
    begin
      uSwimClub.SwitchClubs(PK1, PK2);
      frSession.Initialise; // adjusts the grid.PageMode - grid visibility..
      frEvent.Initialise;
      frFilterMember.Initialise;
      frNominate.Initialise;
      frHeat.Initialise;
      // initialize UI state tabsheet 0 and Collapsed grid view.
      PageControl.ActivePageIndex := 0;
      frEvent.actnEv_GridView.Checked := false;
      pnlSession.Visible := true;
    end;

  finally
    frSession.grid.EndUpdate;
    frEvent.grid.EndUpdate;
    frFilterMember.grid.EndUpdate;
    frNominate.grid.EndUpdate;
  end;
end;

procedure TMain2.Tools_PreferencesExecute(Sender: TObject);
var
  dlg: TPreferences;
begin
  dlg := TPreferences.Create(Self);
  dlg.ShowModal;
  dlg.Free;

  // enable/disable FINA codes....
  // show/hide debug info.

end;

procedure TMain2.UpdateFrameVisibility;
begin
  {
    All frames are hidden when there is no database connection.
    STACK ORDER is important when making visible panels.
  }
  pnlSession.Visible := false;
  pnlEvent.Visible := false;
  pnlNominate.Visible := false;
  pnlFilterMember.Visible := false;
  pnlHeat.Visible := False;

  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    if frEvent.actnEv_GridView.Checked then
      pnlSession.Visible := false
    else
      pnlSession.Visible := true;

    pnlEvent.Visible := true;
    pnlFilterMember.Visible := true;
    pnlNominate.Visible := true;
    pnlHeat.Visible := true;
  end;
end;

end.
