-- ADVANCED QUERIES AND FINAL REPORTS

-- 1. Rank students by GPA
SELECT s.id,
       s.name,
       s.gpa,
       RANK() OVER (ORDER BY s.gpa DESC NULLS LAST, s.name ASC) AS gpa_rank
FROM students s
ORDER BY gpa_rank, s.name;

-- 2. Rank courses by enrollment count
WITH course_counts AS (
  SELECT c.id,
         c.title,
         c.credit,
         COUNT(e.student_id) AS enrollement_count
  FROM courses c
  LEFT JOIN enrollement e
    ON c.id = e.course_id
  GROUP BY c.id, c.title, c.credit
)
SELECT id,
       title,
       credit,
       enrollement_count,
       RANK() OVER (ORDER BY enrollement_count DESC, title ASC) AS enrollement_rank
FROM course_counts
ORDER BY enrollement_rank, title;

-- 3. Show the top student per course
WITH course_student_gpa AS (
  SELECT c.id AS course_id,
         c.title AS course_title,
         s.id AS student_id,
         s.name AS student_name,
         e.grade,
         s.gpa,
         ROW_NUMBER() OVER (
           PARTITION BY c.id
           ORDER BY s.gpa DESC NULLS LAST, s.name ASC
         ) AS rn
  FROM courses c
  JOIN enrollement e
    ON c.id = e.course_id
  JOIN students s
    ON s.id = e.student_id
)
SELECT course_id,
       course_title,
       student_id,
       student_name,
       grade,
       gpa
FROM course_student_gpa
WHERE rn = 1
ORDER BY course_title;

-- 4. Compare current and previous semester performance
WITH semester_performance AS (
  SELECT e.student_id,
         e.semester,
         MIN(e.enrolled_date) AS first_enrolled_date,
         ROUND(AVG(
           CASE e.grade
             WHEN 'A' THEN 4.0
             WHEN 'B' THEN 3.0
             WHEN 'C' THEN 2.0
             WHEN 'D' THEN 1.0
             WHEN 'E' THEN 0.5
             ELSE 0.0
           END
         )::numeric, 2) AS semester_gpa
  FROM enrollement e
  GROUP BY e.student_id, e.semester
),
semester_trends AS (
  SELECT sp.student_id,
         s.name AS student_name,
         sp.semester,
         sp.semester_gpa,
         LAG(sp.semester_gpa) OVER (
           PARTITION BY sp.student_id
           ORDER BY sp.first_enrolled_date, sp.semester
         ) AS previous_semester_gpa,
         LEAD(sp.semester_gpa) OVER (
           PARTITION BY sp.student_id
           ORDER BY sp.first_enrolled_date, sp.semester
         ) AS next_semester_gpa
  FROM semester_performance sp
  JOIN students s
    ON s.id = sp.student_id
)
SELECT student_id,
       student_name,
       semester,
       semester_gpa,
       previous_semester_gpa,
       next_semester_gpa,
       ROUND((semester_gpa - COALESCE(previous_semester_gpa, semester_gpa))::numeric, 2) AS change_from_previous
FROM semester_trends
ORDER BY student_name, semester;

-- 5. Find overloaded professors
WITH professor_load AS (
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
)
SELECT professor_id,
       professor_name,
       department,
       course_count,
       total_enrollement_count,
       RANK() OVER (ORDER BY course_count DESC, total_enrollement_count DESC, professor_name ASC) AS workload_rank
FROM professor_load
WHERE course_count > 1 OR total_enrollement_count > 3
ORDER BY workload_rank, professor_name;

-- 6. Find under-enrolled courses
WITH course_capacity AS (
  SELECT c.id AS course_id,
         c.title,
         c.max_capacity,
         c.enrolled_count,
         COUNT(e.student_id) AS actual_enrollement_count
  FROM courses c
  LEFT JOIN enrollement e
    ON c.id = e.course_id
  GROUP BY c.id, c.title, c.max_capacity, c.enrolled_count
)
SELECT course_id,
       title,
       max_capacity,
       enrolled_count,
       actual_enrollement_count,
       ROUND(
         CASE
           WHEN COALESCE(max_capacity, 0) = 0 THEN 0
           ELSE (actual_enrollement_count::numeric / max_capacity::numeric) * 100
         END,
         2
       ) AS fill_rate_percent
FROM course_capacity
WHERE COALESCE(actual_enrollement_count, 0) < COALESCE(max_capacity, 0) / 2
ORDER BY fill_rate_percent ASC, title ASC;
