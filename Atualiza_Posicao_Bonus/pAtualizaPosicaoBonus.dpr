{-------------------------------------------------------------------------------
 Programa..: pAtualizaPosicaoBonus
 Empresa...: Grazziotin S/A
 Finalidade: Geranciador do projeto para atualizar os valores de b�nus

 Autor   Data     Opera��o  Descri��o
 Ant�nio ABR/2021 Cria��o
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
