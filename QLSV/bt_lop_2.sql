--1tr 2tr thi sinh vien ... dat hoc bong


	declare y cursor
	dynamic scroll
	for 
		select sv.Masv, sv.Tensv, AVG(d.Diem) as diem
		from SINHVIEN sv
		join DIEMSV d on sv.Masv = d.Masv
		group by sv.Masv, sv.Tensv
		having AVG(d.Diem) >= 8.5

	open y;

	declare @masv varchar(50), @ten nvarchar(50), @diem float;
	fetch first from y into @masv, @ten, @diem
	while (@@FETCH_STATUS = 0)
	Begin
		if (@diem < 9) print N'Sinh viên ' + @ten + N' đạt học bổng 1tr';
		else if (@diem >= 9) print N'Sinh viên ' + @ten + N' đạt học bổng 2tr';
		else print N'Không có sinh viên nào đạt học bổng';
		fetch next from y into @masv, @ten, @diem
	End

	close y;
	deallocate y;


	--diemtk diemtk = avg diem cao nhat moi mon

	alter table SINHVIEN
	add diemtk real

	declare y cursor
	dynamic scroll
	for 
		select sv.Masv, sv.Tensv, AVG(maxdiem.DiemCaoNhat) as diemtb
		from SINHVIEN sv
		join
		(
		select d.Masv, d.Mamh, MAX(d.Diem) as DiemCaoNhat 
		from DIEMSV d
		group by d.Masv, d.Mamh
		) as maxdiem on sv.Masv = maxdiem.Masv
		group by sv.Masv, sv.Tensv

	open y;

	declare @masv varchar(50), @ten nvarchar(50), @diemtb float;
	fetch first from y into @masv, @ten, @diemtb
	while (@@FETCH_STATUS = 0)
	Begin
		update SINHVIEN 
		set diemtk = @diemtb
		where Masv = @masv;
		
		fetch next from y into @masv, @ten, @diemtb
	End

	close y;
	deallocate y;

	select * from SINHVIEN


	-- con tro in ra sinh vien nao thi lai mon hoc nao all lan thi < 4


	declare y cursor
	dynamic scroll
	for 
		select sv.Masv, sv.Tensv, maxdiem.Mamh, maxdiem.DiemCaoNhat
		from SINHVIEN sv
		join
		(
		select d.Masv, d.Mamh, MAX(d.Diem) as DiemCaoNhat 
		from DIEMSV d
		group by d.Masv, d.Mamh
		) as maxdiem on sv.Masv = maxdiem.Masv
		group by sv.Masv, sv.Tensv, maxdiem.Mamh, maxdiem.DiemCaoNhat

	open y;

	declare @masv varchar(50), @ten nvarchar(50), @mamh varchar(50), @diem float;
	fetch first from y into @masv, @ten, @mamh, @diem
	while (@@FETCH_STATUS = 0)
	Begin
		if (@diem < 5) print N'Sinh viên ' + @ten + N' thi lại ' + @mamh + N' với điểm là ' + cast(@diem as varchar(10))
		
		fetch next from y into @masv, @ten, @mamh, @diem
	End

	close y;
	deallocate y;