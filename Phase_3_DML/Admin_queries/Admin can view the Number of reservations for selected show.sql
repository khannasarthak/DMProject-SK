SET @show_name="%Liumouth%";

SELECT
show_name, COUNT(reservation.show_id) AS num_of_reservations
FROM
shows
JOIN
reservation ON reservation.show_id = shows.show_id
WHERE
show_name like @show_name
GROUP BY reservation.show_id
