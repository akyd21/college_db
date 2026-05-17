-- ============================================================
--  COLLEGE MANAGEMENT SYSTEM - STORED PROCEDURES
-- ============================================================
USE college_db;
DELIMITER $$

-- ─────────────────────────────────────────────────────────────
--  1. GetStudentReport
--     Returns full academic report for a student
-- ─────────────────────────────────────────────────────────────
CREATE PROCEDURE GetStudentReport(IN p_student_id INT)
BEGIN
    SELECT
        CONCAT(s.first_name,' ',s.last_name) AS student_name,
        s.roll_no,
        d.dept_name,
        s.current_sem,
        c.course_name,
        c.course_code,
        e.academic_year,
        e.marks,
        e.grade
    FROM Student s
    JOIN Department  d ON s.dept_id    = d.dept_id
    JOIN Enrollment  e ON s.student_id = e.student_id
    JOIN Course      c ON e.course_id  = c.course_id
    WHERE s.student_id = p_student_id
    ORDER BY e.academic_year, c.course_code;
END$$

-- ─────────────────────────────────────────────────────────────
--  2. GetAttendancePercent
--     Returns attendance % per course for a student
-- ─────────────────────────────────────────────────────────────
CREATE PROCEDURE GetAttendancePercent(IN p_student_id INT)
BEGIN
    SELECT
        c.course_code,
        c.course_name,
        COUNT(a.attendance_id)                                 AS total_classes,
        SUM(a.status = 'Present')                              AS present,
        ROUND(SUM(a.status='Present')*100/COUNT(*), 2)         AS attendance_pct
    FROM Attendance a
    JOIN Course c ON a.course_id = c.course_id
    WHERE a.student_id = p_student_id
    GROUP BY c.course_id;
END$$

-- ─────────────────────────────────────────────────────────────
--  3. GetDeptToppers
--     Returns top-scoring student per department
-- ─────────────────────────────────────────────────────────────
CREATE PROCEDURE GetDeptToppers()
BEGIN
    SELECT
        d.dept_name,
        CONCAT(s.first_name,' ',s.last_name) AS topper,
        s.roll_no,
        ROUND(AVG(e.marks), 2)               AS avg_marks
    FROM Enrollment e
    JOIN Student    s ON e.student_id = s.student_id
    JOIN Department d ON s.dept_id    = d.dept_id
    WHERE e.marks IS NOT NULL
    GROUP BY d.dept_id, s.student_id
    HAVING avg_marks = (
        SELECT MAX(sub.avg)
        FROM (
            SELECT s2.student_id, AVG(e2.marks) AS avg
            FROM Enrollment e2
            JOIN Student s2 ON e2.student_id = s2.student_id
            WHERE e2.marks IS NOT NULL AND s2.dept_id = d.dept_id
            GROUP BY s2.student_id
        ) sub
    )
    ORDER BY d.dept_name;
END$$

-- ─────────────────────────────────────────────────────────────
--  4. EnrollStudent
--     Safely enroll a student into a course
-- ─────────────────────────────────────────────────────────────
CREATE PROCEDURE EnrollStudent(
    IN p_student_id   INT,
    IN p_course_id    INT,
    IN p_teacher_id   INT,
    IN p_acad_year    VARCHAR(10)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Enrollment failed.';
    END;

    START TRANSACTION;
    INSERT INTO Enrollment (student_id, course_id, teacher_id, academic_year)
    VALUES (p_student_id, p_course_id, p_teacher_id, p_acad_year);
    COMMIT;
    SELECT 'Enrollment successful' AS status;
END$$

-- ─────────────────────────────────────────────────────────────
--  5. UpdateGrade
--     Update marks and auto-assign grade
-- ─────────────────────────────────────────────────────────────
CREATE PROCEDURE UpdateGrade(
    IN p_student_id   INT,
    IN p_course_id    INT,
    IN p_acad_year    VARCHAR(10),
    IN p_marks        DECIMAL(5,2)
)
BEGIN
    DECLARE v_grade VARCHAR(5);

    SET v_grade = CASE
        WHEN p_marks >= 90 THEN 'A+'
        WHEN p_marks >= 80 THEN 'A'
        WHEN p_marks >= 70 THEN 'B+'
        WHEN p_marks >= 60 THEN 'B'
        WHEN p_marks >= 50 THEN 'C'
        WHEN p_marks >= 40 THEN 'D'
        ELSE 'F'
    END;

    UPDATE Enrollment
    SET marks = p_marks, grade = v_grade
    WHERE student_id = p_student_id
      AND course_id  = p_course_id
      AND academic_year = p_acad_year;

    SELECT CONCAT('Grade set to ', v_grade) AS status;
END$$

-- ─────────────────────────────────────────────────────────────
--  6. GetFeeDefaulters
--     Returns students with pending/overdue fees
-- ─────────────────────────────────────────────────────────────
CREATE PROCEDURE GetFeeDefaulters(IN p_year VARCHAR(10))
BEGIN
    SELECT
        s.roll_no,
        CONCAT(s.first_name,' ',s.last_name) AS student_name,
        d.dept_name,
        f.fee_type,
        f.amount,
        f.status
    FROM Fee f
    JOIN Student    s ON f.student_id = s.student_id
    JOIN Department d ON s.dept_id    = d.dept_id
    WHERE f.academic_year = p_year
      AND f.status IN ('Pending','Overdue')
    ORDER BY f.status DESC, d.dept_name;
END$$

DELIMITER ;
