program ThreadDemo;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  Vcl.Themes,
  Vcl.Styles,
  Common in 'Common\Common.pas',
  UICommon in 'Common\UICommon.pas',
  uDemoBase in 'Common\uDemoBase.pas' {frmDemoBase},
  DownloadThread in 'DemoDownload\DownloadThread.pas',
  uDemoDownload in 'DemoDownload\uDemoDownload.pas' {frmDemoDownload},
  DatabaseThread in 'DemoDatabase\DatabaseThread.pas',
  uDemoDatabase in 'DemoDatabase\uDemoDatabase.pas' {frmDemoDatabase},
  CriticalSectionThread in 'DemoCriticalSections\CriticalSectionThread.pas',
  uDemoCriticalSections in 'DemoCriticalSections\uDemoCriticalSections.pas' {frmDemoCriticalSections},
  HttpServerThread in 'DemoHttpServer\HttpServerThread.pas',
  uDemoHttpServer in 'DemoHttpServer\uDemoHttpServer.pas' {frmDemoHttpServer},
  CpuMonitor in 'DemoHurtMyCpu\CpuMonitor.pas',
  HurtMyCpuThread in 'DemoHurtMyCpu\HurtMyCpuThread.pas',
  uDemoHurtMyCpu in 'DemoHurtMyCpu\uDemoHurtMyCpu.pas' {frmDemoHurtMyCpu},
  uDemoOmniThreads in 'DemoOmniThreads\uDemoOmniThreads.pas' {frmDemoOmniThreads},
  ProgressThread in 'DemoProgress\ProgressThread.pas',
  uDemoProgress in 'DemoProgress\uDemoProgress.pas' {frmDemoProgress},
  uDemoThreadQueue in 'DemoQueues\uDemoThreadQueue.pas' {frmDemoThreadQueue},
  ThreadPoolThread in 'DemoThreadPools\ThreadPoolThread.pas',
  uDemoThreadPools in 'DemoThreadPools\uDemoThreadPools.pas' {frmDemoThreadPools},
  uDemoWindowsMessages in 'DemoWindowsMessages\uDemoWindowsMessages.pas' {frmDemoWindowsMessages};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'JD Thread Demo';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
