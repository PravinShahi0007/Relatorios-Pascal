object frmRel_Numero_Sorte: TfrmRel_Numero_Sorte
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
    DataSet = qry
    Left = 248
    Top = 7
  end
  object qry: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM grazz.VDA_VENDA_Ano a'
      'Where a.cod_emp = 10'
      '  and a.cod_unidade > 900 '
      '  and a.ano >= 2019 - 2 '
      '  and a.mes = 08'
      '  and not exists (select 1 from nl.grz_lojas_unificadas_cia t'
      '                   where a.cod_emp     = t.cod_emp_para'
      '                     and a.cod_unidade = t.cod_unidade_para)'
      'ORDER BY cod_emp, cod_unidade, ano, dta_movimento')
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
  object FDQuery2: TFDQuery
    Connection = FDConnection1
    Left = 136
    Top = 128
  end
  object FDQuery3: TFDQuery
    Connection = FDConnection1
    Left = 184
    Top = 112
  end
end
