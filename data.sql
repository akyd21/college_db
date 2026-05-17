-- ============================================================
--  COLLEGE MANAGEMENT SYSTEM - SAMPLE DATA
-- ============================================================
USE college_db;

-- ─── DEPARTMENTS ────────────────────────────────────────────
INSERT INTO Department (dept_name, hod_name, established_year, location) VALUES
('Computer Science',      'Dr. Rajesh Kumar',   1990, 'Block A'),
('Electronics',           'Dr. Priya Menon',    1985, 'Block B'),
('Mechanical Engineering','Dr. Anil Sharma',    1975, 'Block C'),
('Civil Engineering',     'Dr. Sunita Rao',     1970, 'Block D'),
('Mathematics',           'Dr. Kavitha Nair',   1965, 'Block E');

-- ─── COURSES ────────────────────────────────────────────────
INSERT INTO Course (course_name, course_code, credits, dept_id, semester) VALUES
('Data Structures & Algorithms', 'CS301', 4, 1, 3),
('Database Management Systems',  'CS302', 4, 1, 3),
('Computer Networks',            'CS401', 4, 1, 4),
('Artificial Intelligence',      'CS501', 4, 1, 5),
('Compiler Design',              'CS601', 4, 1, 6),
('Digital Electronics',          'EC301', 4, 2, 3),
('Signal Processing',            'EC401', 4, 2, 4),
('Thermodynamics',               'ME301', 4, 3, 3),
('Fluid Mechanics',              'ME401', 4, 3, 4),
('Structural Analysis',          'CE401', 4, 4, 4),
('Discrete Mathematics',         'MA301', 3, 5, 3),
('Probability & Statistics',     'MA401', 3, 5, 4);

-- ─── TEACHERS ───────────────────────────────────────────────
INSERT INTO Teacher (emp_code, first_name, last_name, email, phone, designation, dept_id, joining_date, salary) VALUES
('EMP001', 'Ramesh',   'Iyer',    'ramesh.iyer@college.edu',    '9876540001', 'Professor',        1, '2010-06-01', 85000.00),
('EMP002', 'Seetha',   'Pillai',  'seetha.pillai@college.edu',  '9876540002', 'Associate Professor',1,'2015-07-15', 70000.00),
('EMP003', 'Arjun',    'Varma',   'arjun.varma@college.edu',    '9876540003', 'Assistant Professor',1,'2018-08-01', 55000.00),
('EMP004', 'Deepa',    'Krishnan','deepa.krishnan@college.edu', '9876540004', 'Professor',        2, '2008-06-01', 87000.00),
('EMP005', 'Vinod',    'Nair',    'vinod.nair@college.edu',     '9876540005', 'Associate Professor',2,'2012-01-10', 72000.00),
('EMP006', 'Suresh',   'Babu',    'suresh.babu@college.edu',    '9876540006', 'Professor',        3, '2005-07-01', 90000.00),
('EMP007', 'Meena',    'Thomas',  'meena.thomas@college.edu',   '9876540007', 'Assistant Professor',4,'2019-06-01', 52000.00),
('EMP008', 'Lakshmi',  'Devi',    'lakshmi.devi@college.edu',   '9876540008', 'Associate Professor',5,'2013-08-01', 68000.00);

-- ─── STUDENTS ───────────────────────────────────────────────
INSERT INTO Student (roll_no, first_name, last_name, dob, gender, email, phone, address, dept_id, admission_yr, current_sem) VALUES
('CS21001','Akash',    'Yadav',    '2003-05-14','Male',  'akash.yadav@student.edu',   '9000000001','Patna, Bihar',         1,2021,7),
('CS21002','Priya',    'Singh',    '2003-08-22','Female','priya.singh@student.edu',   '9000000002','Kochi, Kerala',        1,2021,7),
('CS21003','Rohit',    'Mehta',    '2003-01-30','Male',  'rohit.mehta@student.edu',   '9000000003','Mumbai, Maharashtra',  1,2021,7),
('CS21004','Anjali',   'Nair',     '2003-11-05','Female','anjali.nair@student.edu',   '9000000004','Thrissur, Kerala',     1,2021,7),
('CS21005','Vikram',   'Patel',    '2002-07-19','Male',  'vikram.patel@student.edu',  '9000000005','Ahmedabad, Gujarat',   1,2021,7),
('EC21001','Sneha',    'Menon',    '2003-03-12','Female','sneha.menon@student.edu',   '9000000006','Kozhikode, Kerala',    2,2021,7),
('EC21002','Arun',     'Kumar',    '2003-06-25','Male',  'arun.kumar@student.edu',    '9000000007','Delhi',                2,2021,7),
('ME21001','Deepak',   'Sharma',   '2003-09-08','Male',  'deepak.sharma@student.edu', '9000000008','Jaipur, Rajasthan',    3,2021,7),
('CE21001','Pooja',    'Reddy',    '2003-02-14','Female','pooja.reddy@student.edu',   '9000000009','Hyderabad, Telangana', 4,2021,7),
('CS22001','Rahul',    'Gupta',    '2004-04-20','Male',  'rahul.gupta@student.edu',   '9000000010','Lucknow, UP',          1,2022,5),
('CS22002','Divya',    'Pillai',   '2004-12-01','Female','divya.pillai@student.edu',  '9000000011','Thiruvananthapuram',   1,2022,5),
('EC22001','Sanjay',   'Verma',    '2004-07-30','Male',  'sanjay.verma@student.edu',  '9000000012','Bhopal, MP',           2,2022,5);

-- ─── ENROLLMENTS ────────────────────────────────────────────
INSERT INTO Enrollment (student_id, course_id, teacher_id, academic_year, grade, marks) VALUES
(1,1,1,'2023-24','A',88),(1,2,2,'2023-24','A+',95),(1,3,3,'2023-24','B+',75),
(2,1,1,'2023-24','B+',76),(2,2,2,'2023-24','A',85),(2,3,3,'2023-24','A',80),
(3,1,1,'2023-24','B',65),(3,2,2,'2023-24','B+',72),(3,3,3,'2023-24','C',55),
(4,1,1,'2023-24','A+',97),(4,2,2,'2023-24','A',90),(4,3,3,'2023-24','A+',98),
(5,1,1,'2023-24','C',50),(5,2,2,'2023-24','B',68),(5,3,3,'2023-24','B',70),
(6,6,4,'2023-24','A',83),(6,7,5,'2023-24','B+',77),
(7,6,4,'2023-24','B',66),(7,7,5,'2023-24','A',87),
(8,8,6,'2023-24','A',91),(8,9,6,'2023-24','A+',94),
(9,10,7,'2023-24','B+',74),
(10,1,1,'2024-25',NULL,NULL),(10,2,2,'2024-25',NULL,NULL),
(11,1,1,'2024-25',NULL,NULL),(11,2,2,'2024-25',NULL,NULL),
(12,6,4,'2024-25',NULL,NULL);

-- ─── ATTENDANCE (sample - last 5 days for CS students) ──────
INSERT INTO Attendance (student_id, course_id, attend_date, status) VALUES
(1,1,'2024-11-11','Present'),(1,1,'2024-11-12','Present'),(1,1,'2024-11-13','Absent'),
(2,1,'2024-11-11','Present'),(2,1,'2024-11-12','Late'),   (2,1,'2024-11-13','Present'),
(3,1,'2024-11-11','Absent'), (3,1,'2024-11-12','Absent'), (3,1,'2024-11-13','Present'),
(4,1,'2024-11-11','Present'),(4,1,'2024-11-12','Present'),(4,1,'2024-11-13','Present'),
(5,1,'2024-11-11','Present'),(5,1,'2024-11-12','Absent'), (5,1,'2024-11-13','Absent'),
(1,2,'2024-11-11','Present'),(1,2,'2024-11-12','Present'),(1,2,'2024-11-13','Present'),
(2,2,'2024-11-11','Present'),(2,2,'2024-11-12','Present'),(2,2,'2024-11-13','Present');

-- ─── EXAMS ──────────────────────────────────────────────────
INSERT INTO Exam (course_id, exam_type, exam_date, max_marks) VALUES
(1,'Internal','2024-10-05',50),(1,'External','2024-11-20',100),
(2,'Internal','2024-10-06',50),(2,'External','2024-11-21',100),
(3,'Internal','2024-10-07',50),(3,'External','2024-11-22',100);

-- ─── EXAM RESULTS ───────────────────────────────────────────
INSERT INTO Exam_Result (exam_id, student_id, marks_obtained) VALUES
(1,1,44),(1,2,38),(1,3,32),(1,4,49),(1,5,25),
(2,1,88),(2,2,76),(2,3,65),(2,4,97),(2,5,50),
(3,1,47),(3,2,42),(3,3,36),(3,4,50),(3,5,30),
(4,1,95),(4,2,85),(4,3,72),(4,4,90),(4,5,68),
(5,1,37),(5,2,40),(5,3,27),(5,4,49),(5,5,35),
(6,1,75),(6,2,80),(6,3,55),(6,4,98),(6,5,70);

-- ─── FEE ────────────────────────────────────────────────────
INSERT INTO Fee (student_id, amount, fee_type, paid_on, status, academic_year) VALUES
(1,45000,'Tuition','2024-07-10','Paid','2024-25'),
(2,45000,'Tuition','2024-07-12','Paid','2024-25'),
(3,45000,'Tuition',NULL,'Pending','2024-25'),
(4,45000,'Tuition','2024-07-05','Paid','2024-25'),
(5,45000,'Tuition',NULL,'Overdue','2024-25'),
(1,12000,'Hostel','2024-07-10','Paid','2024-25'),
(3,12000,'Hostel',NULL,'Pending','2024-25'),
(6,45000,'Tuition','2024-07-08','Paid','2024-25'),
(7,45000,'Tuition',NULL,'Pending','2024-25'),
(8,45000,'Tuition','2024-07-15','Paid','2024-25'),
(9,45000,'Tuition',NULL,'Overdue','2024-25'),
(10,45000,'Tuition','2024-07-11','Paid','2024-25'),
(11,45000,'Tuition','2024-07-13','Paid','2024-25');
