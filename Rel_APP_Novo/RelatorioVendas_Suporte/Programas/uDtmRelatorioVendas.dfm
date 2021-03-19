object dtmRelatorioVendas: TdtmRelatorioVendas
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 196
  Width = 268
  object fdcRelatorioVendas: TFDConnection
    Params.Strings = (
      'Database=192.168.200.110:1522/GRZPROD'
      'User_Name=nl'
      'Password=nl'
      'MetaDefSchema=system'
      'DriverID=Ora')
    FetchOptions.AssignedValues = [evUnidirectional]
    Connected = True
    LoginPrompt = False
    Transaction = trsRelatorioVendas
    Left = 40
    Top = 17
  end
  object trsRelatorioVendas: TFDTransaction
    Connection = fdcRelatorioVendas
    Left = 143
    Top = 16
  end
  object qryGeralDados: TFDQuery
    Connection = fdcRelatorioVendas
    Transaction = trsRelatorioVendas
    Left = 48
    Top = 72
  end
  object fspGRZ_Rel_Pgto_AppxLoja_SP: TFDStoredProc
    Connection = fdcRelatorioVendas
    Transaction = trsRelatorioVendas
    SchemaName = 'NL'
    StoredProcName = 'GRZ_REL_PGTO_APPXLOJA_SP'
    Left = 152
    Top = 96
    ParamData = <
      item
        Position = 1
        Name = 'PDATAINICIAL'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end
      item
        Position = 2
        Name = 'PDATAFINAL'
        DataType = ftString
        FDDataType = dtAnsiString
        ParamType = ptInput
      end>
  end
end
