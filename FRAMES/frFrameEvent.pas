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
    actnlistEvent: TActionList;
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
  private
    { Private declarations }
    procedure SetIconGridView();
    procedure SetGridView();
  public
    // messages must be forwarded by main form.
    procedure Msg_SCM_Scroll_Event(var Msg: TMessage); message SCM_SCROLL_EVENT;
  end;

implementation

{$R *.dfm}

procedure TFrameEvent.actnEv_GridViewExecute(Sender: TObject);
var
  fld: TField;
begin
  // TActionUpdate determines if this routine can be accessed
    TAction(Sender).Checked := not TAction(Sender).Checked; // T O G G L E .
    gEvent.BeginUpdate;
    CORE.qryEvent.DisableControls;
    try
      if TAction(Sender).Checked then
      begin
          TAction(Sender).ImageIndex := 2; // COLLAPSED.

      end
      else
      begin
          TAction(Sender).ImageIndex := 1  // EXPANDED.

      end;


      // e v e n t   d e s c r i p t i o n ...
      fld := CORE.qryEvent.FindField('Caption');
      if Assigned(fld) then fld.Visible := Checked;

      // e v e n t   s c h e d u l e  t i m e ...
      fld := CORE.qryEvent.FindField('ScheduleDT');
      if Assigned(fld) then fld.Visible := Checked;

      // INDV or RELAY event type ....
      // fld := CORE.qryEvent.FindField('luEventType');
      // if Assigned(fld) then
      // fld.Visible := Checked;

      // Fields that are always visible in either grid display mode.
      // n o m i n a t i o n s  ...
      fld := CORE.qryEvent.FindField('NomineeCount');
      if Assigned(fld) then
      begin
        if Checked then fld.DisplayLabel := 'Nominees'
        else fld.DisplayLabel := 'Nom#';
      end;
      // e n t r a n t s ...
      fld := CORE.qryEvent.FindField('EntrantCount');
      if Assigned(fld) then
      begin
        if Checked then fld.DisplayLabel := 'Entrants'
        else fld.DisplayLabel := ' Ent#';
      end;

    finally
      begin
        CORE.qryEvent.EnableControls;
        SetIconGridView();
        gEvent.EndUpdate;
      end;
    end;


    //EXPANDED


    // makes visible the event caption field used to enter event details
    try
      gEvent.BeginUpdate;
      CORE.qryEvent.DisableControls;

    finally
      CORE.qryEvent.EnableControls;
      gEvent.EndUpdate;
    end;

end;

procedure TFrameEvent.actnEv_GridViewUpdate(Sender: TObject);
var
  DoEnable: boolean;
begin
  DoEnable := false;
  // fix RAD STUDIO icon re-assignment issue.
  if (not spbtnEvGridView.imageindex in [1,2]) then
    spbtnEvGridView.imageindex := 2; // Collapsed grid.

  if Assigned(CORE) and CORE.IsActive and
    not CORE.qryEvent.IsEmpty then DoEnable := true;
  TAction(Sender).Enabled := DoEnable;
end;

procedure TFrameEvent.Msg_SCM_Scroll_Event(var Msg: TMessage);
begin
  SetIconGridView; // check the icon state..
end;

procedure TFrameEvent.SetGridView;
begin
  // hide columns in gEvent;
end;

procedure TFrameEvent.SetIconGridView;
begin
  if (actnEv_GridView.Checked) and (spbtnEvGrid.ImageIndex <> 2) then
    spbtnEvGrid.ImageIndex := 2 else spbtnEvGrid.ImageIndex := 1;
end;

end.
