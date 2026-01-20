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
    procedure gridGetCellColor(Sender: TObject; ARow, ACol: Integer; AState:
        TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure gridGetDisplText(Sender: TObject; ACol, ARow: Integer; var Value:
        string);
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
      // table's readonly state is determined on the lock state of the Session.
      if not CORE.qryNominate.UpdateOptions.ReadOnly then
      begin
        G.BeginUpdate;
        try
            uNominee.ToogleNomination(); // current active record.
        finally
          G.EndUpdate;
        end;
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

procedure TFrameNominate.gridGetCellColor(Sender: TObject; ARow, ACol: Integer;
    AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  if (ARow >= grid.FixedRows) then   // (ARow >= grid.FixedCols)
  begin
    // overrides all
    if uSession.IsLocked then
      AFont.Color := grid.DisabledFontColor;
  end;
end;

procedure TFrameNominate.gridGetDisplText(Sender: TObject; ACol, ARow: Integer;
  var Value: string);
var
  indx: integer;
begin
  // It's here we toggle the DISABLED ICONS that are displayed in the grid.
  if (ARow >= grid.FixedRows) then
    if CORE.qryNominate.UpdateOptions.ReadOnly then
    begin
      indx := StrToIntDef(Value, 0);
      case ACol of
        1: // CHECKBOX - NOMINATED (zero is accepted here.)
          Value := IntToStr(indx + 2);
        2: // QUALLIFIED
          if indx = 1 then Value := IntToStr(indx + 1);
        3: // STROKE.
          begin
            if indx > 0 then
              { Results in a different data image being displayed.
               In this instance, a 'disabled' stroke icon. }
              Value := IntToStr(indx + 5);
          end;
        6: // EVENTYPEID.
          if indx > 0 then Value := IntToStr(indx + 2);
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
  { NOTE: never make TMG TDBAdvGrid Invisible. It won't draw correctly.}
  if DoFullUpdate then
  begin
    // CHECK TMS rule..
    if grid.RowCount < grid.FixedRows  then
      grid.RowCount := grid.FixedRows + 1;

    if (not Assigned(SCM2)) or (not SCM2.scmConnection.connected) or
        (not Assigned(CORE)) or (not CORE.IsActive) or (CORE.qrySession.IsEmpty) then
    begin
      Self.Visible := false; // hide everthing - move on.
      exit;
    end;
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



