program pLivroPedidos;

uses
  Vcl.Forms,
  uRelLivroPedidos in 'uRelLivroPedidos.pas' {frmLivroPedido},
  uCarregaSenha in 'uCarregaSenha.pas',
  Encryp in 'Encryp.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLivroPedido, frmLivroPedido);
  Application.Run;
end.
