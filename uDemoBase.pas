unit uDemoBase;

interface

(*
  This form is the base for all other demo content forms. All of them are
  inherited from this one. `SetEnabledState()` should be overridden
  in order to imlement enabling/disabling controls when it is busy.
*)

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmDemoBase = class;

  TDemoFormClass = class of TfrmDemoBase;

  TfrmDemoBase = class(TForm)
  private

  public
    procedure SetEnabledState(const Enabled: Boolean); virtual;
  end;

var
  frmDemoBase: TfrmDemoBase;

implementation

{$R *.dfm}

{ TfrmDemoBase }

procedure TfrmDemoBase.SetEnabledState(const Enabled: Boolean);
begin
  //Nothing here, instead the inherited forms will implement this...

end;

end.
