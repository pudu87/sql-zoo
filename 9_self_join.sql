--1
SELECT COUNT(*)
FROM stops;

--2
SELECT id
FROM stops
WHERE name = 'Craiglockhart';

--3
SELECT id, name
FROM stops JOIN route ON (id = stop)
WHERE num = '4' AND company = 'LRT';

--4
SELECT company, num, COUNT(*)
FROM route 
WHERE stop = 149 OR stop = 53
GROUP BY company, num
HAVING COUNT(*) > 1;

--5
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop IN 
  (SELECT id FROM stops WHERE name = 'London Road');

--6
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
             JOIN stops stopa ON (a.stop=stopa.id)
             JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name = 'Craiglockhart' AND stopb.name = 'London Road';

--7
SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
WHERE a.stop = 115 AND b.stop = 137;

--8
SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
             JOIN stops stopa ON (a.stop = stopa.id)
             JOIN stops stopb ON (b.stop = stopb.id)
WHERE stopa.name = 'Craiglockhart' AND stopb.name = 'Tollcross';

--9
SELECT DISTINCT stopb.name, a.company, a.num
FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
             JOIN stops stopa ON (a.stop = stopa.id)
             JOIN stops stopb ON (b.stop = stopb.id)
WHERE stopa.name = 'Craiglockhart';

--10
SELECT x.num, x.company, name, y.num, y.company
FROM (SELECT b.company, b.num, b.stop 
      FROM route a 
      JOIN route b ON (a.company = b.company AND a.num = b.num) 
      WHERE a.stop IN (SELECT id FROM stops WHERE name = 'Craiglockhart')) AS x
JOIN (SELECT a.company, a.num, a.stop 
      FROM route a 
      JOIN route b ON (a.company = b.company AND a.num = b.num) 
      WHERE b.stop IN (SELECT id FROM stops WHERE name = 'Lochend')) AS y 
  ON (x.stop = y.stop)
JOIN stops ON (x.stop = id)
ORDER BY x.num, name, y.num;
