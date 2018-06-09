inherited frmDemoThreadPools: TfrmDemoThreadPools
  Caption = 'Using Thread Pools for Many Tasks'
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 77
    Width = 694
    Height = 370
    Align = alClient
    Alignment = taCenter
    Caption = 'Coming Soon'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -56
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
    ExplicitTop = 3
    ExplicitWidth = 370
    ExplicitHeight = 68
  end
  object Label12: TLabel
    AlignWithMargins = True
    Left = 5
    Top = 5
    Width = 690
    Height = 64
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'A thread pool is a collection of threads for equally dividing up' +
      ' multiple tasks. They typically have a "max thread" and keep a q' +
      'ueue of tasks to perform, each of which is forwarded to the next' +
      ' available thread.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
end
