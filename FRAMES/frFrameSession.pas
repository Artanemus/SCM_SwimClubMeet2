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
    actnSess_Clone: TAction;
    actnSess_Delete: TAction;
    actnSess_Edit: TAction;
    actnSess_Lock: TAction;
    actnSess_IsLocked: TAction;
    actnSess_New: TAction;
    actnSess_Report: TAction;
    CloneSession1: TMenuItem;
    DeleteSession1: TMenuItem;
    EditSession1: TMenuItem;
    gSession: TDBAdvGrid;
    LockUnlock1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    NewSession1: TMenuItem;
    pnlBody: TPanel;
    pnlCntrl: TPanel;
    pumenuSession: TPopupMenu;
    pumToggleVisibility: TMenuItem;
    SessionReport1: TMenuItem;
    ShapeSessBar1: TShape;
    ShapeSessBar2: TShape;
    spbtnSessClone: TSpeedButton;
    spbtnSessDelete: TSpeedButton;
    spbtnSessEdit: TSpeedButton;
    spbtnSessLock: TSpeedButton;
    spbtnSessLockedVisible: TSpeedButton;
    spbtnSessNew: TSpeedButton;
    spbtnSessReport: TSpeedButton;
    actnSess_Export: TAction;
    actnSess_Import: TAction;
    actnSess_Sort: TAction;
    actnSess_Search: TAction;
    actnSess_Stats: TAction;
    actnSess_Schedule: TAction;
    procedure actnSess_CheckLockUpdate(Sender: TObject);
    procedure actnSess_CloneUpdate(Sender: TObject);
    procedure actnSess_DeleteExecute(Sender: TObject);
    procedure actnSess_DeleteUpdate(Sender: TObject);
    procedure actnSess_EditExecute(Sender: TObject);
    procedure actnSess_EditUpdate(Sender: TObject);
    procedure actnSess_IsLockedExecute(Sender: TObject);
    procedure actnSess_IsLockedUpdate(Sender: TObject);
    procedure actnSess_LockExecute(Sender: TObject);
    procedure actnSess_LockUpdate(Sender: TObject);
    procedure actnSess_NewExecute(Sender: TObject);
    procedure actnSess_NewUpdate(Sender: TObject);
    procedure actnSess_ReportUpdate(Sender: TObject);
    procedure actnSess_SortExecute(Sender: TObject);
    procedure actnSess_SortUpdate(Sender: TObject);
    procedure gSessionDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure gSessionGetCellColor(Sender: TObject; ARow, ACol: Integer; AState:
        TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure gSessionGetHTMLTemplate(Sender: TObject; ACol, ARow: Integer; var
        HTMLTemplate: string; Fields: TFields);
  private
    { Private declarations }
    procedure SetIsLockedIcon;
    procedure SetLockIcon;
    procedure FixedSessCntrlIcons;
  public
    procedure Initialise();
    // messages must be forwarded by main form.
    procedure Msg_SCM_Scroll_Session(var Msg: TMessage); message SCM_SCROLL_SESSION;

  end;

implementation

uses
  dlgEditSession, dlgNewSession;

{$R *.dfm}

procedure TFrameSession.actnSess_CheckLockUpdate(Sender: TObject);
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

procedure TFrameSession.actnSess_CloneUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  // fix RAD STUDIO icon re-assignment issue.
  if (spbtnSessClone.imageindex <> 11) then
    spbtnSessClone.imageindex := 11;
  if Assigned(CORE) and CORE.IsActive and
    not CORE.qrySession.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSession.actnSess_DeleteExecute(Sender: TObject);
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

procedure TFrameSession.actnSess_DeleteUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  // fix RAD STUDIO icon re-assignment issue.
  if (spbtnSessDelete.imageindex <> 4) then
    spbtnSessDelete.imageindex := 4;
  if Assigned(CORE) and CORE.IsActive and not CORE.qrySession.IsEmpty then
  begin
    if CORE.qrySession.FieldByName('SessionStatusID').AsInteger <> 2 then
      DoEnable := true;
  end;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSession.actnSess_EditExecute(Sender: TObject);
var
dlg: TEditSession;
begin
  dlg := TEditSession.Create(Self);
  dlg.ShowModal;
  dlg.Free;
end;

procedure TFrameSession.actnSess_EditUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  // fix RAD STUDIO icon re-assignment issue.
  if (spbtnSessEdit.imageindex <> 8) then
    spbtnSessEdit.imageindex := 8;
  if Assigned(CORE) and CORE.IsActive and not CORE.qrySession.IsEmpty then
  begin
    if CORE.qrySession.FieldByName('SessionStatusID').AsInteger <> 2 then
      DoEnable := true;
  end;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSession.actnSess_IsLockedExecute(Sender: TObject);
begin
    gSession.BeginUpdate;
    TAction(Sender).Checked := not TAction(Sender).Checked;
    try
      SetIsLockedIcon;
      // Assign index ... ApplyMaster.
      // true - indxShowAll , false indxHideLocked.
      uSession.SetIndexName(TAction(Sender).Checked);
    finally
      gSession.EndUpdate;
    end;
end;

procedure TFrameSession.actnSess_IsLockedUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  // fix RAD STUDIO icon re-assignment issue.
  if (not spbtnSessLockedVisible.imageindex in [1,2]) then
    spbtnSessLockedVisible.imageindex := 1; // eye icon - no slash.
  if Assigned(CORE) and CORE.IsActive and
    not CORE.qrySession.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSession.actnSess_LockExecute(Sender: TObject);
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

procedure TFrameSession.actnSess_LockUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  // fix RAD STUDIO icon re-assignment issue.
  if (not spbtnSessLock.imageindex in [6,7]) then
    spbtnSessLock.imageindex := 7; // lock icon is open.
  if Assigned(CORE) and CORE.IsActive and
    not CORE.qrySession.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSession.actnSess_NewExecute(Sender: TObject);
var
  dlg: TNewSession;
  mr: TModalResult;
begin
  dlg := TNewSession.Create(Self);
  mr := dlg.ShowModal;
  dlg.Free;
  if mr = mrOk then
    CORE.qrySession.Refresh;
end;

procedure TFrameSession.actnSess_NewUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  // fix RAD STUDIO icon re-assignment issue.
  if (spbtnSessNew.imageindex <> 3) then
    spbtnSessNew.imageindex := 3;
  DoEnable := false;
  if Assigned(CORE) and CORE.IsActive then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSession.actnSess_ReportUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  // fix RAD STUDIO icon re-assignment issue.
  if (spbtnSessReport.imageindex <> 5) then
    spbtnSessReport.imageindex := 5;
  if Assigned(CORE) and CORE.IsActive and
    not CORE.qrySession.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSession.actnSess_SortExecute(Sender: TObject);
begin
  gSession.BeginUpdate;
  {TODO -oBSA -cGeneral : Check if detailed tables are in sync.}
  CORE.qrySession.Refresh;
  gSession.EndUpdate;
end;

procedure TFrameSession.actnSess_SortUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(CORE) and CORE.IsActive and
    not CORE.qrySession.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSession.FixedSessCntrlIcons;
var
  i: integer;
begin
  for I := 0 to actnlstSession.ActionCount - 1 do
    TAction(actnlstSession.Actions[i]).Update;
end;

procedure TFrameSession.gSessionDblClickCell(Sender: TObject; ARow, ACol:
    Integer);
begin
  // edit the session....
  if (ARow >= gSession.FixedRows) and (ACol = 1)then
    actnSess_Edit.Execute;
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
  ShowSeasonIcon, Locked: boolean;
  weeks: integer;
begin
  if (not Assigned(CORE)) or (not CORE.IsActive) or
    CORE.qrySession.IsEmpty then exit;


  ShowSeasonIcon := false;
  if CORE.qrySession.FieldByName('SessionStatusID').AsInteger = 2 then
    Locked := true else Locked := false;
  // as typical swimming season is 6 months .. 25 weeks...
  weeks := uSession.WeeksSinceSeasonStart;
  if (weeks < 26) and (weeks > 0) then ShowSeasonIcon := true;

  if (ACol = 1) then     // and (ARow >= gSession.FixedRows)
  begin
    if not Locked then
    begin
      // Session date and time. Caption. Status buttons. 2xlines
      s := '''
        <FONT Size="12">
        <IND x="2"><B><#SessionDT></B><br>
        <IND x="4"><IMG src="idx:7" align="bottom">
        ''';
      if ShowSeasonIcon then
      begin
        s := s + '<IND x="24"><IMG src="idx:17" align="bottom">';
        s := s + ' ' + IntToStr(weeks) + ' ';
      end;
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
      begin
        s := s + '  <IMG src="idx:17" align="middle">'; // <IND x="24">
        s := s + ' ' + IntToStr(weeks) + '  ';
      end;
      // extended info shown only on locked sessions <IND x="44">  <IND x="104">
      s := s + '  <IMG src="idx:14" align="middle"> <#NomineeCount>';
      s := s + '  <IMG src="idx:15" align="middle"> <#EntrantCount></FONT>';

    end;
    HTMLTemplate := s;
  end;


end;

procedure TFrameSession.Initialise;
begin
  FixedSessCntrlIcons; // Fix RAD Studio erronous icon assignment.
  gSession.RowCount := gSession.FixedRows + 1; // rule: row count > fixed row.

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
        actnSess_IsLocked.Checked := Settings.HideLockedSessions
      else
        actnSess_IsLocked.Checked := false;

      SetIsLockedIcon; // uses actnSess_Visible.Checked state.

      gSession.BeginUpdate;
        // FILTER TABLE CONTENTS: false - indxShowAll , true indxHideLocked.
        uSession.SetIndexName(actnSess_IsLocked.Checked);
      gSession.EndUpdate;
    end;
  end
  else
    gSession.PageMode := false; // read-only

end;

procedure TFrameSession.Msg_SCM_Scroll_Session(var Msg: TMessage);
var
  i: integer;
begin
  // track the state of locked/unlocked.
  i := CORE.qrySession.FieldByName('SessionStatusID').AsInteger;
  if (i=2) and not actnSess_Lock.Checked then
  begin
    actnSess_Lock.Checked := true; // syncronize to equal db state
    SetLockIcon;
  end;
  if (i=1) and actnSess_Lock.Checked then
  begin
    actnSess_Lock.Checked := false; // syncronize to equal db state
    SetLockIcon;
  end;
end;

procedure TFrameSession.SetIsLockedIcon;
begin
    if actnSess_IsLocked.Checked then
    begin
      actnSess_IsLocked.ImageIndex := 4; // Eye+line - HIDE locked sessions.
      if (spbtnSessLockedVisible.ImageIndex <> 2) then // saves a repaint..
        spbtnSessLockedVisible.ImageIndex := 2;
    end
    else
    begin
      actnSess_IsLocked.ImageIndex := 3; // Eye - SHOW ALL sessions.
      if (spbtnSessLockedVisible.ImageIndex <> 1) then // saves a repaint..
        spbtnSessLockedVisible.ImageIndex := 1;
    end;
end;

procedure TFrameSession.SetLockIcon;
begin
  if actnSess_Lock.Checked then
  begin
    actnSess_Lock.ImageIndex := 16; // lock2 icon
    if (spbtnSessLock.ImageIndex <> 6) then // saves a repaint..
      spbtnSessLock.ImageIndex := 6;
  end
  else
  begin
    actnSess_Lock.ImageIndex := 17; // lock2-open icon
    if (spbtnSessLock.ImageIndex <> 7) then // saves a repaint..
      spbtnSessLock.ImageIndex := 7;
  end;
end;


end.
