-- 1. Khởi tạo và sử dụng Cơ sở dữ liệu
CREATE DATABASE IF NOT EXISTS healthsync_db;
USE healthsync_db;

-- 2. Tạo bảng Bệnh nhân (Patients)
CREATE TABLE IF NOT EXISTS Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
);

-- 3. Tạo bảng Bác sĩ (Doctors)
CREATE TABLE IF NOT EXISTS Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50)
);

-- 4. Tạo bảng Lịch hẹn (Appointments) - Đã tái cấu trúc chuẩn hóa nghiệp vụ
CREATE TABLE IF NOT EXISTS Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    
    -- Thay thế is_active bằng trạng thái vòng đời đa cấp (Lifecycle Status)
    status ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    
    -- Bổ sung thông tin tài chính và lý do hủy
    deposit_amount DECIMAL(10, 2) DEFAULT 0.00,
    penalty_fee DECIMAL(10, 2) DEFAULT 0.00,
    cancel_reason VARCHAR(255) DEFAULT NULL,
    
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- 5. Tạo bảng Đơn thuốc (Prescriptions) - Mới hoàn toàn
CREATE TABLE IF NOT EXISTS Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE, -- Quan hệ 1-1 với lịch hẹn đã hoàn thành
    medication_details TEXT NOT NULL,
    issued_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE
);

-- =================================================================
-- KỊCH BẢN THỰC THI DỮ LIỆU MÔ PHỎNG (DML)
-- =================================================================

-- Thêm dữ liệu mẫu ban đầu
INSERT INTO Patients (full_name, phone) VALUES 
('Nguyen Van A', '0901234567'),
('Tran Thi B', '0912345678');

INSERT INTO Doctors (full_name, specialty) VALUES 
('BS. Le Van C', 'Tim mach'),
('BS. Pham Thi D', 'Nhi khoa');

-- KỊCH BẢN 1: Luồng khám thành công (COMPLETED)
-- 1.1 Tạo lịch hẹn PENDING cọc 500.000đ
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (1, 1, '2026-10-20 09:00:00', 'PENDING', 500000.00);

-- 1.2 Bệnh nhân đến khám -> Cập nhật CHECKED_IN -> Khám xong COMPLETED
UPDATE Appointments 
SET status = 'COMPLETED' 
WHERE appointment_id = 1;

-- 1.3 Bác sĩ kê đơn thuốc
INSERT INTO Prescriptions (appointment_id, medication_details)
VALUES (1, 'Paracetamol 500mg - Ngày 2 viên; Vitamin C - Ngày 1 viên');


-- KỊCH BẢN 2: Luồng Hủy lịch và Phạt tiền cọc (CANCELLED + Penalty)
-- 2.1 Tạo lịch hẹn đã CONFIRMED cọc 300.000đ
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (2, 2, '2026-10-21 14:00:00', 'CONFIRMED', 300000.00);

-- 2.2 Bệnh nhân báo hủy -> Cập nhật CANCELLED, ghi lý do và phạt 150.000đ
UPDATE Appointments 
SET status = 'CANCELLED',
    cancel_reason = 'Ban viec dot xuat',
    penalty_fee = 150000.00
WHERE appointment_id = 2;

-- Truy vấn kiểm tra kết quả danh sách khám hoàn tất kèm đơn thuốc
SELECT 
    a.appointment_id, 
    p.full_name AS patient_name, 
    d.full_name AS doctor_name, 
    a.status, 
    a.deposit_amount, 
    pr.medication_details
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
LEFT JOIN Prescriptions pr ON a.appointment_id = pr.appointment_id;