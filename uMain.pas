unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls,
  ShellApi,
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
  uDemoHurtMyCpu, System.ImageList, Vcl.ImgList;

type
  TfrmMain = class(TForm)
    Pages: TPageControl;
    TabSheet8: TTabSheet;
    Label11: TLabel;
    Label12: TLabel;
    pMain: TGridPanel;
    lstMenu: TListView;
    Stat: TStatusBar;
    imgPages: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure PagesChange(Sender: TObject);
    procedure lstMenuSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure StatClick(Sender: TObject);
  private
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
  Width:= 1100;
  Height:= 700;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  PopulateMenu;
end;

procedure TfrmMain.EmbedAllForms;
begin
  EmbedForm(TfrmDemoDownload,         'Downloading');
  EmbedForm(TfrmDemoProgress,         'Progress Bar');
  EmbedForm(TfrmDemoCriticalSections, 'Critical Sections');
  EmbedForm(TfrmDemoWindowsMessages,  'Windows Messages');
  EmbedForm(TfrmDemoThreadQueue,      'Queues');
  EmbedForm(TfrmDemoDatabase,         'Database');
  EmbedForm(TfrmDemoHttpServer,       'HTTP Server');
  EmbedForm(TfrmDemoThreadPools,      'Thread Pools');
  EmbedForm(TfrmDemoOmniThreads,      'Omni Threads');
  EmbedForm(TfrmDemoHurtMyCpu,        'Hurt My CPU');
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
  imgPages.AddIcon(F.Icon);
  T.ImageIndex:= imgPages.Count-1;
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
  Result:= Result + 32;
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

end.
