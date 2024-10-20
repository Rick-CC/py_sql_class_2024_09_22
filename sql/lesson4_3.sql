SELECT * FROM public.payment
ORDER BY payment_id ASC

SELECT customer_id
FROM payment;

/* GROUP BY 教學 */
SELECT customer_id
FROM payment
GROUP BY customer_id
ORDER BY customer_id ASC;


/* GROUP BY 教學 --> 錯誤示範, amout 沒有 GROUP, 無法對應顯示資料 */
SELECT customer_id, amount
FROM payment
GROUP BY customer_id;


/* GROUP BY 教學 , amout 加上聚合函數 & 另外顯示 */
SELECT customer_id, AVG(amount) AS 平均數量
FROM payment
GROUP BY customer_id;

/* GROUP BY 教學 , amout 加上聚合函數 & 另外顯示 */
SELECT customer_id,
		SUM(amount) AS 加總,
		AVG(amount) AS 平均數量,
		COUNT(amount) AS 數量,
		MAX(amount) AS 最大,
		MIN(amount) AS 最小
FROM payment
GROUP BY customer_id
ORDER BY COUNT(amount) ASC;


/* GROUP BY 教學 , amout 加上聚合函數 & 另外顯示 , 篩選 customer_id = 341 */
/* WHERE 只能用在原始資料, 必須加在 GROUP BY 之前 */
SELECT customer_id,
		SUM(amount) AS 加總,
		AVG(amount) AS 平均數量,
		COUNT(amount) AS 數量,
		MAX(amount) AS 最大,
		MIN(amount) AS 最小
FROM payment
WHERE customer_id = 341		/* <========== */
GROUP BY customer_id
ORDER BY COUNT(amount) ASC;
/* GROUP BY 之後必須用 HAVING  */
SELECT customer_id,
		SUM(amount) AS 加總,
		AVG(amount) AS 平均數量,
		COUNT(amount) AS 數量,
		MAX(amount) AS 最大,
		MIN(amount) AS 最小
FROM payment
GROUP BY customer_id
HAVING customer_id = 341     /* <========== */
ORDER BY COUNT(amount) ASC;

SELECT *
FROM payment p JOIN customer c ON p.customer_id = c.customer_id;

SELECT (first_name,last_name)
FROM payment p JOIN customer c ON p.customer_id = c.customer_id;

SELECT first_name || last_name
FROM payment p JOIN customer c ON p.customer_id = c.customer_id;

SELECT (first_name || ' ' || last_name) as full_name
FROM payment p JOIN customer c ON p.customer_id = c.customer_id
GROUP BY full_name; 

SELECT (first_name || ' ' || last_name) as full_name, SUM(amount) AS 總和
FROM payment p JOIN customer c ON p.customer_id = c.customer_id
GROUP BY full_name
ORDER BY 總和 DESC;






