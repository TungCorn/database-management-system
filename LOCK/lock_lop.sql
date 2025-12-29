--LOCK
begin tran
select Tensv from SINHVIEN
with (holdlock) where Masv = 'SV002'

commit tran


-- XLOCK
    --t1 chuyen 20 dong tu tk1 sang tk2
BEGIN tran
set transaction isolation level serializable
select * from NganHang with (updlock ) where IDTaiKhoan = 2
update NganHang set SoDu = SoDu - 20
where IDTaiKhoan = 1
waitfor delay '00:00:10'
update NganHang set SoDu = SoDu + 20
where IDTaiKhoan = 2
commit tran


create proc proc_chuyentien
@tknguon int,
@tkdich int,
@sotien real
as
begin
    begin tran
    set transaction isolation level read committed
    select * from NganHang with ( updlock ) where IDTaiKhoan = @tkdich
    update NganHang set SoDu = SoDu - @sotien
    where IDTaiKhoan = @tknguon
    waitfor delay '00:00:10'
    update NganHang set SoDu = SoDu + @sotien
    where IDTaiKhoan = @tkdich
    commit tran
end

exec proc_chuyentien 1,2,50
exec proc_chuyentien 2,1,30
