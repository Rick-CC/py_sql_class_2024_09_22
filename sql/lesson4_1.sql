-- Create Tables
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(10),
    age smallint
);

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id smallint REFERENCES students(student_id), /* 欄位限制constraint, 關聯students資料表中的student_id */
    course_name VARCHAR(20),
    grade VARCHAR(5)
);


-- Insert data into students table
INSERT INTO students (name, age) VALUES
    ('張小明', 20),
    ('李美華', 19),
    ('王大寶', 21),
    ('陳雅婷', 20),
    ('林志偉', 22);

-- Insert data into enrollments table
INSERT INTO enrollments (student_id, course_name, grade) VALUES
    (1, '資料庫系統', 'A'),
    (1, '程式設計', 'B+'),
    (2, '資料庫系統', 'A-'),
    (2, '網頁設計', 'A'),
    (3, '程式設計', 'B'),
    (3, '資料結構', 'B+'),
    (4, '資料庫系統', 'A+'),
    (4, '作業系統', 'A-'),
    (5, '網頁設計', 'B+'),
    (5, '資料庫系統', 'A-');


SELECT * FROM enrollments; 					/* 查詢單一資料表 */

SELECT * FROM enrollments join students; 	/* 有問題, JOIN 語法不完全 */

SELECT *
FROM enrollments 
join students
ON enrollments.student_id = students.student_id; /* 正確, JOIN + ON */


SELECT students.student_id,
       name,
	   age,
	   course_name,
	   grade
FROM enrollments 
join students
ON enrollments.student_id = students.student_id; /* 正確, JOIN + ON */


SELECT s.student_id,
       name,
	   age,
	   course_name,
	   grade
FROM enrollments e
join students s 
ON e.student_id = s.student_id; /* 正確, JOIN + ON */


SELECT s.student_id AS 學生編號,
               name AS 學生姓名,
	            age AS 學生年齡,
	    course_name AS 課程名稱,
	          grade AS 成績
FROM enrollments e
join students s 
ON e.student_id = s.student_id; /* 正確, JOIN + ON */

SELECT s.student_id AS 學生編號,
               name AS 學生姓名,
	            age AS 學生年齡,
	    course_name AS 課程名稱,
	          grade AS 成績
FROM enrollments e
join students s 
ON e.student_id = s.student_id /* 正確, JOIN + ON */
WHERE name = '張小明';





