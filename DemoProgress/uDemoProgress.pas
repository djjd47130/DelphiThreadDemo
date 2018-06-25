unit uDemoProgress;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDemoBase, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls,

  ProgressThread;

type
  TfrmDemoProgress = class(TfrmDemoBase)
    lblProgMsg: TLabel;
    Prog: TProgressBar;
    Panel5: TPanel;
    btnProgressNoThread: TBitBtn;
    btnProgressThreadClass: TBitBtn;
    btnProgressAnonymous: TBitBtn;
    tmrProgress: TTimer;
    Label4: TLabel;
    Label12: TLabel;
    procedure btnProgressNoThreadClick(Sender: TObject);
    procedure btnProgressThreadClassClick(Sender: TObject);
    procedure btnProgressAnonymousClick(Sender: TObject);
    procedure tmrProgressTimer(Sender: TObject);
  private
    FProgCur: Integer;
    FProgTot: Integer;
    FProgMsg: String;
    procedure ThreadProgress(Sender: TObject; const Current, Total: Integer;
      const Msg: String);
  public
    procedure SetEnabledState(const Enabled: Boolean); override;
  end;

var
  frmDemoProgress: TfrmDemoProgress;

implementation

{$R *.dfm}

{ TfrmDemoBase1 }

procedure TfrmDemoProgress.SetEnabledState(const Enabled: Boolean);
begin
  inherited;

  //Update UI based on current progress state...
  if Enabled = False then
    Self.lblProgMsg.Caption:= 'Doing Long Task...';

  Self.btnProgressNoThread.Enabled:= Enabled;
  Self.btnProgressThreadClass.Enabled:= Enabled;
  Self.btnProgressAnonymous.Enabled:= False; //TODO: Implement...  Enabled;

  //Make sure the UI updates before the process starts...
  Application.ProcessMessages;
end;

procedure TfrmDemoProgress.btnProgressNoThreadClick(Sender: TObject);
begin
  inherited;

  //Do long task without another thread...
  Self.SetEnabledState(False);
  try
    DoLongTask(100, 100, ThreadProgress);
  finally
    Self.SetEnabledState(True);
  end;

end;

procedure TfrmDemoProgress.btnProgressThreadClassClick(Sender: TObject);
var
  T: TProgressThread;
begin
  inherited;

  //Do long task in a thread class...
  Self.SetEnabledState(False);
  T:= TProgressThread.Create(100, 100);
  T.OnProgress:= Self.ThreadProgress;
  T.FreeOnTerminate:= True;
  T.Start;

end;

procedure TfrmDemoProgress.btnProgressAnonymousClick(Sender: TObject);
begin
  inherited;

  //Do long task in an anonymous thread...

end;

procedure TfrmDemoProgress.ThreadProgress(Sender: TObject; const Current,
  Total: Integer; const Msg: String);
begin
  //Don't directly update the UI here, actually just copy the values
  //  to local variables, and use a timer to update the UI periodically.
  //  This way, the thread won't have to be blocked while the UI is updated.
  FProgCur:= Current;
  FProgTot:= Total;
  FProgMsg:= Msg;
  if Current = Total then begin
    Self.SetEnabledState(True);
    Self.lblProgMsg.Caption:= 'Long task complete!';
  end;
  Application.ProcessMessages; //NONO! This is known as a "poor man's thread",
    //  but isn't actually a thread at all! Just a problem causer!
    //  This is the reason why you would want to use a thread.
end;

procedure TfrmDemoProgress.tmrProgressTimer(Sender: TObject);
begin
  inherited;

  //Update the UI with the progress...
  if Prog.Max <> FProgTot then
    Prog.Max:= FProgTot;
  Prog.Position:= FProgCur;
  if FProgCur <> FProgTot then begin
    lblProgMsg.Caption:= FProgMsg;
  end;
end;

end.
