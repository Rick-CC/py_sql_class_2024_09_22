/* 車站代號	車站中文名稱	車站英文名稱 */
/* 車站英文名稱  有多個na, 所以不能用 UNIQUE*/
CREATE TABLE IF NOT EXISTS station_mapping (
    id SERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL ,
    name VARCHAR(20) UNIQUE NOT NULL,
    e_name VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS station_mapping;

select * FROM station_mapping


/* Day3 ---------------  */
/* 使用 SQL語法修改 欄位屬性 */
ALTER TABLE station_mapping
ALTER COLUMN name 
TYPE VARCHAR(25);

ALTER TABLE station
DROP CONSTRAINT
station_code_key;

ALTER TABLE station
ADD CONSTRAINT
station_code_key
UNIQUE (code);

/* 換資料表名稱 */
ALTER TABLE station_mapping
RENAME TO station;

/* SELECT */
/* 選取資料*/
SELECT code, name
FROM station;

SELECT (code, name)
FROM station;

/* 選取資料 + 把顯示的欄位名稱 轉換 ------------------------------------------------------- */
SELECT code as 代碼
FROM station;

SELECT code as 代碼, name as 車站名稱, e_name as 車站英文
FROM station;

SELECT id as 序號, code as 代碼, name as 車站名稱, e_name as 車站英文
FROM station;

/* 選取資料 + 資料篩選, 選取特定資料 ------------------------------------------------------- */
SELECT id as 序號, code as 代碼, name as 車站名稱, e_name as 車站英文
FROM station
WHERE code = '1001' OR code = '1002';

SELECT *
FROM station
WHERE code IN ('1001','1002','1003');

SELECT *
FROM station
WHERE id >= 5 AND id <= 10;

SELECT *
FROM station
WHERE id < 10 OR id > 20;

SELECT *
FROM station
WHERE id BETWEEN 10 AND 20;

SELECT *
FROM station
WHERE id NOT BETWEEN 10 AND 20;


/* [補充] 把CHAR 轉成數值在篩選 ------------------------------------------------------- */
SELECT *
FROM station
WHERE CAST(code AS INTEGER) BETWEEN 1001 AND 1004;


/* 使用 LIKE <模糊> 篩選字串資料 ------------------------------------------------------- */
/* ILIKE 用在 英文大小寫忽略*/
/* _ 為1個萬用字, %數個萬用字*/
SELECT *
FROM station
WHERE name LIKE '台_'
WHERE name LIKE '台%';

SELECT *
FROM station
WHERE name LIKE '%中%';


/* 10/06 下午 */
/* 排序 ORDER 預設 由小到大*/ 
SELECT id as 序號, code as 代碼, name as 車站名稱, e_name as 車站英文
FROM station
ORDER BY id;
/* 排序 ORDER , 加上 DESC 變成由大到小*/ 
SELECT id as 序號, code as 代碼, name as 車站名稱, e_name as 車站英文
FROM station
ORDER BY id DESC;

/* 英文加上 DESC 變成反向排序*/ 
SELECT id as 序號, code as 代碼, name as 車站名稱, e_name as 車站英文
FROM station
ORDER BY e_name DESC;

/* 英文加上 DESC 變成反向排序 + LIMIT 只顯示最後 5項資料 */ 
SELECT *
FROM station
ORDER BY e_name DESC
LIMIT 5;


/* 插入 INSERT ------------------------------------*/
INSERT INTO station

/* 但先建立資料表 -> 預設建法 */
CREATE TABLE student(
	student_id SERIAL PRIMARY KEY,
	name VARCHAR(20),
	major VARCHAR(20)
);

/* 但先建立資料表 -> constrance 限制換種寫法 
直接指定資料表的 PRIMARY KEY 項目 */
CREATE TABLE student(
	student_id SERIAL,
	name VARCHAR(20),
	major VARCHAR(20),
	PRIMARY KEY(student_id)
);

SELECT *
FROM student;


/* 增加資料 */
INSERT INTO student(name,major)
VALUES ('小白','歷史');

/* 增加資料 + 調換順序 */
INSERT INTO student(major,name)
VALUES ('生物','小黑');




/* 增加資料 + 調換順序 + 存入 NULL */
INSERT INTO student(major,name)
VALUES (NULL,'小藍');

SELECT * FROM student;

/* 一次 增加 多筆 資料  */
INSERT INTO student	(major,name)
VALUES 				('國文','小憲'),
					('數學','小綠');

/* 最後一行, 直接顯示 新增的項目 */
INSERT INTO student	(major,name)
VALUES 				('生物','小綠'),
					('歷史','小綠')
RETURNING*;



/* 開始講解 DELETE ----------------------------------*/

/* 先刪除student, */
DROP TABLE IF EXISTS student;
ALTER TABLE student
RENAME TO station_old_1006;

DROP TABLE IF EXISTS student;
CREATE TABLE IF NOT EXISTS student(
    student_id SERIAL,
	name VARCHAR(20),
	major VARCHAR(20),
	score INT,
	PRIMARY KEY (student_id)
);

INSERT INTO student VALUES(1,'小白','英文',50);
INSERT INTO student VALUES(2,'小黃','生物',60);
INSERT INTO student VALUES(3,'小綠','歷史',70);
INSERT INTO student VALUES(4,'小藍','英文',80);
INSERT INTO student VALUES(5,'小黑','化學',90);
SELECT * FROM student;


DELETE FROM student; /* 全部資料刪除 */
SELECT * FROM student;


INSERT INTO student 
VALUES	(1,'小白','英文',50),
		(2,'小黃','生物',60),
		(3,'小綠','歷史',70),
		(4,'小藍','英文',80),
		(5,'小黑','化學',90)
RETURNING *;

DELETE FROM student
WHERE name = '小白'; /* 刪除特定資料 , 使用 WHERE 帶入條件*/

SELECT * FROM student;

/*............................*/
DELETE FROM student; /* 全部資料刪除 */
INSERT INTO student 
VALUES	(1,'小白','英文',50),
		(2,'小黃','生物',60),
		(3,'小綠','歷史',70),
		(4,'小藍','英文',80),
		(5,'小黑','化學',90)
RETURNING *;

DELETE FROM student
WHERE name LIKE '小%'; /* 刪除 <小> 開頭的特定資料 , 使用 WHERE + LIKE 模糊搜尋'帶入條件*/

SELECT * FROM student;

/*............................*/
DELETE FROM student; /* 全部資料刪除 */
INSERT INTO student 
VALUES	(1,'小白','英文',50),
		(2,'小黃','生物',60),
		(3,'小綠','歷史',70),
		(4,'小藍','英文',80),
		(5,'小黑','化學',90)
RETURNING *;

/* 修改特定資料的特定欄位*/
UPDATE student
SET major = '英語文學'
WHERE major = '英文';
SELECT * FROM student;


SELECT * FROM student;

UPDATE student
SET  major = '生化'
WHERE major = '生物' OR major = '化學';
SELECT * FROM student;

