declare
       cursor cursor_atualiza_controle_bonus is
              select cod_emp,cod_unidade,dta_movimento,cod_bonus,cod_lote,tip_movimento
              from grz_mvto_bonus
              where tip_movimento = 1
              and grz_mvto_bonus.cod_emp in (10,30,40,50,70)
              --and grz_mvto_bonus.cod_unidade = :cod_unidade
              and dta_movimento between to_date(:Inicial,'dd/mm/yyyy') and to_date(:Final,'dd/mm/yyyy');
       reg_atualiza_controle_bonus cursor_atualiza_controle_bonus%rowtype;
begin
     open cursor_atualiza_controle_bonus;
     loop
         fetch cursor_atualiza_controle_bonus into reg_atualiza_controle_bonus;
         exit when cursor_atualiza_controle_bonus%notfound;
         update grz_controle_bonus
                set dta_insert = reg_atualiza_controle_bonus.dta_movimento
                where (cod_emp = reg_atualiza_controle_bonus.cod_emp)
                and   (cod_bonus = reg_atualiza_controle_bonus.cod_bonus)
                and   (cod_lote = reg_atualiza_controle_bonus.cod_lote);
     end loop; -- cursor_atualiza_controle_bonus;
     close cursor_atualiza_controle_bonus;
end;
