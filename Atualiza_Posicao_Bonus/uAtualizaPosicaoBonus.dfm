object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Atualiza Posi'#231#227'o B'#244'nus...'
  ClientHeight = 132
  ClientWidth = 296
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlFundo: TPanel
    Left = 0
    Top = 0
    Width = 296
    Height = 132
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    ExplicitHeight = 168
    object lblMensagem: TLabel
      Left = 2
      Top = 82
      Width = 292
      Height = 13
      Align = alTop
      Caption = 'lblMensagem'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 74
    end
    object pnlCabecalho: TPanel
      Left = 2
      Top = 2
      Width = 292
      Height = 31
      Align = alTop
      BevelInner = bvLowered
      Caption = 'Atualiza Posi'#231#227'o B'#244'nus'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object grpData: TGroupBox
      Left = 2
      Top = 33
      Width = 292
      Height = 49
      Align = alTop
      Caption = '[ Data ]'
      TabOrder = 1
      object lblInicio: TLabel
        Left = 17
        Top = 22
        Width = 29
        Height = 13
        Caption = 'Inicio:'
      end
      object edtInicio: TMaskEdit
        Left = 51
        Top = 19
        Width = 74
        Height = 21
        EditMask = '!##/##/####;1; '
        MaxLength = 10
        TabOrder = 0
        Text = '  /  /    '
      end
    end
    object pnlRodape: TPanel
      Left = 2
      Top = 95
      Width = 292
      Height = 35
      Align = alClient
      BevelInner = bvLowered
      TabOrder = 2
      ExplicitLeft = 4
      ExplicitTop = 88
      ExplicitHeight = 71
      object btnSair: TBitBtn
        Left = 215
        Top = 2
        Width = 75
        Height = 31
        Align = alRight
        Caption = 'Sair'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
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
        ParentFont = False
        TabOrder = 0
        OnClick = btnSairClick
        ExplicitHeight = 33
      end
    end
  end
  object trsOracle: TFDTransaction
    Connection = fdcOracle
    Left = 236
    Top = 56
  end
  object fdcOracle: TFDConnection
    Params.Strings = (
      'Database=192.168.200.110:1522/GRZPROD'
      'User_Name=nl'
      'Password=nl'
      'MetaDefSchema=system'
      'DriverID=Ora')
    Connected = True
    LoginPrompt = False
    Transaction = trsOracle
    Left = 160
    Top = 56
  end
  object fspGRZ_Posicao_Bonus_SP: TFDStoredProc
    Connection = fdcOracle
    Transaction = trsOracle
    SchemaName = 'NL'
    StoredProcName = 'GRZ_POSICAO_BONUS_SP'
    Left = 248
    Top = 8
    ParamData = <
      item
        Name = 'pdatainicial'
        DataType = ftString
        ParamType = ptInput
        DataTypeName = 'pdatainicial'
      end>
  end
end
