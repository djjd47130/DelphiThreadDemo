unit uDemoHurtMyCpu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDemoBase, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls,
  System.SyncObjs, System.Generics.Collections,
  HurtMyCpuThread;

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
    FThreads: TObjectList<TThreadRef>;
    FTerminated: Boolean;
    procedure DoSpawn(const CountTo: Integer);
  public
    procedure AddRef(ARef: TThreadRef);
    procedure UpdateRef(ARef: TThreadRef);
    procedure DeleteRef(ARef: TThreadRef);
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
  FThreads:= TObjectList<TThreadRef>.Create(False);
end;

procedure TfrmDemoHurtMyCpu.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(FThreads);
  FreeAndNil(FLock);
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
  T: TThreadRef;
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

procedure TfrmDemoHurtMyCpu.AddRef(ARef: TThreadRef);
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

procedure TfrmDemoHurtMyCpu.DeleteRef(ARef: TThreadRef);
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

procedure TfrmDemoHurtMyCpu.UpdateRef(ARef: TThreadRef);
begin
  FLock.Enter;
  try
    //TODO...
  finally
    FLock.Leave;
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
  T: TThreadRef;
begin
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

{$HINTS OFF}
procedure TfrmDemoHurtMyCpu.DoSpawn(const CountTo: Integer);
begin

  TThread.CreateAnonymousThread(
    procedure
    var
      T: TThreadRef;
      X, Y, Z: Int64;
    begin
      T:= TThreadRef.Create;
      try
        if FTerminated then Exit;
        T.CountTo:= CountTo;
        TThread.Synchronize(nil,
          procedure
          begin
            AddRef(T);
          end);
        if FTerminated then Exit;
        for X := 1 to CountTo do begin
          if FTerminated or T.IsTerminated then Break;
          {$IFDEF DBL_LVL}
          for Y := 1 to MAXINT_JD do begin
          {$ENDIF}
            if FTerminated or T.IsTerminated then Break;
            T.Lock;
            try
              if T.IsTerminated then Break;

              //This is the calculation which actually hurts the CPU
              //  by executing it rapidly with no delay over and over...
              Z:= Round(X/2);

              //TODO: Think of something heavier...

              T.Cur:= X;
            finally
              T.Unlock;
            end;
          {$IFDEF DBL_LVL}
          end;
          {$ENDIF}
        end;

        if FTerminated then Exit;

        TThread.Synchronize(nil,
          procedure
          begin
            DeleteRef(T);
          end);

      finally
        FreeAndNil(T);
      end;
    end).Start;
end;
{$HINTS ON}

end.
