-- INTERMEDIATE SQL PRACTICE

-- 1. Students who are not enrolled in any course
-- NOT EXISTS is safer than NOT IN when NULLs may appear.
SELECT s.id,
       s.name,
       s.age,
       s.email
FROM students s
WHERE NOT EXISTS (
  SELECT 1
  FROM enrollement e
  WHERE e.student_id = s.id
)
ORDER BY s.name ASC;

-- 2. Courses with no students
SELECT c.id,
       c.title,
       c.credit,
       c.professor_id
FROM courses c
WHERE NOT EXISTS (
  SELECT 1
  FROM enrollement e
  WHERE e.course_id = c.id
)
ORDER BY c.title ASC;

-- 3. Label students as Enrolled or Not Enrolled
SELECT s.id,
       s.name,
       CASE
         WHEN EXISTS (
           SELECT 1
           FROM enrollement e
           WHERE e.student_id = s.id
         ) THEN 'Enrolled'
         ELSE 'Not Enrolled'
       END AS enrollement_status
FROM students s
ORDER BY s.name ASC;

-- 4. Count enrollement records per student using a CTE
WITH enrollement_counts AS (
  SELECT s.id AS student_id,
         s.name AS student_name,
         COUNT(e.course_id) AS enrollement_count
  FROM students s
  LEFT JOIN enrollement e
    ON s.id = e.student_id
  GROUP BY s.id, s.name
)
SELECT student_id,
       student_name,
       enrollement_count
FROM enrollement_counts
ORDER BY enrollement_count DESC, student_name ASC;

-- 5. Show a default value when a course has no students
SELECT c.id,
       c.title,
       COALESCE(COUNT(e.student_id), 0) AS student_count,
       CASE
         WHEN COUNT(e.student_id) = 0 THEN 'No students enrolled'
         ELSE COUNT(e.student_id)::text
       END AS student_summary
FROM courses c
LEFT JOIN enrollement e
  ON c.id = e.course_id
GROUP BY c.id, c.title
ORDER BY c.title ASC;
