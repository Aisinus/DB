create table if not exists accounts (
   acc_id serial PRIMARY KEY,
   acc_name varchar(25),
   credit int,
   currency varchar(10)
);

insert into accounts(acc_name, credit, currency) values 
('Ivan', 1000, 'Rub'),
('Danil', 1000, 'Rub'),
('Vova', 1000, 'Rub');


create table if not exists ledger (
  transaction_id serial PRIMARY KEY,
  from_acc_id int,
  to_acc_id int,
  fee int,
  amount int,
  transaction_date_time date
);



alter table accounts add column bank_name varchar(25) default 'SberBank';
UPDATE accounts SET bank_name = 'Fee' WHERE acc_id = 4;
INSERT INTO accounts(acc_name, credit, currency) VALUES ('fees', 0, 'rub')


create or replace procedure credit_transfer(id1 int, id2 int, credit_summ int)
language plpgsql
as $$
declare 
fees int :=30;
begin

	if(select bank_name from accounts where acc_id = id1) = (select bank_name from accounts where acc_id = id2) then
		fees := 0;
	end if;

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
 	set credit = credit - credit_summ - fees
 	where acc_id = id1;
	

 	update accounts 
 	set credit = credit + credit_summ
 	where acc_id = id2;
		
 	if( (select credit from accounts where acc_id = id1)<0) then
		rollback;
		return;
	end if;

	update accounts
	set credit = credit+fees
	where acc_id=4;

	insert into ledger(from_acc_id, to_acc_id, fee, amount, transaction_date_time) values 
    (id1, id2, fee, credit_summ, current_timestamp);

end;
$$

select * from accounts;
begin;
savepoint save1;
call credit_transfer(1, 3, 500);
savepoint save2;
call credit_transfer(2, 1, 700);
savepoint save3;
call credit_transfer(2, 3, 100);

select * from ledger;

rollback to savepoint save1;
end;