unit NewVersioniRT.TFDConnection;

interface

uses
  NewVersioniRT.TFDConnection.Interfaces,
  FireDAC.Comp.Client;

type
  TNewVersioniRTTFDConnection = class(TInterfacedObject , INewVersioniRTTFDConnection)
  private
    FDConnection : TFDConnection;
  public
    constructor Create(const ADatabase : string);
    destructor Destroy; override;
    class function new(const ADatabase : string) : TNewVersioniRTTFDConnection;
    function GetConnectionDB: TFDConnection;
  end;


implementation

uses
  System.Classes,
  System.SysUtils,
  NewVersioniRT.Controller.Interfaces,
  NewVersioniRT.Controller.Factory,
  StrUtils,
  NewVersioniRT.Constants;


{ TNewVersioniRTControllerTDFConnection }

constructor TNewVersioniRTTFDConnection.Create(const ADatabase : string);
begin
    var LParams := TStringList.Create;
    var LConfig := TNewVersioniRTControllerFactory.New.Config;
  try
  case AnsiIndexStr(ADatabase,DATABASES) of
  //aziendale
  0 :
  begin
    LParams.Values[SERVER_FIELD_NAME] := LConfig.Config.DatabaseAZ.Server;
    LParams.Values[USERNAME_FIELD_NAME] := LConfig.Config.DatabaseAZ.NomeUtente;
    LParams.Values[PASSWORD_FIELD_NAME] := LConfig.Config.DatabaseAZ.Password;
    LParams.Values[DATABASE_FIELD_NAME] := LConfig.Config.DatabaseAZ.DataBase;
  end;
  //configurazione
  1 :
  begin
    LParams.Values[SERVER_FIELD_NAME] := LConfig.Config.DatabaseConf.Server;
    LParams.Values[USERNAME_FIELD_NAME] := LConfig.Config.DatabaseConf.NomeUtente;
    LParams.Values[PASSWORD_FIELD_NAME] := LConfig.Config.DatabaseConf.Password;
    LParams.Values[DATABASE_FIELD_NAME] := LConfig.Config.DatabaseConf.DataBase;
  end;
  //statistiche avanzate
  2 :
  begin
    LParams.Values[SERVER_FIELD_NAME] := LConfig.Config.DatabaseStat.Server;
    LParams.Values[USERNAME_FIELD_NAME] := LConfig.Config.DatabaseStat.NomeUtente;
    LParams.Values[PASSWORD_FIELD_NAME] := LConfig.Config.DatabaseStat.Password;
    LParams.Values[DATABASE_FIELD_NAME] := LConfig.Config.DatabaseStat.DataBase;
  end;
  else
    begin
      raise Exception.Create('Database non presente : errore di connessione');
    end;
  end;
    LParams.Values['Pooled'] := 'True';
    var LManager := FDManager.ConnectionDefs.FindConnectionDef(CONNECTION_DEF_NAME);
      if LManager = nil then
        begin
          FDManager.AddConnectionDef(CONNECTION_DEF_NAME, 'MSSQL', LParams);
        end
        else
        begin
          FDManager.CloseConnectionDef(CONNECTION_DEF_NAME);
          FDManager.ModifyConnectionDef(CONNECTION_DEF_NAME, LParams);
        end;
  FDConnection := TFDConnection.Create(nil);
  try
  FDConnection.ConnectionDefName := CONNECTION_DEF_NAME;
  
  FDConnection.Connected := True;
  except
    on e : exception do
          begin
            raise Exception.Create(e.message);
          end;
  end;
  finally
    LParams.Free;
  end;
end;

destructor TNewVersioniRTTFDConnection.Destroy;
begin
  FDConnection.Free;
  inherited;
end;

function TNewVersioniRTTFDConnection.GetConnectionDB: TFDConnection;
begin
  Result := FDConnection;
end;

class function TNewVersioniRTTFDConnection.new(
  const ADatabase : string): TNewVersioniRTTFDConnection;
begin
  Result := Self.create(ADatabase);
end;

end.
