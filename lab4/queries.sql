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

--представления(виды), типы индексов и каким типам данных их лучше применять

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

-- факультет, группа, фио, год. условие: 2 и меньше четверок + 4 курс(бакалавр)/5 курс(специалист)/2курс (магистратура) + нет долгов 


SELECT НЛ.ИМЯ, НЛ.ФАМИЛИЯ, НО.КОРОТКОЕ_ИМЯ, НТС.НАИМЕНОВАНИЕ
FROM "Н_УЧЕНИКИ" НУ
INNER JOIN "Н_ПЛАНЫ" НП ON (НУ."ПЛАН_ИД"=НП."ИД")
INNER JOIN "Н_ЛЮДИ" НЛ ON НУ."ЧЛВК_ИД" = НЛ."ИД"
INNER JOIN "Н_ВЕДОМОСТИ" НВ ON ((НВ."ОЦЕНКА" = '5' OR НВ."ОЦЕНКА" = '4') AND НЛ."ИД" = НВ."ЧЛВК_ИД")
INNER JOIN "Н_ОТДЕЛЫ" НО ON НП."ОТД_ИД"=НО."ИД"
INNER JOIN "Н_НАПРАВЛЕНИЯ_СПЕЦИАЛ" AS ННС ON НП."НАПС_ИД" = ННС."НАПС_ИД"
INNER JOIN "Н_ТИПЫ_СТАНДАРТОВ" AS НТС ON ННС."ТС_ИД" = НТС."ИД"
WHERE (EXTRACT(YEAR FROM CURRENT_TIMESTAMP) - EXTRACT(YEAR FROM НУ."НАЧАЛО")) >= 2 AND НТС."ИД" = 3 
OR (EXTRACT(YEAR FROM CURRENT_TIMESTAMP) - EXTRACT(YEAR FROM НУ."НАЧАЛО")) >= 4 AND НТС."ИД" = 2 
OR (EXTRACT(YEAR FROM CURRENT_TIMESTAMP) - EXTRACT(YEAR FROM НУ."НАЧАЛО")) >= 5 AND НТС."ИД" = 1
;
--
--
--5 вложенных джоинов и соответственно сканирование каждой таблицы + фильтры 
--сканирование таблиц затронутых where
--удаление строк
--сканированик таблицы "Н_ВЕДОМОСТИ" и удаление строк не подходящих по фильтру
--вывод
--

 Nested Loop  (cost=226.53..6173.61 rows=15172 width=505) (actual time=0.303..0.306 rows=0 loops=1)
   ->  Hash Join  (cost=226.24..1789.14 rows=1045 width=513) (actual time=0.303..0.306 rows=0 loops=1)
         Hash Cond: ("НУ"."ЧЛВК_ИД" = "НЛ"."ИД")
         ->  Nested Loop  (cost=11.08..1571.24 rows=1045 width=480) (actual time=0.303..0.305 rows=0 loops=1)
               Join Filter: ((((EXTRACT(year FROM CURRENT_TIMESTAMP) - EXTRACT(year FROM "НУ"."НАЧАЛО")) >= '2'::numeric) AND ("НТС"."ИД" = 3)) OR (((EXTRACT(year FROM CURRENT_TIMESTAMP) - EXTRACT(year FROM "НУ"."НАЧАЛО")) = '4'::numeric) AND ("НТС"."ИД" = 2)) OR (((EXTRACT(year FROM CURRENT_TIMESTAMP) - EXTRACT(year FROM "НУ"."НАЧАЛО")) = '5'::numeric) AND ("НТС"."ИД" = 2)))
               ->  Hash Join  (cost=10.79..38.14 rows=228 width=484) (actual time=0.302..0.304 rows=0 loops=1)
                     Hash Cond: ("НП"."ОТД_ИД" = "НО"."ИД")
                     ->  Hash Join  (cost=6.92..33.60 rows=228 width=430) (actual time=0.265..0.267 rows=0 loops=1)
                           Hash Cond: ("НП"."НАПС_ИД" = "ННС"."НАПС_ИД")
                           ->  Seq Scan on "Н_ПЛАНЫ" "НП"  (cost=0.00..19.52 rows=652 width=12) (actual time=0.005..0.102 rows=652 loops=1)
                           ->  Hash  (cost=6.29..6.29 rows=50 width=426) (actual time=0.076..0.077 rows=38 loops=1)
                                 Buckets: 1024  Batches: 1  Memory Usage: 12kB
                                 ->  Hash Join  (cost=1.20..6.29 rows=50 width=426) (actual time=0.024..0.068 rows=39 loops=1)
                                       Hash Cond: ("ННС"."ТС_ИД" = "НТС"."ИД")
                                       ->  Seq Scan on "Н_НАПРАВЛЕНИЯ_СПЕЦИАЛ" "ННС"  (cost=0.00..4.51 rows=151 width=8) (actual time=0.006..0.023 rows=151 loops=1)
                                       ->  Hash  (cost=1.16..1.16 rows=3 width=422) (actual time=0.009..0.009 rows=2 loops=1)
                                             Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                             ->  Seq Scan on "Н_ТИПЫ_СТАНДАРТОВ" "НТС"  (cost=0.00..1.16 rows=3 width=422) (actual time=0.005..0.007 rows=2 loops=1)
                                                   Filter: (("ИД" = 3) OR ("ИД" = 2) OR ("ИД" = 2))
                                                   Rows Removed by Filter: 7
                     ->  Hash  (cost=3.39..3.39 rows=39 width=62) (actual time=0.033..0.033 rows=39 loops=1)
                           Buckets: 1024  Batches: 1  Memory Usage: 10kB
                           ->  Seq Scan on "Н_ОТДЕЛЫ" "НО"  (cost=0.00..3.39 rows=39 width=62) (actual time=0.012..0.022 rows=39 loops=1)
               ->  Index Scan using "УЧЕН_ПЛАН_FK_I" on "Н_УЧЕНИКИ" "НУ"  (cost=0.29..5.95 rows=14 width=16) (never executed)
                     Index Cond: ("ПЛАН_ИД" = "НП"."ИД")
                     Filter: (((EXTRACT(year FROM CURRENT_TIMESTAMP) - EXTRACT(year FROM "НАЧАЛО")) >= '2'::numeric) OR ((EXTRACT(year FROM CURRENT_TIMESTAMP) - EXTRACT(year FROM "НАЧАЛО")) = '4'::numeric) OR ((EXTRACT(year FROM CURRENT_TIMESTAMP) - EXTRACT(year FROM "НАЧАЛО")) = '5'::numeric))
         ->  Hash  (cost=151.18..151.18 rows=5118 width=33) (never executed)
               ->  Seq Scan on "Н_ЛЮДИ" "НЛ"  (cost=0.00..151.18 rows=5118 width=33) (never executed)
   ->  Index Scan using "ВЕД_ЧЛВК_FK_IFK" on "Н_ВЕДОМОСТИ" "НВ"  (cost=0.29..3.98 rows=22 width=4) (never executed)
         Index Cond: ("ЧЛВК_ИД" = "НУ"."ЧЛВК_ИД")
         Filter: ((("ОЦЕНКА")::text = '5'::text) OR (("ОЦЕНКА")::text = '4'::text))
 Planning Time: 3.539 ms
 Execution Time: 0.389 ms


--представление(dop15) -> update location
SELECT ast.name AS action_name, loc.name AS location_name
FROM action AS a
JOIN action_stats AS ast ON a.action = ast.id
JOIN person_characteristics AS pc ON a.id = pc.current_action
JOIN location AS loc ON pc.location = loc.id;

UPDATE dop15 SET location_name = 'spb'
WHERE location_name = 'Moscow';

CREATE OR REPLACE FUNCTION update_dop15_location_name()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE location
  SET name = NEW.name
  WHERE name = OLD.name;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_dop15_trigger
INSTEAD OF UPDATE ON dop15
FOR EACH ROW
EXECUTE FUNCTION update_dop15_location_name();