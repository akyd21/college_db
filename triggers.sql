-- ============================================================
--  COLLEGE MANAGEMENT SYSTEM - TRIGGERS
-- ============================================================
USE college_db;
DELIMITER $$

-- ─────────────────────────────────────────────────────────────
--  1. trg_auto_grade
--     Auto-assign grade when marks are inserted/updated
--     in Enrollment table
-- ─────────────────────────────────────────────────────────────
CREATE TRIGGER trg_auto_grade
BEFORE INSERT ON Enrollment
FOR EACH ROW
BEGIN
    IF NEW.marks IS NOT NULL THEN
        SET NEW.grade = CASE
            WHEN NEW.marks >= 90 THEN 'A+'
            WHEN NEW.marks >= 80 THEN 'A'
            WHEN NEW.marks >= 70 THEN 'B+'
            WHEN NEW.marks >= 60 THEN 'B'
            WHEN NEW.marks >= 50 THEN 'C'
            WHEN NEW.marks >= 40 THEN 'D'
            ELSE 'F'
        END;
    END IF;
END$$

CREATE TRIGGER trg_auto_grade_update
BEFORE UPDATE ON Enrollment
FOR EACH ROW
BEGIN
    IF NEW.marks IS NOT NULL THEN
        SET NEW.grade = CASE
            WHEN NEW.marks >= 90 THEN 'A+'
            WHEN NEW.marks >= 80 THEN 'A'
            WHEN NEW.marks >= 70 THEN 'B+'
            WHEN NEW.marks >= 60 THEN 'B'
            WHEN NEW.marks >= 50 THEN 'C'
            WHEN NEW.marks >= 40 THEN 'D'
            ELSE 'F'
        END;
    END IF;
END$$

-- ─────────────────────────────────────────────────────────────
--  2. trg_prevent_duplicate_attendance
--     Raise error if same student marked twice on same date
--     for same course  (backup to UNIQUE constraint)
-- ─────────────────────────────────────────────────────────────
CREATE TRIGGER trg_prevent_dup_attendance
BEFORE INSERT ON Attendance
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Attendance
        WHERE student_id  = NEW.student_id
          AND course_id   = NEW.course_id
          AND attend_date = NEW.attend_date
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Attendance already marked for this date.';
    END IF;
END$$

-- ─────────────────────────────────────────────────────────────
--  3. trg_fee_overdue
--     Mark fee as Overdue if payment date exceeds 30 days
--     from academic year start (simplified check on insert)
-- ─────────────────────────────────────────────────────────────
CREATE TRIGGER trg_fee_overdue
BEFORE INSERT ON Fee
FOR EACH ROW
BEGIN
    IF NEW.status = 'Pending' AND DATEDIFF(CURDATE(), MAKEDATE(
        CAST(LEFT(NEW.academic_year, 4) AS UNSIGNED), 213)  -- ~Aug 1
    ) > 30 THEN
        SET NEW.status = 'Overdue';
    END IF;
END$$

-- ─────────────────────────────────────────────────────────────
--  4. trg_log_exam_result
--     After inserting an exam result, sync marks into
--     Enrollment if the exam is 'External'
-- ─────────────────────────────────────────────────────────────
CREATE TRIGGER trg_sync_external_marks
AFTER INSERT ON Exam_Result
FOR EACH ROW
BEGIN
    DECLARE v_exam_type  VARCHAR(20);
    DECLARE v_course_id  INT;
    DECLARE v_max_marks  DECIMAL(5,2);

    SELECT exam_type, course_id, max_marks
      INTO v_exam_type,  v_course_id,  v_max_marks
    FROM Exam WHERE exam_id = NEW.exam_id;

    IF v_exam_type = 'External' THEN
        -- Normalise to 100 and update Enrollment
        UPDATE Enrollment
        SET marks = ROUND((NEW.marks_obtained / v_max_marks) * 100, 2)
        WHERE student_id = NEW.student_id
          AND course_id  = v_course_id;
    END IF;
END$$

DELIMITER ;
