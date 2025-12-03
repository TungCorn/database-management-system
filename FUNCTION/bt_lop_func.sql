-- do tuoi tb sinh vien
create function tuoi_tb_sv()
    returns float
as
begin
    declare @tuoitb float;

    select @tuoitb = avg(Nssv)
    from SINHVIEN
    return @tuoitb
end

select dbo.tuoi_tb_sv() as TuoiTBSinhVien

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

create function ds_mon_thi_sv (@Masv nvarchar(50))
    returns table
as
return
(
    select ds.Mamh, ds.DiemCaoNhat
    from SINHVIEN sv
    join dbo.ds_diem_cao_nhat_sv () as ds on ds_diem_cao_nhat_sv.Masv = sv.Masv
    where sv.Masv = @Masv and ds.DiemCaoNhat > avg(ds.DiemCaoNhat)
)

select * from dbo.ds_mon_thi_sv('SV001')