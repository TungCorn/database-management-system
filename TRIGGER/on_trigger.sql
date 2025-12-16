-- Câu 7. Tạo Trigger để đảm bảo rằng khi thêm một loại mặt hàng vào bảng LoaiHang
-- thì tên loại mặt hàng thêm vào phải chưa có trong bảng. Nếu người dùng nhập một tên
-- loại mặt hàng đã có trong danh sách thì báo lỗi.
-- Thử thêm một loại mặt hàng vào trong bảng
























    create trigger them_hang
    on LoaiHang
    for insert
    as
        begin
            select TenLoaiHang
            from inserted
            where TenLoaiHang in (select TenLoaiHang
                                  from LoaiHang
                                  )
            print 'Ten da ton tai'
            rollback transaction
        end

        insert into LoaiHang ( TenLoaiHang) values ( N'Sách')


-- Câu 8. Tạo Trigger để đảm bảo rằng khi sửa một loại mặt hàng trong bảng LoaiHang
-- thì tên loại mặt hàng sau khi sửa phải khác tên loai mặt hàng trước khi sửa và tên loại
-- mặt hàng sau khi sửa không trùng với tên các loại hàng đã có trong bảng. Nếu vi phạm
-- thì thông báo lỗi.

    alter trigger edit_hang
    on LoaiHang
    for update
    as
        begin
            if exists (select 1
                       from inserted
                       where TenLoaiHang in (select TenLoaiHang
                                             from deleted))
                begin
                    print 'Ten khong duoc trung voi ten truoc do'
                    rollback transaction
                end

             else if exists (
                           select 1
                           from inserted i
                           join LoaiHang l on i.TenLoaiHang = l.TenLoaiHang
                           where i.IDLoaiHang != l.IDLoaiHang
                           )
                    begin
                        print 'Ten da ton tai'
                        rollback transaction
                    end
        end

        update LoaiHang set TenLoaiHang = N'tungcorn' where IDLoaiHang = 7

        drop trigger edit_hang

-- Câu 9. Tạo Trigger để khi xóa một nhà cung cấp trong bảng NhaCungCap thì thay vì
-- xóa nhà cung cấp đó sẽ thực hiện cập nhật trường ConGiaoDich = 0 đối với nhà cung
-- cấp đó và cập nhật bảng SanPham để thiết lập NgungBan = 1 với tất cả các sản phẩm
-- của nhà cung cấp bị xóa đi.


alter trigger delete_ncc
    on NhaCungCap
    instead of delete
    as
        begin
            update NhaCungCap
            set ConGiaoDich = 0
            where IDNhaCungCap in (select IDNhaCungCap
                                   from deleted
                                   )
            update SanPham
            set NgungBan = 1
            where IDNhaCungCap in (select IDNhaCungCap
                                   from deleted
                                   )
            print 'da cap nhat'
        end

        delete from NhaCungCap where IDNhaCungCap = 10
