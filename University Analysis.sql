CREATE SCHEMA Project;
USE Project;
SELECT * FROM attendance;
SELECT * FROM courses;
SELECT * FROM enrollments;
SELECT * FROM feedback;
SELECT * FROM grades;
SELECT * FROM students;
SELECT
    SUM(CASE WHEN attendanceID IS NULL THEN 1 ELSE 0 END) AS attendance_nulls,
	SUM(CASE WHEN AttendanceStatus IS NULL THEN 1 ELSE 0 END) AS status_nulls,
	SUM(CASE WHEN CourseID IS NULL THEN 1 ELSE 0 END) AS course_nulls,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS date_nulls,
    SUM(CASE WHEN StudentID IS NULL THEN 1 ELSE 0 END) AS student_nulls
FROM attendance;
SELECT 
    SUM(CASE WHEN CourseID IS NULL THEN 1 ELSE 0 END) AS courseid_nulls,
    SUM(CASE WHEN CourseName IS NULL THEN 1 ELSE 0 END) AS coursename_nulls,
    SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS department_nulls,
    SUM(CASE WHEN Credits IS NULL THEN 1 ELSE 0 END) AS credits_nulls,
    SUM(CASE WHEN Instructor IS NULL THEN 1 ELSE 0 END) AS Instructor_nulls
FROM courses;
SELECT
	SUM(CASE WHEN EnrollmentID IS NULL THEN 1 ELSE 0 END) AS enrollment_nulls,
    SUM(CASE WHEN StudentID IS NULL THEN 1 ELSE 0 END) AS studentid_nulls,
    SUM(CASE WHEN CourseID IS NULL THEN 1 ELSE 0 END) AS courseid_nulls,
    SUM(CASE WHEN Semester IS NULL THEN 1 ELSE 0 END) AS semester_nulls,
    SUM(CASE WHEN Year IS NULL THEN 1 ELSE 0 END) AS year_nulls,
    SUM(CASE WHEN Grade IS NULL THEN 1 ELSE 0 END) AS grade_nulls
FROM enrollments;
SELECT
	SUM(CASE WHEN FeedbackID IS NULL THEN 1 ELSE 0 END) AS feedback_nulls,
    SUM(CASE WHEN StudentID IS NULL THEN 1 ELSE 0 END) AS studentid_nulls,
    SUM(CASE WHEN FeedbackDate IS NULL THEN 1 ELSE 0 END) AS feedbackdate_nulls,
    SUM(CASE WHEN FeedbackText IS NULL THEN 1 ELSE 0 END) AS feedbacktext_nulls
FROM feedback;
SELECT
	SUM(CASE WHEN GradeID IS NULL THEN 1 ELSE 0 END) AS grade_nulls,
    SUM(CASE WHEN Score IS NULL THEN 1 ELSE 0 END) AS score_nulls,
    SUM(CASE WHEN StudentID IS NULL THEN 1 ELSE 0 END) AS studentid_nulls,
    SUM(CASE WHEN CourseID IS NULL THEN 1 ELSE 0 END) AS courseid_nulls,
    SUM(CASE WHEN AssignmentType IS NULL THEN 1 ELSE 0 END) AS assignment_nulls,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS date_nulls
FROM grades;
SELECT
	SUM(CASE WHEN StudentID IS NULL THEN 1 ELSE 0 END) AS studentid_nulls,
    SUM(CASE WHEN FirstName IS NULL THEN 1 ELSE 0 END) AS firstname_nulls,
    SUM(CASE WHEN LastName IS NULL THEN 1 ELSE 0 END) AS lastname_nulls,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS gender_nulls,
    SUM(CASE WHEN DateOfBirth IS NULL THEN 1 ELSE 0 END) AS dob_nulls,
    SUM(CASE WHEN Major IS NULL THEN 1 ELSE 0 END) AS major_nulls,
	SUM(CASE WHEN GPA IS NULL THEN 1 ELSE 0 END) AS gpa_nulls
FROM students;

-- -------------------------------------------------------------------------------------------------
-- SEGMENT 1: ADVANCED STUDENT PROFILING & DEMOGRAPHIC INTELLIGENCE
-- -------------------------------------------------------------------------------------------------

-- Task 1: The "Non-Traditional Student" STEM Performance Benchmark.
-- Analysis: Calculates student age from DateOfBirth to identify if maturity levels in 
-- technical majors (CS, Physics, Math) correlate with higher GPA achievement tiers.
SELECT students.Major,
    CASE 
        WHEN (YEAR(CURDATE()) - YEAR(students.DateOfBirth)) < 22 THEN 'Gen-Z Learner'
        WHEN (YEAR(CURDATE()) - YEAR(students.DateOfBirth)) BETWEEN 22 AND 28 THEN 'Young Professional'
        ELSE 'Experienced Adult'
    END AS Student_Life_Stage,
    COUNT(students.StudentID) AS Total_Headcount,ROUND(AVG(students.GPA), 2) AS Mean_GPA,
    MAX(students.GPA) AS Top_GPA,MIN(students.GPA) AS Floor_GPA
FROM students WHERE students.Major IN ('Computer Science', 'Physics', 'Mathematics') 
GROUP BY students.Major, Student_Life_Stage 
HAVING COUNT(students.StudentID) >= 1
ORDER BY students.Major ASC, Mean_GPA DESC;


-- Task 2: Academic Standing & Retention Risk Mapping for University Counselors.
-- Analysis: A priority-based risk assessment query that filters students by GPA thresholds 
-- and department difficulty to flag individuals requiring immediate academic intervention.
SELECT students.FirstName,students.LastName,students.Major,students.GPA,
    CASE 
        WHEN students.GPA < 2.5 AND students.Major IN ('Physics', 'Mathematics') THEN 'Priority 1: Immediate Intervention'
        WHEN students.GPA < 2.8 AND students.Major = 'Computer Science' THEN 'Priority 2: Academic Warning'
        WHEN students.GPA < 2.0 THEN 'Priority 3: Probation Review'
        ELSE 'Status: Good Standing'
    END AS Retention_Risk_Level
FROM students
ORDER BY FIELD(Retention_Risk_Level, 'Priority 1: Immediate Intervention', 
'Priority 2: Academic Warning', 'Priority 3: Probation Review',
'Status: Good Standing'), students.GPA ASC;


-- Task 3: Gender Distribution & Enrollment Parity Index per Department.
-- Analysis: Uses correlated subqueries to calculate the percentage of gender representation 
-- within each Major, while tracking the count of high achievers (GPA > 3.5) in each demographic.
-- Check unique values in Students table
SELECT DISTINCT Gender FROM students;

-- Check unique values in Grades table
SELECT DISTINCT AssignmentType FROM grades;

select * from  feedback;
-- Task 3: Gender Distribution & Enrollment Parity Index (Male vs. Female)
-- Analysis: Measures departmental diversity by specifically comparing Male and Female 
-- enrollment percentages and tracking high-performing students within these groups.

-- Task 3: Gender Distribution & Enrollment Parity Index 
-- Analysis: Measures departmental diversity by specifically comparing Male and Female 
-- enrollment percentages. This filtered view provides a clear parity index for the PPT.
SELECT students.Major,students.Gender,
    COUNT(students.StudentID) AS Total_Count,
    ROUND((COUNT(students.StudentID) * 100.0 / (
        SELECT COUNT(*) 
        FROM students AS sub 
        WHERE sub.Major = students.Major 
        AND sub.Gender IN ('Male', 'Female'))), 2) AS Representation_Percentage
FROM students
WHERE students.Gender IN ('Male', 'Female')
  AND students.Major NOT REGEXP '[0-9]'
GROUP BY students.Major, students.Gender
ORDER BY students.Major ASC;

-- -------------------------------------------------------------------------------------------------
-- SEGMENT 2: DEPARTMENTAL RESOURCE & INSTRUCTOR WORKLOAD ANALYTICS
-- -------------------------------------------------------------------------------------------------

-- Task 4: Instructor Load vs. Academic Success Correlation Matrix.
-- Analysis: Investigates if instructors handling high credit volumes and large student 
-- counts see a corresponding dip in average student GPA performance.
SELECT courses.Instructor,courses.Department,
    SUM(courses.Credits) AS Total_Credits_Assigned,
    COUNT(DISTINCT enrollments.StudentID) AS Total_Students_Managed,
    ROUND(AVG(students.GPA), 3) AS Average_Student_GPA,
    COUNT(DISTINCT courses.CourseID) AS Distinct_Courses_Taught
FROM courses
INNER JOIN enrollments ON courses.CourseID = enrollments.CourseID
INNER JOIN students ON enrollments.StudentID = students.StudentID
GROUP BY courses.Instructor, courses.Department
HAVING Total_Credits_Assigned >= 1
ORDER BY Total_Credits_Assigned DESC, Average_Student_GPA ASC;


-- Task 5: Departmental Resource Audit for Capacity Planning.
-- Analysis: Calculates the student-to-instructor ratio in each department to identify 
-- personnel bottlenecks and provide data for institutional faculty recruitment.
SELECT 
    courses.Department,
    COUNT(DISTINCT enrollments.StudentID) AS Total_Enrolled_Students,
    COUNT(DISTINCT courses.Instructor) AS Faculty_Count,
    ROUND(COUNT(DISTINCT enrollments.StudentID) / NULLIF(COUNT(DISTINCT courses.Instructor),0), 2)
    AS Student_Instructor_Ratio,
    SUM(courses.Credits) AS Departmental_Credit_Volume
FROM courses
LEFT JOIN enrollments ON courses.CourseID = enrollments.CourseID
GROUP BY courses.Department
ORDER BY Student_Instructor_Ratio DESC;


-- Task 6: Cross-Departmental GPA Variance & Grade Inflation Benchmark.
-- Analysis: Benchmarks each department's average GPA against the university-wide mean 
-- to detect potential grade inflation or overly strict grading policies.
SELECT 
    ROUND(AVG(students.GPA), 2) AS Dept_Avg_GPA,
    (SELECT ROUND(AVG(GPA), 2) FROM students) AS University_Wide_Avg,
    ROUND(AVG(students.GPA) - (SELECT AVG(GPA) FROM students), 2) AS Deviation_Score,
    CASE 
        WHEN AVG(students.GPA) > (SELECT AVG(GPA) FROM students) + 0.2 THEN 'Potential Grade Inflation'
        WHEN AVG(students.GPA) < (SELECT AVG(GPA) FROM students) - 0.2 THEN 'Strict Grading Policy'
        ELSE 'Aligned with Average'
    END AS Grading_Policy_Status
FROM students
GROUP BY Date
ORDER BY Deviation_Score DESC;


-- -------------------------------------------------------------------------------------------------
-- SEGMENT 3: DETAILED GRADE & EVALUATION INTELLIGENCE
-- -------------------------------------------------------------------------------------------------

-- Task 7: Performance Gap Analysis
-- This compares a student's best ever score vs their average score
-- to see if they are inconsistent or steady.

SELECT 
    StudentID,
    ROUND(AVG(Score), 2) AS Continuous_Evaluation_Avg, 
    MAX(Score) AS Peak_Performance_Score,              
    ROUND(MAX(Score) - AVG(Score), 2) AS Performance_Gap 
FROM grades
GROUP BY StudentID
ORDER BY Performance_Gap DESC;


-- Task 8: Identification of Top-Tier "Consistent High-Performers".
-- Analysis: Filters for students who have never scored below 75% in any individual 
-- assessment across their entire academic record using a NOT IN subquery.
SELECT 
    students.StudentID,
    students.FirstName,
    students.Major,
    COUNT(grades.GradeID) AS Total_Assessments_Taken,
    ROUND(AVG(grades.Score), 2) AS Overall_Average_Score
FROM students
JOIN grades ON students.StudentID = grades.StudentID
WHERE students.StudentID NOT IN (
    SELECT grades.StudentID FROM grades WHERE grades.Score < 75
)
GROUP BY students.StudentID, students.FirstName, students.Major
ORDER BY Overall_Average_Score DESC;


-- Task 9: Course Difficulty Index & Student Failure Rate Analysis.
-- Analysis: Ranks all courses by their failure percentage (scores < 60) to provide 
-- the provost with a list of courses that may require curriculum revision.
SELECT 
    courses.CourseName,
    courses.Instructor,
    COUNT(grades.GradeID) AS Total_Grades_Issued,
    SUM(CASE WHEN grades.Score < 60 THEN 1 ELSE 0 END) AS Failures_Count,
    ROUND((SUM(CASE WHEN grades.Score < 60 THEN 1 ELSE 0 END) * 100.0 / COUNT(grades.GradeID)), 2) AS Failure_Percentage
FROM courses
JOIN grades ON courses.CourseID = grades.CourseID
GROUP BY courses.CourseID, courses.CourseName, courses.Instructor
ORDER BY Failure_Percentage DESC;


-- -------------------------------------------------------------------------------------------------
-- SEGMENT 4: ADVANCED PERFORMANCE RANKING (WINDOW FUNCTIONS)
-- -------------------------------------------------------------------------------------------------

-- Task 10: Intradepartmental Topper Ranking (The Dean's List).
-- Analysis: Utilizes DENSE_RANK() to identify the top 3 students in every department 
-- based on GPA, ensuring a fair ranking during score ties.
SELECT * FROM (
    SELECT 
        students.FirstName,
        students.LastName,
        students.Major,
        students.GPA,
        DENSE_RANK() OVER (PARTITION BY students.Major ORDER BY students.GPA DESC) AS Rank_Within_Major
    FROM students
) AS Ranked_Results
WHERE Rank_Within_Major <= 3
ORDER BY Major ASC, Rank_Within_Major ASC;


-- Task 11: Longitudinal Enrollment & Credit Load Trends.
-- Analysis: Aggregates credits delivered per academic year and uses RANK() to determine 
-- which years placed the highest operational load on the university faculty.
SELECT 
    enrollments.Year,
    COUNT(enrollments.EnrollmentID) AS Total_Enrollments,
    SUM(courses.Credits) AS Total_Credits_Delivered,
    RANK() OVER (ORDER BY SUM(courses.Credits) DESC) AS Year_Workload_Rank
FROM enrollments
JOIN courses ON enrollments.CourseID = courses.CourseID
GROUP BY enrollments.Year
ORDER BY Total_Credits_Delivered DESC;


-- Task 12: Individual Academic Momentum Tracking by Percentile.
-- Analysis: Uses PERCENT_RANK() to compare a student's total credits earned against 
-- their department peers to identify those lagging in degree progress.
SELECT 
    students.FirstName,
    students.Major,
    SUM(courses.Credits) AS Earned_Credits,
    ROUND(PERCENT_RANK() OVER (PARTITION BY students.Major ORDER BY SUM(courses.Credits) ASC), 2) AS Credit_Percentile
FROM students
JOIN enrollments ON students.StudentID = enrollments.StudentID
JOIN courses ON enrollments.CourseID = courses.CourseID
GROUP BY students.StudentID, students.FirstName, students.Major
ORDER BY Major, Credit_Percentile DESC;


-- -------------------------------------------------------------------------------------------------
-- SEGMENT 5: ATTENDANCE PERSISTENCE & ENGAGEMENT FORECASTING
-- -------------------------------------------------------------------------------------------------

-- Task 13: Sequential Absence Detection (Engagement Warning System).
-- Analysis: Employs the LAG() window function to identify students whose status changed 
-- from 'Present' to 'Absent' in consecutive sessions, signaling disengagement.
SELECT 
    attendance.StudentID,
    attendance.CourseID,
    attendance.Date,
    attendance.AttendanceStatus AS Current_Status,
    LAG(attendance.AttendanceStatus) OVER (PARTITION BY attendance.StudentID,
    attendance.CourseID ORDER BY attendance.Date) 
    AS Previous_Session_Status
FROM attendance
ORDER BY attendance.StudentID, attendance.Date DESC;


-- Task 14: Peak Absenteeism & Weekly Pattern Analysis.
-- Analysis: Extracts day names from attendance records to identify weekly patterns 
-- of absenteeism, aiding in the optimization of lecture scheduling.
SELECT 
    DAYNAME(attendance.Date) AS Day_Of_Week,
    COUNT(CASE WHEN attendance.AttendanceStatus = 'Absent' THEN 1 END)
    AS Absent_Count,
    COUNT(attendance.AttendanceID) AS Total_Records,
    ROUND(COUNT(CASE WHEN attendance.AttendanceStatus = 'Absent' THEN 1 END) * 100.0 / 
    COUNT(attendance.AttendanceID), 2) AS Absence_Rate
FROM attendance
GROUP BY Day_Of_Week
ORDER BY Absence_Rate DESC;


-- Task 15: Low-Engagement Audit for Mandatory Attendance Compliance.
-- Analysis: Calculates the total attendance percentage for every student per course 
-- and flags those falling below the mandatory 75% institutional threshold.
SELECT 
    students.FirstName,
    courses.CourseName,
    COUNT(attendance.AttendanceID) AS Total_Lectures,
    SUM(CASE WHEN attendance.AttendanceStatus = 'Present' THEN 1 ELSE 0 END) AS Lectures_Attended,
    ROUND(SUM(CASE WHEN attendance.AttendanceStatus = 'Present' THEN 1 ELSE 0 END) * 100.0 /
    COUNT(attendance.AttendanceID), 2) AS Attendance_Percentage
FROM students
JOIN attendance ON students.StudentID = attendance.StudentID
JOIN courses ON attendance.CourseID = courses.CourseID
GROUP BY students.StudentID, students.FirstName, courses.CourseName
HAVING Attendance_Percentage < 75
ORDER BY Attendance_Percentage ASC;


-- -------------------------------------------------------------------------------------------------
-- SEGMENT 6: INSTITUTIONAL FEEDBACK & 360-DEGREE ANALYSIS
-- -------------------------------------------------------------------------------------------------

-- Task 16: Feedback Engagement vs. Academic Success Correlation.
-- Analysis: Utilizes a CTE to classify students based on feedback participation and 
-- investigates if "Engaged Feedback Providers" achieve higher GPAs than "Passive Students".
WITH Feedback_Stats AS (
    SELECT 
        students.StudentID,
        students.GPA,
        CASE WHEN feedback.FeedbackID IS NOT NULL THEN 'Active Feedback User' ELSE 'Passive Student' END AS Engagement_Category
    FROM students
    LEFT JOIN feedback ON students.StudentID = feedback.StudentID
)
SELECT 
    Engagement_Category,
    COUNT(DISTINCT StudentID) AS Total_Students,
    ROUND(AVG(GPA), 2) AS Group_Average_GPA
FROM Feedback_Stats
GROUP BY Engagement_Category;


-- Task 17: Multi-Year Credit Achievement Transcript Summary.
-- Analysis: Provides a longitudinal progress report of credits earned by each student 
-- across different years and semesters, cross-referenced with their final GPA.
WITH Credit_Tracker AS (
    SELECT 
        enrollments.StudentID,enrollments.Year,
        enrollments.Semester,SUM(courses.Credits) AS Semester_Credits
    FROM enrollments
    JOIN courses ON enrollments.CourseID = courses.CourseID
    GROUP BY enrollments.StudentID, enrollments.Year, enrollments.Semester
)
SELECT 
    students.FirstName,students.LastName,Credit_Tracker.Year,
    Credit_Tracker.Semester,Credit_Tracker.Semester_Credits,
    students.GPA AS Final_GPA
FROM students
JOIN Credit_Tracker ON students.StudentID = Credit_Tracker.StudentID
WHERE Credit_Tracker.Semester_Credits > 0
ORDER BY students.LastName, Credit_Tracker.Year DESC;


-- Task 18: Holistic Instructor Performance Scorecard (360-Degree Analysis).
-- Analysis: The final institutional scorecard that joins teaching load (credits), 
-- student grading outcomes (scores), and qualitative student engagement (feedback volume).
SELECT 
    courses.Instructor,
    courses.Department,
    SUM(courses.Credits) AS Total_Credits_Taught,
    ROUND(AVG(grades.Score), 2) AS Average_Grade_Given,
    COUNT(DISTINCT feedback.FeedbackID) AS Total_Feedbacks_Received
FROM courses
LEFT JOIN grades ON courses.CourseID = grades.CourseID
LEFT JOIN enrollments ON courses.CourseID = enrollments.CourseID
LEFT JOIN feedback ON enrollments.StudentID = feedback.StudentID
GROUP BY courses.Instructor, courses.Department
HAVING Total_Credits_Taught > 0
ORDER BY Average_Grade_Given DESC, Total_Feedbacks_Received DESC;
