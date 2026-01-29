unit NewVersioniRT.Controller.Config.Entity;

interface

uses
  NewVersioniRT.Controller.Interfaces,
  NewVersioniRT.controller.Attributes,
  Spring.Collections,
  System.Rtti;

type
{$SCOPEDENUMS ON}
  TState = (None, Selected, Deleted, Modified);
{$SCOPEDENUMS OFF}


type
  TNewVersioniRTControllerConfigPath = class(TInterfacedObject, INewVersioniRTControllerConfigPath)
  strict private
    [Required]
    FJsonDir : string;
    [Required]
    FLogDir : string;
  private
    constructor Create;
////    function ValidateRequired (const AField: TRttiField;
//      const AAttributes: TCustomAttribute;
//      out AErrorMessage : string) : boolean;
  public
    function JsonDir : string; overload;
    procedure JsonDir(const AValue : string); overload;
    function LogDir : string; overload;
    procedure LogDir(const Avalue : string); overload;
//    function Validate (out AErrorlist :IList<String> ) : boolean;
  end;



type
  TNewVersioniRTControllerConfigDB = class(TInterfacedObject , INewVersioniRTControllerConfigDb)
   strict private
    FServer : string;
    FDataBase : string;
    FNomeUtente : string;
    FPassword : string;
  private
    constructor Create;
  public
    function Server : string; overload;
    procedure Server(const AValue : string); overload;
    function Database : string; overload;
    procedure Database(const AValue : string); overload;
    function NomeUtente : string; overload;
    procedure NomeUtente(const AValue : string); overload;
    function Password : string; overload;
    procedure Password(const AValue : string) ; overload;
  end;



type
  TNewVersioniRTControllerConfigEntity = class(TInterfacedObject, INewVersioniRTControllerConfigEntity)
  strict private
    FPath : INewVersioniRTControllerConfigPath;
    FDataBaseAz : INewVersioniRTControllerConfigDb;
    FDataBaseConf : INewVersioniRTControllerConfigDb;
    FDataBaseStat : INewVersioniRTControllerConfigDb;
  private
    constructor Create;
  public
    function Path : INewVersioniRTControllerConfigPath;
    function DatabaseAZ : INewVersioniRTControllerConfigDb;
    function DatabaseConf : INewVersioniRTControllerConfigDb;
    function DatabaseStat : INewVersioniRTControllerConfigDb;
    class function  New : TNewVersioniRTControllerConfigEntity;
  end;

  resourcestring
  RS_NEWVERSIONI_FIELD_REQUIRED = 'Directory %s mancante';

implementation

uses
  System.SysUtils;


{ TNewVersioniRTControllerConfigPath }

constructor TNewVersioniRTControllerConfigPath.Create;
begin
  FJsonDir := EmptyStr;
  FLogDir := EmptyStr;
end;

function TNewVersioniRTControllerConfigPath.JsonDir: string;
begin
  Result := FJsonDir;
end;

procedure TNewVersioniRTControllerConfigPath.JsonDir(const AValue: string);
begin
  FJsonDir := AValue;
end;

function TNewVersioniRTControllerConfigPath.LogDir: string;
begin
  Result := FLogDir;
end;

procedure TNewVersioniRTControllerConfigPath.LogDir(const Avalue: string);
begin
   FLogDir := AValue;
end;

{ TNewVersioniRTControllerConfigDB }

constructor TNewVersioniRTControllerConfigDB.Create;
begin
  FServer := EmptyStr;
  FDataBase := EmptyStr;
  FNomeUtente := EmptyStr;
  FPassword := EmptyStr;
end;

function TNewVersioniRTControllerConfigDB.Database: string;
begin
  Result := FDataBase;
end;

procedure TNewVersioniRTControllerConfigDB.Database(const AValue: string);
begin
  FDataBase := AValue;
end;

procedure TNewVersioniRTControllerConfigDB.NomeUtente(const AValue: string);
begin
  FNomeUtente := AValue;
end;

function TNewVersioniRTControllerConfigDB.NomeUtente: string;
begin
  Result := FNomeUtente;
end;

function TNewVersioniRTControllerConfigDB.Password: string;
begin
  Result := FPassword;
end;

procedure TNewVersioniRTControllerConfigDB.Password(const AValue: string);
begin
  FPassword := AValue;
end;

function TNewVersioniRTControllerConfigDB.Server: string;
begin
  Result := FServer;
end;

procedure TNewVersioniRTControllerConfigDB.Server(const AValue: string);
begin
  FServer := AValue;
end;

{ TNewVersioniRTControllerConfigEntity }

constructor TNewVersioniRTControllerConfigEntity.Create;
begin
  FDataBaseAz := TNewVersioniRTControllerConfigDb.Create;
  FDataBaseConf := TNewVersioniRTControllerConfigDb.Create;
  FDataBaseStat := TNewVersioniRTControllerConfigDb.Create;
  FPath := TNewVersioniRTControllerConfigPath.create;
end;

function TNewVersioniRTControllerConfigEntity.DatabaseAZ: INewVersioniRTControllerConfigDb;
begin
  Result := FDataBaseAz;
end;

function TNewVersioniRTControllerConfigEntity.DatabaseConf: INewVersioniRTControllerConfigDb;
begin
  Result := FDataBaseConf;
end;

function TNewVersioniRTControllerConfigEntity.DatabaseStat: INewVersioniRTControllerConfigDb;
begin
  Result := FDataBaseStat;
end;

function TNewVersioniRTControllerConfigEntity.Path: INewVersioniRTControllerConfigPath;
begin
  Result := FPath;
end;
//potrebbe servire successivamente
//function TNewVersioniRTControllerConfigPath.Validate(
//  out AErrorlist: IList<String>): boolean;
//var
//  LField : TRttiField;
//  LContext : TRttiContext;
//  LAttributes : TCustomAttribute;
//begin
//   Result := True;
//  AErrorlist := TCollections.CreateList<string>;
// for LField in LContext.GetType(Self.ClassType).GetFields do
//  begin
//    for LAttributes in LField.GetAttributes do
//    begin
//      var LErrorMessage := EmptyStr;
//      if not ValidateRequired(LField, LAttributes, LErrorMessage) then
//      begin
//        Result := False;
//        AErrorList.add(LErrorMessage);
//      end;
//    end;
//  end;
//end;
//
//function TNewVersioniRTControllerConfigPath.ValidateRequired(
//  const AField: TRttiField; const AAttributes: TCustomAttribute;
//  out AErrorMessage: string): boolean;
//begin
//  AErrorMessage := EmptyStr;
//  Result := true;
//  if AAttributes is NewVersioniRT.Controller.Attributes.Required then
//    begin
//      case AField.FieldType.TypeKind of
//        tkInteger, tkInt64:
//        begin
//          Result := (AField.GetValue(Self).AsInteger > 0);
//        end;
//        tkString, tkLString, tkUString, tkWideString:
//        begin
//          Result := not (AField.GetValue(self).AsString.IsEmpty);
//        end;
//
//      end;
//          if not Result then
//   AErrorMessage := format(RS_NEWVERSIONI_FIELD_REQUIRED, [Afield.Name]);
//  end;
//end;
class function TNewVersioniRTControllerConfigEntity.New: TNewVersioniRTControllerConfigEntity;
begin
  Result := Self.Create;
end;

end.
