-- INDEXES AND QUERY OPTIMIZATION PRACTICE

-- 1. Create indexes for common lookup columns
CREATE INDEX IF NOT EXISTS idx_students_email
ON students (email);

CREATE INDEX IF NOT EXISTS idx_courses_professor_id
ON courses (professor_id);

CREATE INDEX IF NOT EXISTS idx_enrollement_student_id
ON enrollement (student_id);

CREATE INDEX IF NOT EXISTS idx_enrollement_course_id
ON enrollement (course_id);

-- 2. Check the query plan before/after indexing for a student lookup
EXPLAIN ANALYZE
SELECT id, name, age, email
FROM students
WHERE email = 'rahul@email.com';

-- 3. Check the query plan for courses taught by a professor
EXPLAIN ANALYZE
SELECT c.id, c.title, c.credit
FROM courses c
WHERE c.professor_id = 1;

-- 4. Check the query plan for student enrollments
EXPLAIN ANALYZE
SELECT e.student_id, e.course_id, e.grade, e.semester
FROM enrollement e
WHERE e.student_id = 1;

-- 5. Check the query plan for course enrollments
EXPLAIN ANALYZE
SELECT e.student_id, e.course_id, e.grade, e.semester
FROM enrollement e
WHERE e.course_id = 1;
