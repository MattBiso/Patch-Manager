unit NewVersioniRT.Controller.Wizard.Pardef.Entity;

interface

uses
  spring.Collections,
  NewVersioniRT.Controller.Interfaces;


type
  TNewVersioniControllerWizardPardefEntity = class(TInterfacedObject, INewVersioniRTControllerWizardPardefEntity)
  private
    FChiave : string;
    FChiavePadre : string;
    FValStr : string;
    FTipoDato : string;
    FID : string;
    FValID : string;
    FValInt : string;
    FValDP : string;
    FTabella : string;
    FDescr : string;
    FObbligatorio : string;
    FSolaLet : string;
    FNascosoto : string;
    FStropz : IDictionary<string,string>;
  public
    procedure Chiave(const AValue : string); overload;
    function Chiave : string; overload;
    procedure ID(const AValue : string); overload;
    function ID : string; overload;
    procedure ValID(const AValue : string); overload;
    function ValID : string; overload;
    procedure ValInt(const AValue : string); overload;
    function ValInt : string; overload;
    procedure ValDP(const AValue : string); overload;
    function ValDP : string; overload;
    procedure Tabella(const AValue : string); overload;
    function Tabella : string; overload;
    procedure Obbligatorio(const AValue : string); overload;
    function Obbligatorio : string; overload;
    procedure Nascosto(const AValue : string); overload;
    function Nascosto : string; overload;
    procedure SolaLet(const AValue : string); overload;
    function SolaLet : string; overload;
    procedure ChiavePadre(const Avalue :string); overload;
    function ChiavePadre : string; overload;
    procedure ValStr(const AValue : string); overload;
    function ValStr : string; overload;
    procedure TipoDato(const Avalue : string); overload;
    function TipoDato : string; overload;
    procedure Descr(const AValue : string); overload;
    function Descr : string; overload;
    procedure Stropz(const AValue : IDictionary<string, string>); overload;
    function Stropz : IDictionary<string,string>; overload;
    class function New : TNewVersioniControllerWizardPardefEntity;
  private
    constructor Create;
end;


implementation

uses
  System.SysUtils;

{ TNewVersioniControllerWizardEntity }

function TNewVersioniControllerWizardPardefEntity.ChiavePadre: string;
begin
  Result := FChiavePadre;
end;

procedure TNewVersioniControllerWizardPardefEntity.ChiavePadre(
  const Avalue: string);
begin
  FChiavePadre := AValue;
end;

function TNewVersioniControllerWizardPardefEntity.Chiave: string;
begin
  Result := FChiave;
end;

procedure TNewVersioniControllerWizardPardefEntity.Chiave(const AValue: string);
begin
  FChiave := AValue;
end;

constructor TNewVersioniControllerWizardPardefEntity.Create;
begin
  FChiave := EmptyStr;
  FDescr := EmptyStr;
  FObbligatorio := '0';
  FSolaLet := '0';
  FNascosoto  := '0';
  FID := EmptyStr;
  FValID := EmptyStr;
  FValStr := EmptyStr;
  FValDP := EmptyStr;
  FTabella := EmptyStr;
  FStropz := TCollections.CreateDictionary<string,string>;
  FTipoDato := EmptyStr;
  FValStr := EmptyStr;
end;

procedure TNewVersioniControllerWizardPardefEntity.Descr(const AValue: string);
begin
  FDescr := AValue;
end;

function TNewVersioniControllerWizardPardefEntity.Descr: string;
begin
  Result := FDescr;
end;

procedure TNewVersioniControllerWizardPardefEntity.ID(const AValue: string);
begin
  FID := AValue;
end;

function TNewVersioniControllerWizardPardefEntity.ID: string;
begin
  Result := FID;
end;

procedure TNewVersioniControllerWizardPardefEntity.Nascosto(
  const AValue: string);
begin
  FNascosoto := AValue;
end;

function TNewVersioniControllerWizardPardefEntity.Nascosto: string;
begin
  Result := FNascosoto;
end;

class function TNewVersioniControllerWizardPardefEntity.New: TNewVersioniControllerWizardPardefEntity;
begin
  Result := Self.Create;
end;

procedure TNewVersioniControllerWizardPardefEntity.Obbligatorio(
  const AValue: string);
begin
  FObbligatorio := AValue;
end;

function TNewVersioniControllerWizardPardefEntity.Obbligatorio: string;
begin
  Result := FObbligatorio;
end;

procedure TNewVersioniControllerWizardPardefEntity.SolaLet(
  const AValue: string);
begin
  FSolaLet := AValue;
end;

function TNewVersioniControllerWizardPardefEntity.SolaLet: string;
begin
  Result := FSolaLet;
end;

function TNewVersioniControllerWizardPardefEntity.Stropz: IDictionary<string, string>;
begin
  Result := FStropz;
end;
//da cambiare forse è sbagliato cosi
procedure TNewVersioniControllerWizardPardefEntity.Stropz(
  const AValue: IDictionary<string, string>);
begin
  FStropz := AValue;
end;

procedure TNewVersioniControllerWizardPardefEntity.TipoDato(const Avalue: string);
begin
  FTipoDato := Avalue;
end;

procedure TNewVersioniControllerWizardPardefEntity.Tabella(
  const AValue: string);
begin
  FTabella := AValue;
end;

function TNewVersioniControllerWizardPardefEntity.Tabella: string;
begin
  Result := FTabella;
end;

function TNewVersioniControllerWizardPardefEntity.TipoDato: string;
begin
  Result := FTipoDato;
end;

procedure TNewVersioniControllerWizardPardefEntity.ValStr(const AValue: string);
begin
  FValStr := AValue;
end;

procedure TNewVersioniControllerWizardPardefEntity.ValDP(const AValue: string);
begin
  FValDP := AValue;
end;

function TNewVersioniControllerWizardPardefEntity.ValDP: string;
begin
  Result := FValDP;
end;

procedure TNewVersioniControllerWizardPardefEntity.ValInt(const AValue: string);
begin
  FValInt := AValue;
end;

function TNewVersioniControllerWizardPardefEntity.ValID: string;
begin
  Result := FValID;
end;

procedure TNewVersioniControllerWizardPardefEntity.ValID(const AValue: string);
begin
  FValID := AValue;
end;

function TNewVersioniControllerWizardPardefEntity.ValInt: string;
begin
  Result := FValInt;
end;

function TNewVersioniControllerWizardPardefEntity.ValStr: string;
begin
  Result := FValStr;
end;

end.
