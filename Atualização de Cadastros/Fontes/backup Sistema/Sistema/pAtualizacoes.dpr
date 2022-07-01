program pAtualizacoes;

uses
  Forms,
  uAtualizacoes in '..\..\Sistema\uAtualizacoes.pas' {Form1},
  uRelatorio1 in 'uRelatorio1.pas' {Form2},
  uRelatorio2 in '..\..\Sistema\uRelatorio2.pas' {Form3},
  uCarregaSenha in '..\..\Sistema\uCarregaSenha.pas',
  UFunc in '..\..\Sistema\uFunc.pas',
  uFuncoes in '..\..\Sistema\uFuncoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
