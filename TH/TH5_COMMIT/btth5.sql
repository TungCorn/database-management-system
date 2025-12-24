create table KHO (
    IDSanPham int primary key,
    TenSP nvarchar(100),
    Stock int,
)


INSERT INTO KHO VALUES (1, 'iPhone 15', 10);
INSERT INTO KHO VALUES (2, 'Samsung S23', 20);

create table NganHang (
    IDTaiKhoan int primary key,
    SoDu money
);

insert into NganHang values (1, 1000);
insert into NganHang values (2, 2000);
insert into NganHang values (3, 3000);

