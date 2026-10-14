# Consistency Report - HealthSync Database Optimization

Báo cáo phân tích chỉ ra 3 điểm "vênh" nghiêm trọng nhất giữa quy trình nghiệp vụ (Activity Diagram) và thiết kế cơ sở dữ liệu cũ (Legacy Schema):

1. **Sai lệch cấu trúc quản lý trạng thái lịch hẹn:**
   - *Thiết kế cũ:* Sử dụng cột `is_active` kiểu `BOOLEAN` chỉ quản lý được 2 trạng thái (Đúng/Sai).
   - *Nghiệp vụ thực tế:* Lịch hẹn trải qua vòng đời 5 trạng thái (`PENDING` -> `CONFIRMED` -> `CHECKED_IN` -> `COMPLETED` / `CANCELLED`). Việc dùng Boolean khiến hệ thống không thể theo dõi tiến trình khám bệnh.
   - *Khắc phục:* Thay thế bằng cột `status` kiểu `ENUM`.

2. **Thiếu hụt dữ liệu tài chính & xử lý vi phạm:**
   - *Thiết kế cũ:* Không có các trường lưu vết dòng tiền cọc và phí phạt khi hủy lịch.
   - *Nghiệp vụ thực tế:* Bệnh nhân phải đóng cọc (`deposit_amount`), nếu hủy sau khi `CONFIRMED` sẽ chịu phạt (`penalty_fee`) trừ vào cọc kèm lý do (`cancel_reason`). Thiếu các thuộc tính này gây thất thoát và không thể đối soát kế toán.
   - *Khắc phục:* Bổ sung các cột `deposit_amount`, `penalty_fee` kiểu `DECIMAL(10,2)` và `cancel_reason`.

3. **Thiếu hoàn toàn thực thể Đơn thuốc (Prescriptions):**
   - *Thiết kế cũ:* Bác sĩ không có nơi để lưu kết quả khám và đơn thuốc.
   - *Nghiệp vụ thực tế:* Khi lịch hẹn đạt trạng thái `COMPLETED`, bác sĩ phải kê đơn thuốc liên kết với lịch hẹn đó.
   - *Khắc phục:* Tạo bảng mới `Prescriptions` liên kết với `Appointments` qua khóa ngoại `appointment_id`.