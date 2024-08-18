# Career Track Analysis with SQL and Tableau

## Project Overview

This project involves analyzing student enrollments and completions in data-related career tracks offered by 365 Data Science. The analysis is performed using SQL for data extraction and Tableau for visualization. The goal is to gain insights into student behavior, track popularity, and completion rates to help 365 Data Science improve their educational offerings.

## Project Structure

- **SQL Data Extraction**: Extract necessary data from the provided SQL database.
- **Tableau Visualizations**: Create insightful visualizations to interpret the data.
- **Analysis and Recommendations**: Analyze the results and provide recommendations for improvement.

## Files in the Repository

- `sql_and_tableau.sql`: The SQL file used to create and populate the database.
- `career_track_completions.csv`: The dataset extracted using SQL, which is then used in Tableau.

## SQL Data Extraction

### Database Tables

- **career_track_info**
  - `track_id`: The unique identification of a track.
  - `track_name`: The name of the track.

- **career_track_student_enrollments**
  - `student_id`: The unique identification of a student.
  - `track_id`: The unique identification of a track.
  - `date_enrolled`: The date the student enrolled in the track.
  - `date_completed`: The date the student completed the track (NULL if not completed).

### SQL Query

The following SQL query extracts the required data and prepares it for visualization in Tableau:

```sql
SELECT 
    ROW_NUMBER() OVER (ORDER BY e.student_id, i.track_name DESC) AS student_track_id,
    e.student_id,
    i.track_name,
    e.date_enrolled,
    IF(e.date_completed IS NULL, 0, 1) AS track_completed,
    DATEDIFF(e.date_completed, e.date_enrolled) AS days_for_completion
FROM
    career_track_student_enrollments e
    JOIN
    career_track_info i ON e.track_id = i.track_id;

SELECT 
    a.*,
    CASE
        WHEN days_for_completion = 0 THEN 'Same day'
        WHEN days_for_completion BETWEEN 1 AND 7 THEN '1 to 7 days'
        WHEN days_for_completion BETWEEN 8 AND 30 THEN '8 to 30 days'
        WHEN days_for_completion BETWEEN 31 AND 60 THEN '31 to 60 days'
        WHEN days_for_completion BETWEEN 61 AND 90 THEN '61 to 90 days'
        WHEN days_for_completion BETWEEN 91 AND 365 THEN '91 to 365 days'
        WHEN days_for_completion > 365 THEN '366+ days'
        ELSE NULL
    END AS completion_bucket
FROM
(
    SELECT 
        ROW_NUMBER() OVER (ORDER BY e.student_id, i.track_name DESC) AS student_track_id,
        e.student_id,
        i.track_name,
        e.date_enrolled,
        IF(e.date_completed IS NULL, 0, 1) AS track_completed,
        DATEDIFF(e.date_completed, e.date_enrolled) AS days_for_completion
    FROM
        career_track_student_enrollments e
        JOIN
        career_track_info i ON e.track_id = i.track_id
) a;
```

### Export to CSV

The result of the above query is exported as `career_track_completions.csv`.

## Tableau Visualizations

### Combo Chart

- **Bar Chart**: Represents the number of track enrollments per month.
- **Line Chart**: Displays the fraction of track completions per month as a percentage of enrollments.

### Steps to Create Combo Chart in Tableau

1. **Connect to Data Source**: Import `career_track_completions.csv` into Tableau.
2. **Create Bar Chart**: Drag `Date Enrolled` to Columns (set to MONTH), drag `student_track_id` to Rows (set to COUNT).
3. **Create Line Chart**: Drag `track_completed` to Rows next to `student_track_id` and change to Line Chart.
4. **Dual Axis**: Right-click the axis and select Dual Axis.
5. **Format Line Chart Axis**: Set to Percentage.
6. **Filter by Career Track**: Drag `track_name` to Filters and show filter.

### Completion Bucket Bar Chart

- Each bar represents a different completion bucket with their height corresponding to the number of track completions.

### Steps to Create Completion Bucket Bar Chart in Tableau

1. **Create Bar Chart**: Drag `completion_bucket` to Columns and `student_track_id` to Rows (set to COUNT).
2. **Remove NULL Values**: Ensure the NULL values are removed.
3. **Order Bars**: Same day, 1 to 7 days, 8 to 30 days, 31 to 60 days, 61 to 90 days, 91 to 365 days, 366+ days.
4. **Filter by Career Track**: Drag `track_name` to Filters and show filter.

![image](https://github.com/user-attachments/assets/e038feab-f7a6-4390-a7d1-c12074539e1b)
![image](https://github.com/user-attachments/assets/bd9d16d6-ddd5-4f11-9d6d-2eb6a4c2b531)
![image](https://github.com/user-attachments/assets/3eeac4eb-0406-44aa-87ab-e6c00361de51)

## Conclusion

This project provides valuable insights into student enrollments and completions in data-related career tracks. By analyzing these patterns, we can help 365 Data Science improve their offerings and better support their students.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.

<kbd>Enjoy Code</kbd> 👨‍💻
[My portfolio](https://ayoub-etoullali.netlify.app/)
