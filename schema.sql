-- ============================================================
--  COLLEGE MANAGEMENT SYSTEM - SCHEMA
--  Author  : akyd21
--  GitHub  : https://github.com/akyd21/college-db
-- ============================================================

CREATE DATABASE IF NOT EXISTS college_db;
USE college_db;

-- ─────────────────────────────────────────
--  1. DEPARTMENT
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Department (
    dept_id     INT AUTO_INCREMENT PRIMARY KEY,
    dept_name   VARCHAR(100) NOT NULL UNIQUE,
    hod_name    VARCHAR(100),
    established_year INT,
    location    VARCHAR(100)
);

-- ─────────────────────────────────────────
--  2. COURSE
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Course (
    course_id   INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    course_code VARCHAR(20)  NOT NULL UNIQUE,
    credits     INT          NOT NULL CHECK (credits BETWEEN 1 AND 6),
    dept_id     INT          NOT NULL,
    semester    INT          NOT NULL CHECK (semester BETWEEN 1 AND 8),
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id) ON DELETE CASCADE
);

-- ─────────────────────────────────────────
--  3. STUDENT
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Student (
    student_id   INT AUTO_INCREMENT PRIMARY KEY,
    roll_no      VARCHAR(20)  NOT NULL UNIQUE,
    first_name   VARCHAR(80)  NOT NULL,
    last_name    VARCHAR(80)  NOT NULL,
    dob          DATE,
    gender       ENUM('Male','Female','Other'),
    email        VARCHAR(120) NOT NULL UNIQUE,
    phone        VARCHAR(15),
    address      TEXT,
    dept_id      INT          NOT NULL,
    admission_yr INT          NOT NULL,
    current_sem  INT          NOT NULL CHECK (current_sem BETWEEN 1 AND 8),
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id) ON DELETE RESTRICT
);

-- ─────────────────────────────────────────
--  4. TEACHER
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Teacher (
    teacher_id   INT AUTO_INCREMENT PRIMARY KEY,
    emp_code     VARCHAR(20)  NOT NULL UNIQUE,
    first_name   VARCHAR(80)  NOT NULL,
    last_name    VARCHAR(80)  NOT NULL,
    email        VARCHAR(120) NOT NULL UNIQUE,
    phone        VARCHAR(15),
    designation  VARCHAR(80),
    dept_id      INT          NOT NULL,
    joining_date DATE,
    salary       DECIMAL(10,2),
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id) ON DELETE RESTRICT
);

-- ─────────────────────────────────────────
--  5. ENROLLMENT  (Student ↔ Course)
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Enrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id    INT  NOT NULL,
    course_id     INT  NOT NULL,
    teacher_id    INT  NOT NULL,
    academic_year VARCHAR(10) NOT NULL,   -- e.g. '2024-25'
    grade         VARCHAR(5),             -- e.g. 'A', 'B+', 'F'
    marks         DECIMAL(5,2) CHECK (marks BETWEEN 0 AND 100),
    UNIQUE KEY uq_enrollment (student_id, course_id, academic_year),
    FOREIGN KEY (student_id)  REFERENCES Student(student_id)  ON DELETE CASCADE,
    FOREIGN KEY (course_id)   REFERENCES Course(course_id)    ON DELETE CASCADE,
    FOREIGN KEY (teacher_id)  REFERENCES Teacher(teacher_id)  ON DELETE RESTRICT
);

-- ─────────────────────────────────────────
--  6. ATTENDANCE
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id    INT  NOT NULL,
    course_id     INT  NOT NULL,
    attend_date   DATE NOT NULL,
    status        ENUM('Present','Absent','Late') NOT NULL DEFAULT 'Present',
    UNIQUE KEY uq_attend (student_id, course_id, attend_date),
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id)  REFERENCES Course(course_id)   ON DELETE CASCADE
);

-- ─────────────────────────────────────────
--  7. EXAM
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Exam (
    exam_id    INT AUTO_INCREMENT PRIMARY KEY,
    course_id  INT          NOT NULL,
    exam_type  ENUM('Internal','External','Practical','Viva') NOT NULL,
    exam_date  DATE,
    max_marks  DECIMAL(5,2) NOT NULL DEFAULT 100,
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE
);

-- ─────────────────────────────────────────
--  8. EXAM_RESULT
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Exam_Result (
    result_id  INT AUTO_INCREMENT PRIMARY KEY,
    exam_id    INT          NOT NULL,
    student_id INT          NOT NULL,
    marks_obtained DECIMAL(5,2) NOT NULL,
    UNIQUE KEY uq_result (exam_id, student_id),
    FOREIGN KEY (exam_id)    REFERENCES Exam(exam_id)       ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE
);

-- ─────────────────────────────────────────
--  9. FEE
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Fee (
    fee_id       INT AUTO_INCREMENT PRIMARY KEY,
    student_id   INT          NOT NULL,
    amount       DECIMAL(10,2) NOT NULL,
    fee_type     ENUM('Tuition','Hostel','Exam','Library','Other') NOT NULL,
    paid_on      DATE,
    status       ENUM('Paid','Pending','Overdue') NOT NULL DEFAULT 'Pending',
    academic_year VARCHAR(10) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE
);
