SET @show_id='100';

SELECT 
    show_name, reservation.r_date, reservation.r_time
FROM
    reservation
        JOIN
    shows ON reservation.show_id = shows.show_id
WHERE
    reservation.show_id = @show_id
