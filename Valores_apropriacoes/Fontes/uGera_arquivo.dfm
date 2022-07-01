object frmGeracao: TfrmGeracao
  Left = 310
  Top = 164
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Gera Arquivo das Apropria'#231#245'es da Financeira V1'
  ClientHeight = 264
  ClientWidth = 649
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000099
    9999900009999999999999999900009999999900099999999999999999000009
    9999990009999999999999999900000999999900099999999999999999000009
    9999999009999999999999999900000099999990009999900000000000000000
    9999999900999999000000000000000009999999000999990000000000000000
    0999999900099999900000000000000000999999900999999000000000000000
    0099999990009999990000000000000000999999900099999900000000000000
    0009999999000999990000000000000000099999990009999990000000000000
    0009999999000999999000000000000000009999999000999999000000000000
    0000999999900099999900000000000000009999999000999999900000000000
    0000999999900009999990000000000000000999999900099999900000000000
    0000099999990009999999000000000000000999999900009999990000000000
    0000009999999000999999000000009999999999999990009999999000000099
    9999999999999900099999900000009999999999999999000999999900000099
    9999999999999990009999990000009999999999999999900099999990000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFC0780003C0380003E0380003E0380003E0180003F01C1FFFF00C
    0FFFF80E0FFFF80E07FFFC0607FFFC0703FFFC0703FFFE0383FFFE0381FFFE03
    81FFFF01C0FFFF01C0FFFF01C07FFF01E07FFF80E07FFF80E03FFF80F03FFFC0
    703FC000701FC000381FC000380FC0001C0FC0001C07FFFFFFFFFFFFFFFF}
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 649
    Height = 264
    Align = alClient
    BevelOuter = bvSpace
    TabOrder = 0
    object Panel2: TPanel
      Left = 14
      Top = 14
      Width = 622
      Height = 243
      BevelOuter = bvLowered
      TabOrder = 0
      object Label3: TLabel
        Left = 152
        Top = 13
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
        Left = 261
        Top = 13
        Width = 89
        Height = 13
        Caption = 'Intervalo Inicial'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 380
        Top = 50
        Width = 82
        Height = 13
        Caption = 'Intervalo Final'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btnGerar: TBitBtn
        Left = 225
        Top = 176
        Width = 75
        Height = 24
        Caption = '&Gerar'
        TabOrder = 14
        OnClick = btnGerarClick
      end
      object btnFechar: TBitBtn
        Left = 320
        Top = 175
        Width = 75
        Height = 25
        Caption = '&Fechar'
        TabOrder = 13
        OnClick = btnFecharClick
        NumGlyphs = 2
      end
      object pnlMensAviso: TPanel
        Left = 31
        Top = 160
        Width = 561
        Height = 66
        BevelInner = bvLowered
        TabOrder = 12
        Visible = False
        object lblMensagem: TLabel
          Left = 2
          Top = 2
          Width = 557
          Height = 62
          Align = alClient
          Alignment = taCenter
          Caption = 'Aguarde.....'#13#10'Gerando arquivo texto.....'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -24
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object Edit10: TEdit
        Left = 122
        Top = 98
        Width = 115
        Height = 21
        TabStop = False
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMenuText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 7
        Text = 'Data'
      end
      object edtdta_ini: TMaskEdit
        Left = 244
        Top = 98
        Width = 117
        Height = 21
        MaxLength = 8
        TabOrder = 8
        OnEnter = edtdta_iniEnter
        OnExit = edtdta_iniExit
      end
      object edtdta_fim: TMaskEdit
        Left = 366
        Top = 98
        Width = 115
        Height = 21
        MaxLength = 8
        TabOrder = 9
        OnEnter = edtdta_fimEnter
        OnExit = edtdta_fimExit
      end
      object Edit2: TEdit
        Left = 122
        Top = 28
        Width = 115
        Height = 21
        TabStop = False
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMenuText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        Text = 'Empresa'
      end
      object edtEmpresa: TEdit
        Left = 244
        Top = 28
        Width = 115
        Height = 21
        TabOrder = 1
        Text = '1'
        OnExit = edtEmpresaExit
      end
      object edt_Uni_Ini: TMaskEdit
        Left = 244
        Top = 75
        Width = 115
        Height = 21
        MaxLength = 7
        TabOrder = 5
        OnExit = edt_Uni_IniExit
      end
      object edt_Uni_Fim: TMaskEdit
        Left = 366
        Top = 75
        Width = 115
        Height = 21
        MaxLength = 7
        TabOrder = 6
        OnExit = edt_Uni_FimExit
      end
      object Edit1: TEdit
        Left = 122
        Top = 75
        Width = 115
        Height = 21
        TabStop = False
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMenuText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 4
        Text = 'Unidade'
      end
      object Edit4: TEdit
        Left = 122
        Top = 51
        Width = 115
        Height = 21
        TabStop = False
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMenuText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        Text = 'Grupo'
      end
      object edtCodGrupo: TMaskEdit
        Left = 244
        Top = 51
        Width = 115
        Height = 21
        MaxLength = 6
        TabOrder = 3
        OnExit = edtCodGrupoExit
        OnKeyPress = edtCodGrupoKeyPress
      end
      object Edit5: TEdit
        Left = 122
        Top = 122
        Width = 115
        Height = 21
        TabStop = False
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMenuText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 10
        Text = 'Produto'
      end
      object cbxProduto: TComboBox
        Left = 244
        Top = 122
        Width = 163
        Height = 21
        ItemHeight = 13
        TabOrder = 11
        Text = 'Ambos'
        OnExit = cbxProdutoExit
        Items.Strings = (
          'Ambos'
          'Financiamento'
          'Emprestimo'
          'CRE Anal'#237'tico'
          'CPP Anal'#237'tico'
          'CRE Sint'#233'tico'
          'CPP Sint'#233'tico')
      end
    end
  end
  object Database1: TDatabase
    AliasName = 'NL'
    DatabaseName = 'NL'
    LoginPrompt = False
    Params.Strings = (
      'SERVER NAME=GRZPROD'
      'USER NAME=SISLOGWEB'
      'NET PROTOCOL=TNS'
      'OPEN MODE=READ/WRITE'
      'SCHEMA CACHE SIZE=8'
      'LANGDRIVER='
      'SQLQRYMODE=SERVER'
      'SQLPASSTHRU MODE=SHARED AUTOCOMMIT'
      'SCHEMA CACHE TIME=-1'
      'MAX ROWS=-1'
      'BATCH COUNT=200'
      'ENABLE SCHEMA CACHE=FALSE'
      'SCHEMA CACHE DIR='
      'ENABLE BCD=FALSE'
      'ENABLE INTEGERS=FALSE'
      'LIST SYNONYMS=NONE'
      'ROWSET SIZE=20'
      'BLOBS TO CACHE=64'
      'BLOB SIZE=32'
      'OBJECT MODE=TRUE'
      'DATABASE NAME='
      'ODBC DSN=NL'
      'PASSWORD=S1sl0gw3bAdm')
    SessionName = 'Session1_1'
    Left = 28
    Top = 51
  end
  object Session1: TSession
    Active = True
    AutoSessionName = True
    Left = 28
    Top = 23
  end
  object sp_Procedure: TStoredProc
    DatabaseName = 'NL'
    SessionName = 'Session1_1'
    StoredProcName = 'GRZ_APROPRIACAO_FINANCEIRA_SP'
    Left = 28
    Top = 79
    ParamData = <
      item
        DataType = ftString
        Name = 'PI_OPCAO'
        ParamType = ptInput
      end>
  end
  object sp_cre_analitico: TStoredProc
    DatabaseName = 'NL'
    SessionName = 'Session1_1'
    StoredProcName = 'GRZ_CRE_ANALITICO_SP'
    Left = 28
    Top = 111
    ParamData = <
      item
        DataType = ftString
        Name = 'PI_OPCAO'
        ParamType = ptInput
      end>
  end
  object sp_cpp_analitico: TStoredProc
    DatabaseName = 'NL'
    SessionName = 'Session1_1'
    StoredProcName = 'GRZ_CPP_ANALITICO_SP'
    Left = 68
    Top = 23
    ParamData = <
      item
        DataType = ftString
        Name = 'PI_OPCAO'
        ParamType = ptInput
      end>
  end
  object StoredProc1: TStoredProc
    DatabaseName = 'NL'
    SessionName = 'Session1_1'
    StoredProcName = 'GRZ_CRE_SINTETICO_SP'
    Left = 68
    Top = 55
    ParamData = <
      item
        DataType = ftString
        Name = 'PI_OPCAO'
        ParamType = ptInput
      end>
  end
  object StoredProc3: TStoredProc
    DatabaseName = 'NL'
    SessionName = 'Session1_1'
    StoredProcName = 'GRZ_CPP_SINTETICO2_SP'
    Left = 492
    Top = 23
  end
  object sp_cpp_sintetico: TStoredProc
    Tag = 1
    DatabaseName = 'NL'
    SessionName = 'Session1_1'
    StoredProcName = 'GRZ_CPP_SINTETICO_SP'
    Left = 68
    Top = 87
    ParamData = <
      item
        DataType = ftString
        Name = 'PI_OPCAO'
        ParamType = ptInput
      end>
  end
end
