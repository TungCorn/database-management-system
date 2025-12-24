--1

begin tran
set transaction isolation level read uncommitted
select * from KHO
commit tran

--2

begin tran
set transaction isolation level read committed
update KHO set Stock = Stock + 100 where IDSanPham = 2
commit tran

--3

begin tran
set transaction isolation level serializable
insert into KHO values (5 , N'iPhone 17', 2000)
commit tran

select * from SanPham

--4

begin tran
set transaction isolation level serializable
update NganHang set SoDu = SoDu - 100 where IDTaiKhoan = 1
update NganHang set SoDu = SoDu + 100 where IDTaiKhoan = 2
commit tran
