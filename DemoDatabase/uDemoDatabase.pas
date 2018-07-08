unit uDemoDatabase;

(*
  Demonstrates how to use databases via ADO in threads.
*)

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDemoBase, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.Grids,
  ADODB,
  DatabaseThread, Vcl.ComCtrls, Vcl.Imaging.GIFImg;

type
  TfrmDemoDatabase = class(TfrmDemoBase)
    Label12: TLabel;
    Panel1: TPanel;
    Label4: TLabel;
    txtConnStr: TEdit;
    btnConnStr: TSpeedButton;
    Panel2: TPanel;
    Label2: TLabel;
    txtSql: TMemo;
    Panel3: TPanel;
    btnExec: TBitBtn;
    gData: TStringGrid;
    pSpinner: TPanel;
    imgSpinner: TImage;
    procedure btnExecClick(Sender: TObject);
    procedure btnConnStrClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    procedure ThreadData(Sender: TObject; Dataset: TLightDataset);
    procedure ThreadException(Sender: TObject; E: Exception);
    procedure LoadDataIntoGrid(AData: TLightDataset);
    procedure ClearGrid;
  public
    procedure SetEnabledState(const Enabled: Boolean); override;
  end;

var
  frmDemoDatabase: TfrmDemoDatabase;

implementation

{$R *.dfm}

procedure TfrmDemoDatabase.ClearGrid;
begin
  gData.RowCount:= 2;
  gData.ColCount:= 1;
  gData.Cols[0].Clear;
end;

procedure TfrmDemoDatabase.FormCreate(Sender: TObject);
begin
  inherited;
  imgSpinner.Align:= alClient;
  pSpinner.Width:= 300;
  pSpinner.Height:= 300;
end;

procedure TfrmDemoDatabase.FormResize(Sender: TObject);
begin
  inherited;
  pSpinner.Left:= (ClientWidth div 2) - (pSpinner.Width div 2);
  pSpinner.Top:= (ClientHeight div 2) - (pSpinner.Height div 2);
end;

procedure TfrmDemoDatabase.btnConnStrClick(Sender: TObject);
begin
  inherited;
  txtConnStr.Text:= PromptDataSource(Self.Handle, txtConnStr.Text);
end;

procedure TfrmDemoDatabase.btnExecClick(Sender: TObject);
var
  T: TDatabaseThread;
begin
  inherited;
  SetEnabledState(False);
  ClearGrid;
  T:= TDatabaseThread.Create;
  T.ConnStr:= Self.txtConnStr.Text;
  T.Sql.Assign(Self.txtSql.Lines);
  T.OnData:= ThreadData;
  T.OnException:= ThreadException;
  T.FreeOnTerminate:= True;
  T.Start;
  //DO NOT TRY TO ACCESS T AFTER THIS POINT since it's FreeOnTerminate
end;

procedure TfrmDemoDatabase.SetEnabledState(const Enabled: Boolean);
begin
  inherited;
  btnExec.Enabled:= Enabled;
  txtConnStr.Enabled:= Enabled;
  txtSql.Enabled:= Enabled;
  btnConnStr.Enabled:= Enabled;
  pSpinner.Visible:= not Enabled;
  TGifImage(imgSpinner.Picture.Graphic).Animate:= not Enabled;
end;

procedure TfrmDemoDatabase.ThreadData(Sender: TObject; Dataset: TLightDataset);
begin
  //Received dataset response from thread...
  LoadDataIntoGrid(Dataset);
  SetEnabledState(True);
end;

procedure TfrmDemoDatabase.ThreadException(Sender: TObject; E: Exception);
begin
  //Received exception response from thread...
  MessageDlg('EXCEPTION: '+E.Message, mtError, [mbOK], 0);
  SetEnabledState(True);
end;

procedure TfrmDemoDatabase.LoadDataIntoGrid(AData: TLightDataset);
var
  X: Integer;
begin

  //Set grid size...
  gData.ColCount:= AData.ColCount;
  if AData.RowCount > 1 then
    gData.RowCount:= AData.RowCount+1
  else
    gData.RowCount:= 2;

  //Column headers...
  for X := 0 to AData.ColCount-1 do begin
    gData.Cells[X, 0]:= AData.Cols[X];
  end;

  //Rows of data...
  for X := 0 to AData.RowCount-1 do begin
    //Since the grid's rows support assigning a complete list of values...
    gData.Rows[X+1].Assign(AData.Rows[X]);
  end;

end;

end.
