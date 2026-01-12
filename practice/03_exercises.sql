-- =============================================
-- BAI TAP ON TAP
-- =============================================

USE QuanLyHoaHong;
GO

-- =============================================
-- BAI 1: FUNCTION TINH TONG HOA HONG THEO NAM
-- =============================================
-- Tham so: @MaDaiLy, @Nam
-- Tra ve: Tong hoa hong cua dai ly trong nam do
-- =============================================

-- VIET CODE O DAY:
/*
CREATE FUNCTION fn_TongHoaHongTheoNam (
    @MaDaiLy INT,
    @Nam INT
)
RETURNS DECIMAL(15,2)
AS
BEGIN
    -- Viet code o day
    RETURN 0;
END
GO
*/


-- =============================================
-- BAI 2: VIEW TOP DAI LY THEO NAM
-- =============================================
-- Hien thi:
--   Nam, MaDaiLy, TenDaiLy, TongHoaHong
-- Sap xep theo TongHoaHong giam dan
-- =============================================

-- VIET CODE O DAY:
/*
CREATE VIEW vw_TopDaiLyTheoNam
AS
    -- Viet code o day
    SELECT 1 AS placeholder;
GO
*/


-- =============================================
-- BAI 3: VIEW DAI LY CO HOA HONG CAO NHAT MOI NAM
-- =============================================
-- Chi lay 1 dai ly cao nhat cua moi nam
-- Dung ROW_NUMBER()
-- =============================================

-- VIET CODE O DAY:
/*
CREATE VIEW vw_DaiLyTopMoiNam
AS
    -- Viet code o day
    SELECT 1 AS placeholder;
GO
*/


-- =============================================
-- CONG THUC
-- =============================================
/*
SoTienHoaHong = GiaTriDonHang * TyLe / 100

Loc theo nam: YEAR(NgayTinh) = @Nam
*/
