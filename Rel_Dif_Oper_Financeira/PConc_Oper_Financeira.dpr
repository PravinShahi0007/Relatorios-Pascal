program PConc_Oper_Financeira;

uses
  Forms,
  UConc_Oper_Financeira in 'UConc_Oper_Financeira.pas' {frmConc_Oper_Financeira},
  UFunc in 'UFunc.pas',
  UFuncoes in 'UFuncoes.pas',
  uCarregaSenha in 'uCarregaSenha.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Conciliação de Operações Financeiras';
  Application.CreateForm(TfrmConc_Oper_Financeira, frmConc_Oper_Financeira);
  Application.run;
//  Application.Terminate;

end.
