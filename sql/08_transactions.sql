-- TRANSACTIONS PRACTICE

-- 1. Enrolling a student in a course
-- Example: enroll Karan (student_id 5) in Linear Algebra (course_id 4).
BEGIN;

INSERT INTO enrollement (student_id, course_id, grade, enrolled_date, semester)
VALUES (5, 4, 'A', CURRENT_DATE, 'Spring 2024')
ON CONFLICT (student_id, course_id) DO NOTHING;

-- Check the row before committing.
SELECT *
FROM enrollement
WHERE student_id = 5 AND course_id = 4;

COMMIT;

-- 2. Dropping a student from a course
-- Example: remove Karan from Linear Algebra after the enrollment exists.
BEGIN;

DELETE FROM enrollement
WHERE student_id = 5
  AND course_id = 4;

-- Check the row before committing the delete.
SELECT *
FROM enrollement
WHERE student_id = 5 AND course_id = 4;

COMMIT;

-- 3. Rolling back a failed enrollment
-- Try an insert, inspect it, then undo it.
BEGIN;

INSERT INTO enrollement (student_id, course_id, grade, enrolled_date, semester)
VALUES (5, 5, 'B', CURRENT_DATE, 'Spring 2024')
ON CONFLICT (student_id, course_id) DO NOTHING;

SELECT *
FROM enrollement
WHERE student_id = 5 AND course_id = 5;

ROLLBACK;

-- 4. Using a savepoint before a risky update
BEGIN;

SAVEPOINT before_grade_change;

-- Change a grade as the risky operation.
UPDATE enrollement
SET grade = 'A'
WHERE student_id = 1
  AND course_id = 2;

-- Undo just the risky update if needed.
ROLLBACK TO SAVEPOINT before_grade_change;

-- Continue with a safe action after the savepoint rollback.
UPDATE enrollement
SET semester = 'Spring 2024'
WHERE student_id = 1
  AND course_id = 2;

COMMIT;
