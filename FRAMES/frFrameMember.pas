unit frFrameMember;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.StdCtrls, Vcl.VirtualImage, Vcl.Buttons, Vcl.Grids,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmSCM2, dmIMG, dmCORE,

  uDefines, uSwimClub, System.Actions, Vcl.ActnList
  ;

type
  TFrameMember = class(TFrame)
    rpnlCntrl: TRelativePanel;
    pnlBody: TPanel;
    pnlList: TPanel;
    vimgSearch: TVirtualImage;
    edtSearch: TEdit;
    btnClearSearch: TButton;
    rpnlSearch: TRelativePanel;
    spbtnMemSort: TSpeedButton;
    ShapeMemBar1: TShape;
    spbtnMemReport: TSpeedButton;
    lblNomWarning: TLabel;
    grid: TDBAdvGrid;
    actnlistMember: TActionList;
    actnNom_SwitchName: TAction;
    actnNom_Report: TAction;
    actnNom_MemberDetails: TAction;
    actnNom_ClearEvent: TAction;
    actnNom_ClearSession: TAction;
    actnNom_MemberPB: TAction;
    spbtnMemDetails: TSpeedButton;
    actnNom_ClearFilter: TAction;
    procedure actnNom_ClearFilterExecute(Sender: TObject);
    procedure actnNom_ClearFilterUpdate(Sender: TObject);
    procedure actnNom_MemberDetailsUpdate(Sender: TObject);
    procedure actnNom_ReportUpdate(Sender: TObject);
    procedure actnNom_SwitchNameUpdate(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Initialise();
  end;

implementation

{$R *.dfm}

procedure TFrameMember.actnNom_ClearFilterExecute(Sender: TObject);
begin
  edtSearch.Text := '';
end;

procedure TFrameMember.actnNom_ClearFilterUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
    // fix RAD STUDIO icon re-assignment issue.
  if (btnClearSearch.imageindex <> 0) then btnClearSearch.imageindex := 0;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameMember.actnNom_MemberDetailsUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
    // fix RAD STUDIO icon re-assignment issue.
  if (spbtnMemDetails.imageindex <> 2) then spbtnMemDetails.imageindex := 2;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameMember.actnNom_ReportUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
    // fix RAD STUDIO icon re-assignment issue.
  if (spbtnMemReport.imageindex <> 1) then spbtnMemReport.imageindex := 1;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameMember.actnNom_SwitchNameUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
    // fix RAD STUDIO icon re-assignment issue.
  if (spbtnMemSort.imageindex <> 0) then spbtnMemSort.imageindex := 0;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameMember.edtSearchChange(Sender: TObject);
var
  fs: String;
begin
  if not Assigned(CORE) or not CORE.IsActive then exit;
  fs := '';
  grid.BeginUpdate;
  CORE.qryFilterMember.DisableControls;
  try
    begin
      // update filter string ....
      if (Length(edtSearch.Text) > 0) then
      begin
        fs := fs + '[FName] LIKE ' + QuotedStr('%' + edtSearch.Text + '%');
      end;
      // assign filter
      if fs.IsEmpty then CORE.qryFilterMember.Filtered := false
      else
      begin
        CORE.qryFilterMember.Filter := fs;
        if not CORE.qryFilterMember.Filtered then
          CORE.qryFilterMember.Filtered := true;
      end;
    end;
  finally
    CORE.qryFilterMember.EnableControls;
    grid.EndUpdate;
  end;
end;

{ TFrameMember }

procedure TFrameMember.Initialise;
begin
  // prepare the SQL Query
  if Assigned(CORE) and CORE.IsActive then
  begin
    CORE.qryFilterMember.Close;
    CORE.qryFilterMember.ParamByName('SWIMCLUBID').AsInteger :=
      uSwimClub.PK;
    // 0 = firstname, 1 = lastname.
    CORE.qryFilterMember.ParamByName('SORTON').AsInteger := 1;
    CORE.qryFilterMember.Prepare;
  end;
end;

end.
