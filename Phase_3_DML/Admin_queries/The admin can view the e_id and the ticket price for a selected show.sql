SET @show_name = 'Rodriguezshire';

SELECT 
    e_id, ticket_price
FROM
    eventtable
WHERE
    eventtable.show_id = (SELECT 
            shows.show_id
        FROM
            shows
        WHERE
            show_name = @show_name)