unit ThreadPoolThread;

(*
  Demonstrates the concept of a thread pool, allowing multiple tasks to
  be evenly split up between multiple different threads.

  This thread pool is very abstract, allowing it to be used for virtually any purpose.
  It is similar to executing anonymous threads, but with a little more control.

  How to use:
    Create an instance of TThreadPool. Assign its ThreadCount to your desired
    number of threads. Use NewTask to create a new task to be executed
    within the thread pool. The next available thread will automatically
    pull the task from the queue and execute it. When calling NewTask,
    you can optionally specify the priority and whether to initialize COM.

*)

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  System.SyncObjs, Winapi.ActiveX;

type
  TThreadPoolTask = class;
  TThreadPoolThread = class;
  TThreadPool = class;

  TThreadPoolProc = procedure;

  TThreadPoolTask = class(TObject)
  private
    FProc: TThreadPoolProc;
    FPriority: TThreadPriority;
    FNeedsCom: Boolean;
    procedure SetPriority(const Value: TThreadPriority);
    procedure SetNeedsCom(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    property Priority: TThreadPriority read FPriority write SetPriority;
    property NeedsCom: Boolean read FNeedsCom write SetNeedsCom;
  end;

  TThreadPoolThread = class(TThread)
  private
    FOwner: TThreadPool;
    procedure Process;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TThreadPool);
    destructor Destroy; override;
  end;

  TThreadPool = class(TComponent)
  private
    FThreads: TObjectList<TThreadPoolThread>;
    FTasks: TObjectList<TThreadPoolTask>;
    FTasksLock: TCriticalSection;
    FThreadCount: Integer;
    procedure SetThreadCount(const Value: Integer);
    procedure EnsureThreadCount;
  protected
    function NextTask(const Remove: Boolean = True): TThreadPoolTask;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ThreadCount: Integer read FThreadCount write SetThreadCount;
    function NewTask(AProc: TThreadPoolProc; APriority: TThreadPriority = tpNormal;
      ANeedsCom: Boolean = False): TThreadPoolTask;
    procedure ClearTaskQueue;
  end;

implementation

{ TThreadPoolTask }

constructor TThreadPoolTask.Create;
begin
  Self.FPriority:= TThreadPriority.tpNormal;
  Self.FNeedsCom:= False;
end;

destructor TThreadPoolTask.Destroy;
begin

  inherited;
end;

procedure TThreadPoolTask.SetNeedsCom(const Value: Boolean);
begin
  FNeedsCom := Value;
end;

procedure TThreadPoolTask.SetPriority(const Value: TThreadPriority);
begin
  FPriority := Value;
end;

{ TThreadPoolThread }

constructor TThreadPoolThread.Create(AOwner: TThreadPool);
begin
  inherited Create(True);
  FOwner:= AOwner;
end;

destructor TThreadPoolThread.Destroy;
begin

  inherited;
end;

procedure TThreadPoolThread.Execute;
begin
  while not Terminated do begin
    try
      try
        Process;
      finally
        Sleep(10);
      end;
    except
      on E: Exception do begin
        //TODO: Implement OnException callback event...

      end;
    end;
  end;
end;

procedure TThreadPoolThread.Process;
var
  T: TThreadPoolTask;
begin
  T:= FOwner.NextTask;
  if T <> nil then begin
    try
      Self.Priority:= T.Priority;

      if T.NeedsCom then
        CoInitialize(nil);
      try

        //EXECUTE PROCEDURE
        T.FProc;

      finally
        if T.NeedsCom then
          CoUninitialize;
      end;

    except
      on E: Exception do begin
        raise Exception.Create('Failed to process thread pool task: '+E.Message);
      end;
    end;
  end;
end;

{ TThreadPool }

constructor TThreadPool.Create(AOwner: TComponent);
begin
  inherited;
  FTasksLock:= TCriticalSection.Create;
  FThreads:= TObjectList<TThreadPoolThread>.Create(False);
  FTasks:= TObjectList<TThreadPoolTask>.Create(False);

end;

destructor TThreadPool.Destroy;
begin
  ClearTaskQueue;
  SetThreadCount(0);

  FreeAndNil(FTasks);
  FreeAndNil(FThreads);
  FreeAndNil(FTasksLock);
  inherited;
end;

procedure TThreadPool.SetThreadCount(const Value: Integer);
begin
  FThreadCount := Value;
  EnsureThreadCount;
end;

procedure TThreadPool.EnsureThreadCount;

  procedure AddThread;
  var
    T: TThreadPoolThread;
  begin
    T:= TThreadPoolThread.Create(Self);
    //TODO...
    FThreads.Add(T);
    T.Start;
  end;

  procedure DeleteThread;
  var
    T: TThreadPoolThread;
  begin
    //TODO: Find an idle thread instead of forcibly tasking the first one
    T:= FThreads[0];
    T.FreeOnTerminate:= True;
    T.Terminate;
    FThreads.Delete(0);
  end;

begin
  while FThreads.Count <> FThreadCount do begin
    if FThreads.Count > FThreadCount then begin
      DeleteThread;
    end else
    if FThreads.Count < FThreadCount then begin
      AddThread;
    end;
  end;
end;

procedure TThreadPool.ClearTaskQueue;
begin
  FTasksLock.Enter;
  try
    while FTasks.Count > 0 do begin
      FTasks[0].Free;
      FTasks.Delete(0);
    end;
  finally
    FTasksLock.Leave;
  end;
end;

function TThreadPool.NewTask(AProc: TThreadPoolProc;
  APriority: TThreadPriority = tpNormal; ANeedsCom: Boolean = False): TThreadPoolTask;
begin
  //Returns a new task.
  //TODO: Is there any reason to return an object: Might be dangerous...
  Result:= TThreadPoolTask.Create;
  Result.FProc:= AProc;
  Result.FPriority:= APriority;
  Result.FNeedsCom:= ANeedsCom;
  FTasksLock.Enter;
  try
    FTasks.Add(Result);
  finally
    FTasksLock.Leave;
  end;
end;

function TThreadPool.NextTask(const Remove: Boolean): TThreadPoolTask;
begin
  //Returns the next task in the queue. Returns nil if empty.
  Result:= nil;
  FTasksLock.Enter;
  try
    if FTasks.Count > 0 then begin
      Result:= FTasks[0];
      if Remove then
        FTasks.Delete(0);
    end;
  finally
    FTasksLock.Leave;
  end;
end;

end.
