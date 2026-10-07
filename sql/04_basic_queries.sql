-- BASIC SELECT PRACTICE

-- 1. List all students
SELECT *
FROM students;

-- 2. List all courses
SELECT *
FROM courses;

-- 3. List students older than 20
SELECT id, name, age, email
FROM students
WHERE age > 20;

-- 4. List courses with more than 3 credit points
SELECT id, title, credit, professor_id
FROM courses
WHERE credit > 3;

-- 5. List professors from the Computer Science department
SELECT id, name, department
FROM professors
WHERE department = 'Computer Science';

-- 6. Sort students by name
SELECT id, name, age, email
FROM students
ORDER BY name ASC;  -- Default DESC

-- 7. Sort courses by credit count
SELECT id, title, credit, professor_id
FROM courses
ORDER BY credit DESC, title ASC;  --Multiple sorting criteria
