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
  Vcl.Themes, Vcl.ImgList, Vcl.Menus, Vcl.WinXCtrls,

  AdvUtil, AdvObj, AdvGrid, DBAdvGrid,

  dmSCM2, dmIMG, dmCORE, uSettings, uDefines

  ;

type

  TFrameSession = class(TFrame)
    actnlstSession: TActionList;
    actnSess_Clone: TAction;
    actnSess_Delete: TAction;
    actnSess_Edit: TAction;
    actnSess_Export: TAction;
    actnSess_Import: TAction;
    actnSess_Visibilty: TAction;
    actnSess_Lock: TAction;
    actnSess_New: TAction;
    actnSess_Report: TAction;
    actnSess_Schedule: TAction;
    actnSess_Search: TAction;
    actnSess_Sort: TAction;
    actnSess_Stats: TAction;
    CloneSession1: TMenuItem;
    DeleteSession1: TMenuItem;
    EditSession1: TMenuItem;
    grid: TDBAdvGrid;
    LockUnlock1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    NewSession1: TMenuItem;
    pnlBody: TPanel;
    pumenuSession: TPopupMenu;
    pumToggleVisibility: TMenuItem;
    SessionReport1: TMenuItem;
    ShapeSessBar1: TShape;
    ShapeSessBar2: TShape;
    spbtnSessClone: TSpeedButton;
    spbtnSessDelete: TSpeedButton;
    spbtnSessEdit: TSpeedButton;
    spbtnSessLockState: TSpeedButton;
    spbtnSessVisiblity: TSpeedButton;
    spbtnSessNew: TSpeedButton;
    spbtnSessReport: TSpeedButton;
    rpnlCntrl: TRelativePanel;
    procedure actnSess_CheckLockUpdate(Sender: TObject);
    procedure actnSess_CloneUpdate(Sender: TObject);
    procedure actnSess_DeleteExecute(Sender: TObject);
    procedure actnSess_DeleteUpdate(Sender: TObject);
    procedure actnSess_EditExecute(Sender: TObject);
    procedure actnSess_EditUpdate(Sender: TObject);
    procedure actnSess_VisibiltyExecute(Sender: TObject);
    procedure actnSess_VisibiltyUpdate(Sender: TObject);
    procedure actnSess_LockExecute(Sender: TObject);
    procedure actnSess_LockUpdate(Sender: TObject);
    procedure actnSess_NewExecute(Sender: TObject);
    procedure actnSess_NewUpdate(Sender: TObject);
    procedure actnSess_ReportUpdate(Sender: TObject);
    procedure actnSess_SortExecute(Sender: TObject);
    procedure actnSess_SortUpdate(Sender: TObject);
    procedure gridDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure gridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState:
        TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure gridGetHTMLTemplate(Sender: TObject; ACol, ARow: Integer; var
        HTMLTemplate: string; Fields: TFields);
  private
    procedure SetVisibilityIcon;
    procedure SetLockStateIcon;
  protected
    procedure Loaded; override;
  public
    procedure Initialise();
    // messages must be forwarded by main form.
    procedure Msg_SCM_Scroll_Session(var Msg: TMessage); message SCM_SCROLL_SESSION;
  end;

implementation

uses
  uSession, dlgEditSession, dlgNewSession;

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
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
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
  grid.BeginUpdate;
  try
    { D E L E T E  S E S S I O N   D O   N O T   E X C L U D E ! }
    { uSession handles enable/disable and re-sync of Master-Detail}
    uSession.Delete_Session(false);
  finally
    grid.EndUpdate;
  end;
end;

procedure TFrameSession.actnSess_DeleteUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and not CORE.qrySession.IsEmpty then
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
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and not CORE.qrySession.IsEmpty then
  begin
    if CORE.qrySession.FieldByName('SessionStatusID').AsInteger <> 2 then
      DoEnable := true;
  end;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSession.actnSess_VisibiltyExecute(Sender: TObject);
begin
    grid.BeginUpdate;
    TAction(Sender).Checked := not TAction(Sender).Checked;
    try
      SetVisibilityIcon;
      // Assign index ... ApplyMaster.
      // true - indxShowAll , false indxHideLocked.
      uSession.SetIndexName(TAction(Sender).Checked);
    finally
      grid.EndUpdate;
    end;
end;

procedure TFrameSession.actnSess_VisibiltyUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qrySession.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSession.actnSess_LockExecute(Sender: TObject);
begin
  grid.BeginUpdate;
  try
    TAction(Sender).Checked := not TAction(Sender).Checked;
    if TAction(Sender).Checked then
    begin
      try
        uSession.SetSessionStatusID(2); // CLOSED ie.LOCKED.
        // good opertunity to re-calulate and store count values.
        {-------------------------------------------------------}
        // iterate over events in session - re-calculating counts.
        uSession.UpdateEvent_Stats();
        // uses database scalar functions.
        uSession.SetSess_NomineeCount; // SwimClubMeet2.dbo.SessionNomineeCount
        uSession.SetSess_EntrantCount; // SwimClubMeet2.dbo.SessionEntrantCount
      finally
        actnSess_Lock.Checked := true; // syncronize to equal db state
        SetLockStateIcon;
      end;
    end
    else
    begin
      uSession.SetSessionStatusID(1); // OPEN ie.UN-LOCKED.
      actnSess_Lock.Checked := false; // syncronize to equal db state
      SetLockStateIcon;
    end;
  finally
    grid.endUpdate;
  end;
end;

procedure TFrameSession.actnSess_LockUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
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
  DoEnable := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSession.actnSess_ReportUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qrySession.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSession.actnSess_SortExecute(Sender: TObject);
begin
  grid.BeginUpdate;
  {TODO -oBSA -cGeneral : Check if detailed tables are in sync.}
  CORE.qrySession.Refresh;
  grid.EndUpdate;
end;

procedure TFrameSession.actnSess_SortUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qrySession.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;


procedure TFrameSession.gridDblClickCell(Sender: TObject; ARow, ACol:
    Integer);
begin
  // edit the session....
  if (ARow >= grid.FixedRows) and (ACol = 1)then
    actnSess_Edit.Execute;
end;

procedure TFrameSession.gridGetCellColor(Sender: TObject; ARow, ACol:
    Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  // method to obtain the 'StyleElements' font color for grid items.
  // FontColor := StyleServices.GetStyleFontColor(sfGridItemFixedPressed);
  // blueish-white..$00FFE4D8;

  if (ARow >= grid.FixedRows) then   // (ARow >= grid.FixedCols)
  begin
    if (grid.Cells[2, ARow] = '2') then
      AFont.Color := grid.DisabledFontColor
    else
    begin
      if (gdSelected in AState) then
        AFont.Color := RGB(255, 254, 254) // slightly dimmed white.
      else
        AFont.Color :=  RGB(215, 215, 215); // even dimmer.
      // clWebGhostWhite;
    end;
  end;

  { C E L L   C O L O R S  .
    1. the StyleElements seFont has been disabled for the session grid.
    2. the propert UseSelectionColor has been disabled.
    3. the property SelectionTextColor has been set but will be ignored.

    - results : all assignments of font color are handles here.

  }
end;

procedure TFrameSession.gridGetHTMLTemplate(Sender: TObject; ACol, ARow:
    Integer; var HTMLTemplate: string; Fields: TFields);
var
  s: string;
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

  if (ACol = 1) then     // and (ARow >= grid.FixedRows)
  begin
    if not Locked then
    begin
      // Session date and time. Caption. Status buttons. 2xlines
      s := '''
        <FONT Size="14">
        <IND x="2"><B><#SessionDT></B></FONT>
        <br>
        <FONT Size="12">
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
        <IND x="2"><FONT Size="10"><#SessionDT>
        <br>
        <IND x="4">'<#Caption>
        <br>
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
  //  grid.RowCount := grid.FixedRows + 1; // rule: row count > fixed row.
  grid.BeginUpdate; // Assures grid.Paint..
  try
  begin
    if SCM2.scmConnection.Connected and CORE.IsActive then
    begin

      if CORE.qrySession.IsEmpty then
      begin
        // setting pagemode to false clears grid of text. (it appears empty)
        grid.PageMode := false;
      end
      else
      begin
        // Set pagemode to the default 'editable' fetch records mode.
        grid.PageMode := true;

        if Assigned(Settings) then
          actnSess_Visibilty.Checked := Settings.HideLockedSessions
        else
          actnSess_Visibilty.Checked := false;

        SetVisibilityIcon; // uses actnSess_Visible.Checked state.

        grid.BeginUpdate;
          // FILTER TABLE CONTENTS: false - indxShowAll , true indxHideLocked.
          uSession.SetIndexName(actnSess_Visibilty.Checked);
        grid.EndUpdate;
      end;
    end
  else
    grid.PageMode := false; // read-only
  end;
  finally
    grid.EndUpdate;
  end;

end;

procedure TFrameSession.Loaded;
begin
  inherited Loaded;
  // This executes after the DFM has loaded and ActionLinks have synced.
  // Manually re-apply your 48x48 indices here.
//  spbtnSessVisiblity.ImageIndex := 1;
  spbtnSessVisiblity.ImageName := 'visible-on';
//  spbtnSessLockState.ImageIndex := 3;
  spbtnSessLockState.ImageName := 'lock2';
//  spbtnSessEdit.ImageIndex := 5;
  spbtnSessEdit.ImageName := 'edit';
//  spbtnSessNew.ImageIndex := 6;
  spbtnSessNew.ImageName := 'new';
//  spbtnSessClone.ImageIndex := 7;
  spbtnSessClone.ImageName := 'clone';
//  spbtnSessDelete.ImageIndex := 8;
  spbtnSessDelete.ImageName := 'delete';
//  spbtnSessReport.ImageIndex := 9;
  spbtnSessReport.ImageName := 'report';
end;

procedure TFrameSession.Msg_SCM_Scroll_Session(var Msg: TMessage);
var
  i: integer;
begin
  // avoid unnessary calls during boot-up.
  grid.BeginUpdate;
  try
    begin
      if Assigned(SCM2) and SCM2.scmConnection.Connected
        and Assigned(CORE) and  CORE.IsActive then
      begin
        // track the state of locked/unlocked.
        i := CORE.qrySession.FieldByName('SessionStatusID').AsInteger;
        if (i=2) and not actnSess_Lock.Checked then
        begin
          actnSess_Lock.Checked := true; // syncronize to equal db state
          SetLockStateIcon;
        end;
        if (i=1) and actnSess_Lock.Checked then
        begin
          actnSess_Lock.Checked := false; // syncronize to equal db state
          SetLockStateIcon;
        end;
      end;
    end;
  finally
    grid.EndUpdate;
  end;
end;

procedure TFrameSession.SetVisibilityIcon;
begin
    if actnSess_Visibilty.Checked then
    begin
      actnSess_Visibilty.ImageName := 'visible-off'; // Eye+line - HIDE locked sessions.
      spbtnSessVisiblity.ImageIndex := 2;

    end
    else
    begin
      actnSess_Visibilty.ImageName := 'visible-on'; // Eye - SHOW ALL sessions.
      spbtnSessVisiblity.ImageIndex := 1;
    end;
end;

procedure TFrameSession.SetLockStateIcon;
begin
  if actnSess_Lock.Checked then
  begin
    actnSess_Lock.ImageName := 'lock2' ;// lock2 icon
    spbtnSessLockState.ImageIndex := 3;
   end
  else
  begin
    actnSess_Lock.ImageName := 'lock2-open'; // lock2-open icon
    spbtnSessLockState.ImageIndex := 4;
  end
end;

end.
