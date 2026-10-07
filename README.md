# UniTrack – University Database System

UniTrack is a PostgreSQL-based database project designed to manage basic university information such as students, professors, courses, and enrollments.

The project focuses on practicing relational database concepts and writing SQL queries to retrieve and work with connected academic data.

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
└── screenshots
```

## 📌 Features

- Student, professor, and course management
- Student-course enrollment records
- Relational table design
- Primary and foreign key relationships
- CRUD operations
- SQL JOIN queries
- Data filtering and sorting
- Aggregate queries and grouping
- Subqueries
- Common Table Expressions (CTEs)
- Views
- Transactions

## 🗄️ Main Tables

- **Students** – stores student information
- **Professors** – stores professor information and departments
- **Courses** – stores course details and assigned professors
- **Enrollment** – connects students with the courses they take

### Basic Relationship

```text
Students ───< Enrollment >─── Courses ───> Professors
```

## 🔗 JOIN Practice

The project includes practical examples of:

- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- FULL OUTER JOIN
- SELF JOIN
- Multi-table JOINs

For example, students can be connected with their enrolled courses through the enrollment table.

## 🛠️ Technologies

- PostgreSQL
- SQL
- pgAdmin 4
- Git & GitHub

## ▶️ How to Run

1. Create a PostgreSQL database named `unitrack`.
2. Open it in pgAdmin 4.
3. Run the table creation and data insertion SQL files.
4. Execute the query files to explore the database.

## 🎯 Purpose

This project was created to develop practical understanding of **PostgreSQL, relational database design, SQL queries, and table relationships** through a university management use case.

## 👤 Author

**csms02**
