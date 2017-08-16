SET @rating = '%R%';
SELECT 
    shows.show_name
FROM
    shows
WHERE
    shows.show_id IN (SELECT ALL
            movie.show_id
        FROM
            movie
        WHERE
            rating LIKE @rating
        GROUP BY movie.rating)
