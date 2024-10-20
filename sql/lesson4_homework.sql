/* 存檔為 lesson4_homework.sql ---------------*/

/*
lesson4 回家作業
全省各站點2022年進站總人數
全省各站點2022年進站總人數大於5佰萬人的站點
基隆火車站2020年,每月份進站人數
基隆火車站2020年,每月份進站人數,由多至少
基隆火車站2020,2021,2022,每年進站人數
基隆火車站,臺北火車站2020,2021,2022,每年進站人數

請使用SubQuery-------------
進站人數最多的一筆
各站點進站人數最多的一筆
*/

/* 1. 建立資料表準備存放 csv 資料 -----------------*/
/* 主要車站資料表 */
CREATE TABLE IF NOT EXISTS train_stations_tw(
	stations_id SERIAL PRIMARY KEY,
	stationCode VARCHAR(5) UNIQUE NOT NULL,
	stationName VARCHAR(20) NOT NULL,
	name VARCHAR(20),
	stationAddrTw VARCHAR(50),
	stationTel VARCHAR(20),
	gps VARCHAR(30),
	haveBike BOOLEAN
);

/* 車站進出人數紀錄 */
CREATE TABLE IF NOT EXISTS train_station_in_out(
	date DATE,
	staCode VARCHAR(5) NOT NULL,
	gateInComingCnt INTEGER,
	gateOutGoingCnt INTEGER,	
	PRIMARY KEY (date,staCode), -- 用2欄組合成 PK !!!
	FOREIGN KEY (staCode)	REFERENCES train_stations_tw(stationCode) -- 對應參照
							ON DELETE SET NULL
							ON UPDATE CASCADE
						 /*	ON DELETE CASCADE -- 原本有刪除, 則 REFERENCE 欄位一併刪除 */
						 /* ON UPDATE CASCADE -- 原本有更新, 則 REFERENCE 欄位一併更新 */
);


SELECT * FROM train_stations_tw;	/* 確認資料有 243筆 */
SELECT * FROM train_station_in_out;/* 確認資料有 406761 筆*/

/* 2. 根據問題寫出對應的sql程式碼 -----------------*/

/*
1.全省各站點2022年進站總人數 *********************************************************************
*/
SELECT * FROM train_station_in_out;
/* 連接兩個資料表, 並用 GROUP BY 合併相同欄位資料 , 並指顯示 2022 年分的資料 */
SELECT stationCode, SUM(gateInComingCnt)
FROM train_station_in_out io join train_stations_tw s_name ON io.staCode = s_name.stationCode
WHERE EXTRACT(YEAR FROM date) = 2022
GROUP BY stationCode;
/* 修改欄位名稱 */
SELECT stationName AS 站名, SUM(gateInComingCnt) 進站人數
FROM train_station_in_out io join train_stations_tw s_name ON io.staCode = s_name.stationCode
WHERE EXTRACT(YEAR FROM date) = 2022
GROUP BY stationName;
/* 加入顯示站號, 並嘗試用站號排序 */
SELECT staCode AS 站號, stationName AS 站名, SUM(gateInComingCnt) 進站人數
FROM train_station_in_out io join train_stations_tw s_name ON io.staCode = s_name.stationCode
WHERE EXTRACT(YEAR FROM date) = 2022
GROUP BY stationName, staCode
ORDER BY staCode ASC;
/* 把站號轉成 INT 才排序 */
SELECT staCode AS 站號, stationName AS 站名, SUM(gateInComingCnt) 進站人數
FROM train_station_in_out io join train_stations_tw s_name ON io.staCode = s_name.stationCode
WHERE EXTRACT(YEAR FROM date) = 2022
GROUP BY stationName, staCode
ORDER BY CAST(staCode AS INTEGER)ASC;


/*
2.全省各站點2022年進站總人數大於5佰萬人的站點 *******************************************************
*/
/* 改成用進站人數排序 */
SELECT staCode AS 站號, stationName AS 站名, SUM(gateInComingCnt) 進站人數
FROM train_station_in_out io join train_stations_tw s_name ON io.staCode = s_name.stationCode
WHERE EXTRACT(YEAR FROM date) = 2022
GROUP BY stationName, staCode
ORDER BY SUM(gateInComingCnt) DESC;
/* 在GROUP 資料後, 使用 HAVING 篩選進站人數 > 5百萬的站別 */
SELECT staCode AS 站號, stationName AS 站名, SUM(gateInComingCnt) 進站人數
FROM train_station_in_out io join train_stations_tw s_name ON io.staCode = s_name.stationCode
WHERE EXTRACT(YEAR FROM date) = 2022
GROUP BY stationName, staCode
HAVING SUM(gateInComingCnt) > 5000000
ORDER BY SUM(gateInComingCnt) DESC;

/*
3.基隆火車站2020年,每月份進站人數 *********************************************************************
*/
/* 把月份也加入 GROUP 分類內, 才能顯示各月份進站人數 */
SELECT staCode AS 站號, stationName AS 站名,EXTRACT(MONTH FROM io.date) AS 進站月份, SUM(gateInComingCnt) 進站人數
FROM train_station_in_out io join train_stations_tw s_name ON io.staCode = s_name.stationCode
WHERE EXTRACT(YEAR FROM date) = 2020 AND stationName = '基隆'
GROUP BY stationName, staCode, EXTRACT(MONTH FROM date)
ORDER BY 進站月份 ASC;

/*
4.基隆火車站2020年,每月份進站人數,由多至少 *********************************************************************
*/
/* 改成用進站人數排序 */
SELECT staCode AS 站號, stationName AS 站名,EXTRACT(MONTH FROM io.date) AS 進站月份, SUM(gateInComingCnt) 當月進站總人數
FROM train_station_in_out io join train_stations_tw s_name ON io.staCode = s_name.stationCode
WHERE EXTRACT(YEAR FROM date) = 2020 AND stationName = '基隆'
GROUP BY stationName, staCode, EXTRACT(MONTH FROM date)
ORDER BY 進站人數 DESC;
/* GROUP BY 相同 'YYYY-MM'  */
SELECT staCode AS 站號, stationName AS 站名,TO_CHAR(io.date, 'YYYY-MM') AS 進站月份, SUM(gateInComingCnt) 當月進站總人數
FROM train_station_in_out io join train_stations_tw s_name ON io.staCode = s_name.stationCode
WHERE EXTRACT(YEAR FROM date) = 2020 AND stationName = '基隆'
GROUP BY stationName, staCode, TO_CHAR(io.date, 'YYYY-MM');


/*
5.基隆火車站2020,2021,2022,每年進站人數 *********************************************************************
*/
/* 把年分加入 GROUP 分類內, 才能顯示各年分進站人數 */
SELECT staCode AS 站號, stationName AS 站名,EXTRACT(YEAR FROM io.date) AS 進站月份, SUM(gateInComingCnt) 進站人數
FROM train_station_in_out io join train_stations_tw s_name ON io.staCode = s_name.stationCode
WHERE EXTRACT(YEAR FROM date) BETWEEN 2020 AND 2022 AND stationName = '基隆'
GROUP BY stationName, staCode, EXTRACT(YEAR FROM date)
ORDER BY 進站人數 DESC;

/*
6.基隆火車站,臺北火車站2020,2021,2022,每年進站人數 ***********************************************************
*/
/* 把臺北加入 stationName 的篩選清單內 */
SELECT staCode AS 站號, stationName AS 站名,EXTRACT(YEAR FROM io.date) AS 進站月份, SUM(gateInComingCnt) 進站人數
FROM train_station_in_out io join train_stations_tw s_name ON io.staCode = s_name.stationCode
WHERE EXTRACT(YEAR FROM date) BETWEEN 2020 AND 2022 AND stationName IN ('基隆','臺北')
GROUP BY stationName, staCode, EXTRACT(YEAR FROM date)
ORDER BY 進站人數 DESC;

SELECT staCode AS 站號, stationName AS 站名,EXTRACT(YEAR FROM io.date) AS 進站月份, SUM(gateInComingCnt) 進站人數
FROM train_station_in_out io join train_stations_tw s_name ON io.staCode = s_name.stationCode
WHERE EXTRACT(YEAR FROM date) IN (2020,2021,2022) AND stationName IN ('基隆','臺北')
GROUP BY stationName, staCode, EXTRACT(YEAR FROM date)
ORDER BY 進站人數 DESC;

/*
請使用SubQuery-------------
進站人數最多的一筆
各站點進站人數最多的一筆
*/

SELECT * FROM train_stations_tw;	/* 確認資料有 243筆 */
SELECT * FROM train_station_in_out;/* 確認資料有 406761 筆*/

SELECT staCode AS 站號, stationName AS 站名, MAX(gateInComingCnt) 進站人數
FROM train_station_in_out io join train_stations_tw s_name ON io.staCode = s_name.stationCode
GROUP BY stationName, staCode
ORDER BY 進站人數 DESC
LIMIT 1;

/*
7.進站人數最多的一筆 [請使用SubQuery]
*/
SELECT io.date AS 日期, io.staCode AS 站號, s_name.stationName AS 站名, io.gateInComingCnt AS 進站人數
FROM train_station_in_out io JOIN train_stations_tw s_name ON io.staCode = s_name.stationCode
WHERE io.gateInComingCnt = (
    SELECT MAX(gateInComingCnt)
    FROM train_station_in_out
);

/*
8.各站點進站人數最多的一筆 [請使用SubQuery]
*/
/* <同一站> 會有多筆 = 0 的資料*/
SELECT io.date AS 日期, io.staCode AS 站號, s_name.stationName AS 站名, io.gateInComingCnt AS 進站人數
FROM train_station_in_out io JOIN train_stations_tw s_name ON io.staCode = s_name.stationCode
WHERE (io.staCode,io.gateInComingCnt) IN (
    SELECT staCode,MAX(gateInComingCnt)
    FROM train_station_in_out
    GROUP BY staCode
)
ORDER BY 進站人數 DESC;

/* 把站號 使用 Group 組合起來 */
SELECT MAX(io.date) AS 日期, io.staCode AS 站號, s_name.stationName AS 站名, MAX(io.gateInComingCnt) AS 進站人數
FROM train_station_in_out io JOIN train_stations_tw s_name ON io.staCode = s_name.stationCode
WHERE (io.staCode,io.gateInComingCnt) IN (
    SELECT staCode,MAX(gateInComingCnt)
    FROM train_station_in_out
    GROUP BY staCode
)
GROUP BY io.staCode,s_name.stationName
ORDER BY 進站人數 DESC;

/* 把站名 使用 Group 組合起來 */
SELECT MAX(io.date) AS 日期, MAX(io.staCode) AS 站號, s_name.stationName AS 站名, MAX(io.gateInComingCnt) AS 進站人數
FROM train_station_in_out io JOIN train_stations_tw s_name ON io.staCode = s_name.stationCode
WHERE (io.staCode,io.gateInComingCnt) IN (
    SELECT staCode,MAX(gateInComingCnt)
    FROM train_station_in_out
    GROUP BY staCode
)
GROUP BY s_name.stationName
ORDER BY 進站人數 DESC;

/* 241筆 staCode */
SELECT staCode,MAX(gateInComingCnt) AS 最大值
FROM train_station_in_out
GROUP BY staCode
ORDER BY 最大值;

/* 243筆 stationName */
SELECT stationName
FROM train_stations_tw
GROUP BY stationName;

/* 只印出 241筆資料 */
SELECT s_name.stationName,SUM(io.gateInComingCnt) AS 最大值
FROM train_station_in_out io JOIN train_stations_tw s_name ON io.staCode = s_name.stationCode
GROUP BY s_name.stationName
ORDER BY 最大值;

/* 找出2筆沒有對應的 */
SELECT s_name.stationName
FROM train_stations_tw s_name
LEFT JOIN train_station_in_out io ON s_name.stationCode = io.staCode
WHERE io.staCode IS NULL;

/* 正確列出對應的 243 筆資料*/
SELECT MAX(io.date) AS 日期, io.staCode AS 站號, s_name.stationName AS 站名, COALESCE(SUM(io.gateInComingCnt), 0) AS 進站人數
FROM train_station_in_out io RIGHT JOIN train_stations_tw s_name ON io.staCode = s_name.stationCode
/* WHERE io.staCode IS NULL */
GROUP BY io.staCode,s_name.stationName
ORDER BY 進站人數 ASC;


