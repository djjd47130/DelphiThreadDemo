unit DownloadThread;

(*
  This unit contains functionality for downloading a file from the web.
  There are 3 different demonstrations to do so:
  - Without a Thread - Call "DownloadFile" procedure directly.
  - With a Thread Class - Create instance of TDownloadThread, assign callback, and start.
  - With an Anonymous Thread - Call "DownloadFileAnonymous" procedure and wait for callback.
*)

interface

uses
  System.Classes, System.SysUtils, IdHTTP;

type

  //This event type is used to pass back the completion of a downloaded file.
  TDownloadDoneEvent = procedure(Sender: TObject; const Success: Boolean) of object;

  //This is a dedicated thread class for the purpose of downloading a file.
  TDownloadThread = class(TThread)
  private
    FUrl: String;
    FFilename: String;
    FSuccess: Boolean; //Used internally when synchronizing success of download on completion.
    FOnFinished: TDownloadDoneEvent;
    procedure SetFilename(const Value: String);
    procedure SetURL(const Value: String);
  protected
    procedure Execute; override; //Note the "override" because it's called internally.
    procedure SYNC_OnFinished; //Note that there are no parameters on this method.
  public
    constructor Create; reintroduce; //Note the "reintroduce" because we want to hide the original.
    destructor Destroy; override;
    property URL: String read FURL write SetURL; //The URL to be downloaded.
    property Filename: String read FFilename write SetFilename; //The local filename to save file to.
    property OnFinished: TDownloadDoneEvent read FOnFinished write FOnFinished; //Triggered upon completion.
  end;


function DownloadFile(const URL: String; const Filename: String): Boolean;

procedure DownloadFileAnonymous(const URL: String; const Filename: String;
  const OnFinished: TDownloadDoneEvent);


implementation


function DownloadFile(const URL: String; const Filename: String): Boolean;
var
  Cli: TIdHTTP;
  FS: TFileStream;
begin
  //This is the core function for downloading ANY file using ANY method.
  //  All 3 methods use this. The function itself does NOT run in the context
  //  of any particular thread, but instead by whatever thread called it.

  Cli:= TIdHTTP.Create(nil);
  try
    //We're setting a custom user agent because our friends at ThinkBroadband.com
    //  wish to be able to explicitly track requests coming from this demo app,
    //  in order to prevent yourself from getting blacklisted.
    Cli.Request.UserAgent:= 'Mozilla/5.0 (compatible; JD Thread Demo)';

    FS:= TFileStream.Create(Filename, fmCreate);
    try

      //Now that we've created an instance of TIdHTTP and TFileStream,
      //  we can actually download the file. If you wish, you could download
      //  it in chunks so that you can monitor the progress of the download,
      //  and trigger synchronized events along the way.
      Cli.Get(Url, FS);

      //As long as we get this far, it means the file downloaded successfully
      //  without any exceptions. Therefore, we will toggle the result.
      Result:= True;

    finally
      FreeAndNil(FS);
    end;
  finally
    FreeAndNil(Cli);
    //I use FreeAndNil() instead of .Free just because the Delphi code insight
    //  often likes to lie and complain that .Free does not exist.
  end;

end;

procedure DownloadFileAnonymous(const URL: String; const Filename: String;
  const OnFinished: TDownloadDoneEvent);
var
  Success: Boolean;
begin
  //An anonymous thread is one which we don't track at all. We don't even
  //  declare a variable for it. Note the call to TThread.Synchronize,
  //  which passes nil first, to define the current thread context.
  TThread.CreateAnonymousThread(
    procedure
    begin
      //Now we're working in the context of a new thread.
      //Whatever happens here does not affect the main UI thread...
      try
        //Let's actually download the file now.
        Success:= DownloadFile(URL, Filename);
      except
        on E: Exception do begin
          //You're gonna want to handle this.
        end;
      end;
      //...until you synchronize...
      TThread.Synchronize(nil,
        procedure
        begin
          //Now, we are working in the context of the VCL thread.
          //  It's safe to trigger these events back to the caller.
          if Assigned(OnFinished) then
            OnFinished(nil, Success);
        end
      );
    end
  ).Start;
  //Don't forget to call .Start at the end. That gets me every time too.
  //  I even made the mistake of forgetting it while writing this example.
  //  The code means nothing until you actually start it, the same as
  //  when you call .Start on a regular TThread object.
end;

{ TDownloadThread }

constructor TDownloadThread.Create;
begin
  inherited Create(True);
  //Code here does NOT run in the context of this thread, but by the calling thread.

end;

destructor TDownloadThread.Destroy;
begin
  //Code here does NOT run in the context of this thread, but by the calling thread.

  inherited;
end;

procedure TDownloadThread.Execute;
begin
  //The actual thread's work starts here. Remember, all code placed here,
  //  and all code which is accessed from here, runs in the context of THIS thread.
  //  Note how this entire unit does not even contain ANYTHING related to the UI/VCL.
  //Some threads perform an infinite loop, which break when the thread is terminated.
  //  In this case, we only download once, so there will be no loop.

  try
    //Here is where we call the main function to download the file.
    FSuccess:= DownloadFile(FUrl, FFilename);
  except
    on E: Exception do begin
      //Here, you would handle any exception(s) and synchronize other events accordingly.
      //  In the case of this demo, I will not be handling this as it's irrelevant to the purpose.
      //  But you would need to make sure you handle this.
    end;
  end;

  //Here's the important part. We SYNCHRONIZE this event to inform the calling thread
  //  that the download has finished. You cannot trigger the event directly,
  //  because that would in turn run in the context of THIS thread. But you need
  //  to make sure it runs in the context of the MAIN thread.
  Synchronize(SYNC_OnFinished);

end;

procedure TDownloadThread.SetFilename(const Value: String);
begin
  FFilename := Value;
end;

procedure TDownloadThread.SetURL(const Value: String);
begin
  FURL := Value;
end;

procedure TDownloadThread.SYNC_OnFinished;
begin
  //This is the method called from "Synchronize()". All code run from "Synchronize()"
  //  runs in the context of the Main VCL UI Thread, NOT from this thread.
  //  This simply triggers the event which was assigned by the calling thread
  //  to inform it that the download has completed.
  if Assigned(FOnFinished) then
    FOnFinished(Self, FSuccess);
end;

end.
