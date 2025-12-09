create view v1
as
select sv.Hosv, sv.Tensv, mh.Tenmh
from SINHVIEN sv
         join DIEMSV d on sv.Masv = d.Masv
         join MONHOC mh on d.Mamh = mh.Mamh

select *
from v1

drop view if exists v1
--

insert into v1 (Masv, Hosv, Tensv)
values ('SV36', N'NGUYEN', N'ANH TUAN')

--1

create view ds_sv_thi_dat_lan1
as
select sv.Masv, sv.Tensv
from SINHVIEN sv
         join DIEMSV d on sv.Masv = d.Masv
where d.Lan = 1
  and sv.Malop = 'TH1'
group by sv.Masv, sv.Tensv
having min(d.Diem) >= 5

select *
from ds_sv_thi_dat_lan1

create view ds_sv_thi_ko_dat_lan1_exists
as
select sv.Masv, sv.Tensv
from SINHVIEN sv
where sv.Malop = 'TH1'
  and not exists(select *
                 from DIEMSV
                 where sv.Masv = DIEMSV.Masv
                   and Lan = 1
                   and Diem < 5)
  and exists(select *
             from DIEMSV
             where sv.Masv = DIEMSV.Masv
               and Lan = 1)

select *
from ds_sv_thi_ko_dat_lan1_exists

--2

alter view ds_sv_tn (Masv, Tensv, Tuoi, DiemTB)
    as
        select sv.Masv, sv.Tensv, year(getdate()) - sv.Nssv, avg(maxdiem.Diemcaonhat)
        from SINHVIEN sv
                 join (select d.Masv, d.Mamh, max(d.Diem) as Diemcaonhat
                       from DIEMSV d
                       group by d.Masv, d.Mamh
                       having max(d.Diem) >= 5) as maxdiem on sv.Masv = maxdiem.Masv
        where (year(getdate()) - sv.Nssv) <= 25
          and sv.Malop = 'TH1'
        group by sv.Masv, Tensv, sv.Nssv

select *
from ds_sv_tn

--3

CREATE VIEW ds_sv_hb_lvk (Masv, Tensv, Makh, DiemTB)
AS
SELECT Masv, Tensv, Makh, DiemTB
FROM (SELECT sv.Masv,
             sv.Tensv,
             k.Makh,
             AVG(d.Diem) AS DiemTB,
             RANK() OVER (PARTITION BY k.Makh ORDER BY AVG(d.Diem) DESC) AS Hang
      FROM SINHVIEN sv
               JOIN LOP l ON sv.Malop = l.Malop
               JOIN KHOA k ON l.Makh = k.Makh
               JOIN DIEMSV d ON sv.Masv = d.Masv
      WHERE d.Lan = 1
      GROUP BY sv.Masv, sv.Tensv, k.Makh) AS ranked
WHERE Hang <= 2;

select *
from ds_sv_hb_lvk

--

create view v1
as
select *
from SINHVIEN sv

select *
from v1

drop view if exists v1
--

insert into v1 (Masv, Hosv, Tensv)
values ('SV36', N'NGUYEN', N'ANH TUAN')

update v1 set Tensv = 'Ninh beo' where Masv = 'SV006';

update SINHVIEN set Tensv = 'Ninh beo' where Masv = 'SV006';

select * from SINHVIEN



