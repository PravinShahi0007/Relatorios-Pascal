object Form1: TForm1
  Left = 357
  Top = 253
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Deleta Notas'
  ClientHeight = 231
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 97
    Top = 69
    Width = 115
    Height = 21
    TabStop = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = False
    TabOrder = 1
    Text = 'Num. Equipamento'
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 440
    Height = 231
    Align = alClient
    BevelOuter = bvSpace
    TabOrder = 2
    object Panel2: TPanel
      Left = 0
      Top = 7
      Width = 427
      Height = 218
      BevelInner = bvLowered
      BevelOuter = bvLowered
      TabOrder = 0
      object Label3: TLabel
        Left = 121
        Top = 23
        Width = 58
        Height = 13
        Caption = 'Par'#226'metro'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 254
        Top = 23
        Width = 30
        Height = 13
        Caption = 'Valor'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btnGerar: TBitBtn
        Left = 124
        Top = 165
        Width = 75
        Height = 24
        Caption = 'Deletar'
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333333333333333333333333333333333333FFF3333333FFF339993333333
          999333888FF3333388833339993333399933333888F833388833333399933399
          93333333888F8388833333333999399933333333388838883333333333999993
          3333333333838F83333333333339993333333333333888FF3333333333999993
          333333333338833FF3333333399939993333333338333338FF33333399933399
          93333333883333388FF3333999333339993333388833333888FF339993333333
          9993338883333333888333333333333333333333333333333333333333333333
          3333333333333333333333333333333333333333333333333333}
        NumGlyphs = 2
        TabOrder = 5
        OnClick = btnGerarClick
      end
      object btnFechar: TBitBtn
        Left = 219
        Top = 165
        Width = 75
        Height = 24
        Caption = 'Fechar'
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
          03333388888888888F333301BBBBBBBB033333883F3333338F3333011BBBBBBB
          0333338F83F333338F33330111BBBBBB0333338F383F33338F333301110BBBBB
          0333338F338F33338F333301110BBBBB0333338F338F33338F333301110BBBB9
          0333338F338F33338F333301110BBB990333338F338F33338F333301110BB999
          9993338F338F33338F333301110B99999993338F338FF3338F33330111B0B999
          9993338F338833338F333301110BBB990333338F338F33338F333301110BBBB9
          0333338F3F8F33338F333301E10BBBBB0333338F8F8F33338F333301EE0BBBBB
          0333338F888FFFFF8F3333000000000003333388888888888333}
        NumGlyphs = 2
        TabOrder = 6
        OnClick = btnFecharClick
      end
      object edtCodUni: TMaskEdit
        Left = 213
        Top = 39
        Width = 115
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 4
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = ''
        OnExit = edtCodUniExit
        OnKeyPress = edtCodUniKeyPress
      end
      object Edit9: TEdit
        Left = 91
        Top = 39
        Width = 115
        Height = 21
        TabStop = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMenuText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = False
        TabOrder = 1
        Text = 'Cod. Unidade'
      end
      object Edit10: TEdit
        Left = 91
        Top = 87
        Width = 115
        Height = 21
        TabStop = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMenuText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = False
        TabOrder = 7
        Text = 'Cupom'
      end
      object edtNota: TMaskEdit
        Left = 213
        Top = 87
        Width = 115
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 9
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = ''
        OnExit = edtNotaExit
        OnKeyPress = edtNotaKeyPress
      end
      object Edit2: TEdit
        Left = 91
        Top = 112
        Width = 115
        Height = 21
        TabStop = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 8
        Text = 'Data Emiss'#227'o'
      end
      object edtDtaEmissao: TMaskEdit
        Left = 213
        Top = 111
        Width = 115
        Height = 21
        EditMask = '00/00/0000;1;_'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 10
        ParentFont = False
        TabOrder = 3
        Text = '  /  /    '
        OnExit = edtDtaEmissaoExit
      end
      object chkCanc: TCheckBox
        Left = 91
        Top = 138
        Width = 217
        Height = 17
        Caption = 'Remover cancelamento do cupom'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
      end
      object Edit3: TEdit
        Left = 91
        Top = 63
        Width = 115
        Height = 21
        TabStop = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMenuText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = False
        TabOrder = 9
        Text = 'Tipo Nota'
      end
    end
  end
  object cbTipoNota: TComboBox
    Left = 213
    Top = 70
    Width = 115
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    Text = 'Nota'
    OnExit = cbTipoNotaExit
    OnKeyDown = cbTipoNotaKeyDown
    Items.Strings = (
      'Nota'
      'Entrada'
      'Sa'#237'da')
  end
  object Database1: TFDConnection
    Params.Strings = (
      'Database=192.168.200.110:1522/GRZPROD'
      'User_Name=SISLOGWEB'
      'Password=S1sl0gw3bAdm'
      'DriverID=Ora')
    Left = 24
    Top = 16
  end
  object spRetorno: TFDStoredProc
    Connection = Database1
    Left = 23
    Top = 64
  end
  object qryGeral: TFDQuery
    Connection = Database1
    SQL.Strings = (
      'SELECT cod_unidade, num_nota, cod_serie, num_equipamento'
      'from nl.ai_ns_notas'
      'where num_nota = :num_nota'
      'and cod_unidade = :cod_unidade'
      'and dta_emissao = :dta_emissao')
    Left = 24
    Top = 112
    ParamData = <
      item
        Name = 'NUM_NOTA'
        ParamType = ptInput
      end
      item
        Name = 'COD_UNIDADE'
        ParamType = ptInput
      end
      item
        Name = 'DTA_EMISSAO'
        ParamType = ptInput
      end>
  end
  object dtsGeral: TDataSource
    DataSet = qryGeral
    Left = 24
    Top = 160
  end
end
