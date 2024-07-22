use sql_and_tableau;

-- Extracting relevant student enrollment data and bucketing their completion duration
SELECT 
    student_track_id,
    student_id,
    track_name,
    date_enrolled,
    track_completed,
    days_for_completion,
    
    -- Categorize completion duration into predefined buckets
    CASE
        WHEN days_for_completion = 0 THEN 'Same day'
        WHEN days_for_completion BETWEEN 1 AND 7 THEN '1 to 7 days'
        WHEN days_for_completion BETWEEN 8 AND 30 THEN '8 to 30 days'
        WHEN days_for_completion BETWEEN 31 AND 60 THEN '31 to 60 days'
        WHEN days_for_completion BETWEEN 61 AND 90 THEN '61 to 90 days'
        WHEN days_for_completion BETWEEN 91 AND 365 THEN '91 to 365 days'
        WHEN days_for_completion >= 366 THEN '366+ days'
    END AS completion_bucket
FROM
(
-- Subquery to extract and process raw data from related tables
SELECT 
    ROW_NUMBER() OVER (ORDER BY student_id, track_name DESC) AS student_track_id, -- Create unique identification for each student-track pair
    e.student_id,
    i.track_name,
    e.date_enrolled,
    e.date_completed,
    IF(date_completed IS NULL, 0, 1) AS track_completed, -- Determine if the track was completed
    DATEDIFF(e.date_completed, e.date_enrolled) AS days_for_completion -- Calculate the difference between completion and enrollment dates
FROM
    career_track_student_enrollments e
        JOIN -- Joining with career_track_info to get the track names
    career_track_info i ON e.track_id = i.track_id) a;