unit frFrameMM_ContactNum;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids,  Vcl.Buttons,

  Data.DB,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  SVGIconImage,

  FireDAC.Stan.Error,

  dmSCM2, dmIMG, dmMM_CORE, Vcl.DBCtrls;

type

  TFrameMM_ContactNum = class(TFrame)
    pnlHeader: TPanel;
    pnlBody: TPanel;
    lblHeader: TLabel;
    pnlCTRL: TPanel;
    imgBug: TSVGIconImage;
    pnlGrid: TPanel;
    Grid: TDBAdvGrid;
    DBContactNumNavigator: TDBNavigator;
    bhMM: TBalloonHint;
    procedure GridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
    procedure GridClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure imgBugClick(Sender: TObject);
    procedure imgBugMouseLeave(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure Loaded; override;

  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrameMM_ContactNum.GridCanEditCell(Sender: TObject; ARow, ACol:
    Integer; var CanEdit: Boolean);
begin
  CanEdit := true;
  if ACol in [3, 4] then CanEdit := false; // IsArchived, CreatedOn cannot be edited.
end;

procedure TFrameMM_ContactNum.GridClickCell(Sender: TObject; ARow, ACol:
    Integer);
var
  G: TDBAdvGrid;
  aState: boolean;
begin
  G := TDBAdvGrid(Sender);
  if ARow >= G.FixedRows then
  begin
    if ACol = 3 then
    begin
      LockDrawing;
      Grid.BeginUpdate;
      MM_CORE.qryContactNum.DisableControls;
      try
        try
          aState := MM_CORE.qryContactNum.FieldByName('IsArchived').AsBoolean;
          aState := not aState;
          begin
            MM_CORE.qryContactNum.CheckBrowseMode;
            MM_CORE.qryContactNum.Edit;
            MM_CORE.qryContactNum.FieldByName('IsArchived').AsBoolean := aState;
            MM_CORE.qryContactNum.Post;
          end;
        except on E: EFDDBEngineException do
          MM_CORE.qryContactNum.Cancel;
        end;
      finally
        MM_CORE.qryContactNum.EnableControls;
        Grid.EndUpdate;
        UnlockDrawing;
      end;
    end;
  end;
end;

procedure TFrameMM_ContactNum.GridDrawCell(Sender: TObject; ACol, ARow:
    LongInt; Rect: TRect; State: TGridDrawState);
var
  G: TDBAdvGrid;
begin
  G := TDBAdvGrid(Sender);
  if ARow = 0 then // Header row...
  begin
    if ACol = 3 then // Archived image 30x30...
      IMG.imglstSwimClubArchived.Draw(G.Canvas, Rect.left + 4, Rect.top + 4, 1);
  end;
end;

procedure TFrameMM_ContactNum.GridKeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
var
  fld: TField;
  G: TDBAdvGrid;
begin
  G := TDBAdvGrid(Sender);
  if (Key = VK_BACK) and (ssAlt in Shift) then
  begin
      G.DataSource.DataSet.DisableControls;
      fld := G.SelectedField;
      if assigned(fld) then
      BEGIN
        // if the query is not in edit mode
        if (G.DataSource.DataSet.State <> dsEdit) or
          (G.DataSource.DataSet.State <> dsInsert) then
          G.DataSource.DataSet.Edit;
        // D B G r i d C o n t a c t I n f o ...
        if (fld.FieldName = 'luContactNumType') then
          fld.Clear;
      end;
      G.DataSource.DataSet.EnableControls;
      // signal finished with key;
      Key := 0;
  end;
end;

procedure TFrameMM_ContactNum.imgBugClick(Sender: TObject);
begin
  bhMM.Title := 'Contact Number Information.';
  bhMM.Description := '''
   - Add
   Insert a new, empty contact record into the grid, ready for
   data entry.
   - Subtract
   Delete the selected contact number.
   - Tick
   Post your changes to the database.
   - Cross
   Clear all changes.
   - Clear Contact Type
   Clear the cell. The same action can be done by selecting the
   blank item in the dropdown combobox or enter the cell and press
   Ctrl+BackSpace.
   - Archive
   Effectively make the contact number invisible. It will not appear
   in reports, used in searches or tracked (etc).
  ''';
  bhMM.ShowHint(imgBug);
end;

procedure TFrameMM_ContactNum.imgBugMouseLeave(Sender: TObject);
begin
  bhMM.HideHint;
end;

procedure TFrameMM_ContactNum.Loaded;
var
  item: TDBGridColumnItem;
begin
  inherited;
  // This executes after the DFM has loaded and ActionLinks have synced.
  // Fix Delphi's disabling column settings.
  item := Grid.ColumnByFieldName['luContactNameType'];
  if item <> nil then item.AllowBlank := true;
  // UNSAFE - Grid.Columns[2].AllowBlank := true;
end;

end.
