-- TODO: find out how to check for existance of a table before 
-- dropping it
DROP TABLE a2departments CASCADE CONSTRAINTS;
DROP TABLE a2term CASCADE CONSTRAINTS;
DROP TABLE a2employees CASCADE CONSTRAINTS;
DROP TABLE a2countries CASCADE CONSTRAINTS;
DROP TABLE a2courses CASCADE CONSTRAINTS;
DROP TABLE a2programs CASCADE CONSTRAINTS;
DROP TABLE a2students CASCADE CONSTRAINTS;
DROP TABLE a2jnc_students_courses CASCADE CONSTRAINTS;
DROP TABLE a2jnc_prog_courses CASCADE CONSTRAINTS;
DROP TABLE a2jnc_prog_students CASCADE CONSTRAINTS;
DROP TABLE a2advisors CASCADE CONSTRAINTS;
DROP TABLE a2professors CASCADE CONSTRAINTS;
DROP TABLE a2sections CASCADE CONSTRAINTS;


-- NOTE: Display order is a column to be used as a ordering
-- precendence column

Prompt **************************************************
Prompt Table creations
Prompt **************************************************

Prompt Creating Departments Table

CREATE TABLE a2departments (

    deptCode        NUMBER(3, 0)    GENERATED AS IDENTITY(START WITH 1) CONSTRAINT a2departments_deptCode_pk PRIMARY KEY,
    deptName        VARCHAR2(45)    CONSTRAINT a2departments_deptName_req NOT NULL,
    officeNumber    NUMBER(4, 0),
    displayOrder    NUMBER(1, 0)
    
);

Prompt Creating Terms Table

CREATE TABLE a2term (

    termCode    NUMBER(5, 0)       GENERATED AS IDENTITY CONSTRAINT a2term_termCode_pk PRIMARY KEY,
    termName    VARCHAR2(11)    CONSTRAINT a2term_termName_req NOT NULL,
    startDate   DATE            CONSTRAINT a2term_startDate_req NOT NULL,
    endDate     DATE            CONSTRAINT a2term_endDate_req NOT NULL
    
);

Prompt Creating Employees Table

CREATE TABLE a2employees (

    empID       NUMBER(5, 0) GENERATED AS IDENTITY CONSTRAINT emp_ID_pk PRIMARY KEY,
    firstName   VARCHAR2(25),
    lastName    VARCHAR2(25) CONSTRAINT a2employees_lastName_req NOT NULL,
    prefix      VARCHAR2(5),
    suffix      VARCHAR2(5),
    isActive    NUMBER(1, 0) DEFAULT 1 CONSTRAINT a2employees_isActive_req NOT NULL,
    sin         NUMBER(9, 0) CONSTRAINT a2employees_sin_req NOT NULL,
    dob         DATE         CONSTRAINT a2employees_dob_req NOT NULL,
    email       VARCHAR2(35) CONSTRAINT a2employees_email_req NOT NULL,
    phone       VARCHAR2(18),
        
        CONSTRAINT a2employees_sin_unq UNIQUE(sin),
        CONSTRAINT a2employees_email_unq UNIQUE(email),
        CONSTRAINT a2employees_phone_unq UNIQUE(phone)

);


Prompt Creating Advisors Table

CREATE TABLE a2advisors (

    empID       NUMBER(5, 0) CONSTRAINT a2advisors_empID_req NOT NULL,
    isActive    NUMBER(1, 0) DEFAULT 1,

        CONSTRAINT a2advisors_empID_pk PRIMARY KEY(empID),
        CONSTRAINT a2advisors_isActive_chk CHECK(isActive IN(1, 0)),  
        CONSTRAINT a2advisors_empID_fk FOREIGN KEY(empID)
            REFERENCES a2employees(empID)

);


Prompt Creating Countries Table

CREATE TABLE a2countries (

    countryCode CHAR(2),
    countryName VARCHAR2(56)    CONSTRAINT a2countries_countryName_req NOT NULL,
    continent   CHAR(2)         CONSTRAINT a2countries_continentID_req NOT NULL,
    isActive    NUMBER(1, 0)    DEFAULT 1 CONSTRAINT a2countries_isActive_req NOT NULL,
        
        CONSTRAINT a2countries_countryCode_pk PRIMARY KEY(countryCode),
        CONSTRAINT a2countries_countryName_unq UNIQUE(countryName),
        CONSTRAINT a2countries_isActive_chk CHECK(isActive IN(1, 0))
            
);

Prompt Creating Courses Table

CREATE TABLE a2courses (

    courseCode  VARCHAR2(8),
    courseName  VARCHAR2(50)     CONSTRAINT a2courses_courseName_req NOT NULL,
    isAvailable NUMBER(1, 0)    DEFAULT 1 CONSTRAINT a2courses_isAvailable_req NOT NULL,
    description VARCHAR2(38),
    
        CONSTRAINT a2courses_courseCode_pk PRIMARY KEY(courseCode),
        CONSTRAINT a2courses_isAvailable_chk CHECK(isAvailable IN(1, 0))
    
);

Prompt Creating Programs Table

CREATE TABLE a2programs (

    progCode    CHAR(3),
    progName    VARCHAR2(30)     CONSTRAINT a2programs_progName_req NOT NULL,
    lengthYears NUMBER(1, 0)    CONSTRAINT a2programs_lengthYears_req NOT NULL,
    isCurrent   NUMBER(1, 0)    DEFAULT 1 CONSTRAINT a2programs_isCurrent_req NOT NULL,
    deptCode    NUMBER(4)       CONSTRAINT a2programs_depCode_req NOT NULL,
    
        CONSTRAINT a2programs_progCode_pk PRIMARY KEY(progCode),
        CONSTRAINT a2programs_deptCode_fk FOREIGN KEY(deptCode)
            REFERENCES a2departments(deptCode),
        CONSTRAINT a2programs_isCurrent_chk CHECK(isCurrent IN (0, 1)),
        CONSTRAINT a2programs_lengthYears_chk CHECK(lengthYears > 0)
);

Prompt Creating Students Table

CREATE TABLE a2students (

    studentID   NUMBER(5, 0)    GENERATED AS IDENTITY CONSTRAINT a2students_studentID_pk PRIMARY KEY,
    firstName   VARCHAR2(20)     CONSTRAINT a2students_firstName_req NOT NULL,
    lastName    VARCHAR2(25)     CONSTRAINT a2students_lastName_req NOT NULL,
    dob         DATE            CONSTRAINT a2students_dob_req NOT NULL,
    gender      CHAR(1),
    email       VARCHAR2(25)     CONSTRAINT a2students_email_req NOT NULL,
    homeCountry CHAR(2),
    phone       VARCHAR2(14),
    advisorID   NUMBER(5, 0),
    
        CONSTRAINT a2students_homeCountry_fk FOREIGN KEY(homeCountry)
            REFERENCES a2countries(countryCode),
        CONSTRAINT a2students_advisorID_fk FOREIGN KEY(advisorID)
            REFERENCES a2advisors(empID)
            
);

-- constraint names for this table were a little too long...
-- I was forced to shorten the identifiers

-- for ex:
-- instead of: a2jnc_students_courses_isActive_req
-- it was changed to: a2stud_courses_isActive_req

Prompt Creating Student_Courses Table

CREATE TABLE a2jnc_students_courses (

    courseCode      VARCHAR2(8),
    studentID       NUMBER(5, 0),
    isActive        NUMBER(1, 0) DEFAULT 1 CONSTRAINT a2stud_courses_isActive_req NOT NULL,

        CONSTRAINT a2stud_courses_pk PRIMARY KEY(courseCode, studentID),
        CONSTRAINT a2stud_courses_isActive_chk CHECK(IsActive IN(1, 0)),
        CONSTRAINT a2stud_courses_courseCode_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode),
        CONSTRAINT a2stud_courses_studentID_fk FOREIGN KEY(studentID)
            REFERENCES a2students(studentID)

);

Prompt Creating Prog_Courses Table

CREATE TABLE a2jnc_prog_courses (

    progCourseID    NUMBER(5, 0) GENERATED AS IDENTITY CONSTRAINT a2prog_courses_progCourseID_pk PRIMARY KEY,
    progCode        CHAR(3) CONSTRAINT a2prog_courses_progCode_req NOT NULL,
    courseCode      VARCHAR2(8),
    isActive        NUMBER(1, 0) DEFAULT 1 CONSTRAINT a2prog_courses_isActive_req NOT NULL,

        CONSTRAINT a2prog_courses_progCode_fk FOREIGN KEY(progCode)
            REFERENCES a2programs(progCode),
        CONSTRAINT a2prog_courses_courseCode_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode)

);


Prompt Creating Prog_Students Table

CREATE TABLE a2jnc_prog_students (

    progCode        CHAR(3),
    studentID       NUMBER(5, 0),
    isActive        NUMBER(1, 0) DEFAULT 1,

        CONSTRAINT a2prog_students_pk PRIMARY KEY(progCode, studentID),
        CONSTRAINT a2prog_students_isActive_chk CHECK(IsActive IN(1, 0)),      
        CONSTRAINT a2prog_students_progCode_fk FOREIGN KEY(progCode)
            REFERENCES a2programs(progCode),
        CONSTRAINT a2prog_students_studentID_fk FOREIGN KEY(studentID)
            REFERENCES a2students(studentID)
);


Prompt Creating Professors Table

CREATE TABLE a2professors (

    empID       NUMBER(5, 0),
    deptCode    NUMBER(3, 0),
    isActive    NUMBER(1, 0) DEFAULT 1,
    
        CONSTRAINT a2professors_isActive_chk CHECK(isActive IN(1, 0)),
        CONSTRAINT a2professors_empID_pk PRIMARY KEY(empID),
        CONSTRAINT a2professors_empID_fk FOREIGN KEY(empID)
            REFERENCES a2employees(empID),
        CONSTRAINT a2professors_deptCode_fk FOREIGN KEY(deptCode)
            REFERENCES a2departments(deptCode)
            
);


Prompt Creating Sections Table

CREATE TABLE a2sections (

    sectionID       NUMBER(4, 0),
    sectionLetter   CHAR(1),
    courseCode      VARCHAR2(8),
    termCode        NUMBER(5, 0),
    profID          NUMBER(5, 0),
    
        CONSTRAINT a2sections_sectionID_pk PRIMARY KEY(sectionID),
        CONSTRAINT a2sections_courseCode_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode),
        CONSTRAINT a2sections_termCode_fk FOREIGN KEY(termCode)
            REFERENCES a2term(termCode),
        CONSTRAINT a2sections_profID_fk FOREIGN KEY(profID)
            REFERENCES a2professors(empID)
);

-- TODO: add descriptions for each course
Prompt Semester 1 courses(CPD and CPA)

INSERT INTO a2courses VALUES (
	'IPC144', 'Introduction to Programming Using C', 1, NULL
);

INSERT INTO a2courses VALUES (
	'APC100', 'Applied Professional Communications', 0, NULL
);

INSERT INTO a2courses VALUES (
	'COM101', 'Communicating Across Contexts', 1, NULL
);

INSERT INTO a2courses VALUES (
	'CPR101', 'Computer Principles for Programmers', 1, NULL
);

INSERT INTO a2courses VALUES (
	'ULI101', 'Introduction to UNIX/Linux and the Internet', 1, NULL
);


Prompt Semester 2 courses(CPD and CPA)

INSERT INTO a2courses VALUES (
	'DBS201', 'Introduction to Database Design and SQL', 1, NULL
);

INSERT INTO a2courses VALUES (
	'DCF255', 'Data Communications Fundamentals', 1, NULL
);

INSERT INTO a2courses VALUES (
	'OOP244', 'Introduction to Object Oriented Programming', 1, NULL
);

INSERT INTO a2courses VALUES (
	'WEB222', 'Web Programming Principles', 1, NULL
);


Prompt Semester 3 courses(CPD and CPA)

INSERT INTO a2courses VALUES (
	'DBS301', 'Database Design || and SQL Using Oracle', 1, NULL
);

INSERT INTO a2courses VALUES (
	'OOP345', 'Object-Oriented Software Development Using C++', 1, NULL
);

INSERT INTO a2courses VALUES (
	'SYS366', 'Requirements Gathering Using OO Models', 1, NULL
);

INSERT INTO a2courses VALUES (
	'WEB322', 'Web Programming Tools and Framework' , 1, NULL
);

-- TODO: add the rest of the CPA program
Prompt Semester 4 Courses(CPD and CPA)

INSERT INTO a2courses VALUES (
	'BCI433', 'IBM Business Computing', 1, NULL
);

INSERT INTO a2courses VALUES (
	'EAC397', 'Business Report Writing', 1, NULL
);

INSERT INTO a2courses VALUES (
	'EAC594', 'Business Communication for the Digital Workplace', 1, NULL
);

INSERT INTO a2courses VALUES (
	'JAC444', 'Introduction to Java for C++ Programmers', 1, NULL
);

Prompt Semester 4 professional option(CPD)

INSERT INTO a2courses VALUES (
	'UNX511', 'UNIX Systems Programming', 1, NULL
);


Prompt Employees insertions

INSERT INTO a2employees VALUES (
	DEFAULT, 'Clint', 'MacDonald', NULL, NULL, 1, 123456789, 
		to_date('1999-03-10', 'yyyy-mm-dd'), 
		'clint.macdonald@senecacollege.ca', '416.491.5050e24158'
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'Ron', 'Tarr', NULL, NULL, 1, 444555666, 
		to_date('1990-09-20', 'yyyy-mm-dd'),
		'ron.tarr@senecacollege.ca', '416.491.5050e24026'
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'Robert' , 'Stewart', NULL, NULL, 1, 111222333,
		to_date('1986-04-29', 'yyyy-mm-dd'), 
		'rob.stewart@senecacollege.ca', '416.491.5050e22752'
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'Nathan', 'Misener', NULL, NULL, 1, 67890123, 
		to_date('1990-07-12', 'yyyy-mm-dd'),
		'nathan.misener@senecacollege.ca', NULL
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'Asam', 'Gulaid', NULL, NULL, 1, 098765432,
		to_date('1867-07-01', 'yyyy-mm-dd'),
		'asam.gulaid1@senecacollege.ca', '647.470.6438'
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'Stanley', 'Ukah', NULL, NULL, 1, 999888777,
		to_date('1979-08-15', 'yyyy-mm-dd'),
		'stanley.ukah1@senecacollege.ca', '416.491.5050e33212'
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'Kadeem', 'Best', NULL, NULL, 1, 555666777,
		to_date('1985-04-12', 'yyyy-mm-dd'),
		'kadeem.best@senecacollege.ca', NULL
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'James', 'Mwangi', NULL, NULL, 1, 111111111,
		to_date('1970-03-18', 'yyyy-mm-dd'),
		'james.mwangi@senecacollege.ca', '416.491.5050e22553'
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'Marc', 'Menard', NULL, NULL, 1, 222222222,
		to_date('1965-07-13', 'yyyy-mm-dd'), 
		'marc.menard@senecacollege.ca', '416.491.5050e26929'
);

Prompt Departments insertions

INSERT INTO a2departments VALUES (
	DEFAULT, 'School of info and Comm Tech-SY', NULL, NULL
);

INSERT INTO a2departments VALUES (
	DEFAULT, 'School of Software Design and Data Science', NULL, NULL
);

INSERT INTO a2departments VALUES (
	DEFAULT, 'School of English and Liberal Studies', NULL, NULL
);


Prompt Professor insertions

-- Clint
INSERT INTO a2professors VALUES (
	1, 1, 1
);

-- Ron
INSERT INTO a2professors VALUES (
	2, 1, 1
);

-- Robert
INSERT INTO a2professors VALUES (
	3, 1, 1
);

-- Nathan
INSERT INTO a2professors VALUES (
	4, 1, 1
);

-- Asam
INSERT INTO a2professors VALUES (
	5, 1, 1
);

-- Stanley
INSERT INTO a2professors VALUES (
	6, 1, 1
);

-- Kadeem
INSERT INTO a2professors VALUES (
	7, 2, 1
);

-- James
INSERT INTO a2professors VALUES (
	8, 1, 1
);

-- Marc
INSERT INTO a2professors VALUES (
	9, 3, 1
);


