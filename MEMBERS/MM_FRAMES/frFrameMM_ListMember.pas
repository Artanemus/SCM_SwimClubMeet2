unit frFrameMM_ListMember;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,


  Vcl.ExtCtrls, Vcl.WinXCtrls, Vcl.StdCtrls,
  Vcl.VirtualImage, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  dmSCM2, dmIMG, dmCORE
  ;

type
  TFrameMM_ListMember = class(TFrame)
    rpnlSearch: TRelativePanel;
    vimgSearch: TVirtualImage;
    edtSearch: TEdit;
    btnClearSearch: TButton;
    pnlList: TPanel;
    grid: TDBAdvGrid;
    dsM: TDataSource;
    qM: TFDQuery;
    qMMemberID: TFDAutoIncField;
    qMMembershipNum: TIntegerField;
    qMMembershipStr: TWideStringField;
    qMFirstName: TWideStringField;
    qMMiddleName: TWideStringField;
    qMLastName: TWideStringField;
    qMDOB: TSQLTimeStampField;
    qMIsActive: TBooleanField;
    qMIsSwimmer: TBooleanField;
    qMIsArchived: TBooleanField;
    qMEmail: TWideStringField;
    qMGenderID: TIntegerField;
    qMFName: TWideStringField;
    qMCreatedOn: TSQLTimeStampField;
    qMArchivedOn: TSQLTimeStampField;
    qMTAGS: TWideMemoField;
    qMluGender: TStringField;
    procedure btnClearSearchClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Prepare();
  end;

implementation

{$R *.dfm}

procedure TFrameMM_ListMember.btnClearSearchClick(Sender: TObject);
begin
  // changing text generates edtSearchChanged event.
  edtSearch.Text := '';
end;

procedure TFrameMM_ListMember.edtSearchChange(Sender: TObject);
var
  fs: String;
begin
  // NOTE: MM_CORE.qMember - filter options [foCaseInsensitive]
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  if not qM.Active then exit; // closed dataset.

  fs := '';
  grid.BeginUpdate;
  qM.DisableControls;
  try
    begin
      // update filter string ....
      if (Length(edtSearch.Text) > 0) then
      begin
        fs := fs + '[FName] LIKE ' + QuotedStr('%' + edtSearch.Text + '%');
      end;
      // assign filter
      if fs.IsEmpty then qM.Filtered := false
      else
      begin
        qM.Filter := fs;
        if not qM.Filtered then
          qM.Filtered := true;
      end;
    end;
  finally
    qM.EnableControls;
    grid.EndUpdate;
  end;
end;

procedure TFrameMM_ListMember.Prepare;
begin
  // NOTE: qM - filter options [foCaseInsensitive]
  if not Assigned(SCM2) or not SCM2.scmConnection.Connected then exit;
  qM.Connection := SCM2.scmConnection;
  qM.Filter := '';
  qM.Filtered := false;
  qm.Open;
end;

end.
