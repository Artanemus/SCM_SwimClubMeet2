unit dlgABSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ExtCtrls, Vcl.Imaging.jpeg, Vcl.WinXPickers, Vcl.Buttons, uDefines,
  System.DateUtils, System.UITypes;

type
  TABSettings = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Panel2: TPanel;
    btnCancel: TButton;
    btnOk: TButton;
    Panel3: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    lblSeedDepth1: TLabel;
    prefAlgorithm: TRadioGroup;
    prefcalcDefRT: TCheckBox;
    prefcalcDefRTpercent: TSpinEdit;
    prefSeperateGender: TCheckBox;
    prefGroupBy: TRadioGroup;
    prefSeedMethod: TRadioGroup;
    prefSeedDepth: TSpinEdit;
    lblMembersAge: TLabel;
    lblCustomDate: TLabel;
    rgrpMembersAge: TRadioGroup;
    datePickerCustom: TDatePicker;
    btnToday: TButton;
    btnDate: TButton;
    Label2: TLabel;
    Label3: TLabel;
    prefExcludeLanes: TCheckBox;
    prefListOfExcludeLanes: TEdit;
    lblListOfLanes: TLabel;
    lblSeedingDepthAll: TLabel;
    lblBracketMsg: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnDateClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnTodayClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure ReadSettings;
    procedure WriteSettings;

  public
    { Public declarations }
  end;

var
  ABSettings: TABSettings;

implementation

{$R *.dfm}

uses uUtility, uSettings, dlgscmDatePicker;

procedure TABSettings.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TABSettings.btnDateClick(Sender: TObject);
var
  dlg: TscmDatePicker;
  Rect: TRect;
  rtn: TModalResult;
begin
  dlg := TscmDatePicker.Create(Self);
  dlg.Position := poDesigned;
  Rect := btnDate.ClientToScreen(btnDate.ClientRect);
  dlg.Left := Rect.Left;
  dlg.Top := Rect.Bottom + 1;
  dlg.CalendarView1.Date := datePickerCustom.Date;
  rtn := dlg.ShowModal;
  if IsPositiveResult(rtn) then
    datePickerCustom.Date := dlg.CalendarView1.Date;
  dlg.Free;
end;

procedure TABSettings.btnOkClick(Sender: TObject);
begin
  ModalResult := mrYes;
end;

procedure TABSettings.btnTodayClick(Sender: TObject);
begin
  datePickerCustom.Date := Date.Today;
end;

{
 With the exception of 'closed' and 'raced' heats, all heats held in the current event
 will be deleted prior to running auto-build.

 Only members nominated for the current event are considered. Nominees held
 in 'closed' or 'raced' heats are excluded from the 'Entrant Pool'.

 Entrants are given lane placements based on 'TimeToBeat'. This algorithm is
 calculated each time an auto-build is executed.

 The fastest heat is always the last heat. Fastest lanes are the two center
 lanes. Slowest, the two outer lanes.
}

procedure TABSettings.FormCreate(Sender: TObject);
begin
  if not Assigned(Settings) then Close();
  ReadSettings(); // I N I T  L O C A L   U I   P A R A M S .
end;

procedure TABSettings.FormDestroy(Sender: TObject);
begin
  WriteSettings();
end;

procedure TABSettings.FormKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrCancel;
  end;
end;

procedure TABSettings.FormShow(Sender: TObject);
begin
  btnOk.SetFocus;
end;

procedure TABSettings.ReadSettings;
var
  indx: integer;
begin
  prefAlgorithm.ItemIndex := Settings.ttb_algorithmIndx;
  prefcalcDefRT.Checked := Settings.ttb_calcDefRT;
  prefcalcDefRTpercent.Value := Round(Settings.ttb_calcDefRTpercent);

  // Added: 2026.05.09.
  prefExcludeLanes.Checked := Settings.ab_ExcludeLanes;
  prefListOfExcludeLanes.Text := Settings.ab_ListOfExcludeLanes;

  prefGroupBy.ItemIndex := Settings.ab_GroupByIndx;
  prefSeperateGender.Checked := Settings.ab_SeperateGender;
  prefSeedMethod.ItemIndex := Settings.ab_SeedMethodIndx;
  prefSeedDepth.Value := Settings.ab_SeedDepth;

  //  scmSeedDateAuto = (sda31stDECDate, sdaMeetSessionDate, sdaCustomDate);
  case scmSeedDateAuto(Settings.SeedDateAuto) of
    sda31stDECDate: indx := 0; // 31 December of season (Year).
    sdaMeetSessionDate: indx := 1;
    sdaCustomDate: indx := 2;
  else
    indx := -1;
  end;
    rgrpMembersAge.ItemIndex := indx;
end;

procedure TABSettings.WriteSettings();
begin
  Settings.ttb_algorithmIndx := prefAlgorithm.ItemIndex;
  Settings.ttb_calcDefRT := prefcalcDefRT.Checked;
  Settings.ttb_calcDefRTpercent := prefcalcDefRTpercent.Value;

  // Added: 2026.05.09.
  Settings.ab_ExcludeLanes := prefExcludeLanes.Checked;
  Settings.ab_ListOfExcludeLanes := prefListOfExcludeLanes.Text;

  Settings.ab_GroupByIndx := prefGroupBy.ItemIndex;
  Settings.ab_SeperateGender := prefSeperateGender.Checked;
  Settings.ab_SeedMethodIndx := prefSeedMethod.ItemIndex;
  Settings.ab_SeedDepth := prefSeedDepth.Value;

  // scmSeedDateAuto = (sda31stDECDate, sdaMeetSessionDate, sdaCustomDate);
  case rgrpMembersAge.ItemIndex of
  0:
    // 31 December rule. Used by clubs in the southern hemisphere.
    Settings.SeedDateAuto := ORD(scmSeedDateAuto.sda31stDECDate);
  1:
    Settings.SeedDateAuto := ORD(scmSeedDateAuto.sdaMeetSessionDate);
  2:
    Settings.SeedDateAuto := ORD(scmSeedDateAuto.sdaCustomDate);
  else
    Settings.SeedDateAuto := -1;
  end;

end;


end.
