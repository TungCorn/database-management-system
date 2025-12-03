-- viet 1 ham tra ve sl sv thi qua 1 mon hoc
drop function if exists sl_sv_thi_dat

create function sl_sv_thi_dat (@Mamh nvarchar(50))
returns int
as
begin
    declare @sl int;
    select @sl = count(sv.Masv)
    from SINHVIEN sv
    join (
         select d.Masv, d.Mamh, MAX(d.Diem) as DiemCaoNhat
         from DIEMSV d
         group by d.Masv, d.Mamh) as maxdiem on sv.Masv = maxdiem.Masv
    where maxdiem.DiemCaoNhat >= 5 and maxdiem.Mamh = @Mamh
    group by maxdiem.Mamh
    return @sl
end

select dbo.sl_sv_thi_dat('MH001') as SoLuongSVThiDat

select Mamh, dbo.sl_sv_thi_dat(Mamh)
from MONHOC

--ds sl 1 lop bat ki
drop function if exists ds_sv_lop
create function ds_sv_lop (@Malop nvarchar(50))
returns table
as
return
(
    select *
    from SINHVIEN
    where Malop = @Malop
)

select * from dbo.ds_sv_lop('TH1')

 --

create function ds_diem_cao_nhat_sv ()
returns table
as
return
(
    select d.Masv, d.Mamh, MAX(d.Diem) as DiemCaoNhat
    from DIEMSV d
    group by d.Masv, d.Mamh
)

select * from dbo.ds_diem_cao_nhat_sv()

