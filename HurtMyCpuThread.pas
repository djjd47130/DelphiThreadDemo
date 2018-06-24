unit HurtMyCpuThread;

interface

uses
  System.Classes, System.SysUtils, System.SyncObjs;

type
  THurtMyCpuThread = class;

  TThreadRefEvent = procedure(ARef: THurtMyCpuThread) of object;

  TThreadIsTerminated = function: Boolean of object;

  ///  <summary>
  ///    A simple thread with the sole purpose of consuming 100%
  ///    of a single processor core (or divided among them as Windows does).
  ///  </summary>
  THurtMyCpuThread = class(TThread)
  private
    FCountTo: Int64;
    FCur: Int64;
    FLock: TCriticalSection;
    FOnDeleteRef: TThreadRefEvent;
    FOnAddRef: TThreadRefEvent;
  protected
    procedure Execute; override;
  public
    constructor Create(ACountTo: Int64); reintroduce;
    destructor Destroy; override;
    property Cur: Int64 read FCur;
    property CountTo: Int64 read FCountTo write FCountTo;
    procedure Lock;
    procedure Unlock;
  public
    property OnAddRef: TThreadRefEvent read FOnAddRef write FOnAddRef;
    property OnDeleteRef: TThreadRefEvent read FOnDeleteRef write FOnDeleteRef;
  end;

implementation

{ THurtMyCpuThread }

constructor THurtMyCpuThread.Create(ACountTo: Int64);
begin
  inherited Create(True);
  FCountTo:= ACountTo;
  FLock:= TCriticalSection.Create;
end;

destructor THurtMyCpuThread.Destroy;
begin
  FLock.Enter;
  try
  finally
    FLock.Leave;
  end;
  FreeAndNil(FLock);
  inherited;
end;

{$HINTS OFF}
procedure THurtMyCpuThread.Execute;
var
  X, Z: Int64;
  {$IFDEF DBL_LVL}
  Y: Int64;
  {$ENDIF}
begin

  try
    Synchronize(
      procedure
      begin
        if Assigned(FOnAddRef) then
          FOnAddRef(Self);
      end);

    for X := 1 to FCountTo do begin
      if Terminated then Break;
      {$IFDEF DBL_LVL}
      for Y := 1 to MAXINT_JD do begin
      {$ENDIF}
        if Terminated then Break;
        Lock;
        try
          if Terminated then Break;

          //This is the calculation which actually hurts the CPU
          //  by executing it rapidly with no delay over and over...
          Z:= Round(X/2);

          //TODO: Think of something heavier...

          FCur:= X;
        finally
          Unlock;
        end;
      {$IFDEF DBL_LVL}
      end;
      {$ENDIF}
    end;

    Synchronize(
      procedure
      begin
        if Assigned(FOnDeleteRef) then
          FOnDeleteRef(Self);
      end);

  finally
    FreeOnTerminate:= True;
    Terminate;
  end;

end;
{$HINTS ON}

procedure THurtMyCpuThread.Lock;
begin
  FLock.Enter;
end;

procedure THurtMyCpuThread.Unlock;
begin
  FLock.Leave;
end;

end.
