/* нужно дописать создание таблица rollback и тд */



create or replace procedure credit_transfer(id1 int, id2 int, credit_summ int)
language plpgsql
as $$
begin
	
	if not exists (select * from accounts where acc_id = id1) then
		rollback;
		return;
 	end if;
 
 	if not exists (select * from accounts where acc_id = id2) then
		rollback;
		return;
 	end if;	
 
 	if (credit_summ<0) then 
 		rollback;
 		return;
 	end if;

	update accounts 
 	set credit = credit - credit_summ
 	where acc_id = id1;
 

 	update accounts 
 	set credit = credit + credit_summ
 	where acc_id = id2;
		
 	if( (select credit from accounts where acc_id = id1)<0) then
		rollback;
		return;
	end if;

commit;
end;
$$

update accounts set credit=1000 where acc_id =2;
select * from accounts;
call credit_transfer(1,2,500); 