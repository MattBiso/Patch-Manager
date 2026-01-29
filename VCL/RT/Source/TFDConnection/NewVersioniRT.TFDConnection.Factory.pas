unit NewVersioniRT.TFDConnection.Factory;

interface

uses
  NewVersioniRT.TFDConnection.Interfaces;

type
  TNewVersioniRTTFDConnectionFactory = class(TInterfacedObject, INewVersioniRTTFDConnectionFactory)
  public
    function TFDConnection(
      const ADatabase : string) : INewVersioniRTTFDConnection;
    class function New: INewVersioniRTTFDConnectionFactory;
  end;

implementation

uses
  NewVersioniRT.TFDConnection;

{ TNewVersioniRTTFDConnectionFactory }

class function TNewVersioniRTTFDConnectionFactory.New: INewVersioniRTTFDConnectionFactory;
begin
  Result := Self.Create;
end;

function TNewVersioniRTTFDConnectionFactory.TFDConnection(
  const ADatabase: string) :INewVersioniRTTFDConnection;
begin
  Result := TNewVersioniRTTFDConnection.new(ADatabase);
end;

end.
