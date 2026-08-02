unit uExportDivisionToJSON;

interface

uses
  System.Classes, System.SysUtils, System.JSON, Data.DB, Data.SqlExpr,
  System.Generics.Collections,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client

  ;

type
  TDivisionRecord = record
    DivisionID: Integer;
    DivisionTypeID: Integer;
    Caption: string;
    AgeFrom: Integer;
    AgeTo: Integer;
    GenderID: Integer;
  end;

  TGenderGroup = record
    GenderID: Integer;
    Records: TArray<TDivisionRecord>;
  end;

  TDivisionTypeGroup = record
    DivisionTypeID: Integer;
    Genders: TArray<TGenderGroup>;
  end;

  TDivisionExporter = class
  private
    FSQLQuery: TFDQuery;
    FDivisionTypeCaptionMap: TDictionary<Integer, string>;
    FGenderCaptionMap: TDictionary<Integer, string>;

    procedure LoadCaptionMaps;
    function FindOrCreateDivisionType(var Groups: TArray<TDivisionTypeGroup>;
      DivisionTypeID: Integer): Integer;
    function FindOrCreateGender(var Genders: TArray<TGenderGroup>;
      GenderID: Integer): Integer;
    function CreateHierarchicalJSON(const Groups: TArray<TDivisionTypeGroup>): string;
    function RecordToJSONObject(const Rec: TDivisionRecord): TJSONObject;
  public
    constructor Create(ASQLQuery: TFDQuery);
    destructor Destroy; override;
    function ExportToJSONStringList: TStringList;
  end;

implementation

{ TDivisionExporter }

constructor TDivisionExporter.Create(ASQLQuery: TFDQuery);
begin
  inherited Create;
  FSQLQuery := ASQLQuery;
  FDivisionTypeCaptionMap := TDictionary<Integer, string>.Create;
  FGenderCaptionMap := TDictionary<Integer, string>.Create;
  LoadCaptionMaps;
end;

destructor TDivisionExporter.Destroy;
begin
  FDivisionTypeCaptionMap.Free;
  FGenderCaptionMap.Free;
  FSQLQuery := nil;
  inherited;
end;

procedure TDivisionExporter.LoadCaptionMaps;
begin
  // Load from lookup tables or hardcode
  FDivisionTypeCaptionMap.Add(1, 'Age Group');
  FDivisionTypeCaptionMap.Add(2, 'Open');

  FGenderCaptionMap.Add(1, 'Male');
  FGenderCaptionMap.Add(2, 'Female');
  FGenderCaptionMap.Add(3, 'Mixed');
end;

function TDivisionExporter.FindOrCreateDivisionType(
  var Groups: TArray<TDivisionTypeGroup>;
  DivisionTypeID: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Length(Groups) - 1 do
  begin
    if Groups[i].DivisionTypeID = DivisionTypeID then
    begin
      Result := i;
      Exit;
    end;
  end;

  // Not found, create new
  SetLength(Groups, Length(Groups) + 1);
  Result := High(Groups);
  Groups[Result].DivisionTypeID := DivisionTypeID;
  SetLength(Groups[Result].Genders, 0);
end;

function TDivisionExporter.FindOrCreateGender(
  var Genders: TArray<TGenderGroup>;
  GenderID: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Length(Genders) - 1 do
  begin
    if Genders[i].GenderID = GenderID then
    begin
      Result := i;
      Exit;
    end;
  end;

  // Not found, create new
  SetLength(Genders, Length(Genders) + 1);
  Result := High(Genders);
  Genders[Result].GenderID := GenderID;
  SetLength(Genders[Result].Records, 0);
end;

function TDivisionExporter.RecordToJSONObject(const Rec: TDivisionRecord): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('DivisionID', TJSONNumber.Create(Rec.DivisionID));
  Result.AddPair('Caption', Rec.Caption);
  Result.AddPair('AgeFrom', TJSONNumber.Create(Rec.AgeFrom));
  Result.AddPair('AgeTo', TJSONNumber.Create(Rec.AgeTo));
  Result.AddPair('GenderID', TJSONNumber.Create(Rec.GenderID));
end;

function TDivisionExporter.CreateHierarchicalJSON(
  const Groups: TArray<TDivisionTypeGroup>): string;
var
  RootObj, DivisionTypeObj, GenderObj: TJSONObject;
  RootArray, GendersArray, RecordsArray: TJSONArray;
  DivisionTypeCaption, GenderCaption: string;
  i, j, k: Integer;
begin
  RootObj := TJSONObject.Create;
  try
    RootArray := TJSONArray.Create;
    RootObj.AddPair('DivisionTypes', RootArray);

    // Groups are already sorted by DivisionTypeID from the index
    for i := 0 to Length(Groups) - 1 do
    begin
      DivisionTypeObj := TJSONObject.Create;
      DivisionTypeObj.AddPair('DivisionTypeID', TJSONNumber.Create(Groups[i].DivisionTypeID));

      if FDivisionTypeCaptionMap.TryGetValue(Groups[i].DivisionTypeID, DivisionTypeCaption) then
        DivisionTypeObj.AddPair('DivisionTypeCaption', DivisionTypeCaption)
      else
        DivisionTypeObj.AddPair('DivisionTypeCaption', 'Unknown');

      // Genders are already sorted by GenderID from the index
      GendersArray := TJSONArray.Create;
      DivisionTypeObj.AddPair('Genders', GendersArray);

      for j := 0 to Length(Groups[i].Genders) - 1 do
      begin
        GenderObj := TJSONObject.Create;
        GenderObj.AddPair('GenderID', TJSONNumber.Create(Groups[i].Genders[j].GenderID));

        if FGenderCaptionMap.TryGetValue(Groups[i].Genders[j].GenderID, GenderCaption) then
          GenderObj.AddPair('GenderCaption', GenderCaption)
        else
          GenderObj.AddPair('GenderCaption', 'Unknown');

        // Records are already sorted by AgeFrom (and then DivisionID) from the index
        // No sorting needed in code!
        RecordsArray := TJSONArray.Create;
        GenderObj.AddPair('Records', RecordsArray);

        for k := 0 to Length(Groups[i].Genders[j].Records) - 1 do
        begin
          RecordsArray.Add(RecordToJSONObject(Groups[i].Genders[j].Records[k]));
        end;

        GendersArray.Add(GenderObj);
      end;

      RootArray.Add(DivisionTypeObj);
    end;

    Result := RootObj.ToString;
  finally
    RootObj.Free;
  end;
end;

function TDivisionExporter.ExportToJSONStringList: TStringList;
var
  DivisionTypeGroups: TArray<TDivisionTypeGroup>;
  DivisionRec: TDivisionRecord;
  DivisionTypeIdx, GenderIdx: Integer;
  JSONString: string;
  LastDivisionTypeID, LastGenderID: Integer;
begin
  Result := TStringList.Create;

  try
    SetLength(DivisionTypeGroups, 0);

    if not FSQLQuery.Active then
      FSQLQuery.Open;

    // Apply the index for presorted data
    // The index 'indxJSON' sorts by DivisionTypeID, GenderID, AgeFrom
    if (FSQLQuery.IndexName <> 'indxJSON') then
      FSQLQuery.IndexName := 'indxJSON';

    // Initialize tracking variables
    LastDivisionTypeID := -1;
    LastGenderID := -1;

    if FSQLQuery.RecordCount > 0 then
    begin
      FSQLQuery.First;
      while not FSQLQuery.Eof do
      begin
        // Read record
        DivisionRec.DivisionID := FSQLQuery.FieldByName('DivisionID').AsInteger;
        DivisionRec.DivisionTypeID := FSQLQuery.FieldByName('DivisionTypeID').AsInteger;
        DivisionRec.Caption := FSQLQuery.FieldByName('Caption').AsString;
        DivisionRec.AgeFrom := FSQLQuery.FieldByName('AgeFrom').AsInteger;
        DivisionRec.AgeTo := FSQLQuery.FieldByName('AgeTo').AsInteger;
        DivisionRec.GenderID := FSQLQuery.FieldByName('GenderID').AsInteger;

        // Find or create DivisionType
        DivisionTypeIdx := FindOrCreateDivisionType(DivisionTypeGroups, DivisionRec.DivisionTypeID);

        // Find or create Gender within DivisionType
        GenderIdx := FindOrCreateGender(
          DivisionTypeGroups[DivisionTypeIdx].Genders,
          DivisionRec.GenderID);

        // Add record directly to Gender's Records array
        // Records will naturally be in AgeFrom order due to the index
        SetLength(DivisionTypeGroups[DivisionTypeIdx].Genders[GenderIdx].Records,
          Length(DivisionTypeGroups[DivisionTypeIdx].Genders[GenderIdx].Records) + 1);
        DivisionTypeGroups[DivisionTypeIdx].Genders[GenderIdx].Records[
          High(DivisionTypeGroups[DivisionTypeIdx].Genders[GenderIdx].Records)] := DivisionRec;

        FSQLQuery.Next;
      end;
    end;

    JSONString := CreateHierarchicalJSON(DivisionTypeGroups);
    Result.Text := JSONString;

  except
    on E: Exception do
    begin
      Result.Free;
      raise Exception.Create('Error exporting data to JSON: ' + E.Message);
    end;
  end;
end;

end.
