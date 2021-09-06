commit work;
set autoddl off;
set term ^ ;

create or alter procedure rel_clientes_vd_sp
(
 icod_emp         numeric(3,0),
 idt_cadastro_ini date,
 idt_cadastro_fim date,
 idt_altera_ini   date,
 idt_altera_fim   date,
 iflag            numeric(1,0),
 iorder           numeric(1,0),
 icod_uni_cli     numeric(3,0)
)
returns
(
 icod_cliente      numeric(14,0),
 ides_endereco     varchar(50),
 ides_bairro       varchar(20),
 ides_cidade       varchar(50),
 ides_fone_resid   varchar(15),
 ides_fone_celular varchar(15),
 dta_cadastro      date,
 dta_alteracao     date,
 icod_unidade      numeric(4,0),
 ides_cliente      varchar(40),
 inum_cep          numeric(10,0),
 inum_equipamento  integer,
 inum_usuario      integer,
 ihora_cadastro    varchar(5),
 icpf_escondido    varchar(20)
)
as
  declare variable iind_spc numeric(1);
  declare variable icod_cidade numeric(4);
begin
     if (iflag = 1) then /* cadastro */
     begin
          if (iorder > 1) then /* nome */
          begin
               for select cre_clientes.cod_cliente,
                          cre_clientes.des_cliente,
                          cre_clientes.des_endereco,
                          cre_clientes.des_bairro,
                          cre_clientes.cod_cidade,
                          cre_clientes.des_telefone,
                          cre_clientes.des_fone_celular,
                          cre_clientes.dta_cadastro,
                          cre_clientes.dta_alteracao,
                          cre_clientes.cod_unidade,
                          cre_clientes.num_cep,
                          cre_clientes.num_equipamento,
                          cre_clientes.num_usuario,
                          cre_clientes.hora_cadastro,
                          case when tip_pessoa = 1 then
                                    substring((lpad(cre_clientes.cod_cliente,11,'0')) from 1 for 3)||'.***.***-'||
                                    substring((lpad(cre_clientes.cod_cliente,11,'0')) from 10 for 11)
                               when tip_pessoa = 2 then
                                    substring((lpad(cre_clientes.cod_cliente,14,'0')) from 1 for 2)||
                                    '.***.***/****-'||
                                    substring((lpad(cre_clientes.cod_cliente,14,'0')) from 13 for 14)
                               else
                                   cre_clientes.cod_cliente
                          end as icpf_escondido
                   from cre_clientes
                   where cre_clientes.cod_emp       =:icod_emp and
                         cre_clientes.tip_cliente   = 1 and
                         cre_clientes.dta_cadastro >=:idt_cadastro_ini and
                         cre_clientes.dta_cadastro <=:idt_cadastro_fim
                   order by cre_clientes.num_equipamento,cre_clientes.dta_cadastro,cre_clientes.des_cliente
                   into :icod_cliente,:ides_cliente,:ides_endereco,:ides_bairro,
                        :icod_cidade,:ides_fone_resid,:ides_fone_celular,:dta_cadastro,:dta_alteracao,
                        :icod_unidade,:inum_cep,:inum_equipamento, :inum_usuario, :ihora_cadastro,:icpf_escondido do
               begin
                    if ((icod_uni_cli = 999) or (icod_uni_cli = icod_unidade)) then
                    begin
                         select des_cidade
                         from ger_cidades
                         where cod_cidade = :icod_cidade
                         into ides_cidade;
                         if (ides_endereco is null) then
                            ides_endereco = ' ';
                         if (ides_bairro is null) then
                            ides_bairro = ' ';
                         if (ides_cidade is null) then
                            ides_cidade = ' ';
                         if (ides_fone_resid is null) then
                            ides_fone_resid = ' ';
                         if (inum_cep is null) then
                            inum_cep = ' ';
                         suspend;
                    end
               end
          end
          else
          begin
               for select cre_clientes.cod_cliente,
                          cre_clientes.des_cliente,
                          cre_clientes.des_endereco,
                          cre_clientes.des_bairro,
                          cre_clientes.cod_cidade,
                          cre_clientes.des_telefone,
                          cre_clientes.des_fone_celular,
                          cre_clientes.dta_cadastro,
                          cre_clientes.dta_alteracao,
                          cre_clientes.cod_unidade,
                          cre_clientes.num_cep,
                          cre_clientes.num_equipamento,
                          cre_clientes.num_usuario,
                          cre_clientes.hora_cadastro,
                          case when tip_pessoa = 1  then
                                    substring((lpad(cre_clientes.cod_cliente,11,'0')) from 1 for 3)||'.***.***-'||
                                    substring((lpad(cre_clientes.cod_cliente,11,'0')) from 10 for 11)
                               when tip_pessoa = 2 then
                                    substring((lpad(cre_clientes.cod_cliente,14,'0')) from 1 for 2)||
                                    '.***.***/****-'||
                                    substring((lpad(cre_clientes.cod_cliente,14,'0')) from 13 for 14)
                               else
                                   cre_clientes.cod_cliente
                          end as icpf_escondido
                   from cre_clientes
                   where cre_clientes.cod_emp       =:icod_emp and
                         cre_clientes.tip_cliente   = 1 and
                         cre_clientes.dta_cadastro >=:idt_cadastro_ini and
                         cre_clientes.dta_cadastro <=:idt_cadastro_fim
                   order by cre_clientes.num_equipamento,cre_clientes.dta_cadastro,cre_clientes.cod_cliente
                   into :icod_cliente,:ides_cliente,:ides_endereco,:ides_bairro,
                        :icod_cidade,:ides_fone_resid,:ides_fone_celular,:dta_cadastro,:dta_alteracao,
                        :icod_unidade, :inum_cep, :inum_equipamento, :inum_usuario, :ihora_cadastro,:icpf_escondido do
               begin
                    if ((icod_uni_cli = 999) or (icod_uni_cli = icod_unidade)) then
                    begin
                         select des_cidade
                         from ger_cidades
                         where cod_cidade = :icod_cidade
                         into ides_cidade;
                         if (ides_endereco is null) then
                            ides_endereco = ' ';
                         if (ides_bairro is null) then
                            ides_bairro = ' ';
                         if (ides_cidade is null) then
                            ides_cidade = ' ';
                         if (ides_fone_resid is null) then
                            ides_fone_resid = ' ';
                         if (inum_cep is null) then
                            inum_cep = ' ';
                         suspend;
                    end
               end
          end
     end

     if (iflag = 2) then /* alteracao */
     begin
          if (iorder > 1) then
          begin
               for select cre_clientes.cod_cliente,
                          cre_clientes.des_cliente,
                          cre_clientes.des_endereco,
                          cre_clientes.des_bairro,
                          cre_clientes.cod_cidade,
                          cre_clientes.des_telefone,
                          cre_clientes.des_fone_celular,
                          cre_clientes.dta_cadastro,
                          cre_clientes.dta_alteracao,
                          cre_clientes.cod_unidade,
                          cre_clientes.num_cep,
                          cre_clientes.num_equipamento,
                          cre_clientes.num_usuario,
                          cre_clientes.hora_cadastro,
                          case when tip_pessoa = 1 then
                                    substring((lpad(cre_clientes.cod_cliente,11,'0')) from 1 for 3)||'.***.***-'||
                                    substring((lpad(cre_clientes.cod_cliente,11,'0')) from 10 for 11)
                               when tip_pessoa = 2 then
                                     substring((lpad(cre_clientes.cod_cliente,14,'0')) from 1 for 2)||
                                     '.***.***/****-'||
                                     substring((lpad(cre_clientes.cod_cliente,14,'0')) from 13 for 14)
                               else
                                   cre_clientes.cod_cliente
                          end as icpf_escondido
                   from cre_clientes
                   where cre_clientes.cod_emp        =:icod_emp and
                         cre_clientes.tip_cliente    = 1 and
                         cre_clientes.dta_alteracao >=:idt_altera_ini and
                         cre_clientes.dta_alteracao <=:idt_altera_fim
                   order by cre_clientes.num_equipamento,cre_clientes.dta_alteracao,cre_clientes.des_cliente
                   into :icod_cliente,:ides_cliente,:ides_endereco,:ides_bairro,
                        :icod_cidade,:ides_fone_resid,:ides_fone_celular,:dta_cadastro,:dta_alteracao,
                        :icod_unidade,:inum_cep,:inum_equipamento, :inum_usuario, :ihora_cadastro,:icpf_escondido do
               begin
                    if ((icod_uni_cli = 999) or (icod_uni_cli = icod_unidade)) then
                    begin
                         select des_cidade
                         from ger_cidades
                         where cod_cidade = :icod_cidade
                         into ides_cidade;
                         if (ides_endereco is null) then
                            ides_endereco = ' ';
                         if (ides_bairro is null) then
                            ides_bairro = ' ';
                         if (ides_cidade is null) then
                            ides_cidade = ' ';
                         if (ides_fone_resid is null) then
                            ides_fone_resid = ' ';
                         if (inum_cep is null) then
                            inum_cep = ' ';
                         suspend;
                    end
               end
          end
          else
          begin
               for select cre_clientes.cod_cliente,
                          cre_clientes.des_cliente,
                          cre_clientes.des_endereco,
                          cre_clientes.des_bairro,
                          cre_clientes.cod_cidade,
                          cre_clientes.des_telefone,
                          cre_clientes.des_fone_celular,
                          cre_clientes.dta_cadastro,
                          cre_clientes.dta_alteracao,
                          cre_clientes.cod_unidade,
                          cre_clientes.num_cep,
                          cre_clientes.num_equipamento,
                          cre_clientes.num_usuario,
                          cre_clientes.hora_cadastro,
                          case when tip_pessoa = 1 then
                                    substring((lpad(cre_clientes.cod_cliente,11,'0')) from 1 for 3)||'.***.***-'||
                                    substring((lpad(cre_clientes.cod_cliente,11,'0')) from 10 for 11)
                               when tip_pessoa = 2 then
                                    substring((lpad(cre_clientes.cod_cliente,14,'0')) from 1 for 2)||'.***.***/****-'||
                                    substring((lpad(cre_clientes.cod_cliente,14,'0')) from 13 for 14)
                               else
                                   cre_clientes.cod_cliente
                          end as icpf_escondido
                   from cre_clientes
                   where cre_clientes.cod_emp       =:icod_emp and
                         cre_clientes.tip_cliente   = 1 and
                         cre_clientes.dta_alteracao >=:idt_altera_ini and
                         cre_clientes.dta_alteracao <=:idt_altera_fim
                   order by cre_clientes.num_equipamento,cre_clientes.dta_alteracao,cre_clientes.cod_cliente
                   into :icod_cliente,:ides_cliente,:ides_endereco,:ides_bairro,
                        :icod_cidade,:ides_fone_resid,:ides_fone_celular,:dta_cadastro,:dta_alteracao,
                        :icod_unidade,:inum_cep,:inum_equipamento, :inum_usuario, :ihora_cadastro,:icpf_escondido do
               begin
                    if ((icod_uni_cli = 999) or (icod_uni_cli = icod_unidade)) then
                    begin
                         select des_cidade
                         from ger_cidades
                         where cod_cidade = :icod_cidade
                         into ides_cidade;
                         if (ides_endereco is null) then
                            ides_endereco = ' ';
                         if (ides_bairro is null) then
                            ides_bairro = ' ';
                         if (ides_cidade is null) then
                            ides_cidade = ' ';
                         if (ides_fone_resid is null) then
                            ides_fone_resid = ' ';
                         if (inum_cep is null) then
                            inum_cep = ' ';
                         suspend;
                    end
               end
          end
     end

     if (iflag = 3) then /* ambos */
     begin
          if(iorder > 1 )then
          begin
               for select cre_clientes.cod_cliente,
                          cre_clientes.des_cliente,
                          cre_clientes.des_endereco,
                          cre_clientes.des_bairro,
                          cre_clientes.cod_cidade,
                          cre_clientes.des_telefone,
                          cre_clientes.des_fone_celular,
                          cre_clientes.dta_cadastro,
                          cre_clientes.dta_alteracao,
                          cre_clientes.cod_unidade,
                          cre_clientes.num_cep,
                          cre_clientes.num_equipamento,
                          cre_clientes.num_usuario,
                          cre_clientes.hora_cadastro,
                          case when tip_pessoa = 1 then
                                    substring((lpad(cre_clientes.cod_cliente,11,'0')) from 1 for 3)||'.***.***-'||
                                    substring((lpad(cre_clientes.cod_cliente,11,'0')) from 10 for 11)
                               when tip_pessoa = 2 then
                                    substring((lpad(cre_clientes.cod_cliente,14,'0')) from 1 for 2)||
                                    '.***.***/****-'||
                                    substring((lpad(cre_clientes.cod_cliente,14,'0')) from 13 for 14)
                               else
                                   cre_clientes.cod_cliente
                          end as icpf_escondido
                   from cre_clientes
                   where cre_clientes.cod_emp=:icod_emp and
                         cre_clientes.tip_cliente   = 1 and
                         ((cre_clientes.dta_alteracao >=:idt_altera_ini and
                         cre_clientes.dta_alteracao <=:idt_altera_fim)or
                         (cre_clientes.dta_cadastro  >=:idt_cadastro_ini and
                         cre_clientes.dta_cadastro  <=:idt_cadastro_fim))
                   order by cre_clientes.num_equipamento,cre_clientes.dta_cadastro,cre_clientes.des_cliente
                   into :icod_cliente,:ides_cliente,:ides_endereco,:ides_bairro,
                        :icod_cidade,:ides_fone_resid,:ides_fone_celular,:dta_cadastro,:dta_alteracao,
                        :icod_unidade,:inum_cep,:inum_equipamento, :inum_usuario, :ihora_cadastro,:icpf_escondido do
               begin
                    if ((icod_uni_cli = 999) or (icod_uni_cli = icod_unidade)) then
                    begin
                         select des_cidade
                         from ger_cidades
                         where cod_cidade = :icod_cidade
                         into ides_cidade;
                         if (ides_endereco is null) then
                            ides_endereco = ' ';
                         if (ides_bairro is null) then
                            ides_bairro = ' ';
                         if (ides_cidade is null) then
                            ides_cidade = ' ';
                         if (ides_fone_resid is null) then
                            ides_fone_resid = ' ';
                         if (inum_cep is null) then
                            inum_cep = ' ';
                         suspend;
                    end
               end
          end
          else
          begin
               for select cre_clientes.cod_cliente,
                          cre_clientes.des_cliente,
                          cre_clientes.des_endereco,
                          cre_clientes.des_bairro,
                          cre_clientes.cod_cidade,
                          cre_clientes.des_telefone,
                          cre_clientes.des_fone_celular,
                          cre_clientes.dta_cadastro,
                          cre_clientes.dta_alteracao,
                          cre_clientes.cod_unidade,
                          cre_clientes.num_cep,
                          cre_clientes.num_equipamento,
                          cre_clientes.num_usuario,
                          cre_clientes.hora_cadastro,
                          case when tip_pessoa = 1 then
                                    substring((lpad(cre_clientes.cod_cliente,11,'0')) from 1 for 3)||'.***.***-'||
                                    substring((lpad(cre_clientes.cod_cliente,11,'0')) from 10 for 11)
                               when tip_pessoa = 2 then
                                    substring((lpad(cre_clientes.cod_cliente,14,'0')) from 1 for 2)||
                                    '.***.***/****-'||
                                    substring((lpad(cre_clientes.cod_cliente,14,'0')) from 13 for 14)
                               else
                                   cre_clientes.cod_cliente
                          end as icpf_escondido
                   from cre_clientes
                   where cre_clientes.cod_emp=:icod_emp and
                         cre_clientes.tip_cliente   = 1 and
                         ((cre_clientes.dta_alteracao >=:idt_altera_ini and
                         cre_clientes.dta_alteracao <=:idt_altera_fim)or
                         (cre_clientes.dta_cadastro  >=:idt_cadastro_ini and
                          cre_clientes.dta_cadastro  <=:idt_cadastro_fim))
                   order by cre_clientes.num_equipamento,cre_clientes.dta_cadastro,cre_clientes.cod_cliente
                   into :icod_cliente,:ides_cliente,:ides_endereco,:ides_bairro,
                        :icod_cidade,:ides_fone_resid,:ides_fone_celular,:dta_cadastro,:dta_alteracao,
                        :icod_unidade,:inum_cep, :inum_equipamento, :inum_usuario, :ihora_cadastro,:icpf_escondido  do
               begin
                    if ((icod_uni_cli = 999) or (icod_uni_cli = icod_unidade)) then
                    begin
                         select des_cidade
                         from ger_cidades
                         where cod_cidade = :icod_cidade
                         into ides_cidade;
                         if (ides_endereco is null) then
                            ides_endereco = ' ';
                         if (ides_bairro is null) then
                             ides_bairro = ' ';
                         if (ides_cidade is null) then
                            ides_cidade = ' ';
                         if (ides_fone_resid is null)then
                            ides_fone_resid = ' ';
                         if (inum_cep is null) then
                            inum_cep = ' ';
                         suspend;
                    end
               end
          end
     end
end ^

set term ; ^
commit work;
set autoddl on;
