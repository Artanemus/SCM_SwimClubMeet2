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

  AdvUtil, AdvObj, BaseGrid,  AdvGrid, DBAdvGrid,

  dmSCM2, dmCORE, dmIMG, uDefines, uSettings;
  
type

  TEntrantPicker = class(TForm)
    btnCancel: TButton;
    btnPost: TButton;
    btnToggleName: TButton;
    dsQuickPick: TDataSource;
    Grid: TDBAdvGrid;
    edtSearch: TEdit;
    pnlBody: TPanel;
    pnlCntrl: TPanel;
    pnlGrid: TPanel;
    pnlHeader: TPanel;
    qryQuickPick: TFDQuery;
    qryQuickPickAGE: TIntegerField;
    qryQuickPickEventID: TIntegerField;
    qryQuickPickFName: TWideStringField;
    qryQuickPickGenderID: TIntegerField;
    qryQuickPickGenderStr: TWideStringField;
    qryQuickPickMemberID: TIntegerField;
    qryQuickPickNomineeID: TFDAutoIncField;
    qryQuickPickPB: TTimeField;
    qryQuickPickTTB: TTimeField;
    VirtualImage2: TVirtualImage;
    procedure btnCancelClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure btnToggleNameClick(Sender: TObject);
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
    procedure edtSearchChange(Sender: TObject);
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
begin
  if not qryQuickPick.Active then exit;
  CORE.qryLane.DisableControls;
  CORE.qryNominee.DisableControls;
  try
    begin
      // grid and DB are syncronized.
      aNomineeID := qryQuickPick.FieldByName('NomineeID').AsInteger;
      if (aNomineeID <> 0) then
      begin
        try
          CORE.qryLane.CheckBrowseMode; // finalize DB operations.
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
  aNomineeID: Integer;
begin
  fToggleNameState := not fToggleNameState;
  with dsQuickPick.DataSet as TFDQuery do
  begin
    aNomineeID := FieldByName('NomineeID').AsInteger;
    LockDrawing;
    Grid.BeginUpdate;
    DisableControls;
    try
      Close;
      ParamByName('TOGGLENAME').AsBoolean := fToggleNameState;
      Prepare;
      Open;
      if (Active) then uLane.LocateOnNominee(aNomineeID);
    finally
      EnableControls();
      Grid.EndUpdate;
      UnLockdrawing;
    end;
  end;
end;

procedure TEntrantPicker.FormCreate(Sender: TObject);
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

procedure TEntrantPicker.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then ModalResult := mrCancel;
end;

procedure TEntrantPicker.GridCanEditCell(Sender: TObject; ARow, ACol:
    Integer; var CanEdit: Boolean);
begin
  CanEdit := false; // grid is read-only...
end;

procedure TEntrantPicker.GridDblClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  // GO assign the 'Quick-Picked' Nominee.
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
    // Special considerations...
    case ACol of
      5: // G E N D E R ...
      begin
        case TSortState[ACol] of
        stUnsorted:
          // centered gender icon...
          IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 6, Rect.top + 4, 3);
        stAscend, stDescend:
          // move gender icon to right of sort direction icon.
          IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 26, Rect.top + 4, 3)
        end;
      end;
    end;
  end;
end;

procedure TEntrantPicker.GridFixedCellClick(Sender: TObject; ACol, ARow:
    LongInt);
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

procedure TEntrantPicker.GridGetCellColor(Sender: TObject; ARow, ACol: Integer;
    AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  if ARow = 0 then
  begin
    if TSortState[ACol] in [stAscend, stDescend] then
      ABrush.Color := clWebDarkGoldenRod;
  end;
end;

procedure TEntrantPicker.edtSearchChange(Sender: TObject);
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

function TEntrantPicker.Prepare(LaneID: Integer): boolean;
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
      qryQuickPick.Indexes[10].Selected := true; // idxUnSorted.
      { The InitSortXRef method initializes the current row indexing
          as reference. }
      // Grid.InitSortXRef;
      result := true;
    end;
  finally
    qryQuickPick.EnableControls;
    Grid.EndUpdate;
    UnlockDrawing;
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

procedure TEntrantPicker.SortGrid(aActiveSortCol: Integer);
var
  idx: Integer;
begin
  idx := 10;
  if aActiveSortCol in [0..5] then
  begin
    case aActiveSortCol of
      1: // MEMBER FNAME
        case TSortState[aActiveSortCol] of
          stDescend:
            idx := 0;
          stAscend:
            idx := 1;
        end;
      2: // TTB
        case TSortState[aActiveSortCol] of
          stDescend:
            idx := 2;
          stAscend:
            idx := 3;
        end;
      3: // PB
        case TSortState[aActiveSortCol] of
          stDescend:
            idx := 4;
          stAscend:
            idx := 5;
        end;
      4: // AGE
        case TSortState[aActiveSortCol] of
          stDescend:
            idx := 6;
          stAscend:
            idx := 7;
        end;
      5: // GENDER
        case TSortState[aActiveSortCol] of
          stDescend:
            idx := 8;
          stAscend:
            idx := 9;
        end;
    end;
  end;
  // note aActiveSortCol = 0 ... idx = 10. (UnSorted)
  qryQuickPick.Indexes[idx].Selected := true;
end;

procedure TEntrantPicker.ToogleSortState(indx: integer);
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
