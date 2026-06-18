-- TIẾN HÀNH PHÂN TÍCH DỮ LIỆU TÌM RA INSIGHTS
-- Các hàm sử dụng để phân tích dữ liệu

-- Load dữ liệu lên
select 
*
from student_performent_table
limit 15;

-- Thống kê về ty lệ giới tính
select
gender,
count(gender) as total
from student_performent_table
group by gender;

-- Thống kê về trình độ học vấn
select
parent_education,
count(parent_education) as total
from student_performent_table
group by parent_education
order by total desc;

-- Thống kê về tỷ lệ passed
select 
passed,
count(passed) as total
from student_performent_table
group by passed;

-- Thống kê về tỷ lệ có mạng sử dụng
select 
internet_access,
count(internet_access) as total
from student_performent_table
group by internet_access;

-- Thống kê về tỷ lệ hoạt động ngoại khóa
select
extracurricular,
count(extracurricular) as total
from student_performent_table
group by extracurricular;

-- Thống kê về các biến numerical
CREATE VIEW describe_statis AS
WITH describe_statistic AS(
SELECT
    'age' AS metric_name,
    COUNT(*) AS total_sample,
    AVG(age) AS avg,
    STDDEV_SAMP(age) AS std,
    MIN(age) AS min,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY age) AS Q1,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY age) AS Q2,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY age) AS Q3,
    MAX(age) AS max
FROM student_performent_table

UNION ALL

SELECT
    'study_hours_per_week' AS metric_name,
    COUNT(*) AS total_sample,
    AVG(study_hours_per_week) AS avg,
    STDDEV_SAMP(study_hours_per_week) AS std,
    MIN(study_hours_per_week) AS min,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY study_hours_per_week) AS Q1,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY study_hours_per_week) AS Q2,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY study_hours_per_week) AS Q3,
    MAX(study_hours_per_week) AS max
FROM student_performent_table

UNION ALL

SELECT
    'attendance_rate' AS metric_name,
    COUNT(*) AS total_sample,
    AVG(attendance_rate) AS avg,
    STDDEV_SAMP(attendance_rate) AS std,
    MIN(attendance_rate) AS min,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY attendance_rate) AS Q1,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY attendance_rate) AS Q2,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY attendance_rate) AS Q3,
    MAX(attendance_rate) AS max
FROM student_performent_table

UNION ALL

SELECT
    'previous_score' AS metric_name,
    COUNT(*) AS total_sample,
    AVG(previous_score) AS avg,
    STDDEV_SAMP(previous_score) AS std,
    MIN(previous_score) AS min,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY previous_score) AS Q1,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY previous_score) AS Q2,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY previous_score) AS Q3,
    MAX(previous_score) AS max
FROM student_performent_table

UNION ALL

SELECT
    'final_score' AS metric_name,
    COUNT(*) AS total_sample,
    AVG(final_score) AS avg,
    STDDEV_SAMP(final_score) AS std,
    MIN(final_score) AS min,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY final_score) AS Q1,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY final_score) AS Q2,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY final_score) AS Q3,
    MAX(final_score) AS max
FROM student_performent_table
)
SELECT * FROM describe_statistic;

select * from describe_statis;

-- Phân tích tỷ lệ đỗ và điểm cuối kì của học sinh theo nhân khẩu học
create view student_pass_rate_by_gender_age_group as
with age_group_by_grade as (
select
age,
gender,
final_score,
passed,
case 
	when age >= 15 and age <= 16 then 'Lớp 10'
	when age > 16 and age <= 17 then 'lớp 11'
	when age > 17 and age <=18 then 'lớp 12'
	when age > 18 then '18+'
end as age_group
from student_performent_table
)

select
gender,
age_group,
count(*) as total,
round(AVG(final_score)::numeric, 2) as final_score_avg,
PERCENTILE_CONT(0.5) within group (order by final_score) as median_final_score,
count(passed) filter (where passed = 'Yes') as total_passed,
round((((count(passed) filter (where passed = 'Yes'))::float/(count(passed))::float)*100.0)::numeric, 2) as percent_passed
from age_group_by_grade
group by
gender,
age_group
order by percent_passed desc;

select * from student_pass_rate_by_gender_age_group;

-- Phân tích mức độ duy trì phong độ học tập và động lực học tập của học sinh qua 2 kì thi 
create view vw_student_performance_trend_distribution as
with cte_Score_Variance_group as (
select 
previous_score,
final_score,
case
	when final_score - previous_score >= 10 then 'Tiến bộ'
	when final_score - previous_score <= -10 then 'Sa sút'
	else 'Giữ vững'
end as Score_Variance_group
from student_performent_table
)

select
Score_Variance_group,
count(*) as total,
round((count(Score_Variance_group)::float * 100.0/sum(count(*)) over ())::numeric, 2) as percent
from cte_Score_Variance_group
group by Score_Variance_group;

select * from vw_student_performance_trend_distribution;

-- Phân tích thói quen, hành vi của học sinh ảnh hưởng như thế nào đến kết quả học tập và tỷ lệ đỗ kỳ thi

create view vw_study_hours_attendance_performance_matrix as
with study_attendance_groups as (
select
study_hours_per_week,
attendance_rate,
final_score,
passed,
case 
	when study_hours_per_week >= 2 and study_hours_per_week < 8 then 'Học ít'
	when study_hours_per_week >= 8 and study_hours_per_week < 14 then 'Học trung bình'
	when study_hours_per_week >= 14 and study_hours_per_week < 23 then 'Học nhiều'
	when study_hours_per_week >= 23 and study_hours_per_week <= 30 then 'Học rất nhiều'
end as study_hours_per_week_group,

case
	when attendance_rate >=50.2 and attendance_rate < 64.5 then 'Tham ra rất ít'
	when attendance_rate >= 64.5 and attendance_rate < 76.2 then 'Tham gia ít'
	when attendance_rate >= 76.2 and attendance_rate < 87.6 then 'Tham giá trung bình'
	when attendance_rate >= 87.6 and attendance_rate <= 100 then 'Tham gia rất đầy đủ '
end as attendance_rate_group
from student_performent_table
)

select
attendance_rate_group,
study_hours_per_week_group,
count(*) as total,
round(AVG(final_score)::numeric, 2) as avg_final_score,
PERCENTILE_CONT(0.5) within group (order by final_score) as median_final_score,
count(passed) filter (where passed = 'Yes') as total_passed,
round((count(passed) filter (where passed = 'Yes')::float * 100.0 / count(passed)::float)::numeric, 2) as percent
from study_attendance_groups
group by 
attendance_rate_group,
study_hours_per_week_group;

select * from vw_study_hours_attendance_performance_matrix;

-- Phân tích sự ảnh hưởng của yếu tố kinh tế và xã hội đến giáo dục
select 
parent_education,
internet_access,
count(*) as total,
round(AVG(final_score)::numeric, 2) as avg_final_score,
PERCENTILE_CONT(0.5) within group (order by final_score) as medium_finale_score,
count(passed) filter (where passed = 'Yes') as total_passed,
round(((count(passed) filter (where passed = 'Yes')::float*100.0)/count(passed)::float)::numeric, 2) as percent_passed
from student_performent_table
group by 
parent_education,
internet_access;

-- Phân tích đánh giá hoạt động ngoại khóa là gánh nặng hay đòn bẩy cho học tập
create view vw_study_hours_extracurricular_performance as
with study_hours_extracurricular_groups as (
select
study_hours_per_week,
extracurricular,
final_score,
case
	when study_hours_per_week < 8 then '< 8h'
	when study_hours_per_week >= 8 and study_hours_per_week <= 23 then '8 <= and <= 23'
	when study_hours_per_week > 23 then '> 23'
end as study_hours_per_week_group
from student_performent_table
)

select 
extracurricular,
study_hours_per_week_group,
round(avg(final_score)::numeric, 2) as avg_final_score
from study_hours_extracurricular_groups
group by 
extracurricular,
study_hours_per_week_group;

select * from vw_study_hours_extracurricular_performance;

-- Phân tích các học sinh đặc biệt để giáo viên có cách hỗ trợ
create view vw_resilient_high_achieversss as
with final_score_index as (
select
final_score,
student_id,
internet_access,
previous_score,
gender,
age,
row_number() over (order by final_score desc) as rn
from student_performent_table
)

select 
student_id,
gender,
age,
final_score,
internet_access,
previous_score
from final_score_index
where internet_access = 'No' 
and previous_score < 50 
and final_score > (select 
final_score 
from final_score_index
where rn = 38);

select * from vw_resilient_high_achieversss;

create view vw_high_effort_underperformerss as
select 
student_id,
attendance_rate,
study_hours_per_week,
passed,
gender,
age
from student_performent_table
where 
attendance_rate > 70
and study_hours_per_week > 15
and passed = 'No';

select 
* 
from 
vw_high_effort_underperformerss;

-- Phân tích top 3 học sinh có thành tích tốt theo parent education
create view top_3_students_by_parent_education as
with student_rank as (
select 
student_id,
final_score,
parent_education,
DENSE_RANK() over(
PARTITION  by parent_education
order by final_score desc) as top
from student_performent_table
)

select 
student_id,
final_score,
parent_education,
top
from
student_rank
where top <= 3;

-- Phân tích sự đúng đắn của dữ liệu
select 
stddev(final_score) as std_final_score,
AVG(final_score) as avg_final_score,
PERCENTILE_CONT(0.5) within group (order by final_score) as medium_final_score,
max(final_score) as max_final_score,
min(final_score) as min_final_score
from student_performent_table
where 
attendance_rate > 90;




