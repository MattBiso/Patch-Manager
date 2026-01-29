unit NewVersioniRT.Controller.Log;

interface
uses
  NewVersioniRT.Controller.Interfaces,
  NewVersioniRT.Model.Interfaces,
  Spring.Collections,
  System.classes,
  System.SysUtils;

type
  TNewVersioniRTControllerLog = class(TInterfacedObject, INewVersioniRTControllerLog)
  private
    FEntity : INewVersioniRTControllerLogEntity;
    FErrors : IList<string>;
    FModel : INewVersioniRTModelLog;
  public
    procedure Log(const Avalue: INewVersioniRTControllerLogEntity); overload;
    function Log: INewVersioniRTControllerLogEntity; overload;
    procedure WriteLog(const ALogType : string ; const ALogInfo: string);
    function GetLog : string;
    procedure SaveLog;
    class function New(AConnection : TConnectionType) : INewVersioniRTControllerLog;
    constructor Create(const AConnection : TConnectionType);
  end;

implementation

uses
  NewVersioniRT.Model.Factory,
  NewVersioniRT.Controller.Factory,
  NewVersioniRT.Messages;


constructor TNewVersioniRTControllerLog.Create(const AConnection : TConnectionType);
begin
  var LConnection := TNewVersioniRTControllerFactory.New.JSONConnection(function: string
  begin
    var LConfig := TNewVersioniRTControllerFactory.New.Config;
    Result := LConfig.Config.Path.LogDir;
  end);
  FEntity := TNewVersioniRTControllerFactory.New.EntityLog;
  FModel := TNewVersioniRTModelFactory.New.Log;
  FModel.log(FEntity);
  FModel.Connection(LConnection.Connection);
  FErrors := TCollections.CreateList<string>;
end;

procedure TNewVersioniRTControllerLog.Log(
  const Avalue: INewVersioniRTControllerLogEntity);
begin
  FEntity := Avalue;
end;

function TNewVersioniRTControllerLog.Log: INewVersioniRTControllerLogEntity;
begin
  Result := FEntity;
end;

class function TNewVersioniRTControllerLog.New(AConnection : TConnectionType) : INewVersioniRTControllerLog;
begin
  Result := Self.Create(AConnection);
end;

procedure TNewVersioniRTControllerLog.SaveLog;
begin
  try
    FModel.SaveLog;
  except
    on e: exception do
      begin
        FErrors.add(e.message);
        WriteLog(
          '[Errore]',ERR_SAVE_FILE_LOG)
      end;
  end;
end;

procedure TNewVersioniRTControllerLog.WriteLog(const ALogType, ALogInfo : string);
begin
  FModel.WriteLog(ALogType, ALogInfo);
end;

function TNewVersioniRTControllerLog.GetLog: string;
begin
  try
  Result := FModel.GetLog;
  except
    on e: exception do
      begin
        Result := '';
        FErrors.add(e.message);
      end;
  end;
end;
end.
