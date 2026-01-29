unit NewVersioniRT.DataTypes;

interface

uses
  NewVersioniRT.DataTypes.Interfaces,
  spring.Collections;


type
  TNewVersioniRTDataTypes = class(TInterfacedObject, INewVersioniRTDataTypes)
    FDictionary : IDictionary<string,integer>;
  private
    constructor Create;
  public
    function GetDict :  IDictionary<string,integer>;
    class function New : TNewVersioniRTDataTypes;
  end;

implementation

{ TNewVersioniRTDataTypes }

constructor TNewVersioniRTDataTypes.Create;
begin
  FDictionary := Tcollections.CreateDictionary<string,integer>;
  FDictionary.Add('BOOLEANO',2);
  FDictionary.add('DATA',3);
  FDictionary.Add('IDALLMAG',1);
  FDictionary.Add('IdAnaAtt',1);
  FDictionary.Add('IDANAPAG',1);
  FDictionary.Add('IDANRELA',1);
  FDictionary.Add('IDANRIPIND',1);
  FDictionary.Add('IDARTICO',1);
  FDictionary.Add('IDCAUALL',1);
  FDictionary.Add('IDCAUMOV',1);
  FDictionary.Add('IDCAUPRE',1);
  FDictionary.Add('IDCAUSALI',1);
  FDictionary.Add('IDCELPRO',1);
  FDictionary.Add('IDCONTI',1);
  FDictionary.Add('IDCONTICEE',1);
  FDictionary.Add('IDIVA',1);
  FDictionary.Add('IDLISTES',1);
  FDictionary.Add('IDNATTRA',1);
  FDictionary.Add('IDNAZIONI',1);
  FDictionary.Add('IDORINC',1);
  FDictionary.Add('IDREGIME',1);
  FDictionary.Add('IDREPCDC',1);
  FDictionary.Add('IDTIPIDOC',1);
  FDictionary.Add('IDTIPINC',1);
  FDictionary.Add('IDTIPLAV',1);
  FDictionary.Add('IDTIPO',1);
  FDictionary.Add('IDTIPSRV',1);
  FDictionary.Add('IDTRAINTR',1);
  FDictionary.Add('IDVALUTA',1);
  FDictionary.Add('IMPORTO',3);
  FDictionary.Add('INT16',2);
  FDictionary.Add('INT32',2);
  FDictionary.Add('Ora',3);
  FDictionary.Add('PERC',3);
  FDictionary.Add('STRINGA',0);
end;

function TNewVersioniRTDataTypes.GetDict: IDictionary<string, integer>;
begin
  Result := FDictionary;
end;

class function TNewVersioniRTDataTypes.New: TNewVersioniRTDataTypes;
begin
  Result := self.create;
end;

end.
