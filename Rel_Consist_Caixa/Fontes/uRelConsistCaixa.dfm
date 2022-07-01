object frmRel_Consist_Caixa: TfrmRel_Consist_Caixa
  Left = 444
  Top = 214
  Width = 429
  Height = 345
  BorderIcons = [biSystemMenu]
  Caption = 'Relat'#243'rio de Consist'#234'ncia de Caixa'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    00000000BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000088088080808008080808000000000000
    8880888888888888888800000000000000007808080000000087800000000000
    000077707777777778888000000C00000000FF0F0F7F707880000000870C0000
    0000FFFFFFFFFF0007777777770C00000000FFFFFFFFFFF0000077FFFF0C0000
    0000FF00000FFFF0F00807FFFF0C00000007FFFFFFFFFFF0700007FFFF0C0000
    000FF00F00000F00F70007FFF0000000000FFFFFFFFFFFFF0F7007FF00000000
    007FF0000F00F00FF0F700F00000000000FFFFFFFFFFFFFFFF00000000000000
    07FF00F000F00FFFF7000000000000007FFFFFFFFFFFFFFF7000000000000007
    FF0000F000000FF7000000000000007FFFFFFFFFFFFFFFF000000000000000FF
    00F00F0000F00F80000000000000077F7F7F7F7F7F7F7F000000000000000770
    0007070700077700000000000000077788888888888888000000000000000780
    0000000000000000000000000000070FFFFFFFFFFFFFFFFF8000000000000088
    8888888888888888000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000FFE000007FE000007FFE00003CFE00
    0030FE000000FE000000FE000000FE000000FC000000FC000000FC000007F800
    000FF800001FF00001CFE00003E7C00007F380000FFB80000FFD00001FFF0000
    1FFF00001FFF000007FF000007FF80000FFFFFFFFFFFFFFFFFFFFFFFFFFF}
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 413
    Height = 306
    Align = alClient
    TabOrder = 0
    object Panel8: TPanel
      Left = 5
      Top = 224
      Width = 412
      Height = 46
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 7
      object rdgListar: TRadioGroup
        Left = 68
        Top = 3
        Width = 271
        Height = 36
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Listar &Tudo'
          'Listar &Divergencias')
        TabOrder = 0
      end
    end
    object Panel2: TPanel
      Left = 5
      Top = 62
      Width = 412
      Height = 28
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
      object Label1: TLabel
        Left = 179
        Top = 7
        Width = 48
        Height = 19
        Caption = 'Grupo'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Edit1: TEdit
        Left = 286
        Top = 4
        Width = 121
        Height = 21
        TabOrder = 0
        Visible = False
      end
    end
    object Panel3: TPanel
      Left = 5
      Top = 88
      Width = 412
      Height = 30
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object Label4: TLabel
        Left = 125
        Top = 9
        Width = 25
        Height = 16
        Caption = 'De:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtGrupo: TMaskEdit
        Left = 154
        Top = 5
        Width = 100
        Height = 21
        BevelKind = bkFlat
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 0
        OnExit = edtGrupoExit
      end
    end
    object Panel4: TPanel
      Left = 5
      Top = 116
      Width = 412
      Height = 28
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 2
      object Label2: TLabel
        Left = 172
        Top = 7
        Width = 64
        Height = 19
        Caption = 'Unidade'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object Panel5: TPanel
      Left = 5
      Top = 142
      Width = 412
      Height = 30
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 3
      object Label6: TLabel
        Left = 67
        Top = 9
        Width = 25
        Height = 16
        Caption = 'De:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 213
        Top = 9
        Width = 28
        Height = 16
        Caption = 'At'#233':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtCodUnidadeFinal: TMaskEdit
        Left = 244
        Top = 5
        Width = 100
        Height = 21
        BevelKind = bkFlat
        BorderStyle = bsNone
        TabOrder = 1
        OnExit = edtCodUnidadeFinalExit
      end
      object edtCodUnidadeInic: TMaskEdit
        Left = 95
        Top = 5
        Width = 100
        Height = 21
        BevelKind = bkFlat
        BorderStyle = bsNone
        TabOrder = 0
        OnExit = edtCodUnidadeInicExit
      end
    end
    object Panel6: TPanel
      Left = 5
      Top = 170
      Width = 412
      Height = 28
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 4
      object Label8: TLabel
        Left = 141
        Top = 6
        Width = 123
        Height = 19
        Caption = 'Data Movimento'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object Panel7: TPanel
      Left = 5
      Top = 196
      Width = 412
      Height = 30
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 5
      object Label9: TLabel
        Left = 68
        Top = 9
        Width = 25
        Height = 16
        Caption = 'De:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label10: TLabel
        Left = 213
        Top = 9
        Width = 28
        Height = 16
        Caption = 'At'#233':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtDataFinal: TMaskEdit
        Left = 245
        Top = 4
        Width = 100
        Height = 21
        BevelKind = bkFlat
        BorderStyle = bsNone
        EditMask = '!##/##/####;1;_'
        MaxLength = 10
        TabOrder = 1
        Text = '  /  /    '
        OnExit = edtDataFinalExit
      end
      object edtDataInicial: TMaskEdit
        Left = 96
        Top = 5
        Width = 100
        Height = 21
        BevelKind = bkFlat
        BorderStyle = bsNone
        EditMask = '!##/##/####;1;_'
        MaxLength = 10
        TabOrder = 0
        Text = '  /  /    '
        OnExit = edtDataInicialExit
      end
    end
    object Panel9: TPanel
      Left = 5
      Top = 329
      Width = 505
      Height = 0
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 8
    end
    object Panel10: TPanel
      Left = 5
      Top = 268
      Width = 412
      Height = 39
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 9
      object btnOK: TBitBtn
        Left = 43
        Top = 7
        Width = 142
        Height = 26
        Caption = '&OK'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = btnOKClick
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
          555555555555555555555555555555555555555555FF55555555555559055555
          55555555577FF5555555555599905555555555557777F5555555555599905555
          555555557777FF5555555559999905555555555777777F555555559999990555
          5555557777777FF5555557990599905555555777757777F55555790555599055
          55557775555777FF5555555555599905555555555557777F5555555555559905
          555555555555777FF5555555555559905555555555555777FF55555555555579
          05555555555555777FF5555555555557905555555555555777FF555555555555
          5990555555555555577755555555555555555555555555555555}
        NumGlyphs = 2
      end
      object btnCancelar: TBitBtn
        Left = 227
        Top = 7
        Width = 142
        Height = 26
        Caption = '&Cancelar'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = btnCancelarClick
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333FFFFF3333333333999993333333333F77777FFF333333999999999
          33333337777FF377FF3333993370739993333377FF373F377FF3399993000339
          993337777F777F3377F3393999707333993337F77737333337FF993399933333
          399377F3777FF333377F993339903333399377F33737FF33377F993333707333
          399377F333377FF3377F993333101933399377F333777FFF377F993333000993
          399377FF3377737FF7733993330009993933373FF3777377F7F3399933000399
          99333773FF777F777733339993707339933333773FF7FFF77333333999999999
          3333333777333777333333333999993333333333377777333333}
        NumGlyphs = 2
      end
    end
    object Panel11: TPanel
      Left = 5
      Top = 34
      Width = 412
      Height = 30
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 10
      object Label3: TLabel
        Left = 125
        Top = 10
        Width = 25
        Height = 16
        Caption = 'De:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtRede: TMaskEdit
        Left = 154
        Top = 5
        Width = 100
        Height = 21
        BevelKind = bkFlat
        BorderStyle = bsNone
        TabOrder = 0
        OnExit = edtRedeExit
      end
    end
    object Panel12: TPanel
      Left = 5
      Top = 8
      Width = 412
      Height = 28
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 11
      object Label5: TLabel
        Left = 184
        Top = 7
        Width = 40
        Height = 19
        Caption = 'Rede'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object pnlDisplay: TPanel
      Left = 60
      Top = 200
      Width = 299
      Height = 65
      BevelInner = bvLowered
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      Visible = False
      object Label11: TLabel
        Left = 54
        Top = 3
        Width = 120
        Height = 29
        Caption = 'Aguarde...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -24
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 54
        Top = 31
        Width = 237
        Height = 29
        Caption = 'Gerando Relat'#243'rio...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -24
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Animate1: TAnimate
        Left = 9
        Top = 18
        Width = 31
        Height = 25
        Active = True
        AutoSize = False
        CommonAVI = aviFindFile
        StopFrame = 1
      end
    end
  end
  object qryRel: TQuery
    DatabaseName = 'database1'
    SessionName = 'Session1_1'
    SQL.Strings = (
      ' SELECT COD_UNIDADE,'
      '            des_unidade,'
      '                 DTA_MOVIMENTO,'
      '                 NUM_EQUIPAMENTO,'
      '                 sum(vlr_lcto)  as vlr_adm,'
      '                 sum(vlr_lcto_serv)  as vlr_serv,'
      
        '                 (SUM(VLR_LCTO) - SUM(VLR_LCTO_SERV)) VLR_DIFERE' +
        'NCA'
      '                 FROM GRZ_TEF_TRANSACAO_DIVERGENCIAS'
      '                 WHERE DES_USUARIO =  '#39'suplojas'#39
      
        '                 GROUP BY COD_UNIDADE, des_unidade, DTA_MOVIMENT' +
        'O, NUM_EQUIPAMENTO'
      
        '                 ORDER BY COD_UNIDADE, des_unidade, DTA_MOVIMENT' +
        'O, NUM_EQUIPAMENTO')
    Left = 6
    Top = 41
    object qryRelCOD_UNIDADE: TFloatField
      FieldName = 'COD_UNIDADE'
      Origin = 'DATABASE1.GRZ_TEF_TRANSACAO_DIVERGENCIAS.COD_UNIDADE'
    end
    object qryRelDES_UNIDADE: TStringField
      FieldName = 'DES_UNIDADE'
      Origin = 'DATABASE1.GRZ_TEF_TRANSACAO_DIVERGENCIAS.DES_UNIDADE'
      Size = 50
    end
    object qryRelDTA_MOVIMENTO: TDateTimeField
      FieldName = 'DTA_MOVIMENTO'
      Origin = 'DATABASE1.GRZ_TEF_TRANSACAO_DIVERGENCIAS.DTA_MOVIMENTO'
    end
    object qryRelNUM_EQUIPAMENTO: TFloatField
      FieldName = 'NUM_EQUIPAMENTO'
      Origin = 'DATABASE1.GRZ_TEF_TRANSACAO_DIVERGENCIAS.NUM_EQUIPAMENTO'
    end
    object qryRelVLR_ADM: TFloatField
      FieldName = 'VLR_ADM'
      Origin = 'DATABASE1.GRZ_TEF_TRANSACAO_DIVERGENCIAS.VLR_LCTO'
    end
    object qryRelVLR_SERV: TFloatField
      FieldName = 'VLR_SERV'
      Origin = 'DATABASE1.GRZ_TEF_TRANSACAO_DIVERGENCIAS.VLR_LCTO_SERV'
      EditFormat = '0.00'
      currency = True
    end
    object qryRelVLR_DIFERENCA: TFloatField
      FieldName = 'VLR_DIFERENCA'
      Origin = 'DATABASE1.GRZ_TEF_TRANSACAO_DIVERGENCIAS.VLR_LCTO'
    end
  end
  object Database1: TDatabase
    AliasName = 'NL'
    DatabaseName = 'database1'
    KeepConnection = False
    LoginPrompt = False
    Params.Strings = (
      'SERVER NAME=NLPROD2'
      'USER NAME=sislogweb'
      'NET PROTOCOL=TNS'
      'OPEN MODE=READ/WRITE'
      'SCHEMA CACHE SIZE=32'
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
      'BLOBS TO CACHE=512'
      'BLOB SIZE=128'
      'OBJECT MODE=TRUE'
      'PASSWORD=S1sl0gw3bAdm')
    SessionName = 'Session1_1'
    Left = 6
    Top = 7
  end
  object StpConciliacao: TStoredProc
    DatabaseName = 'database1'
    SessionName = 'Session1_1'
    StoredProcName = 'GRZ_REL_CONSIST_CAIXA_SP'
    Left = 38
    Top = 7
    ParamData = <
      item
        DataType = ftString
        Name = 'PI_OPCAO'
        ParamType = ptInput
        Value = '910#44#44#26/05/2008#26/05/2008#suplojas#'
      end
      item
        DataType = ftString
        Name = 'PO_RETORNO'
        ParamType = ptOutput
        Value = Null
      end>
  end
  object Session1: TSession
    Active = True
    AutoSessionName = True
    Left = 71
    Top = 7
  end
  object pprRelatorio: TppReport
    AutoStop = False
    DataPipeline = ppDBPipeline1
    PrinterSetup.BinName = 'Default'
    PrinterSetup.DocumentName = 'Report'
    PrinterSetup.PaperName = 'A4'
    PrinterSetup.PrinterName = 'Default'
    PrinterSetup.mmMarginBottom = 6350
    PrinterSetup.mmMarginLeft = 6350
    PrinterSetup.mmMarginRight = 6350
    PrinterSetup.mmMarginTop = 6350
    PrinterSetup.mmPaperHeight = 297000
    PrinterSetup.mmPaperWidth = 210000
    PrinterSetup.PaperSize = 9
    DeviceType = 'Screen'
    OnPreviewFormCreate = pprRelatorioPreviewFormCreate
    OutlineSettings.CreateNode = True
    OutlineSettings.CreatePageNodes = True
    OutlineSettings.Enabled = True
    OutlineSettings.Visible = True
    PreviewFormSettings.WindowState = wsMaximized
    PreviewFormSettings.ZoomSetting = zsPageWidth
    TextSearchSettings.DefaultString = '<FindText>'
    TextSearchSettings.Enabled = True
    Left = 38
    Top = 73
    Version = '7.02'
    mmColumnWidth = 0
    DataPipelineName = 'ppDBPipeline1'
    object ppHeaderBand1: TppHeaderBand
      PrintHeight = phDynamic
      mmBottomOffset = 0
      mmHeight = 21960
      mmPrintPosition = 0
      object ppMemo2: TppMemo
        UserName = 'Memo2'
        Caption = 'Memo2'
        CharWrap = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 12
        Font.Style = [fsBold]
        Lines.Strings = (
          'Grupo'
          'Grazziotin')
        TextAlignment = taCentered
        Transparent = True
        mmHeight = 11113
        mmLeft = 3969
        mmTop = 794
        mmWidth = 24342
        BandType = 0
        mmBottomOffset = 0
        mmOverFlowOffset = 0
        mmStopPosition = 0
        mmLeading = 0
      end
      object ppShape2: TppShape
        UserName = 'Shape2'
        Brush.Color = clSilver
        Shape = stRoundRect
        mmHeight = 5027
        mmLeft = 3175
        mmTop = 16933
        mmWidth = 192088
        BandType = 0
      end
      object ppLabel16: TppLabel
        UserName = 'Label16'
        Caption = 'Data'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 9
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 3725
        mmLeft = 36248
        mmTop = 17463
        mmWidth = 6477
        BandType = 0
      end
      object ppLabel20: TppLabel
        UserName = 'Label101'
        Caption = 'Valor Caixa'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 9
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3704
        mmLeft = 91281
        mmTop = 17463
        mmWidth = 16404
        BandType = 0
      end
      object ppLabel22: TppLabel
        UserName = 'Label22'
        Caption = 'Valor NL'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 9
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3704
        mmLeft = 124884
        mmTop = 17463
        mmWidth = 12965
        BandType = 0
      end
      object ppLabel27: TppLabel
        UserName = 'Label27'
        Caption = 'Loja'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 9
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 3725
        mmLeft = 5292
        mmTop = 17463
        mmWidth = 6308
        BandType = 0
      end
      object ppLabel4: TppLabel
        UserName = 'Label4'
        Caption = 'Diferen'#231'a'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 9
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3704
        mmLeft = 160073
        mmTop = 17463
        mmWidth = 13229
        BandType = 0
      end
      object ppLabel15: TppLabel
        UserName = 'Label15'
        Caption = 'P'#225'gina :'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 7
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3175
        mmLeft = 162454
        mmTop = 2381
        mmWidth = 8467
        BandType = 0
      end
      object ppSystemVariable4: TppSystemVariable
        UserName = 'SystemVariable4'
        VarType = vtPageNo
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 7
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3175
        mmLeft = 171715
        mmTop = 2381
        mmWidth = 12700
        BandType = 0
      end
      object ppSystemVariable3: TppSystemVariable
        UserName = 'SystemVariable3'
        VarType = vtDateTime
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 7
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3175
        mmLeft = 171715
        mmTop = 5821
        mmWidth = 22225
        BandType = 0
      end
      object ppLabel9: TppLabel
        UserName = 'Label9'
        Caption = 'Data de Emiss'#227'o :'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 7
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3175
        mmLeft = 152929
        mmTop = 5821
        mmWidth = 17992
        BandType = 0
      end
      object ppLabel10: TppLabel
        UserName = 'Label10'
        Caption = 'Relat'#243'rio de Diverg'#234'ncias'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 10
        Font.Style = [fsBold, fsUnderline]
        Transparent = True
        mmHeight = 4106
        mmLeft = 79111
        mmTop = 1323
        mmWidth = 38820
        BandType = 0
      end
      object pplParametros: TppLabel
        OnPrint = pplParametrosPrint
        UserName = 'lParametros'
        Caption = 'tipo'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 8
        Font.Style = []
        Transparent = True
        mmHeight = 3344
        mmLeft = 4763
        mmTop = 12965
        mmWidth = 4445
        BandType = 0
      end
      object ppLabel8: TppLabel
        UserName = 'Label102'
        Caption = 'Consist'#234'ncia - Caixa'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 10
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 4106
        mmLeft = 83608
        mmTop = 5556
        mmWidth = 29898
        BandType = 0
      end
    end
    object ppDetailBand1: TppDetailBand
      mmBottomOffset = 0
      mmHeight = 4498
      mmPrintPosition = 0
      object ppDBText3: TppDBText
        UserName = 'DBText3'
        DataField = 'VLR_ADM'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '#,0.00;-#,0.00'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 8
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3440
        mmLeft = 88106
        mmTop = 0
        mmWidth = 19579
        BandType = 4
      end
      object ppDBText5: TppDBText
        UserName = 'DBText5'
        DataField = 'VLR_SERV'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '#,0.00;-#,0.00'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 8
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3440
        mmLeft = 118534
        mmTop = 0
        mmWidth = 19315
        BandType = 4
      end
      object ppDBText6: TppDBText
        UserName = 'DBText6'
        DataField = 'VLR_DIFERENCA'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '#,0.00;-#,0.00'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 8
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3440
        mmLeft = 150813
        mmTop = 0
        mmWidth = 22490
        BandType = 4
      end
      object ppLabel1: TppLabel
        OnPrint = ppLabel1Print
        UserName = 'Label1'
        Caption = 'Label1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 7
        Font.Style = []
        Transparent = True
        mmHeight = 2879
        mmLeft = 37571
        mmTop = 265
        mmWidth = 7324
        BandType = 4
      end
    end
    object ppFooterBand1: TppFooterBand
      mmBottomOffset = 0
      mmHeight = 5556
      mmPrintPosition = 0
      object ppDBCalc3: TppDBCalc
        UserName = 'DBCalc3'
        AutoSize = True
        DataField = 'VLR_ADM'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '#,0.00;-#,0.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3704
        mmLeft = 84932
        mmTop = 1323
        mmWidth = 22754
        BandType = 8
      end
      object ppDBCalc4: TppDBCalc
        UserName = 'DBCalc4'
        DataField = 'VLR_SERV'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '#,0.00;-#,0.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3440
        mmLeft = 116681
        mmTop = 1058
        mmWidth = 21167
        BandType = 8
      end
      object ppDBCalc5: TppDBCalc
        UserName = 'DBCalc5'
        DataField = 'VLR_DIFERENCA'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '#,0.00;-#,0.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3440
        mmLeft = 148167
        mmTop = 1058
        mmWidth = 25135
        BandType = 8
      end
      object ppLine1: TppLine
        UserName = 'Line1'
        Weight = 0.750000000000000000
        mmHeight = 794
        mmLeft = 0
        mmTop = 529
        mmWidth = 197380
        BandType = 8
      end
      object ppLabel3: TppLabel
        UserName = 'Label3'
        Caption = 'Total Geral:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 3440
        mmLeft = 62706
        mmTop = 1588
        mmWidth = 16669
        BandType = 8
      end
    end
    object ppGroup3: TppGroup
      BreakName = 'COD_UNIDADE'
      DataPipeline = ppDBPipeline1
      OutlineSettings.CreateNode = True
      NewPage = True
      UserName = 'Group3'
      mmNewColumnThreshold = 0
      mmNewPageThreshold = 0
      DataPipelineName = 'ppDBPipeline1'
      object ppGroupHeaderBand3: TppGroupHeaderBand
        mmBottomOffset = 0
        mmHeight = 4233
        mmPrintPosition = 0
        object ppDBText13: TppDBText
          UserName = 'DBText13'
          DataField = 'DES_UNIDADE'
          DataPipeline = ppDBPipeline1
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Name = 'Times New Roman'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3440
          mmLeft = 25929
          mmTop = 264
          mmWidth = 58208
          BandType = 3
          GroupNo = 1
        end
        object ppLabel6: TppLabel
          UserName = 'Label6'
          Caption = 'Loja:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Name = 'Times New Roman'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3344
          mmLeft = 5292
          mmTop = 265
          mmWidth = 6646
          BandType = 3
          GroupNo = 1
        end
        object ppDBText9: TppDBText
          UserName = 'DBText4'
          DataField = 'COD_UNIDADE'
          DataPipeline = ppDBPipeline1
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Name = 'Times New Roman'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3440
          mmLeft = 13229
          mmTop = 264
          mmWidth = 5292
          BandType = 3
          GroupNo = 1
        end
        object ppLabel7: TppLabel
          UserName = 'Label7'
          Caption = '   -   '
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Name = 'Times New Roman'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3344
          mmLeft = 19315
          mmTop = 265
          mmWidth = 5249
          BandType = 3
          GroupNo = 1
        end
        object ppLine4: TppLine
          UserName = 'Line4'
          Weight = 0.750000000000000000
          mmHeight = 529
          mmLeft = 0
          mmTop = 3704
          mmWidth = 197115
          BandType = 3
          GroupNo = 0
        end
      end
      object ppGroupFooterBand3: TppGroupFooterBand
        mmBottomOffset = 0
        mmHeight = 5556
        mmPrintPosition = 0
        object ppDBCalc1: TppDBCalc
          UserName = 'DBCalc1'
          AutoSize = True
          DataField = 'VLR_ADM'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup3
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3704
          mmLeft = 84932
          mmTop = 1852
          mmWidth = 22754
          BandType = 5
          GroupNo = 1
        end
        object ppDBCalc2: TppDBCalc
          UserName = 'DBCalc2'
          DataField = 'VLR_SERV'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup3
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3440
          mmLeft = 116681
          mmTop = 1852
          mmWidth = 21167
          BandType = 5
          GroupNo = 1
        end
        object ppLabel2: TppLabel
          UserName = 'Label2'
          Caption = 'Total Unidade:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3387
          mmLeft = 58738
          mmTop = 1852
          mmWidth = 20638
          BandType = 5
          GroupNo = 1
        end
        object ppDBCalc8: TppDBCalc
          UserName = 'DBCalc8'
          DataField = 'VLR_DIFERENCA'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup3
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3440
          mmLeft = 148167
          mmTop = 1852
          mmWidth = 25135
          BandType = 5
          GroupNo = 1
        end
        object ppLine2: TppLine
          UserName = 'Line2'
          Weight = 0.750000000000000000
          mmHeight = 529
          mmLeft = 265
          mmTop = 794
          mmWidth = 197115
          BandType = 5
          GroupNo = 0
        end
      end
    end
    object ppGroup1: TppGroup
      BreakName = 'DTA_MOVIMENTO'
      DataPipeline = ppDBPipeline1
      KeepTogether = True
      OutlineSettings.CreateNode = True
      UserName = 'Group1'
      mmNewColumnThreshold = 0
      mmNewPageThreshold = 0
      DataPipelineName = 'ppDBPipeline1'
      object ppGroupHeaderBand1: TppGroupHeaderBand
        mmBottomOffset = 0
        mmHeight = 5027
        mmPrintPosition = 0
        object ppDBText2: TppDBText
          UserName = 'DBText2'
          DataField = 'DTA_MOVIMENTO'
          DataPipeline = ppDBPipeline1
          DisplayFormat = 'dd/mm/yyyy'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Name = 'Times New Roman'
          Font.Size = 9
          Font.Style = [fsBold]
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3725
          mmLeft = 6085
          mmTop = 794
          mmWidth = 23548
          BandType = 3
          GroupNo = 1
        end
      end
      object ppGroupFooterBand1: TppGroupFooterBand
        mmBottomOffset = 0
        mmHeight = 4498
        mmPrintPosition = 0
        object ppLabel5: TppLabel
          UserName = 'Label5'
          Caption = 'Total Data:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3387
          mmLeft = 64294
          mmTop = 265
          mmWidth = 15081
          BandType = 5
          GroupNo = 1
        end
        object ppDBCalc6: TppDBCalc
          UserName = 'DBCalc6'
          AutoSize = True
          DataField = 'VLR_ADM'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup1
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3704
          mmLeft = 84932
          mmTop = 265
          mmWidth = 22754
          BandType = 5
          GroupNo = 1
        end
        object ppDBCalc7: TppDBCalc
          UserName = 'DBCalc7'
          DataField = 'VLR_SERV'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup1
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3440
          mmLeft = 116681
          mmTop = 265
          mmWidth = 21167
          BandType = 5
          GroupNo = 1
        end
        object ppDBCalc9: TppDBCalc
          UserName = 'DBCalc9'
          DataField = 'VLR_DIFERENCA'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup1
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3440
          mmLeft = 148432
          mmTop = 265
          mmWidth = 25135
          BandType = 5
          GroupNo = 1
        end
        object ppLine3: TppLine
          UserName = 'Line3'
          Pen.Style = psDot
          Weight = 0.750000000000000000
          mmHeight = 529
          mmLeft = 0
          mmTop = 0
          mmWidth = 197115
          BandType = 5
          GroupNo = 1
        end
      end
    end
  end
  object DataSource1: TDataSource
    AutoEdit = False
    DataSet = qryRel
    Left = 38
    Top = 41
  end
  object ppDBPipeline1: TppDBPipeline
    DataSource = DataSource1
    UserName = 'DBPipeline1'
    Left = 6
    Top = 73
    object ppDBPipeline1ppField1: TppField
      Alignment = taRightJustify
      FieldAlias = 'COD_UNIDADE'
      FieldName = 'COD_UNIDADE'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 0
      Position = 0
    end
    object ppDBPipeline1ppField2: TppField
      FieldAlias = 'DES_UNIDADE'
      FieldName = 'DES_UNIDADE'
      FieldLength = 50
      DisplayWidth = 50
      Position = 1
    end
    object ppDBPipeline1ppField3: TppField
      FieldAlias = 'DTA_MOVIMENTO'
      FieldName = 'DTA_MOVIMENTO'
      FieldLength = 0
      DataType = dtDateTime
      DisplayWidth = 18
      Position = 2
    end
    object ppDBPipeline1ppField4: TppField
      Alignment = taRightJustify
      FieldAlias = 'NUM_EQUIPAMENTO'
      FieldName = 'NUM_EQUIPAMENTO'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 10
      Position = 3
    end
    object ppDBPipeline1ppField5: TppField
      Alignment = taRightJustify
      FieldAlias = 'VLR_ADM'
      FieldName = 'VLR_ADM'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 10
      Position = 4
    end
    object ppDBPipeline1ppField6: TppField
      Alignment = taRightJustify
      FieldAlias = 'VLR_SERV'
      FieldName = 'VLR_SERV'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 10
      Position = 5
    end
    object ppDBPipeline1ppField7: TppField
      Alignment = taRightJustify
      FieldAlias = 'VLR_DIFERENCA'
      FieldName = 'VLR_DIFERENCA'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 10
      Position = 6
    end
  end
  object qryConsulta: TQuery
    DatabaseName = 'database1'
    SessionName = 'Session1_1'
    Left = 5
    Top = 116
  end
end
