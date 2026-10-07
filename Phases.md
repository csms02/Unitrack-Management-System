# UniTrack Project Phases

This plan is for learning SQL step by step while building the UniTrack database project.

featGoal: build a university tracking database that manages professors, students, courses, enrollement records, grades, reports, performance, transactions, views, JSON data, search, procedures, and triggers.

## Phase 1: Understand the Project and Setup

### Learn

- What a relational database is.
- What tables, rows, columns, primary keys, and foreign keys are.
- How PostgreSQL stores related data.
- How SQL files are organized in a project.

### Build

- Read `README.md`.
- Understand the current folders:
  - `schema/` for table creation and seed data.
  - `sql/` for practice queries.
- Install or open PostgreSQL.
- Create a database named `unitrack`.

### Do

```sql
CREATE DATABASE unitrack;
```

Then connect to it before running project files.

### Done When

- You can explain what UniTrack tracks.
- The `unitrack` database exists.
- You know which SQL file should be run first.

## Phase 2: Create the Core Schema

### Learn

- `CREATE TABLE`
- Data types: `SERIAL`, `VARCHAR`, `INTEGER`, `DATE`, `CHAR`
- `PRIMARY KEY`
- `FOREIGN KEY`
- `NOT NULL`
- `UNIQUE`
- `CHECK`
- Composite primary keys

### Build

- Complete and clean `schema/01_create_tables.sql`.
- Create these tables:
  - `professors`
  - `students`
  - `courses`
  - `enrollement`

### Do

- Use consistent column names.
- Make sure every table has proper constraints.
- Run the file in PostgreSQL.

Example command:

```bash
psql -d unitrack -f schema/01_create_tables.sql
```

### Done When

- All tables are created without errors.
- `\dt` shows all project tables.
- You can explain how students and courses are connected through `enrollement`.

## Phase 3: Insert Sample Data

### Learn

- `INSERT INTO`
- Inserting all columns vs selected columns
- How foreign keys affect insert order
- How sample data helps test queries

### Build

- Complete `schema/02_seed_data.sql`.
- Add sample data for:
  - Professors
  - Students
  - Courses
  - `enrollement`

### Do

- Insert professors before courses.
- Insert students and courses before `enrollement`.
- Add at least one student with no `enrollement`.
- Add at least one course with no `enrollement`.

Example command:

```bash
psql -d unitrack -f schema/02_seed_data.sql
```

### Done When

- Sample data inserts without errors.
- You can run `SELECT * FROM students;`.
- You can run `SELECT * FROM courses;`.
- You have data that can test inner, left, right, and full joins.

## Phase 4: Basic SELECT Practice

### Learn

- `SELECT`
- `WHERE`
- `ORDER BY`
- `LIMIT`
- Column aliases
- Basic filtering
- Basic comparison operators

### Build

- Create `sql/04_basic_queries.sql`.

### Do

Write queries for:

- List all students.
- List all courses.
- List students older than 20.
- List courses with more than 3 `credit` points.
- List professors from the Computer Science department.
- Sort students by name.
- Sort courses by `credit` count.

### Done When

- You can retrieve data from each table.
- You can filter and sort results without help.

## Phase 5: Join Queries

### Learn

- `INNER JOIN`
- `LEFT JOIN`
- `RIGHT JOIN`
- `FULL OUTER JOIN`
- `SELF JOIN`
- Joining more than two tables
- Table aliases

### Build

- Improve `sql/03_joins.sql`.

### Do

Write and understand queries for:

- Students with their enrolled courses.
- All students, including students with no `enrollement` records.
- All courses, including courses with no students.
- Students, courses, and professor names together.
- Professor pairs from the same department.

### Done When

- You understand why the enrollment table is needed.
- You know when to use each join type.
- You can predict when `NULL` values will appear.

## Phase 6: Aggregation and Reports

### Learn

- `COUNT`
- `AVG`
- `MIN`
- `MAX`
- `SUM`
- `GROUP BY`
- `HAVING`

### Build

- Create `sql/05_aggregations.sql`.

### Do

Write reports for:

- Number of students in each course.
- Number of courses taught by each professor.
- Average student age.
- Highest and lowest grades by course if using numeric grades later.
- Courses with more than one student.
- Departments with more than one professor.

### Done When

- You can create summary reports.
- You understand the difference between `WHERE` and `HAVING`.

## Phase 7: Intermediate SQL

### Learn

- Subqueries
- Common Table Expressions using `WITH`
- `CASE WHEN`
- `COALESCE`
- `NULL` handling

### Build

- Create `sql/06_intermediate.sql`.

### Do

Write queries for:

- Students who are not enrolled in any course.
- Courses with no students.
- Label students as `Enrolled` or `Not Enrolled`.
- Count `enrollement` records per student using a CTE.
- Show a default value when a course has no students.

### Done When

- You can break complex queries into readable steps.
- You can handle missing data clearly.

## Phase 8: Add GPA and Better Course Tracking

### Learn

- `ALTER TABLE`
- Updating schema after data already exists
- Derived values
- Grade-to-point conversion

### Build

- Update schema to support:
  - `students.gpa`
  - `courses.max_capacity`
  - `courses.enrolled_count`
  - `enrollement.semester`
- Create `schema/03_alter_tables.sql`.

### Do

- Add new columns with `ALTER TABLE`.
- Create grade mapping logic using `CASE WHEN`.
- Write queries to calculate GPA manually before automating it later.

### Done When

- Students can have GPA values.
- Courses can track capacity.
- `enrollement` records can be grouped by semester.

## Phase 9: Views

### Learn

- `CREATE VIEW`
- Why views are useful
- Difference between a table and a view
- Materialized views if using PostgreSQL

### Build

- Create `sql/07_views.sql`.

### Do

Create views for:

- Student enrollment summary.
- Course enrollment summary.
- Professor teaching summary.
- Student GPA report.

### Done When

- You can query a view using `SELECT * FROM view_name;`.
- You understand how views simplify repeated queries.

## Phase 10: Transactions

### Learn

- `BEGIN`
- `COMMIT`
- `ROLLBACK`
- `SAVEPOINT`
- Why transactions protect data

### Build

- Create `sql/08_transactions.sql`.

### Do

Write transaction examples for:

- Enrolling a student in a course.
- Dropping a student from a course.
- Rolling back a failed enrollment.
- Using a savepoint before a risky update.

### Done When

- You can explain why enrollment changes should use transactions.
- You can safely undo a failed operation.

## Phase 11: Indexes and Query Optimization

### Learn

- `CREATE INDEX`
- `EXPLAIN`
- `EXPLAIN ANALYZE`
- Why indexes improve lookup speed
- When indexes are not useful

### Build

- Create `sql/09_indexes_optimization.sql`.
- Add a `screenshots/explain_analyze/` folder if needed.

### Do

Add indexes for:

- `students.email`
- `courses.professor_id`
- `enrollement.student_id`
- `enrollement.course_id`

Compare query plans before and after indexes.

### Done When

- You can read a basic query plan.
- You can explain why an index helps a specific query.

## Phase 12: JSON and Full-Text Search

### Learn

- PostgreSQL `JSONB`
- Storing flexible student metadata
- Full-text search using `TSVECTOR`
- Searching course descriptions

### Build

- Create `sql/10_json_fulltext.sql`.

### Do

- Add `metadata JSONB` to `students`.
- Store data like hobbies, city, skills, or scholarship status.
- Add course descriptions.
- Add a searchable `description_tsv` column.
- Write search queries for course keywords.

### Done When

- You can query inside JSON data.
- You can search courses by text.

## Phase 13: Procedures and Triggers

### Learn

- PL/pgSQL basics
- Functions
- Stored procedures
- Triggers
- Audit logs

### Build

- Create `sql/11_procedures_triggers.sql`.
- Add a `deleted_students_log` table.

### Do

Create triggers to:

- Update `courses.enrolled_count` when `enrollement` rows change.
- Update `students.gpa` when grades change.
- Log deleted students into `deleted_students_log`.

### Done When

- Enrolled count updates automatically.
- GPA can be recalculated automatically.
- Deleted students are recorded in an audit table.

## Phase 14: Advanced Queries and Final Reports

### Learn

- Window functions
- `ROW_NUMBER`
- `RANK`
- `LAG`
- `LEAD`
- Complex reporting queries

### Build

- Create `sql/12_advanced_queries.sql`.

### Do

Write reports for:

- Rank students by GPA.
- Rank courses by enrollment count.
- Show top student per course.
- Compare current and previous semester performance.
- Find overloaded professors.
- Find under-enrolled courses.

### Done When

- You can write analytical SQL queries.
- Your database can answer real project questions.

## Phase 15: Documentation and Cleanup

### Learn

- Writing clear project documentation
- Explaining schema design
- Explaining how to run a SQL project
- Keeping files organized

### Build

- Update `README.md`.

### Do

Document:

- Project purpose.
- Final folder structure.
- Schema diagram.
- Setup steps.
- File run order.
- Important queries.
- Concepts learned.

Recommended run order:

```text
schema/01_create_tables.sql
schema/02_seed_data.sql
schema/03_alter_tables.sql
sql/03_joins.sql
sql/04_basic_queries.sql
sql/05_aggregations.sql
sql/06_intermediate.sql
sql/07_views.sql
sql/08_transactions.sql
sql/09_indexes_optimization.sql
sql/10_json_fulltext.sql
sql/11_procedures_triggers.sql
sql/12_advanced_queries.sql
```

### Done When

- Another person can clone the project and run it.
- The README explains what the project does.
- The SQL files are named clearly and run in order.

## Final Checklist

- Database can be created from scratch.
- Tables have correct keys and constraints.
- Sample data is realistic.
- Basic queries work.
- Join queries work.
- Aggregation reports work.
- Intermediate queries work.
- Views work.
- Transactions are demonstrated.
- Indexes are tested.
- JSON and full-text search are demonstrated.
- Triggers automate important updates.
- Advanced reports answer useful questions.
- README is clear and complete.

## Suggested Learning Order

1. Tables and constraints
2. Inserts and sample data
3. Basic selects
4. Joins
5. Aggregations
6. Subqueries and CTEs
7. Schema changes
8. Views
9. Transactions
10. Indexes
11. JSONB
12. Full-text search
13. Procedures and triggers
14. Window functions
15. Documentation
