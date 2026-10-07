# UniTrack

UniTrack is a PostgreSQL project for building and practicing a university database. It helps you learn relational schema design, SQL queries, joins, aggregation, views, transactions, indexes, JSONB, full-text search, and triggers while managing professors, students, courses, and enrollments.

## Project Structure

```text
unitrack/
├── README.md
├── Phases.md
├── schema/
│   ├── 01_create_tables.sql
│   ├── 02_seed_data.sql
│   └── 03_alter_tables.sql
├── sql/
│   ├── 03_joins.sql
│   ├── 04_basic_queries.sql
│   ├── 05_aggregations.sql
│   ├── 06_intermediate.sql
│   ├── 07_views.sql
│   ├── 08_transactions.sql
│   ├── 09_indexes_optimization.sql
│   ├── 10_json_fulltext.sql
│   ├── 11_procedures_triggers.sql
│   └── 12_advanced_queries.sql
└── screenshots/
    └── explain_analyze/
```

## Schema Summary

- `professors`
  - `id` primary key
  - `name`
  - `department`

- `students`
  - `id` primary key
  - `name`
  - `age`
  - `email`
  - `gpa`
  - `metadata` JSONB

- `courses`
  - `id` primary key
  - `title`
  - `credit`
  - `professor_id` foreign key
  - `max_capacity`
  - `enrolled_count`
  - `description`
  - `description_tsv`

- `enrollement`
  - `student_id` foreign key
  - `course_id` foreign key
  - `grade`
  - `enrolled_date`
  - `semester`

- `deleted_students_log`
  - `student_id`
  - `name`
  - `deleted_at`

## Setup

1. Create the database.

```sql
CREATE DATABASE unitrack;
```

2. Connect to it in PostgreSQL.
3. Run the schema files in order.

## Run Order

Run these files from top to bottom:

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

## What Each Phase Adds

- Phase 1: project setup
- Phase 2: core tables and constraints
- Phase 3: seed data
- Phase 4: basic `SELECT` queries
- Phase 5: joins
- Phase 6: aggregation reports
- Phase 7: subqueries and CTEs
- Phase 8: schema extensions for GPA, capacity, and semester
- Phase 9: views
- Phase 10: transactions
- Phase 11: indexes and query plans
- Phase 12: JSONB and full-text search
- Phase 13: procedures and triggers
- Phase 14: advanced analytical queries

## Notes

- The project intentionally keeps the current names `enrollement` and `credit` in the SQL files.
- See [Phases.md](./Phases.md) for the learning-first phase plan.
- The SQL files are written for PostgreSQL.

## Useful Checks

```sql
\dt
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM enrollement;
```
