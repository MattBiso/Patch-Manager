unit NewVersioniRT.Controller.Log.Entity;

interface

uses
  NewVersioniRT.Controller.Interfaces,
  NewVersioniRT.Controller.Attributes;

type
  TNewVersioniRTControllerLogEntity = class(TInterfacedObject, INewVersioniRTControllerLogEntity)
  strict private
    [EntityField]
    FCreated: string;
    [EntityField]
    FLogType: string;
    [EntityField]
    FLogInfo: string;
  public
    constructor Create;
    function Created : String; overload;
    procedure Created(const Avalue : string); overload;
    function LogType: String; overload;
    procedure LogType(const Avalue : string); overload;
    function LogInfo: string; overload;
    procedure LogInfo(const Avalue : string); overload;
    class function New : TNewVersioniRTControllerLogEntity;
  end;

implementation

uses
  System.SysUtils;



{ TNewVersioniRTControllerLogEntity }

constructor TNewVersioniRTControllerLogEntity.Create;
begin
  FCreated := EmptyStr;
  FLogType := EmptyStr;
  FLogInfo := EmptyStr;
end;

procedure TNewVersioniRTControllerLogEntity.Created(const Avalue: string);
begin
  FCreated := Avalue;
end;

function TNewVersioniRTControllerLogEntity.Created: String;
begin
  Result := Fcreated;
end;

procedure TNewVersioniRTControllerLogEntity.LogInfo(const Avalue: string);
begin
  FLogInfo := Avalue;
end;

function TNewVersioniRTControllerLogEntity.LogInfo: string;
begin
  Result := FLogInfo;
end;

procedure TNewVersioniRTControllerLogEntity.LogType(const Avalue: string);
begin
  FLogType := Avalue;
end;

function TNewVersioniRTControllerLogEntity.LogType: String;
begin
  Result := FLogType;
end;

class function TNewVersioniRTControllerLogEntity.New: TNewVersioniRTControllerLogEntity;
begin
  Result := Self.Create;
end;

end.
