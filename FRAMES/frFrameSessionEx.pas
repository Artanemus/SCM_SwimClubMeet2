unit frFrameSessionEx;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes,  System.Actions,
  System.DateUtils,

  Data.DB, BaseGrid,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,Vcl.ActnList,
  Vcl.ExtCtrls, Vcl.WinXPanels, Vcl.Buttons, Vcl.Grids,

  AdvUtil, AdvObj, AdvGrid, DBAdvGrid,

  dmSCM2, dmIMG, dmCORE, uSettings, uSession;

type
  TFrameSessionEx = class(TFrame)
    actnlstSession: TActionList;
    actnVisible: TAction;
    stackpnlSess: TStackPanel;
    spbtnSessVisible: TSpeedButton;
    spbtnSessLock: TSpeedButton;
    ShapeSessBar1: TShape;
    spbtnSessEdit: TSpeedButton;
    spbtnSessNew: TSpeedButton;
    spbtnSessClone: TSpeedButton;
    spbtnSessDelete: TSpeedButton;
    ShapeSessBar2: TShape;
    spbtnSessReport: TSpeedButton;
    pnlBody: TPanel;
    gSession: TDBAdvGrid;
    actnLock: TAction;
    actnEdit: TAction;
    actnNew: TAction;
    actnClone: TAction;
    actnDelete: TAction;
    actnReport: TAction;
    procedure actnDeleteExecute(Sender: TObject);
    procedure actnEditExecute(Sender: TObject);
    procedure actnVisibleExecute(Sender: TObject);
    procedure actnGenericUpdate(Sender: TObject);
    procedure actnLockExecute(Sender: TObject);
    procedure actnNewExecute(Sender: TObject);
    procedure actnNewUpdate(Sender: TObject);
    procedure gSessionGetCellColor(Sender: TObject; ARow, ACol: Integer; AState:
        TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure gSessionGetHTMLTemplate(Sender: TObject; ACol, ARow: Integer; var
        HTMLTemplate: string; Fields: TFields);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrameSessionEx.actnDeleteExecute(Sender: TObject);
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
    uSession.DeleteSession(false);
  finally
    gSession.EndUpdate;
  end;
end;

procedure TFrameSessionEx.actnEditExecute(Sender: TObject);
begin
  // open the session DLG editing EDIT MODE.
end;

procedure TFrameSessionEx.actnVisibleExecute(Sender: TObject);
begin
    gSession.BeginUpdate;
    TAction(Sender).Checked := not TAction(Sender).Checked;
    try
      if TAction(Sender).Checked then
        TAction(Sender).ImageIndex := 2 // Hide locked.
      else
        TAction(Sender).ImageIndex := 1; // Show locked.

      uSession.SetVisibilityOfLocked(TAction(Sender).Checked);

    finally
      gSession.EndUpdate;
    end;
end;

procedure TFrameSessionEx.actnGenericUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(CORE) and CORE.IsActive and
    not CORE.qrySession.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameSessionEx.actnLockExecute(Sender: TObject);
begin
  with (Sender as TAction) do
  begin
    gSession.BeginUpdate;
    try
    Checked := not Checked;
    if Checked then
    begin
      TAction(Sender).ImageIndex := 7;
      uSession.SetSessionStatusID(1); // UN-LOCKED.
    end
    else
    begin
      TAction(Sender).ImageIndex := 6;
      uSession.SetSessionStatusID(2); // LOCKED.
    end;
    finally
      gSession.endUpdate;
    end;
  end;
end;

procedure TFrameSessionEx.actnNewExecute(Sender: TObject);
begin
  // open the session DLG editing INSERT MODE.
end;

procedure TFrameSessionEx.actnNewUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(CORE) and CORE.IsActive then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;


procedure TFrameSessionEx.gSessionGetCellColor(Sender: TObject; ARow, ACol:
    Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  if (ARow >= gSession.FixedRows) then   // (ARow >= gSession.FixedCols)
  begin
    if (CORE.qrySession.FieldByName('SessionStatusID').AsInteger = 2) then
        AFont.Color := gSession.DisabledFontColor
    else AFont.Color := Font.Color;
  end;
end;

procedure TFrameSessionEx.gSessionGetHTMLTemplate(Sender: TObject; ACol, ARow:
    Integer; var HTMLTemplate: string; Fields: TFields);
var
  s: string;
  DT1, DT2: TDateTime;
  ShowSeasonIcon: boolean;
//  fColor: TColor;
//  sColor: string;
//  fFont: TFont;
//  cp: TCellProperties;
begin
  if (not Assigned(CORE)) or (not CORE.IsActive) or
    CORE.qrySession.IsEmpty then exit;

  ShowSeasonIcon := false;
  {
  cp := gSession.GetCellProperties(ACol, ARow);
  fColor := cp.FontColor;
  fFont := gSession.ActiveCellFont;
  fColor := fFont.Color;
  sColor := ColorToString(fColor);
  s := s + '<FONT Color=' + sColor +'"';
   }
  DT1 := CORE.qrySession.FieldByName('SessionDT').AsDateTime;
  DT2 := CORE.qrySwimClub.FieldByName('StartOfSwimSeason').AsDateTime;
  if WithinPastMonths(Dt1,DT2,6) then ShowSeasonIcon := true;

  if (ACol = 1) then     // and (ARow >= gSession.FixedRows)
  begin
    if (CORE.qrySession.FieldByName('SessionStatusID').AsInteger <> 2) then
    begin
      // Session date and time. Caption. Status buttons.
      s := '''
        <IND x="2"><FONT Size="10"><B><#SessionDT></B><br>
        <IND x="2"><FONT Size="10"><#Caption><br>
        <IND x="4"><FONT Size="9"><IMG src="idx:7" align="middle">
        ''';
    end
    else // The session is locked - alternative display.
    begin
      s := '''
        <IND x="2"><FONT Size="10"><#SessionDT>
        <br><IND x="2"><FONT Size="10"><#Caption>
        <br><IND x="4"><FONT Size="9"><IMG src="idx:6" align="middle">
        ''';
    end;

    if ShowSeasonIcon then
      s := s + '<IND x="32"><IMG src="idx:13" align="middle">';

    // Nominees Entrants
//    s := s + '  <IMG src="idx:14" align="middle"> <#NomineeCount>  <IMG src="idx:15" align="middle"> <#EntrantCount> ';

    HTMLTemplate := s;
  end;


end;

end.
