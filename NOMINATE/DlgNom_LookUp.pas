unit DlgNom_LookUp;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.WinXCtrls,
  Vcl.Grids, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  AdvGrid, DBAdvGrid,
  AdvUtil,  AdvObj, BaseGrid,
  dmSCM2, dmCORE, dmIMG, uNominee,
  uEvent;

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
    rpnlFooter: TRelativePanel;
    lblEventNum: TLabel;
    lblCountOfNominees: TLabel;
    lblCount: TLabel;
    qryNom_LookUpDistanceStr: TWideStringField;
    qryNom_LookUpStrokeStr: TWideStringField;
    qryNom_LookUpABREV: TWideStringField;
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
    procedure GridClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure GridGetEditMask(Sender: TObject; ACol, ARow: LongInt; var Value:
        string);
    procedure GridGetEditorType(Sender: TObject; ACol, ARow: Integer; var AEditor:
        TEditorType);
    procedure GridGetEditText(Sender: TObject; ACol, ARow: LongInt; var Value:
        string);
    procedure qryNom_LookUpGetText(Sender: TField; var Text: string;
          DisplayText: Boolean);
    procedure qryNom_LookUpPBSeedTimeSetText(Sender: TField; const Text: string);
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
  // 1. Force the grid to finalize the current cell edit
  Grid.HideInplaceEdit; // harmless if not in edit state.
  // 2. Ensure the underlying dataset is posted.
  qryNom_LookUp.CheckBrowseMode;
  Close();
end;

procedure TNom_Lookup.FormKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrOK;
    // 1. Force the grid to finalize the current cell edit
    Grid.HideInplaceEdit; // harmless if not in edit state.
    // 2. Ensure the underlying dataset is posted.
    qryNom_LookUp.CheckBrowseMode;
    Close;
  end;
end;



procedure TNom_Lookup.GridCanEditCell(Sender: TObject; ARow, ACol: Integer;
  var CanEdit: Boolean);
var
  fld: TField;
  G: TDBAdvGrid;
begin
  G := TDBAdvGrid(Sender);
  CanEdit := false;

  fld := G.FieldAtColumn[Acol];
  if Assigned(fld) then
  begin
     if fld.FieldName = 'PBSeedTime' then
      CanEdit := true
  end;

end;

procedure TNom_Lookup.GridClickCell(Sender: TObject; ARow, ACol: Integer);
var
  G: TDBAdvGrid;
  fld: TField;
begin
  G := TDBAdvGrid(Sender);
  fld := G.FieldAtColumn[ACol];
  if Assigned(fld) then
  begin
    if (ARow >= G.FixedRows) and (fld.FieldName = 'PBSeedTime') then
    begin
      if not (goEditing in G.Options) then
      begin
        G.Options := G.Options - [goRowSelect] + [goEditing];
        G.ShowInplaceEdit; // start editing.
      end;
    end
    else
    begin
      if goEditing in G.Options  then
      begin
        G.HideInplaceEdit; // finish editing.
        G.Options := G.Options - [goEditing] + [goRowSelect];
      end;
    end;
  end;
end;

procedure TNom_Lookup.GridGetEditMask(Sender: TObject; ACol, ARow: LongInt; var
    Value: string);
var
  G: TDBAdvGrid;
  fld: TField;
begin
  G := TDBAdvGrid(Sender);
  fld := G.FieldAtColumn[ACol];
  if Assigned(fld) then
  begin
    if (ARow >= G.FixedRows) and (fld.FieldName = 'PBSeedTime') then
    begin
      Value := '!00:00.000;1;0';
    end;
  end;
end;

procedure TNom_Lookup.GridGetEditorType(Sender: TObject; ACol, ARow: Integer;
    var AEditor: TEditorType);
var
  G: TDBAdvGrid;
  fld: TField;
begin
  G := TDBAdvGrid(Sender);
  fld := G.FieldAtColumn[ACol];
  if Assigned(fld) then
  begin
    if (ARow >= G.FixedRows) then
    begin
      if fld.FieldName = 'PBSeedTime' then AEditor := edNumeric
    end;
  end;
end;

procedure TNom_Lookup.GridGetEditText(Sender: TObject; ACol, ARow: LongInt; var
    Value: string);
var
  Hour, Min, Sec, MSec: word;
  G: TDBAdvGrid;
  dt: TDateTime;
begin
  G := TDBAdvGrid(Sender);
  if (ARow >= G.FixedRows) and (G.Columns[ACol].FieldName = 'PBSeedTime')then
  begin
    // This method FIXES display format issues.
    dt := G.DataSource.DataSet.FieldByName('PBSeedTime').AsDateTime;
    DecodeTime(dt, Hour, Min, Sec, MSec);
    Value := Format('%0:2.2u:%1:2.2u.%2:3.3u', [Min, Sec, MSec]);
  end;
end;


{ TNom_Lookup }

function TNom_Lookup.Prepare(EventID: integer; SortOn: boolean): integer;
var
  EventNum: integer;
  s1, s2: string;
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
  if CORE.qryEvent.IsEmpty or CORE.qryNominee.IsEmpty then
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
          s1 := qryNom_LookUp.FieldByName('DistanceStr').AsString;
          s2 := qryNom_LookUp.FieldByName('StrokeStr').AsString;

          lblEventNum.Caption := 'EVENT #' + IntToStr(EventNum) +
            ' ' + s1 + ' '  + s2;
          lblCount.Caption := IntToStr(qryNom_LookUp.RecordCount);
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

procedure TNom_Lookup.qryNom_LookUpPBSeedTimeSetText(Sender: TField; const
    Text: string);
var
  Min, Sec, MSec: word;
  s: string;
  dt: TDateTime;
  i: integer;
  failed: Boolean;
begin
  s := Text;
  failed := false;

  // Take the user input that was entered into the time mask and replace
  // spaces with '0'. Resulting in a valid TTime string.
  // UnicodeString is '1-based'
  for i := 1 to Length(s) do
  begin
    if (s[i] = ' ') then s[i] := '0';
  end;

  // SubString is '0-based'
  Min := StrToIntDef(s.SubString(0, 2), 0);
  Sec := StrToIntDef(s.SubString(3, 2), 0);
  MSec := StrToIntDef(s.SubString(6, 3), 0);
  try
    begin
      dt := EncodeTime(0, Min, Sec, MSec);
      Sender.AsDateTime := dt;
    end;
  except
    failed := true;
  end;

  if failed then Sender.Clear; // Sets the value of the field to NULL
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
