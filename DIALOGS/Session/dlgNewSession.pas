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

  dmCORE, dmIMG,

  uDefines, uSwimClub, uSession;

type
  scmSessionMode = (smEditSession, smNewSession, swNotGiven);

  TNewSession = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnPost: TButton;
    timePickerSess: TTimePicker;
    DBEdit1: TDBEdit;
    btnToday: TButton;
    btnDate: TButton;
    datePickerSess: TDatePicker;
    btnNow: TButton;
    spbtnPlus: TSpeedButton;
    spbtnMinus: TSpeedButton;
    spbtnAutoDT: TSpeedButton;
    spbtnNew: TSpeedButton;
    spbtnSchedule: TSpeedButton;
    procedure FormDestroy(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDateClick(Sender: TObject);
    procedure btnMinusClick(Sender: TObject);
    procedure btnNowClick(Sender: TObject);
    procedure btnPlusClick(Sender: TObject);
    procedure btnTodayClick(Sender: TObject);
    procedure spbtnAutoDTClick(Sender: TObject);
    procedure spbtnScheduleClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditSession: TNewSession;

implementation

{$R *.dfm}

uses
  System.DateUtils, dlgDatePicker;

procedure TNewSession.FormDestroy(Sender: TObject);
begin
  CORE.qrySession.CheckBrowseMode;
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
  TDateTime(timePickerSess.time).IncMinute(-15);
end;

procedure TNewSession.btnNowClick(Sender: TObject);
begin
  TDateTime(timePickerSess.Time).SetTime(Now().GetHour(), 0, 0, 0);
end;

procedure TNewSession.btnPlusClick(Sender: TObject);
begin
  TDateTime(timePickerSess.time).IncMinute(15);
end;

procedure TNewSession.btnPostClick(Sender: TObject);
var
  dt: TDateTime;
begin
  if CORE.qrySession.State = dsInsert then
  begin
    try
      dt := datePickerSess.Date + timePickerSess.Time;
      if CORE.qrySession.FieldByName('SessionStart').AsDateTime <> dt then
        CORE.qrySession.FieldByName('SessionStart').AsDateTime := dt;

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
  if not CORE.qrySession.IsEmpty then Close;
  try
    CORE.qrySession.Insert;
  except on E: Exception do
    begin
      CORE.qrySession.Cancel;
      Close;
    end;
  end;

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
    if CORE.qrySession.FieldByName('StartDT').IsNull then
      dt := Now
    else
      dt := CORE.qrySession.FieldByName('StartDT').AsDateTime;

    datePickerSess.Date := DateOf(dt);
    timePickerSess.Time := TimeOf(dt);
    if CanFocus then datePickerSess.SetFocus;
end;

procedure TNewSession.spbtnAutoDTClick(Sender: TObject);
var
  msg: string;
begin
  msg := '''
    Auto assign date and time
    based on the previous session.
    ''';
  MessageBox(0, PChar(msg), PChar('AutoBuild Session Details...'),
  MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2);
end;

procedure TNewSession.spbtnScheduleClick(Sender: TObject);
var
  msg: string;
begin
  msg := '''
    Save changes and run the schedule package.
    ''';
  MessageBox(0, PChar(msg), PChar('Schedule Session...'),
  MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2);
end;

end.
