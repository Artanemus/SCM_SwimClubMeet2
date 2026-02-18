unit frFrameMM_SwimClub;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.UITypes,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Grids,

  AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  SVGIconImage,

  FireDAC.Stan.Error,

  dmSCM2, dmIMG, dmMM_CORE, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.WinXPanels;

type
  TframeMM_SwimClub = class(TFrame)
    Grid: TDBAdvGrid;
    pnlHeader: TPanel;
    pnlBody: TPanel;
    spbtnAdd: TSpeedButton;
    spbtnRemove: TSpeedButton;
    lblHeader: TLabel;
    spbtnClearHouse: TSpeedButton;
    bhMM: TBalloonHint;
    spbtnArchive: TSpeedButton;
    spnlCTRL: TStackPanel;
    spbtnMM_Info: TSpeedButton;
    procedure GridCanEditCell(Sender: TObject; ARow, ACol: Integer; var
        CanEdit: Boolean);
    procedure GridClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure GridGetDisplText(Sender: TObject; ACol, ARow: Integer; var Value:
        string);
    procedure spbtnAddClick(Sender: TObject);
    procedure spbtnClearHouseClick(Sender: TObject);
    procedure spbtnMM_InfoClick(Sender: TObject);
    procedure spbtnMM_InfoMouseLeave(Sender: TObject);
    procedure spbtnRemoveClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure Loaded; override;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  dlgSwimClubPicker;

procedure TframeMM_SwimClub.GridCanEditCell(Sender: TObject; ARow, ACol:
    Integer; var CanEdit: Boolean);
begin
  CanEdit := false;
  if ARow >= Grid.FixedRows then
  begin
    if (ACol = 2) then CanEdit := true;
  end;
end;

procedure TframeMM_SwimClub.GridClickCell(Sender: TObject; ARow, ACol: Integer);
var
  G: TDBAdvGrid;
  aState: boolean;
begin
  G := TDBAdvGrid(Sender);
  if ARow >= G.FixedRows then
  begin
    if ACol = 3 then
    begin
      LockDrawing;
      Grid.BeginUpdate;
      MM_CORE.qryMemberLink.DisableControls;
      try
        try
          aState := MM_CORE.qryMemberLink.FieldByName('IsArchived').AsBoolean;
          aState := not aState;
          begin
            MM_CORE.qryMemberLink.CheckBrowseMode;
            MM_CORE.qryMemberLink.Edit;
            MM_CORE.qryMemberLink.FieldByName('IsArchived').AsBoolean := aState;
            MM_CORE.qryMemberLink.Post;
          end;
        except on E: EFDDBEngineException do
          MM_CORE.qryMemberLink.Cancel;
        end;
      finally
        MM_CORE.qryMemberLink.EnableControls;
        Grid.EndUpdate;
        UnlockDrawing;
      end;
    end;
  end;
end;

procedure TframeMM_SwimClub.GridDrawCell(Sender: TObject; ACol, ARow: LongInt;
    Rect: TRect; State: TGridDrawState);
var
  G: TDBAdvGrid;
begin
  G := TDBAdvGrid(Sender);
  if ARow = 0 then // Header row...
  begin
    if ACol = 3 then // Archived image 30x30...
      IMG.imglstSwimClubArchived.Draw(G.Canvas, Rect.left + 4, Rect.top + 4, 1);
  end;
end;

procedure TframeMM_SwimClub.GridGetDisplText(Sender: TObject; ACol, ARow:
    Integer; var Value: string);
var
  G: TDBAdvGrid;
begin
  G := TDBAdvGrid(Sender);
  if ARow >= G.FixedRows then
  begin
//    if ACol = 3 then
//    begin
//      if Value = 'False' then Value := '0';
//      if Value = 'True' then Value := '1';
//    end;
  end;
end;

procedure TframeMM_SwimClub.Loaded;
var
  item: TDBGridColumnItem;
begin
  inherited;
  // This executes after the DFM has loaded and ActionLinks have synced.
  // Fix Delphi's disabling column settings.
  item := Grid.ColumnByFieldName['luHouseStr'];
  if item <> nil then item.AllowBlank := true;
    // UNSAFE - Grid.Columns[2].AllowBlank := true;
end;

procedure TframeMM_SwimClub.spbtnAddClick(Sender: TObject);
var
  dlg: TSwimClubPicker;
  mr: TModalResult;
begin
  dlg := nil;
  if Assigned(MM_CORE) and MM_CORE.IsActive then
  begin
    LockDrawing;
    Grid.BeginUpdate;
    MM_CORE.qryMemberLink.DisableControls;
    try
      dlg := TSwimClubPicker.Create(Self);
      dlg.MemberID := MM_CORE.qMember.FieldByName('MemberID').AsInteger;
      mr := dlg.ShowModal;
      if IsPositiveResult(mr) AND (dlg.MemberID > 0)
        AND (dlg.SwimClubID > 0) then
      begin
        try
          begin
            MM_CORE.qryMemberLink.CheckBrowseMode;
            MM_CORE.qryMemberLink.Insert;
            MM_CORE.qryMemberLink.FieldByName('MemberID').AsInteger := dlg.MemberID;
            MM_CORE.qryMemberLink.FieldByName('SwimClubID').AsInteger := dlg.SwimClubID;
            MM_CORE.qryMemberLink.FieldByName('IsArchived').AsBoolean := false;
            MM_CORE.qryMemberLink.FieldByName('House').Clear;
            MM_CORE.qryMemberLink.Post;
          end;
        except on E: EFDDBEngineException do
          MM_CORE.qryMemberLink.Cancel;
        end;
        //
      end;
    finally
      if Assigned(dlg) then dlg.Free;
      MM_CORE.qryMemberLink.EnableControls;
      Grid.EndUpdate;
      UnlockDrawing;
    end;
  end;
end;

procedure TframeMM_SwimClub.spbtnClearHouseClick(Sender: TObject);
begin
  LockDrawing;
  Grid.BeginUpdate;
  MM_CORE.qryMemberLink.DisableControls;
  try
    try
      begin
        MM_CORE.qryMemberLink.CheckBrowseMode;
        MM_CORE.qryMemberLink.Edit;
        MM_CORE.qryMemberLink.FieldByName('HouseID').Clear;
        MM_CORE.qryMemberLink.Post;
      end;
    except on E: EFDDBEngineException do
      MM_CORE.qryMemberLink.Cancel;
    end;
  finally
    MM_CORE.qryMemberLink.EnableControls;
    Grid.EndUpdate;
    UnlockDrawing;
  end;
end;

procedure TframeMM_SwimClub.spbtnMM_InfoClick(Sender: TObject);
begin
  bhMM.Title := 'Control Buttons.';
  bhMM.Description := '''
   - Add Club
   Excluded from club-picker: Grouped Clubs, Archived Clubs and clubs
   currently assigned to member.
   - Remove Club
   Note: If a member has been nominated to an event, the club cannot
   be unassigned. This preserves historical data.
   - Archive Club
   Effectively removes a member from a club by hiding the member from
   appearing in the nomination panel.
   - Clear House
   Unassign's house. Historical data remains safe unless you re-compute
   scores. The same action can be done by selecting the blank item in
   the dropdown combobox or enter the cell and press Ctrl+BackSpace.
  ''';
  bhMM.ShowHint(spbtnMM_Info);

end;

procedure TframeMM_SwimClub.spbtnMM_InfoMouseLeave(Sender: TObject);
begin
  bhMM.HideHint;
end;

procedure TframeMM_SwimClub.spbtnRemoveClick(Sender: TObject);
var
  SQL: string;
  v: Variant;
  aSwimClubID, aMemberID: integer;
begin
  aSwimClubID := MM_CORE.qryMemberLink.FieldByName('SwimClubID').AsInteger;
  aMemberID := MM_CORE.qryMemberLink.FieldByName('MemberID').AsInteger;
  // Test: Is the member nominated in events within the club?
  if (aSwimClubID <> 0) AND (aMemberID <> 0) AND Assigned(SCM2) then
  begin
    SQL := '''
    SELECT COUNT(NomineeID) FROM SwimClubMeet2.dbo.Nominee
    INNER JOIN [Event] ON Nominee.EventID = [Event].EventID
    INNER JOIN [Session] ON [Event].SessionID = [Session].SessionID
    WHERE [Session].SwimClubID = :ID1 AND MemberID = :ID2;
    ''';
    v := SCM2.scmConnection.ExecSQL(SQL, [aSwimClubID, aMemberID]);
    if not VarIsClear(v) and (v = 0) then
    begin
      LockDrawing;
      Grid.BeginUpdate;
      MM_CORE.qryMemberLink.DisableControls;
      try
        try
          begin
            MM_CORE.qryMemberLink.CheckBrowseMode;
            MM_CORE.qryMemberLink.Delete;
          end;
        except on E: EFDDBEngineException do
          MM_CORE.qryMemberLink.Cancel;
        end;
      finally
        MM_CORE.qryMemberLink.EnableControls;
        Grid.EndUpdate;
        UnlockDrawing;
      end;
    end;
  end;

end;

end.
