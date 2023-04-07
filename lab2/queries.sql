--1
select "НАИМЕНОВАНИЕ","ЧЛВК_ИД" FROM "Н_ТИПЫ_ВЕДОМОСТЕЙ"
right join "Н_ВЕДОМОСТИ" НВ on ("Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД" = НВ."ТВ_ИД"
and "ДАТА" < '2022-06-08' ) where "Н_ТИПЫ_ВЕДОМОСТЕЙ"."ИД" < 2;

--2
select "ФАМИЛИЯ",НВ."ДАТА",НС."ЧЛВК_ИД" from "Н_ЛЮДИ"
left join "Н_СЕССИЯ" НС on ("Н_ЛЮДИ"."ИД" = НС."ЧЛВК_ИД" and НС."ИД" = 1975)
left join "Н_ВЕДОМОСТИ" НВ on (НС."СЭС_ИД" = НВ."СЭС_ИД" and НВ."ЧЛВК_ИД" < 153285)
where "Н_ЛЮДИ"."ИД"=152862;


--3
select count("ИМЯ") from (select "ИМЯ" from  "Н_ЛЮДИ" group by "ИМЯ") as aoaooaoaoao;

--4
select "НУ"."ГРУППА", count(*) from "Н_УЧЕНИКИ" "НУ"
inner join "Н_ПЛАНЫ" "НП" on ("НУ"."ПЛАН_ИД"="НП"."ИД")
inner join "Н_ОТДЕЛЫ" "НО" on ("НО"."КОРОТКОЕ_ИМЯ"='ВТ' and "НП"."ОТД_ИД"="НО"."ИД")
where ( "НУ"."ПРИЗНАК"='обучен' AND DATE_PART('year', "НУ"."НАЧАЛО") <= '2011' AND DATE_PART('year', "НУ"."КОНЕЦ") >= '2011')
group by "НУ"."ГРУППА" having count(*)<5;

--5
WITH AvgGrade_3100 AS (
    SELECT AVG("БАЛЛЫ") as avg_grade_3100
    FROM "Н_ВЕДОМОСТИ" NV
    JOIN "Н_УЧЕНИКИ" NU ON NV."ЧЛВК_ИД" = NU."ЧЛВК_ИД"
    WHERE NU."ГРУППА" = '3100'
),
AvgGrade_4100 AS (
    SELECT NL."ИД", NL."ФИО", AVG(NV."БАЛЛЫ") as avg_grade
    FROM "Н_ВЕДОМОСТИ" NV
    JOIN "Н_УЧЕНИКИ" NU ON NV."ЧЛВК_ИД" = NU."ЧЛВК_ИД"
    JOIN "Н_ЛЮДИ" NL ON NU."ЧЛВК_ИД" = NL."ИД"
    WHERE NU."ГРУППА" = '4100'
    GROUP BY NL."ИД", NL."ФИО"
)
SELECT A4."ИД" as "Номер", A4."ФИО", A4.avg_grade as "Сроценка"
FROM AvgGrade_4100 A4, AvgGrade_3100 A3
WHERE A4.avg_grade = A3.avg_grade_3100;

--6
SELECT NU."ГРУППА" as "Номер группы",
       NL."ИД" as "Номер",
       NL."ФАМИЛИЯ",
       NL."ИМЯ",
       NL."ОТЧЕСТВО",
       NU."П_ПРКОК_ИД" as "Номер пункта приказа"
FROM "Н_ЛЮДИ" NL
JOIN "Н_УЧЕНИКИ" NU ON NL."ИД" = NU."ЧЛВК_ИД"
JOIN "Н_ПЛАНЫ" NP ON NU."ПЛАН_ИД" = NP."ИД"
WHERE NU."СОСТОЯНИЕ" = 'Отчислен' AND
      NU."КОНЕЦ" = '2012-09-01' AND
      NP."ФО_ИД" IN (
          SELECT "ИД"
          FROM "Н_ФОРМЫ_ОБУЧЕНИЯ"
          WHERE "НАИМЕНОВАНИЕ" = 'Заочная'
      );

--7
select count(*) from (select НЛ."ИД" FROM "Н_УЧЕНИКИ" НУ
inner join "Н_ПЛАНЫ" НП on (НУ."ПЛАН_ИД"=НП."ИД")
inner join "Н_ОТДЕЛЫ" НО on (НО."КОРОТКОЕ_ИМЯ"='КТиУ' and НП."ОТД_ИД"=НО."ИД")
inner join "Н_ЛЮДИ" НЛ on НУ."ЧЛВК_ИД" = НЛ."ИД"
inner join "Н_ВЕДОМОСТИ" НВ on НЛ."ИД" = НВ."ЧЛВК_ИД"
where НВ."ОЦЕНКА" = '3' group by НЛ."ИД") as bufftable;