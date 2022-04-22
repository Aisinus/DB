postgres=# begin transaction isolation level read uncommitted;
BEGIN
postgres=*# show transaction_isolation;
 transaction_isolation 
-----------------------
 read uncommitted
(1 строка)

postgres=*# select * from account;
 username |     fullname     | balance | group_id 
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 jones    | Alice Jones      |      82 |        1
(5 строк)

postgres=*# select * from account;
 username |     fullname     | balance | group_id 
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 jones    | Alice Jones      |      82 |        1
(5 строк)

postgres=*# select * from account;
 username |     fullname     | balance | group_id 
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 jones    | ajones           |      82 |        1
(5 строк)

postgres=*# update account set balance = balance+10 where fullname = 'ajones';
UPDATE 1
postgres=*# commit;
COMMIT
postgres=# select * from account;
 username |     fullname     | balance | group_id 
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 jones    | ajones           |      92 |        1
(5 строк)

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

/* Explonation */