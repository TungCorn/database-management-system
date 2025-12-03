--B1


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
		having AVG(maxdiem.DiemCaoNhat) > 8

	open y;

	declare @masv varchar(50), @ten nvarchar(50), @diemtb float, @diemcaonhat float;
	fetch first from y into @masv, @ten, @diemtb
	while (@@FETCH_STATUS = 0)
	Begin
		print @masv + '		' + @ten + '	' + cast(@diemtb as varchar(10))
		
		fetch next from y into @masv, @ten, @diemtb
	End
	--

	declare @masv varchar(50), @ten nvarchar(50), @diemtb float, @diemcaonhat float;
	set @diemcaonhat = 0;
	fetch next from y into @masv, @ten, @diemtb
	while (@@FETCH_STATUS = 0)
	Begin
		if (@diemtb > @diemcaonhat) set @diemcaonhat = @diemtb;		
		fetch next from y into @masv, @ten, @diemtb
	End


	fetch first from y into @masv, @ten, @diemtb
	while (@@FETCH_STATUS = 0)
	Begin
		if (ABS(@diemtb - @diemcaonhat) < 0.001) print @masv + '		' + @ten + '	' + cast(@diemtb as varchar(10))
		fetch next from y into @masv, @ten, @diemtb
	End
	close y;
	deallocate y;


	--B2

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
		order by sv.Masv, maxdiem.Mamh 
	open y;

	declare @masv varchar(50), @ten nchar(10), @mamh varchar(50), @diemcaonhat float;
	fetch first from y into @masv, @ten, @mamh, @diemcaonhat
	while (@@FETCH_STATUS = 0)
	Begin
		print @masv + '		' + @ten + '	' + @mamh + '	' + cast(@diemcaonhat as varchar(10))
		
		fetch next from y into @masv, @ten, @mamh, @diemcaonhat
	End
	--

	close y;
	deallocate y;