/* Data Insertion*/
-- 2 types 

INSERT INTO professors VALUES    -- No id required as SERIAL, so auto increment
(1,'Dr. Sharma','Computer Science'),  -- type 1 = No (specify field) if adding all value in sequence
(2,'Dr. Mehta','Mathematics'),
(3,'Dr. Rao','Computer Science');

INSERT INTO students (name,age,email)  -- type 2 = Specify field if not adding all fields (here id is not added)
VALUES
('Rahul',20,'rahul@email.com'),  
('Priya',21,'priya@email.com'),
('Arjun',22,'arjun@email.com'),
('Sneha',20,'sneha@email.com'),
('Karan',23,'karan@email.com');

INSERT INTO courses VALUES
(1,'Data Structures',4,1),
(2,'Calculus',3,2),
(3,'Algorithms',4,1),
(4,'Linear Algebra',3,2),
(5,'OS Fundamentals',4,3);

INSERT INTO enrollement VALUES
(1,1,'A','2024-01-10'),
(1,2,'B','2024-01-10'),
(2,1,'A','2024-01-11'),
(2,3,'B','2024-01-11'),
(3,3,'C','2024-01-12'),
(4,2,'A','2024-01-12');