object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'frmPrincipal'
  ClientHeight = 214
  ClientWidth = 341
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
  object btnImprimir: TBitBtn
    Left = 201
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
      'DriverID=Ora')
    LoginPrompt = False
    Left = 42
    Top = 14
  end
  object qry: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      '')
    Left = 136
    Top = 8
  end
  object dtsCadastrosNovos: TDataSource
    DataSet = qry
    Left = 248
    Top = 7
  end
  object dtsItens: TDataSource
    DataSet = qryItens
    Left = 216
    Top = 55
  end
  object qryItens: TFDQuery
    Connection = FDConnection1
    Left = 136
    Top = 64
  end
  object FDPhysOracleDriverLink1: TFDPhysOracleDriverLink
    DriverID = 'NL'
    VendorLib = 'oci.dll'
    Left = 42
    Top = 62
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
