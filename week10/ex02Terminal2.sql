postgres=# begin transaction isolation level read uncommitted;
BEGIN
postgres=*# show transaction_isolation; 
 transaction_isolation 
-----------------------
 read uncommitted
(1 строка)

postgres=*# update account set fullname = 'ajones' where fullname = 'Alice Jones';
UPDATE 1
postgres=*# select * from account;
 username |     fullname     | balance | group_id 
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 jones    | ajones           |      82 |        1
(5 строк)

postgres=*# commit;
COMMIT
postgres=# begin transaction isolation level read uncommitted;
BEGIN
postgres=*# end;
COMMIT
postgres=# select * from account;
 username |     fullname     | balance | group_id 
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 jones    | ajones           |      82 |        1
(5 строк)

postgres=# begin transaction isolation level read uncommitted;
BEGIN
postgres=*# update account set balance = balance + 20 where fullname = 'ajones';
UPDATE 1
postgres=*# select * from account;
 username |     fullname     | balance | group_id 
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 jones    | ajones           |     112 |        1
(5 строк)

postgres=*# rollback;
ROLLBACK
postgres=# select * from account;
 username |     fullname     | balance | group_id 
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 jones    | ajones           |      92 |        1
(5 строк)

postgres=# 

