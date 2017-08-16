set @e_id = event_id;
set @customer_id = "1";  //change
set @num_tickets = "10";
set @price = "500.00";
set @booking_date = "2017-08-08";
set @booking_time = "03:05:00";
insert into booking(e_id,customer_id,num_tickets,price,booking_date,booking_time) values(@e_id,@customer_id,@num_tickets,@price,@booking_date,@booking_time)
