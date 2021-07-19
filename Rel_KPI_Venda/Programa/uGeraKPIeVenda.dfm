object frmGeraKPI: TfrmGeraKPI
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Gera KPI e Venda'
  ClientHeight = 161
  ClientWidth = 258
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlFundo: TPanel
    Left = 0
    Top = 0
    Width = 258
    Height = 161
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvSpace
    TabOrder = 0
    object grpParametros: TGroupBox
      Left = 2
      Top = 2
      Width = 254
      Height = 119
      Align = alClient
      Caption = '[ Par'#226'metros ]'
      TabOrder = 0
      object lblUnidade: TLabel
        Left = 13
        Top = 46
        Width = 43
        Height = 13
        Caption = 'Unidade:'
      end
      object lblEmpresa: TLabel
        Left = 11
        Top = 24
        Width = 45
        Height = 13
        Caption = 'Empresa:'
      end
      object lblDatas: TLabel
        Left = 24
        Top = 73
        Width = 32
        Height = 13
        Caption = 'Datas:'
      end
      object lblParametroEmpresa: TLabel
        Left = 62
        Top = 24
        Width = 23
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = '1'
      end
      object lblUnidadeAte: TLabel
        Left = 114
        Top = 46
        Width = 16
        Height = 13
        Caption = 'ate'
      end
      object lblDatasAte: TLabel
        Left = 145
        Top = 73
        Width = 16
        Height = 13
        Caption = 'ate'
      end
      object lblMensagem: TLabel
        Left = 2
        Top = 101
        Width = 250
        Height = 16
        Align = alBottom
        Caption = 'xxxxxx'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 42
      end
      object edtUnidadeInicial: TMaskEdit
        Left = 62
        Top = 43
        Width = 46
        Height = 21
        MaxLength = 2
        ReadOnly = True
        TabOrder = 0
        Text = ''
      end
      object edtUnidadeFinal: TMaskEdit
        Left = 136
        Top = 43
        Width = 46
        Height = 21
        MaxLength = 2
        ReadOnly = True
        TabOrder = 1
        Text = ''
      end
      object edtDataInicial: TMaskEdit
        Left = 62
        Top = 70
        Width = 77
        Height = 21
        AutoSize = False
        EditMask = '!99/99/9999;1;_'
        MaxLength = 10
        ReadOnly = True
        TabOrder = 2
        Text = '  /  /    '
      end
      object edtDataFinal: TMaskEdit
        Left = 167
        Top = 70
        Width = 77
        Height = 21
        AutoSize = False
        EditMask = '!99/99/9999;1;_'
        MaxLength = 10
        ReadOnly = True
        TabOrder = 3
        Text = '  /  /    '
      end
    end
    object pnlBotoes: TPanel
      Left = 2
      Top = 121
      Width = 254
      Height = 38
      Align = alBottom
      BevelInner = bvLowered
      TabOrder = 1
      object btnGerar: TBitBtn
        Left = 2
        Top = 2
        Width = 90
        Height = 34
        Align = alLeft
        Caption = 'Gerar'
        Glyph.Data = {
          F6060000424DF606000000000000360000002800000018000000180000000100
          180000000000C0060000C40E0000C40E00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFEFEFEF9F9F9F5F5F5F2F2F2EFEFEFEDEDEDE7E9E8E7E8E7
          E7E7E7E6E6E6E6E6E6E6E6E6E6E6E6E7E7E7E9E9E9EAEAEAECECECEFEFEFF2F2
          F2F5F5F5F9F9F9FDFDFDFFFFFFFFFFFFEDEDEDD0D0D0C3C3C3BBBBBBB6B6B6B3
          B3B397B4A54DBE86A2AEA8ADADADADADADADADADADADADADADADAFAFAFB0B0B0
          B3B3B3B6B6B6BBBBBBC3C3C3D0D0D0EDEDEDFFFFFFFFFFFFFFFFFFFBFBFBCFCF
          CFC2C2C2C1C1C1C0C0C0BDC0BF38C68343C486A9C0B6BFBFBFBFBFBFBFBFBFBF
          BFBFBFBFBFBFBFBFC0C0C0C1C1C1C2C2C2CECECEFAFAFAFFFFFFFFFFFFFFFFFF
          FFFFFFE5E6E6BCBDBDABBEB691C0AB82C1A57CC2A242C98B26C87D30C78196C0
          ADBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDE4E5E5FF
          FFFFFFFFFFFFFFFFF4FCF88CDAB83BC98925CA8125CB8125CB8125CB8125CB81
          25CB8125CB8128CA8287C5A9BEBEBEB7B8B8B8B9B9BABBBBBABBBBBBBBBBBFBF
          BFBFC0C0E1E1E1FFFFFFFFFFFFDDF7EC3ED39322CD8422CD8423CD8422CD8422
          CD8423CD8423CE8522CD8422CD8423CD8425CE86B8D8C9DCDBDADCDBDADCDBDA
          DCDBDAD8D8D8BDBEBEC1C1C1E2E2E2FFFFFFFCFEFD48D89D21D08721D08726D2
          8C2FD5923BD49741D39939D69728D28D21D08721D0872AD38E62D8A9D0D4CDCF
          C4BAD8D3CED8D3CED5CFC9D9D5D2BFC0C0C3C4C4E3E3E3FFFFFFC5F3E120D28A
          20D28A2BD5927ACFAEB5C8C0C6C6C6CACACAD4DFD725D18A22D38B36D59591CC
          A9D4CDC5DAD5D1D1C6BBDAD5D1DAD5D1D8D1CBDAD6D3C2C2C2C6C6C6E3E4E4FF
          FFFF98EBCA1ED48C21D58E80D7B6C8C8C8C8C8C8C8C8C8D5D5D58EDFBF25D793
          5FDCAAD1E0CEE0D5C9D9D3CDDFDDDAD4CBC2DFDDDADFDDDADCD8D4DDD8D5C4C4
          C4C8C8C8E5E5E5FFFFFF9CEDCE1DD68F1FD790BDE4D5CACACACACACACACACADF
          DFDF51DDA898E1C5D3C7B9DBD0C3D7C9BBD3C9BED8D0C8CFC2B5D8D0C8D8D0C8
          D6CCC3DEDAD7C6C6C6CACACAE5E6E6FFFFFFD3F8EA22DA961CD890AFE2CECBCC
          CCCBCCCCCBCCCCE8E7E7D4D3C4E8E7E6E0D6CBECE6DEE5DCD2E1DDD9E8E8E8DA
          D2CBE8E8E8E8E8E8E4E2E0E0DCD8C7C7C7CBCCCCE6E6E6FFFFFFFFFFFF72E8BE
          1FDA956CD6AECDCDCDCDCDCDD3D3D3E3DEDADFD4C7E7E6E4D6C8BADDD1C3D8CA
          BBD6CCC2DBD4CCD1C4B8DBD4CCDBD4CCD9D0C7E1DEDAC9C9C9CDCDCDE7E7E7FF
          FFFFFFFFFFF7FDFB6CE9BD68D6AFCECFCFCECECEDCDCDCDFD8D1E4DCD2EBEAE8
          D6C9BBDCD1C5D7CABDD6CCC2DBD4CDD1C5B9DBD4CDDBD4CDD9D0C7E3DFDBCACA
          CACECFCFE8E8E8FFFFFFFFFFFFFFFFFFFFFFFFC5E6DAD0D0D0D0D0D0E4E4E4EC
          ECECE3DED7E8E6E4E0D6CAECE5DCE5DCD1E4E0DCECECECDDD5CEECECECECECEC
          E8E6E4E3DFDCCCCCCCD0D0D0E8E8E8FFFFFFFFFFFFFFFFFFFFFFFFEBEBEBD1D1
          D1D1D1D1EBEBEBEDEDEDDFD1B4E7E2D7DCD3C9E0D7CEDCD2C8DCD4CCE0DAD4D8
          CFC5E0DAD4E0DAD4DED7D0E7E4E2CDCDCDD1D1D1E9E9E9FFFFFFFFFFFFFFFFFF
          FFFFFFEBEBEBD2D2D2D8D8D8EDEDEDEDEDEDECECECECECECEDEDEDDDD2BBC6AA
          71E7E3DAC5AA71E0D7C4CDB789D0BF9BDEDEDEE0E0E0CECECED2D2D2EAEAEAFF
          FFFFFFFFFFFFFFFFFFFFFFECECECD3D3D3D4D4D4DEDEDEE6E6E6ECECECECECEC
          ECECECE9E3D7E3D5B8EBE9E4E3D5B8E9E5DBE5DAC3A8A193727272A0A0A0D3D3
          D3D3D3D3EAEAEAFFFFFFFFFFFFFFFFFFFFFFFFECECECD4D4D4D3D3D3D4D4D4D4
          D4D4D4D4D4E9E9E9EDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDED999999
          989898D3D3D3D3D3D3D4D4D4EBEBEBFFFFFFFFFFFFFFFFFFFFFFFFEEEEEED7D7
          D7D4D4D4D4D4D4D4D4D4D4D4D4DDDDDDE1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1
          E1E1E1E1E1C4C4C4D4D4D4D4D4D4D4D4D4D7D7D7EDEDEDFFFFFFFFFFFFFFFFFF
          FFFFFFFBFBFBE0E0E0DCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDC
          DCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCE0E0E0FBFBFBFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCFCFCFCFCFCFCFCFCFCFCFCFC
          FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFC
          FCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        TabOrder = 0
        OnClick = btnGerarClick
      end
      object btnSair: TBitBtn
        Left = 162
        Top = 2
        Width = 90
        Height = 34
        Align = alRight
        Caption = 'Sair'
        Glyph.Data = {
          76060000424D7606000000000000360400002800000018000000180000000100
          0800000000004002000000000000000000000001000000000000000000000000
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
          070707070707070707070707070707070707070707FFFFFFFFFFFFFFFFFFFF00
          0000FFFFFFFF07070707070707FFFFFFFFFFFFFFFFFFFF000000FFFFFFFF0707
          0707070707FFFFFFFFFFFFFFFFFFFF0000FE00FFFFFFFF07070707FFFFFFFFFF
          FFFFFFFFFFFFFF0000FE060000FFFFFFFF07070000000000000000FFFFFFFF00
          00FE0606060000000007070000000000000000FFFFFFFF0000FE060606000000
          0007070707070707070707000000000000FE0606060007070707070707070707
          070007A4A4A4A40000FE0606060007070707070707070707070000A4A4A4A400
          00FE0606060007070707070707070707070000A4A4A4A40000FE060606000707
          07070707070707070700FE0000A4A40000FE0006060007070707070707000000
          0000FEFEFE00A40000FE000606000707070707070700FEFEFEFEFEFEFEFE0000
          00FE060606000707070707070700FEFEFEFEFEFEFEFE000000FE060606000707
          07070707070000000000FEFEFE00A40000FE0606060007070707070707070707
          0700FE0000A4A40000FE0606060007070707070707070707070000A4A4A4A400
          00FE0606060007070707070707070707070000A4A4A4A40000FE060606000707
          0707070707070707070007A4A4A4A4A4A400FE06060007070707070707070707
          070707A4A4A4A4A4A4A400FEFE0007070707070707070707070707A4A4A4A4A4
          A4A4A400000007070707070707070707070707A4A4A4A4A4A4A4A40000000707
          0707070707070707070707070707070707070707070707070707}
        TabOrder = 1
        OnClick = btnSairClick
      end
    end
  end
  object fdcBancoDados: TFDConnection
    Params.Strings = (
      'Database=192.168.200.110:1522/GRZPROD'
      'User_Name=nl'
      'Password=nl'
      'DriverID=Ora')
    Connected = True
    LoginPrompt = False
    Left = 203
    Top = 4
  end
  object sp_Venda_Diaria_Cidade: TFDStoredProc
    Connection = fdcBancoDados
    SchemaName = 'NL'
    StoredProcName = 'GRZ_REL_KPI_VENDA'
    Left = 147
    Top = 4
    ParamData = <
      item
        Position = 1
        Name = 'PI_OPCAO'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end>
  end
end
