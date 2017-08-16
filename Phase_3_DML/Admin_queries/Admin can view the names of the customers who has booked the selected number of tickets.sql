SET @maz_tickets = '2';

SELECT 
    customer_name
FROM
    (SELECT 
        customer_id, COUNT(booking.num_tickets)
    FROM
        booking
    GROUP BY booking.customer_id
    HAVING COUNT(booking.num_tickets) = @maz_tickets) AS s,
    customer
WHERE
    s.customer_id = customer.customer_id