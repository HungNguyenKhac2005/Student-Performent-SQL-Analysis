-- Tạo database
create database STUDENT_PERFORMENT;

-- Tạo bảng dữ liệu 
create table student_performent_table(
student_id varchar(20) primary key,
gender varchar(10) not null,
age int not null,
study_hours_per_week int not null,
attendance_rate float not null,
parent_education varchar(50) not null, 
internet_access varchar(10) not null,
extracurricular varchar(10) not null,
previous_score int not null,
final_score int not null,
passed varchar(20) not null
);

-- Kiếm tra cơ sơ dữ liệu và bảng đã được tạo hay chưa
select * from student_performent_table;