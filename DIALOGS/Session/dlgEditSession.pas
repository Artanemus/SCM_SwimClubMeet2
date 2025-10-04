unit dlgEditSession;

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

  dmCORE, dmIMG,

  uDefines, uSwimClub, uSession, SVGIconImage;

type
  scmSessionMode = (smEditSession, smNewSession, swNotGiven);

  TEditSession = class(TForm)
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
    spbtnAutoDT: TSpeedButton;
    spbtnMinus: TSpeedButton;
    spbtnPlus: TSpeedButton;
    spbtnSchedule: TSpeedButton;
    timePickerSess: TTimePicker;
    spbtnLockState: TSpeedButton;
    lblWeekNumber: TLabel;
    pnlHeader: TPanel;
    spbtnSeasonStart: TSpeedButton;
    lblNominees: TLabel;
    lblEntrants: TLabel;
    lblEvents: TLabel;
    lblWeek: TLabel;
    lblLongDate: TLabel;
    DBTextNominees: TDBText;
    DBTextEntrants: TDBText;
    lblEventCount: TLabel;
    lblWeekCount: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnDateClick(Sender: TObject);
    procedure btnMinusClick(Sender: TObject);
    procedure btnThisHourClick(Sender: TObject);
    procedure btnPlusClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure btnTodayClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure spbtnAutoDTClick(Sender: TObject);
    procedure spbtnLockStateClick(Sender: TObject);
    procedure spbtnScheduleClick(Sender: TObject);
    procedure spbtnSeasonStartClick(Sender: TObject);
    procedure DTPickerSessChange(Sender: TObject);
  end;

var
  EditSession: TEditSession;

implementation

{$R *.dfm}

uses
  System.DateUtils, dlgDatePicker;

procedure TEditSession.btnCancelClick(Sender: TObject);
begin
    if CORE.qrySession.State = dsEdit then CORE.qrySession.Cancel;
    ModalResult := mrCancel;
end;

procedure TEditSession.btnDateClick(Sender: TObject);
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

procedure TEditSession.btnMinusClick(Sender: TObject);
begin
  timePickerSess.time := TDateTime(timePickerSess.time).IncMinute(-15);
end;

procedure TEditSession.btnThisHourClick(Sender: TObject);
var
  DT: TDateTime;
  time: TTime;
begin
  DT := Now;
  TDateTime(time).SetTime(DT.GetHour, 0, 0, 0);
  timePickerSess.Time := time;
end;

procedure TEditSession.btnPlusClick(Sender: TObject);
begin
  timePickerSess.time := TDateTime(timePickerSess.time).IncMinute(15);
end;

procedure TEditSession.btnPostClick(Sender: TObject);
var
  dt: TDateTime;
begin
  if CORE.qrySession.State = dsEdit then
  begin
    try
      dt := datePickerSess.Date + timePickerSess.Time;
      if CORE.qrySession.FieldByName('SessionDT').AsDateTime <> dt then
        CORE.qrySession.FieldByName('SessionDT').AsDateTime := dt;
      CORE.qrySession.FieldByName('ModifiedOn').AsDateTime := Now;
      if CORE.qrySession.FieldByName('SessionStatusID').IsNull then
        CORE.qrySession.FieldByName('SessionStatusID').AsInteger := 1;
      CORE.qrySession.Post; // finalize the changes...
      ModalResult := mrOk;
    except on E: Exception do
      begin
        // ShowMessage('Error saving session: ' + E.Message);
        CORE.qrySession.Cancel;
        ModalResult := mrCancel;
      end;
    end
  end
  else
  begin
    CORE.qrySession.Cancel; // safe....
    ModalResult := mrCancel;
  end;
end;

procedure TEditSession.btnTodayClick(Sender: TObject);
begin
  datePickerSess.Date := Date.Today;
end;

procedure TEditSession.FormCreate(Sender: TObject);
begin
  if (not Assigned(CORE)) or (not CORE.IsActive) then
    raise Exception.Create('DataBase (CORE) not active.');

  if not CORE.qrySession.IsEmpty then Close;

  try
    CORE.qrySession.Edit;

    // re-calculate the stats for this session...
    CORE.qrySession.FieldByName('NomineeCount').AsInteger := uSession.CalcNomineeCount;
    CORE.qrySession.FieldByName('EntrantCount').AsInteger := uSession.CalcEntrantCount;
    lblEventCount.Caption := IntToStr(uSession.CalcEventCount);

  except on E: Exception do
    begin
      CORE.qrySession.Cancel;
      Close;
    end;
  end;
end;

procedure TEditSession.FormDestroy(Sender: TObject);
begin
  CORE.qrySession.CheckBrowseMode;
end;

procedure TEditSession.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    // cancel all edits ...
    if CORE.qrySession.State = dsEdit then CORE.qrySession.Cancel;
    Key := 0;
    ModalResult := mrCancel;
  end;
end;

procedure TEditSession.FormShow(Sender: TObject);
var
  dt: TDateTime;
  WeeksBetween: integer;
begin
    try
      if CORE.qrySession.FieldByName('SessionDT').IsNull then
        dt := Now
      else
        dt := CORE.qrySession.FieldByName('SessionDT').AsDateTime;
      datePickerSess.Date := DateOf(dt);
      timePickerSess.Time := TimeOf(dt);

      if (CORE.qrySession.FieldByName('SessionStatusID').AsInteger = 2) then
        spbtnLockState.ImageName := 'lock'
      else
        spbtnLockState.ImageName := 'lock-open';

      WeeksBetween := uSession.WeeksSinceSeasonStart(datePickerSess.Date);
      lblWeekCount.Caption :=  IntToStr(WeeksBetween);

    finally
      if CanFocus then datePickerSess.SetFocus;
    end;
end;

procedure TEditSession.spbtnAutoDTClick(Sender: TObject);
var
  msg: string;
begin
  msg := '''
    Auto assign a date and time,
    based on the previous session.
    ''';
  MessageBox(0, PChar(msg), PChar('Button ideas ...'),
  MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2);
end;

procedure TEditSession.spbtnScheduleClick(Sender: TObject);
var
  msg: string;
begin
  msg := '''
    Schedule the session.
    (Your changes will be saved.)
    ''';
  MessageBox(0, PChar(msg), PChar('Button ideas ...'),
  MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2);
end;

procedure TEditSession.spbtnSeasonStartClick(Sender: TObject);
var
  msg: string;
begin
  msg := '''
    Adjust the 'start of the swimming season' date.
    (Helpful if the week count isn't correct.)
    ''';
  MessageBox(0, PChar(msg), PChar('Button ideas ...'),
  MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2);
end;

procedure TEditSession.spbtnLockStateClick(Sender: TObject);
var
  msg: string;
  id: integer;
  dt: TDateTime;
begin
  msg := '''
    Answer yes...
    Your changes will be saved, the session will be locked and the dialogue closes.
    (Depending on the visibility settings, the session may no longer appear in the main form.)
    ''';
  id := MessageBox(0, PChar(msg), PChar('LOCK SESSION ...'),
  MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2);

  if (id = IDYES) then
  begin
    if CORE.qrySession.State = dsEdit then
    begin
      try
        dt := datePickerSess.Date + timePickerSess.Time;
        if CORE.qrySession.FieldByName('SessionDT').AsDateTime <> dt then
          CORE.qrySession.FieldByName('SessionDT').AsDateTime := dt;
        CORE.qrySession.FieldByName('ModifiedOn').AsDateTime := Now;
        if CORE.qrySession.FieldByName('SessionStatusID').IsNull then
          CORE.qrySession.FieldByName('SessionStatusID').AsInteger := 2;
        CORE.qrySession.Post; // finalize the changes...
        ModalResult := mrOk;
      except on E: Exception do
        begin
          // ShowMessage('Error saving session: ' + E.Message);
          CORE.qrySession.Cancel;
          ModalResult := mrCancel;
        end;
      end
    end
    else
    begin
      CORE.qrySession.Cancel; // safe....
      ModalResult := mrCancel;
    end;
  end;

end;

procedure TEditSession.DTPickerSessChange(Sender: TObject);
var
  fs: TFormatSettings;
  dt: TDateTime;
  WeeksBetween: integer;
begin
  fs := TFormatSettings.Create; // default local format;
  try
    // header caption.
    dt := DateOf(datePickerSess.Date) + TimeOf(timePickerSess.Time);
    lblLongDate.Caption := FormatDateTime('dddd mmmm yyyy hh:nn', dt, fs);
    // number of weeks since start of the swimmging season.
    WeeksBetween := uSession.WeeksSinceSeasonStart(datePickerSess.Date);
    lblWeekCount.Caption :=  IntToStr(WeeksBetween);
  except on E: Exception do
    lblLongDate.Caption := '';
  end;
end;

end.
