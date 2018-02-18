CREATE DATABASE IF NOT EXISTS school_sport_clubs;
USE school_sport_clubs;

CREATE TABLE sports(
	sport_id INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(30) NOT NULL
);

CREATE TABLE coaches(
	coach_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL
);

CREATE TABLE students(
	student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    egn VARCHAR(10) NOT NULL
);

CREATE TABLE `group`(
	group_id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(120) NOT NULL,
    coach_id INT,
    sport_id INT,
    day_of_week ENUM('monday','tuesday','wednesday','thursday','friday','saturday','sunday'),
    start_hour TIME,
    UNIQUE KEY(day_of_week,start_hour,coach_id),
    CONSTRAINT FOREIGN KEY (sport_id) REFERENCES sports(sport_id),
    CONSTRAINT FOREIGN KEY (coach_id) REFERENCES coaches(coach_id)
);

CREATE TABLE students_groups(
	group_id INT NOT NULL,
    student_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY(group_id) REFERENCES `group`(group_id),
    CONSTRAINT FOREIGN KEY(student_id) REFERENCES students(student_id),
    PRIMARY KEY(group_id,student_id)
);
