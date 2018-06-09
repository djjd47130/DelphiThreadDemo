inherited frmDemoProgress: TfrmDemoProgress
  Caption = 'Monitoring Progress of Long Tasks'
  PixelsPerInch = 96
  TextHeight = 13
  object lblProgMsg: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 188
    Width = 774
    Height = 25
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Press a button above to begin long task.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 694
  end
  object Label4: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 109
    Width = 774
    Height = 32
    Align = alTop
    AutoSize = False
    Caption = 
      'Clicking any one of these will perform a lengthy task using the ' +
      'same universal procedure, but using different methods.'
    Layout = tlCenter
    ExplicitLeft = 8
    ExplicitTop = 75
    ExplicitWidth = 694
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
      'Progress can be reported from a thread through synchronized even' +
      'ts, or callback methods, which carry the progress information vi' +
      'a parameters.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
    ExplicitLeft = 15
    ExplicitTop = -31
    ExplicitWidth = 680
  end
  object Prog: TProgressBar
    AlignWithMargins = True
    Left = 3
    Top = 78
    Width = 774
    Height = 25
    Align = alTop
    TabOrder = 0
  end
  object Panel5: TPanel
    Left = 0
    Top = 144
    Width = 780
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btnProgressNoThread: TBitBtn
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 217
      Height = 35
      Cursor = crHandPoint
      Align = alLeft
      BiDiMode = bdLeftToRight
      Caption = 'Progress Without Thread'
      ParentBiDiMode = False
      TabOrder = 0
      OnClick = btnProgressNoThreadClick
    end
    object btnProgressThreadClass: TBitBtn
      AlignWithMargins = True
      Left = 226
      Top = 3
      Width = 217
      Height = 35
      Cursor = crHandPoint
      Align = alLeft
      Caption = 'Progress With Thread Class'
      TabOrder = 1
      OnClick = btnProgressThreadClassClick
    end
    object btnProgressAnonymous: TBitBtn
      AlignWithMargins = True
      Left = 449
      Top = 3
      Width = 217
      Height = 35
      Cursor = crHandPoint
      Align = alLeft
      Caption = 'Progress With Anonymous Thread'
      Enabled = False
      TabOrder = 2
      OnClick = btnProgressAnonymousClick
    end
  end
  object tmrProgress: TTimer
    Interval = 200
    OnTimer = tmrProgressTimer
    Left = 120
    Top = 416
  end
end
