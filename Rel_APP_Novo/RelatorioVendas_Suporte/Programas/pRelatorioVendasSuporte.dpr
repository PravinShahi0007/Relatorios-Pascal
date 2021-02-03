{-------------------------------------------------------------------------------
 Programa..: pAtualizaVendaAVista
 Empresa...: Grazziotin S/A
 Finalidade: Gerenciador do projeto

 Autor    Data     Operação  Descrição
 Antonio  JAN/2021 Criação
-------------------------------------------------------------------------------}
program pRelatorioVendasSuporte;

uses
  Vcl.Forms,
  uPrincipalRelatorioVendasSuporte in 'uPrincipalRelatorioVendasSuporte.pas' {frmPrincipalRelatorioVendas},
  Vcl.Themes,
  Vcl.Styles,
  uDtmRelatorioVendas in 'uDtmRelatorioVendas.pas' {dtmRelatorioVendas: TDataModule},
  uAparencia in 'uAparencia.pas' {frmAparencia},
  uFuncoes in 'uFuncoes.pas',
  uConfiguracaoINI in 'uConfiguracaoINI.pas' {frmConfiguracaoINI},
  uRelatorioVendas in 'uRelatorioVendas.pas' {frmRelatorioVendas};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdtmRelatorioVendas, dtmRelatorioVendas);
  Application.CreateForm(TfrmPrincipalRelatorioVendas, frmPrincipalRelatorioVendas);
  Application.Run;
end.
