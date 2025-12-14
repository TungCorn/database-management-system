ALTER trigger TRIG1
    on LOP
    for insert
    as
    begin
        declare dsmalop cursor dynamic scroll
            for
            select Malop
            from inserted
        open dsmalop
        declare @ml varchar(50);
        fetch next from dsmalop into @ml;
        while @@fetch_status = 0
            begin
                print 'Ban da them lop ' + @ml + ' thanh cong'
                fetch next from dsmalop into @ml;
            end

        close dsmalop;
        deallocate dsmalop;
    end
    insert into LOP (Malop, Makh)
    values ('TH40', 'CNTT'),
           ('TH39', 'CNTT')
    drop trigger if exists TRIG1
    CREATE TRIGGER trig_del
        on DIEMSV
        for delete
        as
    begin
        print 'du lieu da bi xoa'
    end
        delete
        from DIEMSV
        where Masv = 'SV020'
        create trigger trig_update
            on DIEMSV
            for update
            as
        begin
            print 'da cap nhat'
        end
            update DIEMSV
            set Diem = 9
            where Masv = 'SV021'
              and Mamh = 'CSDL'


-- trigger for insert, update, delete
            create trigger insert_update_delete_trig
                on SINHVIEN
                for insert, update, delete
                as
            begin
                if exists (select *
                           from inserted)
                    and exists (select *
                                from deleted)
                    print 'Record Updated'
                else
                    if exists (select *
                               from inserted)
                        print 'Record Inserted'
                    else
                        if exists (select *
                                   from deleted)
                            print 'Record Deleted'
            end
                update SINHVIEN
                set Tensv = 'Beo'
                where Masv = 'SV007'

--

                alter trigger update_sv
                    on SINHVIEN
                    for update, insert
                    as
                    begin
                        if exists(select l.Malop
                                  from LOP l
                                  where l.Malop in (select Malop
                                                    from inserted
                                                    union
                                                    select Malop
                                                    from deleted)
                                    and (select count(*)
                                         from SINHVIEN sv
                                         where sv.Malop = l.Malop) > 10)
                            begin
                                print 'Khong the them/capnhat sinh vien vi so luong sinh vien lop se qua 10';
                                rollback transaction;
                            end
                        else
                            begin
                                print 'Cap nhat/ them sinh vien thanh cong';
                            end
                    end
                    insert SINHVIEN (Masv, Tensv, Malop)
                    values ('SV051', 'Nguyen Van A', 'TH1'),
                           ('SV052', 'Tran Thi B', 'TH1'),
                           ('SV053', 'Le Van C', 'TH1'),
                           ('SV054', 'Pham Thi D', 'TH1'),
                           ('SV055', 'Hoang Van E', 'TH1'),
                           ('SV056', 'Vu Thi F', 'TH1'),
                           ('SV057', 'Dang Van G', 'TH2'),
                           ('SV058', 'Bui Thi H', 'TH2'),
                           ('SV059', 'Do Van I', 'TH2'),
                           ('SV060', 'Phan Thi K', 'CK1')
                    update SINHVIEN
                    set Malop = 'TH1'
                    where Masv = 'SV011'
                    select count(*) as SoLuongSVLop
                    from SINHVIEN
                    group by SINHVIEN.Malop
                    alter table SINHVIEN
                        add GhiChu nvarchar(500)

--viet trigger instead of de thay vi xoa thi se cap nhat cot Ghichu
                    alter trigger trg_instead_of_delete
                        on SINHVIEN
                        instead of delete
                        as
                        begin
                            update SINHVIEN
                            set GhiChu = 'Sinh vien bi xoa'
                            where Masv in (select Masv from deleted)
                        end
                        delete
                        from SINHVIEN
                        where Masv = 'SV100'

--viet 1 trigger de tu dong cap nhat gia tri cua cot diemtk khi co su thay doi ve diem cua sinh vien do

                        ALTER TRIGGER trg_update_diemtk
                            ON DIEMSV
                            FOR INSERT, UPDATE
                            AS
                            BEGIN
                                UPDATE SINHVIEN
                                SET diemtk = (SELECT AVG(DiemCaoNhat)
                                              FROM (SELECT MAX(d.Diem) as DiemCaoNhat
                                                    FROM DIEMSV d
                                                    WHERE d.Masv = SINHVIEN.Masv
                                                    GROUP BY d.Mamh) maxdiem)
                                WHERE Masv IN (SELECT DISTINCT Masv FROM inserted)
                            END


                            update DIEMSV
                            set Diem = 10
                            where Masv = 'SV019'
                              and Mamh = 'MH003'
                              and Lan = 1


                            SELECT d.Masv, d.Mamh, MAX(d.Diem) as DiemCaoNhat
                            FROM DIEMSV d
                            GROUP BY d.Mamh, d.Masv