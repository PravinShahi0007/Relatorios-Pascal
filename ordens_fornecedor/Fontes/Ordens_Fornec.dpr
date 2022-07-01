program Ordens_Fornec;

uses
  Forms,
  uGeraArquivo in 'uGeraArquivo.pas' {frmGeraArquivo},
  Ufuncoes in 'G:\Estoque\ordens_fornec\Fontes\Ufuncoes.pas',
  Encryp in 'Encryp.pas',
  uCarregaSenha in 'uCarregaSenha.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'etiquetas_fornecedores';
  Application.CreateForm(TfrmGeraArquivo, frmGeraArquivo);
  Application.Run;
end.
