-- AGGREGATION AND REPORT PRACTICE

-- 1. Number of students in each course
-- LEFT JOIN keeps courses that currently have no enrollement rows.
SELECT c.id,
       c.title,
       COUNT(e.student_id) AS student_count
FROM courses c
LEFT JOIN enrollement e
  ON c.id = e.course_id
GROUP BY c.id, c.title
ORDER BY student_count DESC, c.title ASC;

-- 2. Number of courses taught by each professor
-- LEFT JOIN keeps professors who are not assigned any course yet.
SELECT p.id,
       p.name,
       p.department,
       COUNT(c.id) AS course_count
FROM professors p
LEFT JOIN courses c
  ON p.id = c.professor_id
GROUP BY p.id, p.name, p.department
ORDER BY course_count DESC, p.name ASC;

-- 3. Average student age
SELECT ROUND(AVG(age)::numeric, 2) AS average_student_age
FROM students;

-- 4. Highest and lowest grade by course
-- Grades are stored as letters in this schema, so MIN/MAX are lexical.
SELECT c.id,
       c.title,
       MIN(e.grade) AS lowest_grade,
       MAX(e.grade) AS highest_grade
FROM courses c
LEFT JOIN enrollement e
  ON c.id = e.course_id
GROUP BY c.id, c.title
ORDER BY c.title ASC;

-- 5. Courses with more than one student
SELECT c.id,
       c.title,
       COUNT(e.student_id) AS student_count
FROM courses c
JOIN enrollement e
  ON c.id = e.course_id
GROUP BY c.id, c.title
HAVING COUNT(e.student_id) > 1
ORDER BY student_count DESC, c.title ASC;

-- 6. Departments with more than one professor
SELECT department,
       COUNT(*) AS professor_count
FROM professors
GROUP BY department
HAVING COUNT(*) > 1
ORDER BY professor_count DESC, department ASC;
