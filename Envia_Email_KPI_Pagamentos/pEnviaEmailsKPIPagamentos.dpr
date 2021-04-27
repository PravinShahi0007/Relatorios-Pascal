{-------------------------------------------------------------------------------
 Programa..: pEnviaEmailsKPIPagamentos
 Empresa...: Grazziotin S/A
 Finalidade: Geranciador do projeto para envio de e-mail�s autom�ticos da
             consulta do KPI Pagamentos

 Autor   Data     Opera��o  Descri��o
 Ant�nio MAR/2021 Cria��o
-------------------------------------------------------------------------------}
program pEnviaEmailsKPIPagamentos;

uses
  Forms,
  Ufuncoes in 'Ufuncoes.pas',
  uEnviaEmailKPIPagamentos in 'uEnviaEmailKPIPagamentos.pas' {frmPrincipal},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Windows10');
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
