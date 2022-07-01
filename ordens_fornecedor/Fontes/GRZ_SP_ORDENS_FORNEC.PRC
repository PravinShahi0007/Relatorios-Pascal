CREATE OR REPLACE PROCEDURE GRZ_SP_ORDENS_FORNEC
  (PI_OPCAO IN VARCHAR2
  ,PO_FORNEC out VARCHAR2)
  IS
  BEGIN
  DECLARE
 	  pi_unidade                NUMBER;
	  pi_ordem                  NUMBER;
	  pi_pessoa		    NUMBER;
	  pi_usuario		    VARCHAR2(30);
	  pi_mascara       NUMBER;
	  
	  wi			    NUMBER;
	  wf  			    NUMBER;
	  	  
	  wNum_seq		    NUMBER;
	  wCod_pessoa		    NUMBER;
	  wDes_pessoa		    VARCHAR2(50);
	  wSemana		    NUMBER;
	  wCod_lista	            NUMBER;
	  wCod_completo	 	    VARCHAR2(12);
	  wCod_rede 		    VARCHAR2(02);
	  wDes_rede 		    VARCHAR2(20);
	  wDes_item		    VARCHAR2(30);
	  wIncremento               NUMBER(06) := 0;
	  wvlr_tamanho        	VARCHAR2(3);
	  wDesMarca            VARCHAR2(50);
	  wDesEnderecoLoja  VARCHAR2(50);
	  
	    
	  CURSOR c_itens IS
		select it.num_seq
		      ,it.num_seq_item
		      ,it.cod_item
		      ,pa.qtd_prev_entr
		  from ac_itens_oc it
		      ,ac_parcs_itens pa
		 where it.num_seq      = pa.num_seq
		   and it.num_seq_item = pa.num_seq_item
		   and it.num_seq      = wNum_Seq;
 	  r_itens c_itens%ROWTYPE;

	  CURSOR c_precos IS
		select max(dta_inicio) as dta_inicio
       		      ,vlr_item 
  		  from lp_precos
 	         where cod_item  = r_itens.cod_item
   	           and cod_lista = to_number(wCod_rede)
                 group by vlr_item
 		 order by dta_inicio desc;
 	  r_precos c_precos%ROWTYPE;

          BEGIN
	        wi := INSTR(pi_opcao, '#', 1, 1);
	        pi_unidade := TO_NUMBER(SUBSTR(pi_opcao, 1,(wi-1)));
	        wf := INSTR(pi_opcao, '#', 1, 2);
	        pi_ordem := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	        wi := wf;
	        wf := INSTR(pi_opcao, '#', 1, 3);
	        pi_pessoa := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	        wi := wf;
	        wf := INSTR(pi_opcao, '#', 1, 4);
	        pi_usuario := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));
			wi := wf;
	        wf := INSTR(pi_opcao, '#', 1, 5);
			pi_mascara := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));

		delete from grzw_ordens_fornec
		 where upper(des_usuario)=upper(pi_usuario);
		commit;

      	        begin	
		     select num_seq
		           ,to_char(cod_pessoa)
		       into wNum_seq
		           ,wCod_pessoa
		       from ac_ordens_compra
		      where cod_emp          = 1
			and cod_unidade      = pi_unidade
		        and num_ordem_compra = pi_ordem
		        and cod_pessoa       = pi_pessoa;
		    EXCEPTION
		     	when no_data_found then
		       	     wNum_seq    := 0;
		       	     wCod_pessoa := 0;
		end;

		/*
		begin
		     select des_pessoa
		       into PO_FORNEC
		       from ps_pessoas
          	      where cod_gu     = 1
          	        and cod_pessoa = wCod_pessoa;
		    EXCEPTION
		     	when no_data_found then
		       	     PO_FORNEC := 'FORNECEDOR SEM DESCRICAO';
		end;

		PO_FORNEC := PO_FORNEC||'#'||lPad(wCod_pessoa,7,'0');
		*/
		
		begin
		     select round((trunc(sysdate)-to_date('01/01/'||to_char(sysdate,'yyyy'),'dd/mm/yyyy'))/7+1,0)||substr(to_char(sysdate,'yyyy'),4,4)
		       into wSemana
		       from dual
		end;

	        OPEN c_itens;
	        FETCH c_itens INTO r_itens;
	        WHILE c_itens%FOUND LOOP
	        BEGIN
   		     begin
   		          select a.cod_completo,b.cod_niv3
   		            into wCod_completo,wvlr_tamanho
   		            from ie_mascaras a,ie_mascaras b
  			   where a.cod_item = b.cod_item(+)
			         and a.cod_mascara = pi_mascara
					 and b.cod_mascara(+) = 155
    			     and a.cod_item    = r_itens.cod_item;
    			 EXCEPTION
			     when no_data_found then
			     	wCod_completo := '0000000000';
					wvlr_tamanho := '';
   		     end;

   		     wCod_rede     := substr(wCod_completo,1,2);
   		     wCod_completo := substr(wCod_completo,3,10);
		     
		     wIncremento := wIncremento + 1;
		     
		     OPEN c_precos;
	             FETCH c_precos INTO r_precos;
   		     
   		     if wCod_rede = '10' then
                           wDes_rede := 'GRAZZIOTIN';
                       elsif wCod_rede = '20' then
                             wDes_rede := 'TECH BOX';
                         elsif wCod_rede = '30' then
                               wDes_rede := 'PORMENOS';
		            elsif  wCod_rede = '40' then
                                  wDes_rede := 'FRANCO GIORGI';
                               elsif wCod_rede = '50' then
                                     wDes_rede := 'TOTTAL';
                                  elsif wCod_rede = '60' then
                                       wDes_rede := 'VIA RAQUELLE';
		     else
		         wDes_rede := 'REDE SEM DESCRICAO';
		     end if;

  		     begin
	      	 	  select SUBSTR(des_item,1,30)
	      	 	    into wDes_item
  			    from ie_descricoes
 	         	   where cod_item  = r_itens.cod_item
 	         	     and cod_grupo = 1;
    			 EXCEPTION
			     when no_data_found then
			     	wDes_item := 'sem';
   		     end;
   		     
   		     if wDes_item = 'sem' then
   		            begin
		      	 	  select SUBSTR(des_item,1,30)
		      	 	    into wDes_item
				    from ie_itens
		         	   where cod_item = r_itens.cod_item;
				 EXCEPTION
				     when no_data_found then
				     	wDes_item := 'ITEM SEM DESCRICAO';
			     end;
   		     end if;			 	

			begin
			      select vlr_coluna into wDesMarca
 				  from ie_colunas where cod_item = r_itens.cod_item and seq_coluna =5;
			exception
		     	when no_data_found then
				        wDesMarca := '';
			end;
			
			begin
			      select vlr_coluna into wDesEnderecoLoja
 				  from ie_colunas where cod_item = r_itens.cod_item and seq_coluna =6;
			exception
		     	when no_data_found then
				        wDesEnderecoLoja := '';
			end;
			 
			 
			 
   		     
   		     insert into grzw_ordens_fornec(des_usuario
   		                       ,num_seq
						       ,des_rede
        					   ,num_pedido
						       ,cod_produto
					           ,des_produto
						       ,vlr_produto
        					   ,qtd_etiqueta
						       ,vlr_tamanho
					           ,tip_etiqueta
						       ,num_semana
						       ,dta_sistema
							   ,des_marca
							   ,des_endereco_loja)
					     values(pi_usuario
					           ,wIncremento
					           ,wDes_rede
					           ,pi_ordem
					           ,wCod_completo
					           ,wDes_item
					           ,r_precos.vlr_item
					           ,r_itens.qtd_prev_entr
						       ,wvlr_tamanho
					           ,2
					           ,wSemana
					           ,to_date(sysdate,'dd/mm/yyyy')
							   ,wDesMarca
							   ,wDesEnderecoLoja);
   		                              /*
						create global temporary table grzw_ordens_fornec(
						         des_usuario      VARCHAR2(30)  not null
							,des_rede         VARCHAR2(20)  
						        ,num_pedido	  NUMBER(6)
							,cod_produto      VARCHAR2(9)
							,des_produto      VARCHAR2(30)
							,vlr_produto	  NUMBER(9,2)
						        ,qtd_etiqueta	  NUMBER(4) 
							,vlr_tamanho	  VARCHAR2(3)
							,tip_etiqueta	  NUMBER(2)
							,num_semana	  NUMBER(3)
							,dta_sistema	  date
						)
					      */
		     CLOSE c_precos;
                END;
                FETCH c_itens INTO r_itens;
                END LOOP;
                CLOSE c_itens;
                commit;
       	  END;
     end;
END GRZ_SP_ORDENS_FORNEC;
/