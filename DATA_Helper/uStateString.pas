unit uStateString;

{
  // Example of StateString.
'13#20,42,220,90,90,90,39,39,0,0,0,0,0#0,1,2,3,4,5,6,7,8,9,10,11,12#1,1,1,1,1,1,1,1,1,1,1,1,1'

  SYNTAX READS:
  13 total number of columns
  # -> column width... linked to column order
  # -> column display column order...
  # -> column visibility... ignored by TMS TDBAdvGrid - uses DB field.visibility.
}

interface
uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Actions,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.Grids, Vcl.ImgList, Vcl.ActnList, Vcl.Menus, Vcl.Buttons,
  Vcl.ActnMan,

  Data.DB,

  AdvUtil, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,

  dmIMG, dmSCM2, dmCORE, uDefines, uSettings, Vcl.StdCtrls;

type


  TStateString = class(TObject)

  private
    // Extraction of TMS GRID 'ColumnStateString' - contains 4 parts
    // Column-count[0], width[1], sort-order[2] and visibility [3]
    fParts: TArray<string>;

    fColWidth: TArray<Integer>; // StateString widths. Uses sort-order
    fColOrder: TArray<Integer>; // StateString column order. Base 0.
    fColVisible: TArray<Integer>; // String value '0' or '1'. Ignored in TDBAdvGrid.


    fColCount: integer;
    fErrorCode: integer;
    fStateString: string;

    function StringToIntList(const Values: string): TArray<Integer>;
    procedure SetOrder(FromIndex, ToIndex: integer);

  protected
    procedure Disassemble(AStateString: string);
    function Assemble(AStringState: string): string;
    procedure Prepare();
    procedure SetStateString(Value: string);

  public
    constructor Create;
    destructor Destroy; override;
    procedure ColumnMove(FromIndex, ToIndex: integer);
    procedure SetColVisible(ABSindex: integer; visible: boolean);
    procedure SetColWidth(ABSindex: integer; width: integer);

    function GetColWidth(ABSindex: integer): integer; overload;
    function GetColWidth(ABSindex: integer; AStateString: string): integer; overload;
    function LookUpREFindex(ABSindex: integer): integer;

  published
    property StateString: string read fStateString write SetStateString;
    property ErrorCode: integer read fErrorCode;

  end;


implementation

function TStateString.Assemble(AStringState: string): string;
var
  s1, s2, s3: string;
  I: integer;
begin
  result := '';
  // Re-Assemble parts, comma delimeter string
  s1 := '';
  s2 := '';
  for I := 0 to fColCount - 1 do
  begin
    s1 := s1 + IntToStr(fColWidth[I]) + ',';
    s2 := s2 + IntToStr(fColOrder[I]) + ',';
    s3 := s3 + IntToStr(fColVisible[I]) + ',';
  end;
  s1 := s1.TrimRight([',']);
  s2 := s2.TrimRight([',']);
  s3 := s3.TrimRight([',']);

  fParts[1] := s1;
  fParts[2] := s2;
  fParts[3] := s3;

  Result := string.Join('#', fParts);

end;


procedure TStateString.ColumnMove(FromIndex, ToIndex: integer);
begin
  if FromIndex=ToIndex then exit;
  if fStateString.IsEmpty then  exit;
  { dereference if required by using
    ReferenceIndex := LookUpREFindex(FromIndex);}
  SetOrder(FromIndex, ToIndex);
end;

constructor TStateString.Create;
begin
  inherited;
  // TODO -cMM: TStateString.Create default body inserted
  fErrorCode := -1;
  fStateString:='';
end;

destructor TStateString.Destroy;
begin
  // TODO -cMM: TStateString.Destroy default body inserted
  inherited;
end;

procedure TStateString.Disassemble(AStateString: string);
begin
  fParts := AStateString.Split(['#']);
  if Length(fParts) < 4 then
  begin
    fErrorCode := 1;
    SetLength(fColWidth, 0);
    SetLength(fColOrder, 0);
    SetLength(fColVisible, 0);
    Exit;
  end;

  fColCount := StrToIntDef(Trim(fParts[0]), 0);
  if (fColCount = 0) then
  begin
    fErrorCode := 2;
    SetLength(fColWidth, 0);
    SetLength(fColOrder, 0);
    SetLength(fColVisible, 0);
    Exit;
  end;

  fColWidth := StringToIntList(fParts[1]);
  fColOrder := StringToIntList(fParts[2]);
  fColVisible := StringToIntList(fParts[3]);

  fErrorCode := -1;

end;

function TStateString.GetColWidth(ABSindex: integer; AStateString: string): integer;
var
  REFindex: integer;
begin
  result := 0;
  REFindex := LookUpREFindex(ABSindex);
  if REFindex <> -1 then
  begin
    Disassemble(AStateString); // tempory state string.
    result := fColWidth[REFindex]; // lookup tempory state string
    Disassemble(fStateString); // restore state.
  end;
end;

function TStateString.GetColWidth(ABSindex: integer): integer;
var
  REFindex: integer;
begin
  result := 0;
  REFindex := LookUpREFindex(ABSindex);
  if REFindex <> -1 then
    result := fColWidth[REFindex];
end;

function TStateString.LookUpREFindex(ABSindex: integer): integer;
var
  I: Integer;
begin
  result := -1;
  for I := 0 to High(fColOrder) do
  begin
    if fColOrder[I] = ABSindex then
    begin
      result := I;
      break;
    end;
  end;
end;

procedure TStateString.Prepare();
begin
  if not fStateString.IsEmpty then
    Disassemble(fStateString)
  else
    fErrorCode := 0;
end;

procedure TStateString.SetOrder(FromIndex, ToIndex: integer);
var
  Value: integer;
begin
  { absolute grid indexes used here }
  if (FromIndex >= 0) and (FromIndex <= High(fColOrder))
    and (ToIndex >= 0) and (ToIndex <= High(fColOrder))  then
  begin
    Value := fColOrder[FromIndex];
    Delete(fColOrder, FromIndex, 1); // delete 1 item at FromIndex.
    Insert([Value],fColOrder, ToIndex); // src, dest, FromIndex

    Value := fColVisible[FromIndex];
    Delete(fColVisible, FromIndex, 1); // delete 1 item at FromIndex.
    Insert([Value],fColVisible, ToIndex); // src, dest, FromIndex

    Value := fColWidth[FromIndex];
    Delete(fColWidth, FromIndex, 1); // delete 1 item at FromIndex.
    Insert([Value],fColWidth, ToIndex); // src, dest, FromIndex

  end;
end;

procedure TStateString.SetColVisible(ABSindex: integer; visible: boolean);
var
  REFIndex: integer;
begin
  if (ABSindex >= 0) and (ABSindex <= fColCount) then
  begin
    { ASSUME: ABSindex is absolute refernce to dbo.qryLane.Fields[ABSindex]  }
    REFIndex := LookUpREFindex(ABSindex);
    { setting the visibility in a TMS ColumnStatesString has no effect
      when using a TDBAdvGrid. }
    fColVisible[REFIndex] := visible.ToInteger;
    fColWidth[REFIndex] := 0;
  end;
end;

procedure TStateString.SetColWidth(ABSindex, width: integer);
var
  REFIndex: integer;
begin
  if (ABSindex >= 0) and (ABSindex <= fColCount) and (width >= 0)then
  begin
    REFIndex := LookUpREFindex(ABSindex);
    { setting the visibility in a TMS ColumnStatesString has no effect
      when using a TDBAdvGrid. }
    fColWidth[REFIndex] := width;
    if width = 0 then
      fColVisible[REFIndex] := 0 else fColVisible[REFIndex] := 1;
  end;
end;

function TStateString.StringToIntList(const Values: string): TArray<Integer>;
var
  Parts: TArray<string>;
  i: Integer;
begin
  Parts := Values.Split([',']);
  SetLength(Result, Length(Parts));
  for i := 0 to High(Parts) do
    Result[i] := StrToIntDef(Trim(Parts[i]), 0);
end;

procedure TStateString.SetStateString(Value: string);
begin
  fStateString := Value;
  Prepare();
end;

end.
