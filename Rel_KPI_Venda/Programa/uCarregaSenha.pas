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
     // Fun��o para ler parametros do banco de dados oracle
     // deve passar o TomEncryption para desencritpar o arquivo na fun��o
     if FileExists('c:\windows\LSBO.bin') then
     begin
          ifArqINI := TIniFile.Create('c:\windows\LSBO.bin');
          // paramBanco � o Parametro fixo definido no arquivo
          Encriptado := ifArqINI.ReadString('PARAMETROS', ParamBanco, '');

          TomEncryption1.Action := atDecryption;
          //chave de desencripta��o... foi encriptado o arquivo com essa chave
          TomEncryption1.Key := '�O��';
          TomEncryption1.Input := Encriptado;
          TomEncryption1.Execute;
          // l� o login = nome do usu�rio
          sDescriptado := TomEncryption1.Output;
          Login := Copy(sDescriptado,1,pos(';',sDescriptado) - 1);

          // l� a senha do usu�rio
          sDescriptado := Copy(sDescriptado, (pos(';',sDescriptado) + 1),length(sDescriptado));
          Senha := Copy(sDescriptado,1,pos(';',sDescriptado) - 1);

          //l� o nome do banco que ir� se logar
          sDescriptado := Copy(sDescriptado, (pos(';',sDescriptado) + 1),length(sDescriptado));
          NomeBanco := Copy(sDescriptado,1,pos(';',sDescriptado) - 1);

          Result := 'OK';
     end
     else
     begin
          MessageDlg('Arquivo Ini n�o encontrado para conex�o com Banco de Dados!!!', mtError, [mbOK], 0);
          Result := 'ERRO';
          Exit;
     end;
end;

end.
