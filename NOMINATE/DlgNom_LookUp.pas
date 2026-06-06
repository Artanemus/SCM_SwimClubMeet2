unit DlgNom_LookUp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Vcl.Grids, AdvObj, BaseGrid,
  AdvGrid, DBAdvGrid, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  dmSCM2, dmCORE, dmIMG, uNominee, Vcl.Buttons;

type
  TNom_Lookup = class(TForm)
    pnlBody: TPanel;
    pnlFooter: TPanel;
    btnClose: TButton;
    Grid: TDBAdvGrid;
    qryNom_LookUp: TFDQuery;
    dsNom_LookUp: TDataSource;
    qryNom_LookUpNomineeID: TFDAutoIncField;
    qryNom_LookUpAGE: TIntegerField;
    qryNom_LookUpTTB: TTimeField;
    qryNom_LookUpPB: TTimeField;
    qryNom_LookUpPBSeedTime: TTimeField;
    qryNom_LookUpEventID: TIntegerField;
    qryNom_LookUpMemberID: TIntegerField;
    qryNom_LookUpFName: TWideStringField;
    qryNom_LookUpRecordTime: TTimeField;
    qryNom_LookUpLastName: TWideStringField;
    qryNom_LookUpFirstName: TWideStringField;
    qryNom_LookUpEventNum: TIntegerField;
    spbtnSort: TSpeedButton;
    spbtnEdit: TSpeedButton;
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure qryNom_LookUpGetText(Sender: TField; var Text: string;
        DisplayText: Boolean);
    procedure spbtnSortClick(Sender: TObject);
  private
    { Private declarations }
    fEventID: integer;
    fSortOn: boolean;
  public
    { Public declarations }
    // rtn the number of records found.
    function Prepare(EventID: integer; SortOn: boolean): integer;
    property EventID: integer read FEventID write FEventID;
    property SortOn: boolean read FSortOn write FSortOn;
  end;

var
  Nom_Lookup: TNom_Lookup;

implementation

{$R *.dfm}

procedure TNom_Lookup.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrOK;
  Close();
end;

procedure TNom_Lookup.FormKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrOK;
    Close;
  end;
end;

{ TNom_Lookup }

function TNom_Lookup.Prepare(EventID: integer; SortOn: boolean): integer;
var
  EventNum: integer;
begin
  fEventID := EventID;
  fSortOn := SortOn;
  result := 0;
  if not (Assigned(SCM2) and SCM2.scmConnection.Connected) or
    not (Assigned(CORE) and CORE.IsActive) then
  begin
    Close;
    exit;
  end;
  try
    LockDrawing;
    grid.BeginUpdate;
    try
      qryNom_LookUp.Connection := SCM2.scmConnection;
      qryNom_LookUp.ParamByName('EVENTID').AsInteger := fEventID;
      qryNom_LookUp.ParamByName('SORTON').AsBoolean := fSortOn;
      qryNom_LookUp.Prepare;
      qryNom_LookUp.Open;
      if qryNom_LookUp.Active then
      begin
        if qryNom_LookUp.IsEmpty then
          qryNom_LookUp.Close
        else
        begin
          result := qryNom_LookUp.RecordCount;
          // check for missing metrics...
          if not uNominee.IsMetricsOK(fEventID) then
          begin
            uNominee.RefreshStats(fEventID);
            qryNom_LookUp.Refresh;
            qryNom_LookUp.First;
          end;
          if fSortOn = true then
            qryNom_LookUp.IndexName := 'indxLastName'
          else
            qryNom_LookUp.IndexName := 'indxFirstName';

          EventNum := qryNom_LookUp.FieldByName('EventNum').AsInteger;
          Caption := 'List nominees for event #' + IntToStr(EventNum);

        end;
      end;

    except
      on E: EFDDBEngineException do
      begin
        SCM2.FDGUIxErrorDialog.Execute(E);
        Close;
      end;
    end;
  finally
    grid.EndUpdate;
    UnlockDrawing;
  end;

end;

procedure TNom_Lookup.qryNom_LookUpGetText(Sender: TField; var Text: string;
    DisplayText: Boolean);
var
  Hour, Min, Sec, MSec: word;
begin
  // CALLED BY TimeToBeat AND PersonalBest (Read Only fields)
  // this FIXES display format issues.
  DecodeTime(Sender.AsDateTime, Hour, Min, Sec, MSec);
  // DisplayText is true if the field's value is to be used for display only;
  // false if the string is to be used for editing the field's value.
  // "%" [index ":"] ["-"] [width] ["." prec] type
  if DisplayText then
  begin
    if (Min > 0) then Text := Format('%0:2u:%1:2.2u.%2:3.3u', [Min, Sec, MSec])
    else if ((Min = 0) and (Sec > 0)) then
        Text := Format('%1:2u.%2:3.3u', [Min, Sec, MSec])

    else if ((Min = 0) and (Sec = 0)) then Text := '';
  end
  else Text := Format('%0:2.2u:%1:2.2u.%2:3.3u', [Min, Sec, MSec]);
end;

procedure TNom_Lookup.spbtnSortClick(Sender: TObject);
begin
  fSortOn := not fSortOn;
  LockDrawing;
  grid.BeginUpdate;
  qryNom_LookUp.DisableControls;
  try
    qryNom_LookUp.Close;
      qryNom_LookUp.ParamByName('SORTON').AsBoolean := fSortOn;
      qryNom_LookUp.Prepare;
      qryNom_LookUp.Open;
      if qryNom_LookUp.Active then
      begin
        if fSortOn = true then
          qryNom_LookUp.IndexName := 'indxLastName'
        else
          qryNom_LookUp.IndexName := 'indxFirstName';

        qryNom_LookUp.First;
        if grid.row <> qryNom_LookUp.RecNo then
          grid.row := qryNom_LookUp.RecNo; // row 1.
      end;
  finally
    qryNom_LookUp.DisableControls;
    grid.EndUpdate;
    UnlockDrawing;
  end;
end;


end.
