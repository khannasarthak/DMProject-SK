SET @show_id='1';
SET @time_event = "21:00:00";
set @date_event = "2017-04-03";
set @ticket_price = "12";
insert into eventtable(show_id,time_event,date_event,ticket_price) 
values(@show_id,@time_event,@date_event,@ticket_price);
