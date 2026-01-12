-- =============================================
-- BAI TAP ON TAP: QUAN LY HOA HONG DAI LY
-- =============================================

CREATE DATABASE QuanLyHoaHong;
GO

USE QuanLyHoaHong;
GO

-- =============================================
-- BANG 1: DAILY (Dai ly)
-- =============================================
CREATE TABLE DAILY (
    MaDaiLy INT IDENTITY(1,1) PRIMARY KEY,
    TenDaiLy NVARCHAR(200) NOT NULL,
    SoDienThoai NVARCHAR(20),
    DiaChi NVARCHAR(500),
    TyLeHoaHong DECIMAL(5,2) DEFAULT 10.00,      -- % hoa hong mac dinh
    NgayHopDong DATE,
    TrangThai BIT DEFAULT 1                       -- 1: Hoat dong, 0: Ngung
);
GO

-- =============================================
-- BANG 2: DONHANG (Don hang)
-- =============================================
CREATE TABLE DONHANG (
    MaDonHang INT IDENTITY(1,1) PRIMARY KEY,
    MaDaiLy INT NOT NULL,
    NgayDat DATE NOT NULL,
    TongTien DECIMAL(12,2) NOT NULL,
    TrangThai NVARCHAR(20) DEFAULT 'HoanThanh',
    CONSTRAINT FK_DonHang_DaiLy FOREIGN KEY (MaDaiLy) 
        REFERENCES DAILY(MaDaiLy)
);
GO

-- =============================================
-- BANG 3: HOAHONG (Hoa hong)
-- =============================================
CREATE TABLE HOAHONG (
    MaHoaHong INT IDENTITY(1,1) PRIMARY KEY,
    MaDaiLy INT NOT NULL,
    MaDonHang INT NOT NULL,
    GiaTriDonHang DECIMAL(12,2) NOT NULL,        -- Gia tri don hang
    TyLe DECIMAL(5,2) NOT NULL,                  -- Ty le %
    SoTienHoaHong DECIMAL(12,2) NOT NULL,        -- = GiaTriDonHang * TyLe / 100
    NgayTinh DATE NOT NULL,                      -- Ngay tinh hoa hong
    DaThanhToan BIT DEFAULT 0,                   -- 0: Chua, 1: Da thanh toan
    NgayThanhToan DATE NULL,
    CONSTRAINT FK_HoaHong_DaiLy FOREIGN KEY (MaDaiLy) 
        REFERENCES DAILY(MaDaiLy),
    CONSTRAINT FK_HoaHong_DonHang FOREIGN KEY (MaDonHang) 
        REFERENCES DONHANG(MaDonHang)
);
GO

PRINT N'Tao bang thanh cong!';
GO
