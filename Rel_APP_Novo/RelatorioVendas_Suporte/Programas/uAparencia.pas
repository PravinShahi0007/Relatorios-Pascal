{-------------------------------------------------------------------------------
 Programa..: uAparencia
 Empresa...: Grazziotin S/A
 Finalidade: Possibilitar ao usuário escolher o estilo do programa

 Autor    Data     Operação  Descrição
 Antonio  JAN/2021 Criação
-------------------------------------------------------------------------------}
unit uAparencia;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Themes, Vcl.Styles;

type
  TfrmAparencia = class(TForm)
    pnlFundo: TPanel;
    pnlRodapeBotoes: TPanel;
    btnSair: TBitBtn;
    cbxAparencia: TComboBox;
    lblAparencia: TLabel;
    pnlUsuario: TPanel;
    btnOK: TBitBtn;
    procedure CarregaEstilos;
    procedure btnSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbxAparenciaChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAparencia: TfrmAparencia;

implementation

{$R *.dfm}

uses uDtmRelatorioVendas;

procedure TfrmAparencia.CarregaEstilos;
var
   sStyles: String;
begin
     cbxAparencia.Items.BeginUpdate;
     try
        cbxAparencia.Items.Clear;
        for sStyles in TStyleManager.StyleNames do
            cbxAparencia.Items.Add(sStyles);
        cbxAparencia.Sorted :=True;
        cbxAparencia.ItemIndex := cbxAparencia.Items.IndexOf(dtmRelatorioVendas.USUARIO.APARECIA);
     finally
            cbxAparencia.Items.EndUpdate;
     end;
end;

procedure TfrmAparencia.cbxAparenciaChange(Sender: TObject);
begin
     dtmRelatorioVendas.USUARIO.APARECIA := cbxAparencia.Text;
     TStyleManager.TrySetStyle(cbxAparencia.Text);
end;

procedure TfrmAparencia.FormShow(Sender: TObject);
begin
     CarregaEstilos;
     pnlUsuario.Caption := 'Usuário: '+dtmRelatorioVendas.USUARIO.USUARIO;
end;

procedure TfrmAparencia.btnOKClick(Sender: TObject);
begin
     dtmRelatorioVendas.USUARIO.APARECIA := cbxAparencia.Text;
     dtmRelatorioVendas.Escreve_Usuario_INI(Sender);
     Close;
end;

procedure TfrmAparencia.btnSairClick(Sender: TObject);
begin
     Close;
end;

end.
