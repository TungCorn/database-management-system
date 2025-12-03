
-- 1. Cho biết danh sách lớp

select * from LOP

-- 2. Cho biết danh sách sinh viên lớp TH1

select * from SINHVIEN
where Malop = 'TH1'

-- 3. Cho biết danh sách SV khoa CNTT

select sv.*, l.Makh 
from SINHVIEN sv
join LOP l
on sv.Malop = l.Malop
where l.Makh = 'CNTT'

-- 4. Cho biết chương trình học của lớp TH1

select *
from CTHOC
where Malop = 'TH1'

-- 5. Điểm lần 1 môn CSDL của SV lớp TH1

select sv.Tensv, d.*
from DIEMSV d
join SINHVIEN sv
on d.Masv = sv.Masv
where sv.Malop = 'TH1' and Lan = 1 and d.Mamh = 'MH001'

-- 6. Điểm trung bình lần 1 môn CTDL của lớp TH1

declare @diemtb float, @tong float, @sosv int

select @tong = sum(d.Diem), @sosv = count(d.Masv)
from DIEMSV d
join SINHVIEN sv
on d.Masv = sv.Masv
where d.Mamh = 'MH001' and sv.Malop = 'TH1'

set @diemtb = @tong / @sosv;

print N'Điểm trung bình lần 1 môn CTDL của lớp TH1 là: ' + cast(@diemtb as varchar(10));

-- 7. Số lượng SV của lớp TH2

declare @soluongsv int;

select @soluongsv = COUNT(sv.Masv)
from SINHVIEN sv
where sv.Malop = 'TH2'

print N'Số lượng SV của lớp TH2: ' + cast(@soluongsv as varchar(10));

-- 8. Lớp TH1 phải học bao nhiêu môn trong HK1 và HK2

select * from CTHOC


declare @soluongmon int;

select @soluongmon = count(ct.Mamh)
from CTHOC ct
where ct.Malop = 'TH1' and ( ct.HK = 'HK1' or ct.HK = 'HK2' )

print N'Lớp TH1 phải học số môn trong HK1 và HK2: ' + cast(@soluongmon as varchar(10));


select ct.*
from CTHOC ct
where ct.Malop = 'TH1' and ( ct.HK = 'HK1' or ct.HK = 'HK2' )
group by HK

-- 9. Cho biết 3 SV đầu tiên có điểm thi lần 1 cao nhất môn CSDL

select top 3 sv.Masv, sv.Tensv, d.Diem, d.Lan, d.Lan
from DIEMSV d
join SINHVIEN sv
on d.Masv = sv.Masv
where d.Lan = 1 and d.Mamh = 'MH001'
order by d.Diem desc

-- 10. Cho biết sĩ số từng lớp

select sv.Malop, COUNT(*) as SY_SO
from SINHVIEN sv
group by sv.Malop

-- 11. Khoa nào đông SV nhất

declare @khoa varchar(50), @sosinhvien int;

select top 1 @khoa = l.Makh, @sosinhvien = COUNT(sv.Masv) 
from SINHVIEN sv
join LOP l
on sv.Malop = l.Malop
group by l.Makh
order by COUNT(sv.Masv) desc

print 'Khoa ' + @khoa + N' đông nhất với sô sinh viên là: ' + cast(@sosinhvien as nvarchar(10));

select l.Makh, COUNT(sv.Masv) as SiSo
from SINHVIEN sv
join LOP l
on sv.Malop = l.Malop
group by l.Makh
order by COUNT(sv.Masv) desc

-- 12. Lớp nào đông nhất khoa CNTT

declare @lopdongnhat varchar(50), @sisolop int;

select top 1 @lopdongnhat = sv.Malop, @sisolop = COUNT(sv.Masv)
from SINHVIEN sv
join LOP l
on sv.Malop = l.Malop
where l.Makh = 'CNTT'
group by sv.Malop
order by COUNT(sv.Masv) desc

print @lopdongnhat + ' ' + cast(@sisolop as varchar(10));

select sv.Malop, COUNT(sv.Masv)
from SINHVIEN sv
join LOP l
on sv.Malop = l.Malop
where l.Makh = 'CNTT'
group by sv.Malop
order by COUNT(sv.Masv) desc


-- 13. Môn học nào mà ở lần thi 1 có số SV không đạt nhiều nhất

select top 1 d.Mamh, COUNT(d.Masv) as SoSVKhongDat
from DIEMSV d
where d.Lan = 1 and d.Diem < 5
group by d.Mamh
order by COUNT(d.Masv) desc

-- 14. Tìm điểm thi lớn nhất của mỗi SV cho mỗi môn học

select d.Masv, d.Mamh, MAX(d.Diem) as DiemCaoNhat
from DIEMSV d
group by d.Masv, d.Mamh
order by d.Masv, d.Mamh

-- 15. Điểm trung bình của từng lớp khoa CNTT ở lần thi thứ nhất môn CSDL

select l.Malop, AVG(D.Diem) as DiemTB
from DIEMSV d
join SINHVIEN sv
on d.Masv = sv.Masv
join LOP l
on sv.Malop = l.Malop
where l.Makh = 'CNTT' and d.Lan = 1 and d.Mamh = 'MH001'
group by l.Malop


-- 16. Sinh viên nào của lớp TH1 đã thi đạt tất cả các môn học ở lần 1 của HK2

declare @somonhocki2 int;

select @somonhocki2 = COUNT(ct.Mamh)
from CTHOC ct
where ct.Malop = 'TH1' and ct.HK = 'HK2'

select sv.Masv, sv.Tensv
from DIEMSV d
join SINHVIEN sv
on d.Masv = sv.Masv
join CTHOC ct
on d.Mamh = ct.Mamh and ct.Malop = sv.Malop
where sv.Malop = 'TH1' and d.Diem >= 5 and d.Lan = 1 and ct.HK = 'HK2'
group by sv.Masv, sv.Tensv
having COUNT(d.Mamh) = @somonhocki2

-- 17. Danh sách SV nhận học bổng học kỳ 2 của lớp TH2

declare @somonhocki2_2 int;

select @somonhocki2_2 = COUNT(ct.Mamh)
from CTHOC ct
where ct.Malop = 'TH1' and ct.HK = 'HK2'

select sv.Masv, sv.Tensv
from DIEMSV d
join SINHVIEN sv
on d.Masv = sv.Masv
join CTHOC ct
on d.Mamh = ct.Mamh and ct.Malop = sv.Malop
where sv.Malop = 'TH2' and d.Diem >= 5 and d.Lan = 1 and ct.HK = 'HK2'
group by sv.Masv, sv.Tensv
having COUNT(d.Mamh) = @somonhocki2_2

-- 18. Cho biết SV lớp TH1 đủ điều kiện thi tốt nghiệp (đã đạt tất cả các môn)

declare @TongSoMonHoc int;

SELECT @TongSoMonHoc = COUNT(Mamh) 
FROM CTHOC 
WHERE Malop = 'TH1';

print @TongSoMonHoc

select sv.Masv, sv.Tensv
from SINHVIEN sv
join(
	select d.Masv, d.Mamh, max(d.Diem) as DiemMax
	from DIEMSV d
	group by d.Masv, d.Mamh
) as dsDiem on sv.Masv = dsDiem.Masv
join CTHOC ct on sv.Malop = ct.Malop and ct.Mamh = dsDiem.Mamh
where sv.Malop = 'TH1' and dsDiem.DiemMax > 5
group by sv.Masv, sv.Tensv
having COUNT(ct.Mamh) = @TongSoMonHoc



select * from MONHOC