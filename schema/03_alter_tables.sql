-- PHASE 8: SCHEMA ENHANCEMENTS
-- Add columns needed for GPA tracking, course capacity, and semester grouping.

ALTER TABLE students
ADD COLUMN gpa NUMERIC(3,2);

ALTER TABLE courses
ADD COLUMN max_capacity INTEGER CHECK (max_capacity > 0),
ADD COLUMN enrolled_count INTEGER DEFAULT 0 CHECK (enrolled_count >= 0);

ALTER TABLE enrollement
ADD COLUMN semester VARCHAR(20);

-- Optional starter values so the new columns are ready to use in reports.
UPDATE courses
SET max_capacity = COALESCE(max_capacity, 30);

UPDATE enrollement
SET semester = COALESCE(semester, 'Spring 2024');

-- Manual GPA calculation using CASE WHEN.
-- This is a learning query for now; it does not store the GPA automatically yet.
WITH grade_points AS (
  SELECT e.student_id,
         CASE e.grade
           WHEN 'A' THEN 4.0
           WHEN 'B' THEN 3.0
           WHEN 'C' THEN 2.0
           WHEN 'D' THEN 1.0
           WHEN 'E' THEN 0.5
           ELSE 0.0
         END AS points,
         c.credit
  FROM enrollement e
  JOIN courses c
    ON c.id = e.course_id
)
SELECT s.id,
       s.name,
       ROUND(COALESCE(SUM(gp.points * gp.credit) / NULLIF(SUM(gp.credit), 0), 0)::numeric, 2) AS calculated_gpa
FROM students s
LEFT JOIN grade_points gp
  ON gp.student_id = s.id
GROUP BY s.id, s.name
ORDER BY calculated_gpa DESC, s.name ASC;

-- Report course capacity and current enrollment count.
SELECT c.id,
       c.title,
       c.max_capacity,
       c.enrolled_count,
       COALESCE(COUNT(e.student_id), 0) AS actual_enrollement_count
FROM courses c
LEFT JOIN enrollement e
  ON c.id = e.course_id
GROUP BY c.id, c.title, c.max_capacity, c.enrolled_count
ORDER BY c.title ASC;

-- Group enrollement rows by semester.
SELECT semester,
       COUNT(*) AS enrollement_count
FROM enrollement
GROUP BY semester
ORDER BY semester ASC;
