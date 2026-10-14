# AI Prompt Log - Tối ưu CSDL AutoRide

## Câu hỏi 1: Lựa chọn kiểu dữ liệu lưu trữ tiền tệ
- **Prompt:** "Trong thiết kế cơ sở dữ liệu MySQL, tôi nên dùng kiểu FLOAT, DOUBLE hay DECIMAL để lưu trữ các cột tài chính như tiền cọc (security_deposit) và tiền đền bù (damage_fee)? Tại sao?"
- **AI Phản hồi:** AI khuyên sử dụng kiểu `DECIMAL(10,2)` (hoặc tương đương) để lưu trữ giá trị tiền tệ. Các kiểu dữ liệu dấu phẩy động như FLOAT hay DOUBLE lưu trữ số xấp xỉ nên dễ dẫn đến sai số khi tính toán cộng trừ nhân chia. Trong khi đó, `DECIMAL` lưu giá trị chính xác tuyệt đối, vốn là yêu cầu khắt khe và bắt buộc của mọi hệ thống liên quan đến kế toán, tài chính.

## Câu hỏi 2: Chiến lược xóa dữ liệu khóa ngoại
- **Prompt:** "Khi tạo khóa ngoại giữa bảng Inspections và bảng Rentals, tôi có nên dùng ON DELETE CASCADE không? Hay dùng cấu trúc nào khác?"
- **AI Phản hồi:** AI phân tích không nên dùng `CASCADE`. Bảng Inspections lưu trữ biên bản kiểm tra liên quan đến đền bù tài chính. Nếu dùng `CASCADE`, khi xóa một bản ghi thuê xe (Rentals), biên bản kiểm tra cũng sẽ tự động bốc hơi, làm mất dấu vết kiểm toán. AI đề xuất sử dụng `ON DELETE RESTRICT` để khóa chặt bản ghi: ngăn chặn bất kỳ ai xóa hợp đồng thuê xe nếu hợp đồng đó đã có biên bản kiểm tra lưu trong hệ thống.