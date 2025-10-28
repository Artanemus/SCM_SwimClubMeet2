unit frFrameFilterMember;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes, System.Actions,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.StdCtrls, Vcl.VirtualImage, Vcl.Buttons, Vcl.Grids,
  Vcl.ActnList, Vcl.Menus,

  Data.DB,

  FireDAC.Stan.Param,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmSCM2, dmIMG, dmCORE,

  uDefines, uSwimClub, uSettings
  ;

type
  TFrameFilterMember = class(TFrame)
    actnlistNomMember: TActionList;
    actnNom_ClearEvent: TAction;
    actnNom_ClearFilter: TAction;
    actnNom_ClearSession: TAction;
    actnNom_MemberDetails: TAction;
    actnNom_MemberPB: TAction;
    actnNom_Report: TAction;
    actnNom_SwitchName: TAction;
    btnClearSearch: TButton;
    Clear1: TMenuItem;
    Cleareventnominations1: TMenuItem;
    Clearsessionnominations1: TMenuItem;
    edtSearch: TEdit;
    grid: TDBAdvGrid;
    lblNomWarning: TLabel;
    MembersDetails1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    NominateReport1: TMenuItem;
    pnlBody: TPanel;
    pnlList: TPanel;
    pumenuNomMember: TPopupMenu;
    QuickviewPBs1: TMenuItem;
    rpnlCntrl: TRelativePanel;
    rpnlSearch: TRelativePanel;
    ShapeMemBar1: TShape;
    spbtnMemDetails: TSpeedButton;
    spbtnPB: TSpeedButton;
    SwitchName1: TMenuItem;
    vimgSearch: TVirtualImage;
    spbtnReport: TSpeedButton;
    spbtnSort: TSpeedButton;
    procedure actnNom_ClearFilterExecute(Sender: TObject);
    procedure actnNom_ClearFilterUpdate(Sender: TObject);
    procedure actnNom_MemberDetailsUpdate(Sender: TObject);
    procedure actnNom_MemberPBUpdate(Sender: TObject);
    procedure actnNom_ReportUpdate(Sender: TObject);
    procedure actnNom_SwitchNameExecute(Sender: TObject);
    procedure actnNom_SwitchNameUpdate(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure gridGetHTMLTemplate(Sender: TObject; ACol, ARow: Integer; var
        HTMLTemplate: string; Fields: TFields);
  public
    procedure Initialise();
  end;

implementation

{$R *.dfm}

uses

uNominate;


procedure TFrameFilterMember.actnNom_ClearFilterExecute(Sender: TObject);
begin
  // changing text generates edtSearchChanged event.
  edtSearch.Text := '';
end;

procedure TFrameFilterMember.actnNom_ClearFilterUpdate(Sender: TObject);
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

procedure TFrameFilterMember.actnNom_MemberDetailsUpdate(Sender: TObject);
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

procedure TFrameFilterMember.actnNom_MemberPBUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
    // fix RAD STUDIO icon re-assignment issue.
  if (spbtnPB.imageindex <> 3) then spbtnPB.imageindex := 3;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameFilterMember.actnNom_ReportUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
    // fix RAD STUDIO icon re-assignment issue.
  if (spbtnReport.imageindex <> 1) then spbtnReport.imageindex := 1;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameFilterMember.actnNom_SwitchNameExecute(Sender: TObject);
var
  SortOn, PK: integer;
begin
  // Switch name, TFDQuery needs param changes.
  grid.BeginUpdate;
  CORE.qryFilterMember.DisableControls;
  try
    PK := CORE.qryFilterMember.FieldByName('MemberID').AsInteger;
    CORE.qryFilterMember.Close;
    // calls edtSearchChange, but aborts - table not active.
    edtSearch.Text := '';
    // turn of filtering, show all members.
    CORE.qryFilterMember.Filtered := false;
    CORE.qryFilterMember.Filter := '';
    // toogle state of action.
    actnNom_SwitchName.Checked := not actnNom_SwitchName.Checked;
    SortOn := ORD(actnNom_SwitchName.Checked);
    // store user preferences...
    if Assigned(Settings) then
      Settings.MemberSortOn := SortOn;

    CORE.qryFilterMember.ParamByName('SORTON').AsInteger := SortOn;
    CORE.qryFilterMember.Prepare;
    CORE.qryFilterMember.Open;

    uNominate.Locate_FilterMember(PK); // re-locate to last member selected.

  finally
    CORE.qryFilterMember.EnableControls;
    grid.EndUpdate;
  end;
end;

procedure TFrameFilterMember.actnNom_SwitchNameUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
    // fix RAD STUDIO icon re-assignment issue.
  if (spbtnSort.imageindex <> 0) then spbtnSort.imageindex := 0;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameFilterMember.edtSearchChange(Sender: TObject);
var
  fs: String;
begin
  // NOTE: CORE.qryFilterMember - filter options [foCaseInsensitive]
  if not Assigned(CORE) or not CORE.IsActive then exit;
  if not CORE.qryFilterMember.Active then exit; // closed dataset.

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

procedure TFrameFilterMember.gridGetHTMLTemplate(Sender: TObject; ACol, ARow:
    Integer; var HTMLTemplate: string; Fields: TFields);
var
  s: string;
  // SQL: String;
//  v: variant;
//  id1, id2: integer;
begin
  if (not Assigned(CORE)) or (not CORE.IsActive) or
    CORE.qryFilterMember.IsEmpty then exit;

  s := '';

  if (ACol = 1) then
  begin
    s := '''
      <FONT size="14"><B><#FName></B></FONT><FONT size="12">  (<#ABREV>.<#Age>)</FONT>
      ''';
  end;

  {
  // if the member has nominations in this session then include an icon.
  SQL := '''
        SELECT COUNT(dbo.nominee.NomineeID) AS NomCount
        FROM Nominee
        INNER JOIN dbo.Event ON Nominee.Eventid = Event.EventID
        WHERE Nominee.memberid = :ID1
              AND Event.SessionID = :ID2;
      ''';
  id1 := CORE.qryFilterMember.FieldByName('MemberID').AsInteger;
  id2 := CORE.qrySession.FieldByName('SessionID').AsInteger;
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [id1, id2]) ;
  if (v <> 0) then
    s := s + '  <IMG src="idx:14" align="middle">' + IntToStr(v);
  }

  HTMLTemplate := s;

end;

{ TFrameMember }

procedure TFrameFilterMember.Initialise;
var
  SortOn: integer;
begin
  // prepare the SQL Query
  grid.RowCount := grid.FixedRows + 1; // rule: row count > fixed row.
  edtSearch.Text := '';
  SortOn := 0;
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
          SortOn := Settings.MemberSortOn;
        // check bounds
        if not SortOn in [0,1] then  SortOn := 0;
        // set state of toggle in action.
        if (SortOn = 1) then actnNom_SwitchName.checked := true
        else actnNom_SwitchName.checked := false;

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
