Set @e_id = '1809 ' ;

SELECT 
    COUNT(booking_id)
FROM
    booking
WHERE
    e_id = @e_id
GROUP BY e_id