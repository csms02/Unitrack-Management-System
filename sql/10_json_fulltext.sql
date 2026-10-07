-- JSONB AND FULL-TEXT SEARCH PRACTICE

-- 1. Add sample JSON metadata to students
ALTER TABLE students
ADD COLUMN IF NOT EXISTS metadata JSONB;

UPDATE students
SET metadata = jsonb_build_object(
  'city', 'Hyderabad',
  'skills', jsonb_build_array('SQL', 'Python', 'Data Analysis'),
  'scholarship', true
)
WHERE id = 1;

UPDATE students
SET metadata = jsonb_build_object(
  'city', 'Bangalore',
  'skills', jsonb_build_array('SQL', 'Java'),
  'scholarship', false
)
WHERE id = 2;

UPDATE students
SET metadata = jsonb_build_object(
  'city', 'Pune',
  'skills', jsonb_build_array('C', 'Linux'),
  'scholarship', true
)
WHERE id = 3;

-- 2. Query JSONB fields
SELECT id,
       name,
       metadata->>'city' AS city,
       metadata->'skills' AS skills,
       metadata->>'scholarship' AS scholarship_status
FROM students
ORDER BY name ASC;

SELECT id,
       name
FROM students
WHERE metadata->>'city' = 'Hyderabad';

SELECT id,
       name
FROM students
WHERE metadata->'skills' ? 'SQL';

-- 3. Add course descriptions
ALTER TABLE courses
ADD COLUMN IF NOT EXISTS description TEXT,
ADD COLUMN IF NOT EXISTS description_tsv tsvector;

UPDATE courses
SET description = CASE id
  WHEN 1 THEN 'Data structures course covering arrays, linked lists, stacks, and queues.'
  WHEN 2 THEN 'Calculus course focused on limits, derivatives, and integrals.'
  WHEN 3 THEN 'Algorithms course covering sorting, searching, and complexity analysis.'
  WHEN 4 THEN 'Linear algebra course on vectors, matrices, and transformations.'
  WHEN 5 THEN 'Operating systems fundamentals with processes, memory, and scheduling.'
END;

UPDATE courses
SET description_tsv = to_tsvector('english', COALESCE(description, ''));

CREATE INDEX IF NOT EXISTS idx_courses_description_tsv
ON courses
USING GIN (description_tsv);

-- 4. Full-text search examples
SELECT id,
       title,
       description
FROM courses
WHERE description_tsv @@ plainto_tsquery('english', 'sorting algorithms');

SELECT id,
       title,
       description
FROM courses
WHERE description_tsv @@ plainto_tsquery('english', 'memory scheduling');

-- 5. Refresh the tsvector after description changes
SELECT id,
       title,
       ts_rank(description_tsv, plainto_tsquery('english', 'systems')) AS rank
FROM courses
WHERE description_tsv @@ plainto_tsquery('english', 'systems')
ORDER BY rank DESC, title ASC;
