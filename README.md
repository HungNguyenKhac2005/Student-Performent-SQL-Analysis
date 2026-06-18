# 🧠 Student-Performance-SQL-Analysis

Dự án phân tích dữ liệu hiệu suất học tập của học sinh bằng SQL trên PostgreSQL. Sử dụng các kỹ thuật truy vấn từ cơ bản đến nâng cao để trích xuất các chỉ số KPI quan trọng, hỗ trợ Ban giám hiệu đưa ra các quyết định giáo dục tối ưu.

---

## ✒️ Giới thiệu về tác giả

- **Tên:** Nguyễn Khắc Hưng
- **Vị trí:** Data Analyst
- **Học văn:** Đang theo học chương trình kỹ sư ngành Khoa học Dữ liệu, chuyên ngành Phân tích Dữ liệu trong Kinh tế và Tài chính, thuộc Khoa Công nghệ Thông tin, Đại học Mỏ - Địa chất.

---

## 📊 Cấu trúc cơ sở dữ liệu (Database Schema)

Cơ sở dữ liệu bao gồm bảng chính [student_performent_table](file:///C:/SQL_/PostgresSQL/student_performent/Schema/Schema.sql) chứa thông tin của học sinh:

| Tên trường             | Kiểu dữ liệu  | Mô tả                                   |
| :--------------------- | :------------ | :-------------------------------------- |
| `student_id`           | `VARCHAR(20)` | Mã học sinh (Khóa chính)                |
| `gender`               | `VARCHAR(10)` | Giới tính                               |
| `age`                  | `INT`         | Tuổi của học sinh                       |
| `study_hours_per_week` | `INT`         | Số giờ tự học mỗi tuần                  |
| `attendance_rate`      | `FLOAT`       | Tỷ lệ chuyên cần (%)                    |
| `parent_education`     | `VARCHAR(50)` | Trình độ học vấn cao nhất của phụ huynh |
| `internet_access`      | `VARCHAR(10)` | Tình trạng truy cập Internet (Yes/No)   |
| `extracurricular`      | `VARCHAR(10)` | Tham gia hoạt động ngoại khóa (Yes/No)  |
| `previous_score`       | `INT`         | Điểm thi kỳ trước                       |
| `final_score`          | `INT`         | Điểm thi cuối kỳ                        |
| `passed`               | `VARCHAR(20)` | Trạng thái đỗ kỳ thi (Yes/No)           |

> [!NOTE]
> Chi tiết tập lệnh khởi tạo cơ sở dữ liệu xem tại [Schema.sql](file:///C:/SQL_/PostgresSQL/student_performent/Schema/Schema.sql).

---

## 📌 Đặt vấn đề (Problem Statements)

Dưới đây là 10 bài toán phân tích nghiệp vụ được đưa ra để đánh giá hiệu quả học tập và đề xuất giải pháp cải thiện chất lượng giảng dạy:

1.  **VẤN ĐỀ 1: Bức tranh tổng quan về tỷ lệ đỗ và nhân khẩu học (Descriptive Analytics)**
    - _Yêu cầu:_ Tính tổng số học sinh, điểm cuối kỳ trung bình, và tỷ lệ đỗ (Pass Rate) chia theo từng độ tuổi và giới tính. Sắp xếp theo tỷ lệ đỗ giảm dần.
2.  **VẤN ĐỀ 2: Phân tích sự tiến bộ và sa sút của học sinh (Diagnostic Analytics)**
    - _Yêu cầu:_ So sánh điểm thi kỳ này với kỳ trước của từng học sinh để phân nhóm thành 3 xu hướng học tập: "Tiến bộ" (Improved), "Giữ vững" (Stable), và "Sa sút" (Declined). Tính tỷ trọng (%) của mỗi nhóm.
3.  **VẤN ĐỀ 3: Tác động của Thói quen học tập đến Kết quả (Segmentation & Trend Analysis)**
    - _Yêu cầu:_ Phân loại học sinh theo các dải giờ tự học và tỷ lệ chuyên cần. Thống kê điểm cuối kỳ trung bình và tỷ lệ đỗ của từng nhóm để đo lường ROI của sự chăm chỉ.
4.  **VẤN ĐỀ 4: Đo lường rào cản ngoại cảnh - Nền tảng Gia đình & Internet (Comparative Analysis)**
    - _Yêu cầu:_ Kết hợp trình độ học vấn của phụ huynh và quyền truy cập Internet để đo lường sự chênh lệch điểm số trung bình và tỷ lệ đỗ giữa các nhóm kinh tế - xã hội.
5.  **VẤN ĐỀ 5: Đánh giá Hoạt động Ngoại khóa - Gánh nặng hay Đòn bẩy? (Diagnostic Analytics)**
    - _Yêu cầu:_ So sánh điểm cuối kỳ giữa học sinh tham gia và không tham gia hoạt động ngoại khóa, phân nhóm theo thời gian tự học tự chọn để loại bỏ yếu tố gây nhiễu.
6.  **VẤN ĐỀ 6: Truy tìm những nhân tố "Đột biến" và "Cá biệt" (Anomaly Detection)**
    - _Yêu cầu:_ Lọc ra top 5 học sinh "Vượt khó" (Không internet, điểm xuất phát thấp nhưng điểm thi cuối kỳ xuất sắc) và top 5 học sinh "Tụt dốc bất thường" (Chuyên cần cao, học nhiều nhưng kết quả trượt).
7.  **VẤN ĐỀ 7: Bảng xếp hạng Học giả Cấp trường (Ranking & Subqueries)**
    - _Yêu cầu:_ Tìm ra Top 3 học sinh có điểm cuối kỳ cao nhất theo từng nhóm học vấn phụ huynh (sử dụng logic xếp hạng không bỏ sót học sinh bằng điểm ở vị trí thứ 3).
8.  **VẤN ĐỀ 8: Chấm điểm Rủi ro (Risk Scoring System) cho năm học tới (Risk Detection)**
    - _Yêu cầu:_ Xây dựng hệ thống tính điểm rủi ro (Risk Score từ 0 đến 3) dựa trên: chuyên cần thấp, giờ học ít, điểm kỳ trước kém. Thống kê phân bổ học sinh và tỷ lệ trượt thực tế theo từng cấp độ rủi ro.
9.  **VẤN ĐỀ 9: Phân tích sự trung thành/đều đặn của dữ liệu (Data Quality & Root Cause)**
    - _Yêu cầu:_ Tính độ lệch chuẩn (Standard Deviation), giá trị lớn nhất, nhỏ nhất và trung bình của điểm cuối kỳ đối với nhóm học sinh đi học chuyên cần trên 90%.
10. **VẤN ĐỀ 10: Master View - Dữ liệu nền tảng cho Ban giám hiệu (Data Engineering / View Creation)**
    - _Yêu cầu:_ Tạo một View tổng hợp chuẩn hóa tích hợp sẵn các chỉ báo đã tính toán (`score_progress`, `risk_flag`, `academic_tier`) để phục vụ truy vấn báo cáo trực tiếp nhanh chóng.

---

## 🛠️ Công cụ sử dụng (Tools)

- **PostgreSQL 17**: Hệ quản trị cơ sở dữ liệu quan hệ chính sử dụng để lưu trữ và tối ưu hóa truy vấn dữ liệu.
- **SQL (DQL, DDL, DML)**: Viết các CTE phức tạp, hàm cửa sổ (Window Functions), phân tích thống kê và khởi tạo View.
- **DBeaver IDE**: Môi trường làm việc trực quan quản trị cơ sở dữ liệu và phát triển truy vấn.

---

## 📊 Phân tích chi tiết (Data Analysis & Insights)

> [!IMPORTANT]
> Toàn bộ mã nguồn truy vấn phân tích được lưu trữ và cập nhật tại tệp tin [Analysis/Analysis.sql](file:///C:/SQL_/PostgresSQL/student_performent/Analysis/Analysis.sql).

### 📍 Vấn đề 1: Bức tranh tổng quan về tỷ lệ đỗ và nhân khẩu học

#### **Mã truy vấn SQL**

```sql
CREATE OR REPLACE VIEW student_pass_rate_by_gender_age_group AS
WITH age_group_by_grade AS (
    SELECT
        age,
        gender,
        final_score,
        passed,
        CASE
            WHEN age >= 15 AND age <= 16 THEN 'Lớp 10'
            WHEN age > 16 AND age <= 17 THEN 'lớp 11'
            WHEN age > 17 AND age <= 18 THEN 'lớp 12'
            WHEN age > 18 THEN '18+'
        END AS age_group
    FROM student_performent_table
)
SELECT
    gender,
    age_group,
    COUNT(*) AS total,
    ROUND(AVG(final_score)::numeric, 2) AS final_score_avg,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY final_score) AS median_final_score,
    COUNT(passed) FILTER (WHERE passed = 'Yes') AS total_passed,
    ROUND((((COUNT(passed) FILTER (WHERE passed = 'Yes'))::float / (COUNT(passed))::float) * 100.0)::numeric, 2) AS percent_passed
FROM age_group_by_grade
GROUP BY gender, age_group
ORDER BY percent_passed DESC;

-- Xem kết quả
SELECT * FROM student_pass_rate_by_gender_age_group;
```

#### **Kết quả truy vấn (Output)**

| Giới tính (gender) | Khối lớp (age_group) | Sĩ số (total) | Điểm trung bình cuối kỳ (final_score_avg) | Trung vị điểm cuối kỳ (median_final_score) | Tổng số đỗ (total_passed) | Tỷ lệ đỗ (percent_passed) |
| :----------------- | :------------------- | :-----------: | :---------------------------------------: | :----------------------------------------: | :-----------------------: | :-----------------------: |
| Male               | lớp 12               |      38       |                   57.53                   |                    59.5                    |            28             |          73.68%           |
| Male               | Lớp 10               |      62       |                   57.84                   |                    58.5                    |            43             |          69.35%           |
| Female             | Lớp 10               |      79       |                   55.85                   |                    56.0                    |            52             |          65.82%           |
| Female             | lớp 12               |      38       |                   55.32                   |                    56.5                    |            25             |          65.79%           |
| Male               | lớp 11               |      36       |                   55.14                   |                    55.0                    |            23             |          63.89%           |
| Male               | 18+                  |      42       |                   52.55                   |                    52.0                    |            25             |          59.52%           |
| Female             | lớp 11               |      47       |                   55.85                   |                    54.0                    |            27             |          57.45%           |
| Female             | 18+                  |      41       |                   54.76                   |                    52.0                    |            22             |          53.66%           |

#### **Nhận xét & Insight (Insights)**

- _[Viết nhận xét của bạn vào đây]_

---

### 📍 Vấn đề 2: Phân tích sự tiến bộ và sa sút của học sinh

#### **Mã truy vấn SQL**

```sql
CREATE OR REPLACE VIEW vw_student_performance_trend_distribution AS
WITH cte_Score_Variance_group AS (
    SELECT
        previous_score,
        final_score,
        CASE
            WHEN final_score - previous_score >= 10 THEN 'Tiến bộ'
            WHEN final_score - previous_score <= -10 THEN 'Sa sút'
            ELSE 'Giữ vững'
        END AS Score_Variance_group
    FROM student_performent_table
)
SELECT
    Score_Variance_group,
    COUNT(*) AS total,
    ROUND((COUNT(Score_Variance_group)::float * 100.0 / SUM(COUNT(*)) OVER ())::numeric, 2) AS percent
FROM cte_Score_Variance_group
GROUP BY Score_Variance_group;

-- Xem kết quả
SELECT * FROM vw_student_performance_trend_distribution;
```

#### **Kết quả truy vấn (Output)**

| Xu thái học lực (score_variance_group) | Số lượng học sinh (total) | Tỷ lệ (%) |
| :------------------------------------- | :-----------------------: | :-------: |
| Tiến bộ                                |            92             |  24.02%   |
| Sa sút                                 |            180            |  47.00%   |
| Giữ vững                               |            111            |  28.98%   |

#### **Nhận xét & Insight (Insights)**

- _[Viết nhận xét của bạn vào đây]_

---

### 📍 Vấn đề 3: Tác động của Thói quen học tập đến Kết quả

#### **Mã truy vấn SQL**

```sql
CREATE OR REPLACE VIEW vw_study_hours_attendance_performance_matrix AS
WITH study_attendance_groups AS (
    SELECT
        study_hours_per_week,
        attendance_rate,
        final_score,
        passed,
        CASE
            WHEN study_hours_per_week >= 2 AND study_hours_per_week < 8 THEN 'Học ít'
            WHEN study_hours_per_week >= 8 AND study_hours_per_week < 14 THEN 'Học trung bình'
            WHEN study_hours_per_week >= 14 AND study_hours_per_week < 23 THEN 'Học nhiều'
            WHEN study_hours_per_week >= 23 AND study_hours_per_week <= 30 THEN 'Học rất nhiều'
        END AS study_hours_per_week_group,
        CASE
            WHEN attendance_rate >= 50.2 AND attendance_rate < 64.5 THEN 'Tham gia rất ít'
            WHEN attendance_rate >= 64.5 AND attendance_rate < 76.2 THEN 'Tham gia ít'
            WHEN attendance_rate >= 76.2 AND attendance_rate < 87.6 THEN 'Tham gia trung bình'
            WHEN attendance_rate >= 87.6 AND attendance_rate <= 100 THEN 'Tham gia rất đầy đủ'
        END AS attendance_rate_group
    FROM student_performent_table
)
SELECT
    attendance_rate_group,
    study_hours_per_week_group,
    COUNT(*) AS total,
    ROUND(AVG(final_score)::numeric, 2) AS avg_final_score,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY final_score) AS median_final_score,
    COUNT(passed) FILTER (WHERE passed = 'Yes') AS total_passed,
    ROUND((COUNT(passed) FILTER (WHERE passed = 'Yes')::float * 100.0 / COUNT(passed)::float)::numeric, 2) AS percent
FROM study_attendance_groups
GROUP BY attendance_rate_group, study_hours_per_week_group;

-- Xem kết quả
SELECT * FROM vw_study_hours_attendance_performance_matrix;
```

#### **Kết quả truy vấn (Output)**

| Tần suất chuyên cần (attendance_rate_group) | Mức độ học tập (study_hours_per_week_group) | Số học sinh (total) | Điểm trung bình (avg_final_score) | Trung vị điểm (median_final_score) | Số lượng đỗ (total_passed) | Tỷ lệ đỗ (percent) |
| :------------------------------------------ | :------------------------------------------ | :-----------------: | :-------------------------------: | :--------------------------------: | :------------------------: | :----------------: |
| Tham gia ít                                 | Học ít                                      |         24          |               40.71               |                41.5                |             5              |       20.83%       |
| Tham gia ít                                 | Học nhiều                                   |         26          |               58.54               |                58.5                |             20             |       76.92%       |
| Tham gia ít                                 | Học rất nhiều                               |         28          |               71.68               |                73.5                |             28             |      100.00%       |
| Tham gia ít                                 | Học trung bình                              |         18          |               46.39               |                46.0                |             7              |       38.89%       |
| Tham gia rất đầy đủ                         | Học ít                                      |         23          |               45.57               |                45.0                |             7              |       30.43%       |
| Tham gia rất đầy đủ                         | Học nhiều                                   |         23          |               65.52               |                65.0                |             23             |      100.00%       |
| Tham gia rất đầy đủ                         | Học rất nhiều                               |         26          |               75.85               |                76.5                |             26             |      100.00%       |
| Tham gia rất đầy đủ                         | Học trung bình                              |         25          |               54.24               |                55.0                |             19             |       76.00%       |
| Tham gia trung bình                         | Học ít                                      |         21          |               43.62               |                45.0                |             6              |       28.57%       |
| Tham gia trung bình                         | Học nhiều                                   |         26          |               63.19               |                63.0                |             24             |       92.31%       |
| Tham gia trung bình                         | Học rất nhiều                               |         19          |               72.58               |                72.0                |             19             |      100.00%       |
| Tham gia trung bình                         | Học trung bình                              |         29          |               46.90               |                47.0                |             9              |       31.03%       |
| Tham gia rất ít                             | Học ít                                      |         22          |               32.68               |                29.0                |             1              |       4.55%        |
| Tham gia rất ít                             | Học nhiều                                   |         33          |               54.42               |                54.0                |             24             |       72.73%       |
| Tham gia rất ít                             | Học rất nhiều                               |         24          |               66.58               |                66.0                |             23             |       95.83%       |
| Tham gia rất ít                             | Học trung bình                              |         16          |               44.56               |                45.0                |             4              |       25.00%       |

#### **Nhận xét & Insight (Insights)**

- _[Viết nhận xét của bạn vào đây]_

---

### 📍 Vấn đề 4: Đo lường rào cản ngoại cảnh - Nền tảng Gia đình & Internet

#### **Mã truy vấn SQL**

```sql
-- Thống kê phân tổ theo Học vấn phụ huynh và Internet
SELECT
    parent_education,
    internet_access,
    COUNT(*) AS total,
    ROUND(AVG(final_score)::numeric, 2) AS avg_final_score,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY final_score) AS medium_finale_score,
    COUNT(passed) FILTER (WHERE passed = 'Yes') AS total_passed,
    ROUND(((COUNT(passed) FILTER (WHERE passed = 'Yes')::float * 100.0) / COUNT(passed)::float)::numeric, 2) AS percent_passed
FROM student_performent_table
GROUP BY parent_education, internet_access;

-- Bảng Pivot phân tích sự chênh lệch (Score Gap)
SELECT
    parent_education,
    ROUND(AVG(CASE WHEN internet_access = 'Yes' THEN final_score END)::numeric, 2) AS avg_score_internet_yes,
    ROUND(AVG(CASE WHEN internet_access = 'No' THEN final_score END)::numeric, 2) AS avg_score_internet_no,
    ROUND((AVG(CASE WHEN internet_access = 'Yes' THEN final_score END) - AVG(CASE WHEN internet_access = 'No' THEN final_score END))::numeric, 2) AS score_gap
FROM student_performent_table
GROUP BY parent_education
ORDER BY parent_education;
```

#### **Kết quả truy vấn (Output)**

_Bảng 1: Phân tổ đa chiều_
| Học vấn phụ huynh (parent_education) | Internet (internet_access) | Số học sinh (total) | Điểm trung bình (avg_final_score) | Trung vị (medium_finale_score) | Tổng số đỗ (total_passed) | Tỷ lệ đỗ (percent_passed) |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: |
| Bachelor | No | 47 | 50.79 | 51.0 | 25 | 53.19% |
| Bachelor | Yes | 50 | 53.48 | 51.0 | 27 | 54.00% |
| High School | No | 47 | 58.55 | 56.0 | 33 | 70.21% |
| High School | Yes | 48 | 55.38 | 56.0 | 34 | 70.83% |
| Master | No | 49 | 54.65 | 54.0 | 33 | 67.35% |
| Master | Yes | 51 | 58.04 | 60.0 | 34 | 66.67% |
| PhD | No | 46 | 57.87 | 57.0 | 30 | 65.22% |
| PhD | Yes | 45 | 57.27 | 58.0 | 29 | 64.44% |

_Bảng 2: Pivot chênh lệch điểm (Score Gap)_
| Học vấn phụ huynh (parent_education) | Trung bình điểm có Internet (Yes) | Trung bình điểm không Internet (No) | Chênh lệch điểm số (score_gap) |
| :--- | :---: | :---: | :---: |
| Bachelor | 53.48 | 50.79 | 2.69 |
| High School | 55.38 | 58.55 | -3.18 |
| Master | 58.04 | 54.65 | 3.39 |
| PhD | 57.27 | 57.87 | -0.60 |

#### **Nhận xét & Insight (Insights)**

- _[Viết nhận xét của bạn vào đây]_

---

### 📍 Vấn đề 5: Đánh giá Hoạt động Ngoại khóa - Gánh nặng hay Đòn bẩy?

#### **Mã truy vấn SQL**

```sql
CREATE OR REPLACE VIEW vw_study_hours_extracurricular_performance AS
WITH study_hours_extracurricular_groups AS (
    SELECT
        study_hours_per_week,
        extracurricular,
        final_score,
        CASE
            WHEN study_hours_per_week < 8 THEN '< 8h'
            WHEN study_hours_per_week >= 8 AND study_hours_per_week <= 23 THEN '8 <= and <= 23'
            WHEN study_hours_per_week > 23 THEN '> 23'
        END AS study_hours_per_week_group
    FROM student_performent_table
)
SELECT
    extracurricular,
    study_hours_per_week_group,
    ROUND(AVG(final_score)::numeric, 2) AS avg_final_score
FROM study_hours_extracurricular_groups
GROUP BY extracurricular, study_hours_per_week_group;

-- Xem kết quả
SELECT * FROM vw_study_hours_extracurricular_performance;
```

#### **Kết quả truy vấn (Output)**

| Ngoại khóa (extracurricular) | Nhóm giờ tự học (study_hours_per_week_group) | Điểm trung bình cuối kỳ (avg_final_score) |
| :--------------------------- | :------------------------------------------- | :---------------------------------------: |
| Yes                          | > 23                                         |                   73.02                   |
| No                           | 8 <= and <= 23                               |                   54.67                   |
| No                           | < 8h                                         |                   41.45                   |
| No                           | > 23                                         |                   72.35                   |
| Yes                          | 8 <= and <= 23                               |                   55.78                   |
| Yes                          | < 8h                                         |                   39.73                   |

#### **Nhận xét & Insight (Insights)**

- _[Viết nhận xét của bạn vào đây]_

---

### 📍 Vấn đề 6: Truy tìm những nhân tố "Đột biến" và "Cá biệt"

#### **Mã truy vấn SQL**

```sql
-- Tạo View danh sách học sinh vượt khó
CREATE OR REPLACE VIEW vw_resilient_high_achieversss AS
WITH final_score_index AS (
    SELECT
        final_score,
        student_id,
        internet_access,
        previous_score,
        gender,
        age,
        ROW_NUMBER() OVER (ORDER BY final_score DESC) AS rn
    FROM student_performent_table
)
SELECT
    student_id,
    gender,
    age,
    final_score,
    internet_access,
    previous_score
FROM final_score_index
WHERE internet_access = 'No'
  AND previous_score < 50
  AND final_score > (SELECT final_score FROM final_score_index WHERE rn = 38);

-- Tạo View danh sách học sinh tụt dốc bất thường
CREATE OR REPLACE VIEW vw_high_effort_underperformerss AS
SELECT
    student_id,
    attendance_rate,
    study_hours_per_week,
    passed,
    gender,
    age
FROM student_performent_table
WHERE attendance_rate > 70
  AND study_hours_per_week > 15
  AND passed = 'No';

-- Truy vấn
SELECT * FROM vw_resilient_high_achieversss;
SELECT * FROM vw_high_effort_underperformerss;
```

#### **Kết quả truy vấn (Output)**

_Bảng 1: Danh sách học sinh "Vượt khó" (Resilient High Achievers)_
| Mã học sinh (student_id) | Giới tính (gender) | Tuổi (age) | Điểm cuối kỳ (final_score) | Internet (internet_access) | Điểm kỳ trước (previous_score) |
| :--- | :--- | :---: | :---: | :--- | :---: |
| STU0122 | Female | 17 | 84 | No | 48 |
| STU0445 | Male | 15 | 80 | No | 42 |
| STU0320 | Male | 17 | 80 | No | 41 |
| STU0108 | Female | 15 | 78 | No | 48 |

_Bảng 2: Danh sách học sinh "Tụt dốc bất thường" (High Effort Underperformers)_
| Mã học sinh (student_id) | Tỷ lệ chuyên cần (attendance_rate) | Giờ tự học (study_hours_per_week) | Đỗ (passed) | Giới tính (gender) | Tuổi (age) |
| :--- | :---: | :---: | :--- | :--- | :---: |
| STU0023 | 73.6% | 20 | No | Male | 19 |
| STU0174 | 70.9% | 18 | No | Female | 19 |
| STU0341 | 84.1% | 19 | No | Female | 17 |
| STU0442 | 74.8% | 19 | No | Male | 15 |

#### **Nhận xét & Insight (Insights)**

- _[Viết nhận xét của bạn vào đây]_

---

### 📍 Vấn đề 7: Bảng xếp hạng Học giả Cấp trường

#### **Mã truy vấn SQL**

```sql
CREATE OR REPLACE VIEW top_3_students_by_parent_education AS
WITH student_rank AS (
    SELECT
        student_id,
        final_score,
        parent_education,
        DENSE_RANK() OVER (
            PARTITION BY parent_education
            ORDER BY final_score DESC
        ) AS top
    FROM student_performent_table
)
SELECT
    student_id,
    final_score,
    parent_education,
    top
FROM student_rank
WHERE top <= 3;

-- Xem kết quả
SELECT * FROM top_3_students_by_parent_education;
```

#### **Kết quả truy vấn (Output)**

| Mã học sinh (student_id) | Điểm thi cuối kỳ (final_score) | Học văn phụ huynh (parent_education) | Xếp hạng (top) |
| :----------------------- | :----------------------------: | :----------------------------------- | :------------: |
| STU0376                  |               95               | Bachelor                             |       1        |
| STU0324                  |               85               | Bachelor                             |       2        |
| STU0446                  |               81               | Bachelor                             |       3        |
| STU0202                  |               81               | Bachelor                             |       3        |
| STU0122                  |               84               | High School                          |       1        |
| STU0306                  |               84               | High School                          |       1        |
| STU0183                  |               80               | High School                          |       2        |
| STU0053                  |               80               | High School                          |       2        |
| STU0018                  |               79               | High School                          |       3        |
| STU0209                  |               91               | Master                               |       1        |
| STU0017                  |               89               | Master                               |       2        |
| STU0407                  |               84               | Master                               |       3        |
| STU0015                  |               84               | Master                               |       3        |
| STU0428                  |               93               | PhD                                  |       1        |
| STU0468                  |               86               | PhD                                  |       2        |
| STU0319                  |               84               | PhD                                  |       3        |

#### **Nhận xét & Insight (Insights)**

- _[Viết nhận xét của bạn vào đây]_

---

### 📍 Vấn đề 8: Chấm điểm Rủi ro (Risk Scoring System) cho năm học tới

#### **Mã truy vấn SQL**

```sql
WITH student_risk AS (
    SELECT
        student_id,
        passed,
        (
            CASE WHEN attendance_rate < 75 THEN 1 ELSE 0 END +
            CASE WHEN study_hours_per_week < 10 THEN 1 ELSE 0 END +
            CASE WHEN previous_score < 50 THEN 1 ELSE 0 END
        ) AS risk_score
    FROM student_performent_table
)
SELECT
    risk_score,
    COUNT(*) AS total_students,
    COUNT(CASE WHEN passed = 'No' THEN 1 END) AS failed_students,
    ROUND((COUNT(CASE WHEN passed = 'No' THEN 1 END)::float * 100.0 / COUNT(*))::numeric, 2) AS fail_rate_percent
FROM student_risk
GROUP BY risk_score
ORDER BY risk_score;
```

#### **Kết quả truy vấn (Output)**

| Điểm rủi ro (risk_score) | Tổng số học sinh (total_students) | Số lượng trượt thực tế (failed_students) | Tỷ lệ trượt (%) (fail_rate_percent) |
| :----------------------: | :-------------------------------: | :--------------------------------------: | :---------------------------------: |
|            0             |                91                 |                    9                     |                9.89%                |
|            1             |                188                |                    55                    |               29.26%                |
|            2             |                88                 |                    58                    |               65.91%                |
|            3             |                16                 |                    16                    |               100.00%               |

#### **Nhận xét & Insight (Insights)**

- _[Viết nhận xét của bạn vào đây]_

---

### 📍 Vấn đề 9: Phân tích sự trung thành/đều đặn của dữ liệu

#### **Mã truy vấn SQL**

```sql
SELECT
    ROUND(STDDEV(final_score)::numeric, 2) AS std_final_score,
    ROUND(AVG(final_score)::numeric, 2) AS avg_final_score,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY final_score) AS median_final_score,
    MAX(final_score) AS max_final_score,
    MIN(final_score) AS min_final_score
FROM student_performent_table
WHERE attendance_rate > 90;
```

#### **Kết quả truy vấn (Output)**

| Độ lệch chuẩn (std_final_score) | Điểm trung bình (avg_final_score) | Trung vị điểm (median_final_score) | Điểm cao nhất (max_final_score) | Điểm thấp nhất (min_final_score) |
| :-----------------------------: | :-------------------------------: | :--------------------------------: | :-----------------------------: | :------------------------------: |
|              15.38              |               60.88               |                61.0                |               95                |                29                |

#### **Nhận xét & Insight (Insights)**

- _[Viết nhận xét của bạn vào đây]_

---

### 📍 Vấn đề 10: Master View - Dữ liệu nền tảng cho Ban giám hiệu

#### **Mã truy vấn SQL**

```sql
CREATE OR REPLACE VIEW vw_student_performance_master AS
WITH student_features AS (
    SELECT
        *,
        (
            CASE WHEN attendance_rate < 75 THEN 1 ELSE 0 END +
            CASE WHEN study_hours_per_week < 10 THEN 1 ELSE 0 END +
            CASE WHEN previous_score < 50 THEN 1 ELSE 0 END
        ) AS risk_score,
        PERCENT_RANK() OVER (ORDER BY final_score DESC) AS score_percentile
    FROM student_performent_table
)
SELECT
    student_id,
    gender,
    age,
    study_hours_per_week,
    attendance_rate,
    parent_education,
    internet_access,
    extracurricular,
    previous_score,
    final_score,
    passed,
    CASE
        WHEN final_score - previous_score >= 10 THEN 'Tiến bộ'
        WHEN final_score - previous_score <= -10 THEN 'Sa sút'
        ELSE 'Giữ vững'
    END AS score_progress,
    CASE
        WHEN risk_score >= 2 THEN 'High Risk'
        WHEN risk_score = 1 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_flag,
    CASE
        WHEN score_percentile <= 0.25 THEN 'Top 25%'
        WHEN score_percentile <= 0.75 THEN 'Middle 50%'
        ELSE 'Bottom 25%'
    END AS academic_tier
FROM student_features;

-- Ví dụ truy vấn
SELECT * FROM vw_student_performance_master LIMIT 5;
```

#### **Kết quả truy vấn (Output)**

| student_id | gender | age | study_hours | attendance_rate | parent_education | internet | extracurricular | previous_score | final_score | passed | score_progress | risk_flag   | academic_tier |
| :--------- | :----- | :-: | :---------: | :-------------: | :--------------- | :------: | :-------------: | :------------: | :---------: | :----- | :------------- | :---------- | :------------ |
| STU0376    | Female | 17  |     28      |      99.6%      | Bachelor         |   Yes    |       Yes       |       70       |     95      | Yes    | Tiến bộ        | Low Risk    | Top 25%       |
| STU0428    | Female | 19  |     30      |      95.3%      | PhD              |   Yes    |       No        |       53       |     93      | Yes    | Tiến bộ        | Low Risk    | Top 25%       |
| STU0209    | Male   | 18  |     30      |      81.4%      | Master           |    No    |       No        |       61       |     91      | Yes    | Tiến bộ        | Low Risk    | Top 25%       |
| STU0017    | Male   | 17  |     30      |      99.3%      | Master           |   Yes    |       Yes       |       60       |     89      | Yes    | Tiến bộ        | Low Risk    | Top 25%       |
| STU0468    | Female | 15  |     26      |      67.6%      | PhD              |    No    |       No        |       84       |     86      | Yes    | Giữ vững       | Medium Risk | Top 25%       |

#### **Nhận xét & Insight (Insights)**

- _[Viết nhận xét của bạn vào đây]_
