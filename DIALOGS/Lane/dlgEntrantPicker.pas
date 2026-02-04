unit dlgEntrantPicker;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants,
  System.Classes, System.Actions, System.ImageList,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList,
  Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.VirtualImage, Vcl.BaseImageCollection,
  Vcl.ImageCollection,  Vcl.ImgList, Vcl.VirtualImageList,

  Data.DB,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,


  dmSCM2, dmCORE, dmIMG, uDefines, uSettings, AdvUtil, AdvObj, BaseGrid,
  AdvGrid, DBAdvGrid;

type
  TEntrantPicker = class(TForm)
    Panel1: TPanel;
    btnPost: TButton;
    btnCancel: TButton;
    btnToggleName: TButton;
    Nominate_Edit: TEdit;
    qryQuickPick: TFDQuery;
    qryQuickPickMemberID: TIntegerField;
    qryQuickPickFName: TWideStringField;
    qryQuickPickTTB: TTimeField;
    qryQuickPickPB: TTimeField;
    qryQuickPickAGE: TIntegerField;
    dsQuickPick: TDataSource;
    qryQuickPickEventID: TIntegerField;
    qryQuickPickGenderID: TIntegerField;
    VirtualImage2: TVirtualImage;
    Grid: TDBAdvGrid;
    qryQuickPickNomineeID: TFDAutoIncField;
    pnlHeader: TPanel;
    pnlBody: TPanel;
    pnlCntrl: TPanel;
    pnlGrid: TPanel;
    qryQuickPickGenderStr: TWideStringField;
    procedure btnCancelClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Nominate_EditChange(Sender: TObject);
    procedure btnToggleNameClick(Sender: TObject);
    procedure GridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
    procedure GridCustomCompare(Sender: TObject; str1, str2: string; var Res:
        Integer);
    procedure GridDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure GridFixedCellClick(Sender: TObject; ACol, ARow: LongInt);
    procedure GridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState:
        TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure qryQuickPickPBGetText(Sender: TField; var Text: string; DisplayText:
        Boolean);
    procedure qryQuickPickTTBGetText(Sender: TField; var Text: string; DisplayText:
        Boolean);
  private
    fToggleNameState: boolean;
    FSuccess: boolean;
    ToggleState: Array [0 .. 5] of boolean;  // fwd..rev
    fActiveSortCol: integer;

    procedure UpdateGridTitleBar(ACol: Integer);
    function NormalizeDistanceID(aDistanceID: integer): integer;

  public
    { Public declarations }
    function Prepare(LaneID: Integer): boolean;

    property Success: boolean read FSuccess write FSuccess;

  end;

var
  EntrantPicker: TEntrantPicker;

implementation

{$R *.dfm}

uses uUtility, uEvent, uNominee, uLane, IniFiles, System.Math;

procedure TEntrantPicker.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TEntrantPicker.btnPostClick(Sender: TObject);
var
  aNomineeID: integer;
  s: string;
begin
  if not qryQuickPick.Active then exit;
  CORE.qryLane.DisableControls;
  CORE.qryNominee.DisableControls;
  try
    begin
      s := Grid.UnSortedCells[0, Grid.Row]; // Safe, even if not sorted.
      aNomineeID := StrToIntDef(s, 0);
      if (aNomineeID <> 0) then
      begin
        try
          CORE.qryLane.CheckBrowseMode;
          CORE.qryLane.Edit;
          CORE.qryLane.FieldByName('NomineeID').AsInteger := aNomineeID;
          CORE.qryLane.Post;
          ModalResult := mrOk
        except on E: EFDDBEngineException do
          begin
            CORE.qryLane.Cancel;
            ModalResult := mrCancel;
          end;
        end;
      end;
    end;
  finally
    CORE.qryNominee.EnableControls;
    CORE.qryLane.EnableControls;
  end;
end;

procedure TEntrantPicker.btnToggleNameClick(Sender: TObject);
var
  NomineeID: Integer;
begin
  fToggleNameState := not fToggleNameState;
  with dsQuickPick.DataSet as TFDQuery do
  begin
    NomineeID := FieldByName('NomineeID').AsInteger;
    LockDrawing;
    Grid.BeginUpdate;
    DisableControls;
    try
      Close;
      ParamByName('TOGGLENAME').AsBoolean := fToggleNameState;
      Prepare;
      Open;
      if (Active) then uLane.LocateNominee(NomineeID);
    finally
      EnableControls();
      Grid.EndUpdate;
      UnLockdrawing;
    end;
  end;
end;

procedure TEntrantPicker.FormCreate(Sender: TObject);
var
  iniFileName: String;
  ifile: TIniFile;
  i: Integer;
begin
  FSuccess := false;
  fActiveSortCol := -1;
  // assert connection ?
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
    qryQuickPick.Connection := SCM2.scmConnection
  else
    Close;
end;

procedure TEntrantPicker.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then ModalResult := mrCancel;
end;


procedure TEntrantPicker.Nominate_EditChange(Sender: TObject);
var
  fs: string;
  indx: integer;
begin
  with dsQuickPick.DataSet do
  begin
    fs := '';
    Grid.BeginUpdate;
    DisableControls;
    try
      // update filter string ....
      if (Length(Nominate_Edit.Text) > 0) then
      begin
        fs := fs + '[FName] LIKE ' + QuotedStr('%' + Nominate_Edit.Text + '%');
      end;
      // assign filter
      if fs.IsEmpty then Filtered := false
      else
      begin
        Filter := fs;
        if not Filtered then Filtered := true;
      end;
    finally
      EnableControls;
      Grid.QSort;
      Grid.EndUpdate;
    end;
  end;
end;

function TEntrantPicker.Prepare(LaneID: Integer): boolean;
begin
  result := false;
  fActiveSortCol := -1; // no sorting...
  LockDrawing;
  // Grid.BeginUpdate
  qryQuickPick.DisableControls;
  try
    qryQuickPick.Close();
    qryQuickPick.ParamByName('EVENTID').AsInteger := uEvent.PK;
    qryQuickPick.ParamByName('TOGGLENAME').AsBoolean := fToggleNameState;
    qryQuickPick.Prepare();
    qryQuickPick.Open();
    if (qryQuickPick.Active) then
      result := true;
  finally
    qryQuickPick.EnableControls;
    // Grid.EndUpdate
    UnlockDrawing;
  end;

  // The InitSortXRef method initializes the current row indexing as reference.
  Grid.InitSortXRef;

end;

procedure TEntrantPicker.GridCanEditCell(Sender: TObject; ARow, ACol:
    Integer; var CanEdit: Boolean);
begin
  CanEdit := false;
end;

function ParseRaceTimeStrToMSec(const S: string; out MSec: Double): Boolean;
var
  sTrim, minsPart, secsPart, msPart: string;
  mins, secs, ms: Integer;
  totalMS, hrs, minsR, secsR: Int64;
  dotPos, colonPos: Integer;
  i: Integer;
  digits: string;
begin
  Result := False;
  MSec := 0;
  sTrim := Trim(S);
  if sTrim = '' then Exit;

  // split minutes and seconds by ':' (if present)
  colonPos := Pos(':', sTrim);
  if colonPos > 0 then
  begin
    minsPart := Trim(Copy(sTrim, 1, colonPos-1));
    secsPart := Trim(Copy(sTrim, colonPos+1, MaxInt));
  end
  else
  begin
    // no colon means we treat the whole string as seconds[.ms]
    minsPart := '0';
    secsPart := sTrim;
  end;

  // split seconds and milliseconds by '.' or ','
  dotPos := Pos('.', secsPart);
  if dotPos = 0 then dotPos := Pos(',', secsPart);
  if dotPos > 0 then
  begin
    msPart := Copy(secsPart, dotPos+1, MaxInt);
    secsPart := Copy(secsPart, 1, dotPos-1);
  end
  else
    msPart := '0';

  mins := StrToIntDef(minsPart, -1);
  secs := StrToIntDef(secsPart, -1);
  if (mins < 0) or (secs < 0) then Exit(False);

  // normalise ms to 0..999 (handle 1-3 digits)
  digits := '';
  for i := 1 to Length(msPart) do
    if msPart[i] in ['0'..'9'] then
      digits := digits + msPart[i]
    else
      Break;
  if digits = '' then
    ms := 0
  else if Length(digits) = 1 then
    ms := StrToIntDef(digits, 0) * 100
  else if Length(digits) = 2 then
    ms := StrToIntDef(digits, 0) * 10
  else
    ms := StrToIntDef(Copy(digits, 1, 3), 0);

  // compute total milliseconds
  totalMS := (Int64(mins) * 60 + Int64(secs)) * 1000 + ms;

  if totalMS>0 then
  begin
    Result := true;
    MSec := totalMS;
  end;
end;

procedure TEntrantPicker.GridCustomCompare(Sender: TObject; str1, str2: string;
    var Res: Integer);
var
  T1, T2: Double;
  ok1, ok2: Boolean;
begin
  Res := 0;
  // nn:ss.zzz parsing.
  ok1 := ParseRaceTimeStrToMSec(str1, T1);
  ok2 := ParseRaceTimeStrToMSec(str2, T2);
  if not (ok1 and ok2) then exit;
  if T1 < T2 then Res := -1
  else if T1 = T2 then Res := 0
  else Res := 1;
end;

procedure TEntrantPicker.GridDblClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  if ARow >= TDBAdvGrid(Sender).FixedRows then btnPost.Click;
end;

procedure TEntrantPicker.GridDrawCell(Sender: TObject; ACol, ARow: LongInt;
    Rect: TRect; State: TGridDrawState);
var
  G: TDBAdvGrid;
begin
  G := TDBAdvGrid(Sender);
  if (ARow = 0) then
  begin
    if fActiveSortCol = ACol then
    begin
      if ToggleState[ACol] then
        // Sort direction icon  UP.
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 6, Rect.top + 4, 4)
      else
        // Sort direction icon DOWN.
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 6, Rect.top + 4, 5);
    end;

    case ACol of // Draw icons in the header line of the grid.
      5:
      begin
        if fActiveSortCol = Acol then
        begin
          if ToggleState[ACol] then
            // Gender icon
            IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 30, Rect.top + 4, 3)
          else
            // Gender icon
            IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 30, Rect.top + 4, 3);
        end
        else // centered gender icon...
          IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 6, Rect.top + 4, 3);
      end;
    end;
  end;
end;

procedure TEntrantPicker.GridFixedCellClick(Sender: TObject; ACol, ARow:
    LongInt);
begin
  if fActiveSortCol <> ACol  then
    fActiveSortCol := ACol // Select col but only toggle on next click...
  else
  begin
    ToggleState[ACol] := not ToggleState[ACol]; // toggle the state of ASC or DESC.
    UpdateGridTitleBar(ACol); // redundant?
  end;
end;

procedure TEntrantPicker.GridGetCellColor(Sender: TObject; ARow, ACol: Integer;
    AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  if ARow = 0 then
  begin
    if ToggleState[ACol] then

  end;
end;

procedure TEntrantPicker.qryQuickPickPBGetText(Sender: TField; var Text:
    string; DisplayText: Boolean);
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

procedure TEntrantPicker.qryQuickPickTTBGetText(Sender: TField; var Text:
    string; DisplayText: Boolean);
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


procedure TEntrantPicker.UpdateGridTitleBar(ACol: Integer);
var
  idx: Integer;
  s: string;
begin
  Grid.Columns[0].Header := ' ';
  Grid.Columns[1].Header := 'Nominee';
  Grid.Columns[2].Header := 'TTB';
  Grid.Columns[3].Header := 'PB';
  Grid.Columns[4].Header := 'AGE';
  Grid.Columns[5].Header := 'Gender';

  // This cryptic method works provided all indexes are listed in the
  // correct order and all are active...
  //
  idx := (ACol * 2) + Integer(ToggleState[ACol]);
  qryQuickPick.Indexes[idx].Selected := true;
  if ToggleState[ACol] then s := (#$02C4 + ' ')
  else s := (#$02C5 + ' ');

  Grid.Columns[ACol].Header := s + Grid.Columns[ACol]
    .Header;
end;



end.
