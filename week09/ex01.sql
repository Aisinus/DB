create or replace function get_address_with_11()
returns table (
	address_id int,
	city varchar(50),
	address varchar(50),
	country varchar(50)
)
language plpgsql
as $$
begin
	return query
	select s.address_id, s.city, s.address, country.country from country
	inner join (select city.country_id, q.address_id, city.city, q.address from city
	inner join (select address.address_id, address.city_id, address.address
	from address
	where address.address ~ '11' and 400 <= address.city_id and address.city_id <= 600
	) q on q.city_id = city.city_id
	) s on s.country_id = country.country_id
	;
end;
$$

select * from get_address_with_11();

update address set longitude = {}, latitude = {} where address_id = {}