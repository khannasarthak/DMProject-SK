SET @performance_type = 'Opera';

SELECT 
    performance.show_id, performers, show_name
FROM
    performance,
    shows
WHERE
    performance_type = @performance_type
        AND shows.show_id = performance.show_id