unit frFrameSession;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes,  System.Actions,
  System.DateUtils, System.UITypes,

  Data.DB, BaseGrid,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,Vcl.ActnList,
  Vcl.ExtCtrls, Vcl.WinXPanels, Vcl.Buttons, Vcl.Grids,

  AdvUtil, AdvObj, AdvGrid, DBAdvGrid,

  dmSCM2, dmIMG, dmCORE, uSettings, uSession, uDefines;

type
  TFrameSession = class(TFrame)
    actnlstSession: TActionList;
    actnSessFr_Visible: TAction;
    spbtnSessVisible: TSpeedButton;
    spbtnSessLock: TSpeedButton;
    ShapeSessBar1: TShape;
    spbtnSessNew: TSpeedButton;
    spbtnSessClone: TSpeedButton;
    spbtnSessDelete: TSpeedButton;
    ShapeSessBar2: TShape;
    spbtnSessReport: TSpeedButton;
    pnlBody: TPanel;
    gSession: TDBAdvGrid;
    actnSessFr_Lock: TAction;
    actnSessFr_Edit: TAction;
    actnSessFr_New: TAction;
    actnSessFr_Clone: TAction;
    actnSessFr_Delete: TAction;
    actnSessFr_Report: TAction;
    pnlCntrl: TPanel;
    spbtnEdit: TSpeedButton;
    procedure actnSessFr_DeleteExecute(Sender: TObject);
    procedure actnSessFr_EditExecute(Sender: TObject);
    procedure actnSessFr_VisibleExecute(Sender: TObject);
    procedure actnSessFr_DefaultUpdate(Sender: TObject);
    procedure actnSessFr_CheckLockUpdate(Sender: TObject);
    procedure actnSessFr_LockExecute(Sender: TObject);
    procedure actnSessFr_NewExecute(Sender: TObject);
    procedure actnSessFr_NewUpdate(Sender: TObject);
    procedure gSessionGetCellColor(Sender: TObject; ARow, ACol: Integer; AState:
        TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure gSessionGetHTMLTemplate(Sender: TObject; ACol, ARow: Integer; var
        HTMLTemplate: string; Fields: TFields);
  private
    { Private declarations }
    procedure SetVisibilityIcons();
    procedure SetLockIcons();

  protected

  public
    procedure Initialise();
    // will message seen by main tunnle through to frame?  CHECK...
    procedure Msg_SCM_Scroll_Session(var Msg: TMessage); message SCM_SCROLL_SESSION;

  end;

implementation

uses
  dlgEditSession;

{$R *.dfm}

procedure TFrameSession.actnSessFr_DeleteExecute(Sender: TObject);
var
  rtnValue: integer;
begin
  if uSession.IsLocked then
  begin
    MessageDlg('A locked session can''t be deleted.', mtInformation,
      [mbOK], 0, mbOK);
    exit;
  end;
  { WARNING #1 }
  rtnValue := MessageDlg('Delete the selected session?' + sLineBreak +
    'Including it''s events, nominees, heats, entrants, relays, etc.',
    mtConfirmation, [mbYes, mbNo], 0, mbNo);
  // DON'T USE (rtnValue = mrNo) AS IT DOESN'T ACCOUNT FOR OS CLOSE 'X' BTN.
  // mrCancel=2 mrNo=7 mrYes=6
  if (rtnValue <> mrYes) then exit;
  { WARNING #2 }
  if uSession.HasClosedOrRacedHeats() then
  begin
    rtnValue := MessageDlg('The session contains CLOSED and/or RACED heats.' +
      sLineBreak +
      'Racetimes and entrant data will be lost if you delete this session.' +
      sLineBreak + 'Do you wish to delete the session?', mtWarning,
      [mbYes, mbNo], 0, mbNo);
    // DON'T USE (results = mrNo) AS IT DOESN'T ACCOUNT FOR OS CLOSE 'X' BTN.
    // mrCancel=2 mrNo=7 mrYes=6
    if (rtnValue <> mrYes) then exit;
  end;
  gSession.BeginUpdate;
  try
    { D E L E T E  S E S S I O N   D O   N O T   E X C L U D E ! }
    { uSession handles enable/disable and re-sync of Master-Detail}
    uSession.Delete_Session(false);
  finally
    gSession.EndUpdate;
  end;
end;

procedure TFrameSession.actnSessFr_EditExecute(Sender: TObject);
var
dlg: TEditSession;
begin
  dlg := TEditSession.Create(Self);
  dlg.ShowModal;
  dlg.Free;
end;

procedure TFrameSession.actnSessFr_VisibleExecute(Sender: TObject);
begin
    gSession.BeginUpdate;
    TAction(Sender).Checked := not TAction(Sender).Checked;
    try
      SetVisibilityIcons;
      // Assign index ... ApplyMaster.
      // true - indxShowAll , false indxHideLocked.
      uSession.SetVisibilityOfLocked(not TAction(Sender).Checked);
    finally
      gSession.EndUpdate;
    end;
end;

procedure TFrameSession.actnSessFr_DefaultUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(CORE) and CORE.IsActive and
    not CORE.qrySession.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSession.actnSessFr_CheckLockUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(CORE) and CORE.IsActive and not CORE.qrySession.IsEmpty then
  begin
    if CORE.qrySession.FieldByName('SessionStatusID').AsInteger <> 2 then
      DoEnable := true;
  end;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSession.actnSessFr_LockExecute(Sender: TObject);
begin
  gSession.BeginUpdate;
  try
    TAction(Sender).Checked := not TAction(Sender).Checked;
    if TAction(Sender).Checked then
    begin
      uSession.SetSessionStatusID(2); // CLOSED ie.LOCKED.
      SetLockIcons;
    end
    else
    begin
      uSession.SetSessionStatusID(1); // OPEN ie.UN-LOCKED.
      SetLockIcons;
    end;
  finally
    gSession.endUpdate;
  end;
end;

procedure TFrameSession.actnSessFr_NewExecute(Sender: TObject);
begin
  // open the session DLG editing INSERT MODE.
end;

procedure TFrameSession.actnSessFr_NewUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(CORE) and CORE.IsActive then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSession.gSessionGetCellColor(Sender: TObject; ARow, ACol:
    Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  //gSession.FontColors[Acol, ARow]; // clWhite;  //

  if (ARow >= gSession.FixedRows) then   // (ARow >= gSession.FixedCols)
  begin
//    if (gdFocused in AState) then
//      AFont.Color := clWebGoldenRod
//    else
//    begin

      if (gSession.Cells[2, ARow] = '2') then
          AFont.Color := gSession.DisabledFontColor
      else AFont.Color :=  $00FFE4D8;

//    end;
  end;
end;

procedure TFrameSession.gSessionGetHTMLTemplate(Sender: TObject; ACol, ARow:
    Integer; var HTMLTemplate: string; Fields: TFields);
var
  s, s2: string;
  DT1, DT2: TDateTime;
  ShowSeasonIcon, Locked: boolean;
begin
  if (not Assigned(CORE)) or (not CORE.IsActive) or
    CORE.qrySession.IsEmpty then exit;

  ShowSeasonIcon := false;
  if CORE.qrySession.FieldByName('SessionStatusID').AsInteger = 2 then
    Locked := true else Locked := false;
  DT1 := CORE.qrySession.FieldByName('SessionDT').AsDateTime;
  DT2 := CORE.qrySwimClub.FieldByName('StartOfSwimSeason').AsDateTime;
  if WithinPastMonths(Dt1,DT2,6) then ShowSeasonIcon := true;

  if (ACol = 1) then     // and (ARow >= gSession.FixedRows)
  begin
    if not Locked then
    begin
      // Session date and time. Caption. Status buttons. 2xlines
      s := '''
        <IND x="2"><FONT Size="12"><B><#SessionDT></B></FONT><br>
        <IND x="4"><FONT Size="12"><IMG src="idx:7" align="middle">
        ''';
      if ShowSeasonIcon then
        s := s + '<IND x="24"><IMG src="idx:13" align="middle">';
      s := s + '  <#Caption></FONT>';
    end
    else // The session is locked - 3xlines at reduced font size.
    begin
      s := '''
        <IND x="2"><FONT Size="10"><#SessionDT><br>
        <IND x="4">'<#Caption><br>
        <IND x="4"><IMG src="idx:6" align="middle">
        ''';
      if ShowSeasonIcon then
        s := s + '<IND x="24"><IMG src="idx:13" align="middle">';
      // extended info shown only on locked sessions
      s2 := '''
        <IND x="44"><IMG src="idx:14" align="middle"> <#NomineeCount>
        <IND x="104"><IMG src="idx:15" align="middle"> <#EntrantCount></FONT>
        ''';
      s := s + s2;
    end;
    HTMLTemplate := s;
  end;


end;

procedure TFrameSession.Initialise;
var
  HideLockedSessions: boolean;
begin
  HideLockedSessions := false;
  if Assigned(Settings) then
    HideLockedSessions := Settings.HideLockedSessions;

  if (HideLockedSessions) then
  begin
    actnSessFr_Visible.Checked := true; // hide locked sessions.
    SetVisibilityIcons;
  end
  else
  begin
    actnSessFr_Visible.Checked := false;  // Show all .
    SetVisibilityIcons;
  end;

  gSession.BeginUpdate;
  // true - indxShowAll , false indxHideLocked. (INVERTED LOGIC)
  uSession.SetVisibilityOfLocked(not actnSessFr_Visible.Checked);
  gSession.EndUpdate;

end;

procedure TFrameSession.Msg_SCM_Scroll_Session(var Msg: TMessage);
var
  i: integer;
begin
  // track the state of locked/unlocked.
  i := CORE.qrySession.FieldByName('SessionStatusID').AsInteger;
  if (i=2) and not actnSessFr_Lock.Checked then
  begin
    actnSessFr_Lock.Checked := true; // syncronize to equal db state
    SetLockIcons;
  end;

  if (i=1) and actnSessFr_Lock.Checked then
  begin
    actnSessFr_Lock.Checked := false; // syncronize to equal db state
    SetLockIcons;
  end;
end;

procedure TFrameSession.SetLockIcons;
begin
  if actnSessFr_Lock.Checked then
  begin
    actnSessFr_Lock.ImageIndex := 6; // lock2 icon
    if (spbtnSessLock.ImageIndex <> 6) then // saves a repaint..
      spbtnSessLock.ImageIndex := 6;
  end
  else
  begin
    actnSessFr_Lock.ImageIndex := 7; // lock2-open icon
    if (spbtnSessLock.ImageIndex <> 7) then // saves a repaint..
      spbtnSessLock.ImageIndex := 7;
  end;
end;

procedure TFrameSession.SetVisibilityIcons;
begin
    if actnSessFr_Visible.Checked then
    begin
      actnSessFr_Visible.ImageIndex := 2; // Eye+line - HIDE locked sessions.
      if (spbtnSessVisible.ImageIndex <> 2) then // saves a repaint..
        spbtnSessVisible.ImageIndex := 2;
    end
    else
    begin
      actnSessFr_Visible.ImageIndex := 1; // Eye - SHOW ALL sessions.
      if (spbtnSessVisible.ImageIndex <> 1) then // saves a repaint..
        spbtnSessVisible.ImageIndex := 1;
    end;
end;

end.
