-- select posição de bonus em determinada data lojas
select a.cod_emp, count(1), sum(a.vlr_bonus) from grz_mvto_bonus a
where a.cod_emp in (10,30,40,50,70)
and a.cod_bonus > 0
and a.cod_unidade in (select cod_unidade from ge_grupos_unidades ge where cod_grupo in (910,930,940,950,970) and cod_emp = 1)
and a.dta_validade_bonus between '01/01/2021' and '28/02/2021'
and a.tip_movimento = 1
and not exists (select 1 from grz_mvto_bonus t
where a.cod_bonus = t.cod_bonus
and a.cod_lote = t.cod_lote
and t.tip_movimento = 2
and t.dta_movimento < '01/01/2021')
group by a.cod_emp

-- select bonus gastos lojas
select a.cod_emp, count(1), sum(a.vlr_bonus) from grz_mvto_bonus a
where a.cod_emp in (10,30,40,50,70)
and a.cod_bonus > 0
and a.cod_unidade in (select cod_unidade from ge_grupos_unidades ge where cod_grupo in (910,930,940,950,970) and cod_emp = 1)
and a.dta_validade_bonus between '01/01/2021' and '28/02/2021'
and a.tip_movimento = 1
and exists (select 1 from grz_mvto_bonus t
where a.cod_bonus = t.cod_bonus
and a.cod_lote = t.cod_lote
and t.tip_movimento = 2
and t.dta_movimento between '01/01/2021' and '28/02/2021')
group by a.cod_emp

-- select bonus aniversario
select a.cod_emp, count(1),
       sum(a.vlr_bonus)
from grz_controle_bonus a
where a.cod_emp in (10,30,40,50,70)
and a.cod_bonus > 0
and a.cod_lote in (9910,9930,9940,9950,9970)
and a.dta_validade_ret between '01/01/2021' and '07/02/2021'
and not exists (select 1 from grz_mvto_bonus t
                where a.cod_bonus = t.cod_bonus
                and a.cod_lote = t.cod_lote
                and t.tip_movimento = 2
                and t.dta_movimento < '01/01/2021')
group by a.cod_emp

-- select bonus gastos aniversario
select a.cod_emp,
       count(1),
       sum(a.vlr_bonus)
from grz_controle_bonus a
where a.cod_emp in (10,30,40,50,70)
and a.cod_bonus > 0
and a.cod_lote in (9910,9930,9940,9950,9970)
and a.dta_validade_ret between '01/01/2021' and '07/02/2021'
and exists (select 1 from grz_mvto_bonus t
            where a.cod_bonus = t.cod_bonus
            and a.cod_lote = t.cod_lote
            and t.tip_movimento = 2
            and t.dta_movimento between '01/01/2021' and '07/02/2021')
group by a.cod_emp

-- select bonus APP
select a.cod_emp, count(1), sum(a.vlr_bonus) from grz_controle_bonus a
where a.cod_emp > 0
and a.cod_bonus > 0
and a.cod_lote = 702
and a.dta_validade_ret between '01/01/2021' and '28/02/2021'
and not exists (select 1 from grz_mvto_bonus t
where a.cod_bonus = t.cod_bonus
and a.cod_lote = t.cod_lote
and t.tip_movimento = 2
and t.dta_movimento < '01/01/2021')
group by a.cod_emp


-- select bonus gastos APP
select a.cod_emp, count(1), sum(a.vlr_bonus) from grz_controle_bonus a
where a.cod_emp > 0
and a.cod_bonus > 0
and a.cod_lote = 702
and a.dta_validade_ret between '01/01/2021' and '28/02/2021'
and exists (select 1 from grz_mvto_bonus t
where a.cod_bonus = t.cod_bonus
and a.cod_lote = t.cod_lote
and t.tip_movimento = 2
and t.dta_movimento between '01/01/2021' and '28/02/2021')
group by a.cod_emp
