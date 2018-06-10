inherited frmDemoHurtMyCpu: TfrmDemoHurtMyCpu
  Caption = 'Stress your processor with threads'
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 36
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
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
    StyleElements = [seClient, seBorder]
    ExplicitWidth = 435
  end
  object lstThreads: TListView
    AlignWithMargins = True
    Left = 3
    Top = 232
    Width = 774
    Height = 215
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderStyle = bsNone
    Columns = <
      item
        Caption = 'Thread ID'
        Width = 120
      end
      item
        Caption = 'Current'
        Width = 120
      end
      item
        Caption = 'Total'
        Width = 120
      end
      item
        Caption = '%'
        Width = 120
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 780
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 397
    object Label1: TLabel
      AlignWithMargins = True
      Left = 241
      Top = 3
      Width = 60
      Height = 27
      Align = alLeft
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Count To:'
      Layout = tlCenter
    end
    object btnSpawn: TBitBtn
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 113
      Height = 27
      Cursor = crHandPoint
      Align = alLeft
      Caption = 'Spawn a Thread'
      TabOrder = 0
      OnClick = btnSpawnClick
    end
    object btnStop: TBitBtn
      AlignWithMargins = True
      Left = 122
      Top = 3
      Width = 113
      Height = 27
      Cursor = crHandPoint
      Align = alLeft
      Caption = 'Stop All Threads'
      TabOrder = 1
      OnClick = btnStopClick
    end
    object txtCountTo: TEdit
      AlignWithMargins = True
      Left = 307
      Top = 7
      Width = 94
      Height = 19
      Margins.Top = 7
      Margins.Bottom = 7
      Align = alLeft
      TabOrder = 2
      Text = '2147483647'
    end
  end
  object Tmr: TTimer
    Interval = 400
    OnTimer = TmrTimer
    Left = 72
    Top = 120
  end
end
