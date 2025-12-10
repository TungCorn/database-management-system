USE master;
GO

-- 1. Tạo Cơ sở dữ liệu
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'QuanLyBanHang')
    DROP DATABASE QuanLyBanHang;
GO
CREATE DATABASE QuanLyBanHang;
GO
USE QuanLyBanHang;
GO

-- 2. Tạo các bảng (Tables) theo sơ đồ

-- Bảng Nhà Cung Cấp
CREATE TABLE NhaCungCap (
                            IDNhaCungCap INT IDENTITY(1,1) PRIMARY KEY,
                            TenCongTy NVARCHAR(255) NOT NULL,
                            DiaChi NVARCHAR(255),
                            SoDienThoai VARCHAR(20),
                            Website VARCHAR(100),
                            ConGiaoDich BIT DEFAULT 1 -- 1: Còn, 0: Không (dùng cho câu 9)
);

-- Bảng Loại Hàng
CREATE TABLE LoaiHang (
                          IDLoaiHang INT IDENTITY(1,1) PRIMARY KEY,
                          TenLoaiHang NVARCHAR(100) NOT NULL,
                          MoTa NVARCHAR(MAX)
);

-- Bảng Sản Phẩm
CREATE TABLE SanPham (
                         IDSanPham INT IDENTITY(1,1) PRIMARY KEY,
                         TenSP NVARCHAR(255) NOT NULL,
                         IDNhaCungCap INT,
                         IDLoaiHang INT,
                         DonGiaNhap DECIMAL(18, 2),
                         SoLuongCon INT DEFAULT 0,
                         SoLuongChoCungCap INT DEFAULT 0,
                         MoTa NVARCHAR(MAX),
                         NgungBan BIT DEFAULT 0, -- 1: Ngưng, 0: Còn bán
                         FOREIGN KEY (IDNhaCungCap) REFERENCES NhaCungCap(IDNhaCungCap),
                         FOREIGN KEY (IDLoaiHang) REFERENCES LoaiHang(IDLoaiHang)
);

-- Bảng Khách Hàng
CREATE TABLE KhachHang (
                           IDKhachHang INT IDENTITY(1,1) PRIMARY KEY,
                           HoTen NVARCHAR(100) NOT NULL,
                           GioiTinh NVARCHAR(10), -- Nam/Nữ
                           DiaChi NVARCHAR(255),
                           Email VARCHAR(100),
                           SoDienThoai VARCHAR(20)
);

-- Bảng Nhân Viên
CREATE TABLE NhanVien (
                          IDNhanVien INT IDENTITY(1,1) PRIMARY KEY,
                          HoTen NVARCHAR(100) NOT NULL,
                          NgaySinh DATE,
                          GioiTinh NVARCHAR(10),
                          NgayBatDauLam DATE,
                          DiaChi NVARCHAR(255),
                          Email VARCHAR(100),
                          SoDienThoai VARCHAR(20)
);

-- Bảng Công Ty Giao Hàng
CREATE TABLE CtyGiaoHang (
                             IDCty INT IDENTITY(1,1) PRIMARY KEY,
                             TenCongTy NVARCHAR(255) NOT NULL,
                             SoDienThoai VARCHAR(20),
                             DiaChi NVARCHAR(255)
);

-- Bảng Đơn Hàng
CREATE TABLE DonHang (
                         IDDonHang INT IDENTITY(1,1) PRIMARY KEY,
                         IDKhachHang INT,
                         IDNhanVien INT,
                         NgayDatHang DATETIME DEFAULT GETDATE(),
                         NgayGiaoHang DATETIME,
                         NgayYeuCauChuyen DATETIME,
                         IDCtyGiaoHang INT,
                         DiaChiGiaoHang NVARCHAR(255),
                         FOREIGN KEY (IDKhachHang) REFERENCES KhachHang(IDKhachHang),
                         FOREIGN KEY (IDNhanVien) REFERENCES NhanVien(IDNhanVien),
                         FOREIGN KEY (IDCtyGiaoHang) REFERENCES CtyGiaoHang(IDCty)
);

-- Bảng Chi Tiết Đơn Hàng (SP_DonHang)
CREATE TABLE SP_DonHang (
                            IDDonHang INT,
                            IDSanPham INT,
                            SoLuong INT,
                            DonGiaBan DECIMAL(18, 2),
                            TyLeGiamGia FLOAT, -- Ví dụ: 0.1 là 10%
                            PRIMARY KEY (IDDonHang, IDSanPham),
                            FOREIGN KEY (IDDonHang) REFERENCES DonHang(IDDonHang),
                            FOREIGN KEY (IDSanPham) REFERENCES SanPham(IDSanPham)
);
GO

-- 3. Nhập dữ liệu mẫu (Data Seeding)

-- Nhập NhaCungCap
INSERT INTO NhaCungCap (TenCongTy, DiaChi, SoDienThoai, Website, ConGiaoDich) VALUES
                                                                                  (N'Công ty Vinamilk', N'TP.HCM', '0901234567', 'vinamilk.com.vn', 1),
                                                                                  (N'Sony Electronics', N'Hà Nội', '0987654321', 'sony.com.vn', 1),
                                                                                  (N'Samsung Vina', N'Bắc Ninh', '0911223344', 'samsung.com', 1),
                                                                                  (N'Unilever VN', N'Bình Dương', '0999888777', 'unilever.com', 1);

-- Nhập LoaiHang
INSERT INTO LoaiHang (TenLoaiHang, MoTa) VALUES
                                             (N'Điện tử', N'Các thiết bị điện tử, công nghệ'),
                                             (N'Thực phẩm', N'Đồ ăn, thức uống, sữa'),
                                             (N'Gia dụng', N'Đồ dùng trong gia đình');

-- Nhập SanPham
-- Giả sử ID: 1-SonyTV, 2-SamsungPhone, 3-Sữa tươi, 4-Bột giặt
INSERT INTO SanPham (TenSP, IDNhaCungCap, IDLoaiHang, DonGiaNhap, SoLuongCon, SoLuongChoCungCap, MoTa, NgungBan) VALUES
                                                                                                                     (N'TV Sony 55 inch', 2, 1, 15000000, 10, 5, N'Smart TV 4K', 0),
                                                                                                                     (N'Samsung Galaxy S23', 3, 1, 20000000, 20, 0, N'Điện thoại cao cấp', 0),
                                                                                                                     (N'Sữa tươi 1L', 1, 2, 30000, 100, 20, N'Sữa tiệt trùng', 0),
                                                                                                                     (N'Bột giặt OMO', 4, 3, 150000, 50, 10, N'Hương ngàn hoa', 0),
                                                                                                                     (N'Tai nghe Sony', 2, 1, 2000000, 15, 0, N'Chống ồn', 0);

-- Nhập KhachHang
INSERT INTO KhachHang (HoTen, GioiTinh, DiaChi, Email, SoDienThoai) VALUES
                                                                        (N'Nguyễn Văn A', N'Nam', N'Hà Nội', 'vana@gmail.com', '0912345678'),
                                                                        (N'Trần Thị B', N'Nữ', N'TP.HCM', 'thib@gmail.com', '0987123456'),
                                                                        (N'Lê Văn C', N'Nam', N'Đà Nẵng', 'vanc@gmail.com', '0909090909');

-- Nhập NhanVien
INSERT INTO NhanVien (HoTen, NgaySinh, GioiTinh, NgayBatDauLam, DiaChi, Email, SoDienThoai) VALUES
                                                                                                (N'Phạm Nhân Viên 1', '1990-01-01', N'Nam', '2020-01-01', N'Hà Nội', 'nv1@cty.com', '0911111111'),
                                                                                                (N'Nguyễn Thị Sale', '1995-05-05', N'Nữ', '2021-06-15', N'Hà Nội', 'sale@cty.com', '0922222222');

-- Nhập CtyGiaoHang
INSERT INTO CtyGiaoHang (TenCongTy, SoDienThoai, DiaChi) VALUES
                                                             (N'Giao Hàng Tiết Kiệm', '19001234', N'Toàn quốc'),
                                                             (N'Viettel Post', '19005678', N'Toàn quốc');

-- Nhập DonHang
-- Đơn 1: Khách A mua, NV 1 bán, Giao hàng 1
INSERT INTO DonHang (IDKhachHang, IDNhanVien, NgayDatHang, NgayGiaoHang, NgayYeuCauChuyen, IDCtyGiaoHang, DiaChiGiaoHang) VALUES
                                                                                                                              (1, 1, '2023-10-01', '2023-10-03', '2023-10-02', 1, N'Nhà riêng khách A'),
-- Đơn 2: Khách B mua, NV 2 bán, Giao hàng 2
                                                                                                                              (2, 2, '2023-10-05', NULL, '2023-10-06', 2, N'Công ty khách B'),
-- Đơn 3: Khách A mua tiếp
                                                                                                                              (1, 2, '2023-10-10', '2023-10-12', '2023-10-11', 1, N'Nhà riêng khách A');

-- Nhập Chi Tiết Đơn Hàng (SP_DonHang)
INSERT INTO SP_DonHang (IDDonHang, IDSanPham, SoLuong, DonGiaBan, TyLeGiamGia) VALUES
-- Đơn 1 mua: 1 TV Sony, 10 Sữa tươi
(1, 1, 1, 18000000, 0.05), -- Giảm 5%
(1, 3, 10, 35000, 0),

-- Đơn 2 mua: 1 Samsung S23
(2, 2, 1, 25000000, 0.1), -- Giảm 10%

-- Đơn 3 mua: 2 Bột giặt, 1 Tai nghe
(3, 4, 2, 180000, 0),
(3, 5, 1, 2500000, 0.02);
GO

SELECT N'Đã tạo CSDL và nhập dữ liệu thành công!' AS ThongBao;



--

USE QuanLyBanHang;
GO

-- 1. Thêm thêm Loại Hàng (Mở rộng danh mục)
INSERT INTO LoaiHang (TenLoaiHang, MoTa) VALUES
                                             (N'Thời trang', N'Quần áo, giày dép, phụ kiện'),
                                             (N'Sách', N'Sách giáo khoa, văn học, truyện tranh'),
                                             (N'Mỹ phẩm', N'Son, phấn, đồ trang điểm, dưỡng da'),
                                             (N'Nội thất', N'Bàn ghế, tủ, giường'),
                                             (N'Văn phòng phẩm', N'Bút, giấy, kẹp ghim');

-- 2. Thêm thêm Nhà Cung Cấp
INSERT INTO NhaCungCap (TenCongTy, DiaChi, SoDienThoai, Website, ConGiaoDich) VALUES
                                                                                  (N'Công ty May Việt Tiến', N'TP.HCM', '02838640800', 'viettien.com.vn', 1),
                                                                                  (N'Nhà sách Fahasa', N'TP.HCM', '1900636467', 'fahasa.com', 1),
                                                                                  (N'L''Oreal Việt Nam', N'TP.HCM', '1800545463', 'loreal.vn', 1),
                                                                                  (N'Nội thất Hòa Phát', N'Hà Nội', '02435558888', 'hoaphat.com', 1),
                                                                                  (N'Thiên Long', N'TP.HCM', '02837505555', 'thienlong.vn', 1),
                                                                                  (N'Apple Distribution', N'Singapore', '0011223344', 'apple.com', 1);

-- 3. Thêm nhiều Sản Phẩm (Đa dạng giá và loại)
-- Lưu ý: IDNhaCungCap và IDLoaiHang được ước lượng dựa trên thứ tự Insert
INSERT INTO SanPham (TenSP, IDNhaCungCap, IDLoaiHang, DonGiaNhap, SoLuongCon, SoLuongChoCungCap, MoTa, NgungBan) VALUES
                                                                                                                     (N'Áo Sơ mi Nam', 5, 4, 250000, 100, 0, N'Vải cotton thoáng mát', 0),
                                                                                                                     (N'Quần Tây đen', 5, 4, 300000, 80, 0, N'Dáng công sở', 0),
                                                                                                                     (N'Harry Potter trọn bộ', 6, 5, 1200000, 30, 5, N'Bìa cứng bản đặc biệt', 0),
                                                                                                                     (N'Đắc Nhân Tâm', 6, 5, 50000, 200, 10, N'Sách bán chạy nhất', 0),
                                                                                                                     (N'Son L''Oreal Matte', 7, 6, 180000, 50, 0, N'Màu đỏ quyến rũ', 0),
                                                                                                                     (N'Kem dưỡng ẩm', 7, 6, 250000, 40, 0, N'Ban đêm', 0),
                                                                                                                     (N'Ghế xoay văn phòng', 8, 7, 800000, 20, 0, N'Lưới chịu lực', 0),
                                                                                                                     (N'Bàn làm việc gỗ', 8, 7, 1500000, 10, 2, N'Gỗ công nghiệp', 0),
                                                                                                                     (N'Bút bi Thiên Long', 9, 8, 3000, 1000, 100, N'Hộp 20 cây', 0),
                                                                                                                     (N'iPhone 15 Pro Max', 10, 1, 28000000, 5, 5, N'Titanium Tự nhiên', 0),
                                                                                                                     (N'MacBook Air M2', 10, 1, 24000000, 8, 2, N'Mỏng nhẹ', 0),
                                                                                                                     (N'Giày Nike Air', 5, 4, 2000000, 15, 0, N'Giày chạy bộ', 0),
                                                                                                                     (N'Sữa rửa mặt', 7, 6, 90000, 60, 0, N'Cho da dầu', 0);

-- 4. Thêm danh sách Khách Hàng phong phú
INSERT INTO KhachHang (HoTen, GioiTinh, DiaChi, Email, SoDienThoai) VALUES
                                                                        (N'Phạm Văn Dũng', N'Nam', N'Hải Phòng', 'dungpv@gmail.com', '0933445566'),
                                                                        (N'Lê Thị Thu', N'Nữ', N'Cần Thơ', 'thule@yahoo.com', '0944556677'),
                                                                        (N'Hoàng Minh Tuấn', N'Nam', N'Nghệ An', 'tuanhm@gmail.com', '0955667788'),
                                                                        (N'Đỗ Thu Hà', N'Nữ', N'Hà Nội', 'hadt@gmail.com', '0966778899'),
                                                                        (N'Ngô Bảo Châu', N'Nam', N'Huế', 'chaunb@edu.vn', '0977889900'),
                                                                        (N'Bùi Thị Xuân', N'Nữ', N'Bình Định', 'xuanbt@gmail.com', '0988990011'),
                                                                        (N'Trương Vô Kỵ', N'Nam', N'Núi Võ Đang', 'kyvo@kiemhiep.com', '0911223399'),
                                                                        (N'Triệu Mẫn', N'Nữ', N'Mông Cổ', 'manmong@gmail.com', '0922334455');

-- 5. Thêm Nhân Viên
INSERT INTO NhanVien (HoTen, NgaySinh, GioiTinh, NgayBatDauLam, DiaChi, Email, SoDienThoai) VALUES
                                                                                                (N'Lê Thanh Tâm', '1992-03-10', N'Nữ', '2019-05-20', N'TP.HCM', 'tamlt@cty.com', '0933111222'),
                                                                                                (N'Trần Quốc Toản', '1998-08-15', N'Nam', '2022-01-10', N'Hà Nội', 'toantq@cty.com', '0944333444'),
                                                                                                (N'Nguyễn Thị Chi', '1985-12-20', N'Nữ', '2015-09-01', N'Đà Nẵng', 'chint@cty.com', '0955666777');

-- 6. Thêm Đơn Hàng (Tạo lịch sử giao dịch)
-- Các đơn hàng rải rác trong năm 2023, 2024
INSERT INTO DonHang (IDKhachHang, IDNhanVien, NgayDatHang, NgayGiaoHang, NgayYeuCauChuyen, IDCtyGiaoHang, DiaChiGiaoHang) VALUES
                                                                                                                              (3, 1, '2023-11-01', '2023-11-03', '2023-11-02', 2, N'Nghệ An'),
                                                                                                                              (4, 2, '2023-11-05', '2023-11-07', '2023-11-06', 1, N'Hà Nội'),
                                                                                                                              (5, 3, '2023-11-10', '2023-11-15', '2023-11-12', 2, N'Huế'),
                                                                                                                              (6, 1, '2023-12-01', '2023-12-05', '2023-12-04', 1, N'Bình Định'),
                                                                                                                              (1, 4, '2024-01-05', '2024-01-08', '2024-01-07', 2, N'Hà Nội'),
                                                                                                                              (2, 5, '2024-01-15', '2024-01-18', '2024-01-17', 1, N'TP.HCM'),
                                                                                                                              (7, 2, '2024-02-14', '2024-02-16', '2024-02-15', 2, N'Võ Đang'),
                                                                                                                              (8, 3, '2024-02-20', NULL, '2024-02-25', 1, N'Mông Cổ'), -- Đơn chưa giao
                                                                                                                              (3, 1, '2024-03-01', '2024-03-03', '2024-03-02', 1, N'Nghệ An'),
                                                                                                                              (4, 2, '2024-03-08', '2024-03-09', '2024-03-09', 2, N'Hà Nội');

-- 7. Thêm Chi Tiết Đơn Hàng (Dữ liệu quan trọng để tính tiền)
-- Giả định các IDSanPham mới thêm vào từ 6 đến 18
-- Giả định IDDonHang mới thêm vào từ 4 đến 13
INSERT INTO SP_DonHang (IDDonHang, IDSanPham, SoLuong, DonGiaBan, TyLeGiamGia) VALUES
-- Đơn 4 (Khách 3): Mua Áo sơ mi và Quần tây
(4, 6, 2, 350000, 0.1),
(4, 7, 1, 400000, 0),

-- Đơn 5 (Khách 4): Mua Sách Harry Potter
(5, 8, 1, 1500000, 0.05),

-- Đơn 6 (Khách 5): Mua Ghế xoay
(6, 12, 5, 1200000, 0.2), -- Mua sỉ giảm giá sâu

-- Đơn 7 (Khách 6): Mua Son và Kem dưỡng
(7, 10, 2, 250000, 0),
(7, 11, 1, 350000, 0.05),

-- Đơn 8 (Khách 1): Mua iPhone 15
(8, 15, 1, 32000000, 0.0), -- Không giảm giá

-- Đơn 9 (Khách 2): Mua Bút bi sll
(9, 14, 50, 5000, 0.1),

-- Đơn 10 (Khách 7 - Vô Kỵ): Mua Kiếm (Không có kiếm, mua gậy Gofl/Bàn ghế) -> Mua Bàn
(10, 13, 2, 2000000, 0),

-- Đơn 11 (Khách 8 - Triệu Mẫn): Mua Sách Đắc Nhân Tâm + Son
(11, 9, 10, 70000, 0.1),
(11, 10, 5, 250000, 0),

-- Đơn 12 (Khách 3): Mua MacBook
(12, 16, 1, 28000000, 0.05),

-- Đơn 13 (Khách 4): Mua Giày Nike
(13, 17, 1, 2500000, 0.1);
GO

SELECT N'Đã bổ sung dữ liệu lớn thành công!' AS ThongBao;