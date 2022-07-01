program PConc_Pag_Financeira;

uses
  Forms,
  UConc_Pag_Financeira in 'UConc_Pag_Financeira.pas' {frmConc_Pag_Financeira},
  UFunc in 'UFunc.pas',
  UFuncoes in 'UFuncoes.pas',
  uCarregaSenha in 'uCarregaSenha.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Conciliação de Pagamentos Financeiros';
  Application.CreateForm(TfrmConc_Pag_Financeira, frmConc_Pag_Financeira);
  Application.Run;
end.
