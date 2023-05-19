--1 +
select "НАИМЕНОВАНИЕ","ЧЛВК_ИД" from "Н_ТИПЫ_ВЕДОМОСТЕЙ"
right join "Н_ВЕДОМОСТИ" НВ on ("Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД" = НВ."ТВ_ИД"
and "ДАТА" < '2022-06-08' ) where "Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД" < 2;

--2 +
select "ФАМИЛИЯ",НВ."ДАТА",НС."ЧЛВК_ИД" from "Н_ЛЮДИ"
left join "Н_СЕССИЯ" НС on ("Н_ЛЮДИ"."ИД" = НС."ЧЛВК_ИД" and НС."ИД" = 1975)
left join "Н_ВЕДОМОСТИ" НВ on (НС."СЭС_ИД" = НВ."СЭС_ИД" and НВ."ЧЛВК_ИД" < 153285)
where "Н_ЛЮДИ"."ИД"=152862;

--кластерный индекс в 1, Н_Ведомости дата и id;
--кластерный индекс в 2, Н_Ведомости id;

--с индексами лучше потому-что join быстрее сделаются из-за того что не надо будет сканировать таблицы целиком

--explain analyze
--1
 Nested Loop  (cost=830.93..6751.40 rows=74123 width=422) (actual time=6.987..71.318 rows=190894 loops=1)
   ->  Seq Scan on "Н_ТИПЫ_ВЕДОМОСТЕЙ"  (cost=0.00..1.04 rows=1 width=422) (actual time=0.008..0.011 rows=1 loops=1)
         Filter: ("ИД" < 2)
         Rows Removed by Filter: 2
   ->  Bitmap Heap Scan on "Н_ВЕДОМОСТИ" "НВ"  (cost=830.93..6009.13 rows=74123 width=8) (actual time=6.973..48.680 rows=190894 loops=1)
         Recheck Cond: ("ТВ_ИД" = "Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД")
         Filter: ("ДАТА" < '2022-06-08 00:00:00'::timestamp without time zone)
         Rows Removed by Filter: 3
         Heap Blocks: exact=4040
         ->  Bitmap Index Scan on "ВЕД_ТВ_FK_I"  (cost=0.00..812.40 rows=74147 width=0) (actual time=6.333..6.333 rows=190897 loops=1)
               Index Cond: ("ТВ_ИД" = "Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД")
 Planning Time: 1.041 ms
 Execution Time: 80.140 ms

 --2

  Nested Loop Left Join  (cost=4.87..125.94 rows=34 width=28) (actual time=0.033..0.035 rows=1 loops=1)
   ->  Nested Loop Left Join  (cost=4.58..19.63 rows=1 width=24) (actual time=0.026..0.028 rows=1 loops=1)
         Join Filter: ("Н_ЛЮДИ"."ИД" = "НС"."ЧЛВК_ИД")
         ->  Index Scan using "ЧЛВК_PK" on "Н_ЛЮДИ"  (cost=0.28..8.30 rows=1 width=20) (actual time=0.011..0.011 rows=1 loops=1)
               Index Cond: ("ИД" = 152862)
         ->  Bitmap Heap Scan on "Н_СЕССИЯ" "НС"  (cost=4.30..11.32 rows=1 width=8) (actual time=0.007..0.007 rows=0 loops=1)
               Recheck Cond: ("ЧЛВК_ИД" = 152862)
               Filter: ("ИД" = 1975)
               ->  Bitmap Index Scan on "SYS_C003500_IFK"  (cost=0.00..4.29 rows=2 width=0) (actual time=0.004..0.004 rows=0 loops=1)
                     Index Cond: ("ЧЛВК_ИД" = 152862)
   ->  Index Scan using "ВЕД_ИП_FK_I" on "Н_ВЕДОМОСТИ" "НВ"  (cost=0.29..105.99 rows=32 width=12) (actual time=0.005..0.005 rows=0 loops=1)
         Index Cond: ("СЭС_ИД" = "НС"."СЭС_ИД")
         Filter: ("ЧЛВК_ИД" < 153285)
 Planning Time: 0.898 ms
 Execution Time: 0.094 ms

 --виды индексов, процедуры, мутации