unit ThreadPoolThread;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections;

type
  TThreadTask = class;
  TThreadPool = class;
  TThreadPoolThread = class;



  TThreadTask = class(TObject)
  private

  public
    constructor Create;
    destructor Destroy; override;
  end;

  TThreadPool = class(TObject)

  end;

  TThreadPoolThread = class(TThread)

  end;

implementation

{ TThreadTask }

constructor TThreadTask.Create;
begin

end;

destructor TThreadTask.Destroy;
begin

  inherited;
end;

end.
