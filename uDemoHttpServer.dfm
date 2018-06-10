inherited frmDemoHttpServer: TfrmDemoHttpServer
  Caption = 'Indy HTTP Server Context Threads'
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 304
    Width = 774
    Height = 143
    Align = alBottom
    Alignment = taCenter
    Caption = 'Coming Soon'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -56
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Label12: TLabel
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 760
    Height = 55
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'Indy'#39's TIdHTTPServer automatically spawns new threads via "Conte' +
      'xt" classes. Each context represents a client connection on the ' +
      'server-side.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
    ExplicitWidth = 680
  end
  object pMain: TPanel
    Left = 0
    Top = 75
    Width = 780
    Height = 198
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    OnResize = pMainResize
    object pSvr: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 198
      Align = alLeft
      TabOrder = 0
      ExplicitHeight = 259
      object Label2: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 312
        Height = 19
        Align = alTop
        Alignment = taCenter
        Caption = 'Server'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 53
      end
      object Panel5: TPanel
        Left = 1
        Top = 57
        Width = 318
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object btnSvrStart: TBitBtn
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 150
          Height = 35
          Align = alLeft
          Caption = 'Start Server'
          TabOrder = 0
          OnClick = btnSvrStartClick
        end
        object btnSvrStop: TBitBtn
          AlignWithMargins = True
          Left = 159
          Top = 3
          Width = 150
          Height = 35
          Align = alLeft
          Caption = 'Stop Server'
          Enabled = False
          TabOrder = 1
          OnClick = btnSvrStopClick
        end
      end
      object Panel4: TPanel
        Left = 1
        Top = 26
        Width = 318
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Label4: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 69
          Height = 25
          Align = alLeft
          AutoSize = False
          Caption = 'TCP Port #'
          Layout = tlCenter
          ExplicitTop = 5
        end
        object sePort: TSpinEdit
          AlignWithMargins = True
          Left = 79
          Top = 6
          Width = 81
          Height = 22
          MaxValue = 65535
          MinValue = 1
          TabOrder = 0
          Value = 8008
        end
      end
      object lstClients: TListView
        AlignWithMargins = True
        Left = 4
        Top = 101
        Width = 312
        Height = 50
        Align = alTop
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderStyle = bsNone
        Columns = <
          item
            Caption = 'Thread ID'
            Width = 70
          end
          item
            AutoSize = True
            Caption = 'Client Name'
          end
          item
            Caption = 'Port #'
            Width = 80
          end>
        TabOrder = 2
        ViewStyle = vsReport
        ExplicitHeight = 111
      end
    end
    object pCli: TPanel
      Left = 497
      Top = 0
      Width = 283
      Height = 198
      Align = alRight
      TabOrder = 1
      ExplicitHeight = 259
      object Label3: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 275
        Height = 19
        Align = alTop
        Alignment = taCenter
        Caption = 'Client'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 48
      end
    end
  end
  object Svr: TIdHTTPServer
    Bindings = <>
    DefaultPort = 8008
    Left = 16
    Top = 400
  end
  object Cli: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 648
    Top = 400
  end
end
