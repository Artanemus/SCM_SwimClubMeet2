unit dlgNewSession;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants,
  System.Classes, System.UITypes,

  Data.DB,

  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.WinXPickers,
  Vcl.Mask, Vcl.DBCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Buttons,

  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  dmCORE, dmIMG, dmSCM2,

  uDefines, uSwimClub, uSession;

type
  scmSessionMode = (smEditSession, smNewSession, swNotGiven);

  TNewSession = class(TForm)
    btnCancel: TButton;
    btnDate: TButton;
    btnNow: TButton;
    btnPost: TButton;
    btnToday: TButton;
    datePickerSess: TDatePicker;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    spbtnMinus: TSpeedButton;
    spbtnPlus: TSpeedButton;
    timePickerSess: TTimePicker;
    pnlHeader: TPanel;
    DBTextClubName: TDBText;
    DBImageLogo: TDBImage;
    DBTextNickName: TDBText;
    procedure btnCancelClick(Sender: TObject);
    procedure btnDateClick(Sender: TObject);
    procedure btnMinusClick(Sender: TObject);
    procedure btnNowClick(Sender: TObject);
    procedure btnPlusClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure btnTodayClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure AutoCalcDateTime();
  end;

var
  EditSession: TNewSession;

implementation

{$R *.dfm}

uses
  System.DateUtils, dlgDatePicker;

procedure TNewSession.AutoCalcDateTime;
var
  lastDT: TDateTime;
  v: variant;
  SQL: string;
  id: integer;
begin
  // get the Max DT
  SQL := '''
    SELECT MAX([SessionDT]) FROM SWimClubMeet2.dbo.Session
    WHERE [SwimClubID] = :ID;
    ''';

  if CORE.qrySession.IsEmpty then
  begin
    lastDT := RecodeTime(Now, HourOf(Now), 0, 0, 0);
  end
  else
  begin
    // master - detail.
    id := CORE.qrySession.FieldByName('SwimClubID').AsInteger;
    v := SCM2.scmConnection.ExecSQLScalar(SQL, [id]);
    if (not VarIsClear(v)) and (v > 0) then
      lastDT := IncWeek(DateOf(v), 1) + RecodeTime(0, HourOf(v), 0, 0, 0)
    else
      lastDT := RecodeTime(Now, HourOf(Now), 0, 0, 0);
  end;
  datePickerSess.Date := DateOf(lastDT);
  timePickerSess.Time := TimeOf(lastDT);
end;

procedure TNewSession.btnCancelClick(Sender: TObject);
begin
    if CORE.qrySession.State = dsInsert then CORE.qrySession.Cancel;
    ModalResult := mrCancel;
end;

procedure TNewSession.btnDateClick(Sender: TObject);
var
  dlg: TDatePicker;
  Rect: TRect;
  rtn: TModalResult;
begin
  dlg := TDatePicker.Create(Self);

  dlg.Position := poDesigned;
  Rect := btnDate.ClientToScreen(btnDate.ClientRect);
  dlg.Left := Rect.Left;
  dlg.Top := Rect.Bottom + 1;
  dlg.CalendarView1.Date := datePickerSess.Date;
  rtn := dlg.ShowModal;
  if IsPositiveResult(rtn) then
    datePickerSess.Date := dlg.CalendarView1.Date;

  dlg.Free;
end;

procedure TNewSession.btnMinusClick(Sender: TObject);
begin
  timePickerSess.time := TDateTime(timePickerSess.time).IncMinute(-15);
end;

procedure TNewSession.btnNowClick(Sender: TObject);
begin
  TDateTime(timePickerSess.Time).SetTime(Now().GetHour(), 0, 0, 0);
end;

procedure TNewSession.btnPlusClick(Sender: TObject);
begin
  timePickerSess.time := TDateTime(timePickerSess.time).IncMinute(15);
end;

procedure TNewSession.btnPostClick(Sender: TObject);
var
  dt: TDateTime;
begin
  if CORE.qrySession.State = dsInsert then
  begin
    try
      dt := datePickerSess.Date + timePickerSess.Time;
      if CORE.qrySession.FieldByName('SessionDT').AsDateTime <> dt then
        CORE.qrySession.FieldByName('SessionDT').AsDateTime := dt;

      if CORE.qrySession.FieldByName('SessionStatusID').IsNull then
        CORE.qrySession.FieldByName('SessionStatusID').AsInteger := 1;

      CORE.qrySession.FieldByName('SwimClubID').AsInteger :=
        CORE.qrySwimClub.FieldByName('SwimClubID').AsInteger;

      CORE.qrySession.FieldByName('NomineeCount').AsInteger := 0;
      CORE.qrySession.FieldByName('EntrantCount').AsInteger := 0;

      CORE.qrySession.Post; // finalize the changes...
      ModalResult := mrOk;
    except on E: Exception do
      begin
        // ShowMessage('Error saving session: ' + E.Message);
        CORE.qrySession.Cancel;
        ModalResult := mrCancel;
      end;
    end;
  end
  else
  begin
    CORE.qrySession.Cancel; // safe....
    ModalResult := mrCancel;
  end;
end;

procedure TNewSession.btnTodayClick(Sender: TObject);
begin
  datePickerSess.Date := Date.Today;
end;

procedure TNewSession.FormCreate(Sender: TObject);
begin
  if (not Assigned(CORE)) or (not CORE.IsActive) then
    raise Exception.Create('DataBase (CORE) not active.');
  try
    CORE.qrySession.Insert;
  except on E: Exception do
    begin
      CORE.qrySession.Cancel;
      Close;
    end;
  end;
end;

procedure TNewSession.FormDestroy(Sender: TObject);
begin
  CORE.qrySession.CheckBrowseMode;
end;

procedure TNewSession.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    // cancel all edits ...
    if CORE.qrySession.State = dsInsert then CORE.qrySession.Cancel;
    Key := 0;
    ModalResult := mrCancel;
  end;
end;

procedure TNewSession.FormShow(Sender: TObject);
var
  dt: TDateTime;
begin
  try
    // calculate a session date and time based on the previous session..
    AutoCalcDateTime;

  finally
    if CanFocus then datePickerSess.SetFocus;
  end;
end;

end.
