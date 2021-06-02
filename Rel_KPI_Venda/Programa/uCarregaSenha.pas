unit uCarregaSenha;

interface

uses Classes, Dialogs, ExtCtrls, StdCtrls, SysUtils, Windows, IniFiles, Encryp;

function CarregaSenhasBancoOra(ParamBanco : string; TomEncryption1: TTomEncryption;
                               var Login, Senha, NomeBanco : String):string;

implementation

function CarregaSenhasBancoOra(ParamBanco : string; TomEncryption1: TTomEncryption;
                               var Login, Senha, NomeBanco : String):string;
var
   ifArqINI: TIniFile;
   Encriptado, sDescriptado: string;
   Self: TComponent;
begin
     // Função para ler parametros do banco de dados oracle
     // deve passar o TomEncryption para desencritpar o arquivo na função
     if FileExists('c:\windows\LSBO.bin') then
     begin
          ifArqINI := TIniFile.Create('c:\windows\LSBO.bin');
          // paramBanco é o Parametro fixo definido no arquivo
          Encriptado := ifArqINI.ReadString('PARAMETROS', ParamBanco, '');

          TomEncryption1.Action := atDecryption;
          //chave de desencriptação... foi encriptado o arquivo com essa chave
          TomEncryption1.Key := 'èµOûÿ';
          TomEncryption1.Input := Encriptado;
          TomEncryption1.Execute;
          // lê o login = nome do usuário
          sDescriptado := TomEncryption1.Output;
          Login := Copy(sDescriptado,1,pos(';',sDescriptado) - 1);

          // lê a senha do usuário
          sDescriptado := Copy(sDescriptado, (pos(';',sDescriptado) + 1),length(sDescriptado));
          Senha := Copy(sDescriptado,1,pos(';',sDescriptado) - 1);

          //lê o nome do banco que irá se logar
          sDescriptado := Copy(sDescriptado, (pos(';',sDescriptado) + 1),length(sDescriptado));
          NomeBanco := Copy(sDescriptado,1,pos(';',sDescriptado) - 1);

          Result := 'OK';
     end
     else
     begin
          MessageDlg('Arquivo Ini não encontrado para conexão com Banco de Dados!!!', mtError, [mbOK], 0);
          Result := 'ERRO';
          Exit;
     end;
end;

end.
