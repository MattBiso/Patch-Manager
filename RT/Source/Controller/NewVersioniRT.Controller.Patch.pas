unit NewVersioniRT.Controller.Patch;

interface

uses
  NewVersioniRT.Controller.Interfaces,
  NewVersioniRT.Model.Interfaces,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
  Spring.Collections;

type
  TNewVersioniRTControllerPatch = class(TInterfacedObject , INewVersioniRTControllerPatch)
  private
    FEntity : INewVersioniRTControllerPatchEntity;
    FLog : INewVersioniRTControllerLog;
    FErrors : IList<string>;
    FMessage : TFunc<string, TSeverity, boolean>;
    FValidator : INewVersioniRTControllerValidator;
    FModel : INewVersioniRTModelPatchToJson;
    FConnection : INewVersioniRTControllerConnection<string>;
//    FModificato : boolean;
  public
    function Entity : INewVersioniRTControllerPatchEntity; overload;
    procedure Entity(const Avalue : INewVersioniRTControllerPatchEntity); overload;
    function Insert(out AErrorList : Ilist<string>) : boolean;
    function GetLog : string;
    function Errors: IList<string>;
    function Save : boolean;
    function GetPatch : string;
    function GlobalValidateMessage : boolean; overload;
    function ValidateMessage : boolean; overload;
    function DatabaseAssigned(ADeassign : boolean = true) : boolean;
//    function load : TList<String>;  per caricare dati da file json;
    constructor Create(const AConnection : TConnectionType;
      const AViewMessage: TFunc<string, TSeverity, boolean>) ;
    class function New(
      const AConnectionType : TConnectionType;
      const AViewMessage: TFunc<string, TSeverity, boolean>) : INewVersioniRTControllerPatch;
  end;


implementation

uses
  NewVersioniRT.Model.Factory,
  NewVersioniRT.Controller.Factory,
  NewVersioniRT.Messages,
  System.RegularExpressions;

{ TNewVersioniRTControllerPatch }

constructor TNewVersioniRTControllerPatch.Create(
  const AConnection : TConnectionType;
  const AViewMessage: TFunc<string, TSeverity, boolean>);
begin
  FMessage := AViewMessage;
  FEntity := TNewVersioniRTControllerFactory.New.Entity;
  FLog := TNewVersioniRTControllerFactory.New.Log(TConnectionType.json);
  FConnection := TNewVersioniRTControllerFactory.New.JSONConnection(function: string
  begin
    var LConfig := TNewVersioniRTControllerFactory.New.Config;
    Result := LConfig.Config.Path.JsonDir;
  end);
  //in base al tipo di connessione inizializza un model diverso
  //per ora solo tipo json
  case AConnection of
    TConnectionType.Json:
    begin
      FModel := TNewVersioniRTModelFactory.New.ToJson;
    end;
  end;
  FModel.Connection(FConnection.Connection);
  FModel.Entity(FEntity);
  FErrors := TCollections.CreateList<string>;
end;

//se fvalidator è assegnato e viene passato false allora viene deassegnata fvaliator
//se invece non viene passato nulla viene verficato solo se è assegnata oppure no
function TNewVersioniRTControllerPatch.DatabaseAssigned(
  ADeassign: boolean = true): boolean;
begin
  if (assigned(FValidator)) and (ADeassign = false) then
  begin
    FValidator := nil;
  end
  else
  begin
    Result := assigned(FValidator);
  end
end;

procedure TNewVersioniRTControllerPatch.Entity(
  const Avalue: INewVersioniRTControllerPatchEntity);
begin
  FEntity := Avalue;
end;

function TNewVersioniRTControllerPatch.Entity: INewVersioniRTControllerPatchEntity;
begin
  Result := FEntity;
end;

function TNewVersioniRTControllerPatch.Errors: IList<string>;
begin
  Result := FErrors;
end;

//per caricare dati da file json da usare per un possibile caricamento dati
//function TNewVersioniRTControllerPatch.load: TList<String>;
//begin
//  Result := FModel.load
//end;

//funzione che richiama il validator ogni volta che viene inserita una query
//e mostra i messaggi che vengono restituiti
function TNewVersioniRTControllerPatch.ValidateMessage: boolean;
var
 LDict : IDictionary<string,TSeverity>;
 LMessageKey : string;
 LError : string;
begin
  try
    Result := FValidator.Validate(LDict);
    if not result then
    begin
      for LMessageKey in Ldict.Keys do
      begin
        if Ldict[LMessageKey] = TSeverity.Block then
        begin
          LError := LError + LMessageKey + sLineBreak;
        end;
      end;
      LError := 'Errors: ' + sLineBreak + LError;
      if assigned(FMessage) then
        Result := FMessage(LError,TSeverity.Block)
      else
        Result := false;
    end
    else
    begin
      for LMessageKey in Ldict.Keys do
      begin
        if Ldict[LMessageKey] = TSeverity.Ask then
          begin
            if assigned(FMessage) then
              Result := FMessage(LMessageKey,TSeverity.Ask)
            else
              Result := true;
          end
        else
          begin
          LError := LError + LMessageKey + sLineBreak;
          end;
      end;
      if not LError.IsEmpty then
      begin
        LError := 'Warnings: ' + sLineBreak + LError;
        if assigned(FMessage) then
          Result := FMessage(LError,TSeverity.Warning)
        else
          Result := true;
      end;
    end;
  except
    on E : exception do
    begin
    //se la query da un errore lo fa vedere
      FLog.WriteLog(
          '[Errore]: ' ,e.Message);
            exit;
      Result := FMessage(e.Message,TSeverity.Block);
    end;
  end;
end;
//funzione che richiama il validator quando viene richiesto il salvataggio
//e mostra i messaggi che vengono restituiti su l'intera lista dei comandi
function TNewVersioniRTControllerPatch.GlobalValidateMessage : boolean;
var
  LError : String;
  Ldict : IDictionary<string,TSeverity>;
  LMessageKey : string;
begin
  try
    Result := FValidator.GlobalValidate(Ldict);
  if not result then
    begin
      for LMessageKey in Ldict.Keys do
      begin
        if Ldict[LMessageKey] = TSeverity.Block then
        begin
          LError := LError + LMessageKey + sLineBreak;
        end;
      end;
      LError := 'Errors: ' + sLineBreak + LError;
      if assigned(FMessage) then
        Result := FMessage(LError,TSeverity.Block)
      else
        Result := false;
    end
    else
    begin
      for LMessageKey in Ldict.Keys do
      begin
        if Ldict[LMessageKey] = TSeverity.Ask then
          begin
            if assigned(FMessage) then
              Result := FMessage(LMessageKey,TSeverity.Ask)
            else
              Result := true;
          end
        else
          begin
          LError := LError + LMessageKey + sLineBreak;
          end;
      end;
      if not LError.IsEmpty then
      begin
        LError := 'Warnings: ' + sLineBreak + LError;
        if assigned(FMessage) then
          Result := FMessage(LError,TSeverity.Warning)
        else
          Result := true;
      end;
    end;
  except
    on E : exception do
    begin
    //se la query da un errore lo fa vedere
      FLog.WriteLog(
          '[Errore]: ' ,e.Message);
            exit;
      Result := FMessage(e.Message,TSeverity.Block);
    end;
  end;
end;

function TNewVersioniRTControllerPatch.Insert(out AErrorList : Ilist<string>): boolean;
var
  LErrors : string;
begin
//validazione dei campi obbligatori
  if not FEntity.Validate(LErrors) then
    begin
        Result := FMessage(LErrors,TSeverity.Block);
      exit;
    end;
  try
//verifico se è assegnato gia il database
    if not DatabaseAssigned then
      begin
        FValidator := TNewVersioniRTControllerFactory.New.Validator(FEntity.DbType);
        FValidator.Entity(FEntity);
        FValidator.Log(FLog);
      end;
    Result := ValidateMessage;
    //rimuovo la query nel caso la validazione vada male
    if not Result then
      begin
        FValidator.RemoveCommand;
        exit;
      end;
    FModel.Insert;
    except
      on e : exception do
      begin
        Result := False;
        FValidator := nil;
        FErrors.add(e.message);
        FLog.WriteLog(
          '[Errore]' ,format(ERR_LOG_INS_MESSAGE,
            [FEntity.Description,e.Message]));
            exit;
      end;
  end;
  FLog.WriteLog('[Informazione]' , format(LOG_INS_MESSAGE,
    [FEntity.Description]));
end;

function TNewVersioniRTControllerPatch.Save: boolean;
var
  LErrors : string;
begin
  Result := GlobalValidateMessage;
  if not Result then
    exit;
  try
    FModel.Save;
  except
    on e : exception do
    begin
      Result := False;
      FErrors.add(e.message);
      FLog.WriteLog(
        '[Errore]',format(ERR_LOG_SAVE_MESSAGE,
          [FEntity.Description,e.Message]));
          exit;
    end;
  end;
  FLog.WriteLog(
    '[Informazione]',format(LOG_SAVE_MESSAGE ,
      [FEntity.Description,FConnection.Connection]));
  FLog.SaveLog;
end;

function TNewVersioniRTControllerPatch.GetLog: string;
begin
  try
  Result := FLog.GetLog;
  except
    on e: exception do
      begin
        Result := '';
        FErrors.add(e.message);
      end;
  end;
end;

function TNewVersioniRTControllerPatch.GetPatch: string;
begin
  try
    Result := FModel.GetJsonPatch;
  except
    on e: exception do
      begin
        Result := '';
        FErrors.add(e.message);
      end;
  end;
end;

class function TNewVersioniRTControllerPatch.New(const AConnectionType : TConnectionType;
  const AViewMessage: TFunc<string, TSeverity, boolean>) : INewVersioniRTControllerPatch;
begin
  Result := Self.Create(AConnectionType,AViewMessage);
end;


end.
