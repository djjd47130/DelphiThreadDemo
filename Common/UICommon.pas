unit UICommon;

interface

uses
  System.Classes, System.SysUtils,
  Winapi.Windows,
  Vcl.Controls, Vcl.Graphics, Vcl.ComCtrls;

function ListViewCellRect(AListView: TCustomListView; AColIndex: Integer;
  AItemIndex: Integer): TRect;

procedure DrawProgressBar(const ACanvas: TCanvas; const ARect: TRect;
  const APercent: Single;
  const ABackColor: TColor = clGray; const AForeColor: TColor = clNavy;
  const AText: String = '');

implementation

function ListViewCellRect(AListView: TCustomListView; AColIndex: Integer;
  AItemIndex: Integer): TRect;
var
  I: Integer;
begin
  Result:= AListView.Items[AItemIndex].DisplayRect(TDisplayCode.drBounds);
  for I:= 0 to AColIndex-1 do
    Result.Left := Result.Left + AListView.Column[I].Width;
  Result.Width:= AListView.Column[AColIndex].Width;
end;

procedure DrawProgressBar(const ACanvas: TCanvas; const ARect: TRect;
  const APercent: Single;
  const ABackColor: TColor = clGray; const AForeColor: TColor = clNavy;
  const AText: String = '');
const
  DRAW_FLAGS = DT_SINGLELINE or DT_CENTER or DT_VCENTER;
var
  BR, FR, TR: TRect;
  S: String;
begin
  //Draw background
  BR:= ARect;
  InflateRect(BR, -2, -2);
  ACanvas.Pen.Width:= 1;
  ACanvas.Pen.Style:= psSolid;
  ACanvas.Pen.Color:= AForeColor;
  ACanvas.Brush.Style:= bsSolid;
  ACanvas.Brush.Color:= ABackColor;
  ACanvas.Rectangle(BR);

  //Draw foreground
  FR:= BR;
  InflateRect(FR, -1, -1);
  FR.Width:= Trunc(FR.Width * APercent);
  ACanvas.Pen.Style:= psClear;
  ACanvas.Brush.Color:= AForeColor;
  ACanvas.FillRect(FR);

  //Draw text
  TR:= BR;
  ACanvas.Font.Color:= clWhite;
  ACanvas.Font.Style:= [fsBold];
  ACanvas.Font.Height:= ARect.Height - 6;
  ACanvas.Pen.Style:= psClear;
  ACanvas.Brush.Style:= bsClear;
  if AText = '' then
    S:= FormatFloat('0%', APercent * 100)
  else
    S:= AText;
  DrawText(ACanvas.Handle, PChar(S), Length(S), TR, DRAW_FLAGS);

end;

end.
