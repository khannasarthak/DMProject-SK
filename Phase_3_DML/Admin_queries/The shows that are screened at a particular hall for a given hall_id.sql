set @reservation.hall_id = '319';

SELECT
    shows.show_name
FROM
    shows
WHERE
    shows.show_id IN (SELECT
            eventtable.show_id
        FROM
            eventtable
        HAVING eventtable.show_id IN (SELECT
                reservation.show_id
            FROM
                reservation
            WHERE
                reservation.hall_id = @reservation.hall_id))
