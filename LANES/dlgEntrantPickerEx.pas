unit dlgEntrantPickerEx;

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

  TEntrantPickerEx = class(TForm)
    btnClearLane: TButton;
    btnClose: TButton;
    btnDown: TButton;
    btnInject: TButton;
    btnSortLanes: TButton;
    btnToggleName: TButton;
    btnUp: TButton;
    dsQuickPick: TDataSource;
    edtSearch: TEdit;
    Grid: TDBAdvGrid;
    lanegrid: TDBAdvGrid;
    pnlBody: TPanel;
    pnlCntrl: TPanel;
    pnlGrid: TPanel;
    pnlHeader: TPanel;
    pnlLane: TPanel;
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
    procedure btnCloseClick(Sender: TObject);
    procedure btnToggleNameClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
    procedure GridDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure qryQuickPickPBGetText(Sender: TField; var Text: string; DisplayText:
        Boolean);
    procedure qryQuickPickTTBGetText(Sender: TField; var Text: string; DisplayText:
        Boolean);
    procedure GridClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure lanegridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
  private
    fLaneID: integer;
    fToggleNameState: boolean;
    // 6 grid columns containing TriState: unsorted, ascend, descend.
    SortState: Array [0 .. 5] of integer;
    function LocateNomineeID(ANomineeID: Integer; ADataSet: TDataSet): boolean;
    function UpdateEntrantData(): boolean;
  public
    function Prepare(LaneID: Integer): boolean;
  end;

var
  EntrantPickerEx: TEntrantPickerEx;

implementation

{$R *.dfm}

uses uUtility, uEvent, uNominee, uLane, System.Math;

procedure TEntrantPickerEx.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TEntrantPickerEx.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TEntrantPickerEx.btnToggleNameClick(Sender: TObject);
var
  NomineeID: Integer;
begin
  fToggleNameState := not fToggleNameState;
  NomineeID := qryQuickPick.FieldByName('NomineeID').AsInteger;
  LockDrawing;
  grid.BeginUpdate;
  qryQuickPick.DisableControls;
  try
    qryQuickPick.Close;
    qryQuickPick.ParamByName('TOGGLENAME').AsBoolean := fToggleNameState;
    qryQuickPick.Prepare;
    qryQuickPick.Open;
    if (qryQuickPick.Active) then
    begin
      if (NomineeID <> 0) and
      (qryQuickPick.FieldByName('MemberID').AsInteger <> NomineeID) then
        LocateNomineeID(NomineeID, qryQuickPick);
    end;
  finally
    qryQuickPick.EnableControls();
    grid.EndUpdate;
    UnlockDrawing;
  end;
end;

procedure TEntrantPickerEx.edtSearchChange(Sender: TObject);
var
  fs: string;
begin
  if not qryQuickPick.Active then exit;
  fs := '';
  qryQuickPick.DisableControls;
  grid.BeginUpdate;
  LockDrawing;
  try
    // update filter string ....
    if (Length(edtSearch.Text) > 0) then
      fs := '[FName] LIKE ' + QuotedStr('%' + edtSearch.Text + '%');
    // assign filter
    if fs.IsEmpty then
      qryQuickPick.Filtered := false
    else
    begin
      qryQuickPick.Filter := fs;
      if not qryQuickPick.Filtered then
        qryQuickPick.Filtered := true;
    end;

  finally
    qryQuickPick.EnableControls;
    grid.EndUpdate;
    UnlockDrawing;
  end;
end;

procedure TEntrantPickerEx.FormCreate(Sender: TObject);
var
  I: integer;
begin
  fLaneID := 0;
  for I := 0 to Length(SortState)-1 do
    SortState[I] := 0;
end;

procedure TEntrantPickerEx.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CORE.qryLane.CheckBrowseMode;
  if (Key = VK_ESCAPE) then ModalResult := mrCancel;
end;

procedure TEntrantPickerEx.GridCanEditCell(Sender: TObject; ARow, ACol:
    Integer; var CanEdit: Boolean);
begin
  CanEdit := false; // grid is read-only...
end;

procedure TEntrantPickerEx.GridClickCell(Sender: TObject; ARow, ACol: Integer);
var
  G: TDBAdvGrid;
  item: TDBGridColumnItem;
  NomineeID: integer;
begin
  G := TDBAdvGrid(Sender);
  NomineeID := 0;
  if (ARow = 0) then // GRID's HEADER BAR.
  begin
    // Best practise to deal withsorted columns.
    item := G.Columns[ACol];
    if not Assigned(item) then exit;

    LockDrawing;
    grid.BeginUpdate;
    try
      NomineeID := qryQuickPick.FieldByName('NomineeID').AsInteger;

      if (item.FieldName = 'FName') then
      begin
        INC(SortState[ACol]);
        if SortState[ACol] > 2 then SortState[ACol] := 0;
        case SortState[ACol] of
        0:
          qryQuickPick.IndexName := 'idxUnSorted';
        1:
          qryQuickPick.IndexName := 'idxFName';
        2:
          qryQuickPick.IndexName := 'idxFNameDESC';
        end;
      end

      else if (item.FieldName = 'GenderStr') then
      begin
        INC(SortState[ACol]);
        if SortState[ACol]  > 2 then SortState[ACol] := 0;
        case SortState[ACol] of
        0:
          qryQuickPick.IndexName := 'idxUnSorted';
        1:
          qryQuickPick.IndexName := 'idxGender';
        2:
          qryQuickPick.IndexName := 'idxGenderDESC';
        end;
      end

      else if (item.FieldName = 'PB') then
      begin
        INC(SortState[ACol]);
        if SortState[ACol]  > 2 then SortState[ACol] := 0;
        case SortState[ACol] of
        0:
          qryQuickPick.IndexName := 'idxUnSorted';
        1:
          qryQuickPick.IndexName := 'idxPB';
        2:
          qryQuickPick.IndexName := 'idxPBDESC';
        end;
      end

      else if (item.FieldName = 'TTB') then
      begin
        INC(SortState[ACol]);
        if SortState[ACol]  > 2 then SortState[ACol] := 0;
        case SortState[ACol] of
        0:
          qryQuickPick.IndexName := 'idxUnSorted';
        1:
          qryQuickPick.IndexName := 'idxTTB';
        2:
          qryQuickPick.IndexName := 'idxTTBDESC';
        end;
      end

      else if (item.FieldName = 'AGE') then
      begin
        INC(SortState[ACol]);
        if SortState[ACol]  > 2 then SortState[ACol] := 0;
        case SortState[ACol] of
        0:
          qryQuickPick.IndexName := 'idxUnSorted';
        1:
          qryQuickPick.IndexName := 'idxAge';
        2:
          qryQuickPick.IndexName := 'idxAgeDESC';
        end;
      end

      else
        qryQuickPick.IndexName := 'idxUnSorted';

    finally

      if not qryQuickPick.Filtered then qryQuickPick.Filtered := true;

      if (NomineeID <> 0) and
        (qryQuickPick.FieldByName('MemberID').AsInteger <> NomineeID) then
        LocateNomineeID(NomineeID, qryQuickPick);

      grid.EndUpdate;
      UnlockDrawing;
    end;
  end;
end;

procedure TEntrantPickerEx.GridDblClickCell(Sender: TObject; ARow,
  ACol: Integer);
begin
  // place the current selected Nominee into a lane...
end;

procedure TEntrantPickerEx.GridDrawCell(Sender: TObject; ACol, ARow: LongInt;
    Rect: TRect; State: TGridDrawState);
var
  G: TDBAdvGrid;
  item: TDBGridColumnItem;
begin
  G := TDBAdvGrid(Sender);
  if (ARow = 0) then
  begin
    // Best practise to deal withsorted columns.
    item := G.Columns[ACol];

    // Member's name - green member badge.
    if (item.FieldName = 'FName') then
    begin
      IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 28, Rect.top + 4, 1);

      if qryQuickPick.IndexName = 'idxFName' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 9)
      else if qryQuickPick.IndexName = 'idxFNameDESC' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 10)
      else
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 11);
    end

    // Gender M,Y,X - tomatoe red uni-gender symbol
    else if item.FieldName = 'GenderStr' then
    begin
      IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 28, Rect.top + 4, 3);

      if qryQuickPick.IndexName = 'idxGender' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 9)
      else if qryQuickPick.IndexName = 'idxGenderDESC' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 10)
      else
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 11);
    end

    // AGE
    else if item.FieldName = 'AGE' then
    begin
      if qryQuickPick.IndexName = 'idxAge' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 9)
      else if qryQuickPick.IndexName = 'idxAgeDESC' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 10)
      else
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 11);
    end

    // Personal Best
    else if item.FieldName = 'PB' then
    begin
      if qryQuickPick.IndexName = 'idxPB' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 9)
      else if qryQuickPick.IndexName = 'idxPBDESC' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 10)
      else
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 11);
    end

    // TimeTo Beat
    else if item.FieldName = 'TTB' then
    begin
      if qryQuickPick.IndexName = 'idxTTB' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 9)
      else if qryQuickPick.IndexName = 'idxTTBDESC' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 10)
      else
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 11);
    end;

  end;

end;

procedure TEntrantPickerEx.lanegridDrawCell(Sender: TObject; ACol, ARow:
    LongInt; Rect: TRect; State: TGridDrawState);
var
  G: TDBAdvGrid;
  item: TDBGridColumnItem;
begin
  G := TDBAdvGrid(Sender);
  if (ARow = 0) then // GRID's HEADER BAR.
  begin
    // Best practise to deal withsorted columns.
    item := G.Columns[ACol];

    if item.FieldName = 'FullName' then  // Entrant + tick
    begin
      IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 2);
      exit;
    end
  end;
end;

function TEntrantPickerEx.LocateNomineeID(ANomineeID: Integer;
  ADataSet: TDataSet): boolean;
var
  SearchOptions: TLocateOptions;
begin
  SearchOptions := SearchOptions + [loPartialKey];
  try
    result := ADataSet.Locate('NomineeID', ANomineeID, SearchOptions);
  except
    on E: Exception do result := false;
  end;
end;

function TEntrantPickerEx.Prepare(LaneID: Integer): boolean;
begin
  result := false;

  if CORE.qryEvent.IsEmpty then
  begin
    ModalResult := mrCancel;
    Close();
    exit;
  end;

  fLaneID := LaneID;
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
      qryQuickPick.IndexName := 'idxUnSorted';
      if not qryQuickPick.Filtered then qryQuickPick.Filtered := true;
      result := true;
    end;

    qryQuickPick.Filter := '';
    qryQuickPick.Filtered := true;
    qryQuickPick.IndexName := 'idxFName';

  finally
    qryQuickPick.EnableControls;
    Grid.EndUpdate;
    UnlockDrawing;
  end;
end;

procedure TEntrantPickerEx.qryQuickPickPBGetText(Sender: TField; var Text:
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

procedure TEntrantPickerEx.qryQuickPickTTBGetText(Sender: TField; var Text:
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


function TEntrantPickerEx.UpdateEntrantData: boolean;
begin
  {TODO -oBSA -cGeneral : Update Entrant Data....}
end;

end.
