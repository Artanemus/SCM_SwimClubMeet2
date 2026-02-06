unit dlgTeamPickerCTRL;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes,

  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.VirtualImage,
  Vcl.ExtCtrls, Vcl.Grids,

  Data.DB,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  BaseGrid, AdvUtil, AdvObj, AdvGrid, DBAdvGrid,

  dmSCM2, dmCORE, dmIMG, uDefines, uSettings;

type
  TTeamPickerCTRL = class(TForm)
    qryQuickPick: TFDQuery;
    pnlHeader: TPanel;
    VirtualImage2: TVirtualImage;
    Nominate_Edit: TEdit;
    pnlBody: TPanel;
    pnlCntrl: TPanel;
    btnCancel: TButton;
    btnPost: TButton;
    btnToggleName: TButton;
    pnlGrid: TPanel;
    Grid: TDBAdvGrid;
  private
    fActiveSortCol: integer;
    fToggleNameState: boolean;
    // 6 grid columns containing TriState: unsorted, ascend, descend.
    TSortState: Array [0 .. 5] of scmSortState;
    procedure SortGrid(aActiveSortCol: Integer);
    procedure ToogleSortState(indx: integer);
  public
    function Prepare(LaneID: Integer): boolean;
  end;

var
  TeamPickerCTRL: TTeamPickerCTRL;

implementation

{$R *.dfm}

uses uEvent;

{ TTeamPickerCTRL }

function TTeamPickerCTRL.Prepare(LaneID: Integer): boolean;
begin
  result := false;
  fActiveSortCol := -1; // no sorting...
  LockDrawing;
  Grid.BeginUpdate;
  qryQuickPick.DisableControls;
  try
    qryQuickPick.Close();
    qryQuickPick.ParamByName('EVENTID').AsInteger := uEvent.PK;
    qryQuickPick.ParamByName('TOGGLENAME').AsBoolean := fToggleNameState;
    qryQuickPick.Prepare();
    qryQuickPick.Open();
    if (qryQuickPick.Active) then
    begin
      // qryQuickPick.IndexName := 'idxUnsorted';
      qryQuickPick.Indexes[10].Selected := true; // idxUnSorted.
      { The InitSortXRef method initializes the current row indexing
          as reference. }
      // Grid.InitSortXRef;
      result := true;
    end;
  finally
    qryQuickPick.EnableControls;
    Grid.EndUpdate;
    UnlockDrawing;
  end;end;

procedure TTeamPickerCTRL.SortGrid(aActiveSortCol: Integer);
var
  idx: Integer;
begin
  idx := 0; // UnSorted
  if aActiveSortCol in [0..5] then
  begin
    case aActiveSortCol of
      1: // TEAM FNAME
        case TSortState[aActiveSortCol] of
          stDescend:
            idx := 1;
          stAscend:
            idx := 2;
        end;
      2: // TTB
        case TSortState[aActiveSortCol] of
          stDescend:
            idx := 3;
          stAscend:
            idx := 4;
        end;
      3: // PB
        case TSortState[aActiveSortCol] of
          stDescend:
            idx := 5;
          stAscend:
            idx := 5;
        end;
      4: // ABREV
        case TSortState[aActiveSortCol] of
          stDescend:
            idx := 7;
          stAscend:
            idx := 8;
        end;
      5: // CAPTION
        case TSortState[aActiveSortCol] of
          stDescend:
            idx := 9;
          stAscend:
            idx := 10;
        end;
    end;
  end;
  // note aActiveSortCol = -1 ... idx = 10. (UnSorted)
  qryQuickPick.Indexes[idx].Selected := true;
end;

procedure TTeamPickerCTRL.ToogleSortState(indx: integer);
begin
  TSortState[indx] := stUnsorted;
  // check bounds
  if indx in [0..5] then
  begin
    case TSortState[indx] of
      stDescend:
        TSortState[indx] := stUnsorted;
      stAscend:
        TSortState[indx] := stDescend;
      stUnSorted:
        TSortState[indx] := stAscend;
    end;
  end;
end;

end.
