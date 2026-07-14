unit dlgDivisions;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,

  Vcl.Graphics, Vcl.StdCtrls,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, AdvUtil,
  Vcl.Grids,

  Data.DB,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmCORE,
  dmIMG, dmSCM2;

type
  TDivisions = class(TForm)
    pnlHeader: TPanel;
    pnlBody: TPanel;
    pnlFooter: TPanel;
    tcDivision: TTabControl;
    Grid: TDBAdvGrid;
    lblHeader: TLabel;
    qryDivision: TFDQuery;
    qryDivisionDivisionID: TFDAutoIncField;
    qryDivisionCaption: TWideStringField;
    qryDivisionAgeFrom: TIntegerField;
    qryDivisionAgeTo: TIntegerField;
    qryDivisionGenderID: TIntegerField;
    dsDivision: TDataSource;
    btnOk: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure qryDivisionNewRecord(DataSet: TDataSet);
    procedure tcDivisionChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Divisions: TDivisions;

implementation

{$R *.dfm}

procedure TDivisions.btnOkClick(Sender: TObject);
begin
  qryDivision.CheckBrowseMode;
  Close;
end;

procedure TDivisions.FormCreate(Sender: TObject);
begin
  // prepare DB
  qryDivision.Connection := SCM2.scmConnection;
  qryDivision.IndexName := 'indxMale';
  try
    qryDivision.Open;
  except
    on E: EFDDBEngineException do
    begin
      SCM2.FDGUIxErrorDialog.Execute(E);
      Close;
    end;
  end;
  tcDivision.TabIndex := 0;
end;

procedure TDivisions.FormKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    qryDivision.CheckBrowseMode;
    Key := 0;
    Close;
  end;
end;

procedure TDivisions.qryDivisionNewRecord(DataSet: TDataSet);
begin
  try
    case tcDivision.TabIndex of
    0, -1:
      DataSet.FieldByName('GenderID').AsInteger := 1;
    1:
      DataSet.FieldByName('GenderID').AsInteger := 2;
    2:
      DataSet.FieldByName('GenderID').AsInteger := 3;
  end;
  finally
    ;
  end;

end;

procedure TDivisions.tcDivisionChange(Sender: TObject);
begin
  qryDivision.CheckBrowseMode;
  LockDrawing;
  grid.BeginUpdate;
  try
    case tcDivision.TabIndex of
    0:
      qryDivision.IndexName := 'indxMale';
    1:
      qryDivision.IndexName := 'indxFemale';
    2:
      qryDivision.IndexName := 'indxMixed';
  end;
  finally
    grid.EndUpdate;
    UnlockDrawing;
  end;
end;


end.
