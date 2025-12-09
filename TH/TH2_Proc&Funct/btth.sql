--1

create proc sp_ThanhTien
as
begin
    update SP_DonHang
    set ThanhTien = dh.SoLuong * sp.DonGia
    from SP_DonHang dh
             join SanPham sp on dh.IDSanPham = sp.IDSanPham
end
    exec sp_ThanhTien
    drop proc if exists sp_ThanhTien

--2

    create proc sp_TongTien
    as
    begin
        update DonHang
        set TongTien = dstongtien.tongtien1dh
        from DonHang dh
                 join (select spdh.IDDonHang, sum(spdh.ThanhTien) as tongtien1dh
                       from SP_DonHang spdh
                       group by spdh.IDDonHang) as dstongtien on dh.IDDonHang = dstongtien.IDDonHang
    end
        exec sp_TongTien

--3

        create proc sp_ThuNhap @ngaydau datetime,
                               @ngaycuoi datetime,
                               @thunhap float output
        as
        begin
            select @thunhap = sum(TongTien)
            from DonHang
            where NgayDatHang >= @ngaydau
              and NgayDatHang <= @ngaycuoi
        end

        declare @thunhap1 float
        declare @thunhap2 float
        declare @ngaydau1 datetime, @ngaycuoi1 datetime , @ngaydau2 datetime, @ngaycuoi2 datetime
            set @ngaydau1 = '2023-11-01'
            set @ngaycuoi1 = '2023-11-05'
            set @ngaydau2 = '2023-11-06'
            set @ngaycuoi2 = '2023-11-15'
            exec sp_ThuNhap @ngaydau1, @ngaycuoi1, @thunhap1 output
            exec sp_ThuNhap '2023-11-06', '2023-11-15', @thunhap2 output
            print 'Thu nhap tu ' + convert(varchar, @ngaydau1) + ' den ' + convert(varchar, @ngaycuoi1) + ' la: ' +
                  format(@thunhap1, 'N2')
            print 'Thu nhap tu ' + convert(varchar, @ngaydau2) + ' den ' + convert(varchar, @ngaycuoi2) + ' la: ' +
                  format(@thunhap2, 'N2')
            if (@thunhap1 > @thunhap2)
                print 'Khoang thoi gian tu ' + convert(varchar, @ngaydau1) + ' den ' + convert(varchar, @ngaycuoi1) +
                      ' co thu nhap cao hon: ' + format(@thunhap1, 'N2')
            else
                print 'Khoang thoi gian tu ' + convert(varchar, @ngaydau2) + ' den ' + convert(varchar, @ngaycuoi2) +
                      ' co thu nhap cao hon: ' + format(@thunhap2, 'N2')

--4

            create function func_SLSP(@TenSP nvarchar(100))
                returns int
            as
            begin
                declare @soluong int;

                select @soluong = sum(spdh.SoLuong)
                from SP_DonHang spdh
                         join SanPham sp on spdh.IDSanPham = sp.IDSanPham
                where sp.TenSP = @TenSP

                return @soluong
            end

--a

        select dbo.func_SLSP('Laptop Dell XPS') as SoLuongBanRa

--b
        select sp.TenSP, dbo.func_SLSP(TenSP) as SoLuongBanRa
        from SanPham sp
        where dbo.func_SLSP(TenSP) =
              (select min(dbo.func_SLSP(sp2.TenSP))
               from SanPham sp2)

--c
        UPDATE SanPham
        SET DonGia = DonGia * 0.9
        WHERE dbo.func_SLSP(TenSP) < 100

--5
CREATE FUNCTION func_TongTienDH(@IDDonHang int)
    RETURNS float
AS
BEGIN
    DECLARE @tongtien float;

    SELECT @tongtien = SUM(spdh.SoLuong * sp.DonGia)
    FROM SP_DonHang spdh
             JOIN SanPham sp ON spdh.IDSanPham = sp.IDSanPham
    WHERE spdh.IDDonHang = @IDDonHang

    RETURN @tongtien
END

--5a
        SELECT dh.IDDonHang, dbo.func_TongTienDH(dh.IDDonHang) AS TongTien
        FROM DonHang dh
        WHERE dh.IDKhachHang = '1'

--5b
        SELECT SUM(dbo.func_TongTienDH(dh.IDDonHang)) AS TongTatCa
        FROM DonHang dh
        WHERE dh.IDKhachHang = '1'

--6
            CREATE PROC sp_ThongKe
            AS
            BEGIN
                DECLARE @Thu2 int = 0, @Thu3 int = 0, @Thu4 int = 0, @Thu5 int = 0,
                    @Thu6 int = 0, @Thu7 int = 0, @CN int = 0

                SELECT @Thu2 = COUNT(*) FROM DonHang WHERE DATEPART(WEEKDAY, NgayDatHang) = 2
                SELECT @Thu3 = COUNT(*) FROM DonHang WHERE DATEPART(WEEKDAY, NgayDatHang) = 3
                SELECT @Thu4 = COUNT(*) FROM DonHang WHERE DATEPART(WEEKDAY, NgayDatHang) = 4
                SELECT @Thu5 = COUNT(*) FROM DonHang WHERE DATEPART(WEEKDAY, NgayDatHang) = 5
                SELECT @Thu6 = COUNT(*) FROM DonHang WHERE DATEPART(WEEKDAY, NgayDatHang) = 6
                SELECT @Thu7 = COUNT(*) FROM DonHang WHERE DATEPART(WEEKDAY, NgayDatHang) = 7
                SELECT @CN = COUNT(*) FROM DonHang WHERE DATEPART(WEEKDAY, NgayDatHang) = 1

                PRINT 'Thu hai: ' + CAST(@Thu2 AS varchar) + ' hoa don'
                PRINT 'Thu ba: ' + CAST(@Thu3 AS varchar) + ' hoa don'
                PRINT 'Thu tu: ' + CAST(@Thu4 AS varchar) + ' hoa don'
                PRINT 'Thu nam: ' + CAST(@Thu5 AS varchar) + ' hoa don'
                PRINT 'Thu sau: ' + CAST(@Thu6 AS varchar) + ' hoa don'
                PRINT 'Thu bay: ' + CAST(@Thu7 AS varchar) + ' hoa don'
                PRINT 'Chu nhat: ' + CAST(@CN AS varchar) + ' hoa don'

                DECLARE @max int = (SELECT MAX(cnt)
                                    FROM (VALUES (@Thu2), (@Thu3), (@Thu4), (@Thu5), (@Thu6), (@Thu7), (@CN)) AS T(cnt))

                IF @max = @Thu2
                    PRINT 'Thu hai co nhieu nguoi mua hang nhat'
                ELSE
                    IF @max = @Thu3
                        PRINT 'Thu ba co nhieu nguoi mua hang nhat'
                    ELSE
                        IF @max = @Thu4
                            PRINT 'Thu tu co nhieu nguoi mua hang nhat'
                        ELSE
                            IF @max = @Thu5
                                PRINT 'Thu nam co nhieu nguoi mua hang nhat'
                            ELSE
                                IF @max = @Thu6
                                    PRINT 'Thu sau co nhieu nguoi mua hang nhat'
                                ELSE
                                    IF @max = @Thu7
                                        PRINT 'Thu bay co nhieu nguoi mua hang nhat'
                                    ELSE
                                        IF @max = @CN PRINT 'Chu nhat co nhieu nguoi mua hang nhat'
            END
                EXEC sp_ThongKe

--7
                CREATE PROC sp_SPCao @x int, @dsSP CURSOR VARYING OUTPUT
                AS
                BEGIN
                    SET @dsSP = CURSOR FOR
                        SELECT sp.IDSanPham, sp.TenSP, dbo.func_SLSP(sp.TenSP) AS SoLuongBan
                        FROM SanPham sp
                        WHERE dbo.func_SLSP(sp.TenSP) > @x

                    OPEN @dsSP
                END

--
                DECLARE @curSP CURSOR
                    EXEC sp_SPCao 2, @curSP OUTPUT

                DECLARE @id int, @ten nvarchar(100), @sl int
                    FETCH NEXT FROM @curSP INTO @id, @ten, @sl
                    WHILE @@FETCH_STATUS = 0
                        BEGIN
                            PRINT 'San pham: ' + @ten + ' - So luong ban: ' + CAST(@sl AS varchar)
                            FETCH NEXT FROM @curSP INTO @id, @ten, @sl
                        END
                    CLOSE @curSP
                    DEALLOCATE @curSP

--8
                    CREATE PROC sp_KH_DonHang @dsKH CURSOR VARYING OUTPUT
                    AS
                    BEGIN
                        SET @dsKH = CURSOR FOR
                            SELECT kh.IDKhachHang,
                                   kh.HoTen,
                                   COUNT(dh.IDDonHang) AS SoDonHang,
                                   SUM(dh.TongTien)    AS SoTien,
                                   SUM(spdh.SoLuong)   AS SoSanPham
                            FROM KhachHang kh
                                     LEFT JOIN DonHang dh ON kh.IDKhachHang = dh.IDKhachHang
                                     LEFT JOIN SP_DonHang spdh ON dh.IDDonHang = spdh.IDDonHang
                            GROUP BY kh.IDKhachHang, kh.HoTen

                        OPEN @dsKH
                    END

--
                    DECLARE @curKH CURSOR
                        EXEC sp_KH_DonHang @curKH OUTPUT

                    DECLARE @idkh nvarchar(50), @hoten nvarchar(100), @sodh int, @sotien float, @sosp int
                        FETCH NEXT FROM @curKH INTO @idkh, @hoten, @sodh, @sotien, @sosp
                        WHILE @@FETCH_STATUS = 0
                            BEGIN
                                IF @sodh = 0
                                    PRINT 'Khach hang ' + @hoten + ' chua tung giao dich'
                                ELSE
                                    PRINT 'Khach hang: ' + @hoten + ' - Don hang: ' + CAST(@sodh AS varchar) +
                                          ' - So tien: ' + FORMAT(@sotien, 'N2') + ' - So san pham: ' +
                                          CAST(@sosp AS varchar)
                                FETCH NEXT FROM @curKH INTO @idkh, @hoten, @sodh, @sotien, @sosp
                            END
                        CLOSE @curKH
                        DEALLOCATE @curKH


