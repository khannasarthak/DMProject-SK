set @cnum=6;

SELECT DISTINCT
    show_name, release_date
FROM
    movie,
    shows
WHERE
    shows.show_id IN (SELECT 
            show_id
        FROM
            eventtable
        GROUP BY show_id
        HAVING COUNT(show_id) > @cnum)
        AND release_date = 2017