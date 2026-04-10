# University Academic Intelligence & Institutional Analytics
## Executive Summary
  This project presents an end-to-end Institutional Analytics System developed to transform fragmented academic data into strategic intelligence. By utilizing advanced MySQL techniques, the system audits student performance, evaluates faculty effectiveness, and identifies operational bottlenecks. The primary goal is to provide university administrators with data-driven evidence to improve retention rates and resource allocation.

  🛠 Tools Used
1. **Language**: SQL (MySQL)
2. **Environment**: MySQL Workbench
3. **Documentation**: Microsoft PowerPoint (Institutional Presentation)

## 💎SQL & Technical Highlights
- The analytical engine is built on MySQL, featuring 18 complex scripts designed for deep-tier data mining. Key technical implementations include:
- **Data Integrity Audits**: Comprehensive null-value handling and cross-table validation.
- **Advanced Logic**: Extensive use of Common Table Expressions (CTEs) and Window Functions (RANK, ROW_NUMBER) for longitudinal tracking.
- **Feature Engineering**: Creation of calculated fields like "Retention Risk Level" and "Engagement Scores."
- **Performance Optimization**: Efficient joins across 6+ relational tables (Students, Courses, Attendance, etc.).

## 🏗️Dataset Architecture
- The project utilizes a multi-dimensional relational dataset (sourced from Kaggle/Internal) structured into the following entities:
- **Core Entities**: Students, Courses, and Faculty.
- **Transactional Data**: Enrollment records, daily Attendance logs, and Grade history.
- **Qualitative Data**: Student feedback and institutional engagement metrics.

## 💡Main Findings
1. **📅The "Friday Effect"**: Absenteeism peaks on Fridays by 20%, significantly impacting lab-based course outcomes.
2. **🚧Gatekeeper Courses**: Identified specific courses in the CS and Physics departments where failure rates exceed 25%.
3. **📉Engagement Correlation**: Data confirms that students who actively provide institutional feedback maintain a 0.3 higher GPA on average than passive students.

## 🔍Top Operational Insights
- **⚠️Early Warning System (EWS)**: Successfully flagged "At-Risk" students through sequential absence detection before mid-term failures occurred.
- **👥Faculty Workload Balancing**: Analysis revealed a direct correlation between high instructor credit loads and a decline in average student grades.
- **🛡️Departmental Efficiency**: Physics and Engineering departments showed the highest need for supplemental tutoring resources based on GPA distribution.

## 📜Code & Analytics Overview
The repository includes modular SQL scripts categorized by:

1. **Data Cleaning**: Scripts to ensure 100% data completeness.
2. **Student Profiling**: GPA trends and life-stage analysis.
3. **Engagement Tracking**: Attendance patterns and compliance audits.
4. **360-Degree Feedback**: Holistic instructor and course evaluations.

## 📊Dashboard Preview
- **Student Success Scorecard**: Real-time tracking of GPA vs. Attendance.
- **Institutional Health**: Department-wise performance and resource distribution.
- **Faculty Performance**: Balanced scorecard of credits taught vs. student satisfaction.

## 🚀Strategic Recommendations
- **Targeted Interventions**: Implement mandatory peer-tutoring for "Gatekeeper" courses identified in the analytics.
- **Schedule Optimization**: Re-evaluate the scheduling of core technical labs on high-absenteeism days (Fridays).
- **Engagement Incentives**: Reward feedback participation to increase the volume of qualitative data for institutional growth.
- **Faculty Support**: Introduce a credit-hour cap for instructors handling high-density introductory courses to maintain grading quality.
