SELECT * FROM public.country
ORDER BY country_id ASC

/* subquery */
/************************************************/
SELECT *
FROM country;
SELECT *
FROM city;

SELECT country_id
FROM country
WHERE country = 'Taiwan';

SELECT city
FROM city
WHERE country_id = 92;

/* 以上要查詢2次 才能找出 台灣的 city */
/* 合併動作 */
SELECT city
FROM city
WHERE country_id = (
	SELECT country_id
	FROM country
	WHERE country = 'Taiwan'
);

/************************************************/



/* 也可以用 JOIN ON 合併後, 在篩選資料 */
SELECT city
FROM city JOIN country ON city.country_id = country.country_id
WHERE country = 'Taiwan';

