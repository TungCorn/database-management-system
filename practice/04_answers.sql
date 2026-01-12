-- =============================================
-- DAP AN
-- =============================================

USE QuanLyHoaHong;
GO

-- =============================================
-- DAP AN BAI 1: FUNCTION
-- =============================================
CREATE OR ALTER FUNCTION fn_TongHoaHongTheoNam (
    @MaDaiLy INT,
    @Nam INT
)
RETURNS DECIMAL(15,2)
AS
BEGIN
    DECLARE @Tong DECIMAL(15,2);
    
    SELECT @Tong = ISNULL(SUM(SoTienHoaHong), 0)
    FROM HOAHONG
    WHERE MaDaiLy = @MaDaiLy
      AND YEAR(NgayTinh) = @Nam;
    
    RETURN @Tong;
END
GO

-- Test:
SELECT 
    TenDaiLy,
    dbo.fn_TongHoaHongTheoNam(MaDaiLy, 2024) AS HoaHong2024,
    dbo.fn_TongHoaHongTheoNam(MaDaiLy, 2025) AS HoaHong2025
FROM DAILY;
GO


-- =============================================
-- DAP AN BAI 2: VIEW TOP DAI LY THEO NAM
-- =============================================
CREATE OR ALTER VIEW vw_TopDaiLyTheoNam
AS
SELECT 
    YEAR(h.NgayTinh) AS Nam,
    d.MaDaiLy,
    d.TenDaiLy,
    SUM(h.SoTienHoaHong) AS TongHoaHong
FROM HOAHONG h
INNER JOIN DAILY d ON h.MaDaiLy = d.MaDaiLy
GROUP BY YEAR(h.NgayTinh), d.MaDaiLy, d.TenDaiLy;
GO

-- Test:
SELECT * FROM vw_TopDaiLyTheoNam
ORDER BY Nam, TongHoaHong DESC;
GO


-- =============================================
-- DAP AN BAI 3: VIEW TOP 1 MOI NAM
-- =============================================
CREATE OR ALTER VIEW vw_DaiLyTopMoiNam
AS
WITH XepHang AS (
    SELECT 
        YEAR(h.NgayTinh) AS Nam,
        d.TenDaiLy,
        SUM(h.SoTienHoaHong) AS TongHoaHong,
        ROW_NUMBER() OVER (
            PARTITION BY YEAR(h.NgayTinh) 
            ORDER BY SUM(h.SoTienHoaHong) DESC
        ) AS Hang
    FROM HOAHONG h
    INNER JOIN DAILY d ON h.MaDaiLy = d.MaDaiLy
    GROUP BY YEAR(h.NgayTinh), d.TenDaiLy
)
SELECT Nam, TenDaiLy, TongHoaHong
FROM XepHang
WHERE Hang = 1;
GO

-- Test:
SELECT * FROM vw_DaiLyTopMoiNam;
GO
