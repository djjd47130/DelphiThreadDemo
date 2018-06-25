unit uDemoCriticalSections;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDemoBase, Vcl.StdCtrls;

type
  TfrmDemoCriticalSections = class(TfrmDemoBase)
    Label12: TLabel;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDemoCriticalSections: TfrmDemoCriticalSections;

implementation

{$R *.dfm}

end.
