object frmRel_Clientes_APP: TfrmRel_Clientes_APP
  Left = 0
  Top = 0
  Caption = 'Relatorio_Venda_dia_Email'
  ClientHeight = 169
  ClientWidth = 378
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
    DataSet = qryCadastrosNovos
    Left = 248
    Top = 7
  end
  object qryCadastrosNovos: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM grazz.VDA_VENDA_Ano a'
      'Where a.cod_emp = 10'
      '  and a.cod_unidade > 900 '
      '  and a.ano >= 2019 - 2 '
      '  and a.mes = 08'
      '  and not exists (select 1 from grz_lojas_unificadas_cia t'
      '                   where a.cod_emp     = t.cod_emp_para'
      '                     and a.cod_unidade = t.cod_unidade_para)'
      'ORDER BY cod_emp, cod_unidade, ano, dta_movimento')
    Left = 136
    Top = 8
  end
  object qryCadastros: TFDQuery
    Connection = FDConnection1
    Left = 136
    Top = 64
  end
  object dtsCadastros: TDataSource
    DataSet = qryCadastros
    Left = 216
    Top = 55
  end
  object qryClientes: TFDQuery
    Connection = FDConnection1
    Left = 24
    Top = 192
  end
  object dtsClientes: TDataSource
    DataSet = qryClientes
    Left = 104
    Top = 183
  end
  object qryCliAprovados: TFDQuery
    Connection = FDConnection1
    Left = 24
    Top = 256
  end
  object dtsCliAprovados: TDataSource
    DataSet = qryCliAprovados
    Left = 104
    Top = 247
  end
  object dtsCliPendnetes: TDataSource
    DataSet = qryCliPendentes
    Left = 312
    Top = 199
  end
  object qryCliPendentes: TFDQuery
    Connection = FDConnection1
    Left = 232
    Top = 208
  end
  object qryPgto_App: TFDQuery
    Connection = FDConnection1
    Left = 232
    Top = 280
  end
  object dtsPgto_App: TDataSource
    DataSet = qryPgto_App
    Left = 312
    Top = 271
  end
  object qryPgtoParcelas: TFDQuery
    Connection = FDConnection1
    Left = 456
    Top = 200
  end
  object dtsPgtoParcelas: TDataSource
    DataSet = qryPgtoParcelas
    Left = 440
    Top = 135
  end
  object qryValorPgtoParcelas: TFDQuery
    Connection = FDConnection1
    Left = 432
    Top = 32
  end
  object dtsValorPgtoParcelas: TDataSource
    DataSet = qryValorPgtoParcelas
    Left = 344
    Top = 80
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
