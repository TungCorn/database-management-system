--diemtk diemtk = avg diem cao nhat moi mon

declare x cursor dynamic scroll
    for
    select d.Masv, sv.Tensv, d.Mamh, max(d.Diem)
    from DIEMSV d
             join SINHVIEN sv on d.Masv = sv.Masv
    group by d.Masv, d.Mamh, sv.Tensv
    order by d.Masv, d.Mamh
open x;

declare @masv varchar(50), @ten nvarchar(50), @diemcaonhat float, @mamh varchar(10);
fetch first from x into @masv, @ten, @mamh, @diemcaonhat
while (@@FETCH_STATUS = 0)
    Begin
        print @masv + '		' + @ten + '	' + @mamh + '   ' + cast(@diemcaonhat as varchar(10))

        fetch next from x into @masv, @ten, @mamh, @diemcaonhat
    End
close x
deallocate x

--truy van danh sach diem sinh vien trong 1 lop trong 1 mon hoc
--thu tuc tra ve 1 con tro cho biet so luong sv thi lai cua moi mon hoc diem < 4

--ds_diem_cao_nhat_sv funct

--view ds_sv_thi_dat_lan1

--Câu 7. Tạo Trigger để đảm bảo rằng khi thêm một loại mặt hàng vào bảng LoaiHang
-- thì tên loại mặt hàng thêm vào phải chưa có trong bảng. Nếu người dùng nhập một tên
-- loại mặt hàng đã có trong danh sách thì báo lỗi.
-- Thử thêm một loại mặt hàng vào trong bảng

