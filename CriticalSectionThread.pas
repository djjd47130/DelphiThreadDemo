unit CriticalSectionThread;

{
--------------------------------------------------------------------------------

  This unit is separated into 2 main parts:
  1) TLocker
  2) TLockedThread

--------------------------------------------------------------------------------

  TLocker

  Encapsulates locking an object. When creating, pass the object
    you wish to lock. Make sure you don't store a reference to
    that object anywhere else - that would defeat the purpose.

  You can accomplish the same without using this TLocker class,
    but it helps to make sure you really hide the object's
    access through a universal function that must be used.

  The idea is any time you want to access this object,
    you would call the Lock function, which returns the object,
    but ONLY when another thread is finished with it.
    Once finished, call Unlock to allow another thread to use.

  ALL access to this object should be through this lock mechanism.
    Any place that ignores the lock would break the rule and
    no longer serve its purpose. This would include objects which
    the VCL or other framework or library might directly access
    behind your back, such as list items for example.
    UI controls cannot be protected with this, because the
    VCL has absolutely no idea about your lock and would ignore it.

  The end goal is to protect memory from being accessed by more
    than one thread at the same time, which could lead to
    unpredictable results, such as deadlocks, or race conditions.

  All Lock/Unlock usage should be wrapped with try..finally blocks.

  var
    O: TMyObject;
  begin
    O:= TMyObject(L.Lock);
    try
      //Do something with O...

    finally
      L.Unlock;
    end;
  end;

--------------------------------------------------------------------------------

  TLockedThread

  A thread which implements TLocker to protect an object.



--------------------------------------------------------------------------------
}

interface

uses
  System.Classes, System.SysUtils, System.SyncObjs;

type

  TLocker = class(TObject)
  private
    FLock: TCriticalSection;
  strict private
    FObj: TObject;
  public
    constructor Create(AObj: TObject);
    destructor Destroy; override;
    function Lock: TObject;
    procedure Unlock;
  end;

implementation

{ TLocker }

constructor TLocker.Create(AObj: TObject);
begin
  FObj:= AObj;
  FLock:= TCriticalSection.Create;
end;

destructor TLocker.Destroy;
begin
  FLock.Enter;
  FLock.Leave;
  FreeAndNil(FLock);
  inherited;
end;

function TLocker.Lock: TObject;
begin
  //First, we try to "lock" it, which will wait until another thread is finished,
  // that is, if any thread was using it at all. Otherwise, will return immediately.
  FLock.Enter;
  //Now that it's locked, we return the internal object reference...
  Result:= FObj;
end;

procedure TLocker.Unlock;
begin
  //When a thread is done using an object, it must "unlock" it to allow
  //  another thread to be able to access it.
  FLock.Leave;
end;

end.
