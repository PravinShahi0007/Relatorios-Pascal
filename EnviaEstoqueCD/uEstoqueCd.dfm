object frmEstoqueCD: TfrmEstoqueCD
  Left = 0
  Top = 0
  Caption = 'Relatorio_Venda_dia_Email'
  ClientHeight = 200
  ClientWidth = 346
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object btnImprimir: TBitBtn
    Left = 225
    Top = 135
    Width = 90
    Height = 25
    Caption = '&Gerar'
    NumGlyphs = 2
    TabOrder = 0
    OnClick = btnImprimirClick
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=192.168.200.110:1522/GRZPROD'
      'User_Name=nl'
      'Password=nl'
      'DriverID=Ora')
    Connected = True
    LoginPrompt = False
    Left = 42
    Top = 14
  end
  object FDPhysOracleDriverLink1: TFDPhysOracleDriverLink
    DriverID = 'NL'
    VendorLib = 'oci.dll'
    Left = 42
    Top = 62
  end
  object dtsCadastrosNovos: TDataSource
    DataSet = qry
    Left = 248
    Top = 7
  end
  object qry: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      '')
    Left = 136
    Top = 8
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 136
    Top = 64
  end
  object dtsCadastros: TDataSource
    DataSet = FDQuery1
    Left = 216
    Top = 55
  end
  object ACBrMail1: TACBrMail
    Host = '127.0.0.1'
    Port = '25'
    SetSSL = False
    SetTLS = False
    Attempts = 3
    DefaultCharset = UTF_8
    IDECharset = CP1252
    Left = 72
    Top = 128
  end
end
