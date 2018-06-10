unit HurtMyCpuThread;

interface

uses
  System.Classes, System.SysUtils, System.SyncObjs;

type
  TThreadRef = class(TObject)
  private
    FThreadID: Cardinal;
    FCur: Integer;
    FLock: TCriticalSection;
    FTerminated: Boolean;
    FCountTo: Integer;
    procedure SetCountTo(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Terminate;
    procedure Lock;
    procedure Unlock;
    property ThreadID: Cardinal read FThreadID;
    property IsTerminated: Boolean read FTerminated;
    property Cur: Integer read FCur write FCur;
    property CountTo: Integer read FCountTo write SetCountTo;
  end;

implementation

{ TThreadRef }

constructor TThreadRef.Create;
begin
  FLock:= TCriticalSection.Create;
  FCur:= 0;
  FThreadID:= TThread.CurrentThread.ThreadID;
end;

destructor TThreadRef.Destroy;
begin
  FreeAndNil(FLock);
  inherited;
end;

procedure TThreadRef.SetCountTo(const Value: Integer);
begin
  FCountTo := Value;
end;

procedure TThreadRef.Terminate;
begin
  FTerminated:= True;
end;

procedure TThreadRef.Unlock;
begin
  FLock.Leave;
end;

procedure TThreadRef.Lock;
begin
  Flock.Enter;
end;

end.
