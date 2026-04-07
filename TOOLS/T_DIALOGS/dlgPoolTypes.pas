unit dlgPoolTypes;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes,

  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  dmSCM2, dmIMG, dmCORE, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  DBAdvGrid, Vcl.ExtCtrls, Vcl.WinXPanels, Vcl.Buttons, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.StdCtrls;

type
  TPoolTypes = class(TForm)
    pnlBody: TPanel;
    Grid: TDBAdvGrid;
    tblPoolType: TFDTable;
    tblUnitType: TFDTable;
    tblPoolTypePoolTypeID: TFDAutoIncField;
    tblPoolTypeCaption: TWideStringField;
    tblPoolTypeCaptionShort: TWideStringField;
    tblPoolTypeABREV: TWideStringField;
    tblPoolTypeIsShortCourse: TBooleanField;
    tblPoolTypeLengthOfPool: TFloatField;
    tblPoolTypeIsArchived: TBooleanField;
    tblPoolTypeUnitTypeID: TIntegerField;
    dsPoolType: TDataSource;
    dsUnitType: TDataSource;
    tblPoolTypeluUnitTypeID: TStringField;
    pnlFooter: TPanel;
    BtnClose: TButton;
    navGrid: TDBNavigator;
    procedure FormCreate(Sender: TObject);
    procedure GridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
    procedure GridClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure GridGetDisplText(Sender: TObject; ACol, ARow: Integer; var Value:
        string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PoolTypes: TPoolTypes;

implementation

{$R *.dfm}

procedure TPoolTypes.FormCreate(Sender: TObject);
begin
  // prepare data
  tblPoolType.Connection := SCM2.scmConnection;
  tblUnitType.Connection := SCM2.scmConnection;

  try
    Grid.BeginUpdate;
    try
      tblPoolType.Open;
      tblUnitType.Open;
    except on E: EFDDBEngineException do
      begin
          tblPoolType.Cancel;
          tblUnitType.Cancel;
      end;
    end;
  finally
    Grid.EndUpdate;
  end;

end;

procedure TPoolTypes.GridCanEditCell(Sender: TObject; ARow, ACol: Integer; var
    CanEdit: Boolean);
begin
  CanEdit := true;
  if ACol = 6 then CanEdit := false;

end;

procedure TPoolTypes.GridClickCell(Sender: TObject; ARow, ACol: Integer);
var
  G: TDBAdvGrid;
  aState: boolean;
begin
  G := TDBAdvGrid(Sender);
  if ARow >= G.FixedRows then
  begin
    if ACol = 6 then
    begin
      LockDrawing;
      Grid.BeginUpdate;
      tblPoolType.DisableControls;
      try
        try
          aState := tblPoolType.FieldByName('IsArchived').AsBoolean;
          aState := not aState;
          begin
            tblPoolType.CheckBrowseMode;
            tblPoolType.Edit;
            tblPoolType.FieldByName('IsArchived').AsBoolean := aState;
            tblPoolType.Post;
          end;
        except on E: EFDDBEngineException do
          tblPoolType.Cancel;
        end;
      finally
        tblPoolType.EnableControls;
        Grid.EndUpdate;
        UnlockDrawing;
      end;
    end;
  end;
end;

procedure TPoolTypes.GridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect:
    TRect; State: TGridDrawState);
var
  G: TDBAdvGrid;
begin
  G := TDBAdvGrid(Sender);
  if ARow = 0 then // Header row...
  begin
    if ACol = 6 then // Archived image 30x30...
      IMG.imglstSwimClubArchived.Draw(G.Canvas, Rect.left + 4, Rect.top + 4, 1);
  end;
end;

procedure TPoolTypes.GridGetDisplText(Sender: TObject; ACol, ARow: Integer; var
    Value: string);
var
  ABool: boolean;
begin
  if ARow >= TDBAdvGrid(Sender).FixedRows then
  begin
    if ACol = 6 then
    begin
      Value := '0';
      // CAST([IsArchived] AS INT) AS IsArchivedAsInt
      ABool := tblPoolType.FieldByName('IsArchived').AsBoolean;
      if ABool then  Value := '1';
    end;
    if ACol = 5 then
    begin
      Value := 'N';
      ABool := tblPoolType.FieldByName('IsShortCourse').AsBoolean;
      if ABool then  Value := 'Y';
    end;
  end;
end;

end.
