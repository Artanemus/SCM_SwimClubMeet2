unit frFrameNominate;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes, System.Actions,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.StdCtrls, Vcl.DBCtrls,  Vcl.Grids, Vcl.Menus,
  Vcl.ActnList,

  Data.DB,

  FireDAC.Stan.Param,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  uDefines, uSettings, dmIMG
  ;

type
  TFrameNominate = class(TFrame)
    actnlistNominate: TActionList;
    dbtxtNominateFullName: TDBText;
    grid: TDBAdvGrid;
    pnlBody: TPanel;
    pumenuNominate: TPopupMenu;
    rpnlCntrl: TRelativePanel;
    pnlG: TPanel;
    procedure gridCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit:
        Boolean);
    procedure gridClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure gridGetHTMLTemplate(Sender: TObject; ACol, ARow: Integer; var
        HTMLTemplate: string; Fields: TFields);
    procedure gridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    procedure UpdateUI(DoFullUpdate: boolean = false);
    // messages originate in the CORE and are forwarded by main form.
    procedure Msg_SCM_Scroll_FilterMember(var Msg: TMessage);
      message SCM_SCROLL_NOMINATE_FILTERMEMBER; // refreshes nominate and qualified icons
    procedure Msg_SCM_AfterScroll_Session(var Msg: TMessage); message
        SCM_AFTERSCROLL_SESSION;
    procedure UpdateQryNominate();
  end;

implementation

{$R *.dfm}

{ TFrameNominate }


uses
  dmSCM2, dmCORE, uSwimClub, uSession, uNominee;

procedure TFrameNominate.gridCanEditCell(Sender: TObject; ARow, ACol: Integer;
    var CanEdit: Boolean);
begin
{
    No editing allowed within this grid. To toggle nomination...
      - Click on nominate check box.
      - Press space bar.
}
  CanEdit := false;
end;

procedure TFrameNominate.gridClickCell(Sender: TObject; ARow, ACol: Integer);
var
//  aEventID, amemberID: integer;
  G: TDBAdvGrid;
begin
  G := TDBAdvGrid(Sender);
  if ARow >= G.FixedRows then
  begin
    if ACol = 1 then
    begin
      G.BeginUpdate;
      try
        uNominee.ToogleNomination(); // current active reccord?
      finally
        G.EndUpdate;
      end;
      {
      CORE.qryNominate.DisableControls;
      try
        aMemberID := CORE.qryFilterMember.FieldByName('MemberID').AsInteger;
        aEventID := CORE.qryNominate.FieldByName('EventID').AsInteger;
        if (aMemberID=0) or (aEventID=0)  then exit;
        // is the member nominate?
        if uNominee.Locate_Nominee(aMemberID, aEventID) then
        begin
          // UN-NOMINATE the member. (in the current event)
          uNominee.DeleteNominee(aMemberID, aEventID);
        end
        else
        begin
          // NOMINATE the member. (for the current event)
          uNominee.NewNominee(aMemberID, aEventID);
        end;
      finally
        CORE.qryNominate.Refresh; // redraws (icon) checkbox state.
        CORE.qryNominate.EnableControls;
      end;
      }
    end;
  end;
end;

procedure TFrameNominate.gridGetHTMLTemplate(Sender: TObject; ACol, ARow:
    Integer; var HTMLTemplate: string; Fields: TFields);
var
  s: string;
begin
  s := '''
    <FONT size="12"><P line-height=".5"><B><#SubText></B><BR>
    <#Caption></P></FONT>
    ''';
  HTMLTemplate := s;
end;

procedure TFrameNominate.gridKeyDown(Sender: TObject; var Key: Word; Shift:
    TShiftState);
var
  ARow: integer;
//  ACol: integer;
  G: TDBAdvGrid;
begin
  if Key = VK_SPACE then
  begin
    // get the current row and col
    ARow := grid.GetRealRow;
//    ACol := grid.GetRealCol;
    G := TDBAdvGrid(Sender);
    if ARow >= G.FixedRows then
    begin
      G.BeginUpdate;
      try
        uNominee.ToogleNomination(); // current active reccord?
      finally
        G.EndUpdate;
        Key := 0;
      end;
    end;
  end;
end;


procedure TFrameNominate.Msg_SCM_Scroll_FilterMember(var Msg: TMessage);
begin
//    frNominate.UpdateUI;
end;

procedure TFrameNominate.Msg_SCM_AfterScroll_Session(var Msg: TMessage);
begin
//    UpdateQryNominate;
end;

procedure TFrameNominate.UpdateQryNominate;
begin
  if Assigned(SCM2) and SCM2.scmConnection.Connected
    and Assigned(CORE) and  CORE.IsActive then
  begin
    grid.BeginUpdate;
    CORE.qryNominate.DisableControls;
    try
      begin
        CORE.qryNominate.Close;
        CORE.qryNominate.ParamByName('MEMBERID').AsInteger := CORE.qryFilterMember.FieldByName('MemberID').AsInteger;
        CORE.qryNominate.ParamByName('SESSIONID').AsInteger := uSession.PK;
        CORE.qryNominate.ParamByName('SEEDDATE').AsDateTime := uNominee.GetSeedDate();
        CORE.qryNominate.ParamByName('ISSHORTCOURSE').AsByte := ORD(uSwimClub.IsShortCourse);
        CORE.qryNominate.Prepare;
        CORE.qryNominate.Open;
      end;
    finally
      CORE.qryNominate.EnableControls;
      grid.EndUpdate;
    end;
  end;
end;

procedure TFrameNominate.UpdateUI(DoFullUpdate: boolean = false);
begin
  if DoFullUpdate then
  begin
    // CHECK TMS rule..
    if grid.RowCount < grid.FixedRows  then
      grid.RowCount := grid.FixedRows + 1;

    { NOTE: never make TMG TDBAdvGrid Invisible. It won't draw correctly.}

    if (not Assigned(SCM2)) or (not SCM2.scmConnection.connected) or
        (not Assigned(CORE)) or (not CORE.IsActive) or (CORE.qrySession.IsEmpty) then
    begin
      Self.Visible := false; // hide everthing - move on.
      exit;
    end;

    { CHEAT: grid must be visible to sync + forces re-paint. }
    LockDrawing;
    Self.Visible := true;
    pnlBody.Visible := true;
    pnlG.Visible := true;
//    if CORE.qryNominate.Active then
//      CORE.qryNominate.EmptyDataSet;
    grid.Refresh;
    UnlockDrawing;
  end;


  LockDrawing;

  try
    if CORE.qrySession.IsEmpty() then
    begin
      Self.Visible := false;   // hide all..
      exit;
    end;

    if not Self.Visible then Self.Visible := true;

    if CORE.qryEvent.IsEmpty then
    begin
      // CNTRL panel is displayed but not the grid.
      pnlBody.Visible := true;
      pnlBody.Caption := 'No events found.';
      pnlG.Visible := false;
    end
    else
    begin
      pnlBody.Visible := true;
      pnlG.Visible := true;
      if not CORE.qryFilterMember.IsEmpty() then
      begin
        pnlG.Visible := true;
        UpdateQryNominate();
      end
      else
      begin
        pnlBody.Caption := 'No club members found.';
        pnlG.Visible := false;
      end;
    end;

  finally
    UnlockDrawing;
  end;

end;

end.



