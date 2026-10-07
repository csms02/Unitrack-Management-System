/* Table Creation*/

CREATE TABLE professors (
id SERIAL PRIMARY KEY,    -- each table always a primary key
name VARCHAR(50) NOT NULL,
department VARCHAR(50) NOT NULL
);

CREATE TABLE students (
id SERIAL PRIMARY KEY,
name VARCHAR(50) NOT NULL,   -- apply NOT NULL for mandatory details
age INTEGER CHECK (age BETWEEN 18 AND 35), -- To apply more constraint during insertiob
email VARCHAR(50) UNIQUE NOT NULL  --UNIQUE reject any other record with same value of this field
);

CREATE TABLE courses (
id SERIAL PRIMARY KEY,
title VARCHAR(50) NOT NULL,
credit INTEGER CHECK (credit BETWEEN 1 AND 6),
professor_id INTEGER REFERENCES professors(id)   --Foreign Key added (professor id)
);

CREATE TABLE enrollement(
student_id INTEGER REFERENCES students(id),
course_id INTEGER REFERENCES courses(id),
grade CHAR(1) CHECK ( grade IN ('A','B','C','D','E','F')),
enrolled_date DATE DEFAULT CURRENT_DATE,
PRIMARY KEY (student_id,course_id)  -- COMPOSITE PRIMARY KEY
);



