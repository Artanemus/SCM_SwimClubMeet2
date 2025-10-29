unit frFrameEvent;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes,  System.Actions,

  Data.DB, BaseGrid,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.Menus, Vcl.ActnList, Vcl.Buttons,

  AdvUtil, AdvObj, AdvGrid, DBAdvGrid, Vcl.WinXCtrls,

  dmSCM2, dmIMG, dmCORE, uDefines,

  uSettings, uSession, uEvent
  ;

type
  TFrameEvent = class(TFrame)
    actnEv_Delete: TAction;
    actnEv_EventType: TAction;
    actnEv_Export: TAction;
    actnEv_Final: TAction;
    actnEv_GridView: TAction;
    actnEv_Import: TAction;
    actnEv_MoveDown: TAction;
    actnEv_MoveUp: TAction;
    actnEv_New: TAction;
    actnEv_QuartFinals: TAction;
    actnEv_Renumber: TAction;
    actnEv_Report: TAction;
    actnEv_Schedule: TAction;
    actnEv_SemiFinals: TAction;
    actnEv_Stats: TAction;
    actnlstEvent: TActionList;
    DeleteEvent1: TMenuItem;
    EventReport1: TMenuItem;
    EventType1: TMenuItem;
    grid: TDBAdvGrid;
    MoveDown1: TMenuItem;
    MoveUp1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    NewEvent1: TMenuItem;
    oogleGridView1: TMenuItem;
    pnlBody: TPanel;
    pumenuEvent: TPopupMenu;
    rpnlCntrl: TRelativePanel;
    ShapeEvBar1: TShape;
    ShapeEvBar2: TShape;
    spbtnEvDelete: TSpeedButton;
    spbtnEvDown: TSpeedButton;
    spbtnEvGridView: TSpeedButton;
    spbtnEvIndvTeam: TSpeedButton;
    spbtnEvNew: TSpeedButton;
    spbtnEvReport: TSpeedButton;
    spbtnEvUp: TSpeedButton;
    procedure actnEv_DeleteExecute(Sender: TObject);
    procedure actnEv_DeleteUpdate(Sender: TObject);
    procedure actnEv_EventTypeExecute(Sender: TObject);
    procedure actnEv_EventTypeUpdate(Sender: TObject);
    procedure actnEv_GridViewExecute(Sender: TObject);
    procedure actnEv_GridViewUpdate(Sender: TObject);
    procedure actnEv_MoveUpDownExecute(Sender: TObject);
    procedure actnEv_MoveUpDownUpdate(Sender: TObject);
    procedure actnEv_NewExecute(Sender: TObject);
    procedure actnEv_NewUpdate(Sender: TObject);
    procedure actnEv_RenumberExecute(Sender: TObject);
    procedure actnEv_RenumberUpdate(Sender: TObject);
    procedure gridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
    procedure gridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
  private
    procedure FixedEventCntrlIcons();
    procedure SetGridView_ColVisibility;
    procedure SetGridView_IconIndex;
  public
    procedure Initialise();
    // messages must be forwarded by main form.
    procedure Msg_SCM_Scroll_Event(var Msg: TMessage); message SCM_SCROLL_EVENT;
  end;

implementation

{$R *.dfm}

procedure TFrameEvent.actnEv_DeleteExecute(Sender: TObject);
begin
  grid.BeginUpdate;
  try
    if uEvent.DeleteEvent(true) then
    begin
      uSession.RenumberEvents(); // runs SCM2.dbo.RenumberEvents...
      CORE.qryEvent.Refresh;
    end;
  finally
    grid.EndUpdate;
  end;
end;

procedure TFrameEvent.actnEv_DeleteUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
    // fix RAD STUDIO icon re-assignment issue.
  if (spbtnEvDelete.imageindex <> 5) then spbtnEvDelete.imageindex := 5;

  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameEvent.actnEv_EventTypeExecute(Sender: TObject);
begin
  grid.BeginUpdate;
  uEvent.ToggleEventTypeID;
  grid.EndUpdate;
end;

procedure TFrameEvent.actnEv_EventTypeUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  // fix RAD STUDIO icon re-assignment issue.
  if (spbtnEvIndvTeam.imageindex <> 7) then spbtnEvDelete.imageindex := 7;

  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameEvent.actnEv_GridViewExecute(Sender: TObject);
begin
    TAction(Sender).Checked := not TAction(Sender).Checked; // T O G G L E .
    grid.BeginUpdate;
    CORE.qryEvent.DisableControls;
    try
      SetGridView_IconIndex;  // uses actnEv_GridView.Checked state.
      SetGridView_ColVisibility;  // uses actnEv_GridView.Checked state.
    finally
      begin
        CORE.qryEvent.EnableControls;
        grid.EndUpdate;
      end;
    end;
end;

procedure TFrameEvent.actnEv_GridViewUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  // fix RAD STUDIO icon re-assignment issue.
  SetGridView_IconIndex; // uses actnEv_GridView.Checked state.
  // grid view is enabled when events table is empty.
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameEvent.actnEv_MoveUpDownExecute(Sender: TObject);
var
cn: TComponentName;
PK: integer;
begin
    grid.BeginUpdate;
    PK := uEvent.PK;
    try
      cn := TComponent(Sender).Name;
      if String(cn).Contains('Down') then
        uEvent.MoveUpDown(scmMoveDirection.mdDown)
      else if string(cn).Contains('Up')  then
        uEvent.MoveUpDown(scmMoveDirection.mdUp)
      else exit;
    finally
      CORE.qryEvent.Refresh; // re-sort on indx - eventNum.
      uEvent.Locate(PK); // track event just moved.
      grid.EndUpdate;
    end;
end;

procedure TFrameEvent.actnEv_MoveUpDownUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  // fix RAD STUDIO icon re-assignment issue.
  if (spbtnEvDown.imageindex <> 3) then
      spbtnEvDown.imageindex := 3;
  if (spbtnEvUp.imageindex <> 2) then
      spbtnEvUp.imageindex := 2;

  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameEvent.actnEv_NewExecute(Sender: TObject);
begin
  grid.BeginUpdate;
  uEvent.NewEvent;
  // uSession.RenumberEvents();
  grid.EndUpdate;
end;

procedure TFrameEvent.actnEv_NewUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  // fix RAD STUDIO icon re-assignment issue.
  if (spbtnEvNew.imageindex <> 4) then spbtnEvNew.imageindex := 4;
  // new is enabled when events table is empty
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameEvent.actnEv_RenumberExecute(Sender: TObject);
begin
  // call DB Procedure
  if Assigned(SCM2) and SCM2.scmConnection.Connected then
  begin
    grid.BeginUpdate;
    try
      uSession.RenumberEvents(); // runs SCM2.dbo.RenumberEvents...
      CORE.qryEvent.Refresh;
    finally
      grid.EndUpdate;
    end;
  end;
end;

procedure TFrameEvent.actnEv_RenumberUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  if Assigned(SCM2) and SCM2.scmConnection.Connected and
    Assigned(CORE) and CORE.IsActive and
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

procedure TFrameEvent.gridCanEditCell(Sender: TObject; ARow, ACol: Integer;
    var CanEdit: Boolean);
begin
  // inhibit -  description, gender, round.
  if actnEv_GridView.Checked then // Expanded.
    CanEdit := not (ACol in [0, 1, 2, 5, 7, 8, 9])
  else
    CanEdit := not (ACol in [0, 1, 2, 5 ,6, 7, 8, 9, 10, 11, 12, 13]); // collapsed.
end;

procedure TFrameEvent.gridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect:
  TRect; State: TGridDrawState);
begin
  if (ARow = 0) then
  begin
    case ACol of
      8:
        IMG.imglstEventCell.Draw(TDBAdvGrid(Sender).Canvas, Rect.left + 4,
          Rect.top + 4, 1);
      9:
        IMG.imglstEventCell.Draw(TDBAdvGrid(Sender).Canvas, Rect.left + 4,
          Rect.top + 4, 2);
      10: // centered gender icon...
        IMG.imglstEventCell.Draw(TDBAdvGrid(Sender).Canvas, Rect.left + 6,
          Rect.top + 4, 3);
    end;
  end;
end;

procedure TFrameEvent.gridKeyPress(Sender: TObject; var Key: Char);
begin
  {TODO -oBSA -cGeneral :
    Clear lookup cells, whether in edit state of not, using the BACKSPACE key.
    make it optional to use CNTRL+BACKSPACE to clear cell}

//      if ((GetKeyState(VK_CONTROL) and 128) = 128) then
//      begin
//      end;

  if (grid.row >= grid.FixedRows) and
      (grid.RealColIndex(grid.Col) in [12, 13]) then
  begin
    if (Key = char(VK_BACK)) or (Key = #$7F) then
    begin
      grid.BeginUpdate;
      try
        begin
          try
            begin
              if (CORE.qryEvent.State <> dsEdit) then
                CORE.qryEvent.Edit;
              case (grid.RealColIndex(grid.Col)) of
                12:
                CORE.qryEvent.FieldByName('EventCategoryID').Clear;
                13:
                CORE.qryEvent.FieldByName('ParalympicTypeID').Clear;
              end;
              CORE.qryEvent.Post;
              Key := char(0);
            end;
          except
            on E: Exception do ShowMessage(E.Message);
          end;
        end;
      finally
        grid.EndUpdate;
      end;
    end;
  end;
end;

procedure TFrameEvent.Initialise;
begin
  // GridView button icon index is depenandt on checked state.
  actnEv_GridView.Checked := false; // Collapsed grid view.
  FixedEventCntrlIcons; // Fix RAD Studio erronous icon re-assignment.
  SetGridView_ColVisibility;
  grid.RowCount := grid.FixedRows + 1; // TMS rule: row count > fixed row.

  if SCM2.scmConnection.Connected and CORE.IsActive then
  begin
    if CORE.qrySession.IsEmpty then
      // setting pagemode to false clears grid of text. (it appears empty)
      grid.PageMode := false
    else
      // Set pagemode to the default 'editable' fetch records mode.
      grid.PageMode := true;
  end
  else
    grid.PageMode := false; // read-only

end;

procedure TFrameEvent.Msg_SCM_Scroll_Event(var Msg: TMessage);
begin
  // ...
  ;
end;

procedure TFrameEvent.SetGridView_ColVisibility;
begin
  // EXPANDED or COLLAPSED grid views...
  if actnEv_GridView.Checked then
  begin  // EXPANDED...
    grid.Columns[6].Width := 400;   // DESCRIPTION.
    grid.Columns[10].Width := 38;   // Gender (ABREV)
    grid.Columns[11].Width := 80;   // Round (ABREV)
    grid.Columns[12].Width := 100;   // Event Category (ABREV)
    grid.Columns[13].Width := 140;   // ParaOlympic (Caption)
  end
  else
  begin  // COLLAPSED...
    grid.Columns[6].Width := 0;
    grid.Columns[10].Width := 0;
    grid.Columns[11].Width := 0;
    grid.Columns[12].Width := 0;
    grid.Columns[13].Width := 0;
  end;
end;

procedure TFrameEvent.SetGridView_IconIndex;
begin
  // logic saves on unessesary repaints.
  if (actnEv_GridView.Checked) then // Expanded view - icon has no slash.
  begin
    if (spbtnEvGridView.ImageIndex <> 1) then
      spbtnEvGridView.ImageIndex := 1;
  end
  else // Collapsed view - icon contains a slash.
  begin
    if (spbtnEvGridView.ImageIndex <> 0) then
       else spbtnEvGridView.ImageIndex := 0;
  end;
end;

end.
