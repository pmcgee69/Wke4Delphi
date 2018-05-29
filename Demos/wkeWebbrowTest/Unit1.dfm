object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 482
  ClientWidth = 636
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object WkeWebBrowser1: TWkeWebBrowser
    Left = 0
    Top = 0
    Width = 636
    Height = 421
    Align = alTop
    Color = clWhite
    UserAgent = 
      'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, l' +
      'ike Gecko) Chrome/31.0.1650.63 Safari/537.36 Langji.Wke 1.0'
    ZoomPercent = 100
    OnTitleChange = WkeWebBrowser1TitleChange
    OnCreateView = WkeWebBrowser1CreateView
    ExplicitHeight = 374
  end
  object Button1: TButton
    Left = 56
    Top = 440
    Width = 75
    Height = 25
    Caption = #21462#28304#30721
    TabOrder = 1
    OnClick = Button1Click
  end
end
