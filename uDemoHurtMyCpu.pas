unit uDemoHurtMyCpu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDemoBase, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls,
  System.SyncObjs, System.Generics.Collections,
  HurtMyCpuThread,
  CpuMonitor;

type
  TfrmDemoHurtMyCpu = class(TfrmDemoBase)
    lblWarning: TLabel;
    lstThreads: TListView;
    Panel1: TPanel;
    Label1: TLabel;
    btnSpawn: TBitBtn;
    btnStop: TBitBtn;
    txtCountTo: TEdit;
    Tmr: TTimer;
    Label12: TLabel;
    Bevel1: TBevel;
    progCPU: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSpawnClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure TmrTimer(Sender: TObject);
    procedure lstThreadsCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lstThreadsCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FLock: TCriticalSection;
    FThreads: TObjectList<THurtMyCpuThread>;
    FTerminated: Boolean;
    procedure DoSpawn(const CountTo: Integer);
  public
    procedure AddRef(ARef: THurtMyCpuThread);
    procedure DeleteRef(ARef: THurtMyCpuThread);
    procedure UpdateRef(ARef: THurtMyCpuThread);
    function IsTerminated: Boolean;
  end;

var
  frmDemoHurtMyCpu: TfrmDemoHurtMyCpu;

implementation

{$R *.dfm}

uses
  UICommon;

{ TfrmDemoHurtMyCpu }

procedure TfrmDemoHurtMyCpu.FormCreate(Sender: TObject);
begin
  inherited;
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown:= True;
  {$ENDIF}
  lblWarning.Caption:= 'WARNING: If you spawn more threads than you have CPU cores ('+IntToStr(System.CPUCount)+'), you could lock up your PC!';
  lstThreads.Align:= alClient;
  FLock:= TCriticalSection.Create;
  FThreads:= TObjectList<THurtMyCpuThread>.Create(False);
end;

procedure TfrmDemoHurtMyCpu.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(FThreads);
  FreeAndNil(FLock);
end;

function TfrmDemoHurtMyCpu.IsTerminated: Boolean;
begin
  Result:= FTerminated;
end;

procedure TfrmDemoHurtMyCpu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FTerminated:= True;
end;

procedure TfrmDemoHurtMyCpu.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  Self.btnStopClick(nil);
end;

procedure TfrmDemoHurtMyCpu.lstThreadsCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  inherited;
  //
end;

procedure TfrmDemoHurtMyCpu.lstThreadsCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  Perc: Single;
  R: TRect;
  T: THurtMyCpuThread;
begin
  inherited;
  if (SubItem = 3) then begin
    DefaultDraw:= False;
    FLock.Enter;
    try
      T:= FThreads[Item.Index];
      T.Lock;
      try
        Perc:= T.Cur / T.CountTo;
      finally
        T.Unlock;
      end;
    finally
      FLock.Leave;
    end;
    R:= ListViewCellRect(Sender, SubItem, Item.Index);
    DrawProgressBar(Sender.Canvas, R, Perc);
    SetBkMode(Sender.Canvas.Handle, TRANSPARENT); // <- will effect the next [sub]item
  end else begin
    DefaultDraw:= True;
  end;
end;

procedure TfrmDemoHurtMyCpu.btnSpawnClick(Sender: TObject);
var
  T: String;
  I: Int64;
begin
  T:= txtCountTo.Text;
  I:= StrToIntDef(T, 0);
  if (I > 0) and (I <= 2147483647) then
    DoSpawn(I)
  else
    raise Exception.Create('Invalid input for "Count To".');
end;

procedure TfrmDemoHurtMyCpu.btnStopClick(Sender: TObject);
var
  X: Integer;
begin
  FLock.Enter;
  try
    for X := FThreads.Count-1 downto 0 do begin
      FThreads[X].Terminate;
    end;
  finally
    FLock.Leave;
  end;
end;

procedure TfrmDemoHurtMyCpu.TmrTimer(Sender: TObject);
var
  I: TListItem;
  X: Integer;
  T: THurtMyCpuThread;
  Cpu: Double;
begin
  //We do all UI updates inside of a timer, rather than at the moment
  //  of receiving events from the threads. This is because when events
  //  are received, the calling worker thread is temporarily blocked until
  //  the synchronized event is done and returns. Instead, all we do in
  //  those events is capture the information in a variable, then later
  //  use it in the timer to update controls in the UI (which is heavier).

  //We also grab information about the current CPU usage, and update
  //  a progress bar to reflect the current load.

  Cpu:= GetTotalCpuUsagePct;
  progCPU.Position:= Trunc(Cpu);

  FLock.Enter;
  try

    //Ensure count matches
    while lstThreads.Items.Count <> FThreads.Count do begin
      if lstThreads.Items.Count < FThreads.Count then begin
        //Add a new list item...
        I:= lstThreads.Items.Add;
        I.SubItems.Add('');
        I.SubItems.Add('');
        I.SubItems.Add('');
      end else begin
        //Delete a list item
        if lstThreads.Items.Count > 0 then
          lstThreads.Items.Delete(0);
      end;
    end;

    //Update list items to match objects...
    for X := 0 to FThreads.Count-1 do begin
      T:= FThreads[X];
      I:= lstThreads.Items[X];
      T.Lock;
      try
        I.Caption:= IntToStr(T.ThreadID);
        I.SubItems[0]:= IntToStr(T.Cur);
        I.SubItems[1]:= IntToStr(T.CountTo);
        //I.SubItems[2]:= FormatFloat('0.000%', (T.Cur / T.CountTo) * 100);
        I.Update;
      finally
        T.Unlock;
      end;
    end;

  finally
    FLock.Leave;
  end;
end;

procedure TfrmDemoHurtMyCpu.AddRef(ARef: THurtMyCpuThread);
begin
  FLock.Enter;
  try
    ARef.Lock;
    try
      FThreads.Add(ARef);
    finally
      ARef.Unlock;
    end;
  finally
    FLock.Leave;
  end;
end;

procedure TfrmDemoHurtMyCpu.DeleteRef(ARef: THurtMyCpuThread);
begin
  FLock.Enter;
  try
    ARef.Lock;
    try
      FThreads.Delete(FThreads.IndexOf(ARef));
    finally
      ARef.Unlock;
    end;
  finally
    FLock.Leave;
  end;
end;

procedure TfrmDemoHurtMyCpu.UpdateRef(ARef: THurtMyCpuThread);
begin
  FLock.Enter;
  try
    //TODO...
  finally
    FLock.Leave;
  end;
end;

procedure TfrmDemoHurtMyCpu.DoSpawn(const CountTo: Integer);
var
  T: THurtMyCpuThread;
begin
  //Creates an actual instance of a thread which consumes 100% of a CPU core.
  T:= THurtMyCpuThread.Create(CountTo);
  T.OnAddRef:= AddRef;
  T.OnDeleteRef:= DeleteRef;
  T.Start;
end;

end.
