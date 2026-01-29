unit NewVersioniRT.Model.Validator;

interface

uses
  NewVersioniRT.Model.Interfaces,
  NewVersioniRT.Controller.Interfaces,
  FireDAC.Comp.Client,
  System.RegularExpressions,
  System.Classes,
  Spring.Collections;

type
  TNewVersioniRTModelValidator = class(TInterfacedObject , INewVersioniRTModelValidator)
    private
      FConnection : TFDConnection;
      FCommandList : IList<string>;
      Flog : INewVersioniRTControllerLog;
    Public
      procedure Connection(const Avalue : TFDConnection);
      procedure CommandList(const AValue : IList<string>);
      procedure Log(const Avalue : INewVersioniRTControllerLog);
      function IsUpperCase(const AValue : string): boolean;
      function ValidateView(
        out ADict : IDictionary<string,TSeverity>; const AViewName: string): boolean;
      function ConfrontaListe(
        const AListA : Ilist<string>; const AListB : IList<string>): Ilist<string>;
      function GetColumnsNames(
        const ATableName : string; const AQuery: TFDQuery) : Ilist<string>;
      function ValidateColumns
        (out ADict : IDictionary<string,TSeverity>; const Alist : Ilist<string>): boolean;
      function ValidateFK_Key(
        out ADict : IDictionary<string,TSeverity>; ACommand : string)  : boolean;
      constructor Create;
      function GlobalValidate(
        out ADict : IDictionary<string,TSeverity>): boolean;
      class function new : INewVersioniRTModelValidator;
  end;

implementation

uses
  System.SysUtils,
  NewVersioniRT.Constants,
  NewVersioniRT.Messages;

{ TNewVersioniRTModelValidator }

procedure TNewVersioniRTModelValidator.CommandList(const Avalue: IList<string>);
begin
  FCommandList := Avalue;
end;

procedure TNewVersioniRTModelValidator.Connection(const Avalue: TFDConnection);
begin
  FConnection := Avalue;
end;

constructor TNewVersioniRTModelValidator.Create;
begin
  FCommandList := TCollections.CreateList<string>;
end;

function TNewVersioniRTModelValidator.ConfrontaListe(const AListA,
  AListB: IList<string>): Ilist<string>;
var LTempList : Ilist<string>;
begin
  LTempList := TCollections.CreateList<string>;
  if AListA.IsEmpty then
  begin
    Result := AListB;
    exit;
  end;
  for var i := 0 to AListB.Count -1 do
  begin
    if AListA.IndexOf(AListB[i]) = -1 then
    begin
      LTempList.add(AListB[i]);
    end;
  end;
  Result := LTempList;
end;

function TNewVersioniRTModelValidator.GetColumnsNames(
  const ATableName: string; const AQuery: TFDQuery): Ilist<string>;
var
  Llist : IList<string>;
begin
  try
    Llist := TCollections.CreateList<string>;
    try
      AQuery.SQL.Text :=  'SELECT COLUMN_NAME '+
                          'FROM INFORMATION_SCHEMA.COLUMNS '+
                          'WHERE TABLE_NAME = :TableName '+
                          'ORDER BY COLUMN_NAME';
      AQuery.ParamByName('TableName').AsString := ATableName;
      AQuery.open;
      while not AQuery.eof do
        begin
        Llist.add(AQuery.FieldByName('COLUMN_NAME').AsString);
        AQuery.Next;
        end;
    except
      on E: Exception do
      begin
      Result := Llist;
      exit;
      end;
    end;
  finally
    Result := Llist;
  end;
end;

function TNewVersioniRTModelValidator.GlobalValidate(
  out ADict : IDictionary<string,TSeverity>): boolean;
var
  LQuery : TFDQuery;
  LListA, LListB, LListToValidate : IList<string>;
  LCommand, LTableName: string;
  LMatch : TMatch;
begin
  Result := true;
  LQuery := TFDQuery.Create(nil);
  LListA := TCollections.CreateList<string>;
  LListB := TCollections.CreateList<string>;
    try
      LQuery.Connection := FConnection;
      ADict := TCollections.CreateDictionary<string,TSeverity>;
      FConnection.StartTransaction;
      try
        for LCommand in FCommandList do
        begin
          //Nel caso sia un CREATE
          LMatch := TRegEx.Match(LCommand, CREATE_REGEX_NODB , [roIgnoreCase]);
          if LMatch.Success then
          begin
            LTableName := LMatch.Groups[1].Value;
            if not IsUpperCase(LTableName) then
            begin
              Result := false;
              ADict.Add(DISKLABEL_NAME_UPPERCASE, TSeverity.Block);
              exit;
            end;
            LListA := GetColumnsNames(LTableName, LQuery);

            LQuery.SQL.Text := LCommand;
            LQuery.ExecSQL;

            LListB := GetColumnsNames(LTableName, LQuery);
            LListToValidate := ConfrontaListe(LListA,LListB);

            if not ValidateColumns(ADict, LListToValidate) then
            begin
              Result := false;
              exit;
            end;
            continue;
          end;
          //Nel caso sia una VIEW
          LMatch := TRegEx.Match(LCommand, CREATEVIEW_REGEX, [roIgnoreCase]);
          if LMatch.Success then
          begin
            if not ValidateView(ADict,LMatch.Groups[1].Value) then
            begin
              Result := false;
              exit;
            end;
          end;
          //Nel caso sia un ALTER
          LMatch := TRegEx.Match(LCommand, ALTER_REGEX , [roIgnoreCase]);
          if LMatch.Success then
          begin
          LTableName := LMatch.Groups[1].Value;
            LMatch := TRegEx.Match(LCommand,FOREIGNKEY_REGEX,[roIgnoreCase]);
            if LMatch.Success then
            begin
              if not ValidateFK_Key(ADict, LCommand) then
              begin
                Result := false;
                exit;
              end;
            end;
            LListA := GetColumnsNames(LTableName, LQuery);

            LQuery.SQL.Text := LCommand;
            LQuery.ExecSQL;

            LListB := GetColumnsNames(LTableName, LQuery);
            LListToValidate := ConfrontaListe(LListA,LListB);
            if not ValidateColumns(ADict, LListToValidate) then
            begin
              Result := false;
              exit;
            end;
            continue;
          end;
          LQuery.SQL.Text := LCommand;
          LQuery.ExecSQL;
        end;
        except
          on E: Exception do
          begin
            Result := false;
            FLog.WriteLog('[Errore]: ' ,e.Message);
            ADict.Add(e.Message, TSeverity.Block);
          end;
      end;
    finally
    FConnection.Rollback;
    LQuery.free;
    end;
end;

//da migliorare per verificare se un nome è pascalCase
function TNewVersioniRTModelValidator.IsUpperCase(
  const AValue: string): boolean;
begin
  Result := TRegEx.IsMatch(AValue, '^[A-Z]');
end;

procedure TNewVersioniRTModelValidator.Log(
  const Avalue: INewVersioniRTControllerLog);
begin
  Flog := Avalue;
end;

function TNewVersioniRTModelValidator.ValidateView(
  out ADict : IDictionary<string,TSeverity>; const AViewName: string): boolean;
var
  LMatch : TMatch;
begin
  Result := true;
  ADict := TCollections.CreateDictionary<string,TSeverity>;
  LMatch := TRegEx.Match(AViewName , CREATEVIEW_NAME_REGEX);
  if LMatch.Success then
  begin
    if not IsUpperCase(LMatch.Groups[1].Value) then
      begin
        ADict.Add(format(CREATEVIEW_NAME_UPPERCASE,[AViewName]), TSeverity.Block);
        Result := false;
      end;
    exit;
  end;
  ADict.Add(format(CREATEVIEW_NAME_SYNTAX,[AViewName]),TSeverity.Block);
  Result := false;
end;

function TNewVersioniRTModelValidator.ValidateColumns(
  out ADict : IDictionary<string,TSeverity>; const Alist: Ilist<string>): boolean;
begin
  Result :=  true;
  ADict := TCollections.CreateDictionary<string,TSeverity>;
  for var i := 0 to Alist.Count -1 do
  begin
    if not IsUpperCase(Alist[i]) then
    begin
      ADict.Add(format(UPPERCASE_MISS,[Alist[i]]), TSeverity.Block);
      Result := false;
    end;
    if TRegEx.IsMatch(Alist[i], 'id$') or
      TRegEx.IsMatch(Alist[i], '^ID(?!$)',[roIgnoreCase]) then
    begin
      ADict.Add(format(FOREIGNKEY_REFERENCE,[Alist[i]]), TSeverity.Ask);
    end;
  end;
end;

function TNewVersioniRTModelValidator.ValidateFK_Key(
  out ADict : IDictionary<string,TSeverity>; ACommand : string)  : boolean;
var
  LTargetTableName, LTargetColumnName,
  LSourceTableName, LSourceColumnName, LFKKeyToComp : string;
  LMatch : TMatch;
begin
  Result := true;
  ADict := TCollections.CreateDictionary<string,TSeverity>;
  try
  LMatch := TRegEx.Match(ACommand, FOREIGNKEY_REGEX ,[roIgnoreCase]);
    for var i := 1 to LMatch.Groups.Count - 1  do
    begin
      if i = 2  then
      continue;
      if not IsUpperCase(LMatch.Groups[i].value) then
      begin
        ADict.Add(format(UPPERCASE_MISS,[LMatch.Groups[i].value]),
          TSeverity.Block);
        Result := false;
      end;
    end;
      if result then
      begin
        LTargetTableName := LMatch.Groups[1].Value;
        LTargetColumnName := LMatch.Groups[3].Value;
        LSourceTableName := LMatch.Groups[4].Value;
        LSourceColumnName := LMatch.Groups[5].Value;
        LFKKeyToComp := 'FK_' +
                        LTargetTableName + '_' +
                        LTargetColumnName + '_' +
                        LSourceTableName + '_' +
                        LSourceColumnName;
        if not (LFKKeyToComp = LMatch.Groups[2].Value) then
          begin
            result := false;
            ADict.Add(format(FOREIGNKEY_NAME_SYNTAX,[LMatch.Groups[2].Value]),
              TSeverity.Block);
          end;
      exit;
      end;
  except
    on e: Exception do
    begin
      Result := false;
    end;
  end;
end;

class function TNewVersioniRTModelValidator.new: INewVersioniRTModelValidator;
begin
  Result := self.Create;
end;

end.
