SELECT 
    customer_name, COUNT(booking.customer_id)
FROM
    booking,
    customer
WHERE
    booking.customer_id = customer.customer_id
GROUP BY booking.customer_id
ORDER BY COUNT(booking.booking_id) DESC
LIMIT 10
