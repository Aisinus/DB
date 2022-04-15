 
create function retrievecustomers(start_num int, end_num int)
returns SETOF customer
language plpgsql
as $$
begin
	if start_num < 0 or end_num < 0 then
		raise exception 'input values cannot be negative';
	end if;
	if start_num > end_num then
		raise exception 'start cannot be greater than end';
	end if;
	if end_num > 600 then
		raise exception 'end cannot be greater than 600';
	end if;
	return query select * from customer where start_num <= customer_id and customer_id < end_num;
end;
$$

select * from retrievecustomers(10, 60);
