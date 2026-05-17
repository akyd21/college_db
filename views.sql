-- ============================================================
--  COLLEGE MANAGEMENT SYSTEM - VIEWS
-- ============================================================
USE college_db;

-- ─────────────────────────────────────────────────────────────
--  1. vw_student_summary
--     One row per student with dept and fee status
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_student_summary AS
SELECT
    s.student_id,
    s.roll_no,
    CONCAT(s.first_name,' ',s.last_name)   AS student_name,
    s.gender,
    d.dept_name,
    s.current_sem,
    s.admission_yr,
    s.email,
    s.phone
FROM Student s
JOIN Department d ON s.dept_id = d.dept_id;

-- ─────────────────────────────────────────────────────────────
--  2. vw_enrollment_details
--     Full enrollment info with student, course, teacher names
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_enrollment_details AS
SELECT
    e.enrollment_id,
    s.roll_no,
    CONCAT(s.first_name,' ',s.last_name)   AS student_name,
    c.course_code,
    c.course_name,
    CONCAT(t.first_name,' ',t.last_name)   AS teacher_name,
    e.academic_year,
    e.marks,
    e.grade
FROM Enrollment e
JOIN Student s ON e.student_id = s.student_id
JOIN Course  c ON e.course_id  = c.course_id
JOIN Teacher t ON e.teacher_id = t.teacher_id;

-- ─────────────────────────────────────────────────────────────
--  3. vw_course_avg_marks
--     Average marks per course per academic year
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_course_avg_marks AS
SELECT
    c.course_code,
    c.course_name,
    e.academic_year,
    COUNT(e.student_id)           AS enrolled_count,
    ROUND(AVG(e.marks), 2)        AS avg_marks,
    MAX(e.marks)                  AS highest,
    MIN(e.marks)                  AS lowest
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
WHERE e.marks IS NOT NULL
GROUP BY c.course_id, e.academic_year;

-- ─────────────────────────────────────────────────────────────
--  4. vw_attendance_summary
--     Attendance % per student per course
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_attendance_summary AS
SELECT
    s.roll_no,
    CONCAT(s.first_name,' ',s.last_name)        AS student_name,
    c.course_code,
    c.course_name,
    COUNT(a.attendance_id)                       AS total_classes,
    SUM(a.status = 'Present')                    AS present_count,
    SUM(a.status = 'Absent')                     AS absent_count,
    ROUND(SUM(a.status='Present')*100/COUNT(*),2) AS attendance_pct
FROM Attendance a
JOIN Student s ON a.student_id = s.student_id
JOIN Course  c ON a.course_id  = c.course_id
GROUP BY s.student_id, c.course_id;

-- ─────────────────────────────────────────────────────────────
--  5. vw_fee_status
--     Fee details with student and dept info
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_fee_status AS
SELECT
    f.fee_id,
    s.roll_no,
    CONCAT(s.first_name,' ',s.last_name) AS student_name,
    d.dept_name,
    f.fee_type,
    f.amount,
    f.paid_on,
    f.status,
    f.academic_year
FROM Fee f
JOIN Student    s ON f.student_id = s.student_id
JOIN Department d ON s.dept_id    = d.dept_id;

-- ─────────────────────────────────────────────────────────────
--  6. vw_dept_performance
--     Department-level academic performance summary
-- ─────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW vw_dept_performance AS
SELECT
    d.dept_name,
    COUNT(DISTINCT s.student_id)        AS total_students,
    COUNT(DISTINCT t.teacher_id)        AS total_teachers,
    ROUND(AVG(e.marks), 2)              AS dept_avg_marks,
    SUM(e.grade = 'F')                  AS fail_count,
    SUM(e.grade IN ('A+','A'))          AS distinction_count
FROM Department d
LEFT JOIN Student    s ON s.dept_id    = d.dept_id
LEFT JOIN Enrollment e ON e.student_id = s.student_id
LEFT JOIN Teacher    t ON t.dept_id    = d.dept_id
GROUP BY d.dept_id;
