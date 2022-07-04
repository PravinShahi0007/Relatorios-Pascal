object frmRel_Prod_Desc_Email: TfrmRel_Prod_Desc_Email
  Left = 0
  Top = 0
  ClientHeight = 155
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object btnConsultar: TBitBtn
    Left = 16
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Consultar'
    TabOrder = 0
    OnClick = btnConsultarClick
  end
  object fdcConexao: TFDConnection
    Params.Strings = (
      'DriverID=Ora')
    Left = 16
    Top = 104
  end
  object qryConsulta: TFDQuery
    Connection = fdcConexao
    Left = 137
    Top = 104
    object qryConsultaItem: TStringField
      FieldName = 'Item'
      Origin = '"Item"'
      Size = 100
    end
    object qryConsultaDescrição: TStringField
      FieldName = 'Descri'#231#227'o'
      Origin = '"Descri'#231#227'o"'
      Required = True
      Size = 50
    end
    object qryConsultaComprador: TStringField
      FieldName = 'Comprador'
      Origin = '"Comprador"'
      Required = True
      Size = 100
    end
    object qryConsultaLivro: TStringField
      FieldName = 'Livro'
      Origin = '"Livro"'
      Size = 1
    end
    object qryConsultaCD: TBCDField
      FieldName = 'CD'
      Origin = 'CD'
      Required = True
      Precision = 7
      Size = 0
    end
    object qryConsultaRecebimento: TDateTimeField
      FieldName = 'Recebimento'
      Origin = '"Recebimento"'
    end
    object qryConsultaEstCD: TFMTBCDField
      FieldName = 'Est CD'
      Origin = '"Est CD"'
      Precision = 38
      Size = 38
    end
    object qryConsultaPadrão: TFMTBCDField
      FieldName = 'Padr'#227'o'
      Origin = '"Padr'#227'o"'
      Precision = 38
      Size = 38
    end
  end
  object dtsqryConsulta: TDataSource
    DataSet = qryConsulta
    Left = 211
    Top = 104
  end
  object ACBrMail1: TACBrMail
    Host = '127.0.0.1'
    Port = '25'
    SetSSL = False
    SetTLS = False
    Attempts = 3
    DefaultCharset = UTF_8
    IDECharset = CP1252
    Left = 77
    Top = 105
  end
  object FDPhysOracleDriverLink1: TFDPhysOracleDriverLink
    DriverID = 'NL'
    VendorLib = 'oci.dll'
    Left = 202
    Top = 62
  end
end
