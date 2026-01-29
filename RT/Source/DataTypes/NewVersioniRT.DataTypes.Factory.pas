unit NewVersioniRT.DataTypes.Factory;

interface
  uses
    NewVersioniRT.DataTypes.Interfaces;

type
  TNewVersioniRTDataTypesFactory = class(TInterfacedObject, INewVersioniRTDataTypesFactory)
    function DataTypes : INewVersioniRTDataTypes;
    class function new : INewVersioniRTDataTypesFactory;
  end;

implementation

uses
  NewVersioniRT.DataTypes;

{ TNewVersioniRTDataTypesFactory }

function TNewVersioniRTDataTypesFactory.DataTypes: INewVersioniRTDataTypes;
begin
 Result :=  TNewVersioniRTDataTypes.New;
end;

class function TNewVersioniRTDataTypesFactory.new: INewVersioniRTDataTypesFactory;
begin
  Result := self.Create;
end;

end.
