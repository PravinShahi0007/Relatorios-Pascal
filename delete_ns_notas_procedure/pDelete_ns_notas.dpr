program pDelete_ns_notas;

uses
  Forms,
  uDelete_ns_notas in 'uDelete_ns_notas.pas' {Form1},
  Encryp in 'Encryp.pas',
  uCarregaSenha in 'uCarregaSenha.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Deleta Cupons';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
