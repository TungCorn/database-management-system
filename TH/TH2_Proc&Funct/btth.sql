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

