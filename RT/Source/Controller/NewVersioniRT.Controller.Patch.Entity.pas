unit NewVersioniRT.Controller.Patch.Entity;

interface

uses NewVersioniRT.Controller.Interfaces,
  NewVersioniRT.Controller.Attributes,
  System.JSON,
  System.Classes,
  Rest.Json,
  Spring.Collections,
  System.Rtti;

type
  TNewVersioniRTControllerPatchEntity = class(TInterfacedObject, INewVersioniRTControllerPatchEntity)
  strict private
    [EntityField]
    FCreated: string;
    [EntityField]
    [Required]
    FDbType: string;
    [EntityField]
    FID: Integer;
    [EntityField]
    [Required]
    FDescription: string;
    [EntityField]
    [Required]
    FCommand: string;
    [EntityField]
    FExistCommand : string;
    [EntityField]
    [Required]
    FPatchId: TGUID;
  private
    function ValidateRequired(
      const AField : TRttiField ;
      const AAttributes : TCustomAttribute;
      out AErrorMessage : string) : boolean;
  public
    constructor Create;
    function Created : string; overload;
    procedure Created(const AValue : string); overload;
    function DbType : string; overload;
    procedure DbType(const AValue: string); overload;
    function ID : Integer; overload;
    procedure ID(const AValue : Integer); overload;
    function Description : string; overload;
    procedure Description(const AValue: string); overload;
    function Command : string; overload;
    procedure Command(const AValue: string); overload;
    function ExistCommand : string; overload;
    procedure ExistCommand(const AValue : string); overload;
    function PatchId : TGUID; overload;
    procedure PatchId(const Avalue : TGUID); overload;
    function ToJSON : TJsonObject;
    function Validate(out AErrorMessage : string) : Boolean;
    function CopyEntity(
    AEntity :INewVersioniRTControllerPatchEntity
    ) : INewVersioniRTControllerPatchEntity;
    class function New: TNewVersioniRTControllerPatchEntity;
  end;

implementation

uses
  System.SysUtils,
  NewVersioniRT.Messages,
  NewVersioniRT.Constants;


{ TNewVersioniRTControllerPatchEntity }
constructor TNewVersioniRTControllerPatchEntity.Create;
begin
  FCommand := EmptyStr;
  FCreated := EmptyStr;
  FDescription := EmptyStr;
  FDbType := EmptyStr;
  FID := 0;
end;

function TNewVersioniRTControllerPatchEntity.Command: string;
begin
  Result := FCommand;
end;

procedure TNewVersioniRTControllerPatchEntity.Command(const AValue: string);
begin
  FCommand := AValue;
end;

function TNewVersioniRTControllerPatchEntity.Created: string;
begin
  Result := FCreated;
end;

procedure TNewVersioniRTControllerPatchEntity.Created(const AValue: string);
begin
  FCreated := AValue;
end;

function TNewVersioniRTControllerPatchEntity.Description: string;
begin
  Result := FDescription;
end;

procedure TNewVersioniRTControllerPatchEntity.Description(const AValue: string);
begin
  FDescription := Avalue;
end;

procedure TNewVersioniRTControllerPatchEntity.ExistCommand(
  const AValue: string);
begin
  FExistCommand := Avalue;
end;

function TNewVersioniRTControllerPatchEntity.ExistCommand: string;
begin
  Result := FExistCommand;

end;

function TNewVersioniRTControllerPatchEntity.DbType: string;
begin
  Result := FDbType;
end;

procedure TNewVersioniRTControllerPatchEntity.DbType(const AValue: string);
begin
  FDbType:= AValue;
end;

function TNewVersioniRTControllerPatchEntity.ID: Integer;
begin
  Result := FID;
end;

procedure TNewVersioniRTControllerPatchEntity.ID(const AValue: Integer);
begin
  FID := AValue;
end;

class function TNewVersioniRTControllerPatchEntity.New: TNewVersioniRTControllerPatchEntity;
begin
  Result := Self.Create;
end;

function TNewVersioniRTControllerPatchEntity.PatchId: TGUID;
begin
  Result := FPatchId;
end;

procedure TNewVersioniRTControllerPatchEntity.PatchId(const Avalue: TGUID);
begin
  FPatchId := Avalue;
end;

function TNewVersioniRTControllerPatchEntity.CopyEntity(
  AEntity :INewVersioniRTControllerPatchEntity) : INewVersioniRTControllerPatchEntity;
var
  LContext : TRttiContext;
  LField : TRttiField;
begin
for LField in LContext.GetType(Self.ClassType).GetFields do
  begin
    for var LAttributes in LField.GetAttributes do
    begin
        if LAttributes is EntityField then
          LField.SetValue(Self,LField.GetValue(AEntity as TNewVersioniRTControllerPatchEntity));
    end;
  end;
end;

function TNewVersioniRTControllerPatchEntity.ToJSON: TJsonObject;
begin
//  Result := Rest.Json.TJson.ObjectToJsonString(Self);
  Result := TJSONObject.Create;
  Result.AddPair(ID_PATCH_ADT_NAME, FID);
  Result.AddPair(DESCRIPTION_PATCH_NAME, FDescription);
  Result.AddPair(COMMAND_PATCH_NAME, FExistCommand);
  Result.AddPair(ID_PATCH_NAME, FPatchId.ToString);
end;

function TNewVersioniRTControllerPatchEntity.Validate(
  out AErrorMessage : string): Boolean;
var
  LField : TRttiField;
  LContext : TRttiContext;
  LAttributes : TCustomAttribute;
  LErrorMessage : string;
begin
  Result := True;
 for LField in LContext.GetType(Self.ClassType).GetFields do
  begin
    for LAttributes in LField.GetAttributes do
    begin
      if not ValidateRequired(LField, LAttributes, LErrorMessage) then
      begin
        Result := False;
        AErrorMessage := LErrorMessage + sLineBreak + AErrorMessage;
      end;
    end;
  end;

 end;

function TNewVersioniRTControllerPatchEntity.ValidateRequired(
  const AField: TRttiField;
  const AAttributes: TCustomAttribute;
  out AErrorMessage : string) : boolean;
begin
  AErrorMessage := EmptyStr;
  Result := true;
  if AAttributes is NewVersioniRT.Controller.Attributes.Required then
    begin
      case AField.FieldType.TypeKind of
        tkInteger, tkInt64:
        begin
          Result := (AField.GetValue(Self).AsInteger > 0);
        end;
        tkString, tkLString, tkUString, tkWideString:
        begin
          Result := not (AField.GetValue(self).AsString.IsEmpty);
        end;

      end;
          if not Result then
   AErrorMessage := format(RS_NEWVERSIONI_FIELD_REQUIRED, [Afield.Name]);
  end;
end;

end.
