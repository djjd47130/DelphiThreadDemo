inherited frmDemoHurtMyCpu: TfrmDemoHurtMyCpu
  Caption = 'Stress your processor with threads'
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lblWarning: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 78
    Width = 774
    Height = 36
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'WARNING: If you spawn more threads than you have CPU cores, you ' +
      'could lock up your PC!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
    StyleElements = [seClient, seBorder]
    ExplicitLeft = 8
    ExplicitTop = 36
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
      'This demonstrates a heavy load on your processor by spawning mul' +
      'tiple threads which each do heavy amounts of work with no delay.'
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
  object Bevel1: TBevel
    Left = 0
    Top = 150
    Width = 780
    Height = 10
    Align = alTop
    Shape = bsBottomLine
  end
  object lstThreads: TListView
    AlignWithMargins = True
    Left = 3
    Top = 208
    Width = 774
    Height = 239
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderStyle = bsNone
    Columns = <
      item
        Caption = 'Thread ID'
        Width = 150
      end
      item
        Caption = 'Current'
        Width = 150
      end
      item
        Caption = 'Total'
        Width = 150
      end
      item
        Caption = 'Progress'
        Width = 250
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
    OnCustomDrawItem = lstThreadsCustomDrawItem
    OnCustomDrawSubItem = lstThreadsCustomDrawSubItem
    ExplicitLeft = -2
    ExplicitTop = 211
  end
  object Panel1: TPanel
    Left = 0
    Top = 117
    Width = 780
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 0
    ExplicitWidth = 397
    object Label1: TLabel
      AlignWithMargins = True
      Left = 257
      Top = 3
      Width = 60
      Height = 27
      Align = alLeft
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Count To:'
      Layout = tlCenter
      ExplicitLeft = 241
    end
    object btnSpawn: TBitBtn
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 121
      Height = 27
      Cursor = crHandPoint
      Align = alLeft
      Caption = 'Spawn a Thread'
      TabOrder = 0
      OnClick = btnSpawnClick
    end
    object btnStop: TBitBtn
      AlignWithMargins = True
      Left = 130
      Top = 3
      Width = 121
      Height = 27
      Cursor = crHandPoint
      Align = alLeft
      Caption = 'Stop All Threads'
      TabOrder = 1
      OnClick = btnStopClick
    end
    object txtCountTo: TEdit
      AlignWithMargins = True
      Left = 323
      Top = 7
      Width = 94
      Height = 19
      Margins.Top = 7
      Margins.Bottom = 7
      Align = alLeft
      TabOrder = 2
      Text = '2147483647'
      ExplicitLeft = 307
    end
  end
  object Tmr: TTimer
    Interval = 400
    OnTimer = TmrTimer
    Left = 16
    Top = 160
  end
end
