-- ============================================================
--  COLLEGE MANAGEMENT SYSTEM - USEFUL QUERIES
-- ============================================================
USE college_db;

-- ── 1. List all students with their department ──────────────
SELECT * FROM vw_student_summary ORDER BY dept_name, roll_no;

-- ── 2. Show full enrollment details ─────────────────────────
SELECT * FROM vw_enrollment_details WHERE academic_year = '2023-24';

-- ── 3. Average marks per course ─────────────────────────────
SELECT * FROM vw_course_avg_marks ORDER BY avg_marks DESC;

-- ── 4. Attendance summary (flag students < 75%) ─────────────
SELECT *, IF(attendance_pct < 75, '⚠ Low', '✓ OK') AS remark
FROM vw_attendance_summary
ORDER BY attendance_pct;

-- ── 5. Fee defaulters for 2024-25 ───────────────────────────
CALL GetFeeDefaulters('2024-25');

-- ── 6. Student report for student_id = 1 ────────────────────
CALL GetStudentReport(1);

-- ── 7. Attendance % for student_id = 1 ──────────────────────
CALL GetAttendancePercent(1);

-- ── 8. Department toppers ────────────────────────────────────
CALL GetDeptToppers();

-- ── 9. Department performance overview ──────────────────────
SELECT * FROM vw_dept_performance ORDER BY dept_avg_marks DESC;

-- ── 10. Top 5 students overall ──────────────────────────────
SELECT
    s.roll_no,
    CONCAT(s.first_name,' ',s.last_name) AS student_name,
    d.dept_name,
    ROUND(AVG(e.marks),2) AS avg_marks
FROM Enrollment e
JOIN Student    s ON e.student_id = s.student_id
JOIN Department d ON s.dept_id    = d.dept_id
WHERE e.marks IS NOT NULL
GROUP BY s.student_id
ORDER BY avg_marks DESC
LIMIT 5;

-- ── 11. Courses with highest failure rate ───────────────────
SELECT
    c.course_code,
    c.course_name,
    COUNT(*) AS total,
    SUM(e.grade = 'F') AS failures,
    ROUND(SUM(e.grade='F')*100/COUNT(*),2) AS failure_pct
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
WHERE e.grade IS NOT NULL
GROUP BY c.course_id
ORDER BY failure_pct DESC;

-- ── 12. Teacher workload (number of enrollments handled) ────
SELECT
    CONCAT(t.first_name,' ',t.last_name) AS teacher_name,
    t.designation,
    d.dept_name,
    COUNT(e.enrollment_id) AS students_taught
FROM Teacher t
JOIN Department d  ON t.dept_id    = d.dept_id
LEFT JOIN Enrollment e ON e.teacher_id = t.teacher_id
GROUP BY t.teacher_id
ORDER BY students_taught DESC;

-- ── 13. Update marks using procedure ────────────────────────
-- CALL UpdateGrade(3, 2, '2023-24', 88.00);

-- ── 14. Enroll a new student ────────────────────────────────
-- CALL EnrollStudent(12, 7, 5, '2024-25');
