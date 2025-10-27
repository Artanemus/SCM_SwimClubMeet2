unit frFrameNominate;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.StdCtrls, Vcl.DBCtrls,  Vcl.Grids, Vcl.Menus,

  Data.DB,

  FireDAC.Stan.Param,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmSCM2, dmIMG, dmCORE,

  uDefines, uSwimClub, uSession, uSettings, System.Actions, Vcl.ActnList
  ;


type
  TFrameNominate = class(TFrame)
    rpnlCntrl: TRelativePanel;
    pnlBody: TPanel;
    dbtxtNominateFullName: TDBText;
    grid: TDBAdvGrid;
    actnlistNominate: TActionList;
    pumenuNominate: TPopupMenu;
  private
    { Private declarations }
  public
    procedure Initialise();
  end;

implementation

{$R *.dfm}

{ TFrameNominate }

procedure TFrameNominate.Initialise;
var
  SeedDateAuto: scmSeedDateAuto;
  DT: TDate;
begin
  // prepare the SQL Query
  grid.RowCount := grid.FixedRows + 1; // rule: row count > fixed row.
  SeedDateAuto := scmSeeddateAuto.sdaTodaysDate;
  grid.BeginUpdate;
  try
    begin
      if SCM2.scmConnection.Connected and CORE.IsActive then
      begin
        CORE.qryNominate.Close;
        CORE.qryNominate.ParamByName('MEMBERID').AsInteger := 0;
        CORE.qryNominate.ParamByName('SESSIONID').AsInteger := uSession.PK;
        // 0 = firstname, 1 = lastname.
        if Assigned(Settings) then
          if Settings.SeedDateAuto in [1..2] then
            SeedDateAuto := scmSeedDateAuto(Settings.SeedDateAuto);
        case SeedDateAuto of
          sdaTodaysDate:
            DT := Date();
          sdaSessionDate:
            DT := uSession.SessionDT;
          sdaStartOfSeason:
            DT := uSwimClub.StartOfSwimSeason;
        else
          DT := Date();
        end;
        CORE.qryNominate.ParamByName('SEEDATE').AsDateTime := DT;
        CORE.qryNominate.Prepare;
        CORE.qryNominate.Open;

        if CORE.qryNominate.IsEmpty then
        begin
          // setting pagemode to false clears grid of text. (it appears empty)
          grid.PageMode := false;
        end
        else
        begin
          // Set pagemode to the default 'editable' fetch records mode.
          grid.PageMode := true;
        end;
      end
      else
        grid.PageMode := false; // read-only
    end;
  finally
    grid.EndUpdate;
  end;end;

end.
