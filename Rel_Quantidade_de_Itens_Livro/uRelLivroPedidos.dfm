object frmLivroPedido: TfrmLivroPedido
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Quantidade Itens Livro'
  ClientHeight = 216
  ClientWidth = 461
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 64
    Width = 43
    Height = 13
    Caption = 'Per'#237'odo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 32
    Top = 96
    Width = 93
    Height = 13
    Caption = 'Per'#237'odo Previsto'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 32
    Top = 123
    Width = 108
    Height = 13
    Caption = 'C'#243'digo Estruturado'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel3: TPanel
    Left = 0
    Top = 49
    Width = 465
    Height = 96
    TabOrder = 10
  end
  object Panel1: TPanel
    Left = -3
    Top = -3
    Width = 468
    Height = 53
    TabOrder = 8
  end
  object edtCodigoInicial: TEdit
    Left = 156
    Top = 115
    Width = 115
    Height = 21
    Hint = 'Ex: 100000000'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnExit = edtCodigoInicialExit
    OnKeyPress = edtCodigoInicialKeyPress
  end
  object edtCodigoFinal: TEdit
    Left = 284
    Top = 115
    Width = 115
    Height = 21
    Hint = 'Ex: 10999999999'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnExit = edtCodigoFinalExit
    OnKeyPress = edtCodigoFinalKeyPress
  end
  object btnVizualizar: TButton
    Left = 35
    Top = 9
    Width = 101
    Height = 32
    Caption = 'Gerar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = btnVizualizarClick
  end
  object Edit1: TEdit
    Left = 528
    Top = 8
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 7
    Text = 'Edit1'
    Visible = False
  end
  object edtDataFinal: TMaskEdit
    Left = 284
    Top = 61
    Width = 115
    Height = 21
    Hint = 'Data desejada . Ex: 18/01/2020'
    EditMask = '!99/99/0000;1;_'
    MaxLength = 10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Text = '  /  /    '
    OnExit = edtDataFinalExit
    OnKeyPress = edtDataFinalKeyPress
  end
  object edtDataPrevistaInicial: TMaskEdit
    Left = 156
    Top = 88
    Width = 115
    Height = 21
    Hint = 'Data desejada para os proximos 30 dias . Ex: 19/01/2020'
    EditMask = '!99/99/0000;1;_'
    MaxLength = 10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    Text = '  /  /    '
    OnExit = edtDataPrevistaInicialExit
    OnKeyPress = edtDataPrevistaInicialKeyPress
  end
  object edtDataPrevistaFinal: TMaskEdit
    Left = 284
    Top = 88
    Width = 115
    Height = 21
    Hint = ' Ex: 19/02/2020'
    EditMask = '!99/99/0000;1;_'
    MaxLength = 10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Text = '  /  /    '
    OnExit = edtDataPrevistaFinalExit
    OnKeyPress = edtDataPrevistaFinalKeyPress
  end
  object edtDataInicial: TMaskEdit
    Left = 156
    Top = 61
    Width = 115
    Height = 21
    Hint = 'Data desejada . Ex: 12/01/2020'
    EditMask = '!99/99/0000;1;_'
    MaxLength = 10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Text = '  /  /    '
    OnExit = edtDataInicialExit
    OnKeyPress = edtDataInicialKeyPress
  end
  object btmCancelar: TButton
    Left = 204
    Top = 8
    Width = 101
    Height = 33
    Caption = 'Fechar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = btmCancelarClick
    OnExit = btmCancelarExit
  end
  object grdLivroPedidos: TStringGrid
    Left = 0
    Top = 144
    Width = 465
    Height = 72
    ColCount = 4
    RowCount = 2
    TabOrder = 11
    OnDrawCell = grdLivroPedidosDrawCell
    ColWidths = (
      64
      64
      64
      64)
    RowHeights = (
      24
      24)
  end
  object Memo1: TMemo
    Left = 589
    Top = 131
    Width = 185
    Height = 89
    Lines.Strings = (
      'Memo1')
    TabOrder = 12
  end
  object sp_relatorios: TFDStoredProc
    IndexesActive = False
    Connection = fdOracle
    StoredProcName = 'NL.GRZ_SP_REL_TOT_CUPOM_ITENS'
    Left = 78
    Top = 307
    ParamData = <
      item
        Position = 1
        Name = 'PI_OPCAO'
        DataType = ftWideString
        FDDataType = dtWideString
        ParamType = ptInput
      end>
  end
  object fdOracle: TFDConnection
    Params.Strings = (
      'Database=192.168.200.110:1522/GRZPROD'
      'User_Name=nl'
      'Password=nl'
      'DriverID=Ora')
    LoginPrompt = False
    Left = 16
    Top = 299
  end
  object FDQuery1: TFDQuery
    Connection = fdOracle
    SQL.Strings = (
      
        'select QTD_ITEM_LIVRO_SEMANA, QTD_ITEM_NOVO_SEMANA, ITEM_NOVO_CR' +
        'OSS, ITEM_NOVO_ENTRAR  from GRZ_ITENS_LIVRO_CD ')
    Left = 144
    Top = 304
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 216
    Top = 304
  end
end