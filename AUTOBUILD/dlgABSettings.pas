unit dlgABSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ExtCtrls, Vcl.Imaging.jpeg, Vcl.WinXPickers, Vcl.Buttons, uDefines;

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
    prefExcludeOutsideLanes: TCheckBox;
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
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
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

uses uUtility, uSettings;

procedure TABSettings.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TABSettings.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
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
  prefExcludeOutsideLanes.Checked := Settings.ab_ExcludeOutsideLanes;
  prefGroupBy.ItemIndex := Settings.ab_GroupByIndx;
  prefSeperateGender.Checked := Settings.ab_SeperateGender;
  prefSeedMethod.ItemIndex := Settings.ab_SeedMethodIndx;
  prefSeedDepth.Value := Settings.ab_SeedDepth;

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

procedure TABSettings.WriteSettings();
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

end;


end.
