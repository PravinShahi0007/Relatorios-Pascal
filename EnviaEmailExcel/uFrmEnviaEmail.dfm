object Form1: TForm1
  Left = 0
  Top = 0
  Caption = '%st Venda Di'#225'ria'
  ClientHeight = 115
  ClientWidth = 233
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnExecutar: TButton
    Left = 16
    Top = 16
    Width = 70
    Height = 25
    Caption = 'Executar'
    TabOrder = 0
    OnClick = btnExecutarClick
  end
  object ACBrMail1: TACBrMail
    Host = '127.0.0.1'
    Port = '25'
    SetSSL = False
    SetTLS = False
    Attempts = 3
    DefaultCharset = UTF_8
    IDECharset = CP1252
    Left = 108
    Top = 11
  end
end
