create proc PR2 @malop char(5)
as
begin
    if (exists(select *
               from SINHVIEN
               where Malop = @malop))
        select * from SINHVIEN where Malop = @malop;
    else
end

--truy van danh sach diem sinh vien trong 1 lop trong 1 mon hoc

    create proc dsdiem @malop varchar(10),
                       @mamh varchar(10)
    as
    begin
        if (exists(select sv.Malop, sv.Masv, sv.Tensv, d.Mamh, d.Diem
                   from DIEMSV d
                            join SINHVIEN sv on d.Masv = sv.Masv
                   where sv.Malop = @malop
                     and d.Mamh = @mamh))
            select sv.Malop, sv.Masv, sv.Tensv, d.Mamh, d.Diem
            from DIEMSV d
                     join SINHVIEN sv on d.Masv = sv.Masv
            where sv.Malop = @malop
              and d.Mamh = @mamh
        else
            print 'Khong ton tai'
    end
        EXEC dsdiem 'TH1', 'MH001';

        DROP PROC IF EXISTS dsdiem


        -- tra ve tham so output

--tra ve so sinh vien cua 1 lop bat ki

--         create proc ds_sv_1_lop @malop varchar(10),
--                                 @slsv int output
--         as
--         begin
--             if (exists(select 1
--                        from SINHVIEN
--                        where Malop = @malop))
--                 select *
--                 from SINHVIEN
--                 where Malop = @malop;
--                 set @slsv = @@rowcount;
--             else
--                 print 'Lop khong ton tai'
--         end


        -- thu tuc voi con tro
        create proc htsv @malop varchar(10),
                         @dssv cursor varying out
        as
        begin
            set @dssv = cursor
                for select Tensv, Masv from SINHVIEN where Malop = @malop
            open @dssv
        end

        DECLARE @mycur cursor
            exec htsv 'TH1', @mycur out
        DECLARE @tensv varchar(50), @masv varchar(10)
            fetch next from @mycur into @tensv, @masv
            while @@fetch_status = 0
                begin
                    print @tensv + ' - ' + @masv
                    fetch next from @mycur into @tensv, @masv
                end
            close @mycur
            deallocate @mycur


--thu tuc tra ve 1 con tro cho biet so luong sv thi lai cua moi mon hoc diem < 4, mon hoc co sl sv thi lai nhieu nhat

go

create proc sl_sv_thi_lai @dssv cursor varying out
as
begin
    set @dssv = cursor
        for
        select Mamh, count(Masv) as SoLuongSVThiLai
        from DIEMSV
        where Diem < 5
        group by Mamh
        order by SoLuongSVThiLai desc
    open @dssv
end

DECLARE @dssv cursor
    exec sl_sv_thi_lai @dssv out
DECLARE @mamh varchar(10), @slsv int, @max int
    fetch next from @dssv into @mamh, @slsv
    set @max = @slsv
    while @@fetch_status = 0
        begin
            if (@slsv = @max)
                print @mamh + ' - ' + cast(@slsv as varchar(10))
            fetch next from @dssv into @mamh, @slsv
        end

    close @dssv
    deallocate @dssv


