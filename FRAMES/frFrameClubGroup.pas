unit frFrameClubGroup;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXCtrls,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.WinXPanels, Vcl.Buttons, Vcl.VirtualImage,

  Data.DB,

  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  dmIMG,  dmCORE, dmSCM2;

type
  TFrameClubGroup = class(TFrame)
    lbxR: TListBox;
    lbxL: TListBox;
    pnlHeader: TPanel;
    pnlFooter: TPanel;
    rpnlBody: TRelativePanel;
    spnlBtns: TStackPanel;
    spbtnMoveL: TSpeedButton;
    spbtnMoveR: TSpeedButton;
    spbtnMoveL2: TSpeedButton;
    spbtnMoveR2: TSpeedButton;
    edtL: TEdit;
    vimg1: TVirtualImage;
    qryLstSwimClub: TFDQuery;
    qryLstSwimClubGroup: TFDQuery;
    lbl1: TLabel;
    lbl2: TLabel;
    procedure FrameExit(Sender: TObject);
    procedure spbtnMoveL2Click(Sender: TObject);
    procedure spbtnMoveLClick(Sender: TObject);
    procedure spbtnMoveR2Click(Sender: TObject);
    procedure spbtnMoveRClick(Sender: TObject);
  private
    fParentClubID: integer;
    fIsChanged: boolean;
//    procedure MoveSelectedItem(lstL, lstR: TListBox);
    procedure MoveSelectedItems(lstL, lstR: TListBox);
    procedure MoveAllItems(lstL, lstR: TListBox);
    procedure LoadList_SwimClubGroup(AParentClubID: integer);
    procedure LoadList_SwimClub(AParentClubID: integer);

  protected
    procedure Loaded; override;

  public
    procedure Prepare(AParentClubID: Integer);
    property IsChanged: boolean read FIsChanged;
    procedure UpdateData_SwimClubGroup(AParentClubID: Integer);
  end;

implementation

{$R *.dfm}

procedure TFrameClubGroup.FrameExit(Sender: TObject);
begin
  if fIsChanged then
  begin
    if FParentClubID > 0 then
        UpdateData_SwimClubGroup(FParentClubID);
    fIsChanged := false; // On exit - force state.
  end;
end;

procedure TFrameClubGroup.Prepare(AParentClubID: Integer);
begin
  FParentClubID := AParentClubID;
  if FParentClubID > 0 then
  begin
    LoadList_SwimClub(FParentClubID);
    LoadList_SwimClubGroup(FParentClubID);
  end;
end;

procedure TFrameClubGroup.Loaded;
begin
  inherited;
  fIsChanged := False;
  FParentClubID := 0;

  if not Assigned(SCM2) or not SCM2.scmConnection.connected then exit;
  if not Assigned(CORE) or not CORE.IsActive then exit;
  qryLstSwimClubGroup.Connection := SCM2.scmConnection;
  qryLstSwimClub.Connection := SCM2.scmConnection;

end;

procedure TFrameClubGroup.LoadList_SwimClub(AParentClubID: integer);
var
  s: string;
  idx: integer;
begin
  // clear the Left ListBox - Swimming Clubs;
  lbxL.Items.Clear;
  // re-query the records to be placed in list.
  qryLstSwimClub.Close;
  qryLstSwimClub.ParamByName('PARENTCLUBID').AsInteger := AParentClubID;
  qryLstSwimClub.Prepare;
  qryLstSwimClub.Open;
  if qryLstSwimClub.Active then
  begin
    While not qryLstSwimClub.eof do
    begin
      s := qryLstSwimClub.FieldByName('Caption').AsString;
      idx := lbxL.Items.Add(s); // show the caption
      lbxL.Items.Objects[idx] := TObject(qryLstSwimClub.FieldByName('SwimClubID').AsInteger);
      //  RESTORE SwimClubID := Integer(lbxL.Items.Objects[idx]);
      qryLstSwimClub.Next;
    end;
  end;
end;

procedure TFrameClubGroup.LoadList_SwimClubGroup(AParentClubID: integer);
var
  s: string;
  idx: integer;
begin
  // clear the Left ListBox - Swimming Clubs;
  lbxR.Items.Clear;
  // re-query the records to be placed in list.
  qryLstSwimClubGroup.Close;
  qryLstSwimClubGroup.ParamByName('AParentClubID').AsInteger := AParentClubID;
  qryLstSwimClubGroup.Prepare;
  qryLstSwimClubGroup.Open;
  if qryLstSwimClubGroup.Active then
  begin
    While not qryLstSwimClubGroup.eof do
    begin
      s := qryLstSwimClubGroup.FieldByName('Caption').AsString;
      idx := lbxR.Items.Add(s); // show the caption
      lbxR.Items.Objects[idx] := TObject(qryLstSwimClubGroup.FieldByName('ChildClubID').AsInteger);
      //  RESTORE SwimClubID := Integer(lbxR.Items.Objects[idx]);
      qryLstSwimClubGroup.Next;
    end;
  end;
end;

procedure TFrameClubGroup.MoveAllItems(lstL, lstR: TListBox);
var
  i: Integer;
begin
  if lstL.Items.IsEmpty then exit;
  // Iterate backwards so Delete() won’t shift unprocessed items
  for i := lstL.Count - 1 downto 0 do
  begin
      fIsChanged := true;
      // Add to destination
      lstR.Items.AddObject(lstL.Items[i], lstL.Items.Objects[i]);
      // Remove from source
      lstL.Items.Delete(i);
  end;
  // UI - update
  lstR.ItemIndex := -1;
end;

(*
procedure TFrClubGroup.MoveSelectedItem(lstL, lstR: TListBox);
var
  idx, newIdx: Integer;
begin
  idx := lstL.ItemIndex;
  if idx < 0 then
    Exit; // nothing selected
  fIsChanged := true;
  // Add to right listbox (both text and object pointer)
  newIdx := lstR.Items.AddObject(lstL.Items[idx], lstL.Items.Objects[idx]);
  // Remove from left listbox
  lstL.Items.Delete(idx);
  // Optionally select the newly added item in lstR
  lstR.ItemIndex := newIdx;
end;
*)

procedure TFrameClubGroup.MoveSelectedItems(lstL, lstR: TListBox);
var
  i: Integer;
begin
  if lstL.Items.IsEmpty then exit;
  // Iterate backwards so Delete() won’t shift unprocessed items
  for i := lstL.Count - 1 downto 0 do
  begin
    if lstL.Selected[i] then
    begin
      fIsChanged := true;
      // Add to destination
      lstR.Items.AddObject(lstL.Items[i], lstL.Items.Objects[i]);
      // Remove from source
      lstL.Items.Delete(i);
    end;
  end;
  // UI - update
  lstR.ItemIndex := -1;
end;

procedure TFrameClubGroup.spbtnMoveL2Click(Sender: TObject);
begin
  MoveAllItems(lbxR, lbxL);
end;

procedure TFrameClubGroup.spbtnMoveLClick(Sender: TObject);
begin
  MoveSelectedItems(lbxR, lbxL);
end;

procedure TFrameClubGroup.spbtnMoveR2Click(Sender: TObject);
begin
  MoveAllItems(lbxL, lbxR);
end;

procedure TFrameClubGroup.spbtnMoveRClick(Sender: TObject);
begin
  MoveSelectedItems(lbxL, lbxR);
end;

procedure TFrameClubGroup.UpdateData_SwimClubGroup(AParentClubID: Integer);
var
  SQLDelete, SQLInsert: string;
  idx, ChildClubID: Integer;
begin
  if (fIsChanged = true) and (AParentClubID > 0) then
  begin
    fIsChanged := false; // on passed or failed - false.
    SQLDelete := '''
      DELETE FROM [SwimClubMeet2].[dbo].[SwimClubGroup]
      WHERE [AParentClubID] = :ID;
      ''';

    SQLInsert := '''
      INSERT INTO [SwimClubMeet2].[dbo].[SwimClubGroup]
        ([AParentClubID], [ChildClubID])
      VALUES (:ID1, :ID2);
      ''';
//    SCM2.scmConnection.StartTransaction;
    try
      // clear all old records
      SCM2.scmConnection.ExecSQL(SQLDelete, [AParentClubID]);
      // add new records
      for idx := 0 to lbxR.Items.Count - 1 do
      begin
        ChildClubID := Integer(lbxR.Items.Objects[idx]);
        // if trust FK constraints, just insert:
        SCM2.scmConnection.ExecSQL(SQLInsert, [AParentClubID, ChildClubID]);
      end;
//      SCM2.scmConnection.Commit;
    except
//      SCM2.scmConnection.Rollback;
      raise;
    end;
  end
  else
    fIsChanged := false; // on passed or failed - state is false.
end;


end.
