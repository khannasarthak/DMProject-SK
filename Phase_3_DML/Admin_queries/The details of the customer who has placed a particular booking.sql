set @booking_id = '10';
SELECT 
    *
FROM
    customer
HAVING customer_id IN (SELECT 
        booking.customer_id
    FROM
        booking
    WHERE
        booking_id = @booking_id)
