unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellApi,
  System.SysUtils, System.Variants, System.Classes, System.ImageList,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.ImgList,

  UICommon,
  CpuMonitor,

  uDemoBase,
  uDemoDownload,
  uDemoProgress,
  uDemoCriticalSections,
  uDemoWindowsMessages,
  uDemoThreadPools,
  uDemoDatabase,
  uDemoHttpServer,
  uDemoThreadQueue,
  uDemoOmniThreads,
  uDemoHurtMyCpu,
  uDemoCapture
  ;

type
  TfrmMain = class(TForm)
    Pages: TPageControl;
    TabSheet8: TTabSheet;
    Label11: TLabel;
    Label12: TLabel;
    pMain: TGridPanel;
    lstMenu: TListView;
    Stat: TStatusBar;
    imgPagesSmall: TImageList;
    imgPagesLarge: TImageList;
    Label2: TLabel;
    pbCPU: TPaintBox;
    Tmr: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure PagesChange(Sender: TObject);
    procedure lstMenuSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure StatClick(Sender: TObject);
    procedure pbCPUPaint(Sender: TObject);
    procedure TmrTimer(Sender: TObject);
  private
    FCpu: Double;
    procedure EmbedForm(AFormClass: TDemoFormClass;
      ACaption: String);
    procedure PopulateMenu;
    function MenuWidth: Integer;
    procedure EmbedAllForms;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown:= True;
  {$ENDIF}
  Pages.Align:= alClient;
  EmbedAllForms;
  Pages.ActivePageIndex:= 0;
  PagesChange(nil);
  Width:= 1200;
  Height:= 720;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  PopulateMenu;
end;

procedure TfrmMain.EmbedAllForms;
begin
  imgPagesSmall.Clear;
  imgPagesLarge.Clear;
  imgPagesSmall.AddIcon(Application.Icon);
  imgPagesLarge.AddIcon(Application.Icon);
  EmbedForm(TfrmDemoDownload,         'Download');
  EmbedForm(TfrmDemoProgress,         'Progress');
  EmbedForm(TfrmDemoCriticalSections, 'Critical Section');
  EmbedForm(TfrmDemoWindowsMessages,  'Windows Messages');
  EmbedForm(TfrmDemoThreadQueue,      'Queues');
  EmbedForm(TfrmDemoDatabase,         'Database');
  EmbedForm(TfrmDemoHttpServer,       'HTTP Server');
  EmbedForm(TfrmDemoThreadPools,      'Thread Pool');
  EmbedForm(TfrmDemoOmniThreads,      'Omni Thread');
  EmbedForm(TfrmDemoHurtMyCpu,        'Hurt My CPU');
  EmbedForm(TfrmDemoCapture,          'Capture');
end;

procedure TfrmMain.EmbedForm(AFormClass: TDemoFormClass;
  ACaption: String);
var
  T: TTabSheet;
  F: TfrmDemoBase;
begin
  //Create new tab sheet...
  T:= TTabSheet.Create(Pages);
  T.PageControl:= Pages;
  T.Caption:= ACaption;
  //Create an instance of given form class and embed in given tab sheet...
  F:= TfrmDemoBase(AFormClass.Create(T));
  F.Parent:= T;
  F.Align:= alClient;
  F.Show;
  //Add image to tab...
  //TODO: For some reason AddIcon is being dicky with choosing the right size...
  imgPagesSmall.AddIcon(F.Icon);
  imgPagesLarge.AddIcon(F.Icon);
  T.ImageIndex:= imgPagesSmall.Count-1;
  T.Hint:= F.Caption;
end;

procedure TfrmMain.FormResize(Sender: TObject);
var
  W: Double;
begin
  W:= (pMain.Width - lstMenu.Width) / 2;
  pMain.ColumnCollection[1].Value:= MenuWidth;
  pMain.ColumnCollection[0].Value:= W;
  pMain.ColumnCollection[2].Value:= W;
end;

function TfrmMain.MenuWidth: Integer;
var
  X, W: Integer;
  I: TListItem;
begin
  Result:= 0;
  lstMenu.Canvas.Font.Assign(lstMenu.Font);
  for X := 0 to lstMenu.Items.Count-1 do begin
    I:= lstMenu.Items[X];
    W:= lstMenu.Canvas.TextWidth(I.Caption);
    if W > Result then
      Result:= W;
  end;
  Result:= Result + 42;
end;

procedure TfrmMain.PopulateMenu;
var
  X: Integer;
  F: TfrmDemoBase;
  I: TListItem;
begin
  lstMenu.Items.Clear;
  for X := 1 to Pages.PageCount-1 do begin
    F:= TfrmDemoBase(Pages.Pages[X].Controls[0]);
    I:= lstMenu.Items.Add;
    I.Caption:= F.Caption;
    I.ImageIndex:= X;
  end;
  FormResize(nil);
end;

procedure TfrmMain.StatClick(Sender: TObject);
var
  URL: string;
begin
  URL := 'https://github.com/djjd47130/DelphiThreadDemo';
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmMain.TmrTimer(Sender: TObject);
begin
  FCpu:= GetTotalCpuUsagePct;
  FCpu:= FCpu / 100;
  pbCPU.Invalidate;
end;

procedure TfrmMain.lstMenuSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then begin
    Pages.ActivePageIndex:= Item.Index + 1;
    lstMenu.ItemIndex:= -1;
    PagesChange(nil);
  end;
end;

procedure TfrmMain.PagesChange(Sender: TObject);
var
  F: TfrmDemoBase;
  S: String;
begin
  if Pages.ActivePageIndex = 0 then begin
    S:= 'Home';
  end else begin
    F:= TfrmDemoBase(Pages.ActivePage.Controls[0]);
    S:= F.Caption;
  end;
  Caption:= 'JD Thread Demo - ' + S;
end;

procedure TfrmMain.pbCPUPaint(Sender: TObject);
begin
  DrawProgressBar(pbCPU.Canvas, pbCPU.Canvas.ClipRect, FCPU, clGray, clNavy, 'CPU Usage');
end;

end.
