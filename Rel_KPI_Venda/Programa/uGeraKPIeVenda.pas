{ -------------------------------------------------------------------------------
  Programa..: uGeraKPIeVenda
  Empresa...: Grazziotin S/A
  Finalidade: Gerar valores para a consulta de KPI Venda.
  � executado (autom�tico) no agendamento do WINDOWS.

  Autor   Data     Opera��o  Descri��o
  ??????? ???/???? Cria��o
  Ant�nio MAI/2021 Altera��o Formata��o do c�digo-fonte. Altera��es para que o
                             programa possa ser agendado (no WINDOWS) e tenha
                             sua execu��o "autom�tica"
  ------------------------------------------------------------------------------- }
unit uGeraKPIeVenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, Buttons, Mask, ExtCtrls, Encryp, uFuncoes,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.Oracle, FireDAC.Phys.OracleDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, DateUtils,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Themes, Vcl.Styles;

type
  TfrmGeraKPI = class(TForm)
    pnlFundo: TPanel;
    fdcBancoDados: TFDConnection;
    sp_Venda_Diaria_Cidade: TFDStoredProc;
    grpParametros: TGroupBox;
    lblUnidade: TLabel;
    lblEmpresa: TLabel;
    lblDatas: TLabel;
    lblParametroEmpresa: TLabel;
    edtUnidadeInicial: TMaskEdit;
    lblUnidadeAte: TLabel;
    edtUnidadeFinal: TMaskEdit;
    edtDataInicial: TMaskEdit;
    lblDatasAte: TLabel;
    edtDataFinal: TMaskEdit;
    pnlBotoes: TPanel;
    btnGerar: TBitBtn;
    btnSair: TBitBtn;
    lblMensagem: TLabel;
    procedure PreencheEstilos(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CarregaParamsBanco;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    aEstilos: array of String;
    mmoEstilos: TMemo;
    iEstilos: Integer;
  end;

var
  frmGeraKPI: TfrmGeraKPI;
  sUsuario, sBanco, sSenha: String;
  iNumero: Integer;

implementation

{$R *.dfm}

uses uCarregaSenha;

procedure TfrmGeraKPI.PreencheEstilos(Sender: TObject);
var
   sEstilos: String;
   iInd: Integer;
begin
     mmoEstilos := TMemo.Create(Self);
     mmoEstilos.Parent := Self;
     mmoEstilos.Name := 'mmoEstilos'; // Caso vc queira nome�-lo
     mmoEstilos.Visible := False;

     mmoEstilos.Lines.Clear;

     for sEstilos in TStyleManager.StyleNames do
         mmoEstilos.Lines.Add(sEstilos);

     iEstilos := mmoEstilos.Lines.Count;
     SetLength(aEstilos, iEstilos);

     for iInd := 0 to iEstilos do
         aEstilos[iInd] := mmoEstilos.Lines[iInd];

     Randomize;
     iEstilos := Random(40);

     TStyleManager.TrySetStyle(aEstilos[iEstilos]);
end;

procedure TfrmGeraKPI.btnSairClick(Sender: TObject);
begin
     Close;
end;

procedure TfrmGeraKPI.btnGerarClick(Sender: TObject);
var
   sParametros: string;
begin
     lblMensagem.Caption := 'Aguarde... Gerando dados...';
     lblMensagem.Update;
     Delay(1000);
     try
        sParametros := '1' + '#' + edtDataInicial.Text + '#' + edtDataFinal.Text +
                       '#' + edtUnidadeInicial.Text + '#' + edtUnidadeFinal.Text + '#';

        sp_Venda_Diaria_Cidade.Close;
        sp_Venda_Diaria_Cidade.StoredProcName := 'GRZ_REL_KPI_VENDA';
        // nome da rotina que vai executar
        sp_Venda_Diaria_Cidade.Prepare; // prepara a conexao
        sp_Venda_Diaria_Cidade.Params[0].Value := sParametros;
        // passa os parametros de entrada
        sp_Venda_Diaria_Cidade.ExecProc; // executa a procedure, rotina

        lblMensagem.Caption := 'Gerado com SUCESSO!';
        lblMensagem.Update;
        Delay(3000);
        Close;
     except
           on e: exception do
           begin
                ShowMessage(e.Message);
                Delay(2000);
                Exit;
           end;
     end;
end;

procedure TfrmGeraKPI.FormActivate(Sender: TObject);
begin
     btnGerarClick(Sender);
end;

procedure TfrmGeraKPI.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     try
        if fdcBancoDados.Connected then
           fdcBancoDados.Connected := False;
     except
           lblMensagem.Caption := 'Erro Banco! Tente Novamente!';
           Abort;
           Close;
     end;
end;

procedure TfrmGeraKPI.FormCreate(Sender: TObject);
var
   dtDataAtual, dtDataInicial, dtDataFinal, dtDataAuxiliar: TDate;
   wDia, wMes, wAno: Word;
begin
     PreencheEstilos(Sender);
     //CarregaParamsBanco;
     {try
        fdcBancoDados.Params.Database := sBanco;
        fdcBancoDados.Params.UserName := sUsuario;
        fdcBancoDados.Params.Password := sSenha;
        fdcBancoDados.Connected := True;
     except
           on e: EDatabaseError do
           begin
                lblMensagem.Caption := 'Falha ao conectar o banco ' + #13 +
                                       'a aplica��o vai fechar!' + #13 + e.Message;
                Application.Terminate;
           end;
     end;}

     lblMensagem.Caption := '';

     edtUnidadeInicial.Text := '0000';
     edtUnidadeFinal.Text := '9999';

     dtDataAtual := Date;
     dtDataInicial := StrToDate('01' + Copy(DateToStr(dtDataAtual), 3, 8));
     dtDataFinal := dtDataAtual - 1;

     // Se a data atual � o 1� dia, a data final fica sendo o ultimo dia do m�s
     //  anterior e ocorre a "invers�o" das datas
     if (dtDataInicial > dtDataFinal) then
     begin
          dtDataAuxiliar := dtDataInicial;
          dtDataInicial := dtDataFinal;
          dtDataFinal := dtDataAuxiliar;
     end;

     // Ultimo dia do mes
     // DecodeDate(dtDataAtual, wDia, wMes, wAno);
     // wDia := Ultimo_Dia(wMes, wAno);
     // dtDataFinal := EncodeDate(wAno,wMes,wDia);
     // Dia anterior

     edtDataInicial.Text := DateToStr(dtDataInicial);
     edtDataFinal.Text := DateToStr(dtDataFinal);
end;

procedure TfrmGeraKPI.CarregaParamsBanco;
var
   TomEncryption1: TTomEncryption;
begin
     TomEncryption1 := TTomEncryption.Create(Self);
     CarregaSenhasBancoOra('GRZPNL_BERLIN', TomEncryption1, sUsuario,
                           sSenha, sBanco);
end;

end.
