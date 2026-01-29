unit NewVersioniRT.Controller.Config;

interface

uses
  NewVersioniRT.Controller.Interfaces,
  NewVersioniRT.Model.Interfaces,
  System.SysUtils,
  Spring.Collections,
  System.Classes;

type
  TNewVersioniRTControllerConfig = class(TInterfacedObject , INewVersioniRTControllerConfig)
  private
    FConfig : INewVersioniRTControllerConfigEntity;
    FModel : INewVersioniRTModelConfig;
    FErrors : IList<string>;
  public
    constructor Create;
    function Config : INewVersioniRTControllerConfigEntity; overload;
    procedure Config(
      const Avalue : INewVersioniRTControllerConfigEntity); overload;
    procedure load;
    function WriteConfig : boolean;
    class function new : INewVersioniRTControllerConfig;
  end;

implementation
  uses
    NewVersioniRT.Controller.Factory,
    NewVersioniRT.Model.Factory;

{ TNewVersioniRTControllerConfig }

function TNewVersioniRTControllerConfig.Config: INewVersioniRTControllerConfigEntity;
begin
  Result := FConfig;
end;

procedure TNewVersioniRTControllerConfig.Config(
  const Avalue: INewVersioniRTControllerConfigEntity);
begin
  FConfig := Avalue;
end;

constructor TNewVersioniRTControllerConfig.Create;
var
  LControllerFactory : INewVersioniRTControllerFactory;
  LModelFactory : INewVersioniRTModelFactory;
begin
  LControllerFactory :=  TNewVersioniRTControllerFactory.New;
  LModelFactory :=  TNewVersioniRTModelFactory.New;
  FConfig := LControllerFactory.EntityConfig;
  FModel := LModelFactory.Config;
  FModel.Config(FConfig);
  FModel.Connection(ExtractFilePath(ParamStr(0)));
  FErrors := TCollections.CreateList<string>;
  load;
end;

procedure TNewVersioniRTControllerConfig.load;
begin
  try
    if not Fmodel.load then
    begin

    end;
    except
      on E : exception do
      begin
        FErrors.add(E.Message);
      end;
  end;

end;
class function TNewVersioniRTControllerConfig.new: INewVersioniRTControllerConfig;
begin
  Result := Self.Create;
end;

function TNewVersioniRTControllerConfig.WriteConfig: boolean;
begin
  try
    Result := Fmodel.WriteConfig
    except
      on E : exception do
      begin
        Result := False;
        FErrors.add(E.Message);
      end;
  end;
end;

end.
