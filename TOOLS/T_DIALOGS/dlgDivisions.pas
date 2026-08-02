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
  dmIMG, dmSCM2, Vcl.WinXCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, SVGIconVirtualImageList,

  uExportDivisionToJSON;

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
    rpnlCntrl: TRelativePanel;
    imglstDivision: TSVGIconVirtualImageList;
    spbtnDelete: TSpeedButton;
    spbtnNew: TSpeedButton;
    spbtnOut: TSpeedButton;
    spbtnIn: TSpeedButton;
    spbtnReport: TSpeedButton;
    qryDivisionDivisionTypeID: TIntegerField;
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure qryDivisionNewRecord(DataSet: TDataSet);
    procedure spbtnDeleteClick(Sender: TObject);
    procedure spbtnNewClick(Sender: TObject);
    procedure spbtnOutClick(Sender: TObject);
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

procedure TDivisions.spbtnDeleteClick(Sender: TObject);
begin
  if (tcDivision.TabIndex <> -1) and not qryDivision.IsEmpty then
  begin
    LockDrawing;
    grid.BeginUpdate;
    qryDivision.DisableControls;
    try
      qryDivision.CheckBrowseMode;
      try
        qryDivision.Delete;
      except
        on E: EFDDBEngineException do
        begin
          qryDivision.Cancel;
          SCM2.FDGUIxErrorDialog.Execute(E);
        end;
      end;
    finally
      qryDivision.EnableControls;
      grid.endUpdate;
      UnlockDrawing;
    end;
  end;
end;

procedure TDivisions.spbtnNewClick(Sender: TObject);
begin
  if tcDivision.TabIndex <> -1 then
  begin
    LockDrawing;
    grid.BeginUpdate;
    qryDivision.DisableControls;
    try
      qryDivision.CheckBrowseMode;
      try
        qryDivision.Insert;
        qryDivision.Edit;
        qryDivision.FieldByName('DivisionTypeID').AsInteger := 1;
        case tcDivision.TabIndex of
          0:
            qryDivision.FieldByName('GenderID').AsInteger := 1;
          1:
            qryDivision.FieldByName('GenderID').AsInteger := 2;
          2:
            qryDivision.FieldByName('GenderID').AsInteger := 3;
        end;
        qryDivision.FieldByName('Caption').AsString := 'New Division : All ages.';
        qryDivision.FieldByName('AgeFrom').AsInteger := 0;
        qryDivision.FieldByName('AgeTo').AsInteger := 999;
        qryDivision.Post;
      except
        on E: EFDDBEngineException do
        begin
          qryDivision.Cancel;
          SCM2.FDGUIxErrorDialog.Execute(E);
        end;
      end;
    finally
      qryDivision.EnableControls;
      grid.EndUpdate;
      UnlockDrawing;
    end;
  end;

end;

procedure TDivisions.spbtnOutClick(Sender: TObject);
var
  ex: TDivisionExporter;
  sl: TStringList;
begin
  qryDivision.DisableControls;
  try
    // switch index
    qryDivision.IndexName := 'indxJSON';
    ex := TDivisionExporter.Create(qryDivision);
    sl := TStringList.Create();
    sl := ex.ExportToJSONStringList;
  finally
    ex.Free;
    sl.Free;
    qryDivision.EnableControls;
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
