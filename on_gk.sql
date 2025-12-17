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

--PROC tra ve so sinh vien cua 1 lop bat ki

    create proc slsvien
        @malop varchar(10),
        @slsv int output
        as
        begin
            select @slsv = count(*)
            from SINHVIEN
            where Malop = @malop
        end

declare @slsv int
        exec slsvien 'TH1', @slsv output

        print @slsv

--thu tuc tra ve 1 con tro cho biet so luong sv thi lai cua moi mon hoc diem < 4

    create proc dem_sl_sv_thi_lai
        @dssv cursor varying out
        as
        begin
            set @dssv = cursor for
            select
            from DIEMSV d
        end

--tongtiendh funct

create function tongtiendh(@madh varchar(10))
    returns float
as
begin
    declare @tt float
    select @tt = sum(ThanhTien)
    from SP_DonHang spdh
    where spdh.IDDonHang = @madh
    return @tt
end

select dbo.tongtiendh(1) as tongtien

-- func ds 1 lop

create function ds1lop(@malop varchar(10))
    returns table
as
return (
    select *
    from SINHVIEN
    where Malop = @malop
        )
select * from dbo.ds1lop('TH1')
--
--                   Câu 15: Viết hàm trả về điểm trung bình của một sinh viên nào đấy với MSSV
-- là tham số đầu vào của hàm
        -- DiemTB = Tổng (Điểm thi * Số Tín chỉ)/ Tổng (số tín chỉ)
-- Gọi hàm và in ra màn hình HoTen và điểm trung bình của SV có MaSV = 1

    create function diemtbsv (@masv varchar(50))
        returns float
        as
        begin
            declare @diemtb float
            select @diemtb = sum(kq.diemthi * monhoc.sotinchi) * 1.0 / sum(sotinchi)
            from KetQua kq
            join Monhoc on kq.mamh = monhoc.mamh
            where kq.masv = @masv
            group by kq.masv
            return @diemtb
        end

    --view ds_sv_thi_dat_lan1

--Câu 7. Tạo Trigger để đảm bảo rằng khi thêm một loại mặt hàng vào bảng LoaiHang
-- thì tên loại mặt hàng thêm vào phải chưa có trong bảng. Nếu người dùng nhập một tên
-- loại mặt hàng đã có trong danh sách thì báo lỗi.
-- Thử thêm một loại mặt hàng vào trong bảng

    create trigger themmh
        on LoaiHang
        for insert
        as
    begin
        if exists (select 1
                   from inserted i
                   where i.TenLoaiHang in (select l.TenLoaiHang
                                           from LoaiHang l
                                                    join inserted i1 on l.TenLoaiHang = i1.TenLoaiHang
                                           where i1.IDLoaiHang != l.IDLoaiHang))
            begin
                rollback transaction
                print 'loi'
            end
    end
        insert into LoaiHang (TenLoaiHang)
        values (N'chibi')

--

        create trigger update_diem
            on DIEMSV
            for update
            as
        begin
            update SINHVIEN
            set diemtk = (select avg(d.Diem)
                          from DIEMSV d
                          where d.Masv = i.Masv)
            from inserted i
            where SINHVIEN.Masv = i.Masv
        end
            update DIEMSV
            set Diem = 10
            where Masv = 'SV004'
              and Mamh = 'MH001'

--trigger khong cho update neu doi masv, mamh hoac diem moi < diem truoc

create trigger ktra_update
    on DIEMSV
    for update
    as
    begin
        if update(Mamh) or update(Masv)
            rollback transaction
        if exists (
            select 1
            from DIEMSV dv
            join inserted i on dv.Masv = i.Masv
            where i.Diem < dv.Diem
        )
            begin
                rollback transaction
            end

    end