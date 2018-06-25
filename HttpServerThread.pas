unit HttpServerThread;

interface

uses
  System.Classes, System.SysUtils,
  Vcl.Buttons, IdTCPConnection, IdTCPClient, IdHTTP, IdBaseComponent,
  IdComponent, IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer,
  IdContext;

type
  TSvrContext = class(TIdServerContext)
  private
    FReq: TIdHttpRequestInfo;
    FRes: TIdHttpResponseInfo;
  public
    procedure HandleCmd(AReq: TIdHttpRequestInfo; ARes: TIdHttpResponseInfo);
  end;

  TSvrThread = class(TThread)
  private
    FSvr: TIdHTTPServer;
    FPort: Integer;
    procedure SvrCommand(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure SetPort(const Value: Integer);
  protected
    procedure Execute; override;
  public
    constructor Create; reintroduce;
    property Port: Integer read FPort write SetPort;
  end;

  TCliThread = class(TThread)
  private
    FResource: String;
    procedure SetResource(const Value: String);
  protected
    procedure Execute; override;
  public
    constructor Create; reintroduce;
    property Resource: String read FResource write SetResource;
  end;

implementation

{ TSvrContext }

procedure TSvrContext.HandleCmd(AReq: TIdHttpRequestInfo;
  ARes: TIdHttpResponseInfo);
begin
  FReq:= AReq;
  FRes:= ARes;
  //TODO: Respond with massive amounts of random data...


end;

{ TSvrThread }

constructor TSvrThread.Create;
begin
  inherited Create(True);
  FPort:= 8008;
end;

procedure TSvrThread.Execute;
begin
  FSvr:= TIdHTTPServer.Create(nil);
  try
    FSvr.ContextClass:= TSvrContext;
    FSvr.DefaultPort:= FPort;
    FSvr.OnCommandGet:= SvrCommand;
    FSvr.OnCommandOther:= SvrCommand;
    FSvr.Active:= True;
    try
      while not Terminated do begin
        try
          //Nothing...
        finally
          Sleep(1);
        end;
      end;
    finally
      FSvr.Active:= False;
    end;
  finally
    FSvr.Free;
  end;
end;

procedure TSvrThread.SetPort(const Value: Integer);
begin
  FPort := Value;
end;

procedure TSvrThread.SvrCommand(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  C: TSvrContext;
begin
  C:= TSvrContext(AContext);
  C.HandleCmd(ARequestInfo, AResponseInfo);
end;

{ TCliThread }

constructor TCliThread.Create;
begin
  inherited Create(True);

end;

procedure TCliThread.Execute;
var
  C: TIdHTTP;
begin
  C:= TIdHTTP.Create(nil);
  try

  finally
    C.Free;
  end;
  Terminate;
end;

procedure TCliThread.SetResource(const Value: String);
begin
  FResource := Value;
end;

end.
