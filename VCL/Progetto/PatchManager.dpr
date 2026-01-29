program PatchManager;

uses
  FastMM4,
  FastMM4Messages,
  Vcl.Forms,
  NewVersioni.Main in 'Source\NewVersioni.Main.pas' {FrmNewVersioniMain};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmNewVersioniMain, FrmNewVersioniMain);
  Application.Run;
end.
