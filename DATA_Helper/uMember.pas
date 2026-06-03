unit uMember;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils,
  System.Variants, System.VarUtils,
  System.StrUtils,
  VCL.Dialogs, Vcl.ActnList,

  Data.DB,

  FireDAC.Comp.Client, FireDAC.Stan.Param,

  dmCORE, dmSCM2, uDefines;

function CountMembers: integer;


implementation

uses uSwimClub;

function CountMembers: integer;
var
  SQL: string;
  v: variant;
begin
  result := 0;
  // Count the total number of  Members for the current selected club ....
  SQL := 'SELECT Count(MemberLinkID) FROM SwimClubMeet2.dbo.MemberLink WHERE MemberLink.HeatID = :ID';
  v := SCM2.scmConnection.ExecSQLScalar(SQL, [uSwimClub.PK]);
  if not VarIsNull(v) or not VarIsEmpty(v) then result := v;
end;

end.
