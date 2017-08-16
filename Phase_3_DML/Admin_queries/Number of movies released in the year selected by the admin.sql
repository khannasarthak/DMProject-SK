set @release_date = '2000';

SELECT 
    release_date, COUNT(shows.show_id) AS Total_movie
FROM
    shows
        JOIN
    movie ON movie.show_id = shows.show_id
WHERE
    release_date = @release_date
GROUP BY release_date
