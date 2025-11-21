unit dlgMemberClub;

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
  TItemData = class
  public
    Value: Integer;
    constructor Create(AValue: Integer);
  end;

  TMemberClub = class(TForm)
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
    procedure GridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure qrySwimClubCalcFields(DataSet: TDataSet);
  private
    fSwimClubID: Integer;
  public
    procedure Prepare(ASwimClubID: Integer);
    property SwimClubID: Integer read fSwimClubID write fSwimClubID;
  end;

var
  MemberClub: TMemberClub;

implementation

{$R *.dfm}

constructor TItemData.Create(AValue: Integer);
begin
  Value := AValue;
end;

procedure TMemberClub.btnOkClick(Sender: TObject);
begin
    ModalResult := mrOK
end;

procedure TMemberClub.FormCreate(Sender: TObject);
begin
  fSwimClubID := 0;
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    qrySwimClub.Connection := SCM2.scmConnection
  end
  else
    Close();
end;

procedure TMemberClub.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    ModalResult := mrCancel;
  end;
end;

procedure TMemberClub.GridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect:
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

procedure TMemberClub.Prepare(ASwimClubID: Integer);
var
  idx: Integer;
  itemdata: TItemData;
begin
  qrySwimClub.Open;
  if qrySwimClub.Active then
  begin
  end;
end;

procedure TMemberClub.qrySwimClubCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('IsSelected').AsInteger := 0;
end;

end.
