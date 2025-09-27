unit f_FrameClubGroup;

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
  TFrClubGroup = class(TFrame)
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
    procedure spbtnMoveL2Click(Sender: TObject);
    procedure spbtnMoveLClick(Sender: TObject);
    procedure spbtnMoveR2Click(Sender: TObject);
    procedure spbtnMoveRClick(Sender: TObject);
  private
    fParentClubID: integer;
    fIsChanged: boolean;
    procedure MoveSelectedItem(lstL, lstR: TListBox);
    procedure MoveSelectedItems(lstL, lstR: TListBox);


  public
  {
    constructor Create(AOwner: TComponent); override;
    procedure Initialize;
  }

    procedure LoadList_SwimClubGroup(ParentClubID: integer);
    procedure LoadList_SwimClub(ParentClubID: integer);
    procedure UpdateData_SwimClubGroup(ParentClubID: Integer);
    property ParentClubID: integer read FParentClubID write FParentClubID;
    property IsChanged: boolean read FIsChanged write FIsChanged;

  end;

implementation

{$R *.dfm}

{ TClubGroupAssign }

(*
constructor TFrClubGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Initialization here
  fIsChanged := False;
end;


{
Since TFrame can be placed on a form at design-time, sometimes its constructor
might be called before some properties are set. Therefore call here after
construction.
}
procedure TFrClubGroup.Initialize;
begin
  fIsChanged := False;
end;
*)

procedure TFrClubGroup.LoadList_SwimClub(ParentClubID: integer);
var
  s: string;
  idx: integer;
begin
  // clear the Left ListBox - Swimming Clubs;
  lbxL.Items.Clear;
  // re-query the records to be placed in list.
  qryLstSwimClub.Close;
  qryLstSwimClub.ParamByName('PARENTCLUBID').AsInteger := ParentClubID;
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

procedure TFrClubGroup.LoadList_SwimClubGroup(ParentClubID: integer);
var
  s: string;
  idx: integer;
begin
  // clear the Left ListBox - Swimming Clubs;
  lbxR.Items.Clear;
  // re-query the records to be placed in list.
  qryLstSwimClubGroup.Close;
  qryLstSwimClubGroup.ParamByName('PARENTCLUBID').AsInteger := ParentClubID;
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

procedure TFrClubGroup.MoveSelectedItems(lstL, lstR: TListBox);
var
  i, newIdx: Integer;
begin
  // Iterate backwards so Delete() won’t shift unprocessed items
  for i := lstL.Count - 1 downto 0 do
  begin
    if lstL.Selected[i] then
    begin
      fIsChanged := true;
      // Add to destination
      newIdx := lstR.Items.AddObject(lstL.Items[i], lstL.Items.Objects[i]);
      // Remove from source
      lstL.Items.Delete(i);
      // Optional: select newly added item(s) in lstR
      lstR.ItemIndex := newIdx;
    end;
  end;
end;

procedure TFrClubGroup.spbtnMoveL2Click(Sender: TObject);
begin
  MoveSelectedItems(lbxR, lbxL);
end;

procedure TFrClubGroup.spbtnMoveLClick(Sender: TObject);
begin
  MoveSelectedItem(lbxR, lbxL);
end;

procedure TFrClubGroup.spbtnMoveR2Click(Sender: TObject);
begin
  MoveSelectedItems(lbxL, lbxR);
end;

procedure TFrClubGroup.spbtnMoveRClick(Sender: TObject);
begin
  MoveSelectedItem(lbxL, lbxR);
end;

procedure TFrClubGroup.UpdateData_SwimClubGroup(ParentClubID: Integer);
var
  SQLDelete, SQLInsert: string;
  idx, ChildClubID: Integer;
begin
  if fIsChanged then
  begin
    SQLDelete := '''
      DELETE FROM [SwimClubMeet2].[dbo].[SwimClubGroup]
      WHERE [ParentClubID] = :ID;
      ''';

    SQLInsert := '''
      INSERT INTO [SwimClubMeet2].[dbo].[SwimClubGroup]
        ([ParentClubID], [ChildClubID])
      VALUES (:ID1, :ID2);
      ''';
    SCM2.scmConnection.StartTransaction;
    try
      // clear all old records
      SCM2.scmConnection.ExecSQL(SQLDelete, [ParentClubID]);
      // add new records
      for idx := 0 to lbxR.Items.Count - 1 do
      begin
        ChildClubID := Integer(lbxR.Items.Objects[idx]);
        // if trust FK constraints, just insert:
        SCM2.scmConnection.ExecSQL(SQLInsert, [ParentClubID, ChildClubID]);
      end;
      SCM2.scmConnection.Commit;
    except
      SCM2.scmConnection.Rollback;
      raise;
    end;
  end;
end;


end.
