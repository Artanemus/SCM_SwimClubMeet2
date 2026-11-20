unit uReport;

interface

uses
  System.SysUtils, System.IOUtils;

/// <summary>
/// Returns the full path to the report template file, or '' if not found.
/// Search order: next to the exe, then (DEBUG only) the project folder.
/// </summary>
function GetRPTTemplatePath: string;

implementation

const
  TemplateDirName = 'RPT_TEMPLATES';
  TemplateFileName = 'Base_v1.fr3';

function GetRPTTemplatePath: string;
var
  Candidate: string;
begin
  // 1) Next to the executable (the deployed layout)
  Candidate := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)),
    TPath.Combine(TemplateDirName, TemplateFileName));
  if FileExists(Candidate) then
    Exit(Candidate);

{$IFDEF DEBUG}
  // 2) Dev fallback: relative to the project folder (IDE default CWD)
  Candidate := ExpandFileName(TPath.Combine('..', TPath.Combine(TemplateDirName,
    TemplateFileName)));
  if FileExists(Candidate) then
    Exit(Candidate);
{$ENDIF}

  Result := '';
end;

end.

