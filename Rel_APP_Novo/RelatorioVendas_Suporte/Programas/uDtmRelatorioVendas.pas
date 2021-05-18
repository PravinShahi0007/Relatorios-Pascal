{-------------------------------------------------------------------------------
 Programa..: uDtmRelatorioVendas
 Empresa...: Grazziotin S/A
 Finalidade: Componentes da conexão com a base de dados

 Autor    Data     Operação  Descrição
 Antonio  JAN/2021 Criação
-------------------------------------------------------------------------------}
unit uDtmRelatorioVendas;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, IniFiles, Vcl.Forms, Vcl.Themes, FireDAC.Phys.Oracle,
  FireDAC.Phys.OracleDef;

type
    RCAMINHOS = record
                CAMINHOEXE: String;
                CAMINHOINI: String;
    end;
    RUSUARIO = record
               USUARIO: String; // Pegar o usuário do windows....
               APARECIA: String;
    end;
    RARQUIVOINI = record
                  BASEDADOS: String;
                  USUARIO: String;
                  SENHA: String;
    end;

type
  TdtmRelatorioVendas = class(TDataModule)
    fdcRelatorioVendas: TFDConnection;
    trsRelatorioVendas: TFDTransaction;
    qryGeralDados: TFDQuery;
    fspGRZ_Rel_Pgto_AppxLoja_SP: TFDStoredProc;
    procedure Escreve_Usuario_INI(Sender: TObject);
    procedure Escreve_Conexao_INI(Sender: TObject);
    procedure Verifica_INI(Sender: TObject);
    procedure Le_Conexao_INI(Sender: TObject);
    procedure Le_Usuario_INI(Sender: TObject);
    procedure Escreve_Dados_INI(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ARQUIVOINI: RARQUIVOINI;
    USUARIO: RUSUARIO;
    CAMINHOS: RCAMINHOS;
    ifArquivoINI: TIniFile;
  end;

var
  dtmRelatorioVendas: TdtmRelatorioVendas;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses uFuncoes, uConfiguracaoINI;

{$R *.dfm}

procedure TdtmRelatorioVendas.DataModuleCreate(Sender: TObject);
begin
     fdcRelatorioVendas.Connected := True;

     // Configura CAMINHOS...
     CAMINHOS.CAMINHOEXE := ExtractFilePath(Application.ExeName);
     CAMINHOS.CAMINHOINI := CAMINHOS.CAMINHOEXE+'RelatorioVendas.INI';

     // Pega USUARIO
     USUARIO.USUARIO := NomeUsuario;

     Verifica_INI(Sender); // Verifica se o banco existe
     Le_Conexao_INI(Sender);
     Le_Usuario_INI(Sender);

     // Conexão com o banco de dados...
     fdcRelatorioVendas.Params.Database := ARQUIVOINI.BASEDADOS;
     fdcRelatorioVendas.Params.UserName := ARQUIVOINI.USUARIO;
     fdcRelatorioVendas.Params.Password := ARQUIVOINI.SENHA;

     // Aplica aparencia...
     TStyleManager.TrySetStyle(USUARIO.APARECIA);
end;

procedure TdtmRelatorioVendas.Verifica_INI(Sender: TObject);
var
   Formulario: TfrmConfiguracaoINI;
begin
     if not FileExists(CAMINHOS.CAMINHOINI) then
     begin
          Formulario := TfrmConfiguracaoINI.Create(Self);
          Formulario.sAcaoConfiguracao := 'INATIVO';
          Formulario.ShowModal;
          Formulario.Free;
     end;
end;

procedure TdtmRelatorioVendas.Escreve_Dados_INI(Sender: TObject);
begin
     ifArquivoINI := TIniFile.Create(CAMINHOS.CAMINHOINI);
     ifArquivoINI.WriteString('ORACLE','BASEDADOS', ARQUIVOINI.BASEDADOS);
     ifArquivoINI.WriteString('ORACLE','USUARIO', ARQUIVOINI.USUARIO);
     ifArquivoINI.WriteString('ORACLE','SENHA', ARQUIVOINI.SENHA);

     ifArquivoINI.WriteString(USUARIO.USUARIO,'APARENCIA',USUARIO.APARECIA);

     ifArquivoINI.Free;
end;

procedure TdtmRelatorioVendas.Escreve_Conexao_INI(Sender: TObject);
begin
     ifArquivoINI := TIniFile.Create(CAMINHOS.CAMINHOINI);

     ifArquivoINI.WriteString('ORACLE','BASEDADOS', ARQUIVOINI.BASEDADOS);
     ifArquivoINI.WriteString('ORACLE','USUARIO', ARQUIVOINI.USUARIO);
     ifArquivoINI.WriteString('ORACLE','SENHA', ARQUIVOINI.SENHA);

     ifArquivoINI.Free;
end;

procedure TdtmRelatorioVendas.Escreve_Usuario_INI(Sender: TObject);
begin
     ifArquivoINI := TIniFile.Create(CAMINHOS.CAMINHOINI);

     ifArquivoINI.WriteString(USUARIO.USUARIO,'APARENCIA',USUARIO.APARECIA);

     ifArquivoINI.Free;
end;

procedure TdtmRelatorioVendas.Le_Conexao_INI(Sender: TObject);
begin
     ifArquivoINI := TIniFile.Create(CAMINHOS.CAMINHOINI);
     ARQUIVOINI.BASEDADOS := ifArquivoINI.ReadString('ORACLE','BASEDADOS','NÃO ENCONTROU CAMINHO BASE');
     ARQUIVOINI.USUARIO := ifArquivoINI.ReadString('ORACLE','USUARIO','NÃO ENCONTROU USUÁRIO');
     ARQUIVOINI.SENHA := ifArquivoINI.ReadString('ORACLE','SENHA','NÃO ENCONTROU SENHA');

     ifArquivoINI.Free;
end;

procedure TdtmRelatorioVendas.Le_Usuario_INI(Sender: TObject);
begin
     ifArquivoINI := TIniFile.Create(CAMINHOS.CAMINHOINI);

     USUARIO.APARECIA := ifArquivoINI.ReadString(USUARIO.USUARIO,'APARENCIA','NÃO ENCONTROU APARÊNCIA');

     ifArquivoINI.Free;
end;


end.
