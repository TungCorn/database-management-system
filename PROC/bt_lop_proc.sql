--viet 1 thu tuc lay ra ds sinh vien bi canh cao hoc tap theo tung lop avg diem < 5

create proc ds_sinhvien_canhcao_hoctap
as
begin
    select ds_sv.Masv, ds_sv.Tensv, ds_sv.Malop, ds_sv.DiemTB
    from LOP l
    join (
        select sv.Masv, sv.Tensv, sv.Malop, avg(maxdiem.DiemCaoNhat) as DiemTB
        from SINHVIEN sv
                 join
             (select d.Masv, d.Mamh, MAX(d.Diem) as DiemCaoNhat
              from DIEMSV d
              group by d.Masv, d.Mamh) as maxdiem on sv.Masv = maxdiem.Masv
        group by sv.Masv, sv.Tensv, sv.Malop
    ) as ds_sv on ds_sv.Malop = l.Malop
--     where ds_sv.DiemTB < 5
end

exec ds_sinhvien_canhcao_hoctap

drop proc if exists ds_sinhvien_canhcao_hoctap

