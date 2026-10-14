# Nhật ký hỏi đáp lý thuyết JOIN với AI

**Học viên:** Trong cơ sở dữ liệu MySQL, mặc định từ khóa JOIN (khi không ghi rõ LEFT hay RIGHT) sẽ hoạt động như thế nào? Nó sẽ bỏ qua hay giữ lại các bản ghi không có sự trùng khớp ở cả hai bảng?
**AI:** Mặc định từ khóa `JOIN` (tương đương với `INNER JOIN`) sẽ chỉ trả về các bản ghi có sự trùng khớp ở CẢ HAI bảng. Bất kỳ bản ghi nào ở bảng này mà không có dữ liệu tương ứng ở bảng kia sẽ bị loại bỏ hoàn toàn khỏi kết quả cuối cùng.

**Học viên:** Khi tôi sử dụng LEFT JOIN và đếm số lượng đơn hàng bằng hàm COUNT, tôi nên dùng `COUNT(*)` hay `COUNT(o.order_id)`? Sự khác biệt khi kết quả trả về NULL là gì?
**AI:** Bạn phải dùng `COUNT(o.order_id)`. `COUNT(*)` đếm tổng số dòng, nên nếu LEFT JOIN sinh ra một dòng NULL cho bảng phụ, nó vẫn đếm dòng đó là 1. Trong khi đó, `COUNT(o.order_id)` chỉ đếm các giá trị khác NULL, giúp trả về chính xác số 0 cho các bản ghi không có liên kết bên bảng Orders.

**Học viên:** Có cú pháp SQL nào cho phép tôi kết hợp kết quả của một LEFT JOIN và một RIGHT JOIN để giả lập tính năng FULL OUTER JOIN trong MySQL không?
**AI:** Có. MySQL không hỗ trợ trực tiếp từ khóa `FULL OUTER JOIN`, nhưng bạn có thể giả lập nó bằng cách sử dụng toán tử `UNION` kết hợp kết quả của một câu lệnh `LEFT JOIN` và một câu lệnh `RIGHT JOIN`.