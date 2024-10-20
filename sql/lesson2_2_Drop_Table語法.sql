DROP TABLE IF EXISTS hospital;

CREATE TABLE IF NOT EXISTS hospital (
    id SERIAL PRIMARY KEY,
    state VARCHAR(5) NOT NULL,
	name VARCHAR(30) NOT NULL UNIQUE,
	phone VARCHAR(15),
	ext VARCHAR(7),
	contact VARCHAR(7),
	address VARCHAR(50)
	);

/*欄位用中文匯入資料時, 會出錯*/
DROP TABLE IF EXISTS hospital_2;
CREATE TABLE IF NOT EXISTS hospital_2 (
    "序號" SERIAL PRIMARY KEY,
    "直轄市或省轄縣市" VARCHAR(5) NOT NULL,
	"醫療機構名稱" VARCHAR(30) NOT NULL UNIQUE,
	"市話" VARCHAR(15),
	"分機" VARCHAR(7),
	"聯絡人" VARCHAR(7),
	"地址" VARCHAR(50)
	);


/* 城市, 起始時間, 結束時間, 最高溫度, 最低溫度, 感覺*/
CREATE TABLE IF NOT EXISTS weather (
    id SERIAL PRIMARY KEY,
	city VARCHAR(20) NOT NULL,
    startDate timestamp,
	endDate timestamp,
	hight real,
	low real,
	status VARCHAR(20)
	);

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