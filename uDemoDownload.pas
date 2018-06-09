unit uDemoDownload;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls,
  uDemoBase,
  DownloadThread;

type
  //Used to keep track of which mode is currently being usedl
  TDownloadMode = (dmDirect, dmThread, dmAnon);

  TfrmDemoDownload = class(TfrmDemoBase)
    Label4: TLabel;
    lblDownloadProgress: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    txtDownloadURL: TEdit;
    Panel2: TPanel;
    Label3: TLabel;
    btnDownloadSaveBrowse: TSpeedButton;
    txtDownloadFilename: TEdit;
    Panel3: TPanel;
    btnDownloadWithoutThread: TBitBtn;
    btnDownloadWithThreadClass: TBitBtn;
    btnDownloadWithAnonymousThread: TBitBtn;
    dlgDownloadSave: TSaveDialog;
    Label2: TLabel;
    Label12: TLabel;
    procedure btnDownloadSaveBrowseClick(Sender: TObject);
    procedure btnDownloadWithoutThreadClick(Sender: TObject);
    procedure btnDownloadWithThreadClassClick(Sender: TObject);
    procedure btnDownloadWithAnonymousThreadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FMode: TDownloadMode;
    procedure DownloadFinished(Sender: TObject; const Success: Boolean);
  public
    procedure SetEnabledState(const Enabled: Boolean); override;
  end;

var
  frmDemoDownload: TfrmDemoDownload;

implementation

{$R *.dfm}

uses
  System.IOUtils;

procedure TfrmDemoDownload.FormCreate(Sender: TObject);
var
  Def: String;
begin
  inherited;

  //Define default download directory and filename...
  Def:= TPath.Combine(TPath.GetHomePath, 'Thread Demo');
  ForceDirectories(Def);
  Def:= TPath.Combine(Def, 'TestFile.zip');
  Self.txtDownloadFilename.Text:= Def;

end;

procedure TfrmDemoDownload.SetEnabledState(const Enabled: Boolean);
begin
  inherited;

  //Update UI based on current download state...
  Self.btnDownloadWithoutThread.Enabled:= Enabled;
  Self.btnDownloadWithThreadClass.Enabled:= Enabled;
  Self.btnDownloadWithAnonymousThread.Enabled:= Enabled;
  Self.txtDownloadURL.Enabled:= Enabled;
  Self.txtDownloadFilename.Enabled:= Enabled;
  Self.btnDownloadSaveBrowse.Enabled:= Enabled;
  if Enabled = False then begin
    case FMode of
      dmDirect:   Self.lblDownloadProgress.Caption:= 'Downloading directly, this will freeze this window...';
      dmThread:   Self.lblDownloadProgress.Caption:= 'Downloading with thread class, UI is responsive...';
      dmAnon:     Self.lblDownloadProgress.Caption:= 'Downloading with anonymous thread, UI is responsive...';
    end;
  end;

  //Make sure the UI updates before the process starts...
  Application.ProcessMessages;
end;

procedure TfrmDemoDownload.btnDownloadSaveBrowseClick(Sender: TObject);
begin
  inherited;

  //Prompt user where to save downloaded file...
  dlgDownloadSave.FileName:= txtDownloadFilename.Text;
  if dlgDownloadSave.Execute then begin
    Self.txtDownloadFilename.Text:= Self.dlgDownloadSave.FileName;
  end;
end;

procedure TfrmDemoDownload.btnDownloadWithoutThreadClick(Sender: TObject);
var
  Res: Boolean;
begin
  inherited;

  //Download the file without using any thread...
  FMode:= TDownloadMode.dmDirect;
  Self.SetEnabledState(False);
  try
    //Once you start this, the UI will freeze to a death...
    Res:= DownloadFile(Self.txtDownloadURL.Text, Self.txtDownloadFilename.Text);
  finally
    SetEnabledState(True);
  end;
  //Signal UI that download is done...
  DownloadFinished(Self, Res);
end;

procedure TfrmDemoDownload.btnDownloadWithThreadClassClick(Sender: TObject);
var
  T: TDownloadThread;
begin
  inherited;

  //Download the file using a TThread class...
  FMode:= TDownloadMode.dmThread;
  SetEnabledState(False);

  T:= TDownloadThread.Create;
  T.URL:= txtDownloadURL.Text;
  T.Filename:= txtDownloadFilename.Text;
  T.OnFinished:= DownloadFinished;
  T.FreeOnTerminate:= True;
  T.Start;
  //Aaaaaand we need to FORGET about T from here on out. Trying to access
  //  it is not allowed when FreeOnTerminate is enabled. Once it's started,
  //  that's the point of no return. It's like sending a horse with a wagon
  //  of dynamite out to a target.

  //The handler which was provided to T.OnFinished will be triggered
  //  when it's done, and will run in the context of the main thread.

end;

procedure TfrmDemoDownload.btnDownloadWithAnonymousThreadClick(Sender: TObject);
begin
  inherited;

  //Download the file using an anonymous thread...
  FMode:= TDownloadMode.dmAnon;
  SetEnabledState(False);
  DownloadThread.DownloadFileAnonymous(Self.txtDownloadURL.Text, Self.txtDownloadFilename.Text,
    DownloadFinished);
  //Absolutely nothing to track here, even if you wanted to.
end;

procedure TfrmDemoDownload.DownloadFinished(Sender: TObject; const Success: Boolean);
begin
  //A download has completed.

  SetEnabledState(True);
  if Success then
    Self.lblDownloadProgress.Caption:= 'Download Complete!'
  else
    Self.lblDownloadProgress.Caption:= 'Download Failed!';

  //Obviously you would want to know more information here. That's where the
  //  next demo comes in. It will cover real-time feedback from a thread,
  //  so you can update your UI safely.
end;

end.
