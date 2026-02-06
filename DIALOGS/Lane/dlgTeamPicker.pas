unit dlgTeamPicker;

interface

uses
  Winapi.Windows, Winapi.Messages, 
  
  System.SysUtils, System.Variants, System.Classes, 
  
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.VirtualImage,
  Vcl.ExtCtrls, AdvUtil, Vcl.Grids, 
  
  Data.DB,  
  
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  
  AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmSCM2, dmCORE, dmIMG, uDefines, uSettings;

type

  TTeamPicker = class(TForm)
    pnlHeader: TPanel;
    VirtualImage2: TVirtualImage;
    edtSearch: TEdit;
    pnlBody: TPanel;
    pnlCntrl: TPanel;
    btnCancel: TButton;
    btnPost: TButton;
    btnToggleName: TButton;
    pnlGrid: TPanel;
    Grid: TDBAdvGrid;
    qryQuickPick: TFDQuery;
    dsQuickPick: TDataSource;
    qryQuickPickTeamID: TFDAutoIncField;
    qryQuickPickEventID: TIntegerField;
    qryQuickPickCaption: TWideStringField;
    qryQuickPickTeamName: TWideStringField;
    qryQuickPickABREV: TWideStringField;
    qryQuickPickTTB: TTimeField;
    qryQuickPickPB: TTimeField;
    procedure btnCancelClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure btnToggleNameClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
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
    fActiveSortCol: integer;
    fToggleNameState: boolean;
    // 6 grid columns containing TriState: unsorted, ascend, descend.
    TSortState: Array [0 .. 5] of scmSortState;
    procedure SortGrid(aActiveSortCol: Integer);
    procedure ToogleSortState(indx: integer);
  public
    function Prepare(LaneID: Integer): boolean;
  end;

var
  TeamPicker: TTeamPicker;

implementation

{$R *.dfm}

uses uUtility, uEvent, uNominee, uLane, IniFiles, System.Math;

procedure TTeamPicker.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TTeamPicker.btnPostClick(Sender: TObject);
var
  aTeamID: integer;
begin
  if not qryQuickPick.Active then exit;
  CORE.qryLane.DisableControls;
  CORE.qryTeam.DisableControls;
  try
    begin
      // grid and DB are syncronized.
      aTeamID := qryQuickPick.FieldByName('TeamID').AsInteger;
      if (aTeamID <> 0) then
      begin
        try
          CORE.qryLane.CheckBrowseMode; // finalize DB operations.
          CORE.qryLane.Edit;
          CORE.qryLane.FieldByName('TeamID').AsInteger := aTeamID;
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
    CORE.qryTeam.EnableControls;
    CORE.qryLane.EnableControls;
  end;
end;

procedure TTeamPicker.btnToggleNameClick(Sender: TObject);
var
  aTeamID: Integer;
begin
  fToggleNameState := not fToggleNameState;
  with dsQuickPick.DataSet as TFDQuery do
  begin
    aTeamID := FieldByName('TeamID').AsInteger;
    LockDrawing;
    Grid.BeginUpdate;
    DisableControls;
    try
      Close;
      ParamByName('TOGGLENAME').AsBoolean := fToggleNameState;
      Prepare;
      Open;
      if (Active) then uLane.LocateNominee(aTeamID);
    finally
      EnableControls();
      Grid.EndUpdate;
      UnLockdrawing;
    end;
  end;
end;

procedure TTeamPicker.edtSearchChange(Sender: TObject);
var
  fs: string;
begin
  with dsQuickPick.DataSet do
  begin
    fs := '';
    LockDrawing;
    Grid.BeginUpdate;
    DisableControls;
    try
      // update filter string ....
      if (Length(edtSearch.Text) > 0) then
      begin
        fs := fs + '[FName] LIKE ' + QuotedStr('%' + edtSearch.Text + '%');
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
      Grid.EndUpdate;
      UnLockDrawing;
    end;
  end;
end;

procedure TTeamPicker.FormCreate(Sender: TObject);
begin
  fActiveSortCol := -1;

  // assert connection ?
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    if qryQuickPick.Connection <> SCM2.scmConnection then
      qryQuickPick.Connection := SCM2.scmConnection;
  end
  else
    Close;

  grid.Options := grid.Options + [goRowSelect];
end;


procedure TTeamPicker.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then ModalResult := mrCancel;
end;

procedure TTeamPicker.GridCanEditCell(Sender: TObject; ARow, ACol: Integer; var
    CanEdit: Boolean);
begin
  CanEdit := false; // grid is read-only...
end;

procedure TTeamPicker.GridDblClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  // GO assign the 'Quick-Picked' Nominee.
  if ARow >= TDBAdvGrid(Sender).FixedRows then btnPost.Click;
end;

procedure TTeamPicker.GridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect:
    TRect; State: TGridDrawState);
var
  G: TDBAdvGrid;
begin
  G := TDBAdvGrid(Sender);
  if (ARow = 0) then
  begin
    // Draw an indicator for the ActiveSortCol based on SortState.
    // if SortState = stUnSorted then no sort idicator is drawn.
    if fActiveSortCol = ACol then
    begin
      case TSortState[ACol] of
        stAscend:
          // Sort direction icon  UP.
          IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 1, Rect.top + 4, 4);
        stDescend:
          // Sort direction icon DOWN.
          IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 1, Rect.top + 4, 5);
      end;
    end;
  end;
end;

procedure TTeamPicker.GridFixedCellClick(Sender: TObject; ACol, ARow: LongInt);
begin
  if fActiveSortCol <> ACol  then
  begin
    fActiveSortCol := ACol; // Select col but only toggle on next click...
    TSortState[ACol] := stUnSorted;
  end
  else
  begin
    if ACol <> 0 then // index column always unsorts the grid.
      ToogleSortState(ACol);
  end;
  SortGrid(ACol);
end;

procedure TTeamPicker.GridGetCellColor(Sender: TObject; ARow, ACol: Integer;
    AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  if ARow = 0 then
  begin
    if TSortState[ACol] in [stAscend, stDescend] then
      ABrush.Color := clWebDarkGoldenRod;
  end;
end;

function TTeamPicker.Prepare(LaneID: Integer): boolean;
begin
  result := false;
  fActiveSortCol := -1; // no sorting...
  LockDrawing;
  Grid.BeginUpdate;
  qryQuickPick.DisableControls;
  try
    qryQuickPick.Close();
    qryQuickPick.ParamByName('EVENTID').AsInteger := uEvent.PK;
    qryQuickPick.ParamByName('TOGGLENAME').AsBoolean := fToggleNameState;
    qryQuickPick.Prepare();
    qryQuickPick.Open();
    if (qryQuickPick.Active) then
    begin
      // qryQuickPick.IndexName := 'idxUnsorted';
      qryQuickPick.Indexes[0].Selected := true; // idxUnSorted.
      result := true;
    end;
  finally
    qryQuickPick.EnableControls;
    Grid.EndUpdate;
    UnlockDrawing;
  end;
 end;

procedure TTeamPicker.qryQuickPickPBGetText(Sender: TField; var Text: string;
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

procedure TTeamPicker.qryQuickPickTTBGetText(Sender: TField; var Text: string;
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

procedure TTeamPicker.SortGrid(aActiveSortCol: Integer);
var
  idx: Integer;
begin
  idx := 0; // UnSorted
  if aActiveSortCol in [0..5] then
  begin
    case aActiveSortCol of
      1: // TEAM FNAME
        case TSortState[aActiveSortCol] of
          stDescend:
            idx := 1;
          stAscend:
            idx := 2;
        end;
      2: // TTB
        case TSortState[aActiveSortCol] of
          stDescend:
            idx := 3;
          stAscend:
            idx := 4;
        end;
      3: // PB
        case TSortState[aActiveSortCol] of
          stDescend:
            idx := 5;
          stAscend:
            idx := 5;
        end;
      4: // ABREV
        case TSortState[aActiveSortCol] of
          stDescend:
            idx := 7;
          stAscend:
            idx := 8;
        end;
      5: // CAPTION
        case TSortState[aActiveSortCol] of
          stDescend:
            idx := 9;
          stAscend:
            idx := 10;
        end;
    end;
  end;
  // note aActiveSortCol = -1 ... idx = 10. (UnSorted)
  qryQuickPick.Indexes[idx].Selected := true;
end;

procedure TTeamPicker.ToogleSortState(indx: integer);
begin
  TSortState[indx] := stUnsorted;
  // check bounds
  if indx in [0..5] then
  begin
    case TSortState[indx] of
      stDescend:
        TSortState[indx] := stUnsorted;
      stAscend:
        TSortState[indx] := stDescend;
      stUnSorted:
        TSortState[indx] := stAscend;
    end;
  end;
end;



end.
