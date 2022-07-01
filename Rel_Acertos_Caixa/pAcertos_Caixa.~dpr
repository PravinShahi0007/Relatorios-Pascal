program pAcertos_Caixa;

uses
  Forms,
  Windows,
  Messages,
  Dialogs,
  SysUtils,
  uRel_Acertos_Caixa in 'uRel_Acertos_Caixa.pas' {frmRel_Prod_CD},
  uFunc in 'uFunc.pas',
  uFuncoes in 'uFuncoes.pas',
  uCarregaSenha in 'uCarregaSenha.pas';

{$R *.res}

var
  H: integer;

begin
  //Não permite abrir o sistem mais de uma vez
  ThousandSeparator := #0;
  H := CreateMutex(nil, False, 'Rel. Produt. Diário');
  if WaitForSingleObject(H, 0) <> Wait_TimeOut then
  begin
     Application.Initialize;
     Application.Title := 'Rel. Produt. Diário';
     Application.CreateForm(TfrmRel_Prod_CD, frmRel_Prod_CD);
  Application.Run;
     Application.Terminate;
  end
  else
  begin
    Application.MessageBox('VOCÊ NÃO PODE ABRIR NOVAMENTE O' + #13 +
                           'RELATÓRIO DE PRODUTIVIDADE DAS' + #13 +
                           'CENTRAIS DE DEPÓSITOS!!!','Aviso...', MB_APPLMODAL + MB_ICONSTOP + MB_OK);
    Application.Terminate;
  end;
end.
