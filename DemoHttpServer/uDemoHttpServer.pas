unit uDemoHttpServer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDemoBase, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, IdTCPConnection, IdTCPClient, IdHTTP, IdBaseComponent,
  IdComponent, IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer,
  IdContext,
  HttpServerThread,
  Vcl.Samples.Spin, Vcl.ComCtrls;

type

  TfrmDemoHttpServer = class(TfrmDemoBase)
    pMain: TPanel;
    pSvr: TPanel;
    pCli: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Panel5: TPanel;
    btnSvrStart: TBitBtn;
    btnSvrStop: TBitBtn;
    Svr: TIdHTTPServer;
    Panel4: TPanel;
    Label4: TLabel;
    sePort: TSpinEdit;
    lstClients: TListView;
    Label5: TLabel;
    Label12: TLabel;
    lstConnections: TListView;
    procedure pMainResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSvrStartClick(Sender: TObject);
    procedure btnSvrStopClick(Sender: TObject);
    procedure SvrConnect(AContext: TIdContext);
    procedure SvrDisconnect(AContext: TIdContext);
  private

  public
    procedure SetEnabledState(const Enabled: Boolean); override;
  end;

var
  frmDemoHttpServer: TfrmDemoHttpServer;

implementation

{$R *.dfm}

procedure TfrmDemoHttpServer.btnSvrStartClick(Sender: TObject);
begin
  inherited;
  SetEnabledState(True);
  Svr.DefaultPort:= sePort.Value;
  Svr.Active:= True;
end;

procedure TfrmDemoHttpServer.btnSvrStopClick(Sender: TObject);
begin
  inherited;
  SetEnabledState(False);
  Svr.Active:= False;
end;

procedure TfrmDemoHttpServer.FormCreate(Sender: TObject);
begin
  inherited;
  pMain.Align:= alClient;
  lstClients.Align:= alClient;
  sePort.Align:= alLeft;
end;

procedure TfrmDemoHttpServer.pMainResize(Sender: TObject);
var
  H: Integer;
begin
  inherited;
  H:= (pMain.ClientWidth div 2) - 1;
  pSvr.Width:= H;
  pCli.Width:= H;
end;

procedure TfrmDemoHttpServer.SetEnabledState(const Enabled: Boolean);
begin
  inherited;

  btnSvrStart.Enabled:= not Enabled;
  btnSvrStop.Enabled:= Enabled;
  sePort.Enabled:= not Enabled;

end;

procedure TfrmDemoHttpServer.SvrConnect(AContext: TIdContext);
begin
  inherited;
  //
end;

procedure TfrmDemoHttpServer.SvrDisconnect(AContext: TIdContext);
begin
  inherited;
  //
end;

end.
