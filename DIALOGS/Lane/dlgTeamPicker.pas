unit dlgTeamPicker;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.VirtualImage,
  Vcl.ExtCtrls, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  dmSCM2, dmCORE, dmIMG, uDefines, uSettings, uEvent;

type
  TTeamPicker = class(TForm)
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
    qryQuickPick: TFDQuery;
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
  TeamPicker: TTeamPicker;

implementation

{$R *.dfm}

{ TTeamPicker }

function TTeamPicker.Prepare(LaneID: Integer): boolean;
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


{
function TEntrantPicker.NormalizeDistanceID(aDistanceID: integer): integer;
var
  tbl: TFDTable;
  SearchOptions: TLocateOptions;
  foundit: Boolean;
  meters, aEventTypeID: integer;
begin
  result := 0; // Flags - failed to normalize.
//  if not Assigned(fConnection) then exit;
  tbl := TFDTable.Create(self);
  tbl.TableName := 'SwimClubMeet2..Distance';
//  tbl.Connection := FConnection;
  tbl.IndexFieldNames := 'DistanceID';
  tbl.UpdateOptions.ReadOnly := true;
  tbl.Open;
  if tbl.Active then
  Begin
    // locate the
    foundit := tbl.Locate('DistanceID', aDistanceID, SearchOptions);
    if foundit then
    begin
      meters := tbl.FieldByName('Meters').AsInteger;
      aEventTypeID := tbl.FieldByName('EventTypeID').AsInteger;
      if aEventTypeID = 1 then // INDV EVENT
          result := aDistanceID
      else if aEventTypeID = 2 then // TEAM EVENT
      Begin
        // Total meters divided by number of swimmers.
        // It's ASSUMED that relays have 4 swimmer (Olympic Standard).
        meters := (meters div 4);
        // XReference : The distance swum by each swimmer in the relay.
        // Result is the ID of a INDV event.
        foundit := tbl.Locate('Meters; EventTypeID', VarArrayOf([meters, 1]),
          SearchOptions);
        // This normalized distance is required/used by scalar
        // functions dbo.TTB and dbo.PB
        if foundit then result := tbl.FieldByName('DistanceID').AsInteger;
      End;
    end;
  End;
  tbl.Close;
  tbl.Free;
end;
}

end.
