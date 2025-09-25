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

  dmIMG,  dmCORE;

type
  TClubGroupAssign = class(TFrame)
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
    qryLstClubGroup: TFDQuery;
  private
    fSCID_ClubGroup: integer;
    procedure InitLst_SwimmingClub(ASCID_ClubGroup: integer);
    procedure InitLst_ClubGroup(ASCID_ClubGroup: integer);
    procedure MoveSelectedItem(lstL, lstR: TListBox);
    procedure MoveSelectedItems(lstL, lstR: TListBox);
    procedure Update_ClubGroupData(lstR: TListBox);
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TClubGroupAssign }

procedure TClubGroupAssign.InitLst_ClubGroup(ASCID_ClubGroup: integer);
var
s: string;
idx: integer;
begin
  // clear the ListBox;
  lbxL.Items.Clear;
  // re-query the records to be placed in list.
  qryLstSwimClub.Close;
  qryLstSwimClub.ParamByName('SWIMCLUBID').AsInteger := ASCID_ClubGroup;
  qryLstSwimClub.Prepare;
  qryLstSwimClub.Open;
  if qryLstSwimClub.Active then
  begin
    While not qryLstSwimClub.eof do
    begin
      s := qryLstSwimClub.FieldByName('Caption').AsString;
      s := s.Replace('The', '');
      s := s.Replace('Swimming Club', '');
      idx := lbxL.Items.Add(s); // show the caption
      lbxL.Items.Objects[idx] := TObject(qryLstSwimClub.FieldByName('SwimClubID').AsInteger);
      //  RESTORE SwimClubID := Integer(lbxL.Items.Objects[idx]);
      qryLstSwimClub.Next;
    end;
  end;
end;

procedure TClubGroupAssign.InitLst_SwimmingClub(ASCID_ClubGroup: integer);
begin

end;


procedure TClubGroupAssign.MoveSelectedItem(lstL, lstR: TListBox);
var
  idx, newIdx: Integer;
begin
  idx := lstL.ItemIndex;
  if idx < 0 then
    Exit; // nothing selected

  // Add to right listbox (both text and object pointer)
  newIdx := lstR.Items.AddObject(lstL.Items[idx], lstL.Items.Objects[idx]);

  // Remove from left listbox
  lstL.Items.Delete(idx);

  // Optionally select the newly added item in lstR
  lstR.ItemIndex := newIdx;
end;

procedure TClubGroupAssign.MoveSelectedItems(lstL, lstR: TListBox);
var
  i, newIdx: Integer;
begin
  // Iterate backwards so Delete() won’t shift unprocessed items
  for i := lstL.Count - 1 downto 0 do
  begin
    if lstL.Selected[i] then
    begin
      // Add to destination
      newIdx := lstR.Items.AddObject(lstL.Items[i], lstL.Items.Objects[i]);

      // Remove from source
      lstL.Items.Delete(i);

      // Optional: select newly added item(s) in lstR
      lstR.ItemIndex := newIdx;
    end;
  end;
end;


procedure TClubGroupAssign.Update_ClubGroupData(lstR: TListBox);
begin

end;

end.
