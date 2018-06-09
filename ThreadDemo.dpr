program ThreadDemo;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  DownloadThread in 'DownloadThread.pas',
  ProgressThread in 'ProgressThread.pas',
  uDemoBase in 'uDemoBase.pas' {frmDemoBase},
  uDemoDownload in 'uDemoDownload.pas' {frmDemoDownload},
  uDemoProgress in 'uDemoProgress.pas' {frmDemoProgress},
  CriticalSectionThread in 'CriticalSectionThread.pas',
  uDemoCriticalSections in 'uDemoCriticalSections.pas' {frmDemoCriticalSections},
  uDemoHttpServer in 'uDemoHttpServer.pas' {frmDemoHttpServer},
  uDemoWindowsMessages in 'uDemoWindowsMessages.pas' {frmDemoWindowsMessages},
  uDemoThreadPools in 'uDemoThreadPools.pas' {frmDemoThreadPools},
  uDemoDatabase in 'uDemoDatabase.pas' {frmDemoDatabase},
  uDemoThreadQueue in 'uDemoThreadQueue.pas' {frmDemoThreadQueue},
  uDemoOmniThreads in 'uDemoOmniThreads.pas' {frmDemoOmniThreads},
  Vcl.Themes,
  Vcl.Styles,
  DatabaseThread in 'DatabaseThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'JD Thread Demo';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
