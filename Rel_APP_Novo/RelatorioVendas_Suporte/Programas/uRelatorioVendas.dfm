object frmRelatorioVendas: TfrmRelatorioVendas
  Left = 270
  Top = 20
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Atualiza Cliente '#192' Vista...'
  ClientHeight = 693
  ClientWidth = 796
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlRodape: TPanel
    Left = 0
    Top = 665
    Width = 796
    Height = 28
    Align = alBottom
    BevelInner = bvLowered
    TabOrder = 0
    object btnSair: TBitBtn
      Left = 719
      Top = 2
      Width = 75
      Height = 24
      Align = alRight
      Caption = 'Sair'
      Glyph.Data = {
        9E050000424D9E05000000000000360400002800000012000000120000000100
        0800000000006801000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A6000020400000206000002080000020A0000020C0000020E000004000000040
        20000040400000406000004080000040A0000040C0000040E000006000000060
        20000060400000606000006080000060A0000060C0000060E000008000000080
        20000080400000806000008080000080A0000080C0000080E00000A0000000A0
        200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
        200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
        200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
        20004000400040006000400080004000A0004000C0004000E000402000004020
        20004020400040206000402080004020A0004020C0004020E000404000004040
        20004040400040406000404080004040A0004040C0004040E000406000004060
        20004060400040606000406080004060A0004060C0004060E000408000004080
        20004080400040806000408080004080A0004080C0004080E00040A0000040A0
        200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
        200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
        200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
        20008000400080006000800080008000A0008000C0008000E000802000008020
        20008020400080206000802080008020A0008020C0008020E000804000008040
        20008040400080406000804080008040A0008040C0008040E000806000008060
        20008060400080606000806080008060A0008060C0008060E000808000008080
        20008080400080806000808080008080A0008080C0008080E00080A0000080A0
        200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
        200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
        200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
        2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
        2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
        2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
        2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
        2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
        2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
        2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
        07070707070707070707070700000707FFFFFFFFFFFFFFFF0000FFFFFF070707
        00000707FFFFFFFFFFFFFFFF00FE00FFFFFF0707000007FFFFFFFFFFFFFFFFFF
        00FE0600FFFFFF07000007000000000000FFFFFF00FE06060000000700000707
        070707070700000000FE060600070707000007070707070007A4A4A400FE0606
        00070707000007070707070000A4A4A400FE0606000707070000070707070700
        FE00A4A400FE0006000707070000070700000000FEFE00A400FE000600070707
        00000707FEFEFEFEFEFEFE0000FE0606000707070000070706060606FEFE00A4
        00FE0606000707070000070707070700FE00A4A400FE06060007070700000707
        0707070000A4A4A400FE060600070707000007070707070007A4A4A4A400FE06
        00070707000007070707070707A4A4A4A4A400FE000707070000070707070707
        07A4A4A4A4A4A400000707070000070707070707070707070707070707070707
        0000}
      TabOrder = 0
      OnClick = btnSairClick
    end
    object btnRelatorio: TBitBtn
      Left = 2
      Top = 2
      Width = 87
      Height = 24
      Align = alLeft
      Caption = 'Relat'#243'rio'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
        0003377777777777777308888888888888807F33333333333337088888888888
        88807FFFFFFFFFFFFFF7000000000000000077777777777777770F8F8F8F8F8F
        8F807F333333333333F708F8F8F8F8F8F9F07F333333333337370F8F8F8F8F8F
        8F807FFFFFFFFFFFFFF7000000000000000077777777777777773330FFFFFFFF
        03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
        03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
        33333337F3F37F3733333330F08F0F0333333337F7337F7333333330FFFF0033
        33333337FFFF7733333333300000033333333337777773333333}
      NumGlyphs = 2
      TabOrder = 1
      Visible = False
      OnClick = btnRelatorioClick
    end
  end
  object pnlCabecalho: TPanel
    Left = 0
    Top = 0
    Width = 796
    Height = 48
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 1
    object grpDatas: TGroupBox
      Left = 2
      Top = 2
      Width = 242
      Height = 44
      Align = alLeft
      Caption = '[ Intervalo ]'
      TabOrder = 0
      OnClick = grpDatasClick
      object lblInicial: TLabel
        Left = 11
        Top = 21
        Width = 31
        Height = 13
        Caption = 'Inicial:'
        OnClick = lblInicialClick
      end
      object lblFinal: TLabel
        Left = 128
        Top = 21
        Width = 26
        Height = 13
        Caption = 'Final:'
      end
      object edtInicial: TMaskEdit
        Left = 48
        Top = 17
        Width = 74
        Height = 21
        EditMask = '!##/##/####;1; '
        MaxLength = 10
        TabOrder = 0
        Text = '99/99/9999'
        OnExit = edtInicialExit
        OnKeyDown = edtInicialKeyDown
      end
      object edtFinal: TMaskEdit
        Left = 160
        Top = 17
        Width = 74
        Height = 21
        EditMask = '!##/##/####;1; '
        MaxLength = 10
        TabOrder = 1
        Text = '99/99/9999'
        OnExit = edtFinalExit
        OnKeyDown = edtFinalKeyDown
      end
    end
    object btnRelatorioVendas: TBitBtn
      Left = 649
      Top = 2
      Width = 145
      Height = 44
      Align = alRight
      Caption = 'Relat'#243'rio Vendas'
      Glyph.Data = {
        360C0000424D360C000000000000360000002800000020000000200000000100
        180000000000000C0000C40E0000C40E00000000000000000000FFFFFFFDFDFD
        FBFBFBF8F8F8F6F6F6F3F3F3F2F2F2EFEFEFECECECEBEBEBEBEBEBEBEBEBE6E6
        E6E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E6E6E6EBEBEBEBEBEBEBEBEBEC
        ECECEFEFEFF2F2F2F3F3F3F6F6F6F8F8F8FBFBFBFDFDFDFFFFFFF6F6F6D7D7D7
        C7C7C7BEBEBEB9B9B9B4B4B4B2B2B2B0B0B0ADADADADADADADADADADADADAAAA
        AAA9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9A9AAAAAAADADADADADADADADADAD
        ADADB0B0B0B2B2B2B4B4B4B9B9B9BEBEBEC7C7C7D7D7D7F6F6F6FBFBFBEDEDED
        E3E3E3DCDCDCD5D5D5C7C7C7C2C2C2BFBFBFBFBFBFBCBCBCB9B9B9B9B9B9B9B9
        B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9B9BCBCBCBF
        BFBFBFBFBFC2C2C2C7C7C7D4D4D4DCDCDCE3E3E3EDEDEDFBFBFBFFFFFFFFFFFF
        FFFFFFFFFFFFDFDFDFC3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
        C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3
        C3C3C3C3C3C3C3C3C3C3C3D9D9D9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFD9D9D9C3C3C3C3C3C3C3C3C3C6C6C6C6C6C6C6C6C6C6C6C6C6C6
        C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C5
        C5C5C3C3C3C3C3C3C3C3C3D3D3D3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFDADADAC3C3C3C3C3C3C3C3C3B1AA9FAFA99DAFA99DAFA99DAFA9
        9DAFA99DAFA99DAFA99DAFA99DAFA99DAFA99DAFA99DAFA99DAFA99DAFA99DB4
        AEA5C3C3C3C3C3C3C3C3C3D4D4D4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFDADADAC4C4C4C4C4C4C4C4C4BDBBB8BCBAB7B4B7B975A1C9BCBA
        B7BCBAB7BCBAB7BCBAB7BCBAB7BCBAB7BCBAB7BCBAB7BCBAB7BCBAB7BCBAB7BE
        BDBAC4C4C4C4C4C4C4C4C4D5D5D5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFDCDCDCC8C8C8C8C8C8C8C8C8C8C8C8C7C7C884AFD9158AE9ACBD
        CFC8C8C8C8C8C8C0BDB6BFBCB5BFBCB5BFBCB5BFBCB5BFBCB5BFBCB5BFBCB5C2
        C0BCC8C8C8C8C8C8C8C8C8D7D7D7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFDEDEDECACACACACACACACACACACACA59A4E10E98EB0F96EA0C93
        EB97B8D6CACACAB4AFA7B3AEA5B3AEA5B3AEA5B3AEA5B3AEA5B3AEA5B3AEA5BB
        B7B2CACACACACACACACACAD9D9D9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFE0E0E0CDCDCDCDCDCDCDCDCDCDCDCD54ACE848A4ED0F92F00797
        ED71B2E1CDCDCDD1D1D1D1D1D1D1D1D1D1D1D1D1D1D1CDCDCDCDCDCDCDCDCDCD
        CDCDCDCDCDCDCDCDCDCDCDDBDBDBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFE1E1E1D0D0D0D0D0D0D0D0D0D0D0D080B5E00CA2F310A7F249B0
        EEBDC8D4D0D0D0ADA69AABA497ABA497ABA497ABA497CDCCCBD0D0D0D0D0D0D0
        D0D0D0D0D0D0D0D0D0D0D0DDDDDDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFE3E3E3D2D2D2D2D2D2D2D2D2D2D2D24AB1ED0EA0F80C99F708A1
        F89BBEDED2D2D2CBC9C7CAC8C6CAC8C6CAC8C6CAC8C6D2D2D2D2D2D2D2D2D2D2
        D2D2D2D2D2D2D2D2D2D2D2DFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFE4E4E4D5D5D5D5D5D5D5D5D5D5D5D5ACC7DE3DB7F512B4FB5BBA
        EFCBD1D6D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5
        D5D5D5D5D5D5D5D5D5D5D5E0E0E0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFE6E6E6D7D7D7D7D7D7D7D7D7D1D0CDD0CECBC6CACD88B9DBD0CE
        CBD0CECBD0CECBD0CECBD0CECBD0CECBD0CECBD0CECBD0CECBD0CECBD0CECBD2
        D1CED7D7D7D7D7D7D7D7D7E2E2E2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFE7E7E7D9D9D9D9D9D9D9D9D9AEA79BABA498ABA498ABA498ABA4
        98ABA498ABA498ABA498ABA498ABA498ABA498ABA498ABA498ABA498ABA498B5
        AFA5D9D9D9D9D9D9D9D9D9E4E4E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFE9E9E9DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBC7D2DE4FA1EADBDB
        DBDBDBDBDBDBDBDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDC
        DCDCDBDBDBDBDBDBDBDBDBE5E5E5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFEAEAEADDDDDDDDDDDDDDDDDDDDDDDDC7D3E054A6EA0C8BE879B4
        E7DADCDEDDDDDDB2ABA0AFA99DAFA99DAFA99DAFA99DAFA99DAFA99DAFA99DBF
        BAB2DDDDDDDDDDDDDDDDDDE7E7E7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFEBEBEBDFDFDFDFDFDFDFDFDFDFDFDF3AA2EC1C9FEE1B9AEF0F99
        EB84BAE9DFDFDFD2D0CDD1CFCBD1CFCBD1CFCBD1CFCBD1CFCBD1CFCBD1CFCBD6
        D5D2DFDFDFDFDFDFDFDFDFE8E8E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFECECECE1E1E1E1E1E1E1E1E1E1E1E192C6EC43A4F40596F10BA0
        EE8FC3EBE1E1E1D3D1CDD2D0CCD2D0CCD2D0CCD2D0CCE0E0E0E1E1E1E1E1E1E1
        E1E1E1E1E1E1E1E1E1E1E1E9E9E9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFEEEEEEE3E3E3E3E3E3E3E3E3E3E3E35FB3F00FAAF41BA7F549A9
        F6D3DCE5E3E3E3B3ADA2B0AA9EB0AA9EB0AA9EB1AA9FDFDEDDE3E3E3E3E3E3E3
        E3E3E3E3E3E3E3E3E3E3E3EBEBEBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFEEEEEEE4E4E4E4E4E4E4E4E4E4E4E467BEF20BA7F902A0FA0DB1
        F8ACCDEBE4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4
        E4E4E4E4E4E4E4E4E4E4E4ECECECFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFEFEFEFE6E6E6E6E6E6E6E6E6E6E6E6D8E0E77FC4F32CB6FBA3CE
        EEE6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6
        E6E6E6E6E6E6E6E6E6E6E6EDEDEDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFF0F0F0E7E7E7E7E7E7E8E8E8E8E8E8E8E8E8E7E8E8CDDCEBE8E8
        E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
        E8E8E8E8E8E7E7E7E7E7E7EEEEEEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFF1F1F1E9E9E9E4E7EA58A4DC4F9FDB4F9FDB4F9FDB4F9FDB4F9F
        DB4F9FDB4F9FDB4F9FDB4F9FDB4F9FDB4F9FDB4F9FDB4F9FDB4F9FDB4F9FDB4F
        9FDB59A4DCE5E7EAE9E9E9EEEEEEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFF1F1F1EAEAEAD7E1E91486DA1486DA1486DA1486DA1486DA1486
        DA1486DA1486DA1486DA1486DA1486DA1486DA1486DA1486DA1486DA1486DA14
        86DA1486DAD7E1E9EAEAEAF0F0F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFF2F2F2EBEBEBD8E3EB188DE1188DE1188DE1188DE1188DE1188D
        E1188DE1188DE1188DE1188DE1188DE1188DE1188DE1188DE1188DE1188DE118
        8DE1188DE1D8E3EBEBEBEBEDEDEDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFF3F3F3ECECECDBE5EC33A2EB33A1EB33A1EB33A1EB33A1EB33A1
        EB33A1EB33A1EB33A1EB33A1EB33A1EB33A1EB33A1EB33A1EB33A1EB558CB37C
        8084757D827F80807F7F7FDEDEDEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFF3F3F3ECECECECECECAED4EDB1D8EFB1D8EFB1D8EFB1D8EFB1D8
        EFB1D8EFB1D8EFB1D8EFB1D8EFB1D8EFB1D8EFB1D8EFB1D8EFB1D8EF83888B76
        76767070706A6A6ACBCBCBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFF3F3F3EDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDED
        EDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDED80808068
        6868626262C8C8C8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFF4F4F4EDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDED
        EDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDED71717158
        5858C4C4C4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFF4F4F4EFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEF
        EFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEF626262C1
        C1C1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFDFDFDF4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4
        F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4EEEEEED3D3D3FF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      TabOrder = 1
      OnClick = btnRelatorioVendasClick
    end
  end
  object pnlFundo: TPanel
    Left = 0
    Top = 48
    Width = 796
    Height = 617
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 2
    Visible = False
    object pnlFundoClilentesAVista: TPanel
      Left = 2
      Top = 2
      Width = 792
      Height = 613
      Align = alClient
      BevelInner = bvLowered
      TabOrder = 0
      object pnlCabRelatorioVendas: TPanel
        Left = 2
        Top = 2
        Width = 788
        Height = 30
        Align = alTop
        BevelInner = bvLowered
        Caption = 'Relat'#243'rio de Vendas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object grdRelatorioVendas: TDBGrid
        Left = 2
        Top = 32
        Width = 788
        Height = 209
        Align = alTop
        DataSource = dtsAtualiza
        DrawingStyle = gdsGradient
        Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'ANOMES'
            Title.Caption = 'Ano/M'#234's'
            Width = 55
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'QTD_TOT_CLI_APP'
            Title.Caption = 'Cadastrados APP'
            Width = 98
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'QTD_NEW_CLI_APP'
            Title.Caption = 'Novos Cadastros'
            Width = 99
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'QTD_CLI_GRAZZIOTIN'
            Title.Caption = 'Clientes Grazziotin'
            Width = 98
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'QTD_NEW_CLI_APP_APROV'
            Title.Caption = 'Clientes Aprovados'
            Width = 104
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TOT_CLI_PGTO_APP'
            Title.Caption = 'Pagamento(s) pelo APP'
            Width = 125
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'QTD_PARCELAS_PGTO_CIA'
            Title.Caption = 'Parcelas Pagas na CIA'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VLR_PARCELAS_PGTO_CIA'
            Title.Caption = 'Valor Pago na CIA'
            Visible = True
          end>
      end
      object pnlCabOpcoesGrafico: TPanel
        Left = 2
        Top = 241
        Width = 788
        Height = 33
        Align = alTop
        BevelInner = bvLowered
        TabOrder = 2
        object lblMostrarGrafico: TLabel
          Left = 9
          Top = 9
          Width = 41
          Height = 13
          Caption = 'Mostrar:'
          OnClick = lblMostrarGraficoClick
        end
        object lblTipoGrafico: TLabel
          Left = 237
          Top = 9
          Width = 24
          Height = 13
          Caption = 'Tipo:'
        end
        object lblTipoBarra: TLabel
          Left = 331
          Top = 9
          Width = 30
          Height = 13
          Caption = 'Barra:'
        end
        object chb3D: TCheckBox
          Left = 518
          Top = 8
          Width = 34
          Height = 17
          Caption = '3D'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = chb3DClick
        end
        object cbxMostrarGrafico: TComboBox
          Left = 56
          Top = 6
          Width = 175
          Height = 21
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 1
          Text = 'Cadastrados APP'
          OnChange = cbxMostrarGraficoChange
          OnKeyDown = cbxMostrarGraficoKeyDown
          Items.Strings = (
            'Cadastrados APP'
            'Novos Cadastrados'
            'Clientes GRAZZIOTIN'
            'Novos Clientes Aprovados APP'
            'Pagamento pelo APP'
            'Parcelas Pagas na CIA'
            'Valor Pago na CIA')
        end
        object cbxTipoGrafico: TComboBox
          Left = 267
          Top = 6
          Width = 58
          Height = 21
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 2
          Text = 'Barra'
          OnChange = cbxTipoGraficoChange
          OnKeyDown = cbxTipoGraficoKeyDown
          Items.Strings = (
            'Barra'
            'Linha'
            #193'rea')
        end
        object cbxTipoBarra: TComboBox
          Left = 367
          Top = 6
          Width = 145
          Height = 21
          Style = csDropDownList
          ItemIndex = 10
          TabOrder = 3
          Text = 'Ret'#226'ngulo'
          OnChange = cbxTipoBarraChange
          OnKeyDown = cbxTipoBarraKeyDown
          Items.Strings = (
            'Seta'
            'Bevel'
            'Cilindro'
            'Cone'
            'Diamante'
            'Elipse'
            'Seta Invertida'
            'Cone Invertido'
            'Pir'#226'mide Invertida'
            'Pir'#226'mide'
            'Ret'#226'ngulo'
            'Ret'#226'ngulo Gradiente'
            'Ret'#226'ngulo Arredondado'
            'Cubo')
        end
        object chbMarcas: TCheckBox
          Left = 557
          Top = 8
          Width = 58
          Height = 17
          Caption = 'Marcas'
          TabOrder = 4
          OnClick = chbMarcasClick
        end
      end
      object chtGrafico: TChart
        Left = 2
        Top = 274
        Width = 788
        Height = 337
        Legend.Visible = False
        Title.Font.Color = clBlack
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          'TChart')
        BottomAxis.LabelsAngle = 90
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMinimum = False
        Align = alClient
        TabOrder = 3
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
        object srsBarra_Cadastrados_APP: TBarSeries
          Active = False
          Marks.Brush.Gradient.Direction = gdTopBottom
          Marks.Brush.Gradient.EndColor = clGray
          Marks.Brush.Gradient.MidColor = clWhite
          Marks.Font.Color = 335544320
          Marks.Font.Height = -9
          Marks.Font.Name = 'Tahoma'
          Marks.Font.Style = [fsBold]
          Marks.RoundSize = 14
          Marks.Visible = False
          Marks.Style = smsValue
          Marks.Angle = 90
          Marks.BackColor = 16646143
          Marks.Color = 16646143
          PercentFormat = '##0 %'
          SeriesColor = clRed
          Title = 'Barra_Cadastrados_APP'
          ValueFormat = '#,###,###,#00'
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Bar'
          YValues.Order = loNone
        end
        object srsBarra_Novos_Cadastrados: TBarSeries
          Active = False
          Marks.Font.Style = [fsBold]
          Marks.Visible = False
          Marks.Style = smsValue
          Marks.Angle = 90
          PercentFormat = '##0 %'
          SeriesColor = clBlue
          Title = 'Barra_Novos_Cadastrados'
          ValueFormat = '#,###,###,#00'
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Bar'
          YValues.Order = loNone
        end
        object srsBarra_Clientes_Grazziotin: TBarSeries
          Active = False
          Marks.Font.Style = [fsBold]
          Marks.Visible = False
          Marks.Style = smsValue
          Marks.Angle = 90
          PercentFormat = '##0 %'
          SeriesColor = clYellow
          Title = 'Barra_Clientes_Grazziotin'
          ValueFormat = '###,###,###,#00'
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Bar'
          YValues.Order = loNone
        end
        object srsBarra_Novos_Clientes_Aprovados_APP: TBarSeries
          Active = False
          Marks.Font.Style = [fsBold]
          Marks.Visible = False
          Marks.Style = smsValue
          Marks.Angle = 90
          PercentFormat = '##0 %'
          SeriesColor = clGreen
          Title = 'Barra_Novos_Clientes_Aprovados_APP'
          ValueFormat = '#,###,###,#00'
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Bar'
          YValues.Order = loNone
        end
        object srsBarra_Total_Pagamentos_APP: TBarSeries
          Active = False
          Marks.Font.Style = [fsBold]
          Marks.Visible = False
          Marks.Style = smsValue
          Marks.Angle = 90
          PercentFormat = '##0 %'
          SeriesColor = 4227327
          Title = 'Barra_Total_Pagamentos_APP'
          ValueFormat = '#,###,###,#00'
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Bar'
          YValues.Order = loNone
        end
        object srsBarra_Parcelas_Pagas_CIA: TBarSeries
          Active = False
          Marks.Brush.Gradient.Direction = gdTopBottom
          Marks.Brush.Gradient.EndColor = clGray
          Marks.Brush.Gradient.MidColor = clWhite
          Marks.Font.Color = 335544320
          Marks.Font.Height = -8
          Marks.Font.Name = 'Tahoma'
          Marks.Font.Style = [fsBold]
          Marks.RoundSize = 14
          Marks.Visible = False
          Marks.Style = smsValue
          Marks.Angle = 90
          Marks.BackColor = 16646143
          Marks.Color = 16646143
          PercentFormat = '##0 %'
          SeriesColor = clFuchsia
          Title = 'Barra_Parcelas_Pagas_CIA'
          ValueFormat = '#,###,###,#00'
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Bar'
          YValues.Order = loNone
        end
        object srsLinha_Cadastrados_APP: TLineSeries
          Active = False
          Marks.Font.Style = [fsBold]
          Marks.Style = smsValue
          Marks.Angle = 90
          PercentFormat = '##0 %'
          SeriesColor = clRed
          Title = 'Linha_Cadastrados_APP'
          ValueFormat = '#,###,###,#00'
          Brush.BackColor = clDefault
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object srsLinha_Novos_Cadastrados: TLineSeries
          Active = False
          Marks.Font.Style = [fsBold]
          Marks.Style = smsValue
          Marks.Angle = 90
          PercentFormat = '##0 %'
          SeriesColor = clBlue
          Title = 'Linha_Novos_Cadastrados'
          ValueFormat = '#,###,###,#00'
          Brush.BackColor = clDefault
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object srsLinha_Clientes_Grazziotin: TLineSeries
          Active = False
          Marks.Font.Style = [fsBold]
          Marks.Style = smsValue
          Marks.Angle = 90
          PercentFormat = '##0 %'
          SeriesColor = clYellow
          Title = 'Linha_Clientes_Grazziotin'
          ValueFormat = '#,###,###,#00'
          Brush.BackColor = clDefault
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object srsLinha_Novos_Clientes_Aprovados_APP: TLineSeries
          Active = False
          Marks.Font.Style = [fsBold]
          Marks.Style = smsValue
          Marks.Angle = 90
          PercentFormat = '##0 %'
          SeriesColor = clGreen
          Title = 'Linha_Novos_Clientes_Aprovados_APP'
          ValueFormat = '#,###,###,#00'
          Brush.BackColor = clDefault
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object srsLinha_Total_Pagamentos_APP: TLineSeries
          Active = False
          Marks.Font.Style = [fsBold]
          Marks.Style = smsValue
          Marks.Angle = 90
          PercentFormat = '##0 %'
          SeriesColor = 4227327
          Title = 'Linha_Total_Pagamentos_APP'
          ValueFormat = '#,###,###,#00'
          Brush.BackColor = clDefault
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object srsLinha_Parcelas_Pagas_CIA: TLineSeries
          Active = False
          Marks.Font.Height = -9
          Marks.Font.Style = [fsBold]
          Marks.Style = smsValue
          Marks.Angle = 90
          PercentFormat = '##0 %'
          SeriesColor = clFuchsia
          Title = 'Linha_Parcelas_Pagas_CIA'
          ValueFormat = '#,###,###,#00'
          Brush.BackColor = clDefault
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object srsArea_Cadastrados_APP: TAreaSeries
          Active = False
          Marks.Font.Style = [fsBold]
          Marks.Style = smsValue
          Marks.Angle = 90
          PercentFormat = '##0 %'
          SeriesColor = clRed
          Title = 'Area_Cadastrados_APP'
          ValueFormat = '#,###,###,#00'
          AreaChartBrush.Color = clGray
          AreaChartBrush.BackColor = clDefault
          DrawArea = True
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object srsArea_Novos_Cadastrados: TAreaSeries
          Active = False
          Marks.Font.Style = [fsBold]
          Marks.Style = smsValue
          Marks.Angle = 90
          PercentFormat = '##0 %'
          SeriesColor = clBlue
          Title = 'Area_Novos_Cadastrados'
          ValueFormat = '#,###,###,#00'
          AreaChartBrush.Color = clGray
          AreaChartBrush.BackColor = clDefault
          DrawArea = True
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object srsArea_Clientes_Grazziotin: TAreaSeries
          Active = False
          Marks.Font.Style = [fsBold]
          Marks.Style = smsValue
          Marks.Angle = 90
          PercentFormat = '##0 %'
          SeriesColor = clYellow
          Title = 'Area_Clientes_Graziotin'
          ValueFormat = '#,###,###,#00'
          AreaChartBrush.Color = clGray
          AreaChartBrush.BackColor = clDefault
          DrawArea = True
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object srsArea_Novos_Clientes_Aprovados_APP: TAreaSeries
          Active = False
          Marks.Font.Style = [fsBold]
          Marks.Style = smsValue
          Marks.Angle = 90
          PercentFormat = '##0 %'
          SeriesColor = clGreen
          Title = 'Area_Novos_Clientes_Aprovados_APP'
          ValueFormat = '#,###,###,#00'
          AreaChartBrush.Color = clGray
          AreaChartBrush.BackColor = clDefault
          DrawArea = True
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object srsArea_Total_Pagamentos_APP: TAreaSeries
          Active = False
          Marks.Font.Style = [fsBold]
          Marks.Style = smsValue
          Marks.Angle = 90
          PercentFormat = '##0 %'
          SeriesColor = 4227327
          Title = 'Area_Total_Pagamentos_APP'
          ValueFormat = '#,###,###,#00'
          AreaChartBrush.Color = clGray
          AreaChartBrush.BackColor = clDefault
          DrawArea = True
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object srsArea_Parcelas_Pagas_CIA: TAreaSeries
          Active = False
          Marks.Font.Height = -9
          Marks.Font.Style = [fsBold]
          Marks.Style = smsValue
          Marks.Angle = 90
          PercentFormat = '##0 %'
          SeriesColor = clFuchsia
          Title = 'Area_Parcelas_Pagas_CIA'
          ValueFormat = '#,###,###,#00'
          AreaChartBrush.Color = clGray
          AreaChartBrush.BackColor = clDefault
          DrawArea = True
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
      end
    end
  end
  object qryRelatorioVendas: TFDQuery
    Active = True
    Connection = dtmRelatorioVendas.fdcRelatorioVendas
    Transaction = dtmRelatorioVendas.trsRelatorioVendas
    SQL.Strings = (
      
        'SELECT extract(MONTH FROM dta_mes)||'#39'/'#39'||extract(YEAR FROM dta_m' +
        'es) AS anomes,'
      
        '       QTD_TOT_CLI_APP,QTD_NEW_CLI_APP,QTD_CLI_GRAZZIOTIN,QTD_NE' +
        'W_CLI_APP_APROV,'
      
        '       tot_cli_pgto_app,qtd_parcelas_pgto_cia,vlr_parcelas_pgto_' +
        'cia'
      'FROM GRZW_REL_PGTOS_APPXLOJA'
      'WHERE (extract(YEAR FROM dta_mes) = :ano)'
      'ORDER BY DTA_MES')
    Left = 464
    Top = 8
    ParamData = <
      item
        Name = 'ANO'
        DataType = ftFloat
        ParamType = ptInput
        Value = 2020.000000000000000000
      end>
    object qryRelatorioVendasANOMES: TStringField
      FieldName = 'ANOMES'
      Origin = 'ANOMES'
      Size = 81
    end
    object qryRelatorioVendasQTD_TOT_CLI_APP: TBCDField
      FieldName = 'QTD_TOT_CLI_APP'
      Origin = 'QTD_TOT_CLI_APP'
      DisplayFormat = '###,###,###,##0'
      Precision = 8
      Size = 0
    end
    object qryRelatorioVendasQTD_NEW_CLI_APP: TBCDField
      FieldName = 'QTD_NEW_CLI_APP'
      Origin = 'QTD_NEW_CLI_APP'
      DisplayFormat = '###,###,###,##0'
      Precision = 8
      Size = 0
    end
    object qryRelatorioVendasQTD_CLI_GRAZZIOTIN: TBCDField
      FieldName = 'QTD_CLI_GRAZZIOTIN'
      Origin = 'QTD_CLI_GRAZZIOTIN'
      DisplayFormat = '###,###,###,##0'
      Precision = 8
      Size = 0
    end
    object qryRelatorioVendasQTD_NEW_CLI_APP_APROV: TBCDField
      FieldName = 'QTD_NEW_CLI_APP_APROV'
      Origin = 'QTD_NEW_CLI_APP_APROV'
      DisplayFormat = '###,###,###,##0'
      Precision = 8
      Size = 0
    end
    object qryRelatorioVendasTOT_CLI_PGTO_APP: TBCDField
      FieldName = 'TOT_CLI_PGTO_APP'
      Origin = 'TOT_CLI_PGTO_APP'
      DisplayFormat = '###,###,###,##0'
      Precision = 8
      Size = 0
    end
    object qryRelatorioVendasQTD_PARCELAS_PGTO_CIA: TBCDField
      FieldName = 'QTD_PARCELAS_PGTO_CIA'
      Origin = 'QTD_PARCELAS_PGTO_CIA'
      DisplayFormat = '###,###,###,##0'
      Precision = 8
      Size = 0
    end
    object qryRelatorioVendasVLR_PARCELAS_PGTO_CIA: TFMTBCDField
      FieldName = 'VLR_PARCELAS_PGTO_CIA'
      Origin = 'VLR_PARCELAS_PGTO_CIA'
      DisplayFormat = '###,###,###,##0.00'
      Precision = 18
      Size = 2
    end
  end
  object dtsAtualiza: TDataSource
    DataSet = qryRelatorioVendas
    Left = 520
    Top = 8
  end
  object rptRelatorio: TppReport
    AutoStop = False
    DataPipeline = pplRelatorio
    PrinterSetup.BinName = 'Default'
    PrinterSetup.DocumentName = 'Report'
    PrinterSetup.Orientation = poLandscape
    PrinterSetup.PaperName = 'A4 (210 x 297 mm)'
    PrinterSetup.PrinterName = 'Default'
    PrinterSetup.SaveDeviceSettings = False
    PrinterSetup.mmMarginBottom = 6350
    PrinterSetup.mmMarginLeft = 6350
    PrinterSetup.mmMarginRight = 6350
    PrinterSetup.mmMarginTop = 6350
    PrinterSetup.mmPaperHeight = 210000
    PrinterSetup.mmPaperWidth = 297000
    PrinterSetup.PaperSize = 9
    ArchiveFileName = '($MyDocuments)\ReportArchive.raf'
    DeviceType = 'Screen'
    DefaultFileDeviceType = 'PDF'
    EmailSettings.ReportFormat = 'PDF'
    LanguageID = 'Default'
    OpenFile = False
    OutlineSettings.CreateNode = True
    OutlineSettings.CreatePageNodes = True
    OutlineSettings.Enabled = True
    OutlineSettings.Visible = True
    ThumbnailSettings.Enabled = True
    ThumbnailSettings.Visible = True
    ThumbnailSettings.DeadSpace = 30
    ThumbnailSettings.PageHighlight.Width = 3
    ThumbnailSettings.ThumbnailSize = tsSmall
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
    PDFSettings.PDFAFormat = pafNone
    PreviewFormSettings.PageBorder.mmPadding = 0
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
    Left = 556
    Top = 339
    Version = '20.0'
    mmColumnWidth = 0
    DataPipelineName = 'pplRelatorio'
    object ppHeaderBand1: TppHeaderBand
      Background.Brush.Style = bsClear
      Border.mmPadding = 0
      mmBottomOffset = 0
      mmHeight = 24606
      mmPrintPosition = 0
      object lblRelEmissao: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelEmissao'
        Border.mmPadding = 0
        Caption = 'lblRelEmissao'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        FormFieldSettings.FormSubmitInfo.SubmitMethod = fstPost
        FormFieldSettings.FormFieldType = fftNone
        Transparent = True
        mmHeight = 3969
        mmLeft = 38894
        mmTop = 15610
        mmWidth = 21696
        BandType = 0
        LayerName = Foreground
      end
      object lblRelPagina: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelPagina'
        Border.mmPadding = 0
        Caption = 'P'#225'gina'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        FormFieldSettings.FormSubmitInfo.SubmitMethod = fstPost
        FormFieldSettings.FormFieldType = fftNone
        Transparent = True
        mmHeight = 3969
        mmLeft = 263450
        mmTop = 262
        mmWidth = 10319
        BandType = 0
        LayerName = Foreground
      end
      object stvRelNumeroPagina: TppSystemVariable
        DesignLayer = ppDesignLayer1
        UserName = 'stvRelNumeroPagina'
        AutoSize = False
        Border.mmPadding = 0
        VarType = vtPageNo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3968
        mmLeft = 275340
        mmTop = 265
        mmWidth = 9260
        BandType = 0
        LayerName = Foreground
      end
      object lblRelCabMesAno: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelCabMesAno'
        Border.mmPadding = 0
        Caption = 'M'#234's/Ano'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        FormFieldSettings.FormSubmitInfo.SubmitMethod = fstPost
        FormFieldSettings.FormFieldType = fftNone
        Transparent = True
        mmHeight = 3969
        mmLeft = 245
        mmTop = 20638
        mmWidth = 12436
        BandType = 0
        LayerName = Foreground
      end
      object lblRelCabNovosCadastros: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelCabNovosCadastros'
        Border.mmPadding = 0
        Caption = 'Novos Cadastros'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        FormFieldSettings.FormSubmitInfo.SubmitMethod = fstPost
        FormFieldSettings.FormFieldType = fftNone
        Transparent = True
        mmHeight = 3969
        mmLeft = 41540
        mmTop = 20638
        mmWidth = 25400
        BandType = 0
        LayerName = Foreground
      end
      object lblRelCabCadastradosAPP: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelCabCadastradosAPP'
        Border.mmPadding = 0
        Caption = 'Cadastrados APP'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        FormFieldSettings.FormSubmitInfo.SubmitMethod = fstPost
        FormFieldSettings.FormFieldType = fftNone
        Transparent = True
        mmHeight = 3969
        mmLeft = 14284
        mmTop = 20638
        mmWidth = 25929
        BandType = 0
        LayerName = Foreground
      end
      object lblRelCabClientesGrazziotin: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelCabClientesGrazziotin'
        Border.mmPadding = 0
        Caption = 'Clientes Grazziotin'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        FormFieldSettings.FormSubmitInfo.SubmitMethod = fstPost
        FormFieldSettings.FormFieldType = fftNone
        Transparent = True
        mmHeight = 3968
        mmLeft = 68243
        mmTop = 20638
        mmWidth = 26987
        BandType = 0
        LayerName = Foreground
      end
      object lblRelCabValorPagoCIA: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelCabValorPagoCIA'
        AutoSize = False
        Border.mmPadding = 0
        Caption = 'Valor Pago CIA'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        FormFieldSettings.FormSubmitInfo.SubmitMethod = fstPost
        FormFieldSettings.FormFieldType = fftNone
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3969
        mmLeft = 193142
        mmTop = 20638
        mmWidth = 24081
        BandType = 0
        LayerName = Foreground
      end
      object lblRelCabClientesAprovados: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelCabClientesAprovados'
        Border.mmPadding = 0
        Caption = 'Clientes Aprovados'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        FormFieldSettings.FormSubmitInfo.SubmitMethod = fstPost
        FormFieldSettings.FormFieldType = fftNone
        Transparent = True
        mmHeight = 3968
        mmLeft = 96803
        mmTop = 20638
        mmWidth = 28311
        BandType = 0
        LayerName = Foreground
      end
      object lblRelCabParcelasPagasCIA: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelCabParcelasPagasCIA'
        Border.mmPadding = 0
        Caption = 'Parcelas Pagas CIA'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        FormFieldSettings.FormSubmitInfo.SubmitMethod = fstPost
        FormFieldSettings.FormFieldType = fftNone
        Transparent = True
        mmHeight = 3969
        mmLeft = 162711
        mmTop = 20638
        mmWidth = 29104
        BandType = 0
        LayerName = Foreground
      end
      object lblRelCabPagamentosPeloAPP: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelCabPagamentosPeloAPP'
        Border.mmPadding = 0
        Caption = 'Pagamento(s) pelo APP'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        FormFieldSettings.FormSubmitInfo.SubmitMethod = fstPost
        FormFieldSettings.FormFieldType = fftNone
        Transparent = True
        mmHeight = 3969
        mmLeft = 126471
        mmTop = 20638
        mmWidth = 34925
        BandType = 0
        LayerName = Foreground
      end
      object imgRelLogo: TppImage
        DesignLayer = ppDesignLayer1
        UserName = 'imgRelLogo'
        AlignHorizontal = ahCenter
        AlignVertical = avCenter
        MaintainAspectRatio = False
        Stretch = True
        Border.mmPadding = 0
        Picture.Data = {
          0A544A504547496D616765F92A0000FFD8FFE000104A46494600010101006000
          600000FFDB004300020101020101020202020202020203050303030303060404
          0305070607070706070708090B0908080A0807070A0D0A0A0B0C0C0C0C07090E
          0F0D0C0E0B0C0C0CFFDB004301020202030303060303060C0807080C0C0C0C0C
          0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
          0C0C0C0C0C0C0C0C0C0C0C0C0CFFC0001108009F014B03012200021101031101
          FFC4001F0000010501010101010100000000000000000102030405060708090A
          0BFFC400B5100002010303020403050504040000017D01020300041105122131
          410613516107227114328191A1082342B1C11552D1F02433627282090A161718
          191A25262728292A3435363738393A434445464748494A535455565758595A63
          6465666768696A737475767778797A838485868788898A92939495969798999A
          A2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6
          D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F01000301
          01010101010101010000000000000102030405060708090A0BFFC400B5110002
          0102040403040705040400010277000102031104052131061241510761711322
          328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728
          292A35363738393A434445464748494A535455565758595A636465666768696A
          737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7
          A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3
          E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00FA92
          98E79A7D464E4D739D0145148E702A5EE0309C9A28A29B011CF14CA573CD250B
          44014C7FBD4FA8C9CD2401484E052D35CF147501B4C6396A7D4754520ACFF12F
          89ACFC27A53DE5ECBE542BC0E3258F6007735A15E5BFB4E48C34FD2172769925
          24762405C7F33F9D7262EB3A54A551743EB381787E96799F61F2BAF2718546EE
          D6F68C5C9DBCDDAC5B6FDA3F47078B4D431DBE55FF00E2A8FF008690D23FE7D3
          50FF00BE57FF008AAF16A2BE77FB5F11DD7DC7F5CFFC407E13FF009F73FF00C0
          D9ED0DFB47E907FE5D2FFF00EF95FF00E2A9BFF0D1BA47FCFA5FFF00DF2BFF00
          C5578CD147F6BE23BAFB83FE203F09FF00CFB9FF00E06CF66FF868DD23FE7D2F
          FF00EF95FF00E2A90FED13A413FF001EB7FF00F7CAFF00F155E35451FDAD88EE
          BEE0FF00880FC27FF3EE7FF81B3E90F0A78C6C7C6761F68B293705387461878C
          FB8AD37385AF2BFD9CB4AB85B9D42F4822D990423D1DB39FD07F3AECFE2578C1
          7C23E1F6653FE953E5211EFDDBF0FF000AFA7CAD55C5A824BDE91FC73E2E61B2
          AE0FCC318955BE1E82E66DD9B5A27CBE72BBE55DDD96E725F14FE26DC5BEA6DA
          7E9B398843C4D2A1E4B7F741F6A6FC26F8837F7DAEAD85E4CF751CCA4A339CB2
          11CF5EE2BCF5DCC8E598E598E493DCD749F08BFE47BB4FA3FF00E826BF4DC4E5
          587A397CE9F2A6D45BBF5BDB73FCE6C87C4ACF735E38C363655E51855AD18F22
          93E4509492E5E5D9E9D6DBFBDB9ED0E7269283D68AFCD0FEF8027151D39CFCB4
          D271400C7396A4A28AB7B14F6109C0A6539CF14DA1020A6C94EA639CB525B896
          E25145213814307B8C27268A28A91BD847385A653A4A6D035B1E86C702994E90
          D36B42029AE69D519393528028A2918E050F70184E4D14514D808E70B4CA739A
          6D0B600A639C9A7D464E4D24035CF14DA573CD25515B20AF2BFDA70E6D747FF7
          E5FE495EA84E2BCA7F69AFF8F4D23FDF97F92579D98FFBB4BE5F9A3F4DF06BFE
          4B1C17ACFF00F4DCCF25A28A2BE40FEFD0A28A2800ABBE1FD0E7F126B36F656E
          BBA49DC2FF00BA3B93EC0552AF64F815E06FEC6D24EA97098B8BD5FDD023948F
          FF00AFD7E98AEBC1E19D7A9CBD3A9F0BE21F18D2E1BC9AA639D9D47EED35DE4F
          6F92DDFA5BA9D8689A4DB7847C3F15B2111C1691FCCC78F72C7F535E2DE3FF00
          16378BFC4324E33E427C90A9ECA3BFE3D6BB6F8DDE34FB2DB0D2607FDE4A034E
          41FBABD97F1AF2EAFDB785B2B54A9FD6A6B57A2F25FF0007F23FC27FA47788F5
          733CC1E4546A73284B9AB4AFF1547AD9FF0086F77FDE7DE215D2FC2438F1D5A7
          D1FF00F4135CD5749F097FE47AB4FA37FE826BE8B33FF74ABFE17F91F86F87FF
          00F253E5FF00F5FA9FFE968F68A28A2BF213FD381AE698C70B4AC7269AE69A1A
          1B45145390E431FAD2504E4D14FA074027151D3D8E1699420414D73C53A98E79
          A912D5894514138A40C639CB525145056C7A031C9A28A2AD90231C0A6539CD36
          85B005364A7546C72692DC028A2918E050F70184E4D14514DEC0231C0A653A4A
          639F9685B00C27268A28A194C463815E55FB4CFF00C79E8FFEFCBFC92BD4DCF3
          5E59FB4CFF00C79E8FFEFCBFC92B8332FF007597CBF347E9DE0D7FC96182F59F
          FE9B99E4B451457C79FDF814514FB781EEA748A352F248C1555464B13D00A64C
          A4A29CA5A24745F0B3C14DE33F12A2BAFF00A1DB6249CF623B2FE3FE35EDBE27
          D7E0F096812DD4980B12ED8D3FBCDD80AA7F0EFC1EBE09F0D456DC79EFFBC9D8
          7773FE1D2BCE3E2F78CFFE123D73ECB0BEEB4B2254107877EE7FA57E89C31923
          AB354E5B6F2FF23FCBEFA53F8E11A50AB8DC3CAEA37A7878F77D6A5BB7DAF451
          8BD59CBEA7A8CBABEA12DCCCDBA5998B31A828A2BF618A515CAB63FC93AD5AA5
          6A92AB55DE526DB6F76DEED85749F097FE47AB4FA37FE826B9BAE93E12FF00C8
          F569F46FFD04D71E67FEE957FC2FF23EAFC3EFF929F2FF00FAFD4FFF004B47B4
          5213814B4D73C57E427FA703698DF7A9C4E0532A91482918E052D35CF1475175
          1B45145121C86B9A6D2B7DEA4A7D03A05464E4D3D8E0532A0105231C2D2D35CF
          340B76368A28A06CF40A28A463F2D53DC918C7268A28A6F60118FCB4CA739A6D
          0B600A6B9E69D51939349005145231C0A1EE0309C9A6B9A75464E4D50D051452
          39C2D4BDC1EE309C9AF2DFDA67FE3CF47FF7E5FE495EA55E5BFB4CFF00C79E8F
          FEFCBFC92B8B33FF007697F5D51FA87839FF00258E0BD67FFA6E6792D14515F1
          C7F7D857A57C04F03FDAAE8EB3709FBB8894B6C8FBCDD0B7E1D3EB9AE27C1FE1
          99BC5FE20B7B1841FDE365DBFE79A0EA4D7D071C76BE14D0428DB0DA5945FF00
          7CA815ED64F83756A7B46B45B7A9FCFBE3CF1F4329CB5E51427CB52AA6E6EF6E
          5A7D6FDB9B55FE152F2303E2D78CC7867413044F8BCBC055307945EEDFD2BC5F
          35A7E2FF001249E2BD7A6BC933863B635FEE28E82B32BF78C9F2E584C3A8BF89
          EAFF00CBE47F835E2B71D4F89F3B9E229BFDC53F769AFEEF597AC9EBE965D028
          A28AF58FCC82BA4F84BFF23D5A7D1BFF004135CDD749F097FE47AB4FA37FE826
          B8733FF74ABFE17F91F61E1F7FC94F97FF00D7EA7FFA5A3DA298E7E6A7938A8C
          9CD7E427FA7035CF14DA573934957B22B6414C63934F27151939A48105213814
          B4D73C51D45D46D14514D8D8D73C536958E5A92A036414C63F35389C0A650082
          8A28A0967A0535CD3AA32726A9005145239C0A1EE0309C9A28A29BD80463F2D3
          295CF34942D80298E79A7D464E4D240231C0A652B9E692A8A5A20A6B9A75464E
          4D4A120AF2DFDA67FE3CF47FF7E5FE495EA55E5BFB4CFF00C79E8FFEFCBFC92B
          8733FF007697F5D4FD3FC1CFF92CB05EB3FF00D3733C968A2BB3F82FE05FF84A
          BC43F699933656243B6470EFD97FA9AF94A34A5566A11DD9FDC5C439EE1B26CB
          AAE658B7685357F57D12F36F4477FF0005FC0FFF0008B7877ED53A62F2FC066C
          8E513AAAFF0053587F1C3C67E6CA34881B8421EE08F5EA17FAD775E39F120F0A
          F86EE2EFABA0DB18F563C0AF03BAB97BCB9796462F248C5998F726BF60E12CA2
          3FC67F0C36F5EFFD753FC55FA5378B58BC4CE780E6FDFE2FDEA9FDDA5B282F5B
          72FF00853EE47451457E867F078514514005749F097FE47AB4FA37FE826B9BAE
          93E12FFC8F569F46FF00D04D70E67FEE957FC2FF0023EC3C3EFF00929F2FFF00
          AFD4FF00F4B47B3B9E2994AE7269AE702BF223FD38194514553298D73C53695C
          F34946C836414C73934FA8E92041413814535CF149EE2DD8DA28A290D8D7E94D
          A5739349406C82985B9A713814CA048F4273814DA573934956B4420A639E69F5
          1D24014514D738146EC06939345145360239C2D3295CE4D35CE0508061393451
          450CA6231C0A652B9E6928D906C82BCCBF695B3926D274C995498E195D5D87F0
          96031FC8D7A6938AAD7D630EA76CF0DC449344E30C8E320D7362287B6A4E9F73
          E9B833887FB0B3AA19B3873AA6DDD6D74D38BF9D9BB799F32695A64DAD6A30DA
          DBA19269DC22A8F535F45F837C311783FC3D058C58FDD8CBB7F7D8F534687E09
          D2BC377065B2B182095B82EA39C7A66B51CE057260301EC2EE5AB67DDF8A5E29
          BE28F6785C24254E8435B3B5E52EEED7564B6D7AB66478CFC34BE2EF0FCD66CD
          B19F0C8DFDD61C8AF2A9BE0BEBD1CA42DBC3200786599707F320D7B4D15F5581
          CEB118383852B34FBFF48FE52E38F09F22E28C4C3199873C6A4572DE124AEB56
          93BC64B4BBB6899E267E0DEBE3FE5D23FF00BFE9FE347FC29CD7FF00E7D63FFB
          FC9FE35ED2E79A4AEFFF005AF196DA3F73FF0033E27FE25AF85ADFC5AFFF0081
          C3FF00959E2FFF000A735FFF009F58FF00EFF27F8D21F83DAF0FF9758FFEFF00
          27F8D7B4D464E697FAD98CED1FB9FF00993FF12D9C2DFF003F6BFF00E070FF00
          E5678D7FC29FD7BFE7D63FFBFC9FE35D47C34F86175E1FD53EDF7E511D1488E2
          56DDD7B93D2BBDA6B9C0AE7C571262EBD274A5649F65FF0004F6B87BC08E1ACA
          330A7995175273A6EF153926935B3B4631DB75ADBC8693934C73CD3C9C5464E4
          D7848FDA50504E28A473814750EA328A28A6C6C6B9C0A6D2B9F9A928D906C829
          8E7269E4E0547500828A29AE78A05BB1B4514503635CF14DA573934940D6C7A0
          575BF08FE08F887E366B9F62D0ECFCC5423CEB990EC82DC7AB37F41927D2B2FE
          1E781EEFE2478D74ED12C47FA46A332C4091C20EEC7D80C9AFD24F85BF0CB4AF
          843E0BB4D1B4A856282D9079921037CEFF00C5239EE49FF0E82B651B994A563C
          4BC07FF04DFF000EE956E8FE20D52FB56B8C02E907EE2107DBAB1FCFF0AEFACB
          F62FF86B670EC3E19826FF006A49E527F4615E7DF1FF00FE0A0367E08D56E349
          F0A5B41AADEDBB18E5BC989FB346E38214020BE0F7C815F3F7883F6CDF893E22
          9D99BC4B716A8D9C476914702A0F405573F9926AAF144DA4CFB12E7F632F86B7
          316DFF008462DA3FF6927941FF00D0ABCA3F69BFD8C3C19E06F84FAC6BFA4477
          F6779A7C62544FB4178DBE603041AF03B3FDABBE2369EDB93C5DAB939CFEF1C4
          83F2606AC78B3F6BFF001EF8EBC1977A16AFAB437B657AA1252D671248541CE3
          2AA3FC697345F41DA479A4109B99D235FBCEC147D4D7D0FF0010347F0F7C04D5
          74AF0AE99E03B3F17EBAFA6C7797F737DE6CAC59C12551108C000673EFED5F3C
          DBCE6DA74917EF46C187D457D1BE33F1168DF1AB5CD2BC63A17C44B4F0578822
          D312CEFE0BA9A4B695190104A3AE370607A027A7BE2A16A3663FECF7E09D23E2
          1FC6EF157F6F783EDECADAD3C3F3EA30690DE6C71C5223C2148C90FCE5BBFF00
          15247E17F0D7C5AF81BE32D5D3C171784750F0CC51DC5BDC5B4D314B8C9C18D8
          484FE9EA2BBE9FF685F0AC3FB5878B7C436DAF5AAD8CBE137B2B5BB2ADB24B90
          D13045C8E4FCA7B60E2BCE758F8FAFF19BF663D5748F10EBEB6FE22D26F16EAD
          D48F246AD09EB1B2A00ACCA72464761F5ABD015F739EFDA7BC01A4781AC3C08F
          A559259B6ABE1F86EEECAB31F3A524E5CE49E7E95D8DA7C1EF0DCB2FC0FCE971
          7FC54E57FB53E77FF4CF9C0F9B9E38F4C545E2D5F0AFED21E02F07CBFF00098E
          91E1AD5FC3BA68D36F2D7530C8AC14E55D1BA1EFFA55BF10FC5CF0A699F173E1
          3E95A6EB0977A2781FC98AEF52646485DF702EE32338E3E9CF153D435367C23E
          0AF04FC4BF8EDAD780DFE1EDAE9B696EF710C7AA5A5CCFE6C463E8C77315E6B9
          2B7F0B785BE017C09D23C47A9E8165E2CD73C497B3C5682EE4716B0C313152E1
          54827271FF007D7B7395F19FF6BCF18EAFE30F10D8E93E25C6833DCCB1C06D6D
          6185A4849207EF15048411EAD9357F43D6BC33F1CBF67AF0FF0085353F125978
          635EF0ADCCA6D9EFD585BDCC321C91BC700E71D4F6A6DA0D4A7F14BC2BE1BF88
          5FB3A5B78FF41D121F0E5F59EA874BD46CEDE46681C950CAEA1892382BF99AF1
          0AF70F8A9E29F0DFC39FD9D6DFE1FE87AE5B7892FEF3543AA6A3796A8C2DE3C2
          855456239E02F4F435E1F52F42E3A20A639C9A713814CA943414138A29AE7028
          DD8B76368A28A18D8D73814DA573934952496348D22EB5FD462B3B2B79AEEEA7
          3B6386142EEE7AF00735A5E24F865E22F09D87DAB53D1354B0B6DC13CD9ED991
          327A0C915E8DFB09F88B4FF0CFED27A35C6A5756F650347344B2CEC1103B210A
          371E067A735F51FEDEDF10F40BFF00D9B356B58359D2EE6E6E6681218A1B9491
          DD84809C0049E809FC2AD46EAE4B7AD8FCF773C53295CE4D251B234D90531CF3
          4F2702A3A48482827028AE83E12E896DE26F8A7E1BD3AF63F36D2FF53B7B79D3
          246F4695430C8F6346EC1EE737457E95FC7CFD98FE1FDBFC0EF154B6DE10D06C
          AE2C748B9BA82E2D6CD219A3922899D487501BAA8CF3CF39AFCD4AA9AB0B9AEB
          411CF15B327C32F11C3A71BB6D0B575B509E6194DA3EC0B8CEECE318C5645BB0
          5BB8C9E81867DB9AFD6DD7BC7FE1C5F05DDDD36B1A47F67FD8DA4DFF00698CC6
          63D84E7AF4C5108DC1CB94FC8DA639C9A96E18199C8E9B89150D66520A09C0A2
          9AE702816EC6D145140D9F677FC136FC16BAC7C4BD675A91772E8D66B14648FB
          B24C4807FEF9471F8D7B8FEDB7F16E6F857F05A75B190C5A96B720B181C1E625
          20991C7BED181E8581ED5C3FFC1336C963F01F89AE38DF2DFC719E3B2C791FFA
          19AC1FF829CEA4E6F3C2B67CF96A93CD8F72547F4AE85F098EF23E522726B77E
          1C7C39D57E2B78BADF44D1A149EFEE43322BB8450154B1249E9C0AC2AF40FD98
          FE2BD87C17F8BF63AF6A70DD4F650452C722DBA86906F42A0804807923B8ACBA
          D8B3AD7FF827C7C463FF002EBA5FFE06AD34FF00C13DFE2301FF001E9A5FFE07
          257BB7FC3C9BC05FF3E1E28FFC0487FF008ED7BA785FC45078B7C3763AA5B2C8
          B6FA840971189000E158023201233CFAD6AA31E867CD247E5AF88BC317BE15F1
          35E6917B0F977F6370D6D3460EEC48A769008E0F35E997FF00B0E7C42B1F0AC9
          AC3E9B6BE4456E6E5A2174BE7040371F97D71DAB13E3D9C7ED33E26FFB0F4BFF
          00A38D7E8CCFA72EB1E197B472552EAD4C2C475019307F9D4C229DCA72B1F961
          E1DF09EA7E32D456CF4AB0BBD46E5BFE59DBC45C8FAE3A7E35E9FA0FEC23F12B
          5E8049FD8B159A919C5CDD246C3F0CE6BED1B1B5F027ECADE05488CBA7681A7C
          6399253FBEBA6EE4E3E7918FB03EC315E73AEFFC1497C07A6DCB47696BAF6A21
          7A4A96EB1A37D37B06FCC53E54B70E77D0F8CFE20FC32D57E19F8E26F0F6A714
          635281914AC4E1D58B005707F115EAFA1FFC139BE216B11ABCFF00D8BA70719C
          4F765881EFB15AB87F8EFF00186D7E28FC6FB9F14D9DACF05B3CB0BA43311BC8
          8C28E7191CE2BE86D4FF00E0A85A5C102AD8F85AFA57DA399EE95003F400D4C5
          46E57BDD0E3E3FF826078ACA0DDE21F0F06C72009881F8ECAE7BC67FF04ECF88
          1E16B5926B51A56B48809DB67391211FEEBAAE4FB0CD771FF0F46BDF3FFE454B
          5F2BD3ED6DBBF957BA7ECDBFB5268FFB46D85E0B4B69B4ED4B4E0AD71692B06F
          95B387561D46463A71C7A8AAB41B26F2DD9F9BDAA69773A26A335A5E412DB5D5
          BB94962954ABC6C3A820D775F01BF66BF107ED1136A6BA1C96110D2444676BA9
          4A0FDE6FDA060127EE37E55F40FF00C14D3E13DAA69BA578C2DA148AE8CA2C6F
          1D571E702098CB7A918233E9F415E37FB297ED4BFF000CD336BBBB48FED54D68
          419026F2CC462F331D8E73E61FC854B493B32F9AEB43A86FF8267F8F88FF008F
          DF0E7FE04C9FFC6E93FE1D9BE3FF00F9FDF0DFFE0549FF00C6EBB9FF0087A7C3
          FF0042849FF81C3FF88AF43FD9C7F6C8BDFDA27C64FA759F8524B3B3B58CCB75
          78D75B9201FC231B46493D07B1F4AB4A3D09BCD23C08FF00C1337C7E07FC7EF8
          73FF0002A4FF00E375F3F6BFA3CDE1ED72EEC2E368B8B299E09029C8DCA48383
          F515FABDE3AF1B69FF000EBC257DAD6A932C163A7C4659189EB8E807A927803D
          4D7E53F8BF5CFF00849FC57A9EA21760BFBA96E02FF777B16C7EB5328A5B0E9B
          6CF52F86BFB0D78DFE2A782ECB5ED34694B637EA5E2F3AE76B9009192307D2B7
          BFE1DAFF00117D742FFC0C3FFC4D6C7C0FFF00828527C22F861A5F8764F0D35E
          9D363318996EF66F1B89E9B4FAD756DFF0555847FCC9F2FF00E070FF00E228F7
          1EE4B72B9E73FF000ED5F88DEBA17FE061FF00E26B0BE257EC2DE38F857E0ABE
          D7B521A5358E9EA1E6F26EB7380481C0C0F5AFB7FF00673F8C7A87C74F041D7A
          EB416D0ECE690A598927F31EE54757C606173C0F5C1ED8CF07FF00050BF8B1A6
          F82FE06DDE852C81F55F11ED86DE053CAA2B06791BD140181EA48F7C3708DAE2
          E677B1F0AFC31F86DA97C5EF1CD8787B48111BED4188432B6D4400166663CF00
          027A57A27C5FFD863C67F05FC0F71AFEA32E91736368CA2616B3B33A0638DD86
          51C671F9D2FEC0473FB54F87BFDCB9FF00D10F5F61FEDD9FF26BDE25FF00723F
          FD18B5318A6AECA6F5B1F9A35DFF00C1FF00D98FC67F1C57CDD0B4977B20DB4D
          E4EDE54008EB863D71ED9A4FD99BE0E37C76F8C9A56804B259BB1B8BD917FE59
          C0832DF89E147BB0AFD2DD6356D07E097C3B92E67F234AD0B43B61C22F11A28C
          05503A93C003A9269A8DF71CE56D11F195A7FC12BBC653DB0337883C370C87AA
          2B4CF8FC760AE73C77FF0004DCF88BE0FB27B8B54D2F5E8D01256C676F331FEE
          BAA927D866BD475FFF0082AE5B45AA48BA6784E696CD4E11EE2E8248E3D4A804
          0FA64D7AEFECC9FB66683FB47CF3D8476D3691ADDB279A6D2670E264E8591863
          383D4632323AD5251D91379AD4FCD9D4F4CB9D17509AD2EE096DAE6DD8A4B14A
          855E361D4107A57D09F017F619F8823C5BE11F13C963650E9A9776BA83092ED4
          4A220EAF9DBEBB79C57ADFFC14A3F67AB3D6FC15FF0009CE9D6EB16A9A5958EF
          CA0C7DAA027018FF00B4A48E7D09F4155BE077FC14834DD513C2BE17B8F0DDEA
          DF4C6DB4C69E3B85F2831DB187C119C7438A95149EA3BB6AE8FA4FE2BF87AE7C
          5DF0B7C4BA4D9856BBD4F4ABAB480336D532490B22E4F61922BE083FF04D7F89
          F8FF008F3D27FF0003D2BF40FC6FE284F04782F57D6A589A78F48B29AF5E3538
          690471B39507D4EDAF985BFE0AC3E1F5FF00994F57FF00C0A8FF00C2AE6A3D48
          8DFA1F157897C27A8784BC5579A2DFDBB43A958DC35ACD0F52B2038238EBCD7A
          75EFEC25F13F4FD064D465F0E9582184CEE3ED11F98AA064FCB9CE71DAB91F15
          78F0FC4EF8EB71E216805A9D6357175E486DDE586901033DEBF557C65FF2286A
          BFF5E737FE806B3841334949AB23F24BC03F0EF58F8A5E2BB6D0F43B27BED4AE
          B3B225206028C9249E0003B9AE9BE29FECB1E38F835A65B5E6BDA335BDBDE4C2
          DE268E55977487A2E149393DABBEFF00826E1CFED5B69FF5E377FF00A057E827
          8CEFB44D134AFED4D79F4FB7B3D31BCF17179B425BB608DC0B743C91C73CD118
          26AE273B3B1F9C7F0E7F601F895F116C92E97498B48B690655F5297C9247FB98
          2DFA574DAFFF00C12DFE2369562D35BDD7873527033E4DBDDC8AE7DBE78D47EB
          5ED7F117FE0A9BE10F0DEA325BE83A4EA5E20119DBF692C2DA17F75DC0B11F55
          15DBFECB7FB6C68BFB4C6A577A647A7DC68FABDA45E7F912C824599338255863
          A123231DE9A8C36173496A7E6F78CBC15AAFC3DF115C695ACD8CFA7EA16C7124
          332E187A1F707D4565D7DF5FF054AF85369AE7C28B1F15C70A2EA5A25CAC124A
          07324129C6D3EB87DA47A65BD6BE05ACE4ACEC5277D4FD04FF008265EA2B2F82
          7C516BC6F86FA294FD1E3207FE806B1FFE0A73A5B097C2B7B83B089E0CFB8DAD
          FD6B98FF008272F8E9740F8B3A8E8D2BED8F5CB3F9013F7A5889651FF7CB495E
          FF00FB69FC2597E2BFC14BA167199352D19C5FDB201CCA1410E83DCA9247A951
          5B2D6046D23F3DE9AE78A7302A707823820F6A8C9C9AC56ACD02BF4FFE087FC9
          1DF0C7FD832DFF00F458AFCC0AFD3FF821FF002477C31FF60CB7FF00D162B5A7
          B99CCFCFEF8F87FE3273C4DFF61E97FF0046D7E9269DFF0020F83FEB9AFF002A
          FCDAF8F5FF002739E27FFB0F4DFF00A38D7E92E9DFF20F83FEB9AFF2AA87514F
          A1F993F1FBE2BDF7C60F8A1AA6AB753BC96FF6878ECE327E58610C42003E8013
          EA49AE2E8A42702B07B9B3EC35F96AF4DF027EC77F10BE20D9C77369A04D6D6D
          280C92DE30B70E0F4203738F7C5779FF0004EAF83765F107E216A5AE6A50A5C5
          B7871223044EB9569E42DB58FAED08C7EA457D45FB4A7ED1DA7FECE5E1282F6E
          2D64D42FAFE4315A5AA3840E40CB33373851C7404E48FA8D1455AEC994ADEEA3
          E4F5FF008271FC4323FE60C3DBED7D3F4AF53FD8CFF655F19FC08F8C175A96B3
          1D90D3AE74D96D4BC17024DCC6489978EBFC26B8AB8FF82A1789FCD3E5F87341
          54CFCA19A5240F73B857A77ECA1FB6AEADFB407C469742D4346D3AC825949762
          6B677E4AB20C6189FEF7AF6A71E5E84BE6B1ABFF00051750DFB374F91D350B72
          3DBEF57E7EB1C0AFD03FF828B7FC9B6DC7FD842DFF009B57E7DB7CCD8A99FC43
          A668F837C237FE3DF14D8E8FA640D737FA84A2286351D49EA4FB01924F600D7E
          98FECF9F04B4FF0080BF0E2D346B3547B9204B7B7217E6B9988E58FB0E807602
          BCAFF609FD98CFC31F0C0F14EB36FB35ED5E2FDC4722FCD676E791F466E09F41
          81EB50FEDF7FB4E0F875E1A3E12D1AE71ADEAD11FB5C91B7CD6701E3AF667E40
          F4193E956B4576293E676478BFEDE3FB4EFF00C2D8F167FC239A3DD6EF0F68F2
          1F31A36F92F671C16CF755E83B7535F3CD04E68ACDBEA6BB2B057A87EC9BFB39
          DCFED0BF11E38240F1685A732CDA8CE0754CF112FF00B4D8C7B0C9ED83C27823
          C15A8FC45F15D8E8BA5406E2FF0050944512F619EA49EC00E49F6AFD35F80FF0
          5F4CF801F0DEDB45B2219A35F36F2E9860DCCA47CCE7D07A0EC05108DD99C9D8
          D2F18F8B344F81FF000E27D42EFCBB1D2346B70A91A0C700616341DC9E00AFCC
          BF8E1F18752F8E1F10AFB5ED44ED33B6DB7801CADB443EEA0FA0EA7B9C9AF52F
          DBABF69F6F8C9E346D0B4994FF00C237A2C854329E2FA61C3487FD91C85FC4F7
          E3E7F7344E57D10A2ADA9EC9FB007FC9D4787BFDCB9FFD10F5F627EDD9FF0026
          BDE25FF723FF00D18B5F1DFEC01FF2751E1EFF0072E7FF00443D7D89FB767FC9
          AF7897FDC8FF00F462D5C3E1627F123C03FE0951A224FE39F156A0CBF3DB5945
          0237B3B92C3FF1C5AF42FF0082A3F8965D2BE0C693611B10BA96A40480775446
          6FE78AE27FE094578A35DF18C1FC660B671EE3738AE9BFE0AB167249F0CFC333
          8198E3D4D958FA131363F950BE01EF33E1AAF45FD927C4D3F853F693F064F033
          29B8D561B2703F8926611303F83FE95E755D97ECEDA636B1F1F7C156E14B799A
          E59EE03A8513A163F8004FE159F53491FA61F1EF434F127C13F1559BAEF12E97
          7040C6725632C3F502BF31BE0271F1C3C1FF00F619B4FF00D1C95FA8BF172F97
          4DF853E259DB188B4BB96E4F07F74D8AFCBAF80C73F1C7C21FF61AB4FF00D1C9
          5ACC8A7B33F4E7E3F7FC908F1AFF00D806FBFF0049E4AFC9563935FAD5F1FF00
          FE483F8DBFEC017DFF00A4F257E4AD4D50A468784FFE46AD33FEBEE2FF00D0C5
          7EBAF8CCE3C1FAAFFD79CDFF00A01AFC8AF09FFC8D5A67FD7DC5FF00A18AFD75
          F19FFC89FAB7FD79CDFF00A01A74855373F3DBFE09B5FF00275969FF005E377F
          FA057D4BFF00051EFF00935AD53FEBEEDFFF0043AF96BFE09B5FF275969FF5E3
          77FF00A057D4BFF051EFF935AD53FEBEEDFF00F43A50F8584FE23F361CD7BBFF
          00C136E668BF6A8D2C2B1024B3B956C7F10D99C7E60578313935EEFF00F04DFF
          00F93A9D27FEBD6E7FF459ACE3B9A4BE13EBBFF8287FFC9A97883FEBA5BFFE8D
          5AFCCA2C735FA69FF0510FF9351F107FD74B7FFD1AB5F995555372696C7A9F83
          7C5B79E05F15586B160FB2EF4F99668CF6241E87D8F4FC6BF48FE0B7C61D2FE3
          77816DB58D39D773A84B9B72417B6971F3230FE47B8AFCC9AE8FE19FC57D77E1
          16BE351D0AFA4B39BA48BD63997D1D4F045352E51495CFAB3F686FD80ADBC71A
          BDC6B3E13B8874CBDB96324D67367ECF239EACA47299EE391E98AF9F35DFD8CB
          E24E833956F0CDCDD2E7024B5963955BF26CFE6057BB7C39FF008296E97776A9
          0F8A745BAB3B9030D716244B139F528C432FD016AF4CD1FF006D1F87FADDBF99
          0EA9758EE1ACA5047FE3B5768BD49BC91F1BE9DFB1FF00C4AD4E4DB1F84F504E
          71999E3887E6CC2BF403E16E8973E1BF86FA169F789E5DD5958C30CC99076BAA
          0046471D6B84D6FF006D9F87DA0C5BA6D4EECF19016CA539FF00C76BCF3C6BFF
          000533D034F85D341D0752D4A6E8AF74EB6F17D78DCC7E981447963D44EECF9B
          FE3E1C7ED37E27FF00B0F4DFFA38D7E9369DFF0020F83FEB9AFF002AFCADF127
          8CEEBC57E39BBD76F76BDDDF5E35E4C106D52CCFB881E82BEC8B6FF8295782ED
          F454FF00895EBE6E9211FBAF2A3DA5C2F4DDBFA67BE3F0A22D2DCA9C5D91F0FD
          35CD389C5464E4D628D11F5B7FC12DB5F823B9F18696CC05CCAB6D751AFF007D
          17CC563F8164FF00BEABB7FF0082847C15D73E28F83349BFD0AD26D467D1A590
          CD6B0AEE95E3703E655EAC415E839E6BE35F851F14B54F839E37B4D7748755B9
          B638647FB9321FBC8C3D0D7DADF0EBFE0A19E09F185944BA8A6A1A2EA0547990
          B42D3A6EEFB5D01C8FA807DAB54D35CACCE77E6BA3E25B2F845E2BD575016D6F
          E19D7E69D8ED11AE9F296CFF00DF3C57D59FB0B7ECA3E28F853E359BC4FE218A
          1D3965B17B58ACCB8798EF646DCD8C85FBBD339E6BD2BC49FB727C3DF0D5A79B
          26A37B31FE148ECA4DCDF9803F5AF1FD43FE0A6DF6AF89BA7341A3CF6DE13B77
          7FB52E55EF2E8146553D76A85621B683CE3EF51EEA07293563D23FE0A2E71FB3
          65C7FD842DFF009B57CFBFB02FECE917C59F1ACBE21D5155F46F0F4A9885B9FB
          4DC7DE553FECA8C13F515D07ED71FB6AF867E37FC283A068D65AB25C4B771CCD
          25CC68888A99F4624939AC7FD8BBF6B6F0EFECF7E0FD5F4DD6ED3559A4BEBC17
          313DAC68EB8D8148396041E3F5A2EB9AE349A89F6DF8DB51D4746F095F4FA3E9
          E753D4E388FD96D448B1891FA0CB310001D4FB0AF833C61FB19FC60F1CF896F7
          56D4B455B8BED42569A690DF41C93FF03E9D87D2BDFF00FE1E69E01FF9F0F127
          FE0347FF00C729BFF0F37F00FF00CF87893FF01A3FFE3954F95F5223CCB647CD
          FF00F0C0DF14BFE85E8FFF0003A0FF00E2EBCB3C5DE13D43C09E25BCD2355B73
          6BA869F2986788B06D8C3DC120FE06BEE3FF00879BF807FE7C3C49FF0080D1FF
          00F1CAF8E3E3CF8FED7E28FC5ED7FC416514F0DA6A974668526004817000C804
          8CF1EB594EDD0BBC9EE7D89FF04FBFD9C6DBC05E078FC5F7F1ACBAD6BB166DC9
          E7EC96E7A01FED37049F4007AE7B1FDB07FE13DD6BE1F3685E04D1A6BC9F5606
          3BCBC4B8862FB3C3DD177BA9DCDD323A0CF7E9E59F07FF00E0A1FE0AF037C2FD
          0B47BDB1D7CDDE9B671DBCA62823642CA30483BC71F85749FF000F39F007FCF8
          F893FF0001A3FF00E395A271B5AE46B7B9F31FFC30A7C56FFA14A5FF00C0EB5F
          FE3B547C41FB17FC4DF0BE8975A8DF785A686CECA269A6905E5BBEC40324E164
          24FE02BEA93FF053BF87E3FE5C7C4BFF0080D1FF00F1CAC1F8A3FF00051CF047
          8B7E1D6B5A5DA587887ED3A859C96F17996F1AA86652064EF3C7353CB0EE55E4
          7847EC007FE32AFC3BFEE5CFFE887AFB17F6ECFF00935EF12FFB91FF00E8C5AF
          83FF00664F8AF67F053E3568FE23D42DE7B9B3B3322CC9063CC01E364C807838
          DD9C6457BEFED3FF00B7C7853E2E7C1AD4FC3DA3D86B42F35128A1EE6248E345
          0C18924313DBA629A6946CC249F31E6BFF0004FAF8A76FF0DBF682B586F65586
          CBC410B69CCEC70A92310D193F5650BFF03AFB6BF69BF8229F1FFE125F684244
          82F32B3D9CCFF763957919F63C83F5AFCB412B42EACA4AB29CA90704115F5BFE
          CF3FF0530FEC0D160D27C75677379F67511C5A9DA00D2328E00950E327FDA53C
          FA77A507A598DC5EE8F10F10FEC75F133C37AA3DAC9E0FD62E4A1C096D21FB44
          4E3D432647E7835EF9FB0C7EC59E21F06FC41B7F1778B2CBFB3069C8C6C6CE46
          5695E4652BBD802768009C03CE4F6C57B6693FB70FC39D66CD678757BAD8DFDE
          B0981FFD06B93F887FF052BF017846CE65D323D535DBF5184852036E9BBB6E77
          1C0F701BE955CB1BDC9BC99BDFB7CFC4F83E1D7ECEDAAC0650B7BAF634FB6407
          E66DDCB91EC141CFD47AD7E7BFC20D5A3D0BE2BF866F663886D354B699CFA059
          549FE55ADF1EBE3F6BBFB42F8C4EABACC8A8910296969193E55A21ECBEE70327
          BE2B875731B641208E411DAB39CAECB4ACAC7EBF78EBC36BE37F02EB3A397D8B
          ABD84F67BC7F0892364CFF00E3D5F991AFFEC77F133C3FACCD66FE0ED6AE4C2E
          544D6B6E668641D995D72083FF00EBC57D21FB35FF00C149B4683C2365A378DE
          3BCB6D42C91604BF822334772A3852CA3E656C633C107AF1D2BD8EE7F6DDF875
          6968667D5EE7601938B19BFF0089AD1F2C885CD1D0FCE2FF00844753F027C4AB
          5D2B58B1B8D3B52B4BB804D6F3AED923DC559723DD5811EC457EB278CFFE44FD
          5BFEBCE6FF00D00D7E62FED2FF001774DF89DFB4BEAFE2CD29677D367B9B6687
          CC5D8F22C31451938EDB8C648CF62335F5C788FF00E0A57F0E353F06DF244DAC
          FDAEE2CDD160366410EC846D2D9C753D73530695C6D3763E78FF00826DFF00C9
          D6D9FF00D795DFFE815F527FC1480E3F658D53FEBEEDFF00F43AF8B3F642F8CD
          A67C0CF8ED63E20D623B87D38453412981773C7E62901B1DC038CFF915EE5FB6
          6FEDBDE09F8CDF046EBC3FA0BEA53DFDD5CC4FFBDB631222A9C9249FE9445AE5
          B034DCAE7C715EEFFF0004DFFF0093A9D27FEBD6E7FF00459AF08AF4BFD91BE2
          FE9BF037E39E97E20D5E3B87D3E1496198C0BB9E30EA57763BE0F51D71F9566B
          73496D63EE6FF8288FFC9A8F883FEBA5BFFE8D5AFCCAAFB43F6C2FDBA7C0DF18
          3E056A5E1ED09F539F50BF962DBE65A9891155C31249FA76F5AF8B8BE0D55477
          7A0A9A696A7FFFD9}
        mmHeight = 19059
        mmLeft = 787
        mmTop = 520
        mmWidth = 36814
        BandType = 0
        LayerName = Foreground
      end
    end
    object ppDetailBand1: TppDetailBand
      Background1.Brush.Style = bsClear
      Background2.Brush.Style = bsClear
      Border.mmPadding = 0
      mmBottomOffset = 0
      mmHeight = 4498
      mmPrintPosition = 0
      object lblRelMesAno: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelMesAno'
        Border.mmPadding = 0
        DataField = 'ANOMES'
        DataPipeline = pplRelatorio
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'pplRelatorio'
        mmHeight = 4498
        mmLeft = 260
        mmTop = -7
        mmWidth = 11898
        BandType = 4
        LayerName = Foreground
      end
      object lblRelCadastradosAPP: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelCadastradosAPP'
        Border.mmPadding = 0
        DataField = 'QTD_TOT_CLI_APP'
        DataPipeline = pplRelatorio
        DisplayFormat = '#,0;-#,0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'pplRelatorio'
        mmHeight = 4498
        mmLeft = 14278
        mmTop = -3
        mmWidth = 25943
        BandType = 4
        LayerName = Foreground
      end
      object lblRelNovosCadastrados: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelNovosCadastrados'
        Border.mmPadding = 0
        DataField = 'QTD_NEW_CLI_APP'
        DataPipeline = pplRelatorio
        DisplayFormat = '#,0;-#,0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'pplRelatorio'
        mmHeight = 4498
        mmLeft = 41543
        mmTop = 0
        mmWidth = 25413
        BandType = 4
        LayerName = Foreground
      end
      object lblRelClientesGrazziotin: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelClientesGrazziotin'
        Border.mmPadding = 0
        DataField = 'QTD_NEW_CLI_APP'
        DataPipeline = pplRelatorio
        DisplayFormat = '#,0;-#,0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'pplRelatorio'
        mmHeight = 4498
        mmLeft = 68317
        mmTop = -3
        mmWidth = 27003
        BandType = 4
        LayerName = Foreground
      end
      object lblRelClientesAprovados: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelClientesAprovados'
        Border.mmPadding = 0
        DataField = 'QTD_NEW_CLI_APP_APROV'
        DataPipeline = pplRelatorio
        DisplayFormat = '#,0;-#,0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'pplRelatorio'
        mmHeight = 4498
        mmLeft = 96883
        mmTop = 0
        mmWidth = 28328
        BandType = 4
        LayerName = Foreground
      end
      object lblRelPagamentosAPP: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelPagamentosAPP'
        Border.mmPadding = 0
        DataField = 'TOT_CLI_PGTO_APP'
        DataPipeline = pplRelatorio
        DisplayFormat = '#,0;-#,0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'pplRelatorio'
        mmHeight = 4498
        mmLeft = 126514
        mmTop = 0
        mmWidth = 34953
        BandType = 4
        LayerName = Foreground
      end
      object lblRelParcelasPagasCIA: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelParcelasPagasCIA'
        Border.mmPadding = 0
        DataField = 'QTD_PARCELAS_PGTO_CIA'
        DataPipeline = pplRelatorio
        DisplayFormat = '#,0;-#,0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'pplRelatorio'
        mmHeight = 4498
        mmLeft = 162773
        mmTop = 0
        mmWidth = 29123
        BandType = 4
        LayerName = Foreground
      end
      object lblRelValorPagoCIA: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'lblRelValorPagoCIA'
        Border.mmPadding = 0
        DataField = 'VLR_PARCELAS_PGTO_CIA'
        DataPipeline = pplRelatorio
        DisplayFormat = '#,0.00;(#,0.00)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 9
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'pplRelatorio'
        mmHeight = 4498
        mmLeft = 193191
        mmTop = 0
        mmWidth = 24088
        BandType = 4
        LayerName = Foreground
      end
    end
    object ppPageSummaryBand1: TppPageSummaryBand
      Background.Brush.Style = bsClear
      Border.mmPadding = 0
      mmBottomOffset = 0
      mmHeight = 74613
      mmPrintPosition = 0
      object chtRelCadastradosAPP: TppTeeChart
        DesignLayer = ppDesignLayer1
        UserName = 'chtRelCadastradosAPP'
        Border.BorderPositions = [bpLeft, bpTop, bpRight, bpBottom]
        Border.Visible = True
        Border.mmPadding = 0
        mmHeight = 70398
        mmLeft = 768
        mmTop = 1040
        mmWidth = 139509
        BandType = 11
        LayerName = Foreground
        object ppTeeChartControl1: TppTeeChartControl
          Left = 0
          Top = 0
          Width = 400
          Height = 250
          Title.Font.Color = clBlack
          Title.Font.Style = [fsBold]
          Title.Text.Strings = (
            'Clientes Cadastrados pelo APP')
          BackColor = clWhite
          BottomAxis.LabelsAngle = 90
          BottomAxis.LabelsFormat.Font.Height = -9
          Legend.Visible = False
          MaxPointsPerPage = 0
          Page = 1
          ScaleLastPage = True
          BevelOuter = bvNone
          BorderStyle = bsNone
          Color = clWhite
          DefaultCanvas = 'TTeeCanvas3D'
          ColorPaletteIndex = 13
          object Series1: TBarSeries
            Marks.Font.Height = -9
            Marks.Visible = False
            Marks.Angle = 90
            SeriesColor = 8454143
            Title = 'RelBarra_Cadastrados_APP'
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Bar'
            YValues.Order = loNone
          end
        end
      end
      object chtRelNovosCadastros: TppTeeChart
        DesignLayer = ppDesignLayer1
        UserName = 'chtRelNovosCadastros'
        Border.BorderPositions = [bpLeft, bpTop, bpRight, bpBottom]
        Border.Visible = True
        Border.mmPadding = 0
        mmHeight = 70407
        mmLeft = 144749
        mmTop = 1058
        mmWidth = 139457
        BandType = 11
        LayerName = Foreground
        object ppTeeChartControl2: TppTeeChartControl
          Left = 0
          Top = 0
          Width = 400
          Height = 250
          BackWall.Color = clWhite
          Title.Font.Color = clBlack
          Title.Font.Style = [fsBold]
          Title.Text.Strings = (
            'Novos Cadastros')
          BackColor = clWhite
          BottomAxis.LabelsAngle = 90
          BottomAxis.LabelsFormat.Font.Height = -9
          Legend.Visible = False
          MaxPointsPerPage = 0
          Page = 1
          ScaleLastPage = True
          BevelOuter = bvNone
          BorderStyle = bsNone
          Color = clWhite
          DefaultCanvas = 'TTeeCanvas3D'
          ColorPaletteIndex = 13
          object Series1: TBarSeries
            Marks.Visible = False
            SeriesColor = 8454143
            Title = 'RelBarra_Novos_Cadastros'
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Bar'
            YValues.Order = loNone
          end
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
  object pplRelatorio: TppDBPipeline
    DataSource = dtsAtualiza
    UserName = 'lRelatorio'
    Left = 612
    Top = 340
    object pplRelatorioppField1: TppField
      FieldAlias = 'ANOMES'
      FieldName = 'ANOMES'
      FieldLength = 0
      DisplayWidth = 0
      Position = 0
    end
    object pplRelatorioppField2: TppField
      Alignment = taRightJustify
      FieldAlias = 'QTD_TOT_CLI_APP'
      FieldName = 'QTD_TOT_CLI_APP'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 9
      Position = 1
    end
    object pplRelatorioppField3: TppField
      Alignment = taRightJustify
      FieldAlias = 'QTD_NEW_CLI_APP'
      FieldName = 'QTD_NEW_CLI_APP'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 9
      Position = 2
    end
    object pplRelatorioppField4: TppField
      Alignment = taRightJustify
      FieldAlias = 'QTD_CLI_GRAZZIOTIN'
      FieldName = 'QTD_CLI_GRAZZIOTIN'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 9
      Position = 3
    end
    object pplRelatorioppField5: TppField
      Alignment = taRightJustify
      FieldAlias = 'QTD_NEW_CLI_APP_APROV'
      FieldName = 'QTD_NEW_CLI_APP_APROV'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 9
      Position = 4
    end
    object pplRelatorioppField6: TppField
      Alignment = taRightJustify
      FieldAlias = 'TOT_CLI_PGTO_APP'
      FieldName = 'TOT_CLI_PGTO_APP'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 9
      Position = 5
    end
    object pplRelatorioppField7: TppField
      Alignment = taRightJustify
      FieldAlias = 'QTD_PARCELAS_PGTO_CIA'
      FieldName = 'QTD_PARCELAS_PGTO_CIA'
      FieldLength = 0
      DataType = dtDouble
      DisplayWidth = 9
      Position = 6
    end
    object pplRelatorioppField8: TppField
      Alignment = taRightJustify
      FieldAlias = 'VLR_PARCELAS_PGTO_CIA'
      FieldName = 'VLR_PARCELAS_PGTO_CIA'
      FieldLength = 2
      DataType = dtDouble
      DisplayWidth = 19
      Position = 7
    end
  end
end
