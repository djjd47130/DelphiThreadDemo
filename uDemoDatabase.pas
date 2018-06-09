unit uDemoDatabase;

(*
  Demonstrates how to use databases via ADO in threads.
*)

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDemoBase, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons;

type
  TfrmDemoDatabase = class(TfrmDemoBase)
    Label1: TLabel;
    Label12: TLabel;
    Panel1: TPanel;
    Label4: TLabel;
    txtConnStr: TEdit;
    btnConnStr: TSpeedButton;
    Panel2: TPanel;
    Label2: TLabel;
    Memo1: TMemo;
    Panel3: TPanel;
    btnExec: TBitBtn;
    procedure btnExecClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDemoDatabase: TfrmDemoDatabase;

implementation

{$R *.dfm}

procedure TfrmDemoDatabase.btnExecClick(Sender: TObject);
begin
  inherited;
  //TODO: Execute query and show results in grid...

end;

end.
