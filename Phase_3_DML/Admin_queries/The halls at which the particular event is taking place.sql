set @e_id = '1';
SELECT 
    hall.name_hall
FROM
    hall
WHERE
    hall.hall_id IN (SELECT 
            reservation.hall_id
        FROM
            reservation
        WHERE
            reservation.show_id IN (SELECT 
                    show_id
                FROM
                    eventtable
                WHERE
                    e_id = @e_id))
