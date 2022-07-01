program pAtualizacoes;

uses
  Forms,
  uAtualizacoes in 'uAtualizacoes.pas' {Form1},
  uRelatorio1 in '..\backup Sistema\Sistema\uRelatorio1.pas' {Form2},
  uRelatorio2 in 'uRelatorio2.pas' {Form3},
  uCarregaSenha in 'uCarregaSenha.pas',
  UFunc in 'uFunc.pas',
  uFuncoes in 'uFuncoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
