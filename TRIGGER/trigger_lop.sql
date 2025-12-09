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

update SINHVIEN set Tensv = 'Beo' where Masv = 'SV007'