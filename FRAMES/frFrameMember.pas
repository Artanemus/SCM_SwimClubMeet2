unit frFrameMember;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes, System.Actions,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.StdCtrls, Vcl.VirtualImage, Vcl.Buttons, Vcl.Grids,
  Vcl.ActnList,

  Data.DB,

  FireDAC.Stan.Param,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmSCM2, dmIMG, dmCORE,

  uDefines, uSwimClub, uSettings
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
    procedure gridGetHTMLTemplate(Sender: TObject; ACol, ARow: Integer; var
        HTMLTemplate: string; Fields: TFields);
  private
    { Private declarations }
  public
    procedure Initialise();

    // messages must be forwarded by main form.
    // procedure Msg_SCM_SwimClub_Change(var Msg: TMessage); message SCM_SWIMCLUB_CHANGED;

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

procedure TFrameMember.gridGetHTMLTemplate(Sender: TObject; ACol, ARow:
    Integer; var HTMLTemplate: string; Fields: TFields);
var
  s: string;
begin
  if (not Assigned(CORE)) or (not CORE.IsActive) or
    CORE.qryFilterMember.IsEmpty then exit;

  s := '';

  if (ACol = 1) then
  begin
    s := '''
      <FONT size="12"><#FName></FONT><BR>
      <FONT size="10">Age: <#Age> Gender: <#ABREV> Club: <#NickName></FONT>
      ''';
  end;
  HTMLTemplate := s;

end;

{ TFrameMember }

procedure TFrameMember.Initialise;
var
  SortOn: integer;
begin
  // prepare the SQL Query
  grid.RowCount := grid.FixedRows + 1; // rule: row count > fixed row.
  edtSearch.Text := '';
  CORE.qryFilterMember.Filtered := false;
  CORE.qryFilterMember.Filter := '';

  grid.BeginUpdate;
  try
    begin
      if SCM2.scmConnection.Connected and CORE.IsActive then
      begin
        CORE.qryFilterMember.Close;
        CORE.qryFilterMember.ParamByName('SWIMCLUBID').AsInteger := uSwimClub.PK;
        // 0 = firstname, 1 = lastname.
        if Assigned(Settings) then
          SortOn := Settings.MemberSortOn else SortOn := 0;

        CORE.qryFilterMember.ParamByName('SORTON').AsInteger := SortOn;
        CORE.qryFilterMember.Prepare;
        CORE.qryFilterMember.Open;

        if CORE.qryFilterMember.IsEmpty then
        begin
          // setting pagemode to false clears grid of text. (it appears empty)
          grid.PageMode := false;
        end
        else
        begin
          // Set pagemode to the default 'editable' fetch records mode.
          grid.PageMode := true;
        end;
      end
      else
        grid.PageMode := false; // read-only
    end;
  finally
    grid.EndUpdate;
  end;
end;



end.
