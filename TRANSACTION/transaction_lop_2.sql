create table test (
    id int primary key,
    name nvarchar(50)
);
insert into test values (1, 'a'), (2, 'b'), (3, 'c');

begin tran
update test set name = 'x' where id = 3
waitfor delay '00:00:10'
rollback tran


--
begin tran
set transaction isolation level read committed
select * from test
waitfor delay '00:00:10'
select * from test
commit tran

--

begin tran
set transaction isolation level repeatable read
select * from test
waitfor delay '00:00:10'
select * from test
commit tran

--

BEGIN TRAN
set transaction isolation level serializable
SELECT * FROM test
Waitfor delay '00:00:10'
SELECT * FROM test
Commit tran


