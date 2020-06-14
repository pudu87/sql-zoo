--1
SELECT name, DAY(whn), confirmed, deaths, recovered
FROM covid
WHERE name = 'Spain' AND MONTH(whn) = 3
ORDER BY whn;

--2
SELECT name, DAY(whn), confirmed,
  LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) AS lag
FROM covid
WHERE name = 'Italy' AND MONTH(whn) = 3
ORDER BY whn;

--3
SELECT name, DAY(whn),
  (confirmed-LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn)) AS new
FROM covid
WHERE name = 'Italy' AND MONTH(whn) = 3
ORDER BY whn;

--4
SELECT name, DATE_FORMAT(whn,'%Y-%m-%d') AS date, 
  (confirmed-LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn)) new
FROM covid
WHERE name = 'Italy' AND WEEKDAY(whn) = 0
ORDER BY whn;

--5
SELECT tw.name, DATE_FORMAT(tw.whn,'%Y-%m-%d'), 
  (tw.confirmed-lw.confirmed) AS new
FROM covid tw LEFT JOIN covid lw ON 
  (DATE_ADD(lw.whn, INTERVAL 1 WEEK) = tw.whn AND tw.name = lw.name)
WHERE tw.name = 'Italy' AND WEEKDAY(tw.whn) = 0
ORDER BY tw.whn;

--6
SELECT name, confirmed, RANK() OVER (ORDER BY confirmed DESC) rc,
   deaths, RANK() OVER (ORDER BY deaths DESC) dc
FROM covid
WHERE whn = '2020-04-20'
ORDER BY confirmed DESC;

--7
SELECT world.name,
  ROUND(100000*confirmed/population,0) AS ir,
  RANK() OVER (ORDER BY confirmed/population) AS irr
FROM covid JOIN world ON (covid.name = world.name)
WHERE whn = '2020-04-20' AND population > 10000000
ORDER BY population DESC;

--8
SELECT DISTINCT z.name, z.date, peak
FROM
  (SELECT name, MAX(new) AS peak
  FROM (SELECT name, DATE_FORMAT(whn,'%Y-%m-%d') AS date,
    (confirmed-LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn)) AS new
    FROM covid) x
  GROUP BY name) y
JOIN
  (SELECT name, DATE_FORMAT(whn,'%Y-%m-%d') AS date,
  (confirmed-LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn)) AS new
  FROM covid) z
ON (y.name = z.name)
WHERE peak > 1000 AND peak = new
ORDER BY z.date;