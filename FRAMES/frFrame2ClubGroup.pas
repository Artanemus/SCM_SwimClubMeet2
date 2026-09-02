unit frFrame2ClubGroup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.VirtualImage, Vcl.WinXCtrls, Vcl.Buttons, Vcl.WinXPanels,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  dmSCM2;

type
  TFrame2ClubGroup = class(TFrame)
    lbl1: TLabel;
    lbl2: TLabel;
    vimg1: TVirtualImage;
    edtL: TEdit;
    spnlBtns: TStackPanel;
    spbtnMoveR: TSpeedButton;
    spbtnMoveR2: TSpeedButton;
    spbtnMoveL: TSpeedButton;
    spbtnMoveL2: TSpeedButton;
    pnlL: TPanel;
    pnlR: TPanel;
    lbxL: TListBox;
    lbxR: TListBox;
    qryLstSwimClub: TFDQuery;
    qryLstSwimClubGroup: TFDQuery;
    pnlGrid: TGridPanel;
    procedure spbtnMoveL2Click(Sender: TObject);
    procedure spbtnMoveLClick(Sender: TObject);
    procedure spbtnMoveR2Click(Sender: TObject);
    procedure spbtnMoveRClick(Sender: TObject);
  private
    FIsChanged: boolean;
    FParentClubID: integer;

    procedure MoveSelectedItems(lstL, lstR: TListBox);
    procedure MoveAllItems(lstL, lstR: TListBox);
    procedure LoadList_SwimClubGroup(AParentClubID: integer);
    procedure LoadList_SwimClub(AParentClubID: integer);
    procedure UpdateData_SwimClubGroup(AParentClubID: Integer);

  protected

  public
    constructor Create(AOwner: TComponent); override;

    procedure Prepare(AParentClubID: Integer);
    procedure CheckAndSaveData();
    property IsChanged: boolean read FIsChanged write FIsChanged;

  end;

implementation

{$R *.dfm}

{ TFrame2ClubGroup }



procedure TFrame2ClubGroup.CheckAndSaveData;
begin
  { Test condition...
    Are we missing an update to the SwimClubGroup state.
    param = 0 : Default to frClubGroup.FClubGroupID.
  }
  if (fIsChanged = true) and (FParentClubID > 0) then
  begin
    UpdateData_SwimClubGroup(FParentClubID);
  end;
end;

constructor TFrame2ClubGroup.Create(AOwner: TComponent);
begin
  inherited;
  // Use for:
  // - Initializing non-visual fields (integers, strings, objects)
  // - Setting default property values
  // - Creating objects that don't depend on child components
  // - DO NOT access child components (they don't exist yet!)
  fIsChanged := False;
  FParentClubID := 0;

  // If Parent is not set yet, create a temporary parent
  // This ensures all child controls are properly initialized.
  if not (csDesigning in ComponentState) and (AOwner is TWinControl) then
    Parent := TWinControl(AOwner);

end;


procedure TFrame2ClubGroup.LoadList_SwimClub(AParentClubID: integer);
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
  try
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
  except
    on E: EFDDBEngineException do
      SCM2.FDGUIxErrorDialog.Execute(E);
  end;
end;

procedure TFrame2ClubGroup.LoadList_SwimClubGroup(AParentClubID: integer);
begin
  // clear the Left ListBox - Swimming Clubs;
  lbxR.Items.Clear;
  // re-query the records to be placed in list.
  qryLstSwimClubGroup.Close;
  qryLstSwimClubGroup.ParamByName('PARENTCLUBID').AsInteger := AParentClubID;
  qryLstSwimClubGroup.Prepare;
  try
    qryLstSwimClubGroup.Open;
    while not qryLstSwimClubGroup.eof do
    begin
      lbxR.Items.AddObject(
        qryLstSwimClubGroup.FieldByName('Caption').AsString,
        TObject(qryLstSwimClubGroup.FieldByName('ChildClubID').AsInteger)
        );
      qryLstSwimClubGroup.Next;
    end;
  except
    on E: EFDDBEngineException do
      SCM2.FDGUIxErrorDialog.Execute(E);
  end;
end;

procedure TFrame2ClubGroup.MoveAllItems(lstL, lstR: TListBox);
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

procedure TFrame2ClubGroup.MoveSelectedItems(lstL, lstR: TListBox);
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

procedure TFrame2ClubGroup.Prepare(AParentClubID: Integer);
begin
  qryLstSwimClubGroup.Connection := SCM2.scmConnection;
  qryLstSwimClub.Connection := SCM2.scmConnection;

  FParentClubID := AParentClubID;
  if FParentClubID > 0 then
  begin
    LoadList_SwimClub(FParentClubID);
    LoadList_SwimClubGroup(FParentClubID);
  end;
end;

procedure TFrame2ClubGroup.spbtnMoveL2Click(Sender: TObject);
begin
  MoveAllItems(lbxR, lbxL);
end;

procedure TFrame2ClubGroup.spbtnMoveLClick(Sender: TObject);
begin
  MoveSelectedItems(lbxR, lbxL);
end;

procedure TFrame2ClubGroup.spbtnMoveR2Click(Sender: TObject);
begin
  MoveAllItems(lbxL, lbxR);
end;

procedure TFrame2ClubGroup.spbtnMoveRClick(Sender: TObject);
begin
  MoveSelectedItems(lbxL, lbxR);
end;

procedure TFrame2ClubGroup.UpdateData_SwimClubGroup(AParentClubID: Integer);
var
  SQLDelete, SQLInsert: string;
  idx, ChildClubID: Integer;
begin
  if (fIsChanged = true) and (AParentClubID > 0) then
  begin
    fIsChanged := false; // on passed or failed - false.
    SQLDelete := '''
      DELETE FROM [SwimClubMeet2].[dbo].[SwimClubGroup]
      WHERE [ParentClubID] = :ID;
      ''';

    SQLInsert := '''
      INSERT INTO [SwimClubMeet2].[dbo].[SwimClubGroup]
        ([ParentClubID], [ChildClubID])
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
