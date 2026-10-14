Khi sử dụng `LEFT JOIN`, các bản ghi ở bảng bên trái (ví dụ: `Customers`) không có dữ liệu khớp ở bảng bên phải (`Orders`) vẫn được giữ lại, nhưng các cột của bảng bên phải sẽ nhận giá trị `NULL`.

Nếu ta dùng `COUNT(*)`, hàm này sẽ đếm tổng số dòng (row) được trả về. Do đó, một khách hàng không có đơn hàng nào vẫn sẽ hiển thị 1 dòng (với các cột `NULL` từ bảng `Orders`), dẫn đến kết quả số lượng đơn là 1 - điều này là sai.

Ngược lại, `COUNT(o.order_id)` chỉ đếm các giá trị KHÁC `NULL` trong cột `order_id` của bảng liên kết. Vì khách hàng chưa từng mua hàng sẽ có `o.order_id` là `NULL`, hàm `COUNT(o.order_id)` sẽ bỏ qua và trả về chính xác là 0.