/* 
   1 先把 dvdrental.zip 解壓縮到本機資料夾中
   2 連上pg4 的 server , 右鍵使用 resotre 選擇前一步的資料夾 & 恢復上去
   3 reflash Server / Schemas 
   4 查看 table 名為 "customer" 的資料表
     或是透過 Query Tool 輸入 SELECT * FROM customer
   5 點選Save file, 檔名可命名為 lesson3_homework
   6 完成以下項目
*/

SELECT * FROM customer;

/* first_name為Jamie -------------------------------------------------*/
SELECT *
FROM customer
WHERE first_name = 'Jamie';

/* first_name是Jamie,同時last_name是Rice --------------------------------*/
SELECT *
FROM customer
WHERE first_name = 'Jamie' AND last_name = 'Rice';

/* last_name是Rodriquez 或者 first_name是Adam ---------------------------*/
SELECT *
FROM customer
WHERE last_name = 'Rodriquez' OR first_name = 'Adam';

/* 取出first_name是Ann，Anne，Annie --------------------------------------*/
SELECT *
FROM customer
WHERE first_name = 'Ann' OR 
      first_name = 'Anne' OR
      first_name = 'Annie';

/* 取出字串開頭是Ann的first_name --------------------------------------------*/
SELECT *
FROM customer
WHERE first_name LIKE 'Ann%'
ORDER BY first_name;

/* 取出first_name第1個字元是A,同時first_name的字元長度是3到5的資料 ---------------*/
SELECT *
FROM customer
WHERE first_name LIKE 'A%' AND
      LENGTH(first_name) BETWEEN 3 AND 5;

/* 取出first_name,前3字為Bra,但last_name不是Motley --------------------------*/
SELECT *
FROM customer
WHERE first_name LIKE 'Bra%' AND last_name != 'Motley';

SELECT *
FROM customer
WHERE first_name in ('Ann', 'Anne', 'Annie');


