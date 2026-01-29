unit NewVersioniRT.Model.Patch.ToJson;

interface
uses
  NewVersioniRT.Controller.Interfaces,
  System.JSON,
  System.Classes,
  System.SysUtils,
  Spring.Collections,
  System.Generics.Collections,
  NewVersioniRT.Model.Interfaces;


type
  TNewVersioniRTModelPatchToJson = class(TInterfacedObject , INewVersioniRTModelPatchToJson)
  strict private
    FEntity : INewVersioniRTControllerPatchEntity;
    FListEntity : IList<INewVersioniRTControllerPatchEntity>;
    FErrors : IList<string>;
    FConnection :  string;
  public
    procedure Entity(const AValue : INewVersioniRTControllerPatchEntity);
    procedure Connection(const AConnection : string);
    function Save: boolean;
    function Insert: boolean;
    function GetJsonPatch: string;
    function Load : IList<String>;
    constructor Create;
    class function New: INewVersioniRTModelPatchToJson;
  end;

implementation

uses
  Rest.Json,
  System.IOUtils,
  NewVersioniRT.Controller.Factory,
  NewVersioniRT.Controller.Patch.Entity,
  NewVersioniRT.Model.Factory,
  NewVersioniRT.model.Log,
  NewVersioniRT.Constants,
  System.Rtti;


{ TNewVersioniRTModelPatchToJson }

procedure TNewVersioniRTModelPatchToJson.Connection(const AConnection: string);
begin
  FConnection := AConnection;
end;

constructor TNewVersioniRTModelPatchToJson.Create;
begin
  FErrors := TCollections.CreateList<string>;
  FEntity := TNewVersioniRTControllerFactory.New.Entity;
  FListEntity := TCollections.CreateList<INewVersioniRTControllerPatchEntity>;
end;

procedure TNewVersioniRTModelPatchToJson.Entity(
  const AValue: INewVersioniRTControllerPatchEntity);
begin
  FEntity :=  AValue;
end;
//prova importazione dati da file json da utilizzare successivamente
function TNewVersioniRTModelPatchToJson.Load: IList<String>;
var
  LFileStream : TFileStream;
  LJsonStream : TStringStream;
  LList : IList<String>;
  LJsonValue : TJSONValue;
  LValori : TJSONArray;
  I : integer;
begin
  LJsonStream := TStringStream.Create;
  try
    LFileStream := TFileStream.create(FConnection + '\' + JSON_FILE_NAME, 0);
      try
        LJsonStream.LoadFromStream(LFileStream);
      finally
        LFileStream.Free;
      end;
    LJsonValue := TJSONObject.ParseJSONValue(LJsonStream.DataString);
    LList := TCollections.CreateList<string>;
    try
      LValori := LJsonValue.GetValue<TJSONArray>(PATCHES_ROOT_NAME);
      for I := 0 to LValori.count - 1 do
      LList.add(LValori.Items[I].GetValue<string>(COMMAND_PATCH_NAME));
      Result := LList;
    finally
    LjsonValue.free;
    end;
  finally
  LJsonStream.free;
  end;
end;
//restitutisce la patch json formattata
function TNewVersioniRTModelPatchToJson.GetJsonPatch: string;
var
  RootObject : TJSONObject;
  LJSONArray : TJSONArray;
  LTmpJson : TJSONValue;
  LEntity : INewVersioniRTControllerPatchEntity;
begin
  Result := '';
  if FListEntity.IsEmpty then
    exit;
  RootObject := TJSONObject.Create;
  try
    RootObject.AddPair(DATA_CREAZIONE_NAME, FListEntity[0].Created);
    RootObject.AddPair(DATABASE_TYPE_NAME, FEntity.DbType);
    LJSONArray := TJSONArray.Create;
    for LEntity in FListEntity  do
      LJSONArray.add(LEntity.ToJSON);
      RootObject.addpair(PATCHES_ROOT_NAME,LJSONArray);
      LTmpJson := TJSONObject.ParseJSONValue(RootObject.ToJSON);
      try
        Result := TJson.format(LTmpJson);
      finally
        LTmpJson.free;
      end;
  finally
  RootObject.free;
  end;
end;

//Inserisce la entity(patch) all'interno della lista
function TNewVersioniRTModelPatchToJson.Insert: boolean;
var
  LEntity : INewVersioniRTControllerPatchEntity;
  LGUID : TGUID;
begin
  try
  CreateGUID(LGUID);
  FEntity.PatchId(LGUID);
  FEntity.Created(FormatDateTime(FORMAT_DATE_JSON,now));
  LEntity := TNewVersioniRTControllerFactory.New.Entity;
  LEntity.CopyEntity(FEntity);
  FListEntity.add(LEntity);
  except
      on e : Exception do
      begin
        Result := False;
        FErrors.add(e.message);
      end;
  end;
  Result := True;
end;

//Salva il file json contentente le varie patch
function TNewVersioniRTModelPatchToJson.Save: boolean;
var
  LPatchJson : string;
begin
  try
    LPatchJson := GetJsonPatch;
    Tfile.WriteAllText(FConnection + '\' + JSON_FILE_NAME, LPatchJson);
  except
    on e: Exception do
    begin
        Result := False;
        FErrors.add(e.Message);
    end;
  end;
  Result := true;
end;

class function TNewVersioniRTModelPatchToJson.New: INewVersioniRTModelPatchToJson;
begin
  Result := Self.Create;
end;

end.
