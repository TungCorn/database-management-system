create database QLSV
use QLSV

create table KHOA (
	Makh varchar(50) primary key,
	Vpkh nvarchar(150) 
)

create table LOP (
	Malop varchar(50) primary key,
	Makh varchar(50) ,
	foreign key (Makh) references KHOA(Makh)
	
)

create table SINHVIEN(
	Masv varchar(50) primary key,
	Hosv nvarchar(100),
	Tensv nvarchar(100),
	Nssv int,
	Dcsv nvarchar(150),
	Loptr int,
	Malop varchar(50),
	foreign key (Malop) references LOP(Malop)
)

ALTER TABLE SINHVIEN
    ADD Gioitinh NVARCHAR(10);

create unique index kt_lop_truong
on SINHVIEN(Malop)
where Loptr = 1

create table MONHOC (
	Mamh varchar(50) primary key,
	Tenmh nvarchar(150),
	LT int,
	TH int
)

create table CTHOC (
	Malop varchar(50),
	HK varchar(10),
	Mamh varchar(50),
	foreign key (Malop) references LOP(Malop),
	foreign key (Mamh) references MONHOC(Mamh)
)

create table DIEMSV (
	Masv varchar(50),
	Mamh varchar(50),
	Lan int,
	Diem float,
	foreign key (Masv) references SINHVIEN(Masv),
	foreign key (Mamh) references MONHOC(Mamh)
)