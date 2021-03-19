{-------------------------------------------------------------------------------
 Programa..: pEnviaEmailsKPIPagamentos
 Empresa...: Grazziotin S/A
 Finalidade: Geranciador do projeto para envio de e-mail´s automáticos da
             consulta do KPI Pagamentos

 Autor   Data     Operação  Descrição
 Antônio MAR/2021 Criação
-------------------------------------------------------------------------------}
program pEnviaEmailsKPIPagamentos;

uses
  Forms,
  Ufuncoes in 'Ufuncoes.pas',
  uEnviaEmailKPIPagamentos in 'uEnviaEmailKPIPagamentos.pas' {frmPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
