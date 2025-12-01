unit dlgMemberPicker;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.VirtualImage,
  Vcl.StdCtrls, Vcl.WinXCtrls, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  DBAdvGrid, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, dmSCM2;

type
  TMemberPicker = class(TForm)
    rpnlSearch: TRelativePanel;
    btnClearSearch: TButton;
    edtSearch: TEdit;
    vimgSearch: TVirtualImage;
    pnlBody: TPanel;
    Grid: TDBAdvGrid;
    qryMember: TFDQuery;
    dsMember: TDataSource;
    pnlFooter: TPanel;
    btnPick: TButton;
    btnCancel: TButton;
    procedure btnClearSearchClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridDblClick(Sender: TObject);
  private
    fMemberID: integer;
  public
    property MemberID: integer read FMemberID write FMemberID;
  end;

var
  MemberPicker: TMemberPicker;

implementation

{$R *.dfm}

procedure TMemberPicker.btnClearSearchClick(Sender: TObject);
begin
  // changing text generates edtSearchChanged event.
  edtSearch.Text := '';
end;

procedure TMemberPicker.edtSearchChange(Sender: TObject);
var
  fs: String;
begin
  // NOTE: CORE.qryFilterMember - filter options [foCaseInsensitive]
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  if not qryMember.Active then exit; // closed dataset.

  fs := '';
  grid.BeginUpdate;
  qryMember.DisableControls;
  try
    begin
      // update filter string ....
      if (Length(edtSearch.Text) > 0) then
      begin
        fs := fs + '[FName] LIKE ' + QuotedStr('%' + edtSearch.Text + '%');
      end;
      // assign filter
      if fs.IsEmpty then qryMember.Filtered := false
      else
      begin
        qryMember.Filter := fs;
        if not qryMember.Filtered then
          qryMember.Filtered := true;
      end;
    end;
  finally
    qryMember.EnableControls;
    grid.EndUpdate;
  end;
end;

procedure TMemberPicker.FormCreate(Sender: TObject);
begin
  grid.RowCount := grid.FixedRows + 1; // rule: row count > fixed row.
  edtSearch.Text := '';

  fmemberID := 0;
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    qryMember.Connection := SCM2.scmConnection;
    try
      qryMember.Open;
      qryMember.Filtered := false;
      qryMember.Filter := '';
    except
      on E: EFDDBEngineException do
        SCM2.FDGUIxErrorDialog.Execute(E);
    end;
  end;
end;

procedure TMemberPicker.FormKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  if Key=VK_ESCAPE then
  begin
    Key := 0;
    fMemberID := 0;
    ModalResult := mrCancel;
  end;
end;

procedure TMemberPicker.GridDblClick(Sender: TObject);
begin
    fMemberID := qryMember.FieldByName('MemberID').AsInteger;
    ModalResult := mrOK;
end;

end.
