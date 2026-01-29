unit NewVersioniRT.Model.Factory;

interface

uses
  NewVersioniRT.Model.Interfaces;

type
  TNewVersioniRTModelFactory = class(TInterfacedObject, INewVersioniRTModelFactory)
    function ToJson: INewVersioniRTModelPatchToJson;
    function Log : INewVersioniRTModelLog;
    function Config : INewVersioniRTModelConfig;
    function Validator : INewVersioniRTModelValidator;
    class function New : INewVersioniRTModelFactory;
  end;

implementation

uses
  NewVersioniRT.Model.Patch.ToJson,
  NewVersioniRT.Model.Log,
  NewVersioniRT.Model.Config,
  NewVersioniRT.Model.Validator;


{ TNewVersioniRTModelFactory }

function TNewVersioniRTModelFactory.Config: INewVersioniRTModelConfig;
begin
  Result := TNewVersioniRTModelConfig.New;
end;

function TNewVersioniRTModelFactory.Log: INewVersioniRTModelLog;
begin
  Result := TNewVersioniRTModelLog.new;
end;

class function TNewVersioniRTModelFactory.New: INewVersioniRTModelFactory;
begin
  Result := Self.Create;
end;

function TNewVersioniRTModelFactory.Validator: INewVersioniRTModelValidator;
begin
  Result := TNewVersioniRTModelValidator.new;
end;

function TNewVersioniRTModelFactory.ToJson: INewVersioniRTModelPatchToJson;
begin
  Result := TNewVersioniRTModelPatchToJson.new;
end;

end.
