unit uRelLivroPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.Oracle, FireDAC.Phys.OracleDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.Client, Data.DB, FireDAC.Comp.DataSet, Vcl.ExtCtrls, ppParameter,
  ppDesignLayer, ppCtrls, ppBands, ppClass, ppStrtch, ppMemo, ppVar, ppPrnabl,
  ppCache, ppProd, ppReport, ppDB, ppComm, ppRelatv, ppDBPipe, Vcl.Mask,
  Vcl.Grids, Vcl.Imaging.pngimage, uniGUIBaseClasses, uniGUIClasses, uniImage,
  Vcl.DBGrids;

type
  TfrmLivroPedido = class(TForm)

    edtCodigoInicial: TEdit;
    edtCodigoFinal: TEdit;
    btnVizualizar: TButton;
    sp_relatorios: TFDStoredProc;
    fdOracle: TFDConnection;
    Edit1: TEdit;
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    edtDataFinal: TMaskEdit;
    edtDataInicial: TMaskEdit;
    edtDataPrevistaInicial: TMaskEdit;
    edtDataPrevistaFinal: TMaskEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    btmCancelar: TButton;
    Panel3: TPanel;
    grdLivroPedidos: TStringGrid;
    Memo1: TMemo;
     procedure edtCodigoFinalExit(Sender: TObject);
    procedure edtCodigoInicialExit(Sender: TObject);
    procedure edtDataInicialExit(Sender: TObject);
    procedure edtDataFinalExit(Sender: TObject);
    procedure edtDataPrevistaInicialExit(Sender: TObject);
    procedure edtDataPrevistaFinalExit(Sender: TObject);
    procedure edtDataInicialKeyPress(Sender: TObject; var Key: Char);
    procedure edtDataFinalKeyPress(Sender: TObject; var Key: Char);
    procedure edtDataPrevistaInicialKeyPress(Sender: TObject; var Key: Char);
    procedure edtDataPrevistaFinalKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodigoInicialKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodigoFinalKeyPress(Sender: TObject; var Key: Char);
    procedure btnVizualizarClick(Sender: TObject);
    procedure btmCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdLivroPedidosDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btmCancelarExit(Sender: TObject);
    procedure CarregaParamsBanco;
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLivroPedido: TfrmLivroPedido;
    iNumero,sUsuario,sSenha,sBanco : String;

implementation

uses uFuncoes, Encryp, uCarregaSenha;

{$R *.dfm}


procedure TfrmLivroPedido.CarregaParamsBanco;
var TomEncryption1: TTomEncryption;
begin
    TomEncryption1 := TTomEncryption.Create(Self);
    CarregaSenhasBancoOra('GRZPNL_BERLIN',TomEncryption1,sUsuario,sSenha,sBanco);
end;

procedure TfrmLivroPedido.btmCancelarClick(Sender: TObject);
begin
close;
end;

procedure TfrmLivroPedido.btmCancelarExit(Sender: TObject);
begin
close;
end;

procedure TfrmLivroPedido.btnVizualizarClick(Sender: TObject);
var
 sQtItensLivro , sQItensNovosLivro, sItensNovosCross, sItemNovoEntrar: real;
  iFlag :Integer;

begin

              grdLivroPedidos.Cells[0,0] := ' Quantidade Itens';
              grdLivroPedidos.Cells[1,0] := ' Itens Novos Semana ';
              grdLivroPedidos.Cells[2,0] := ' Itens Novos Cross ';
              grdLivroPedidos.Cells[3,0] := ' Itens Novos p/Entrar ';



       //quantidade de itens de livro de pedido na semana---
    FDQuery1.SQL.Text :=  '';
    FDQuery1.Active := False;

      	  FDQuery1.SQL.Text:= 'select count(distinct a.cod_item) as ItensLivro     '+
                              'from ce_pars_calculo a                 '+
                              ',ie_mascaras b                        '+
                              ',ie_itens ie                          '+
                              ',ps_pessoas p                         '+
                              'where exists (select 1 from ce_estoques ce  '+
                              '               where ce.cod_emp = a.cod_emp '+
                              '                 and ce.cod_unidade = 0       '+
                              '                 and ce.cod_item = a.cod_item   '+
                              '                 and ce.dta_ult_compra is not null) '+
                              'and p.cod_pessoa  = a.cod_unidade  '+
                              'and p.dta_afastamento is null     '+
                              'and ie.cod_item = a.cod_item      '+
                              'and ie.ind_avulso = 0             '+
                              'and upper(ie.des_geral) = ''L''     '+
                              'and ie.cod_tipo = ''00''            '+
                              'and b.cod_item = a.cod_item       '+
                              //'and b.cod_mascara =150           '+
                              'and b.cod_mascara in (150,170)           '+
                              'and b.cod_niv0=''1''                '+
                              'and a.cod_emp = 1                 '+
                              'and nvl(a.qtd_est_min_i,0) > 0    ';

         Memo1.Lines.Add( FDQuery1.SQL.Text)  ;
   FDQuery1.Active := true;

   if ( FDQuery1.RecordCount = 0)then
      begin
      Informacao('Não foi encontrado, itens no intervalo de '+
                    'datas especificado!','Aviso');
      edtDataInicial.SetFocus;
      abort ;
      Exit;
      end;
     sQtItensLivro :=  FDQuery1.FieldByName('ItensLivro').value;


    //itens novos livro da semana----
	  FDQuery1.SQL.Text :=  '';
    FDQuery1.Active := False;

	  FDQuery1.SQL.Text:= ' select count(1) as ItensNovosLivro '+
    		                '	from '+
			                  ' (select a.cod_item '+
			                  ' ,min(a.dta_recebimento)'+
			                  ' ,max(a.dta_recebimento) '+
		                    '	from ne_ficha_compras a '+
	                 		  ' ,ie_mascaras b  '+
	                   	  ' where b.cod_item = a.cod_item'+
		                  //  ' and b.cod_mascara = 150 '+
                                     ' and b.cod_mascara in (150,170) '+
                        ' and b.cod_completo  >=  '''+(edtCodigoInicial.text)+''' '+
                        ' and b.cod_completo <=   '''+(edtCodigoFinal.text)+''' '+
                        ' and b.cod_niv0 = ''1''   '+
		                    ' and a.cod_emp = 1 '+
		                    ' and a.cod_oper = 104  '+
		                    ' and a.dta_recebimento >= sysdate - 730 '+
                        ' having min(a.dta_recebimento) >= '''+(edtDataInicial.text)+''''+
		                    ' and min(a.dta_recebimento) <=  '''+(edtDataFinal.text)+'''' +
		                    ' group by a.cod_item ) item';
     FDQuery1.Active := true;

   if ( FDQuery1.RecordCount = 0)then
      begin
      Informacao('Não foi encontrado, itens no intervalo de '+
                    'datas especificado!','Aviso');
      edtDataInicial.SetFocus;
      abort ;
      Exit;
      end;
     sQItensNovosLivro :=  FDQuery1.FieldByName('ItensNovosLivro').value;

    //itens novos cross da semana----

	 FDQuery1.SQL.Text :=  '';
    FDQuery1.Active := False;

	  FDQuery1.SQL.Text:= ' select count(1) as ItensNovosCross '+
                        ' from  '+
                        ' (select a.cod_item '+
                        ' ,min(a.dta_recebimento) '+
                        ' ,max(a.dta_recebimento) '+
                        ' from ne_ficha_compras a '+
                        ' ,ie_mascaras b  '+
                        ' where b.cod_item = a.cod_item '+
                       // ' and b.cod_mascara = 150 '+
                        ' and b.cod_mascara in (150,170) '+
                        ' and b.cod_completo  >=  '''+(edtCodigoInicial.text)+''' '+
                        ' and b.cod_completo <=   '''+(edtCodigoFinal.text)+''' '+
                        ' and b.cod_niv0 = ''1'' '+
                        ' and a.cod_emp = 1   '+
                        ' and a.cod_oper = 103 '+
                        ' and a.dta_recebimento >= sysdate - 730 '+
                         ' having min(a.dta_recebimento) >= '''+(edtDataInicial.text)+''''+
		                    ' and min(a.dta_recebimento) <=  '''+(edtDataFinal.text)+'''' +
                        ' group by a.cod_item ) item  ';

       FDQuery1.Active := true;

   if ( FDQuery1.RecordCount = 0)then
      begin
      Informacao('Não foi encontrado, itens no intervalo de '+
                    'datas especificado!','Aviso');
      edtDataInicial.SetFocus;
      abort ;
      Exit;
      end;
     sItensNovosCross :=  FDQuery1.FieldByName('ItensNovosCross').value;

    //itens novos de livro para entrar nos próximos 30 dias----

	 FDQuery1.SQL.Text :=  '';
    FDQuery1.Active := False;

	  FDQuery1.SQL.Text:= ' Select count(distinct oc.cod_item) as ItemNovoEntrar  '+
				             	  '	from '+
	                  	  ' (select b.cod_item  '+
                        ' ,sum(nvl(c.qtd_prev_entr,0)) qtd_comprada '+
		                  	' ,sum(nvl(d.qtd_recebida,0)) qtd_recebida '+
	                      ' from ac_ordens_compra a  '+
	                      ' ,ac_itens_oc b  '+
	                      ' ,ac_parcs_itens c  '+
	                      ' ,ac_recebimentos_oc d  '+
	                      ' ,ie_mascaras e   '+
	                      '	where not exists (select 1 from ne_ficha_compras ne  '+
				                ' where ne.cod_item = b.cod_item  '+
			                  ' and ne.dta_recebimento >= sysdate - 730)  '+
                        ' and e.cod_item = b.cod_item  '+
		                 //  ' and e.cod_mascara = 150 '+
                                     ' and e.cod_mascara in (150,170) '+
                        ' and e.cod_completo  >=  '''+(edtCodigoInicial.text)+''' '+
                        ' and e.cod_completo <=   '''+(edtCodigoFinal.text)+''' '+
		                    ' and d.num_seq(+)      = b.num_seq '+
		                  	'	and d.cod_maquina(+)  = b.cod_maquina '+
                        ' and d.num_seq_item(+) = b.num_seq_item  '+
			                	' and nvl(d.tip_atendimento,2) in (1,2)  '+
				                ' and c.num_seq         = b.num_seq  '+
			                  ' and c.cod_maquina     = b.cod_maquina   '+
			                	' and c.num_seq_item    = b.num_seq_item  '+
			                	' and c.dta_prev_entr  >=  '''+(edtDataPrevistaInicial.text)+''''+
			                	' and c.dta_prev_entr  <=  '''+(edtDataPrevistaFinal.text)+''''+
				                ' and b.num_seq         = a.num_seq    '+
		                		' and b.cod_maquina     = a.cod_maquina '+
		                    ' and a.tip_status      = 1 '+
		                    ' and a.tip_situacao    = 1 '+
			                	' and a.cod_oper        = 104  '+
			                	' and a.cod_unidade    IN (818,838,848,858) '+
		                    ' having (sum(nvl(c.qtd_prev_entr,0)) - sum(nvl(d.qtd_recebida,0))) > 0 '+
		                  	' group by b.cod_item ) oc';

                FDQuery1.Active := true;

           if ( FDQuery1.RecordCount = 0)then
              begin
              Informacao('Não foi encontrado, itens no intervalo de '+
                            'datas especificado!','Aviso');
              edtDataInicial.SetFocus;
              abort ;
              Exit;
              end;
             sItemNovoEntrar :=  FDQuery1.FieldByName('ItemNovoEntrar').value;

              grdLivroPedidos.Cells[0,1] := FormatFloat('#,###',sQtItensLivro);
              grdLivroPedidos.Cells[1,1]  := FormatFloat('#,###',sQItensNovosLivro);
              grdLivroPedidos.Cells[2,1] := FormatFloat('#,###',sItensNovosCross);
              grdLivroPedidos.Cells[3,1] := FormatFloat('#,###',sItemNovoEntrar);


end;

procedure TfrmLivroPedido.edtCodigoFinalExit(Sender: TObject);
begin
 if edtCodigoFinal.Text = '' then
          edtCodigoFinal.Text := '9999999999';

    if edtCodigoFinal.Text = '' then
     begin
         Informacao('Código  Final deve ser informado!','Aviso');
          edtCodigoFinal.SetFocus;
          Abort ;
          Exit;
     end;
      edtCodigoFinal.Text := edtCodigoFinal.Text;

end;

procedure TfrmLivroPedido.edtCodigoFinalKeyPress(Sender: TObject; var Key: Char);
var
codigo : boolean;
begin

    case Key of
           '0'..'9' : codigo := true;
       //    ',' : Codigo := True;
           chr(13) : btnVizualizar.SetFocus; //enter
           chr(9)  : Codigo  := True; //Tab
           chr(27) : Codigo  := True; //esc
           chr(8)  : Codigo  := True; //Backspace
      else
        Codigo := False;
    end;

end;

procedure TfrmLivroPedido.edtCodigoInicialExit(Sender: TObject);
begin
 if edtCodigoInicial.Text = '' then
          edtCodigoInicial.Text := '0000000000';

      if edtCodigoInicial.Text = '' then
     begin
          Informacao('Código  Incial deve ser informado!','Aviso');
          edtCodigoInicial.SetFocus;
          Abort;
          Exit;
     end;

      edtCodigoInicial.Text := edtCodigoInicial.Text;
end;


procedure TfrmLivroPedido.edtCodigoInicialKeyPress(Sender: TObject; var Key: Char);
var
codigo : boolean;
begin



    case Key of
           '0'..'9' : codigo := true;
       //    ',' : Codigo := True;
           chr(13) : edtCodigoFinal.SetFocus; //enter
           chr(9)  : Codigo  := True; //Tab
           chr(27) : Codigo  := True; //esc
           chr(8)  : Codigo  := True; //Backspace
      else
        Codigo := False;
    end;

end;



procedure TfrmLivroPedido.edtDataFinalExit(Sender: TObject);
begin
 KeyPreview := True;
         if (AllTrim(edtDataFinal.Text) = '//') then
         begin
              Informacao('Período Final não informado !!!','Aviso...');
              edtDataFinal.SetFocus;
              Abort;
              Exit;
         end;

         if ValidaData(edtDataFinal.Text) then
         begin
              edtDataFinal.SetFocus;
              Abort;
              Exit;
         end;




         if StrToDate(edtDataFinal.Text) < StrToDate(edtDataInicial.Text) then
             begin
                  Informacao('Período Final  menor que Período Inicial!!!','Aviso...');
                  edtDataInicial.SetFocus;
                  Abort;
                  Exit;
             end;



         edtDataFinal.Text := DateToStr(StrToDate(edtDataFinal.Text));
end;


procedure TfrmLivroPedido.edtDataFinalKeyPress(Sender: TObject; var Key: Char);
var
codigo : boolean;
begin



    case Key of
           '0'..'9' : codigo := true;
       //    ',' : Codigo := True;
           chr(13) : edtDataPrevistaInicial.SetFocus; //enter
           chr(9)  : Codigo  := True; //Tab
           chr(27) : Codigo  := True; //esc
           chr(8)  : Codigo  := True; //Backspace
      else
        Codigo := False;
    end;

end;
procedure TfrmLivroPedido.edtDataInicialExit(Sender: TObject);
begin
     KeyPreview := True;
        if (AllTrim(edtDataInicial.Text) = '//') then
         begin
              Informacao('Período Inicial não informado !!!','Aviso...');
              edtDataInicial.SetFocus;
              Abort;
              Exit;
         end;

        if ValidaData(edtDataInicial.Text) then
         begin
              edtDataInicial.SetFocus;
              Abort;
              Exit;
         end;

          edtDataInicial.Text := DateToStr(StrToDate(edtDataInicial.Text));
end;



procedure TfrmLivroPedido.edtDataInicialKeyPress(Sender: TObject; var Key: Char);
var
codigo : boolean;
begin

    case Key of
           '0'..'9' : codigo := true;
       //    ',' : Codigo := True;
           chr(13) : edtDataFinal.SetFocus; //enter
           chr(9)  : Codigo  := True; //Tab
           chr(27) : Codigo  := True; //esc
           chr(8)  : Codigo  := True; //Backspace
      else
        Codigo := False;
    end;

end;
procedure TfrmLivroPedido.edtDataPrevistaFinalExit(Sender: TObject);
begin
    KeyPreview := True;
         if (AllTrim(edtDataPrevistaFinal.Text) = '//') then
         begin
              Informacao('Período Final não informado !!!','Aviso...');
              edtDataPrevistaFinal.SetFocus;
              Abort;
              Exit;
         end;

         if ValidaData(edtDataPrevistaFinal.Text) then
         begin
              edtDataPrevistaFinal.SetFocus;
              Abort;
              Exit;
         end;



               if StrToDate(edtDataPrevistaFinal.Text) < StrToDate(edtDataPrevistaInicial.Text) then
             begin
                  Informacao('Período Final  menor que Período Inicial!!!','Aviso...');
                  edtDataPrevistaInicial.SetFocus;
                  Abort;
                  Exit;
             end;


         edtDataPrevistaFinal.Text := DateToStr(StrToDate(edtDataPrevistaFinal.Text));
end;

procedure TfrmLivroPedido.edtDataPrevistaFinalKeyPress(Sender: TObject; var Key: Char);
var
codigo : boolean;
begin
      case Key of
           '0'..'9' : codigo := true;
       //    ',' : Codigo := True;
           chr(13) : edtCodigoInicial.SetFocus; //enter
           chr(9)  : Codigo  := True; //Tab
           chr(27) : Codigo  := True; //esc
           chr(8)  : Codigo  := True; //Backspace
      else
        Codigo := False;
    end;

end;

procedure TfrmLivroPedido.edtDataPrevistaInicialExit(Sender: TObject);
begin
  KeyPreview := True;
        if (AllTrim(edtDataPrevistaInicial.Text) = '//') then
         begin
              Informacao('Período Inicial não informado !!!','Aviso...');
              edtDataPrevistaInicial.SetFocus;
              Abort;
              Exit;
         end;

        if ValidaData(edtDataPrevistaInicial.Text) then
         begin
              edtDataPrevistaInicial.SetFocus;
              Abort;
              Exit;
         end;

          edtDataPrevistaInicial.Text := DateToStr(StrToDate(edtDataPrevistaInicial.Text));
end;

procedure TfrmLivroPedido.edtDataPrevistaInicialKeyPress(Sender: TObject; var Key: Char);
var
codigo : boolean;
begin

    case Key of
           '0'..'9' : codigo := true;
       //    ',' : Codigo := True;
           chr(13) : edtDataPrevistaFinal.SetFocus; //enter
           chr(9)  : Codigo  := True; //Tab
           chr(27) : Codigo  := True; //esc
           chr(8)  : Codigo  := True; //Backspace
      else
        Codigo := False;
    end;

end;

procedure TfrmLivroPedido.FormCreate(Sender: TObject);
begin
   CarregaParamsBanco;
    try
     fdOracle.Params.Database := sBanco;
     fdOracle.Params.UserName := sUsuario;
     fdOracle.Params.Password := sSenha;
     fdOracle.Connected := True;
   except
       on E:EDatabaseError do
            begin
                 Informacao('Erro!!!'+#13+'Não pode se conectar ao banco!!!','Aviso!!!');
                 Application.Terminate;
            end;
   end;
    try
      fdOracle.Connected := True;
      //Session1.Active := True;
    except
      Informacao('Erro!!!'+#13+'Não pode se conectar ao banco!!!','Aviso!!!');
      Application.Terminate;
    end;
end;

procedure TfrmLivroPedido.FormShow(Sender: TObject);
begin

  grdLivroPedidos.ColWidths[0] := 100;
  grdLivroPedidos.ColWidths[1] := 130;
    grdLivroPedidos.ColWidths[2] := 106;
   grdLivroPedidos.ColWidths[3] := 120;

end;

procedure TfrmLivroPedido.grdLivroPedidosDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
     if ( UpperCase(grdLivroPedidos.Cells[0,0]) = '') then         //primeira linha em negrito
       begin
            grdLivroPedidos.Canvas.Font.Color :=  clBlack;
        end ;


end;

end.
