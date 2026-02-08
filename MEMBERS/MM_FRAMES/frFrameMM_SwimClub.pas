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

  dmSCM2, dmIMG, dmMM_CORE;

type
  TframeMM_SwimClub = class(TFrame)
    Grid: TDBAdvGrid;
    pnlHeader: TPanel;
    pnlCtrl: TPanel;
    pnlBody: TPanel;
    spbtnAdd: TSpeedButton;
    spbtnRemove: TSpeedButton;
    lblHeader: TLabel;
    spbtnClearHouse: TSpeedButton;
    imgBug: TSVGIconImage;
    bhMM_SwimClub: TBalloonHint;
    spbtnArchive: TSpeedButton;
    procedure GridCanEditCell(Sender: TObject; ARow, ACol: Integer; var
        CanEdit: Boolean);
    procedure GridClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect;
        State: TGridDrawState);
    procedure imgBugClick(Sender: TObject);
    procedure imgBugMouseLeave(Sender: TObject);
    procedure spbtnAddClick(Sender: TObject);
    procedure spbtnClearHouseClick(Sender: TObject);
    procedure spbtnRemoveClick(Sender: TObject);
  private
    { Private declarations }
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
  aState: integer;
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
          aState := MM_CORE.qryMemberLink.FieldByName('IsArchived').AsInteger;
          if aState = 0 then aState := 1 else aState := 0;
          begin
            MM_CORE.qryMemberLink.CheckBrowseMode;
            MM_CORE.qryMemberLink.Edit;
            MM_CORE.qryMemberLink.FieldByName('IsArchived').AsInteger := aState;
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
  if ARow < G.FixedRows then
  begin
    if ACol = 3 then // Archived image 30x30...
      IMG.imglstSwimClubArchived.Draw(G.Canvas, Rect.left + 4, Rect.top + 4, 1);
  end;
end;

procedure TframeMM_SwimClub.imgBugClick(Sender: TObject);
begin
  bhMM_SwimClub.Title := 'Contact Number.';
  bhMM_SwimClub.Description := '''
   - Add Club
   Excluded from club-picker: Grouped Clubs, Archived Clubs and clubs
   currently assigned to member.
   - Remove Club
   If a member has been nominated to an event, the club cannot
   be unassigned. This preserves historical data.
   - Archive Club
   Effectively removes a member from a club by hiding the member from
   appearing in the club's nomination panel.
   - Clear House
   Unassign's house. Historical data is safe unless you re-compute
   scores. The same action can be done by selecting the blank item in
   the dropdown combobox.
  ''';
  bhMM_SwimClub.ShowHint(imgBug);

end;

procedure TframeMM_SwimClub.imgBugMouseLeave(Sender: TObject);
begin
  bhMM_SwimClub.HideHint;
end;

procedure TframeMM_SwimClub.spbtnAddClick(Sender: TObject);
var
  dlg: TSwimClubPicker;
  mr: TModalResult;
begin
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
            MM_CORE.qryMemberLink.FieldByName('IsArchived').AsInteger := 0;
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
        MM_CORE.qryMemberLink.FieldByName('House').Clear;
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
