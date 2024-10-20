
/* 主要資料表 */
CREATE TABLE IF NOT EXISTS stations(
	stations_id SERIAL PRIMARY KEY,
	stationCode VARCHAR(5) UNIQUE NOT NULL,
	stationName VARCHAR(20) NOT NULL,
	name VARCHAR(20),
	stationAddrTw VARCHAR(50),
	stationTel VARCHAR(20),
	gps VARCHAR(30),
	haveBike BOOLEAN
);

SELECT * FROM stations;


CREATE TABLE IF NOT EXISTS station_in_out(
	date DATE,
	staCode VARCHAR(5) NOT NULL,
	gateInComingCnt INTEGER,
	gateOutGoingCnt INTEGER,	
	PRIMARY KEY (date,staCode), -- 用2欄組合成 PK !!!
	FOREIGN KEY (staCode)	REFERENCES stations(stationCode) -- 對應參照
							ON DELETE SET NULL
							ON UPDATE CASCADE
						 /*	ON DELETE CASCADE -- 原本有刪除, 則 REFERENCE 欄位一併刪除 */
						 /* ON UPDATE CASCADE -- 原本有更新, 則 REFERENCE 欄位一併更新 */
);

SELECT * FROM station_in_out;


SELECT *
FROM station_in_out in_out JOIN stations s ON in_out.staCode = s.stationCode;


SELECT date AS 日期,
       gateInComingCnt AS 進站人數,
	   gateOutGoingCnt AS 出戰人數,
	   stationName AS 站名,
	   stationAddrTw AS 地址,
	   stationTel AS 電話
FROM station_in_out in_out JOIN stations s ON in_out.staCode = s.stationCode
WHERE stationName = '基隆';



