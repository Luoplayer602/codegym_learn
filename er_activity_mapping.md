# ER - Activity Mapping: Chẩn đoán sự cố dữ liệu AutoRide

Cột `damage_fee` (phí đền bù hư hỏng) là bắt buộc phải có để đảm bảo tính toàn vẹn của hệ thống cũng như quy trình kế toán tài chính. 

Trong thực tế (theo nhánh rẽ của Activity Diagram), khi khách hàng trả xe mà xe bị hư hỏng, hệ thống phải yêu cầu đền bù một khoản phí tương ứng. Khoản phí này sẽ được kế toán trừ trực tiếp vào tiền cọc ban đầu (`security_deposit`) để tính toán ra số tiền thực tế cần hoàn lại cho khách (`refund_amount`). 

Việc thiết kế Database cũ (Legacy ERD) thiếu vắng cột này khiến hệ thống bị "mù thông tin" về dòng tiền phạt. Điều này dẫn đến kế toán không thể hạch toán tự động trên phần mềm, đành phải xuất trả đủ cọc hoặc ghi chép tay ra sổ sách bên ngoài, gây thất thoát doanh thu (bốc hơi lợi nhuận). Do đó, bổ sung cột `damage_fee` là điều kiện tiên quyết để Database có thể phục vụ và lưu vết đúng 100% tiến trình hoạt động thực tế của quy trình thuê - trả xe.