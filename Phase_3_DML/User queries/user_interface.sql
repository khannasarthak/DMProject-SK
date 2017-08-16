select distinct show_name from shows;/*step1*/

/*step2*/
SET @show_name = '%Lynnside%';
SELECT 
    date_event
FROM
    eventtable w
WHERE
    show_id IN (SELECT 
            show_id
        FROM
            shows
        WHERE
            show_name LIKE @show_name);
/*step3*/

SET @chosenDate='2017-12-05';
SELECT 
    s.show_name, e.time_event, e.date_event, e.ticket_price
FROM
    eventtable e
        JOIN
    shows s ON e.show_id = s.show_id
WHERE
    s.show_id IN (SELECT 
            show_id
        FROM
            shows
        WHERE
            show_name LIKE @show_name)
        AND e.date_event = @chosenDate;


