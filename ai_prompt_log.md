# AI Prompt Log - HealthSync Project

## Prompt 1: Tìm hiểu Anti-pattern trong thiết kế trạng thái
- **User:** "Trong thiết kế cơ sở dữ liệu quan hệ, tại sao việc dùng một cột is_active (kiểu TINYINT/BOOLEAN) để theo dõi vòng đời của một Đơn hàng/Lịch hẹn lại là một thiết kế tồi (Anti-pattern)? Tôi nên thay thế bằng cấu trúc nào?"
- **AI Response:** Giải thích rủi ro mất dấu vết trạng thái trung gian của Boolean và đề xuất sử dụng kiểu dữ liệu `ENUM` hoặc bảng tra cứu trạng thái (`Status Look-up Table`).

## Prompt 2: Chọn kiểu dữ liệu tài chính
- **User:** "Khi thiết kế cột deposit_amount và penalty_fee trong MySQL phục vụ tính toán tài chính, tôi nên dùng kiểu dữ liệu FLOAT, DOUBLE hay DECIMAL? Tại sao?"
- **AI Response:** Khuyên dùng `DECIMAL(10,2)` vì `FLOAT` và `DOUBLE` bị rủi ro làm tròn số do biểu diễn số thực dấu phẩy động (Floating point precision issue), không an toàn cho tính toán tiền tệ.

## Prompt 3: Cú pháp cập nhật bảng cũ
- **User:** "Hãy cho tôi xem cú pháp chuẩn trong MySQL để thêm một cột status với kiểu dữ liệu ENUM chứa các giá trị ('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED') vào một bảng có sẵn."
- **AI Response:** Cung cấp câu lệnh `ALTER TABLE Appointments ADD COLUMN status ENUM(...)` và hướng dẫn chuyển đổi an toàn dữ liệu.