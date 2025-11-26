unit dlgSwimClubPicker;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes,

  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.VirtualImage,
  Vcl.ExtCtrls, Vcl.Grids,

  Data.DB,

  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  AdvUtil, AdvObj, BaseGrid,
  AdvGrid, DBAdvGrid,

  dmSCM2, dmIMG
  ;

type
  TSwimClubPicker = class(TForm)
    btnCancel: TButton;
    btnOK: TButton;
    dsSwimClub: TDataSource;
    edtSearch: TEdit;
    Grid: TDBAdvGrid;
    pnlBody: TPanel;
    pnlFooter: TPanel;
    pnlSearch: TPanel;
    qrySwimClub: TFDQuery;
    vimgSearch: TVirtualImage;
    lblRecCount: TLabel;
    vimgClearFilter: TVirtualImage;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridDblClick(Sender: TObject);
    procedure vimgClearFilterClick(Sender: TObject);
  private
    fSwimClubID: Integer;
  public
    property SwimClubID: integer read FSwimClubID write FSwimClubID;
  end;

var
  SwimClubPicker: TSwimClubPicker;

implementation

{$R *.dfm}

procedure TSwimClubPicker.btnCancelClick(Sender: TObject);
begin
    fSwimClubID := 0;
    ModalResult := mrCancel;
end;

procedure TSwimClubPicker.btnOKClick(Sender: TObject);
begin
  if not qrySwimClub.Active then
  begin
    fSwimClubID := 0;
    ModalResult := mrCancel;
  end;
  fSwimClubID := qrySwimClub.FieldByName('SwimClubID').AsInteger;
  ModalResult := mrOk;
end;

procedure TSwimClubPicker.edtSearchChange(Sender: TObject);
var
  LocateSuccess: boolean;
  SearchOptions: TLocateOptions;
  ID: integer;
  fs: string;
begin

  LocateSuccess := false;
  if not qrySwimClub.Active then
    exit;

  fs := '';
  qrySwimClub.DisableControls();

  // LOCATE STORE THE CURRENT ID
  ID := qrySwimClub.FieldByName('SwimClubID').AsInteger;

  // ---------------------------------
  // MEMBER'S FULLNAME ....
  // ---------------------------------
  if (Length(EdtSearch.Text) > 0) then
  begin
    fs := fs + '[ClubName] LIKE ' + QuotedStr('%' + EdtSearch.Text + '%') +
      ' OR [NickName] LIKE ' + QuotedStr('%' + EdtSearch.Text + '%');
  end;

  if (fs.IsEmpty()) then
    qrySwimClub.Filtered := false
  else
  begin
    qrySwimClub.Filter := fs;
    if not(qrySwimClub.Filtered) then
      qrySwimClub.Filtered := true;
  end;

  // DISPLAY NUMBER OF RECORDS FOUND
  qrySwimClub.Last();
  lblRecCount.Caption := 'Found: ' + IntToStr(qrySwimClub.RecordCount);
  // RE_LOCATE TO THE ID
  if (ID <> 0) then
  begin
    SearchOptions := [];
    try
      begin
        LocateSuccess := qrySwimClub.Locate('MemberID', ID,
          SearchOptions);
      end;
    except
      on E: Exception do
        LocateSuccess := false;
    end;
  end;
  // IF MEMBER NOT FOUND ... BROWSE TO FIRST RECORD.
  if (LocateSuccess = false) then
    qrySwimClub.First();

  qrySwimClub.EnableControls();
end;

procedure TSwimClubPicker.edtSearchKeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TSwimClubPicker.FormCreate(Sender: TObject);
begin
  fSwimClubID := 0;
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    qrySwimClub.Connection := SCM2.scmConnection;
    qrySwimClub.Open;
  end
  else
    Close();
  if qrySwimClub.Active then
  begin
    Grid.DataSource := dsSwimClub;
    // Triggers OnChange event.   (Sets up filters and record count.)
    edtSearch.Text := '';
  end
  else
    Close();
end;

procedure TSwimClubPicker.FormDestroy(Sender: TObject);
begin
  qrySwimClub.Close;
end;

procedure TSwimClubPicker.FormKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if (Key = VK_RETURN) then
    btnOKClick(self)
  else if (Key = VK_ESCAPE) then
    btnCancelClick(self);
end;

procedure TSwimClubPicker.GridDblClick(Sender: TObject);
begin
  // pick swimclub and close dlg.
  btnOKClick(self);
end;

procedure TSwimClubPicker.vimgClearFilterClick(Sender: TObject);
begin
    // Triggers OnChange event.   (Clear filter.)
    edtSearch.Text := '';
end;

end.
