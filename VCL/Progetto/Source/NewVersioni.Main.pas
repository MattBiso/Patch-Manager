unit NewVersioni.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.CategoryButtons, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.StdCtrls, Vcl.Imaging.pngimage, System.ImageList,
  Vcl.ImgList, System.Actions, Vcl.ActnList, NewVersioni.View.Patch,
  NewVersioni.Frame.BasePage,NewVersioni.Frame.PatchPage,NewVersioni.Frame.ConfigurationPage,
  NewVersioni.Frame.StatusBar;



type
  TFrmNewVersioniMain = class(TForm)
    SV: TSplitView;
    catMenuItems: TCategoryButtons;
    imlIcons: TImageList;
    pnlToolbar: TPanel;
    imgMenu: TImage;
    lblTitle: TLabel;
    ActionList: TActionList;
    ActPatch: TAction;
    PanelForm: TPanel;
    ActConfig: TAction;
    procedure imgMenuClick(Sender: TObject);
    procedure ActPatchExecute(Sender: TObject);
    procedure ActConfigExecute(Sender: TObject);
  private
    FCurrentPage : TBaseFrame;
  public
    procedure ShowPage<T : TBaseFrame>;
  end;


var FrmNewVersioniMain : TFrmNewVersioniMain;

implementation



{$R *.dfm}

uses
  NewVersioniRT.Controller.Patch.Entity,
  NewVersioniRT.Controller.Interfaces;

procedure TFrmNewVersioniMain.ActConfigExecute(Sender: TObject);
begin
  ShowPage<TConfigurationPage>;
end;

procedure TFrmNewVersioniMain.ActPatchExecute(Sender: TObject);
begin
  ShowPage<TPatchPage>;
end;

procedure TFrmNewVersioniMain.ShowPage<T>;
begin
//se non è assegnata una pagina esce
  If not Assigned(Self) then
  begin
    showmessage('ciao');
    Exit;
  end;
//se è assegnata ed è dello stesso tipo allora esco
  if Assigned(FCurrentPage) and (FCurrentPage.ClassType = TBaseFrame) then
    Exit;
  var LNewPage := T.Create(Self);
  LNewPage.Name := '';
  LNewPage.Parent := PanelForm;
  LnewPage.align := alClient;
  LNewPage.OnSaveAndClose := procedure
    begin
      Close;
    end;
  LNewPage.OnClose := procedure
    begin
      Close;
    end;

//Se è assegnata una pagina la elimina e la riassegna alla nuova
  if Assigned(FCurrentPage) then
    FCurrentPage.Free;
    FCurrentPage := LNewPage;
end;

procedure TFrmNewVersioniMain.imgMenuClick(Sender: TObject);
begin
  if SV.Opened then
    SV.Close
    else
    SV.Open
end;

end.
