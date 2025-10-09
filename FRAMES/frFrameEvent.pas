unit frFrameEvent;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes,

  Data.DB, BaseGrid,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.Menus,

  AdvUtil, AdvObj, AdvGrid, DBAdvGrid,

  dmSCM2, dmIMG, dmCORE, uDefines,

  uSettings, uSession, uEvent, System.Actions, Vcl.ActnList, Vcl.Buttons;

type
  TFrameEvent = class(TFrame)
    pnlCntrl: TPanel;
    pnlBody: TPanel;
    gEvent: TDBAdvGrid;
    actnlstEvent: TActionList;
    actnEv_GridView: TAction;
    actnEv_MoveUp: TAction;
    actnEv_MoveDown: TAction;
    actnEv_New: TAction;
    actnEv_Delete: TAction;
    actnEv_Report: TAction;
    actnEv_Final: TAction;
    actnEv_SemiFinals: TAction;
    actnEv_QuartFinals: TAction;
    actnEv_Renumber: TAction;
    actnEv_Schedule: TAction;
    actnEv_Stats: TAction;
    spbtnEvGridView: TSpeedButton;
    ShapeEvBar1: TShape;
    spbtnEvUp: TSpeedButton;
    spbtnEvDown: TSpeedButton;
    spbtnEvNew: TSpeedButton;
    spbtnEvDelete: TSpeedButton;
    ShapeEvBar2: TShape;
    spbtnEvReport: TSpeedButton;
    procedure actnEv_GridViewExecute(Sender: TObject);
    procedure actnEv_GridViewUpdate(Sender: TObject);
    procedure gEventCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
  private
    { Private declarations }
    procedure SetIconGridView();
    procedure SetColGridView;
    procedure FixedEventCntrlIcons();
  public
    procedure Initialise();

    // messages must be forwarded by main form.
    procedure Msg_SCM_Scroll_Event(var Msg: TMessage); message SCM_SCROLL_EVENT;
  end;

implementation

{$R *.dfm}

procedure TFrameEvent.actnEv_GridViewExecute(Sender: TObject);
begin
    TAction(Sender).Checked := not TAction(Sender).Checked; // T O G G L E .

    gEvent.BeginUpdate;
    CORE.qryEvent.DisableControls;

    try
      SetIconGridView;  // uses actnEv_GridView.Checked state.
      SetColGridView;

      {
      var fld: TField;

      // e v e n t   d e s c r i p t i o n ...
      fld := CORE.qryEvent.FindField('Caption');
      if Assigned(fld) then fld.Visible := TAction(Sender).Checked;

      // e v e n t   s c h e d u l e  t i m e ...
      fld := CORE.qryEvent.FindField('ScheduleDT');
      if Assigned(fld) then fld.Visible := TAction(Sender).Checked;

      // INDV or RELAY event type ....
       fld := CORE.qryEvent.FindField('luEventType');
       if Assigned(fld) then
       fld.Visible := Checked;

      // Fields that are always visible in either grid display mode.
      // n o m i n a t i o n s  ...
      fld := CORE.qryEvent.FindField('NomineeCount');
      if Assigned(fld) then
      begin
        if TAction(Sender).Checked then fld.DisplayLabel := 'Nominees'
        else fld.DisplayLabel := 'Nom#';
      end;
//      // e n t r a n t s ...
      fld := CORE.qryEvent.FindField('EntrantCount');
      if Assigned(fld) then
      begin
        if TAction(Sender).Checked then fld.DisplayLabel := 'Entrants'
        else fld.DisplayLabel := ' Ent#';
      end;
      }

    finally
      begin
        CORE.qryEvent.EnableControls;
        gEvent.EndUpdate;
      end;
    end;

end;

procedure TFrameEvent.actnEv_GridViewUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  // fix RAD STUDIO icon re-assignment issue.
  if (not spbtnEvGridView.imageindex in [1,2]) then
    spbtnEvGridView.imageindex := 1; // Collapsed grid (SLASH).

  if Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameEvent.FixedEventCntrlIcons;
var
  i: integer;
begin
  for I := 0 to actnlstEvent.ActionCount - 1 do
    TAction(actnlstEvent.Actions[i]).Update;
end;

procedure TFrameEvent.gEventCanEditCell(Sender: TObject; ARow, ACol: Integer;
    var CanEdit: Boolean);
begin
  CanEdit := not (ACol in [2, 6, 7, 8, 9]);
end;

procedure TFrameEvent.Initialise;
begin
  FixedEventCntrlIcons; // Fix RAD Studio erronous icon assignment.
  gEvent.RowCount := gEvent.FixedRows + 1; // rule: row count > fixed row.

  if SCM2.scmConnection.Connected and CORE.IsActive then
  begin
    if CORE.qrySession.IsEmpty then
    begin
      // setting pagemode to false clears gEvent of text. (it appears empty)
      gEvent.PageMode := false;
    end
    else
    begin
      // Set pagemode to the default 'editable' fetch records mode.
      gEvent.PageMode := true;

      actnEv_GridView.Checked := false;
      SetIconGridView; // uses actnEv_GridView.Checked state.
      SetColGridView; // uses actnEv_GridView.Checked state.

//      gEvent.BeginUpdate;
        // based actnEv_GridView.Checked state - prepare grid columns.

//      gEvent.EndUpdate;
    end;
  end
  else
    gEvent.PageMode := false; // read-only

end;

procedure TFrameEvent.Msg_SCM_Scroll_Event(var Msg: TMessage);
begin
  // ...
end;

procedure TFrameEvent.SetColGridView;
begin
  // EXPANDED or COLLAPSED grid views...
  if actnEv_GridView.Checked then
  begin  // EXPANDED...
    gEvent.Columns[5].Width := 100;
    // modify other columns
  end
  else
  begin  // COLLAPSED...
    gEvent.Columns[5].Width := 0; // description is Hidden.
  end;
end;

procedure TFrameEvent.SetIconGridView;
begin
  // logic saves on unessesary repaints.
  if (actnEv_GridView.Checked) and (spbtnEvGridView.ImageIndex <> 2) then
    spbtnEvGridView.ImageIndex := 2; // GRID ICON. (EXPANDED).
  if (not actnEv_GridView.Checked) and (spbtnEvGridView.ImageIndex <> 1) then
     else spbtnEvGridView.ImageIndex := 1; // GRID ICON WITH SLASH. (COLLAPSED).
end;

end.
