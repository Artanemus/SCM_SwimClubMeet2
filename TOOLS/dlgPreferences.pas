unit dlgPreferences;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes, System.DateUtils,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  Data.DB,

  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Samples.Spin, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.ExtDlgs, Vcl.WinXCtrls, Vcl.WinXPickers,

  dmSCM2, uSettings, uDefines

  ;

type
  TPreferences = class(TForm)
    btn1: TSpeedButton;
    btnClose: TButton;
    Label7: TLabel;
    Label8: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lblSeedDepth1: TLabel;
    lblSeedDepth2: TLabel;
    PageControl1: TPageControl;
    Panel2: TPanel;
    prefEnableDQcodes: TCheckBox;
    prefExcludeOutsideLanes: TCheckBox;
    prefGroupBy: TRadioGroup;
    prefAlgorithm: TRadioGroup;
    prefcalcDefRTpercent: TSpinEdit;
    prefSeperateGender: TCheckBox;
    prefShowDebugInfo: TCheckBox;
    prefcalcDefRT: TCheckBox;
    prefSeedMethod: TRadioGroup;
    prefSeedDepth: TSpinEdit;
    tab1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    prefMemberChartDataPoints: TEdit;
    Label19: TLabel;
    Label20: TLabel;
    lbl1: TLabel;
    lblMembersAge: TLabel;
    rgrpMembersAge: TRadioGroup;
    lblCustomDate: TLabel;
    datePickerCustom: TDatePicker;
    btnToday: TButton;
    btnDate: TButton;
    spbtnMembersAge: TSpeedButton;
    BalloonHintPreferences: TBalloonHint;
    procedure btnCloseClick(Sender: TObject);
    procedure btnDateClick(Sender: TObject);
    procedure btnTodayClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure spbtnMembersAgeMouseLeave(Sender: TObject);
  private
    procedure ReadPreferences();
    procedure WritePreferences();
  public
  end;

var
  Preferences: TPreferences;

implementation

{$R *.dfm}

uses uUtility, System.UITypes, dlgscmDatePicker;


procedure TPreferences.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TPreferences.btnDateClick(Sender: TObject);
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

procedure TPreferences.btnTodayClick(Sender: TObject);
begin
  datePickerCustom.Date := Date.Today;
end;

procedure TPreferences.FormCreate(Sender: TObject);
begin
  if not Assigned(Settings) then Close();
  // I N I T  L O C A L   U I   P A R A M S .
  PageControl1.TabIndex := 0;
  ReadPreferences();
end;

procedure TPreferences.FormDestroy(Sender: TObject);
begin
  // w r i t e   p r e f e r e n c e s .
  if Assigned(Settings) then
    WritePreferences();
end;

procedure TPreferences.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_escape then
  begin
    // note: all database changes are saved.
    Key := 0;
    ModalResult := mrOK;
  end;
end;

procedure TPreferences.ReadPreferences();
var
  indx: integer;
begin
  prefAlgorithm.ItemIndex := Settings.ttb_algorithmIndx;
  prefcalcDefRT.Checked := Settings.ttb_calcDefRT;
  prefcalcDefRTpercent.Value := Round(Settings.ttb_calcDefRTpercent);
  prefExcludeOutsideLanes.Checked := Settings.ab_ExcludeOutsideLanes;
  prefGroupBy.ItemIndex := Settings.ab_GroupByIndx;
  prefSeperateGender.Checked := Settings.ab_SeperateGender;
  prefSeedMethod.ItemIndex := Settings.ab_SeedMethodIndx;
  prefSeedDepth.Value := Settings.ab_SeedDepth;
  prefShowDebugInfo.Checked := Settings.ShowDebugInfo;
  prefEnableDQcodes.Checked := Settings.EnableDQcodes;
  prefMemberChartDataPoints.Text := FloatToStr(Settings.MemberChartDataPoints);

  // scmSeedDateAuto = (sdaTodaysDate, sdaSessionDate, sdaStartOfSeason, sdaCustomDate, sdaMeetDate);
  case scmSeedDateAuto(Settings.SeedDateAuto) of
    sdaTodaysDate: indx := 3;
    sdaSessionDate: indx := 2;
    sdaStartOfSeason: indx := 0;
    sdaCustomDate: indx := 4;
    sdaMeetDate: indx := 1;
  else
    indx := -1;
  end;
    rgrpMembersAge.ItemIndex := indx;

end;

procedure TPreferences.spbtnMembersAgeMouseLeave(Sender: TObject);
begin
  BalloonHintPreferences.HideHint;
end;

procedure TPreferences.WritePreferences();
var
  i: integer;
begin
  Settings.ttb_algorithmIndx := prefAlgorithm.ItemIndex;
  Settings.ttb_calcDefRT := prefcalcDefRT.Checked;
  Settings.ttb_calcDefRTpercent := prefcalcDefRTpercent.Value;
  Settings.ab_ExcludeOutsideLanes := prefExcludeOutsideLanes.Checked;
  Settings.ab_GroupByIndx := prefGroupBy.ItemIndex;
  Settings.ab_SeperateGender := prefSeperateGender.Checked;
  Settings.ab_SeedMethodIndx := prefSeedMethod.ItemIndex;
  Settings.ab_SeedDepth := prefSeedDepth.Value;
  Settings.ShowDebugInfo := prefShowDebugInfo.Checked;

  // scmSeedDateAuto = (sdaTodaysDate, sdaSessionDate, sdaStartOfSeason, sdaCustomDate, sdaMeetDate);

  if rgrpMembersAge.ItemIndex > -1 then
  begin
    case rgrpMembersAge.ItemIndex of
    0:
      Settings.SeedDateAuto := ORD(scmSeedDateAuto.sdaStartOfSeason);
    1:
      Settings.SeedDateAuto := ORD(scmSeedDateAuto.sdaMeetDate);
    2:
      Settings.SeedDateAuto := ORD(scmSeedDateAuto.sdaSessionDate);
    3:
      Settings.SeedDateAuto := ORD(scmSeedDateAuto.sdaTodaysDate);
    4:
      Settings.SeedDateAuto := ORD(scmSeedDateAuto.sdaCustomDate);

    end;
  end;

  try
    i := Round(StrToFloatDef(prefMemberChartDataPoints.Text, 0));
  except
    on E: Exception do i := 26;
  end;
  if (i < 10) then i := 10;
  if (i > 1000) then i := 1000;

  Settings.MemberChartDataPoints := i;

end;

end.
