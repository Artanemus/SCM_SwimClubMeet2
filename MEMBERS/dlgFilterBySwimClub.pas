unit dlgFilterBySwimClub;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,
  Data.DB,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.CheckLst,
  Vcl.DBCtrls,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  uDefines, dmSCM2, dmIMG, Vcl.WinXCtrls, AdvUtil, Vcl.Grids, AdvObj, BaseGrid,
  AdvGrid, DBAdvGrid;

type

  TFilterBySwimClub = class(TForm)
    btnOk: TButton;
    dsSwimClub: TDataSource;
    qrySwimClub: TFDQuery;
    pnlBody: TPanel;
    btnSelectNone: TButton;
    btnSelectAll: TButton;
    pnlCNTRL: TRelativePanel;
    Grid: TDBAdvGrid;
    qrySwimClubSwimClubID: TFDAutoIncField;
    qrySwimClubCaption: TWideStringField;
    qrySwimClubLogoImg: TBlobField;
    qrySwimClubIsSelected: TIntegerField;
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure qrySwimClubAfterOpen(DataSet: TDataSet);
  end;

var
  FilterBySwimClub: TFilterBySwimClub;

implementation

{$R *.dfm}

procedure TFilterBySwimClub.btnOkClick(Sender: TObject);
begin
    ModalResult := mrOK
end;

procedure TFilterBySwimClub.FormCreate(Sender: TObject);
begin
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    qrySwimClub.Connection := SCM2.scmConnection;
    qrySwimClub.Open;
    if not qrySwimClub.Active then Close();
  end
  else
    Close();
end;

procedure TFilterBySwimClub.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;
  end;
end;

procedure TFilterBySwimClub.GridClickCell(Sender: TObject; ARow, ACol: Integer);
var
  SelectState: integer;
begin
  if (ARow >= Grid.FixedRows) and (ACol = 1) then
  begin
    // note: IsSelected is InternalCalc field. (In memory)
    SelectState := Grid.DataSource.DataSet.FieldByName('IsSelected').AsInteger;
    SelectState := not SelectState;
    Grid.DataSource.DataSet.FieldByName('IsSelected').AsInteger := SelectState;
  end;
end;

procedure TFilterBySwimClub.GridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect:
    TRect; State: TGridDrawState);
begin
  If not Assigned(IMG) then exit;
  if (ARow >= grid.HeaderRow) then
  begin
    case ACol of
      1:
      begin
        if qrySwimClub.FieldByName('IsSelected').AsInteger = 1 then

        IMG.imglstNomCheckBox.Draw(TDBAdvGrid(Sender).Canvas, Rect.left + 4,
          Rect.top + 4, 1)

        else

        IMG.imglstNomCheckBox.Draw(TDBAdvGrid(Sender).Canvas, Rect.left + 4,
          Rect.top + 4, 0)

      end;
    end;
  end;
end;

procedure TFilterBySwimClub.qrySwimClubAfterOpen(DataSet: TDataSet);
begin
  // Iterate HERE, once, immediately after loading data
  DataSet.First;
  while not DataSet.Eof do
  begin
    DataSet.Edit;
    // a default expression has been defined (1) for field IsSelected
    // and the following line may be redundant.
    DataSet.FieldByName('IsSelected').AsInteger := 1; // Set default
    DataSet.Post;
    DataSet.Next;
  end;
  // Reset cursor to top
  DataSet.First;
end;




end.
