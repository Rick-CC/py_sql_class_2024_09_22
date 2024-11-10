CREATE TABLE IF NOT EXISTS 市場(
	name VARCHAR(20),
	country VARCHAR(20),
	PRIMARY KEY(name),
	UNIQUE(name,country) /*資料不可以重複*/
);

CREATE TABLE IF NOT EXISTS 股市(
	stock_id SERIAL,
	date DATE,
	open NUMERIC(17,10),
	high NUMERIC(17,10),
	low NUMERIC(17,10),
	close NUMERIC(17,10),
	adj_close NUMERIC(17,10),
	volume BIGINT DEFAULT 0,
	name VARCHAR(20),
	PRIMARY KEY(stock_id),
	UNIQUE(date,name),/*資料不可以重複*/
	FOREIGN KEY(name) REFERENCES 市場(name) 
	ON DELETE NO ACTION
	ON UPDATE CASCADE
);


/*股市要有資料, 則 <市場> 要先有資料  */
INSERT INTO 市場 values('^TWII','台灣')
ON CONFLICT DO NOTHING; /*如果出錯, 不做任何事*/

SELECT * 
FROM 市場;

/* 再插入股市資料 */
/* https://github.com/roberthsu2003/python-SQLite-MySQL/blob/master/postgresSQL/tutorial_container/%E7%AF%84%E4%BE%8B/1stock_market/3%E6%96%B0%E5%A2%9E%E8%B3%87%E6%96%99.sql
*/
INSERT INTO 股市(date,open,high,low,close,adj_close,volume,name) 
values('1997-07-08',9094.26953125,9124.2998046875,8988.1298828125,8996.7197265625,8996.6865234375,0,'^TWII')
ON CONFLICT DO NOTHING;/*如果出錯, 不做任何事*/

SELECT *
FROM 股市;


/* 刪除上面的測試資料 */
DELETE FROM 股市; /* 先刪股市 */
DELETE FROM 市場; /* 再刪市場 */

SELECT *
FROM 股市;

SELECT *
FROM 股市
WHERE name = '^HSI';

SELECT * 
FROM 市場;

/* 下午 */
/* 取出市場資料 */
SELECT country,市場.name,date,adj_close,volume
FROM 股市 join 市場 on 股市.name=市場.name
WHERE country='台灣';

SELECT country,市場.name,date,adj_close,volume
FROM 股市 join 市場 on 股市.name=市場.name
WHERE country='台灣' and date = (
	SELECT MAX(date)
	FROM 股市
);


SELECT country,市場.name,date,adj_close,volume
FROM 股市 join 市場 on 股市.name=市場.name
WHERE country='台灣' and (date BETWEEN '2024-01-01' AND '2024-12-31');




