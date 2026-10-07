-- VIEWS PRACTICE

-- 1. Student enrollment summary
CREATE OR REPLACE VIEW student_enrollment_summary AS
SELECT s.id AS student_id,
       s.name AS student_name,
       s.age,
       s.email,
       COUNT(e.course_id) AS enrollement_count,
       COALESCE(MAX(e.semester), 'No semester') AS last_recorded_semester
FROM students s
LEFT JOIN enrollement e
  ON s.id = e.student_id
GROUP BY s.id, s.name, s.age, s.email
ORDER BY s.name ASC;

-- 2. Course enrollment summary
CREATE OR REPLACE VIEW course_enrollment_summary AS
SELECT c.id AS course_id,
       c.title AS course_title,
       c.credit,
       c.professor_id,
       p.name AS professor_name,
       c.max_capacity,
       c.enrolled_count,
       COUNT(e.student_id) AS actual_enrollement_count,
       ROUND(
         CASE
           WHEN COALESCE(c.max_capacity, 0) = 0 THEN 0
           ELSE (COUNT(e.student_id)::numeric / c.max_capacity::numeric) * 100
         END,
         2
       ) AS capacity_usage_percent
FROM courses c
LEFT JOIN professors p
  ON p.id = c.professor_id
LEFT JOIN enrollement e
  ON c.id = e.course_id
GROUP BY c.id, c.title, c.credit, c.professor_id, p.name, c.max_capacity, c.enrolled_count
ORDER BY c.title ASC;

-- 3. Professor teaching summary
CREATE OR REPLACE VIEW professor_teaching_summary AS
SELECT p.id AS professor_id,
       p.name AS professor_name,
       p.department,
       COUNT(DISTINCT c.id) AS course_count,
       COUNT(e.student_id) AS total_enrollement_count
FROM professors p
LEFT JOIN courses c
  ON p.id = c.professor_id
LEFT JOIN enrollement e
  ON c.id = e.course_id
GROUP BY p.id, p.name, p.department
ORDER BY p.department ASC, p.name ASC;

-- 4. Student GPA report
CREATE OR REPLACE VIEW student_gpa_report AS
WITH grade_points AS (
  SELECT e.student_id,
         c.credit,
         CASE e.grade
           WHEN 'A' THEN 4.0
           WHEN 'B' THEN 3.0
           WHEN 'C' THEN 2.0
           WHEN 'D' THEN 1.0
           WHEN 'E' THEN 0.5
           ELSE 0.0
         END AS points
  FROM enrollement e
  JOIN courses c
    ON c.id = e.course_id
)
SELECT s.id AS student_id,
       s.name AS student_name,
       s.age,
       s.email,
       ROUND(COALESCE(SUM(gp.points * gp.credit) / NULLIF(SUM(gp.credit), 0), 0)::numeric, 2) AS calculated_gpa,
       COUNT(gp.student_id) AS enrolled_courses
FROM students s
LEFT JOIN grade_points gp
  ON gp.student_id = s.id
GROUP BY s.id, s.name, s.age, s.email
ORDER BY calculated_gpa DESC, s.name ASC;

-- Example queries
SELECT * FROM student_enrollment_summary;
SELECT * FROM course_enrollment_summary;
SELECT * FROM professor_teaching_summary;
SELECT * FROM student_gpa_report;
