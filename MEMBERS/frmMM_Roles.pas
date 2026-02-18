unit frmMM_Roles;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.DBCtrls, Vcl.VirtualImage,
  frFrameMM_ListMember;

type
  TMM_Roles = class(TForm)
    btnInfoRoles: TVirtualImage;
    DBNavigator2: TDBNavigator;
    Label6: TLabel;
    DBGridRole: TDBGrid;
    pnlHeader: TPanel;
    pnlList: TPanel;
    TFrameMM_ListMember1: TFrameMM_ListMember;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MM_Roles: TMM_Roles;

implementation

{$R *.dfm}


{
procedure TManageMember.DBGridRoleEditButtonClick(Sender: TObject);
var
  fld: TField;
  dlg: TscmDatePicker;
  mrRtn: TModalResult;
begin
  // handle the ellipse button for TDateTime entry...
  fld := TDBGrid(Sender).SelectedField;
  if not assigned(fld) then
    exit;
  if (fld.FieldName = 'ElectedOn') OR (fld.FieldName = 'RetiredOn') then
  begin
    dlg := TscmDatePicker.Create(Self);
    mrRtn := dlg.ShowModal; // open DATE PICKER ...
    if (mrRtn = mrOk) then
    begin
      DateTimeToSystemTime(dlg.CalendarView1.Date, fSystemTime);
      if (fld.FieldName = 'ElectedOn') then
        PostMessage(MM_CORE.Handle, SCM_MEMBER_UPDATE_ELECTEDON,
          longint(@fSystemTime), 0)
      else
        PostMessage(MM_CORE.Handle, SCM_MEMBER_UPDATE_RETIREDON,
          longint(@fSystemTime), 0);
    end;
    dlg.Free;
  end;
end;


procedure TManageMember.DBGridGenericKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  fld: TField;
begin
  if (Key = VK_BACK) and (ssAlt in Shift) then
  BEGIN
    with Sender as TDBGrid do
    Begin
      DataSource.DataSet.DisableControls;
      fld := TDBGrid(Sender).SelectedField;
      if assigned(fld) then
      BEGIN
        // if the query is not in edit mode
        if (DataSource.DataSet.State <> dsEdit) or
          (DataSource.DataSet.State <> dsInsert) then
          DataSource.DataSet.Edit;
        // D B G r i d R o l e  ...
        if (fld.FieldName = 'ElectedOn') or (fld.FieldName = 'RetiredOn') then
          fld.Clear;
        // D B G r i d C o n t a c t I n f o ...
        if (fld.FieldName = 'luContactNumType') then
          fld.Clear;
      end;
      DataSource.DataSet.EnableControls;
      // signal finished with key;
      Key := 0;
    END;
  END;
end;

procedure TManageMember.btnInfoRolesClick(Sender: TObject);
var
  s: string;
begin
  BalloonHint1.Title := 'Membership Roles.';
  s := '''
    To enter a start or end date, select the cell, then
    press the ellipse button. A date picker will appear.
    To clear a selected cell, press CTRL-BACKSPACE.
    To delete a record, press CTRL-DEL.
    ''';
  BalloonHint1.Description := s;
  BalloonHint1.ShowHint(btnInfoRoles);
end;

}

end.
