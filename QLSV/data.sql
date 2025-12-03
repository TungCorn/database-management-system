-- CHẠY LỆNH NÀY TRƯỚC ĐỂ XÓA DỮ LIỆU CŨ
DELETE FROM DIEMSV;
DELETE FROM CTHOC;
DELETE FROM SINHVIEN;
DELETE FROM LOP;
DELETE FROM MONHOC;
DELETE FROM KHOA;

INSERT INTO KHOA (Makh, Vpkh) VALUES
('CNTT', N'Văn phòng Khoa CNTT - Tòa A1'),
('KT', N'Văn phòng Khoa Kinh Tế - Tòa B2'),
('CK', N'Văn phòng Khoa Cơ Khí - Tòa C3');

INSERT INTO MONHOC (Mamh, Tenmh, LT, TH) VALUES
('MH001', N'Cơ sở dữ liệu', 45, 15),
('MH002', N'Lập trình Web', 30, 30),
('MH003', N'Kinh tế vi mô', 45, 0),
('MH004', N'Cơ khí đại cương', 30, 15),
('MH005', N'Toán rời rạc', 60, 0),
('MH006', N'Cấu trúc dữ liệu', 45, 15), -- Dữ liệu cho Câu 6 (môn CTDL)
('MH007', N'Mạng máy tính', 45, 15),
('MH008', N'Hệ điều hành', 45, 15),
('MH009', N'Phân tích thiết kế PM', 60, 0),
('MH010', N'An toàn thông tin', 60, 0);

INSERT INTO LOP (Malop, Makh) VALUES
('TH1', 'CNTT'), -- Lớp TH1 thuộc khoa CNTT
('TH2', 'CNTT'), -- Lớp TH2 thuộc khoa CNTT
('KT1', 'KT'),
('KT2', 'KT'),
('CK1', 'CK');

INSERT INTO SINHVIEN (Masv, Hosv, Tensv, Nssv, Dcsv, Loptr, Malop) VALUES
-- Lớp TH1 (9 SV) - Khoa CNTT
('SV001', N'Nguyễn Văn', N'An', 2000, N'Hà Nội', 1, 'TH1'), -- Lớp trưởng
('SV002', N'Trần Thị', N'Bình', 2000, N'Hải Phòng', 0, 'TH1'),
('SV003', N'Lê Văn', N'Cường', 2000, N'Đà Nẵng', 0, 'TH1'),
('SV004', N'Phạm Thị', N'Dung', 2000, N'Nam Định', 0, 'TH1'),
('SV005', N'Vũ Đức', N'Long', 2000, N'Hà Nội', 0, 'TH1'),
('SV006', N'Hoàng Thị', N'Giang', 2000, N'Cần Thơ', 0, 'TH1'),
('SV007', N'Bùi Văn', N'Hiếu', 2000, N'TP. HCM', 0, 'TH1'),
('SV008', N'Đặng Thị', N'Hương', 2000, N'Bắc Ninh', 0, 'TH1'),
('SV009', N'Ngô Văn', N'Kiên', 2000, N'Quảng Ninh', 0, 'TH1'), -- Thêm SV này để TH1 đông nhất
-- Lớp TH2 (8 SV) - Khoa CNTT
('SV010', N'Trịnh Thị', N'Lan', 2000, N'Hà Nam', 1, 'TH2'), -- Lớp trưởng
('SV011', N'Mai Văn', N'Nam', 2000, N'Ninh Bình', 0, 'TH2'),
('SV012', N'Phan Văn', N'Minh', 2000, N'Hà Nội', 0, 'TH2'),
('SV013', N'Đỗ Thị', N'Oanh', 2000, N'Thái Bình', 0, 'TH2'),
('SV014', N'Lý Văn', N'Phú', 2000, N'Hà Tĩnh', 0, 'TH2'),
('SV015', N'Dương Thị', N'Quỳnh', 2000, N'Nghệ An', 0, 'TH2'),
('SV016', N'Lại Văn', N'Sâm', 2000, N'Vĩnh Phúc', 0, 'TH2'),
('SV017', N'Hà Văn', N'Tú', 2000, N'Hải Dương', 0, 'TH2'),
-- Lớp KT1 (8 SV) - Khoa KT
('SV018', N'Đào Thị', N'Uyên', 2000, N'Hưng Yên', 1, 'KT1'), -- Lớp trưởng
('SV019', N'Vương Văn', N'Vinh', 2000, N'Thái Nguyên', 0, 'KT1'),
('SV020', N'Triệu Thị', N'Xuân', 2000, N'Lào Cai', 0, 'KT1'),
('SV021', N'Hoàng Văn', N'Yên', 2000, N'Hà Nội', 0, 'KT1'),
('SV022', N'Tô Văn', N'Bảo', 2000, N'Bắc Giang', 0, 'KT1'),
('SV023', N'Chu Thị', N'Châu', 2000, N'Lạng Sơn', 0, 'KT1'),
('SV024', N'Đinh Văn', N'Đức', 2000, N'Phú Thọ', 0, 'KT1'),
('SV025', N'Giang Văn', N'Hiệp', 2000, N'Sơn La', 0, 'KT1'),
-- Lớp KT2 (8 SV) - Khoa KT
('SV026', N'Hồ Thị', N'Hằng', 2001, N'Quảng Bình', 1, 'KT2'), -- Lớp trưởng
('SV027', N'Lưu Văn', N'Hoàng', 2001, N'Thanh Hóa', 0, 'KT2'),
('SV028', N'Mạc Văn', N'Khải', 2001, N'Hà Nội', 0, 'KT2'),
('SV029', N'Nguyễn Thị', N'Linh', 2001, N'Bắc Kạn', 0, 'KT2'),
('SV030', N'Phùng Văn', N'Mạnh', 2001, N'Cao Bằng', 0, 'KT2'),
('SV031', N'Quách Thị', N'Nga', 2001, N'Hòa Bình', 0, 'KT2'),
('SV032', N'Trần Văn', N'Nghĩa', 2001, N'Hà Nội', 0, 'KT2'),
('SV033', N'Tạ Văn', N'Phát', 2001, N'Tuyên Quang', 0, 'KT2'),
-- Lớp CK1 (8 SV) - Khoa CK
('SV034', N'Vi Thị', N'Quế', 2000, N'Yên Bái', 1, 'CK1'), -- Lớp trưởng
('SV035', N'Lò Văn', N'Rin', 2000, N'Điện Biên', 0, 'CK1'),
('SV036', N'Tống Văn', N'Sơn', 2000, N'Lai Châu', 0, 'CK1'),
('SV037', N'Uông Thị', N'Trà', 2000, N'Hà Nội', 0, 'CK1'),
('SV038', N'Vòng Văn', N'Thắng', 2000, N'Bình Định', 0, 'CK1'),
('SV039', N'Dương Văn', N'Uy', 2000, N'Phú Yên', 0, 'CK1'),
('SV040', N'Đàm Văn', N'Vũ', 2000, N'Khánh Hòa', 0, 'CK1'),
('SV041', N'Trần Hữu', N'Vinh', 2000, N'An Giang', 0, 'CK1');



-- Cập nhật giới tính cho từng sinh viên
UPDATE SINHVIEN SET Gioitinh = N'Nam' WHERE Masv IN ('SV001', 'SV003', 'SV005', 'SV007', 'SV009', 'SV011', 'SV012', 'SV014', 'SV016', 'SV017', 'SV019', 'SV021', 'SV022', 'SV024', 'SV025', 'SV027', 'SV028', 'SV030', 'SV032', 'SV033', 'SV035', 'SV036', 'SV038', 'SV039', 'SV040', 'SV041');

UPDATE SINHVIEN SET Gioitinh = N'Nữ' WHERE Masv IN ('SV002', 'SV004', 'SV006', 'SV008', 'SV010', 'SV013', 'SV015', 'SV018', 'SV020', 'SV023', 'SV026', 'SV029', 'SV031', 'SV034', 'SV037');


INSERT INTO CTHOC (Malop, HK, Mamh) VALUES
-- Chương trình học của TH1 (cho Câu 4, 8, 16, 18)
('TH1', 'HK1', 'MH001'), -- CSDL
('TH1', 'HK1', 'MH005'), -- Toán rời rạc
('TH1', 'HK2', 'MH002'), -- Web
('TH1', 'HK2', 'MH006'), -- CTDL (cho Câu 6, 16)
('TH1', 'HK3', 'MH007'), -- Mạng MT
('TH1', 'HK4', 'MH008'), -- HĐH
('TH1', 'HK5', 'MH009'), -- PTPM
('TH1', 'HK6', 'MH010'), -- ATTT (Đủ 6 học kỳ cho Câu 18)
-- Chương trình học của TH2 (cho Câu 17)
('TH2', 'HK1', 'MH001'), -- CSDL
('TH2', 'HK2', 'MH002'), -- Web
('TH2', 'HK2', 'MH006'), -- CTDL (cho Câu 17 - Học bổng)
-- Chương trình học của KT1
('KT1', 'HK1', 'MH003'); -- KT Vi mô

INSERT INTO DIEMSV (Masv, Mamh, Lan, Diem) VALUES
-- Dữ liệu điểm cho Lớp TH1
-- SV001 (An) - Đủ điều kiện tốt nghiệp (Câu 18)
('SV001', 'MH001', 1, 8.5), -- HK1: Đạt
('SV001', 'MH005', 1, 7.0), -- HK1: Đạt
('SV001', 'MH002', 1, 9.0), -- HK2: Đạt (cho Câu 16)
('SV001', 'MH006', 1, 8.0), -- HK2: Đạt (cho Câu 6, 16)
('SV001', 'MH007', 1, 7.5), -- HK3: Đạt
('SV001', 'MH008', 1, 4.0), -- HK4: Lần 1 Trượt (cho Câu 13, 14)
('SV001', 'MH008', 2, 7.0), -- HK4: Lần 2 Đạt (cho Câu 14)
('SV001', 'MH009', 1, 8.0), -- HK5: Đạt
('SV001', 'MH010', 1, 9.0), -- HK6: Đạt
-- SV002 (Bình) - Trượt tốt nghiệp (Câu 18), và thi lại CSDL
('SV002', 'MH001', 1, 4.0), -- Lần 1 Trượt CSDL (cho Câu 5, 13)
('SV002', 'MH001', 2, 6.0), -- Lần 2 Đạt CSDL (cho Câu 14)
('SV002', 'MH005', 1, 7.0),
('SV002', 'MH002', 1, 8.0), -- HK2 (cho Câu 16)
('SV002', 'MH006', 1, 4.5), -- HK2 Trượt (cho Câu 16 - SV này làm SV003 không đạt)
-- SV003 (Cường) - Có điểm CSDL cao (Câu 9)
('SV003', 'MH001', 1, 9.5), -- (cho Câu 5, 9)
('SV003', 'MH006', 1, 7.0), -- (cho Câu 6)
-- SV004 (Dung) - Có điểm CSDL cao (Câu 9)
('SV004', 'MH001', 1, 9.0), -- (cho Câu 5, 9)
('SV004', 'MH006', 1, 6.0), -- (cho Câu 6)
-- Dữ liệu điểm cho Lớp TH2 (cho Câu 15, 17)
-- SV010 (Lan) - Đạt học bổng HK2 (Câu 17)
('SV010', 'MH001', 1, 8.0), -- (cho Câu 15)
('SV010', 'MH002', 1, 9.0), -- HK2: Đạt
('SV010', 'MH006', 1, 8.5), -- HK2: Đạt
-- SV011 (Nam) - Trượt học bổng HK2 (Câu 17)
('SV011', 'MH001', 1, 7.0), -- (cho Câu 15)
('SV011', 'MH002', 1, 4.0), -- HK2: Trượt (cho Câu 13, 17)
('SV011', 'MH006', 1, 8.0), -- HK2: Đạt
-- SV012 (Minh)
('SV012', 'MH001', 1, 5.0), -- (cho Câu 15)
-- Dữ liệu điểm cho Lớp KT1
('SV018', 'MH003', 1, 4.5), -- (cho Câu 13 - Trượt môn KT Vi mô)
('SV019', 'MH003', 1, 4.0), -- (cho Câu 13 - Trượt môn KT Vi mô)
('SV020', 'MH003', 1, 8.0);