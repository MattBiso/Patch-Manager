unit NewVersioniRT.Controller.Factory;

interface

uses
  System.SysUtils,
  NewVersioniRT.Controller.Interfaces,
  NewVersioniRT.TFDConnection.Interfaces,
  FireDAC.Comp.Client;


type
  TNewVersioniRTControllerFactory = class(TInterfacedObject, INewVersioniRTControllerFactory)
  public
    function Connection<T>(const AConnection: TConnectionType;
      const AConnectionFunc: TFunc<T>): INewVersioniRTControllerConnection<T>;
    function Entity : INewVersioniRTControllerPatchEntity;
    function EntityLog : INewVersioniRTControllerLogEntity;
    function EntityConfig : INewVersioniRTControllerConfigEntity;
    function EntityPardef : INewVersioniRTControllerWizardPardefEntity;
    function Pardef(
      const DbType : string) :  INewVersioniRTControllerWizardPardef;
    function Config : INewVersioniRTControllerConfig;
    function Patch(
      const AConnection :TConnectionType;
      const AViewMessage : TFunc<string, TSeverity, boolean>) : INewVersioniRTControllerPatch;
    function Log(
      const AConnection : TConnectionType) : INewVersioniRTControllerLog;
    function DBConnection(
      const AConnectionFunc: TFunc<INewVersioniRTTFDConnection>)
       : INewVersioniRTControllerConnection<INewVersioniRTTFDConnection>;
    function JSONConnection(
      const AConnectionFunc: TFunc<string>): INewVersioniRTControllerConnection<string>;
    function Validator(
      const ADatabase : string) : INewVersioniRTControllerValidator;
    class function New: INewVersioniRTControllerFactory;
  end;


implementation

uses
  NewVersioniRT.Controller.Patch.Entity,
  NewVersioniRT.Controller.Patch,
  NewVersioniRT.Controller.Log,
  NewVersioniRT.Controller.Log.Entity,
  NewVersioniRT.Controller.Connection,
  NewVersioniRT.Controller.Config,
  NewVersioniRT.Controller.Config.Entity,
  NewVersioniRT.Controller.Validator,
  NewVersioniRT.Controller.Wizard.Pardef.Entity,
  NewVersioniRT.Controller.Wizard.Pardef;

function TNewVersioniRTControllerFactory.Config: INewVersioniRTControllerConfig;
begin
  Result := TNewVersioniRTControllerConfig.new;
end;

function TNewVersioniRTControllerFactory.EntityConfig: INewVersioniRTControllerConfigEntity;
begin
  Result := TNewVersioniRTControllerConfigEntity.new;
end;

function TNewVersioniRTControllerFactory.Connection<T>(
  const AConnection: TConnectionType; const AConnectionFunc: TFunc<T>): INewVersioniRTControllerConnection<T>;
begin
  Result := TNewVersioniRTControllerConnection<T>.New(AConnection, AConnectionFunc);
end;

function TNewVersioniRTControllerFactory.DBConnection(
  const AConnectionFunc: TFunc<INewVersioniRTTFDConnection>):
    INewVersioniRTControllerConnection<INewVersioniRTTFDConnection>;
begin
  Result := Connection<INewVersioniRTTFDConnection>(TConnectionType.DB, AConnectionFunc);
end;

function TNewVersioniRTControllerFactory.Entity: INewVersioniRTControllerPatchEntity;
begin
  Result := TNewVersioniRTControllerPatchEntity.New;
end;

function TNewVersioniRTControllerFactory.EntityLog: INewVersioniRTControllerLogEntity;
begin
  Result := TNewVersioniRTControllerLogEntity.New;
end;

function TNewVersioniRTControllerFactory.EntityPardef: INewVersioniRTControllerWizardPardefEntity;
begin
  Result := TNewVersioniControllerWizardPardefEntity.new;
end;

function TNewVersioniRTControllerFactory.JSONConnection(
  const AConnectionFunc: TFunc<string>): INewVersioniRTControllerConnection<string>;
begin
  Result := Connection<string>(TConnectionType.JSON, AConnectionFunc);
end;

function TNewVersioniRTControllerFactory.Log(const AConnection : TConnectionType): INewVersioniRTControllerLog;
begin
  Result := TNewVersioniRTControllerLog.New(AConnection);
end;

class function TNewVersioniRTControllerFactory.New: INewVersioniRTControllerFactory;
begin
  Result := Self.Create;
end;

function TNewVersioniRTControllerFactory.Pardef(const DbType : string): INewVersioniRTControllerWizardPardef;
begin
  Result := TNewVersioniRTControllerWizardPardef.New(DbType);
end;

function TNewVersioniRTControllerFactory.Patch(
  const AConnection: TConnectionType;
  const AViewMessage: TFunc<string, TSeverity, boolean>): INewVersioniRTControllerPatch;
begin
  Result := TNewVersioniRTControllerPatch.New(AConnection, AViewMessage);
end;

function TNewVersioniRTControllerFactory.Validator(
  const ADatabase : string): INewVersioniRTControllerValidator;
begin
  Result := TNewVersioniRTControllerValidator.New(ADatabase);
end;

end.
