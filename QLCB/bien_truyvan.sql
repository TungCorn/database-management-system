declare @x int, @y date, @z nchar(50);
set @x = 5;
set @y = '01/01/2005';
set @z = N'Lan';

print @x;

select @x = 7;   print @x;



declare @x nchar(100);
select @x = Hoten from tbCanBo
where SoTK = '4';

print 'Sinh vien co ten la: ' + @x;

declare @x int;
select @x = COUNT(SoTK) from tbCanBo
where GT = N'Nữ';

print N'Lớp 65KTPM có ' + CAST(@x as nvarchar(5)) + N' sinh viên';


-- tính số tuổi nhỏ nhất 
declare @x float, @y nvarchar(50);
select @x = min(Luong) from tbCanBo

print @x;

select @y = Hoten from tbCanBo
where Luong = @x;

print @y + N' có số tuổi là ' + cast(@x as nvarchar(5));