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
    qryQuickPickCTRL: TFDQuery;
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
  qryQuickPickCTRL.DisableControls;
  try
    qryQuickPickCTRL.Close();
    qryQuickPickCTRL.ParamByName('EVENTID').AsInteger := uEvent.PK;
    qryQuickPickCTRL.ParamByName('TOGGLENAME').AsBoolean := fToggleNameState;
    qryQuickPickCTRL.Prepare();
    qryQuickPickCTRL.Open();
    if (qryQuickPickCTRL.Active) then
    begin
      // qryQuickPickCTRL.IndexName := 'idxUnsorted';
      qryQuickPickCTRL.Indexes[10].Selected := true; // idxUnSorted.
      { The InitSortXRef method initializes the current row indexing
          as reference. }
      // Grid.InitSortXRef;
      result := true;
    end;
  finally
    qryQuickPickCTRL.EnableControls;
    Grid.EndUpdate;
    UnlockDrawing;
  end;end;

end.
