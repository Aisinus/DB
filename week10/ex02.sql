/* First termianl */
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


---------------------------------------------------------------------------------------------- 

/* Second terminal */

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

----------------------------------------------------------------------------------------------
/*
1) Terminals show diffrent information because no one transaction are commited 
2) Second terminal are locked after update because first terminal didnt finished the transaction
*/

/* Read commited */

/* First terminal */
postgres=# begin transaction isolation level read committed;
BEGIN
postgres=*# select * from account where group_id=2;
 username |   fullname   | balance | group_id 
----------+--------------+---------+----------
 mike     | Michael Dole |      73 |        2
(1 строка)

postgres=*# select * from account where group_id=2;
 username |   fullname   | balance | group_id 
----------+--------------+---------+----------
 mike     | Michael Dole |      73 |        2
(1 строка)

postgres=*# update account set balance = balance+15 where group_id=2;
UPDATE 1
postgres=*# commit;
COMMIT
postgres=# select * from account;
 username |     fullname     | balance | group_id 
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 alyssa   | Alyssa P. Hacker |      79 |        3
 jones    | ajones           |      92 |        1
 bbrown   | Bob Brown        |     100 |        2
 mike     | Michael Dole     |      88 |        2
(5 строк)

postgres=# 

----------------------------------------------------------------------------------------------

/* Second terminal */
postgres=# begin transaction isolation level read committed;
BEGIN
postgres=*# update account set group_id = 2 where fullname = 'Bob Brown';
UPDATE 1
postgres=*# commit;
COMMIT
postgres=# select * from account;
 username |     fullname     | balance | group_id 
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 alyssa   | Alyssa P. Hacker |      79 |        3
 jones    | ajones           |      92 |        1
 bbrown   | Bob Brown        |     100 |        2
 mike     | Michael Dole     |      88 |        2
(5 строк)

postgres=# 

----------------------------------------------------------------------------------------------

/* Repetable read */

/* First terminal */
postgres=# begin transaction isolation level repeatable read;
BEGIN
postgres=*# select * from account where group_id=2;
 username |   fullname   | balance | group_id 
----------+--------------+---------+----------
 mike     | Michael Dole |      88 |        2
(1 строка)

postgres=*# select * from account where group_id=2;
 username |   fullname   | balance | group_id 
----------+--------------+---------+----------
 mike     | Michael Dole |      88 |        2
(1 строка)

postgres=*# update account set balance = balance+15 where group_id=2;
UPDATE 1
postgres=*# commit;
COMMIT
postgres=# select * from account;
 username |     fullname     | balance | group_id 
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 alyssa   | Alyssa P. Hacker |      79 |        3
 jones    | ajones           |      92 |        1
 bbrown   | Bob Brown        |     100 |        3
 mike     | Michael Dole     |     103 |        2
(5 строк)

postgres=# 

----------------------------------------------------------------------------------------------

/* Second terminal */
postgres=# begin transaction isolation level repeatable read;
BEGIN
postgres=*# update account set group_id = 3 where fullname = 'Bob Brown';
UPDATE 1
postgres=*# commit;
COMMIT
postgres=# select * from account;
 username |     fullname     | balance | group_id 
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 alyssa   | Alyssa P. Hacker |      79 |        3
 jones    | ajones           |      92 |        1
 bbrown   | Bob Brown        |     100 |        3
 mike     | Michael Dole     |     103 |        2
(5 строк)

postgres=# 



/*
1) In read committed isolation level bob moved to group 2 but dobt get +15 to balance
2) In repeatable read isolation level bob didnt moved to group 2
 */