unit NewVersioniRT.TFDConnection.Interfaces;

interface

uses
  FireDAC.Comp.Client;


type

  INewVersioniRTTFDConnection = interface
  ['{F3F9DEC1-FAEB-4F1F-B944-EAA1F4BF1267}']
    function GetConnectionDB: TFDConnection;
  end;

  INewVersioniRTTFDConnectionFactory = interface
    ['{87B7A0DA-13D5-4F2F-84AA-9A3DDA66DC5E}']
    function TFDConnection(
      const ADatabase : string) : INewVersioniRTTFDConnection;
  end;

implementation

end.
