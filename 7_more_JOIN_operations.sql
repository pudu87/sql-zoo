--1
SELECT id, title
FROM movie
WHERE yr=1962;

--2
SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

--3
SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr;

--4
SELECT id
FROM actor
WHERE name = 'Glenn Close';

--5
SELECT id
FROM movie
WHERE title = 'Casablanca';

--6
SELECT name
FROM movie JOIN casting ON (movie.id = movieid)
           JOIN actor ON (actor.id = actorid)
WHERE title = 'Casablanca';

--7
SELECT name
FROM movie JOIN casting ON (movie.id = movieid)
           JOIN actor ON (actor.id = actorid)
WHERE title = 'Alien';

--8
SELECT title
FROM movie JOIN casting ON (movie.id = movieid)
           JOIN actor ON (actor.id = actorid)
WHERE name = 'Harrison Ford';

--9
SELECT title
FROM movie JOIN casting ON (movie.id = movieid)
           JOIN actor ON (actor.id = actorid)
WHERE name = 'Harrison Ford' AND ord != 1;

--10
SELECT title, name
FROM movie JOIN casting ON (movie.id = movieid)
           JOIN actor ON (actor.id = actorid)
WHERE yr = 1962 AND ord = 1;

--11
SELECT yr, COUNT(title) 
FROM movie JOIN casting ON (movie.id=movieid)
           JOIN actor ON (actorid=actor.id)
WHERE name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

--12
SELECT title, name
FROM movie JOIN casting ON (movie.id = movieid)
           JOIN actor ON (actor.id = actorid)
WHERE ord = 1 AND movieid IN (
  SELECT movieid FROM casting
  WHERE actorid IN 
    (SELECT id FROM actor
    WHERE name='Julie Andrews'));

--13
SELECT name
FROM actor JOIN casting ON (id = actorid)
WHERE ord = 1
GROUP BY name
HAVING COUNT(name) >= 15;

--14
SELECT title, COUNT(*)
FROM movie JOIN casting ON (id = movieid)
WHERE yr = 1978
GROUP BY id
ORDER BY COUNT(*) DESC, title;

--15
SELECT DISTINCT name
FROM actor JOIN casting ON (id = actorid)
WHERE movieid IN
  (SELECT movieid
  FROM casting JOIN actor ON (id = actorid)
  WHERE name = 'Art Garfunkel')
AND name != 'Art Garfunkel'