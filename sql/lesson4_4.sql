SELECT * FROM public.payment
ORDER BY payment_id ASC;

/* 隋堂演練 : 從 payment 資料表, 取出所有員工的訂單總數 */
SELECT staff_id,
       COUNT(payment_id) as 訂單總和
FROM payment
GROUP BY staff_id
ORDER BY 訂單總和 DESC;

/* 隋堂演練 : 取出每個員工, 在每一個客戶的訂單金額總和 */
SELECT staff_id,customer_id,SUM(amount) AS 訂單金額
FROM payment 
GROUP BY staff_id,customer_id
ORDER BY customer_id, staff_id ASC;

/* 取出每日訂單總和 */
/* 時間轉型運算子 */
/* cast operator */
SELECT payment_date::date AS 日期, SUM(amount) AS 總和
FROM payment
GROUP BY 日期
ORDER BY 日期;


/* GROUP BY 之後要用 HAVING 子句來搜尋 */

SELECT customer_id, SUM(amount) AS 總合
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 200;

SELECT store_id, COUNT(customer_id) AS 客戶數量
FROM customer
GROUP BY store_id
HAVING COUNT(customer_id) > 300;


