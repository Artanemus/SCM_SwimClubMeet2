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


  TStateString = record

  private
    // Extraction of TMS GRID 'ColumnStateString' - contains 4 parts
    // Column-count[0], width[1], sort-order[2] and visibility [3]
    fParts: TArray<string>;
    fColWidth: TArray<Integer>;
    fColOrder: TArray<Integer>;
    fColVisible: TArray<Integer>; // 0 or 1.

    fColCount: integer;
    fErrorCode: integer;
    fValue: string;

    function StringToIntList(const Values: string): TArray<Integer>;
    procedure MoveOrder(FromIndex, ToIndex: integer);
    procedure Disassemble;
    function Assemble: string;
    procedure SetValue(Value: string);
    function GetValue(): string;
    function GetErrorMessage(): string;

  public
    procedure MoveColOrder(FromIndex, ToIndex: integer);
    // Setters.
    procedure SetColWidth(index, width: integer);

    // Getters.
    { returns -1 (error) else width.}
    function GetColWidth(index: integer): integer;
    { returns tri-state -1 unknown (error), 0 false, 1 true}
    function GetColVisible(index: integer): integer;
    { returns -1 else the number at index.}
    function GetColOrder(index: integer): integer;

    class operator Implicit(const AValue: string): TStateString;
    class operator Explicit(const AValue: TStateString): string;
    class operator Initialize(out Dest: TStateString);

  public
    property Value: string read GetValue write SetValue;
    property ErrorCode: integer read fErrorCode;
    property ErrorCodeMsg: string read GetErrorMessage;
    property ColCount: Integer read FColCount;

  end;

  const
  ERR_CODE_SUCCESS = 0;
  ERR_CODE_RANGE_CHECK_FAILED = 1;
  ERR_CODE_BAD_PARTS_COUNT = 2;
  ERR_CODE_BAD_STATE_STRING = 3;
  
  ERR_MSG_SUCCESS = 'No error';
  ERR_MSG_RANGE_CHECK_FAILED = 'Column index range check failed.';
  ERR_MSG_BAD_PARTS_COUNT = 'State string''s parts count failed.';
  ERR_MSG_BAD_STATE_STRING = 'Badly formatted state string.';



implementation

class operator TStateString.Implicit(const AValue: string): TStateString;
begin
  Result.fValue := AValue;
  Result.Disassemble;
end;

class operator TStateString.Initialize(out Dest: TStateString);
begin
  Dest.fErrorCode := ERR_CODE_SUCCESS;
  Dest.fValue := '';
end;

class operator TStateString.Explicit(const AValue: TStateString): string;
begin
  { best coding practice is not to use this explicit assignment but
    rather use TStateString.Value as it shows intent.}
  Result := AValue.Assemble();
end;

function TStateString.GetErrorMessage: string;
begin
  case fErrorCode of
    ERR_CODE_SUCCESS: Result := ERR_MSG_SUCCESS;
    ERR_CODE_RANGE_CHECK_FAILED: Result := ERR_MSG_RANGE_CHECK_FAILED;
    ERR_CODE_BAD_PARTS_COUNT: Result := ERR_MSG_BAD_PARTS_COUNT;
    ERR_CODE_BAD_STATE_STRING: Result := ERR_MSG_BAD_STATE_STRING;
  else
    Result := 'Unknown error code: ' + IntToStr(ErrorCode);
  end;
end;

function TStateString.Assemble: string;
var
  s1, s2, s3: string;
  I: integer;
begin
  result := '';
  // Re-Assemble parts, comma delimeter string
  s1 := '';
  s2 := '';

  // check array length
  if (Length(fColWidth) <> fColCount)
    or (Length(fColOrder) <> fColCount)
        or (Length(fColVisible) <> fColCount) then
    fErrorCode := ERR_CODE_RANGE_CHECK_FAILED
  else
  begin
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

    fErrorCode := ERR_CODE_SUCCESS;
  end;

end;

procedure TStateString.MoveColOrder(FromIndex, ToIndex: integer);

begin
  if FromIndex=ToIndex then exit;
  if fValue.IsEmpty then exit;
  if (FromIndex = -1)  or (ToIndex = -1) then
  begin
    fErrorCode := ERR_CODE_RANGE_CHECK_FAILED;
    exit;
  end
  else
  begin
    MoveOrder(FromIndex, ToIndex);
    fErrorCode := ERR_CODE_SUCCESS;
  end;
end;

procedure TStateString.Disassemble;
begin
  if fValue.IsEmpty then exit;

  fParts := fValue.Split(['#']);
  if Length(fParts) < 4 then
  begin
    fErrorCode := ERR_CODE_BAD_PARTS_COUNT;
    SetLength(fColWidth, 0);
    SetLength(fColOrder, 0);
    SetLength(fColVisible, 0);
    Exit;
  end;

  fColCount := StrToIntDef(Trim(fParts[0]), 0);
  if (fColCount = 0) then
  begin
    fErrorCode := ERR_CODE_RANGE_CHECK_FAILED;
    SetLength(fColWidth, 0);
    SetLength(fColOrder, 0);
    SetLength(fColVisible, 0);
    Exit;
  end;

  fColWidth := StringToIntList(fParts[1]);
  fColOrder := StringToIntList(fParts[2]);
  fColVisible := StringToIntList(fParts[3]);

  fErrorCode := ERR_CODE_SUCCESS;

end;

function TStateString.GetValue: string;
begin
  fValue := Assemble();
  result := fValue;
end;

function TStateString.GetColOrder(index: integer): integer;
begin
  result := -1;
  if (index>=LOW(fColOrder)) and (index <= HIGH(fColOrder)) then
    result := fColOrder[index];
end;

function TStateString.GetColVisible(index: integer): integer;
begin
  result := -1;
  if (index>=LOW(fColVisible)) and (index <= HIGH(fColVisible)) then
    result := fColVisible[index];
end;

function TStateString.GetColWidth(index: integer): integer;
begin
  result := -1;
  if (index >= LOW(fColWidth)) and (index <= HIGH(fColWidth)) then
    result := fColWidth[index];
end;

procedure TStateString.MoveOrder(FromIndex, ToIndex: integer);
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

//    Value := fColVisible[FromIndex];
//    Delete(fColVisible, FromIndex, 1); // delete 1 item at FromIndex.
//    Insert([Value],fColVisible, ToIndex); // src, dest, FromIndex

    Value := fColWidth[FromIndex];
    Delete(fColWidth, FromIndex, 1); // delete 1 item at FromIndex.
    Insert([Value],fColWidth, ToIndex); // src, dest, FromIndex

  end;
end;

procedure TStateString.SetColWidth(index, width: integer);
begin
  if (index>=LOW(fColOrder)) and (index <= HIGH(fColOrder)) then
  begin
      { a width of 0 indicates that the column is hidden. }
      fColWidth[Index] := width;
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

procedure TStateString.SetValue(Value: string);
begin
  fValue := Value;
  Disassemble;
end;

end.
