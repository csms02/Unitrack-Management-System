-- JOIN PRACTICE
--1. INNER JOIN  (list every student with their enrolled course titles)

/* Cant directly conect students and courses as not related
related via enrollement( related to both) */

-- Method 1 (Without Join)
SELECT s.name, c.title
FROM students s, enrollement e, courses c
WHERE s.id = e.student_id AND c.id = e.course_id;



--Method 2(With Join , each JOIN has it own ON)
SELECT s.name, c.title FROM students s
INNER JOIN enrollement e ON s.id = e.student_id
INNER JOIN courses c ON c.id = e.course_id;
/*
-- Method 3 ( Only work for Inner Join)
SELECT s.name, c.title FROM students s
INNER JOIN enrollement e INNER JOIN courses c
ON c.id = e.course_id AND s.id = e.student_id;
*/
-- Once written any JOIN query, for different JOIN just change the JOIN keyword


--2. LEFT JOIN: list ALL students including those with no enrollments (Karan should appear with NULLs)
SELECT s.name, c.title FROM students s
LEFT JOIN enrollement e ON s.id = e.student_id
LEFT JOIN courses c ON c.id = e.course_id;

--3 RIGHT JOIN : list ALL courses including those with no enrollments (courses 4 and 5 should appear)

SELECT s.name, c.title FROM students s
RIGHT JOIN enrollement e ON s.id = e.student_id
RIGHT JOIN courses c ON c.id = e.course_id;

--4. FULL OUTER JOIN: combine both — all students + all courses, NULLs where no match

SELECT s.name, c.title FROM students s
full outer JOIN enrollement e ON s.id = e.student_id
full outer JOIN courses c ON c.id = e.course_id;

--5. SELF JOIN: find pairs of professors in the same department

SELECT p1.name, p2.name, p1.department
FROM professors p1
JOIN professors p2
  ON p1.department = p2.department
 AND p1.id < p2.id;
 
--6. 3-table JOIN: student name + course title + professor name together

SELECT s.name AS student_name,
       c.title AS course_title,
       p.name AS professor_name
FROM students s
JOIN enrollement e
  ON s.id = e.student_id
JOIN courses c
  ON c.id = e.course_id
JOIN professors p
  ON p.id = c.professor_id;