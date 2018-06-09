unit uDemoWindowsMessages;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDemoBase, Vcl.StdCtrls;

type
  TfrmDemoWindowsMessages = class(TfrmDemoBase)
    Label1: TLabel;
    Label12: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDemoWindowsMessages: TfrmDemoWindowsMessages;

implementation

{$R *.dfm}

end.
