DROP DATABASE IF EXISTS university_database;
CREATE DATABASE university_database;
USE university_database;

CREATE TABLE subjects(
	subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(50) NOT NULL
);

CREATE TABLE majors(
	major_id INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE students(
	student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_number VARCHAR(12) NOT NULL,
    student_name VARCHAR(50) NOT NULL,
    major_id INT,
    CONSTRAINT fk_major_id
    FOREIGN KEY (major_id) REFERENCES majors(major_id)
);

CREATE TABLE payments(
	payment_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_date DATE NOT NULL,
    payment_amount DECIMAL(8,2),
    student_id INT NOT NULL,
    CONSTRAINT fk_student_id
    FOREIGN KEY(student_id) REFERENCES students(student_id)
);

CREATE TABLE agenda(
	student_id INT NOT NULL,
    subject_id INT NOT NULL,
    CONSTRAINT pk_student_subject
    PRIMARY KEY(student_id,subject_id),
    
    CONSTRAINT fk_student_id1
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    
    CONSTRAINT fk_subject_id
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);
