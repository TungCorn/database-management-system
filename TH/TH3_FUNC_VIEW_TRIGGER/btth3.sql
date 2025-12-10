--1

drop function if exists f_ThanhTien
create function f_ThanhTien(@IDDonHang int, @IDSanPham int)
    returns float
as
begin
    declare @ThanhTien float
    select @ThanhTien = (SoLuong * DonGiaBan * (1 - TyLeGiamGia))
    from SP_DonHang
    where IDDonHang = @IDDonHang
      and IDSanPham = @IDSanPham
    return @ThanhTien
end

select dbo.f_ThanhTien(1, 1) as ThanhTien

--2
drop function if exists f_TongTien
create function f_TongTien(@IDDonHang int)
    returns float
as
begin
    declare @tongtien float
    select @tongtien = SUM(dbo.f_ThanhTien(@IDDonHang, IDSanPham))
    from SP_DonHang
    where IDDonHang = @IDDonHang
    return @tongtien
end

select dbo.f_TongTien(1) as TongTien

--3
drop function if exists f_SP_DonHang

create function f_SP_DonHang(@IDDonHang int)
    returns table
        as
        return(select spdh.IDSanPham,
                      sp.TenSP,
                      lh.TenLoaiHang,
                      ncc.TenCongTy,
                      spdh.SoLuong,
                      spdh.DonGiaBan,
                      spdh.TyLeGiamGia,
                      dbo.f_ThanhTien(@IDDonHang, spdh.IDSanPham) as ThanhTien
               from SP_DonHang spdh
                        join SanPham sp on spdh.IDSanPham = sp.IDSanPham
                        join NhaCungCap ncc on sp.IDNhaCungCap = ncc.IDNhaCungCap
                        join LoaiHang lh on sp.IDLoaiHang = lh.IDLoaiHang
               where spdh.IDDonHang = @IDDonHang)

select *
from dbo.f_SP_DonHang(1)

--4          VIEW

create view v_ChiTietDonHang
as
select IDDonHang,
       spdh.IDSanPham,
       sp.TenSP,
       lh.TenLoaiHang,
       ncc.TenCongTy,
       spdh.SoLuong,
       spdh.DonGiaBan,
       spdh.TyLeGiamGia,
       dbo.f_ThanhTien(spdh.IDDonHang, spdh.IDSanPham)                                as ThanhTienBan,
       dbo.f_ThanhTien(spdh.IDDonHang, spdh.IDSanPham) - sp.DonGiaNhap * spdh.SoLuong as TienLai
from SP_DonHang spdh
         join SanPham sp on spdh.IDSanPham = sp.IDSanPham
         join NhaCungCap ncc on sp.IDNhaCungCap = ncc.IDNhaCungCap
         join LoaiHang lh on sp.IDLoaiHang = lh.IDLoaiHang

select *
from v_ChiTietDonHang

--5
-- Tạo view v_TongKetDonHang để hiển thị thông tin tổng kết các đơn hàng bao
-- gồm IDDonHang, IDKhachHang, HoTenKhachHang, GioiTinhKhachHang,
-- IDNhanVien, HoTenNhanVien, NgayDatHang, NgayGiaoHang, NgayYeuCauChuyen,
-- IDCongTyGiaoHang, TenCongTyGiaoHang, SoMatHang, TongTienHoaDon,
-- TongTienLai
-- với: - SoMatHang là số mặt hàng trong đơn hàng (chú ý: một sản phẩm với số lượng là
-- n>1 cũng chỉ được tính là 1 mặt hàng)
-- - TongTienHoaDon là tổng tiền thu được từ các mặt hàng trong hóa đơn
-- - TongLai là tổng tiền lãi thu được từ các mặt hàng trong hóa đơn

create view v_TongKetDonHang
as
select dh.IDDonHang,
       KH.IDKhachHang, KH.HoTen as HoTenKH , KH.GioiTinh,
       NV.IDNhanVien, NV.HoTen as HoTenNhanVien,
       dh.NgayDatHang, dh.NgayGiaoHang, dh.NgayYeuCauChuyen,
       CGH.IDCty, cgh.TenCongTy,
       count(sdh.IDSanPham) as SoMatHang,
       dbo.f_TongTien(dh.IDDonHang) as TongTienHoaDon,
       dbo.f_TongTien(dh.IDDonHang) - SUM((sp.DonGiaNhap * sdh.SoLuong)) as TongTienLai
from DonHang dh
join dbo.SP_DonHang SDH on dh.IDDonHang = SDH.IDDonHang
join dbo.KhachHang KH on dh.IDKhachHang = KH.IDKhachHang
join dbo.NhanVien NV on dh.IDNhanVien = NV.IDNhanVien
join dbo.CtyGiaoHang CGH on dh.IDCtyGiaoHang = CGH.IDCty
join dbo.SanPham SP on SDH.IDSanPham = SP.IDSanPham
group by dh.IDDonHang, cgh.TenCongTy, dh.NgayGiaoHang, NV.IDNhanVien, KH.IDKhachHang, KH.HoTen, KH.GioiTinh, NV.HoTen, dh.NgayYeuCauChuyen, dh.NgayDatHang, CGH.IDCty, SDH.IDDonHang

select * from v_TongKetDonHang






