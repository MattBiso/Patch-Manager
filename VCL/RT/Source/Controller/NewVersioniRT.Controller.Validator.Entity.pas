unit NewVersioniRT.Controller.Validator.Entity;

interface

uses
  NewVersioniRT.Controller.Interfaces,
  NewVersioniRT.Controller.Attributes;



type
  TNewVersioniRTControllerValidatorEntity = class(TInterfacedObject, INewVersioniRTControllerValidatorEntity)
  private
    FCommand : string;
  public
    procedure Command (const AValue : String); overload;
    function Command : String; overload;
    class function New: TNewVersioniRTControllerValidatorEntity;
  end;

implementation

{ TNewVersioniRTControllerPatchCommand }


procedure TNewVersioniRTControllerValidatorEntity.Command(
  const AValue: String);
begin
  FCommand := AValue;
end;

function TNewVersioniRTControllerValidatorEntity.Command: String;
begin
  Result := FCommand;
end;

class function TNewVersioniRTControllerValidatorEntity.New  :
  TNewVersioniRTControllerValidatorEntity;
begin
  Result := Self.Create;
end;

end.
