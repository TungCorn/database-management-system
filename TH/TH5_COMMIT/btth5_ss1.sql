--`1

begin tran
set transaction isolation level read uncommitted
update KHO set Stock = 0
where IDSanPham = 1
waitfor delay '00:00:10'
rollback tran


--2

begin tran
set transaction isolation level read committed
select sum(Stock) as Tong from KHO
waitfor delay '00:00:10'
select sum(Stock) as Tong from KHO
commit tran

begin tran
set transaction isolation level repeatable read
select sum(Stock) as Tong from KHO
waitfor delay '00:00:10'
select sum(Stock) as Tong from KHO
commit tran


--3

BEGIN TRAN
set transaction isolation level repeatable read
if not exists(
    select 1 from KHO where TenSP = N'iPhone 16'
)
begin
    waitfor delay '00:00:10'
    insert into SanPham(TenSP, MoTa, DonGia) values ( N'iPhone 16', N'Dien thoai moi nhat', 2000)
end
commit tran

BEGIN TRAN
set transaction isolation level serializable
if not exists(
    select 1 from KHO where TenSP = N'iPhone 17'
)
    begin
        waitfor delay '00:00:10'
        insert into KHO values (5 , N'iPhone 17', 2000)
    end
commit tran

--4

begin tran
set transaction isolation level serializable
select * from NganHang
waitfor delay '00:00:10'
select * from NganHang
commit tran




