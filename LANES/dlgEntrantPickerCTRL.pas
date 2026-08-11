unit dlgEntrantPickerCTRL;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Actions,
  System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  Vcl.BaseImageCollection, Vcl.ImageCollection, Vcl.VirtualImage,
  Vcl.ExtCtrls, vcl.Themes,
  Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,


  dmSCM2, dmCORE, dmIMG, uDefines, uEvent, AdvUtil, AdvObj, BaseGrid, AdvGrid,
  DBAdvGrid,
  uSettings, uSession, uAgeOfSwimmer, uNominee;


type
  TEntrantPickerCTRL = class(TForm)
    btnCancel: TButton;
    btnPost: TButton;
    btnToggleName: TButton;
    dsQuickPickCtrl: TDataSource;
    edtSearch: TEdit;
    Grid: TDBAdvGrid;
    pnlBody: TPanel;
    pnlBorder: TPanel;
    pnlCntrl: TPanel;
    pnlGrid: TPanel;
    pnlHeader: TPanel;
    qryQuickPickCtrl: TFDQuery;
    qryQuickPickCtrlAge: TIntegerField;
    qryQuickPickCtrlFName: TWideStringField;
    qryQuickPickCtrlGenderID: TIntegerField;
    qryQuickPickCtrlGenderStr: TWideStringField;
    qryQuickPickCtrlMemberID: TFDAutoIncField;
    qryQuickPickCtrlPB: TTimeField;
    VirtualImage2: TVirtualImage;
    procedure btnCancelClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure btnToggleNameClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure GridDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure qryQuickPickCtrlPBGetText(Sender: TField; var Text: string;
        DisplayText: Boolean);
  private
    fLaneID: Integer;
    { Private declarations }
    fToggleNameState: boolean;
    SortState: Array [0 .. 4] of integer;
    function GetSeedDate: TDateTime;
    function LocateMemberID(AMemberID: Integer; ADataSet: TDataSet): boolean;
    function UpdateEntrantData(): boolean;
  public
    { Public declarations }
    function Prepare(LaneID: Integer): boolean;
  end;

var
  EntrantPickerCTRL: TEntrantPickerCTRL;

implementation

{$R *.dfm}

uses uUtility, System.IniFiles;

{ TEntrantPickerCTRL }


procedure TEntrantPickerCTRL.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TEntrantPickerCTRL.btnPostClick(Sender: TObject);
begin
  if not qryQuickPickCtrl.Active then exit;
  if UpdateEntrantData then
  ModalResult := mrOk else ModalResult := mrCancel;
end;

procedure TEntrantPickerCTRL.btnToggleNameClick(Sender: TObject);
var
  MemberID: Integer;
begin
  fToggleNameState := not fToggleNameState;

  MemberID := qryQuickPickCtrl.FieldByName('MemberID').AsInteger;
  LockDrawing;
  grid.BeginUpdate;
  qryQuickPickCtrl.DisableControls;
  try
    qryQuickPickCtrl.Close;
    qryQuickPickCtrl.ParamByName('TOGGLENAME').AsBoolean := fToggleNameState;
    qryQuickPickCtrl.Prepare;
    qryQuickPickCtrl.Open;
    if (qryQuickPickCtrl.Active) then
    begin
      if (MemberID <> 0) and
      (qryQuickPickCtrl.FieldByName('MemberID').AsInteger <> MemberID) then
        LocateMemberID(MemberID, qryQuickPickCtrl);
    end;
  finally
    qryQuickPickCtrl.EnableControls();
    grid.EndUpdate;
    UnlockDrawing;
  end;
end;

procedure TEntrantPickerCTRL.edtSearchChange(Sender: TObject);
var
  fs: string;
begin
  if not qryQuickPickCtrl.Active then exit;

  fs := '';
  qryQuickPickCtrl.DisableControls;
  grid.BeginUpdate;
  LockDrawing;
  try
    // update filter string ....
    if (Length(edtSearch.Text) > 0) then
      fs := '[FName] LIKE ' + QuotedStr('%' + edtSearch.Text + '%');
    // assign filter
    if fs.IsEmpty then
      qryQuickPickCtrl.Filtered := false
    else
    begin
      qryQuickPickCtrl.Filter := fs;
      if not qryQuickPickCtrl.Filtered then
        qryQuickPickCtrl.Filtered := true;
    end;

  finally
    qryQuickPickCtrl.EnableControls;
    grid.EndUpdate;
    UnlockDrawing;
  end;

end;

procedure TEntrantPickerCTRL.FormCreate(Sender: TObject);
var
  I: integer;
begin
  fLaneID := 0;
  for I := 0 to Length(SortState)-1 do
    SortState[I] := 0;
end;

procedure TEntrantPickerCTRL.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then ModalResult := mrCancel;
end;

function TEntrantPickerCTRL.GetSeedDate(): TDateTime;
var
  SeedDate: TDateTime;
begin
  result := Date;
  seeddate := 0;
  if Assigned(Settings) then
  begin
    case Settings.ab_SeedMethodIndx of
    0:
      SeedDate := uAgeOfSwimmer.Get31stDECDate;
    1:
      SeedDate := uSession.SessionDT;
    2:
      begin
         if (Settings.CustomSeedDate <> 0) then
          SeedDate := Settings.CustomSeedDate;
      end;
    end;
  end;
  if SeedDate <> 0 then
  result := SeedDate;
end;

procedure TEntrantPickerCTRL.GridClickCell(Sender: TObject; ARow, ACol:
    Integer);
var
  G: TDBAdvGrid;
  item: TDBGridColumnItem;
  MemberID: integer;
begin
  G := TDBAdvGrid(Sender);
  MemberID := 0;
  if (ARow = 0) then // GRID's HEADER BAR.
  begin
    // Best practise to deal withsorted columns.
    item := G.Columns[ACol];
    if not Assigned(item) then exit;

    LockDrawing;
    grid.BeginUpdate;
    try
      MemberID := qryQuickPickCtrl.FieldByName('MemberID').AsInteger;


      if (item.FieldName = 'FName') then
      begin
        INC(SortState[ACol]);
        if SortState[ACol] > 2 then SortState[ACol] := 0;
        case SortState[ACol] of
        0:
          qryQuickPickCtrl.IndexName := 'idxUnSorted';
        1:
          qryQuickPickCtrl.IndexName := 'idxFName';
        2:
          qryQuickPickCtrl.IndexName := 'idxFNameDESC';
        end;
      end

      else if (item.FieldName = 'GenderStr') then
      begin
        INC(SortState[ACol]);
        if SortState[ACol]  > 2 then SortState[ACol] := 0;
        case SortState[ACol] of
        0:
          qryQuickPickCtrl.IndexName := 'idxUnSorted';
        1:
          qryQuickPickCtrl.IndexName := 'idxGender';
        2:
          qryQuickPickCtrl.IndexName := 'idxGenderDESC';
        end;
      end

      else if (item.FieldName = 'PB') then
      begin
        INC(SortState[ACol]);
        if SortState[ACol]  > 2 then SortState[ACol] := 0;
        case SortState[ACol] of
        0:
          qryQuickPickCtrl.IndexName := 'idxUnSorted';
        1:
          qryQuickPickCtrl.IndexName := 'idxPB';
        2:
          qryQuickPickCtrl.IndexName := 'idxPBDESC';
        end;
      end

      else if (item.FieldName = 'AGE') then
      begin
        INC(SortState[ACol]);
        if SortState[ACol]  > 2 then SortState[ACol] := 0;
        case SortState[ACol] of
        0:
          qryQuickPickCtrl.IndexName := 'idxUnSorted';
        1:
          qryQuickPickCtrl.IndexName := 'idxAge';
        2:
          qryQuickPickCtrl.IndexName := 'idxAgeDESC';
        end;
      end

      else
        qryQuickPickCtrl.IndexName := 'idxUnSorted';

    finally

      if not qryQuickPickCtrl.Filtered then qryQuickPickCtrl.Filtered := true;

      if (MemberID <> 0) and
        (qryQuickPickCtrl.FieldByName('MemberID').AsInteger <> MemberID) then
        LocateMemberID(MemberID, qryQuickPickCtrl);

      grid.EndUpdate;
      UnlockDrawing;
    end;


  end;

end;

procedure TEntrantPickerCTRL.GridDblClickCell(Sender: TObject; ARow, ACol:
    Integer);
begin
  // GO assign the 'Quick-Picked' Nominee.
  if ARow >= TDBAdvGrid(Sender).FixedRows then btnPost.Click;
end;

procedure TEntrantPickerCTRL.GridDrawCell(Sender: TObject; ACol, ARow: LongInt;
    Rect: TRect; State: TGridDrawState);
var
  G: TDBAdvGrid;
  item: TDBGridColumnItem;
begin
  G := TDBAdvGrid(Sender);
  if (ARow = 0) then // GRID's HEADER BAR.
  begin
    // Best practise to deal withsorted columns.
    item := G.Columns[ACol];

    // Member's name - green member badge.
    if (item.FieldName = 'FName') then
    begin
      IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 28, Rect.top + 4, 8);

      if qryQuickPickCtrl.IndexName = 'idxFName' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 9)
      else if qryQuickPickCtrl.IndexName = 'idxFNameDESC' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 10)
      else
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 11);
    end

    // Gender M,Y,X - tomatoe red uni-gender symbol
    else if item.FieldName = 'GenderStr' then
    begin
      IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 28, Rect.top + 4, 3);

      if qryQuickPickCtrl.IndexName = 'idxGender' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 9)
      else if qryQuickPickCtrl.IndexName = 'idxGenderDESC' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 10)
      else
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 11);
    end

    // AGE
    else if item.FieldName = 'AGE' then
    begin
      if qryQuickPickCtrl.IndexName = 'idxAge' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 9)
      else if qryQuickPickCtrl.IndexName = 'idxAgeDESC' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 10)
      else
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 11);

    end

    // Personal Best
    else if item.FieldName = 'PB' then
    begin
      if qryQuickPickCtrl.IndexName = 'idxPB' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 9)
      else if qryQuickPickCtrl.IndexName = 'idxPBDESC' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 10)
      else
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 11);

    end;

  end;
end;

function TEntrantPickerCTRL.LocateMemberID(AMemberID: Integer;
  ADataSet: TDataSet): boolean;
var
  SearchOptions: TLocateOptions;
begin
  SearchOptions := SearchOptions + [loPartialKey];
  try
    result := ADataSet.Locate('MemberID', AMemberID, SearchOptions);
  except
    on E: Exception do result := false;
  end;
end;

function TEntrantPickerCTRL.Prepare(LaneID: Integer): boolean;
begin
  result := false;
  fLaneID := LaneID;
  LockDrawing;
  Grid.BeginUpdate;
  qryQuickPickCtrl.DisableControls;
  try
    qryQuickPickCtrl.Close();
    qryQuickPickCtrl.ParamByName('EVENTID').AsInteger := uEvent.PK;
    qryQuickPickCtrl.ParamByName('TOGGLENAME').AsBoolean := fToggleNameState;
    qryQuickPickCtrl.ParamByName('SEEDDATE').AsDateTime := GetSeedDate();
    qryQuickPickCtrl.Prepare();
    qryQuickPickCtrl.Open();

    if (qryQuickPickCtrl.Active) then
    begin
      qryQuickPickCtrl.IndexName := 'idxUnSorted';
      if not qryQuickPickCtrl.Filtered then qryQuickPickCtrl.Filtered := true;
      result := true;
    end;

    qryQuickPickCtrl.Filter := '';
    qryQuickPickCtrl.Filtered := true;
    qryQuickPickCtrl.IndexName := 'idxFName';

  finally
    qryQuickPickCtrl.EnableControls;
    Grid.EndUpdate;
    UnlockDrawing;
  end;
end;

procedure TEntrantPickerCTRL.qryQuickPickCtrlPBGetText(Sender: TField; var
    Text: string; DisplayText: Boolean);
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

function TEntrantPickerCTRL.UpdateEntrantData: boolean;
var
  NomineeID: integer;
  MemberID: integer;
begin
  result := false;
  if not qryQuickPickCtrl.Active then
  begin
    ModalResult := mrCancel;
    exit;
  end;

  CORE.qryLane.DisableControls;
  CORE.qryNominee.DisableControls;
  try
    // U P D A T E   N O M I N A T I O N S .
    begin
      MemberID := qryQuickPickCtrl.FieldByName('MemberID').AsInteger;
      NomineeID := uNominee.NewNominee(MemberID, uEvent.PK);

      // U P D A T E   L A N E   D A T A .
      if (NomineeID <> 0) then
      begin
        try
          CORE.qryLane.CheckBrowseMode; // finalize DB operations.
          CORE.qryLane.Edit;
          CORE.qryLane.FieldByName('NomineeID').AsInteger := NomineeID;
          CORE.qryLane.Post;
          ModalResult := mrOk;
          result := true;
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



end.
