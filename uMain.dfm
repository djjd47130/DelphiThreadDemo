object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'JD Thread Demo'
  ClientHeight = 558
  ClientWidth = 959
  Color = clWhite
  Constraints.MinHeight = 500
  Constraints.MinWidth = 820
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pbCPU: TPaintBox
    AlignWithMargins = True
    Left = 5
    Top = 504
    Width = 949
    Height = 28
    Hint = 'Current CPU load'
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alBottom
    OnPaint = pbCPUPaint
    ExplicitLeft = 3
    ExplicitTop = 507
    ExplicitWidth = 953
  end
  object Pages: TPageControl
    Left = 0
    Top = 0
    Width = 959
    Height = 449
    ActivePage = TabSheet8
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Images = imgPagesSmall
    TabHeight = 28
    TabOrder = 0
    OnChange = PagesChange
    object TabSheet8: TTabSheet
      Hint = 'Home page'
      Caption = ' Home '
      ExplicitLeft = 3
      ExplicitTop = 38
      object Label11: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 5
        Width = 941
        Height = 52
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'JD Thread Demo Application'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -35
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitWidth = 666
      end
      object Label12: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 72
        Width = 931
        Height = 41
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'How to implement threads in Delphi for various purposes'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        WordWrap = True
        ExplicitWidth = 726
      end
      object Label2: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 395
        Width = 945
        Height = 13
        Cursor = crHandPoint
        Hint = 'Click to open the GitHub repository page'
        Align = alBottom
        Alignment = taCenter
        Caption = 'Created by Jerry Dodge for "Can I Use VCL From Threads?"'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16744448
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
        Layout = tlCenter
        StyleElements = [seClient, seBorder]
        OnClick = StatClick
        ExplicitTop = 435
        ExplicitWidth = 286
      end
      object pMain: TGridPanel
        AlignWithMargins = True
        Left = 3
        Top = 126
        Width = 945
        Height = 263
        Align = alClient
        BevelOuter = bvNone
        ColumnCollection = <
          item
            SizeStyle = ssAbsolute
            Value = 100.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 400.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 100.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 1
            Control = lstMenu
            Row = 0
          end>
        RowCollection = <
          item
            Value = 100.000000000000000000
          end>
        TabOrder = 0
        ExplicitHeight = 303
        object lstMenu: TListView
          AlignWithMargins = True
          Left = 103
          Top = 3
          Width = 394
          Height = 257
          Hint = 'Click any item to open its demo screen'
          Align = alClient
          BorderStyle = bsNone
          Columns = <
            item
              AutoSize = True
              Caption = 'Item'
            end>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 16744448
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          HotTrackStyles = [htHandPoint, htUnderlineHot]
          IconOptions.AutoArrange = True
          Items.ItemData = {
            05A40100000600000000000000FFFFFFFFFFFFFFFF00000000FFFFFFFF000000
            00094D00610069006E0020004D0065006E00750000000000FFFFFFFFFFFFFFFF
            00000000FFFFFFFF000000001F4C0069007300740020006900740065006D0073
            002000640079006E0061006D006900630061006C006C00790020007200650070
            006C00610063006500640000000000FFFFFFFFFFFFFFFF00000000FFFFFFFF00
            0000001E6200790020007400690074006C006500730020006F00660020006500
            610063006800200063006F006E00740065006E007400200066006F0072006D00
            00000000FFFFFFFFFFFFFFFF00000000FFFFFFFF000000000000000000FFFFFF
            FFFFFFFFFF00000000FFFFFFFF000000001E4C00690073007400200069007300
            20006100750074006F006D00610074006900630061006C006C00790020006300
            65006E007400650072006500640000000000FFFFFFFFFFFFFFFF00000000FFFF
            FFFF0000000020770069007400680069006E002000690074007300200063006F
            006E007400610069006E0065007200200069006E002000720075006E00740069
            006D0065002E00}
          LargeImages = imgPagesLarge
          StyleElements = [seClient, seBorder]
          ReadOnly = True
          RowSelect = True
          ParentFont = False
          ShowColumnHeaders = False
          SmallImages = imgPagesSmall
          TabOrder = 0
          ViewStyle = vsReport
          OnSelectItem = lstMenuSelectItem
          ExplicitHeight = 297
        end
      end
    end
  end
  object Stat: TStatusBar
    Left = 0
    Top = 537
    Width = 959
    Height = 21
    Cursor = crHandPoint
    Hint = 'Don'#39't point at me like that!'
    AutoHint = True
    Panels = <
      item
        Width = 50
      end>
  end
  object imgPagesSmall: TImageList
    Height = 24
    Width = 24
    Left = 128
  end
  object imgPagesLarge: TImageList
    Height = 48
    Width = 48
    Left = 208
  end
  object Tmr: TTimer
    Interval = 250
    OnTimer = TmrTimer
    Left = 16
    Top = 168
  end
end
