{-------------------------------------------------------------------------------
 Programa..: pAtualizaPosicaoBonus
 Empresa...: Grazziotin S/A
 Finalidade: Geranciador do projeto para atualizar os valores de bônus

 Autor   Data     Operação  Descrição
 Antônio ABR/2021 Criação
-------------------------------------------------------------------------------}
program pAtualizaPosicaoBonus;

uses
  Forms,
  Ufuncoes in 'Ufuncoes.pas',
  uAtualizaPosicaoBonus in 'uAtualizaPosicaoBonus.pas' {frmPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
