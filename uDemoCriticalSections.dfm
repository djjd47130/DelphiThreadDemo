inherited frmDemoCriticalSections: TfrmDemoCriticalSections
  Caption = 'Critical Sections in Threads'
  PixelsPerInch = 96
  TextHeight = 13
  object Label12: TLabel
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 680
    Height = 55
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'A Critical Section is a type of "Lock" which protects resources ' +
      'from being accessed by multiple threads at the same time. This d' +
      'emo shows how critical sections work between threads.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
  object Label1: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 78
    Width = 694
    Height = 369
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
    ExplicitTop = 120
    ExplicitWidth = 370
    ExplicitHeight = 68
  end
end
