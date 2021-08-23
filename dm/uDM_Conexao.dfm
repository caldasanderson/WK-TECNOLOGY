object dm_Conexao: Tdm_Conexao
  OldCreateOrder = False
  Height = 166
  Width = 272
  object CONEXAO: TOraSession
    Options.Direct = True
    ProxyOptions.ResolveDNS = False
    Username = 'SYSTEM'
    Server = 'localhost:1521/xe'
    Connected = True
    HomeName = 'xe'
    Left = 79
    Top = 30
    EncryptedPassword = '9EFF9BFF92FF96FF91FF'
  end
  object OraQuery1: TOraQuery
    Session = CONEXAO
    Left = 136
    Top = 96
  end
end
