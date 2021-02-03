{-------------------------------------------------------------------------------
 Programa..: uConfiguracaoINI
 Empresa...: Grazziotin S/A
 Finalidade: Configuração da conexão, usuário e senha da base de dados;
             aparência do programa por usuário.

 Autor    Data     Operação  Descrição
 Antonio  JAN/2021 Criação
-------------------------------------------------------------------------------}
unit uConfiguracaoINI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Mask, Vcl.Themes;

type
  TfrmConfiguracaoINI = class(TForm)
    pnlBotoes: TPanel;
    pnlConexao: TPanel;
    btnGravar: TBitBtn;
    btnAlterar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    pnlUsuario: TPanel;
    pnlFundoConexao: TPanel;
    pnlFundoUsuario: TPanel;
    lblBase: TLabel;
    Label2: TLabel;
    lblSenha: TLabel;
    lblAparencia: TLabel;
    cbxEstilos: TComboBox;
    edtBase: TMaskEdit;
    edtUsuario: TMaskEdit;
    edtSenha: TMaskEdit;
    procedure Habilita_Desabilita_Campos(Estado : String);
    procedure Controle_Botoes(Estado : String );
    procedure CarregaEstilos;
    procedure cbxEstilosChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbxEstilosEnter(Sender: TObject);
    procedure cbxEstilosExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sAcaoConfiguracao: String;
  end;

var
  frmConfiguracaoINI: TfrmConfiguracaoINI;

implementation

{$R *.dfm}

uses uDtmRelatorioVendas;

procedure TfrmConfiguracaoINI.Habilita_Desabilita_Campos(Estado : String);
begin
     edtBase.Enabled  := (Estado <> 'INATIVO');
     edtBase.TabStop  := (Estado <> 'INATIVO');
     edtBase.ReadOnly := (Estado = 'INATIVO');

     edtUsuario.Enabled  := (Estado <> 'INATIVO');
     edtUsuario.TabStop  := (Estado <> 'INATIVO');
     edtUsuario.ReadOnly := (Estado = 'INATIVO');

     edtSenha.Enabled  := (Estado <> 'INATIVO');
     edtSenha.TabStop  := (Estado <> 'INATIVO');
     edtSenha.ReadOnly := (Estado = 'INATIVO');

     cbxEstilos.Enabled  := (Estado <> 'INATIVO');
     cbxEstilos.TabStop  := (Estado <> 'INATIVO');
end;

procedure TfrmConfiguracaoINI.Controle_Botoes(Estado : String );
begin
     btnGravar.Enabled := not (Estado = 'INATIVO');
     btnAlterar.Enabled := (Estado = 'INATIVO');
     btnCancelar.Enabled := not (Estado = 'INATIVO');
end;

procedure TfrmConfiguracaoINI.btnAlterarClick(Sender: TObject);
begin
     sAcaoConfiguracao := 'ALTERAR';
     Controle_Botoes(sAcaoConfiguracao);
     Habilita_Desabilita_Campos(sAcaoConfiguracao);
     edtBase.SetFocus;
end;

procedure TfrmConfiguracaoINI.btnCancelarClick(Sender: TObject);
begin
     sAcaoConfiguracao := 'INATIVO';
     Controle_Botoes(sAcaoConfiguracao);
     Habilita_Desabilita_Campos(sAcaoConfiguracao);
     btnSair.SetFocus;
end;

procedure TfrmConfiguracaoINI.btnGravarClick(Sender: TObject);
begin
     // Transfere dados...
     dtmRelatorioVendas.ARQUIVOINI.BASEDADOS := Trim(edtBase.Text);
     dtmRelatorioVendas.ARQUIVOINI.USUARIO := Trim(edtUsuario.Text);
     dtmRelatorioVendas.ARQUIVOINI.SENHA := Trim(edtSenha.Text);
     dtmRelatorioVendas.USUARIO.APARECIA := Trim(cbxEstilos.Items[cbxEstilos.ItemIndex]);

     dtmRelatorioVendas.Escreve_Dados_INI(Sender);

     sAcaoConfiguracao := 'INATIVO';
     Controle_Botoes(sAcaoConfiguracao);
     Habilita_Desabilita_Campos(sAcaoConfiguracao);
end;

procedure TfrmConfiguracaoINI.btnSairClick(Sender: TObject);
begin
     Close;
end;

procedure TfrmConfiguracaoINI.CarregaEstilos;
var
   sStyles: String;
begin
     cbxEstilos.Items.BeginUpdate;
     try
        cbxEstilos.Items.Clear;
        for sStyles in TStyleManager.StyleNames do
            cbxEstilos.Items.Add(sStyles);
        cbxEstilos.Sorted :=True;
        cbxEstilos.ItemIndex := cbxEstilos.Items.IndexOf(dtmRelatorioVendas.USUARIO.APARECIA);
     finally
            cbxEstilos.Items.EndUpdate;
     end;
end;

procedure TfrmConfiguracaoINI.cbxEstilosChange(Sender: TObject);
begin
      //TStyleManager.TrySetStyle(cbxEstilos.Items[cbxEstilos.ItemIndex]);
      dtmRelatorioVendas.USUARIO.APARECIA := cbxEstilos.Text;
      TStyleManager.TrySetStyle(cbxEstilos.Text);
end;

procedure TfrmConfiguracaoINI.cbxEstilosEnter(Sender: TObject);
begin
     KeyPreview := False;
end;

procedure TfrmConfiguracaoINI.cbxEstilosExit(Sender: TObject);
begin
     KeyPreview := True;
end;

procedure TfrmConfiguracaoINI.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     case Key of
          VK_RETURN, VK_DOWN: Perform(WM_NEXTDLGCTL,0,0);
          VK_UP, VK_F12     : Perform(WM_NEXTDLGCTL,0,1);
     end;
end;

procedure TfrmConfiguracaoINI.FormShow(Sender: TObject);
begin
     pnlUsuario.Caption := '  Usuário: '+dtmRelatorioVendas.USUARIO.USUARIO;
     edtBase.Text := dtmRelatorioVendas.ARQUIVOINI.BASEDADOS;
     edtUsuario.Text := dtmRelatorioVendas.ARQUIVOINI.USUARIO;
     edtSenha.Text := dtmRelatorioVendas.ARQUIVOINI.SENHA;

     Controle_Botoes(sAcaoConfiguracao);
     Habilita_Desabilita_Campos(sAcaoConfiguracao);


     CarregaEstilos;
end;

end.
