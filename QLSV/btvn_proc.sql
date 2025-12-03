-- Bài tập 1: Viết thủ tục Sp_Update_SV có tham số dùng để:
-- Nếu như là SV cũ thì cập nhật dữ liệu mới  cho một sinh viên khi biết   MaSV trong bảng SinhVien.
-- Nếu như đó là SV mới thì thêm SV đó vào
create
    proc Sp_Update_SV @Masv varchar(10),
                      @Hosv nvarchar(50),
                      @Tensv nvarchar(50),
                      @Nssv int,
                      @Dcsv nvarchar(100),
                      @Loptr int,
                      @Malop varchar(50),
                      @Diemtk real,
                      @Gioitinh nvarchar(10)
as
begin
    if (exists(select 1
               from SINHVIEN
               where Masv = @Masv))
        begin
            update SINHVIEN
            set Hosv   = @Hosv,
                Tensv  = @Tensv,
                Nssv   = @Nssv,
                Dcsv   = @Dcsv,
                Loptr  = @Loptr,
                Malop  = @Malop,
                Diemtk = @Diemtk,
                Gioitinh = @Gioitinh
            where Masv = @Masv
        end
    else
        begin
            insert into SINHVIEN
            values (@Masv,
                    @Hosv,
                    @Tensv,
                    @Nssv,
                    @Dcsv,
                    @Loptr,
                    @Malop,
                    @Diemtk,
                    @Gioitinh
                   )
        end
end

    exec Sp_Update_SV 'SV100', 'ninh', 'minh', 2001, 'HN', 0, 'TH2', 10, 'Nam'

drop proc if exists  Sp_Update_SV

-- Bài tập 2: Viết thủ tục dùng để lấy về điểm trung bình một môn
-- học của cả lớp, của các SV nữ, của các sinh viên Nam với Tên môn
-- học là tham số truyền vào.
go
create proc Sp_DiemTB_MonHoc_GT @Mamh nvarchar(100),
                                @diemtb_ca_lop float output,
                                @diemtb_nu float output,
                                @diemtb_nam float output
as
begin
    if (exists(select 1
               from DIEMSV
               where Mamh = @Mamh))
        begin
            select @diemtb_ca_lop = AVG(Diem)
            from DIEMSV
            where Mamh = @Mamh

            select @diemtb_nu = AVG(d.Diem)
            from DIEMSV d
                     join SINHVIEN sv on d.Masv = sv.Masv
            where d.Mamh = @Mamh
              and sv.Gioitinh = N'Nữ'

            select @diemtb_nam = AVG(d.Diem)
            from DIEMSV d
                     join SINHVIEN sv on d.Masv = sv.Masv
            where d.Mamh = @Mamh
              and sv.Gioitinh = N'Nam'
        end
end

declare @diemtb_ca_lop float , @diemtb_nu float , @diemtb_nam float
    exec Sp_DiemTB_MonHoc_GT
         'MH001',
         @diemtb_ca_lop output,
         @diemtb_nu output,
         @diemtb_nam output
    print 'Diem TB ca lop: ' + cast(@diemtb_ca_lop as varchar(10))
    print 'Diem TB nu: ' + cast(@diemtb_nu as varchar(10))
    print 'Diem TB nam: ' + cast(@diemtb_nam as varchar(10))
    DROP PROC IF EXISTS Sp_DiemTB_MonHoc_GT

go

-- Bài tập 3:
-- Viết thủ tục trả về con trỏ chứa điểm trung bình của SV nữ, điểm trung bình của SV nam cho từng môn học.
-- Sử dụng con trỏ OUTPUT để đưa ra thống kê xem với mỗi môn học thì SV nam hay nữ học tốt hơn.

    create proc Sp_diemtb_theo_gt @dssv cursor varying out
    as
    begin
        set @dssv = cursor for
            select
                mh.Mamh,
                (select avg(d.Diem)
                 from DIEMSV d
                          join SINHVIEN sv on d.Masv = sv.Masv
                 where d.Mamh = mh.Mamh and sv.Gioitinh = N'Nữ') as DiemTB_Nu,
                (select avg(d.Diem)
                 from DIEMSV d
                          join SINHVIEN sv on d.Masv = sv.Masv
                 where d.Mamh = mh.Mamh and sv.Gioitinh = N'Nam') as DiemTB_Nam
            from MONHOC mh
            where exists(select 1 from DIEMSV where Mamh = mh.Mamh)

        open @dssv
    end


    declare @dssv cursor
        exec Sp_diemtb_theo_gt @dssv out

    declare @mamh varchar(50), @diemtb_nu float, @diemtb_nam float

        fetch next from @dssv into @mamh, @diemtb_nu, @diemtb_nam

        while @@fetch_status = 0
            begin
                print N'Môn học: ' + @mamh

                if @diemtb_nu is null and @diemtb_nam is not null
                    print N'  → Chỉ có SV Nam học môn này. Điểm TB: ' + cast(@diemtb_nam as varchar(10))
                else if @diemtb_nam is null and @diemtb_nu is not null
                    print N'  → Chỉ có SV Nữ học môn này. Điểm TB: ' + cast(@diemtb_nu as varchar(10))
                else if @diemtb_nu > @diemtb_nam
                    print N'  → SV Nữ học tốt hơn (Nữ: ' + cast(@diemtb_nu as varchar(10)) + N' - Nam: ' + cast(@diemtb_nam as varchar(10)) + N')'
                else if @diemtb_nam > @diemtb_nu
                    print N'  → SV Nam học tốt hơn (Nam: ' + cast(@diemtb_nam as varchar(10)) + N' - Nữ: ' + cast(@diemtb_nu as varchar(10)) + N')'
                else
                    print N'  → Nam và Nữ học ngang nhau (Điểm: ' + cast(@diemtb_nam as varchar(10)) + N')'

                fetch next from @dssv into @mamh, @diemtb_nu, @diemtb_nam
            end

        close @dssv
        deallocate @dssv
    DROP PROC IF EXISTS Sp_diemtb_theo_gt






