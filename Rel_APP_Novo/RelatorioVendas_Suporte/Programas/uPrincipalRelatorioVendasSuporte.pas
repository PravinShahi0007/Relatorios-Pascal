{-------------------------------------------------------------------------------
 Programa..: uPrincipalRelatorioVendasSuporte
 Empresa...: Grazziotin S/A
 Finalidade: Tela inicial do sistema, com informações de login e menu inicial

 Autor    Data     Operação  Descrição
 Antonio  JAN/2021 Criação
-------------------------------------------------------------------------------}
unit uPrincipalRelatorioVendasSuporte;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.Menus, Vcl.WinHelpViewer, Vcl.AppEvnts;

type
  TfrmPrincipalRelatorioVendas = class(TForm)
    pnlFundoBotoes: TPanel;
    btnAtualizar: TBitBtn;
    btnConfiguracao: TBitBtn;
    btnSair: TBitBtn;
    btnUsuario: TBitBtn;
    pnlUsuario: TPanel;
    pumClienteAVista: TPopupMenu;
    mniAtualizar: TMenuItem;
    mniConfiguracao: TMenuItem;
    mniUsuario: TMenuItem;
    mniSair: TMenuItem;
    procedure btnSairClick(Sender: TObject);
    procedure btnUsuarioClick(Sender: TObject);
    procedure btnConfiguracaoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipalRelatorioVendas: TfrmPrincipalRelatorioVendas;

implementation

{$R *.dfm}

uses uAparencia, uConfiguracaoINI, uRelatorioVendas, uDtmRelatorioVendas,
  uFuncoes;

procedure TfrmPrincipalRelatorioVendas.btnUsuarioClick(Sender: TObject);
var
   Formulario: TfrmAparencia;
begin
     Formulario := TfrmAparencia.Create(Self);
     Formulario.ShowModal;
     Formulario.Free;
end;

procedure TfrmPrincipalRelatorioVendas.btnAtualizarClick(Sender: TObject);
var
   Formulario: TfrmRelatorioVendas;
begin
     Formulario := TfrmRelatorioVendas.Create(Self);
     Formulario.ShowModal;
     Formulario.Free;
end;

procedure TfrmPrincipalRelatorioVendas.btnConfiguracaoClick(
  Sender: TObject);
var
   Formulario: TfrmConfiguracaoINI;
begin
     Formulario := TfrmConfiguracaoINI.Create(Self);
     Formulario.sAcaoConfiguracao := 'INATIVO';
     Formulario.ShowModal;
     Formulario.Free;
end;

procedure TfrmPrincipalRelatorioVendas.btnSairClick(Sender: TObject);
begin
     Close;
end;

procedure TfrmPrincipalRelatorioVendas.FormShow(Sender: TObject);
begin
     pnlUsuario.Caption :=  '  Usuário: '+dtmRelatorioVendas.USUARIO.USUARIO;
end;

end.
