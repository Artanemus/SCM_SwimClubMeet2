unit frFrameNominate;

interface

uses
  Winapi.Windows, Winapi.Messages,

  System.SysUtils, System.Variants, System.Classes, System.Actions,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.StdCtrls, Vcl.DBCtrls,  Vcl.Grids, Vcl.Menus,
  Vcl.ActnList,

  Data.DB,

  FireDAC.Stan.Param,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  uDefines, uSettings

  ;


type
  TFrameNominate = class(TFrame)
    rpnlCntrl: TRelativePanel;
    pnlBody: TPanel;
    dbtxtNominateFullName: TDBText;
    grid: TDBAdvGrid;
    actnlistNominate: TActionList;
    pumenuNominate: TPopupMenu;
    procedure gridGetHTMLTemplate(Sender: TObject; ACol, ARow: Integer; var
        HTMLTemplate: string; Fields: TFields);
  private
    { Private declarations }
  public
    procedure Initialise();
    procedure UpdateQryNominate();

    // messages originate in the CORE and are forwarded by main form.
    procedure Msg_SCM_Scroll_FilterMember(var Msg: TMessage);
      message SCM_SCROLL_FILTERMEMBER; // refreshes nominate and qualified icons

    procedure Msg_SCM_Scroll_Session(var Msg: TMessage);
      message SCM_SCROLL_SESSION; // events change with each session.


    {TODO -oBSA -cGeneral : deleteing and inserting an event also needs tracking
      - it maybe easier to update query each time the tabsheet is selected?}

  end;

implementation

{$R *.dfm}

{ TFrameNominate }


uses
  dmSCM2, dmCORE, uSwimClub, uSession, uNominate;

procedure TFrameNominate.gridGetHTMLTemplate(Sender: TObject; ACol, ARow:
    Integer; var HTMLTemplate: string; Fields: TFields);
var
  s: string;
begin
  s := '''
    <FONT size="12"><P line-height=".5"><B><#SubText></B><BR>
    <#Caption></P></FONT>
    ''';
  HTMLTemplate := s;
end;

procedure TFrameNominate.Initialise;
begin
  // prepare the SQL Query
  grid.RowCount := grid.FixedRows + 1; // rule: row count > fixed row.
  grid.BeginUpdate;
  try
    begin
      if SCM2.scmConnection.Connected and CORE.IsActive then
      begin
        CORE.qryNominate.Close;
        CORE.qryNominate.ParamByName('MEMBERID').AsInteger := 0;
        CORE.qryNominate.ParamByName('SESSIONID').AsInteger := uSession.PK;
        CORE.qryNominate.ParamByName('SEEDDATE').AsDateTime := uNominate.GetSeedDate();
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


procedure TFrameNominate.Msg_SCM_Scroll_FilterMember(var Msg: TMessage);
begin
    UpdateQryNominate;
end;

procedure TFrameNominate.Msg_SCM_Scroll_Session(var Msg: TMessage);
begin
    UpdateQryNominate;
end;

procedure TFrameNominate.UpdateQryNominate;
begin
  if Assigned(SCM2) and SCM2.scmConnection.Connected
    and Assigned(CORE) and  CORE.IsActive then
  begin
    grid.BeginUpdate;
    CORE.qryNominate.DisableControls;
    try
      begin
        CORE.qryNominate.Close;
        CORE.qryNominate.ParamByName('MEMBERID').AsInteger := CORE.qryFilterMember.FieldByName('MemberID').AsInteger;
        CORE.qryNominate.ParamByName('SESSIONID').AsInteger := uSession.PK;
        CORE.qryNominate.ParamByName('SEEDDATE').AsDateTime := uNominate.GetSeedDate();
        CORE.qryNominate.Prepare;
        CORE.qryNominate.Open;
      end;
    finally
      CORE.qryNominate.EnableControls;
      grid.EndUpdate;
    end;
  end;
end;

end.
