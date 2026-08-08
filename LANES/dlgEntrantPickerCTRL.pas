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
    dsQuickPickCtrl: TDataSource;
    qryQuickPickCtrl: TFDQuery;
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
    qryQuickPickCtrlMemberID: TFDAutoIncField;
    qryQuickPickCtrlGenderID: TIntegerField;
    qryQuickPickCtrlGenderStr: TWideStringField;
    qryQuickPickCtrlFName: TWideStringField;
    qryQuickPickCtrlPB: TTimeField;
    qryQuickPickCtrlAge: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnPostClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnToggleNameClick(Sender: TObject);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure edtSearchChange(Sender: TObject);
    procedure GridClickCell(Sender: TObject; ARow, ACol: Integer);
  private
    { Private declarations }
    fToggleNameState: boolean;
    fLaneID: Integer;
    SortState: Array [0 .. 4] of integer;

    function UpdateEntrantData(): boolean;
    function LocateMemberID(AMemberID: Integer; ADataSet: TDataSet): boolean;
    function GetSeedDate: TDateTime;


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
  with dsQuickPickCtrl.DataSet as TFDQuery do
  begin
    MemberID := FieldByName('MemberID').AsInteger;
    DisableControls;
    Close;
    ParamByName('TOGGLENAME').AsBoolean := fToggleNameState;
    Prepare;
    Open;
    if (Active) then LocateMemberID(MemberID, dsQuickPickCtrl.DataSet);
    EnableControls();
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
          qryQuickPickCtrl.IndexName := 'idxMemberFName';
        2:
          qryQuickPickCtrl.IndexName := 'idxMemberFNameDESC';
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

      if qryQuickPickCtrl.FieldByName('MemberID').AsInteger <> MemberID then
        LocateMemberID(MemberID, qryQuickPickCtrl);

      grid.EndUpdate;
      UnlockDrawing;
    end;


  end;

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
      IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 8);

      if qryQuickPickCtrl.IndexName = 'idxMemberFName' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 28, Rect.top + 4, 9)
      else if qryQuickPickCtrl.IndexName = 'idxMemberFNameDESC' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 28, Rect.top + 4, 10);
    end

    // Gender M,Y,X - tomatoe red uni-gender symbol
    else if item.FieldName = 'GenderStr' then
    begin
      IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 3);

      if qryQuickPickCtrl.IndexName = 'idxGender' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 28, Rect.top + 4, 9)
      else if qryQuickPickCtrl.IndexName = 'idxGenderDESC' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 28, Rect.top + 4, 10);
    end

    // AGE
    else if item.FieldName = 'AGE' then
    begin
      if qryQuickPickCtrl.IndexName = 'idxAge' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 9)
      else if qryQuickPickCtrl.IndexName = 'idxAgeDESC' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 10);
    end

    // Personal Best
    else if item.FieldName = 'PB' then
    begin
      if qryQuickPickCtrl.IndexName = 'idxPB' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 9)
      else if qryQuickPickCtrl.IndexName = 'idxPBDESC' then
        IMG.imglstLaneCell.Draw(G.Canvas, Rect.left + 2, Rect.top + 4, 10);
    end;

  end;
end;


function TEntrantPickerCTRL.Prepare(LaneID: Integer): boolean;
begin
  result := false;
  LockDrawing;
  // Grid.BeginUpdate
  qryQuickPickCtrl.DisableControls;
  try
    qryQuickPickCtrl.Close();
    qryQuickPickCtrl.ParamByName('EVENTID').AsInteger := uEvent.PK;
    qryQuickPickCtrl.ParamByName('TOGGLENAME').AsBoolean := fToggleNameState;
    qryQuickPickCtrl.ParamByName('SEEDATE').AsDateTime := GetSeedDate();
    qryQuickPickCtrl.Prepare();
    qryQuickPickCtrl.Open();


    if (qryQuickPickCtrl.Active) then
    begin
      qryQuickPickCtrl.IndexName := 'idxUnSorted';
      if not qryQuickPickCtrl.Filtered then qryQuickPickCtrl.Filtered := true;
      result := true;
    end;

  finally
    qryQuickPickCtrl.EnableControls;
    // Grid.EndUpdate
    UnlockDrawing;
  end;
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
