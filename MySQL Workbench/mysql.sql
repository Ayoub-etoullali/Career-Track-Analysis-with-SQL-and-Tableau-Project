SELECT 
    ROW_NUMBER() OVER (PARTITION BY student_id ORDER BY student_id DESC, track_name DESC) AS student_track_id,
    student_id,
    track_name,
    date_enrolled,
    date_completed,
    CASE
        WHEN date_completed IS NULL THEN 0
        ELSE 1
    END AS track_completed,
    # IF(date_completed IS NULL, 0, 1) AS track_completed,
    CASE 
        WHEN date_completed IS NOT NULL THEN DATEDIFF(date_completed, date_enrolled)
        ELSE NULL
    END AS days_for_completion
    # IF(date_completed IS NOT NULL, DATEDIFF(date_completed, date_enrolled), NULL) AS days_for_completion
FROM
    career_track_student_enrollments e
        JOIN
    career_track_info i ON e.track_id = i.track_id;