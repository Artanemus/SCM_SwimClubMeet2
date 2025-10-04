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
  Vcl.Themes,

  AdvUtil, AdvObj, AdvGrid, DBAdvGrid,

  dmSCM2, dmIMG, dmCORE, uSettings, uSession, uDefines, Vcl.Menus;

type
  TFrameSession = class(TFrame)
    actnlstSession: TActionList;
    actnSessFr_LockedVisible: TAction;
    spbtnSessLockedVisible: TSpeedButton;
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
    pumenuSession: TPopupMenu;
    pumToggleVisibility: TMenuItem;
    LockUnlock1: TMenuItem;
    EditSession1: TMenuItem;
    NewSession1: TMenuItem;
    SessionReport1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    CloneSession1: TMenuItem;
    DeleteSession1: TMenuItem;
    procedure actnSessFr_DeleteExecute(Sender: TObject);
    procedure actnSessFr_EditExecute(Sender: TObject);
    procedure actnSessFr_LockedVisibleExecute(Sender: TObject);
    procedure actnSessFr_DefaultUpdate(Sender: TObject);
    procedure actnSessFr_CheckLockUpdate(Sender: TObject);
    procedure actnSessFr_LockExecute(Sender: TObject);
    procedure actnSessFr_NewExecute(Sender: TObject);
    procedure actnSessFr_NewUpdate(Sender: TObject);
    procedure gSessionDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure gSessionGetCellColor(Sender: TObject; ARow, ACol: Integer; AState:
        TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure gSessionGetHTMLTemplate(Sender: TObject; ACol, ARow: Integer; var
        HTMLTemplate: string; Fields: TFields);
  private
    { Private declarations }
    procedure SetLockedVisibleIcon;
    procedure SetLockIcon;

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

procedure TFrameSession.actnSessFr_LockedVisibleExecute(Sender: TObject);
begin
    gSession.BeginUpdate;
    TAction(Sender).Checked := not TAction(Sender).Checked;
    try
      SetLockedVisibleIcon;
      // Assign index ... ApplyMaster.
      // true - indxShowAll , false indxHideLocked.
      uSession.SetIndexName(TAction(Sender).Checked);
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
      // good opertunity to re-calulate and store count values.
      uSession.SetNomineeCount;
      uSession.SetEntrantCount;
      SetLockIcon;
    end
    else
    begin
      uSession.SetSessionStatusID(1); // OPEN ie.UN-LOCKED.
      SetLockIcon;
    end;
  finally
    gSession.endUpdate;
  end;
end;

procedure TFrameSession.actnSessFr_NewExecute(Sender: TObject);
begin
  gSession.PageMode := true;

end;

procedure TFrameSession.actnSessFr_NewUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(CORE) and CORE.IsActive then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSession.gSessionDblClickCell(Sender: TObject; ARow, ACol:
    Integer);
begin
  // edit the session....
  if (ARow >= gSession.FixedRows) and (ACol = 1)then
    actnSessFr_Edit.Execute;
end;

procedure TFrameSession.gSessionGetCellColor(Sender: TObject; ARow, ACol:
    Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  FontColor: TColor;
begin
  // greenish-blue color..
  FontColor := StyleServices.GetStyleFontColor(sfGridItemFixedPressed);

  if (ARow >= gSession.FixedRows) then   // (ARow >= gSession.FixedCols)
  begin
    if (gSession.Cells[2, ARow] = '2') then
      AFont.Color := gSession.DisabledFontColor
    else
      AFont.Color :=  FontColor; /// blueish-white..$00FFE4D8;
  end;

  { C E L L   C O L O R S  .
    if StyleElements seFont = false then grids selection color param
    is activated ..
          eg. gSession.SelectionTextColor := clWebGoldenRod;

    OR DISABLE the grids selectionn text color ..
          eg. gSession.UseSelectionTextColor := false;

    AND then assign in this procedure...

    if (gdSelected in AState) then AFont.Color := ???
  }
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
begin
  if SCM2.scmConnection.Connected and CORE.IsActive then
  begin
    if CORE.qrySession.IsEmpty then
    begin
      // setting pagemode to false clears gSession of text. (it appears empty)
      gSession.PageMode := false;
    end
    else
    begin
      // Set pagemode to the default 'editable' fetch records mode.
      gSession.PageMode := true;

      if Assigned(Settings) then
        actnSessFr_LockedVisible.Checked := Settings.HideLockedSessions
      else
        actnSessFr_LockedVisible.Checked := false;

      SetLockedVisibleIcon; // uses actnSessFr_Visible.Checked state.

      gSession.BeginUpdate;
      // false - indxShowAll , true indxHideLocked.
      uSession.SetIndexName(actnSessFr_LockedVisible.Checked);
      gSession.EndUpdate;
    end;
  end
  else
    gSession.PageMode := false;
//
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
    SetLockIcon;
  end;
  if (i=1) and actnSessFr_Lock.Checked then
  begin
    actnSessFr_Lock.Checked := false; // syncronize to equal db state
    SetLockIcon;
  end;
end;

procedure TFrameSession.SetLockIcon;
begin
  if actnSessFr_Lock.Checked then
  begin
    actnSessFr_Lock.ImageIndex := 16; // lock2 icon
    if (spbtnSessLock.ImageIndex <> 6) then // saves a repaint..
      spbtnSessLock.ImageIndex := 6;
  end
  else
  begin
    actnSessFr_Lock.ImageIndex := 17; // lock2-open icon
    if (spbtnSessLock.ImageIndex <> 7) then // saves a repaint..
      spbtnSessLock.ImageIndex := 7;
  end;
end;

procedure TFrameSession.SetLockedVisibleIcon;
begin
    if actnSessFr_LockedVisible.Checked then
    begin
      actnSessFr_LockedVisible.ImageIndex := 4; // Eye+line - HIDE locked sessions.
      if (spbtnSessLockedVisible.ImageIndex <> 2) then // saves a repaint..
        spbtnSessLockedVisible.ImageIndex := 2;
    end
    else
    begin
      actnSessFr_LockedVisible.ImageIndex := 3; // Eye - SHOW ALL sessions.
      if (spbtnSessLockedVisible.ImageIndex <> 1) then // saves a repaint..
        spbtnSessLockedVisible.ImageIndex := 1;
    end;
end;

end.
