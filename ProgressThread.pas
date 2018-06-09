unit ProgressThread;

(*
  This unit demonstrates reporting progress of a lengthy task.
  It's done in 3 different ways:
  - Directly, without any additional athread.
  - Using a TThread class.
  - Using an Anonymous Thread.
*)

interface

uses
  System.Classes, System.SysUtils, System.Math;

type

  TProgressEvent = procedure(Sender: TObject; const Current, Total: Integer;
    const Msg: String) of object;

  TProgressThread = class(TThread)
  private
    FDelay: Integer;
    FCurrent: Integer;
    FTotal: Integer;
    FMessage: String;
    FOnProgress: TProgressEvent;
    procedure TaskProgress(Sender: TObject; const Current, Total: Integer;
      const Msg: String);
  protected
    procedure Execute; override;
    procedure SYNC_OnProgress;
  public
    constructor Create(ATotal: Integer; ADelay: Integer = 1000); reintroduce;
    destructor Destroy; override;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
  end;

procedure DoLongTask(ATotal: Integer; ADelay: Integer = 1000;
  AOnProgress: TProgressEvent = nil);

implementation

procedure DoLongTask(ATotal: Integer; ADelay: Integer = 1000;
  AOnProgress: TProgressEvent = nil);
var
  X: Integer;
  Msg: String;
begin
  //This is the root function used to imitate a long task.
  //  It does not have anything related to any thread. That will all
  //  be handled outside of this function in various different ways.
  for X := 1 to ATotal do begin
    Sleep(ADelay);
    //We write some fields which will be used. We can't pass these as parameters.
    Msg:= 'Currently at '+IntToStr(X)+' of '+IntToStr(ATotal);

    AOnProgress(nil, X, ATotal, Msg);

  end;
  AOnProgress(nil, ATotal, ATotal, 'Complete');
end;

procedure DoLongTaskAnonymous(ATotal: Integer; ADelay: Integer;
  AOnProgress: TProgressEvent);
begin

  {
  TThread.CreateAnonymousThread(
    procedure
    begin

      DoLongTask(ATotal, ADelay,
        procedure(Sender: TObject; const Current, Total: Integer; const Msg: String)
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              if Assigned(AOnProgress) then
                AOnProgress(nil, Current, Total, Msg);
            end);
        end);

        //TODO: Properly implement anonymous thread 

    end);
  }

end;

{ TProgressThread }

constructor TProgressThread.Create(ATotal: Integer; ADelay: Integer = 1000);
begin
  inherited Create(True);
  FTotal:= ATotal;
  FDelay:= ADelay;
end;

destructor TProgressThread.Destroy;
begin

  inherited;
end;

procedure TProgressThread.Execute;
begin
  //Here, we pass our internal handler, rather than the one provided by caller.
  //  This is because we will need to synchronize it.
  DoLongTask(FTotal, FDelay, TaskProgress);
end;

procedure TProgressThread.TaskProgress(Sender: TObject; const Current,
  Total: Integer; const Msg: String);
begin
  //Received event from long task, redirect this event through synchronize
  FCurrent:= Current;
  FTotal:= Total;
  FMessage:= Msg;
  //Here we call the REAL event via synchronize, so that it runs
  //  in the context of the main thread, not this one.
  Synchronize(SYNC_OnProgress);
end;

procedure TProgressThread.SYNC_OnProgress;
begin
  //Now we're sure we are running in the context of the main thread.
  if Assigned(FOnProgress) then
    FOnProgress(Self, FCurrent, FTotal, FMessage);
end;

end.
