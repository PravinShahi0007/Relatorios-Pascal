object frmConc_Pag_Financeira: TfrmConc_Pag_Financeira
  Left = 424
  Top = 203
  BorderIcons = [biSystemMenu]
  Caption = 'Concilia'#231#227'o de Pagamentos Financeiros'
  ClientHeight = 363
  ClientWidth = 508
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
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
    Width = 508
    Height = 363
    Align = alClient
    TabOrder = 0
    object Panel2: TPanel
      Left = 6
      Top = 64
      Width = 505
      Height = 29
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
      object Label1: TLabel
        Left = 230
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
    end
    object Panel3: TPanel
      Left = 6
      Top = 91
      Width = 505
      Height = 31
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object Label4: TLabel
        Left = 111
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
      object edtGrupo: TMaskEdit
        Left = 144
        Top = 5
        Width = 102
        Height = 21
        BevelKind = bkFlat
        BorderStyle = bsNone
        TabOrder = 0
        Text = ''
        OnExit = edtGrupoExit
      end
    end
    object Panel4: TPanel
      Left = 6
      Top = 120
      Width = 505
      Height = 29
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 2
      object Label2: TLabel
        Left = 222
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
      Left = 6
      Top = 147
      Width = 505
      Height = 31
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 3
      object Label6: TLabel
        Left = 111
        Top = 8
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
        Left = 255
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
        Left = 287
        Top = 5
        Width = 102
        Height = 21
        BevelKind = bkFlat
        BorderStyle = bsNone
        TabOrder = 1
        Text = ''
        OnExit = edtCodUnidadeFinalExit
      end
      object edtCodUnidadeInic: TMaskEdit
        Left = 144
        Top = 5
        Width = 102
        Height = 21
        BevelKind = bkFlat
        BorderStyle = bsNone
        TabOrder = 0
        Text = ''
        OnExit = edtCodUnidadeInicExit
      end
    end
    object Panel6: TPanel
      Left = 6
      Top = 176
      Width = 505
      Height = 29
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 4
      object Label8: TLabel
        Left = 194
        Top = 7
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
      Left = 6
      Top = 203
      Width = 505
      Height = 33
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 5
      object Label9: TLabel
        Left = 112
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
      object Label10: TLabel
        Left = 256
        Top = 11
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
        Left = 287
        Top = 5
        Width = 102
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
        Left = 144
        Top = 6
        Width = 102
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
    object pnlbuttons: TPanel
      Left = 6
      Top = 312
      Width = 505
      Height = 51
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 7
      object btnOK: TBitBtn
        Left = 89
        Top = 6
        Width = 142
        Height = 38
        Caption = '&OK'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
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
        ParentFont = False
        TabOrder = 0
        OnClick = btnOKClick
      end
      object btnCancelar: TBitBtn
        Left = 273
        Top = 6
        Width = 142
        Height = 38
        Caption = '&Cancelar'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
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
        ParentFont = False
        TabOrder = 1
        OnClick = btnCancelarClick
      end
    end
    object Panel11: TPanel
      Left = 6
      Top = 262
      Width = 505
      Height = 51
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 6
      object Label14: TLabel
        Left = 73
        Top = 5
        Width = 135
        Height = 16
        Caption = 'C'#243'digo do Produto:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 273
        Top = 5
        Width = 68
        Height = 16
        Caption = 'Listagem:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cbxProduto: TComboBox
        Left = 72
        Top = 22
        Width = 160
        Height = 21
        TabOrder = 0
        Text = 'EMPR'#201'STIMO'
        OnEnter = cbxProdutoEnter
        OnExit = cbxProdutoExit
        OnKeyDown = cbxProdutoKeyDown
        Items.Strings = (
          'EMPR'#201'STIMO'
          'FINANCIAMENTO')
      end
      object cbxDiver: TComboBox
        Left = 272
        Top = 22
        Width = 160
        Height = 21
        TabOrder = 1
        Text = 'TODOS'
        OnEnter = cbxDiverEnter
        OnExit = cbxDiverExit
        OnKeyDown = cbxDiverKeyDown
        Items.Strings = (
          'TODOS'
          'SOMENTE DIVERG'#202'NCIA')
      end
    end
    object Panel12: TPanel
      Left = 6
      Top = 234
      Width = 505
      Height = 29
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 8
      object Label13: TLabel
        Left = 233
        Top = 7
        Width = 36
        Height = 19
        Caption = 'ADM'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object pnlDisplay: TPanel
      Left = 77
      Top = 242
      Width = 362
      Height = 62
      BevelInner = bvLowered
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 9
      Visible = False
      object Label11: TLabel
        Left = 81
        Top = 2
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
        Left = 81
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
        Left = 29
        Top = 19
        Width = 34
        Height = 30
        Active = True
        AutoSize = False
        CommonAVI = aviFindFile
        StopFrame = 8
      end
    end
    object Panel8: TPanel
      Left = 6
      Top = 35
      Width = 505
      Height = 30
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 10
      object Label5: TLabel
        Left = 111
        Top = 7
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
      object edtEmp: TMaskEdit
        Left = 144
        Top = 4
        Width = 102
        Height = 21
        BevelKind = bkFlat
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 0
        Text = '1'
      end
    end
    object Panel9: TPanel
      Left = 6
      Top = 7
      Width = 505
      Height = 29
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 11
      object Label16: TLabel
        Left = 220
        Top = 7
        Width = 68
        Height = 19
        Caption = 'Empresa'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Edit1: TEdit
        Left = 368
        Top = 4
        Width = 121
        Height = 21
        TabOrder = 0
        Visible = False
      end
    end
  end
  object qryConsulta: TQuery
    DatabaseName = 'database1'
    SessionName = 'Session1_1'
    SQL.Strings = (
      'select sysdate from dual')
    Left = 38
    Top = 157
  end
  object ppDBPipeline1: TppDBPipeline
    DataSource = DataSource1
    UserName = 'DBPipeline1'
    Left = 38
    Top = 125
    object ppDBPipeline1ppField1: TppField
      FieldAlias = 'DES_REDE'
      FieldName = 'DES_REDE'
      FieldLength = 0
      DisplayWidth = 0
      Position = 0
    end
    object ppDBPipeline1ppField2: TppField
      Alignment = taRightJustify
      FieldAlias = 'COD_UNIDADE'
      FieldName = 'COD_UNIDADE'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 10
      Position = 1
    end
    object ppDBPipeline1ppField3: TppField
      FieldAlias = 'DES_UNIDADE'
      FieldName = 'DES_UNIDADE'
      FieldLength = 50
      DisplayWidth = 50
      Position = 2
    end
    object ppDBPipeline1ppField4: TppField
      FieldAlias = 'DTA_CONTABIL'
      FieldName = 'DTA_CONTABIL'
      FieldLength = 0
      DataType = dtDateTime
      DisplayWidth = 18
      Position = 3
    end
    object ppDBPipeline1ppField5: TppField
      Alignment = taRightJustify
      FieldAlias = 'VALOR_TITULOS'
      FieldName = 'VALOR_TITULOS'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 10
      Position = 4
    end
    object ppDBPipeline1ppField6: TppField
      Alignment = taRightJustify
      FieldAlias = 'VALOR_APRO'
      FieldName = 'VALOR_APRO'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 10
      Position = 5
    end
    object ppDBPipeline1ppField7: TppField
      Alignment = taRightJustify
      FieldAlias = 'DIF_TIT_AP'
      FieldName = 'DIF_TIT_AP'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 10
      Position = 6
    end
    object ppDBPipeline1ppField8: TppField
      Alignment = taRightJustify
      FieldAlias = 'VALOR_TITULOS_TOTAL'
      FieldName = 'VALOR_TITULOS_TOTAL'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 10
      Position = 7
    end
    object ppDBPipeline1ppField9: TppField
      Alignment = taRightJustify
      FieldAlias = 'VALOR_APRO_TOTAL'
      FieldName = 'VALOR_APRO_TOTAL'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 10
      Position = 8
    end
    object ppDBPipeline1ppField10: TppField
      Alignment = taRightJustify
      FieldAlias = 'DIF_TIT_AP_TOTAL'
      FieldName = 'DIF_TIT_AP_TOTAL'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 10
      Position = 9
    end
  end
  object pprRelatorio: TppReport
    AutoStop = False
    DataPipeline = ppDBPipeline1
    PassSetting = psTwoPass
    PrinterSetup.BinName = 'Default'
    PrinterSetup.DocumentName = 'Report'
    PrinterSetup.Duplex = dpNone
    PrinterSetup.PaperName = 'A4 (210 x 297 mm)'
    PrinterSetup.PrinterName = 'Default'
    PrinterSetup.SaveDeviceSettings = False
    PrinterSetup.mmMarginBottom = 6350
    PrinterSetup.mmMarginLeft = 6350
    PrinterSetup.mmMarginRight = 6350
    PrinterSetup.mmMarginTop = 6350
    PrinterSetup.mmPaperHeight = 297000
    PrinterSetup.mmPaperWidth = 210000
    PrinterSetup.PaperSize = 9
    ArchiveFileName = '($MyDocuments)\ReportArchive.raf'
    DeviceType = 'Screen'
    DefaultFileDeviceType = 'PDF'
    EmailSettings.ReportFormat = 'PDF'
    LanguageID = 'Default'
    OnPreviewFormCreate = pprRelatorioPreviewFormCreate
    OpenFile = False
    OutlineSettings.CreateNode = True
    OutlineSettings.CreatePageNodes = True
    OutlineSettings.Enabled = False
    OutlineSettings.Visible = False
    ThumbnailSettings.Enabled = True
    ThumbnailSettings.Visible = True
    ThumbnailSettings.DeadSpace = 30
    PDFSettings.EmbedFontOptions = [efUseSubset]
    PDFSettings.EncryptSettings.AllowCopy = True
    PDFSettings.EncryptSettings.AllowInteract = True
    PDFSettings.EncryptSettings.AllowModify = True
    PDFSettings.EncryptSettings.AllowPrint = True
    PDFSettings.EncryptSettings.AllowExtract = True
    PDFSettings.EncryptSettings.AllowAssemble = True
    PDFSettings.EncryptSettings.AllowQualityPrint = True
    PDFSettings.EncryptSettings.Enabled = False
    PDFSettings.EncryptSettings.KeyLength = kl40Bit
    PDFSettings.EncryptSettings.EncryptionType = etRC4
    PDFSettings.FontEncoding = feAnsi
    PDFSettings.ImageCompressionLevel = 25
    PreviewFormSettings.WindowState = wsMaximized
    PreviewFormSettings.ZoomSetting = zsPageWidth
    RTFSettings.DefaultFont.Charset = DEFAULT_CHARSET
    RTFSettings.DefaultFont.Color = clWindowText
    RTFSettings.DefaultFont.Height = -13
    RTFSettings.DefaultFont.Name = 'Arial'
    RTFSettings.DefaultFont.Style = []
    TextFileName = '($MyDocuments)\Report.pdf'
    TextSearchSettings.DefaultString = '<FindText>'
    TextSearchSettings.Enabled = True
    XLSSettings.AppName = 'ReportBuilder'
    XLSSettings.Author = 'ReportBuilder'
    XLSSettings.Subject = 'Report'
    XLSSettings.Title = 'Report'
    XLSSettings.WorksheetName = 'Report'
    Left = 68
    Top = 125
    Version = '17.02'
    mmColumnWidth = 0
    DataPipelineName = 'ppDBPipeline1'
    object ppHeaderBand1: TppHeaderBand
      Background.Brush.Style = bsClear
      mmBottomOffset = 0
      mmHeight = 23019
      mmPrintPosition = 0
      object ppDBText4: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'Des_Grupo1'
        HyperlinkEnabled = False
        DataField = 'DES_REDE'
        DataPipeline = ppDBPipeline1
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 10
        Font.Style = [fsBold, fsUnderline]
        ParentDataPipeline = False
        TextAlignment = taCentered
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 4106
        mmLeft = 74348
        mmTop = 6615
        mmWidth = 50800
        BandType = 0
        LayerName = Foreground
      end
      object ppMemo2: TppMemo
        DesignLayer = ppDesignLayer1
        UserName = 'Memo2'
        Caption = 'Memo2'
        CharWrap = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 12
        Font.Style = [fsBold, fsUnderline]
        Lines.Strings = (
          'Grupo'
          'Grazziotin')
        RemoveEmptyLines = False
        TextAlignment = taCentered
        Transparent = True
        mmHeight = 11113
        mmLeft = 3440
        mmTop = 794
        mmWidth = 24342
        BandType = 0
        LayerName = Foreground
        mmBottomOffset = 0
        mmOverFlowOffset = 0
        mmStopPosition = 0
        mmMinHeight = 0
        mmLeading = 0
      end
      object ppShape2: TppShape
        DesignLayer = ppDesignLayer1
        UserName = 'Shape2'
        Brush.Color = clSilver
        Shape = stRoundRect
        mmHeight = 6615
        mmLeft = 4233
        mmTop = 16404
        mmWidth = 190765
        BandType = 0
        LayerName = Foreground
      end
      object ppLabel16: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'Label16'
        HyperlinkEnabled = False
        Caption = 'Data'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 9
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 3969
        mmLeft = 58738
        mmTop = 17727
        mmWidth = 7408
        BandType = 0
        LayerName = Foreground
      end
      object ppLabel1: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'Label1'
        HyperlinkEnabled = False
        Caption = 'Valor CR'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3344
        mmLeft = 82021
        mmTop = 17992
        mmWidth = 11769
        BandType = 0
        LayerName = Foreground
      end
      object ppLabel15: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'Label15'
        HyperlinkEnabled = False
        Caption = 'P'#225'gina :'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 7
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3175
        mmLeft = 160602
        mmTop = 3969
        mmWidth = 8467
        BandType = 0
        LayerName = Foreground
      end
      object ppSystemVariable4: TppSystemVariable
        DesignLayer = ppDesignLayer1
        UserName = 'SystemVariable4'
        HyperlinkEnabled = False
        VarType = vtPageNo
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 7
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3175
        mmLeft = 169863
        mmTop = 3969
        mmWidth = 11642
        BandType = 0
        LayerName = Foreground
      end
      object ppSystemVariable3: TppSystemVariable
        DesignLayer = ppDesignLayer1
        UserName = 'SystemVariable3'
        HyperlinkEnabled = False
        VarType = vtDateTime
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 7
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3175
        mmLeft = 169863
        mmTop = 7408
        mmWidth = 22225
        BandType = 0
        LayerName = Foreground
      end
      object ppLabel9: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'Label9'
        HyperlinkEnabled = False
        Caption = 'Data de Emiss'#227'o :'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 7
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3175
        mmLeft = 151077
        mmTop = 7408
        mmWidth = 17992
        BandType = 0
        LayerName = Foreground
      end
      object ppLabel10: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'Label10'
        HyperlinkEnabled = False
        Caption = 'Relat'#243'rio de Pagamentos Financeiros:'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 10
        Font.Style = [fsBold, fsUnderline]
        Transparent = True
        mmHeight = 4233
        mmLeft = 59002
        mmTop = 1323
        mmWidth = 55827
        BandType = 0
        LayerName = Foreground
      end
      object pplParametros: TppLabel
        OnPrint = pplParametrosPrint
        DesignLayer = ppDesignLayer1
        UserName = 'lParametros'
        HyperlinkEnabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 9
        Font.Style = []
        Transparent = True
        mmHeight = 3725
        mmLeft = 4233
        mmTop = 12965
        mmWidth = 4995
        BandType = 0
        LayerName = Foreground
      end
      object ppLabel17: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'Label17'
        HyperlinkEnabled = False
        Caption = 'Diferen'#231'a'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3344
        mmLeft = 121709
        mmTop = 17992
        mmWidth = 11896
        BandType = 0
        LayerName = Foreground
      end
      object ppLabel18: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'Label18'
        HyperlinkEnabled = False
        Caption = 'Valor FINAN'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 8
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3344
        mmLeft = 99748
        mmTop = 17992
        mmWidth = 16637
        BandType = 0
        LayerName = Foreground
      end
      object pplblcod_produto: TppLabel
        OnPrint = pplblcod_produtoPrint
        DesignLayer = ppDesignLayer1
        UserName = 'lblcod_produto'
        HyperlinkEnabled = False
        Caption = 'FINANCIAMENTO'
        Color = clSilver
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 9
        Font.Style = [fsBold]
        mmHeight = 3725
        mmLeft = 116681
        mmTop = 1588
        mmWidth = 27855
        BandType = 0
        LayerName = Foreground
      end
      object ppLabel2: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'Label2'
        HyperlinkEnabled = False
        Caption = 'Valor CR'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 7
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 2910
        mmLeft = 143934
        mmTop = 16764
        mmWidth = 10319
        BandType = 0
        LayerName = Foreground
      end
      object ppLabel11: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'Label11'
        HyperlinkEnabled = False
        Caption = 'Total'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 7
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 2921
        mmLeft = 146579
        mmTop = 19736
        mmWidth = 5546
        BandType = 0
        LayerName = Foreground
      end
      object ppLabel3: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'Label3'
        HyperlinkEnabled = False
        Caption = 'Total'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 7
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 2921
        mmLeft = 167482
        mmTop = 19844
        mmWidth = 5546
        BandType = 0
        LayerName = Foreground
      end
      object ppLabel12: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'Label12'
        HyperlinkEnabled = False
        Caption = 'Valor FINAN'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 7
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 2921
        mmLeft = 162719
        mmTop = 16764
        mmWidth = 14436
        BandType = 0
        LayerName = Foreground
      end
      object ppLabel5: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'Label5'
        HyperlinkEnabled = False
        Caption = 'Diferen'#231'a'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 7
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 2921
        mmLeft = 182298
        mmTop = 16764
        mmWidth = 10414
        BandType = 0
        LayerName = Foreground
      end
      object ppLabel13: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'Label13'
        HyperlinkEnabled = False
        Caption = 'dos Totais'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Times New Roman'
        Font.Size = 7
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 2921
        mmLeft = 182298
        mmTop = 19844
        mmWidth = 10668
        BandType = 0
        LayerName = Foreground
      end
    end
    object ppDetailBand: TppDetailBand
      Background1.Brush.Style = bsClear
      Background2.Brush.Style = bsClear
      mmBottomOffset = 0
      mmHeight = 4233
      mmPrintPosition = 0
      object ppDBText1: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'DBText1'
        HyperlinkEnabled = False
        DataField = 'DTA_CONTABIL'
        DataPipeline = ppDBPipeline1
        DisplayFormat = 'dd/mm/yyyy'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3260
        mmLeft = 54240
        mmTop = 180
        mmWidth = 14817
        BandType = 4
        LayerName = Foreground
      end
      object ppDBText2: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'DBText2'
        HyperlinkEnabled = False
        DataField = 'VALOR_TITULOS'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '#,0.00;-#,0.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3260
        mmLeft = 74877
        mmTop = 180
        mmWidth = 17198
        BandType = 4
        LayerName = Foreground
      end
      object ppDBText5: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'DBText5'
        HyperlinkEnabled = False
        DataField = 'VALOR_APRO'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '#,0.00;-#,0.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3260
        mmLeft = 96573
        mmTop = 180
        mmWidth = 17198
        BandType = 4
        LayerName = Foreground
      end
      object ppDBDif_tit_ap: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'DBDif_tit_ap'
        HyperlinkEnabled = False
        DataField = 'DIF_TIT_AP'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '#,0.00;-#,0.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3260
        mmLeft = 115359
        mmTop = 180
        mmWidth = 15875
        BandType = 4
        LayerName = Foreground
      end
      object ppDBText3: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'DBDif_tit_ap1'
        HyperlinkEnabled = False
        DataField = 'DIF_TIT_AP_TOTAL'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '#,0.00;-#,0.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3260
        mmLeft = 176477
        mmTop = 265
        mmWidth = 15875
        BandType = 4
        LayerName = Foreground
      end
      object ppDBText6: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'DBText6'
        HyperlinkEnabled = False
        DataField = 'VALOR_APRO_TOTAL'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '#,0.00;-#,0.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3260
        mmLeft = 157692
        mmTop = 265
        mmWidth = 17198
        BandType = 4
        LayerName = Foreground
      end
      object ppDBText7: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'DBText7'
        HyperlinkEnabled = False
        DataField = 'VALOR_TITULOS_TOTAL'
        DataPipeline = ppDBPipeline1
        DisplayFormat = '#,0.00;-#,0.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 8
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'ppDBPipeline1'
        mmHeight = 3260
        mmLeft = 135996
        mmTop = 265
        mmWidth = 17198
        BandType = 4
        LayerName = Foreground
      end
    end
    object ppFooterBand: TppFooterBand
      Background.Brush.Style = bsClear
      mmBottomOffset = 0
      mmHeight = 0
      mmPrintPosition = 0
    end
    object ppGroup4: TppGroup
      BreakName = 'DES_REDE'
      DataPipeline = ppDBPipeline1
      GroupFileSettings.NewFile = False
      GroupFileSettings.EmailFile = False
      OutlineSettings.CreateNode = True
      NewPage = True
      ResetPageNo = True
      StartOnOddPage = False
      UserName = 'Group4'
      mmNewColumnThreshold = 0
      mmNewPageThreshold = 0
      DataPipelineName = 'ppDBPipeline1'
      NewFile = False
      object ppGroupHeaderBand4: TppGroupHeaderBand
        Background.Brush.Style = bsClear
        mmBottomOffset = 0
        mmHeight = 0
        mmPrintPosition = 0
      end
      object ppGroupFooterBandRede: TppGroupFooterBand
        Background.Brush.Style = bsClear
        HideWhenOneDetail = False
        mmBottomOffset = 0
        mmHeight = 3440
        mmPrintPosition = 0
        object ppLabel8: TppLabel
          DesignLayer = ppDesignLayer1
          UserName = 'Label8'
          HyperlinkEnabled = False
          Caption = 'Total Rede:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3387
          mmLeft = 53711
          mmTop = 0
          mmWidth = 15409
          BandType = 5
          GroupNo = 0
          LayerName = Foreground
        end
        object ppDBCalcRedeDif_tit_ap: TppDBCalc
          DesignLayer = ppDesignLayer1
          UserName = 'DBCalcRedeDif_tit_ap'
          HyperlinkEnabled = False
          DataField = 'DIF_TIT_AP'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup4
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3387
          mmLeft = 114036
          mmTop = 0
          mmWidth = 17198
          BandType = 5
          GroupNo = 0
          LayerName = Foreground
        end
        object ppDBCalc7: TppDBCalc
          DesignLayer = ppDesignLayer1
          UserName = 'DBCalc7'
          HyperlinkEnabled = False
          DataField = 'VALOR_APRO'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup4
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3387
          mmLeft = 93134
          mmTop = 0
          mmWidth = 20638
          BandType = 5
          GroupNo = 0
          LayerName = Foreground
        end
        object ppDBCalc10: TppDBCalc
          DesignLayer = ppDesignLayer1
          UserName = 'DBCalc10'
          HyperlinkEnabled = False
          DataField = 'VALOR_TITULOS'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup4
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3387
          mmLeft = 70115
          mmTop = 0
          mmWidth = 22225
          BandType = 5
          GroupNo = 0
          LayerName = Foreground
        end
        object ppDBCalc6: TppDBCalc
          DesignLayer = ppDesignLayer1
          UserName = 'DBCalc101'
          HyperlinkEnabled = False
          DataField = 'VALOR_TITULOS_TOTAL'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup4
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3387
          mmLeft = 131234
          mmTop = 0
          mmWidth = 22225
          BandType = 5
          GroupNo = 0
          LayerName = Foreground
        end
        object ppDBCalc8: TppDBCalc
          DesignLayer = ppDesignLayer1
          UserName = 'DBCalc8'
          HyperlinkEnabled = False
          DataField = 'VALOR_APRO_TOTAL'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup4
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3387
          mmLeft = 154252
          mmTop = 0
          mmWidth = 20638
          BandType = 5
          GroupNo = 0
          LayerName = Foreground
        end
        object ppDBCalc9: TppDBCalc
          DesignLayer = ppDesignLayer1
          UserName = 'DBCalcRedeDif_tit_ap1'
          HyperlinkEnabled = False
          DataField = 'DIF_TIT_AP_TOTAL'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup4
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3387
          mmLeft = 175155
          mmTop = 0
          mmWidth = 17198
          BandType = 5
          GroupNo = 0
          LayerName = Foreground
        end
      end
    end
    object ppGroup5: TppGroup
      BreakName = 'DES_UNIDADE'
      DataPipeline = ppDBPipeline1
      GroupFileSettings.NewFile = False
      GroupFileSettings.EmailFile = False
      OutlineSettings.CreateNode = True
      StartOnOddPage = False
      UserName = 'Group5'
      mmNewColumnThreshold = 0
      mmNewPageThreshold = 0
      DataPipelineName = 'ppDBPipeline1'
      NewFile = False
      object ppGroupHeaderBand5: TppGroupHeaderBand
        Background.Brush.Style = bsClear
        mmBottomOffset = 0
        mmHeight = 3704
        mmPrintPosition = 0
        object ppDBText13: TppDBText
          DesignLayer = ppDesignLayer1
          UserName = 'DBText13'
          HyperlinkEnabled = False
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
          mmLeft = 20638
          mmTop = 264
          mmWidth = 58208
          BandType = 3
          GroupNo = 1
          LayerName = Foreground
        end
        object ppLabel6: TppLabel
          DesignLayer = ppDesignLayer1
          UserName = 'Label6'
          HyperlinkEnabled = False
          Caption = 'Loja:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Name = 'Times New Roman'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3344
          mmLeft = 4763
          mmTop = 265
          mmWidth = 6646
          BandType = 3
          GroupNo = 1
          LayerName = Foreground
        end
        object ppDBText9: TppDBText
          DesignLayer = ppDesignLayer1
          UserName = 'DBText4'
          HyperlinkEnabled = False
          DataField = 'COD_UNIDADE'
          DataPipeline = ppDBPipeline1
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Name = 'Times New Roman'
          Font.Size = 8
          Font.Style = [fsBold]
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3440
          mmLeft = 11906
          mmTop = 264
          mmWidth = 5556
          BandType = 3
          GroupNo = 1
          LayerName = Foreground
        end
        object ppLabel7: TppLabel
          DesignLayer = ppDesignLayer1
          UserName = 'Label7'
          HyperlinkEnabled = False
          Caption = ' - '
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Name = 'Times New Roman'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3344
          mmLeft = 17727
          mmTop = 265
          mmWidth = 2371
          BandType = 3
          GroupNo = 1
          LayerName = Foreground
        end
      end
      object ppGroupFooterBandUni: TppGroupFooterBand
        Background.Brush.Style = bsClear
        HideWhenOneDetail = False
        mmBottomOffset = 0
        mmHeight = 4498
        mmPrintPosition = 0
        object ppDBCalc2: TppDBCalc
          DesignLayer = ppDesignLayer1
          UserName = 'DBCalc2'
          HyperlinkEnabled = False
          DataField = 'VALOR_TITULOS'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup5
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3387
          mmLeft = 70115
          mmTop = 265
          mmWidth = 22225
          BandType = 5
          GroupNo = 1
          LayerName = Foreground
        end
        object ppLabel4: TppLabel
          DesignLayer = ppDesignLayer1
          UserName = 'Label4'
          HyperlinkEnabled = False
          Caption = 'Total Loja:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          Transparent = True
          mmHeight = 3387
          mmLeft = 55033
          mmTop = 265
          mmWidth = 14309
          BandType = 5
          GroupNo = 1
          LayerName = Foreground
        end
        object ppDBCalc3: TppDBCalc
          DesignLayer = ppDesignLayer1
          UserName = 'DBCalc3'
          HyperlinkEnabled = False
          DataField = 'VALOR_APRO'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup5
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3387
          mmLeft = 93134
          mmTop = 265
          mmWidth = 20638
          BandType = 5
          GroupNo = 1
          LayerName = Foreground
        end
        object ppDBCalcUniDif_tit_ap: TppDBCalc
          DesignLayer = ppDesignLayer1
          UserName = 'DBCalcUniDif_tit_ap'
          HyperlinkEnabled = False
          DataField = 'DIF_TIT_AP'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup5
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3387
          mmLeft = 114036
          mmTop = 265
          mmWidth = 17198
          BandType = 5
          GroupNo = 1
          LayerName = Foreground
        end
        object ppLine1: TppLine
          DesignLayer = ppDesignLayer1
          UserName = 'Line1'
          Weight = 0.750000000000000000
          mmHeight = 794
          mmLeft = 4233
          mmTop = 3704
          mmWidth = 189707
          BandType = 5
          GroupNo = 1
          LayerName = Foreground
        end
        object ppLine3: TppLine
          DesignLayer = ppDesignLayer1
          UserName = 'Line3'
          Pen.Style = psDot
          Weight = 0.750000000000000000
          mmHeight = 794
          mmLeft = 4498
          mmTop = 0
          mmWidth = 189707
          BandType = 5
          GroupNo = 1
          LayerName = Foreground
        end
        object ppDBCalc1: TppDBCalc
          DesignLayer = ppDesignLayer1
          UserName = 'DBCalc1'
          HyperlinkEnabled = False
          DataField = 'VALOR_TITULOS_TOTAL'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup5
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3387
          mmLeft = 131234
          mmTop = 265
          mmWidth = 22225
          BandType = 5
          GroupNo = 1
          LayerName = Foreground
        end
        object ppDBCalc4: TppDBCalc
          DesignLayer = ppDesignLayer1
          UserName = 'DBCalc4'
          HyperlinkEnabled = False
          DataField = 'VALOR_APRO_TOTAL'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup5
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3387
          mmLeft = 154252
          mmTop = 265
          mmWidth = 20638
          BandType = 5
          GroupNo = 1
          LayerName = Foreground
        end
        object ppDBCalc5: TppDBCalc
          DesignLayer = ppDesignLayer1
          UserName = 'DBCalcUniDif_tit_ap1'
          HyperlinkEnabled = False
          DataField = 'DIF_TIT_AP_TOTAL'
          DataPipeline = ppDBPipeline1
          DisplayFormat = '#,0.00;-#,0.00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Name = 'Arial'
          Font.Size = 8
          Font.Style = [fsBold]
          ResetGroup = ppGroup5
          TextAlignment = taRightJustified
          Transparent = True
          DataPipelineName = 'ppDBPipeline1'
          mmHeight = 3387
          mmLeft = 175155
          mmTop = 265
          mmWidth = 17198
          BandType = 5
          GroupNo = 1
          LayerName = Foreground
        end
      end
    end
    object ppDesignLayers1: TppDesignLayers
      object ppDesignLayer1: TppDesignLayer
        UserName = 'Foreground'
        LayerType = ltBanded
        Index = 0
      end
    end
    object ppParameterList1: TppParameterList
    end
  end
  object DataSource1: TDataSource
    DataSet = qryRel
    Left = 68
    Top = 93
  end
  object Database1: TDatabase
    AliasName = 'NL'
    DatabaseName = 'database1'
    KeepConnection = False
    LoginPrompt = False
    Params.Strings = (
      'SERVER NAME=NLPROD2'
      'USER NAME=NL'
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
      'PASSWORD=NL')
    SessionName = 'Session1_1'
    Left = 23
    Top = 64
  end
  object StpConciliacao: TStoredProc
    DatabaseName = 'database1'
    SessionName = 'Session1_1'
    StoredProcName = 'GRZ_REL_PAG_FINANC_SP'
    Left = 52
    Top = 64
    ParamData = <
      item
        DataType = ftString
        Name = 'PI_OPCAO'
        ParamType = ptInput
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
    SessionName = 'Session1_1'
    Left = 81
    Top = 64
  end
  object qryRel: TQuery
    DatabaseName = 'database1'
    SessionName = 'Session1_1'
    SQL.Strings = (
      'select des_rede, cod_unidade, des_unidade, dta_contabil'
      ', sum(vlr_cr) as valor_titulos'
      ', sum(vlr_cdc_apro) as valor_apro'
      ', (sum(vlr_cr) - sum(vlr_cdc_apro)) as dif_tit_ap'
      ', sum(vlr_cr_total) as valor_titulos_total'
      ', sum(vlr_cdc_apro_total) as valor_apro_total'
      
        ', (sum(vlr_cr_total) - sum(vlr_cdc_apro_total)) as dif_tit_ap_to' +
        'tal'
      ' from GRZ_REL_PAG_FINANC'
      ' where des_usuario = '#39'378371'#39
      ' group by des_rede, cod_unidade, des_unidade, dta_contabil'
      ' order by des_rede, cod_unidade, des_unidade, dta_contabil')
    Left = 38
    Top = 93
    object qryRelDES_REDE: TStringField
      FieldName = 'DES_REDE'
      Origin = 'DATABASE1.GRZ_REL_PAG_FINANC.DES_REDE'
    end
    object qryRelCOD_UNIDADE: TFloatField
      FieldName = 'COD_UNIDADE'
      Origin = 'DATABASE1.GRZ_REL_PAG_FINANC.COD_UNIDADE'
    end
    object qryRelDES_UNIDADE: TStringField
      FieldName = 'DES_UNIDADE'
      Origin = 'DATABASE1.GRZ_REL_PAG_FINANC.DES_UNIDADE'
      Size = 50
    end
    object qryRelDTA_CONTABIL: TDateTimeField
      FieldName = 'DTA_CONTABIL'
      Origin = 'DATABASE1.GRZ_REL_PAG_FINANC.DTA_CONTABIL'
    end
    object qryRelVALOR_TITULOS: TFloatField
      FieldName = 'VALOR_TITULOS'
      Origin = 'DATABASE1.GRZ_REL_PAG_FINANC.VLR_CR'
    end
    object qryRelVALOR_APRO: TFloatField
      FieldName = 'VALOR_APRO'
      Origin = 'DATABASE1.GRZ_REL_PAG_FINANC.VLR_CDC_APRO'
    end
    object qryRelDIF_TIT_AP: TFloatField
      FieldName = 'DIF_TIT_AP'
      Origin = 'DATABASE1.GRZ_REL_PAG_FINANC.VLR_CR'
    end
    object qryRelVALOR_TITULOS_TOTAL: TFloatField
      FieldName = 'VALOR_TITULOS_TOTAL'
      Origin = 'DATABASE1.GRZ_REL_PAG_FINANC.VLR_CR_TOTAL'
    end
    object qryRelVALOR_APRO_TOTAL: TFloatField
      FieldName = 'VALOR_APRO_TOTAL'
      Origin = 'DATABASE1.GRZ_REL_PAG_FINANC.VLR_CDC_APRO_TOTAL'
    end
    object qryRelDIF_TIT_AP_TOTAL: TFloatField
      FieldName = 'DIF_TIT_AP_TOTAL'
      Origin = 'DATABASE1.GRZ_REL_PAG_FINANC.VLR_CR_TOTAL'
    end
  end
end
