-- PROCEDURES AND TRIGGERS PRACTICE

-- 1. Audit table for deleted students
CREATE TABLE IF NOT EXISTS deleted_students_log (
  student_id INTEGER,
  name VARCHAR(50),
  deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Helper function to compute GPA from current enrollement rows
CREATE OR REPLACE FUNCTION calculate_student_gpa(p_student_id INTEGER)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
  v_gpa NUMERIC(3,2);
BEGIN
  SELECT ROUND(
           COALESCE(
             SUM(
               CASE e.grade
                 WHEN 'A' THEN 4.0
                 WHEN 'B' THEN 3.0
                 WHEN 'C' THEN 2.0
                 WHEN 'D' THEN 1.0
                 WHEN 'E' THEN 0.5
                 ELSE 0.0
               END * c.credit
             ) / NULLIF(SUM(c.credit), 0),
             0
           )::numeric,
           2
         )
  INTO v_gpa
  FROM enrollement e
  JOIN courses c
    ON c.id = e.course_id
  WHERE e.student_id = p_student_id;

  RETURN COALESCE(v_gpa, 0);
END;
$$;

-- 3. Helper function to refresh one student's GPA
CREATE OR REPLACE FUNCTION refresh_student_gpa(p_student_id INTEGER)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE students
  SET gpa = calculate_student_gpa(p_student_id)
  WHERE id = p_student_id;
END;
$$;

-- 4. Helper function to refresh course enrollment count
CREATE OR REPLACE FUNCTION refresh_course_enrolled_count(p_course_id INTEGER)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE courses
  SET enrolled_count = (
    SELECT COUNT(*)
    FROM enrollement
    WHERE course_id = p_course_id
  )
  WHERE id = p_course_id;
END;
$$;

-- 5. Trigger function after enrollement changes
CREATE OR REPLACE FUNCTION trg_sync_enrollement_counts()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    PERFORM refresh_course_enrolled_count(NEW.course_id);
    PERFORM refresh_student_gpa(NEW.student_id);
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    PERFORM refresh_course_enrolled_count(OLD.course_id);
    PERFORM refresh_student_gpa(OLD.student_id);
    IF NEW.course_id IS DISTINCT FROM OLD.course_id THEN
      PERFORM refresh_course_enrolled_count(NEW.course_id);
    END IF;
    IF NEW.student_id IS DISTINCT FROM OLD.student_id THEN
      PERFORM refresh_student_gpa(NEW.student_id);
    END IF;
    RETURN NEW;
  ELSE
    PERFORM refresh_course_enrolled_count(OLD.course_id);
    PERFORM refresh_student_gpa(OLD.student_id);
    RETURN OLD;
  END IF;
END;
$$;

DROP TRIGGER IF EXISTS trg_enrollement_sync ON enrollement;
CREATE TRIGGER trg_enrollement_sync
AFTER INSERT OR UPDATE OR DELETE ON enrollement
FOR EACH ROW
EXECUTE FUNCTION trg_sync_enrollement_counts();

-- 6. Trigger function to log deleted students
CREATE OR REPLACE FUNCTION trg_log_deleted_student()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO deleted_students_log (student_id, name, deleted_at)
  VALUES (OLD.id, OLD.name, CURRENT_TIMESTAMP);
  RETURN OLD;
END;
$$;

DROP TRIGGER IF EXISTS trg_student_delete_log ON students;
CREATE TRIGGER trg_student_delete_log
AFTER DELETE ON students
FOR EACH ROW
EXECUTE FUNCTION trg_log_deleted_student();

-- 7. Procedure to enroll a student
CREATE OR REPLACE PROCEDURE enroll_student(
  p_student_id INTEGER,
  p_course_id INTEGER,
  p_grade CHAR(1),
  p_semester VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO enrollement (student_id, course_id, grade, enrolled_date, semester)
  VALUES (p_student_id, p_course_id, p_grade, CURRENT_DATE, p_semester)
  ON CONFLICT (student_id, course_id) DO UPDATE
    SET grade = EXCLUDED.grade,
        semester = EXCLUDED.semester;
END;
$$;

-- 8. Procedure to drop a student from a course
CREATE OR REPLACE PROCEDURE drop_student_from_course(
  p_student_id INTEGER,
  p_course_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
  DELETE FROM enrollement
  WHERE student_id = p_student_id
    AND course_id = p_course_id;
END;
$$;

-- 9. Procedure to recalculate all GPAs
CREATE OR REPLACE PROCEDURE refresh_all_student_gpas()
LANGUAGE plpgsql
AS $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN SELECT id FROM students LOOP
    PERFORM refresh_student_gpa(r.id);
  END LOOP;
END;
$$;

-- Example calls
CALL enroll_student(4, 5, 'B', 'Spring 2024');
CALL drop_student_from_course(4, 5);
CALL refresh_all_student_gpas();
