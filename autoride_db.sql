-- =================================================================
-- HỆ THỐNG AUTORIDE (OPTIMIZED DATABASE)
-- =================================================================

CREATE DATABASE IF NOT EXISTS autoride_db;
USE autoride_db;

-- 1. Bảng Cars
CREATE TABLE IF NOT EXISTS Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
);

-- 2. Bảng Rentals (Đã được cấu trúc lại)
-- Drop bảng nếu đang dùng DB cũ để tạo lại với cấu trúc chuẩn
DROP TABLE IF EXISTS Inspections;
DROP TABLE IF EXISTS Rentals;

CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME,
    
    -- Fix lỗi 1: Khóa chặt trạng thái bằng ENUM thay vì VARCHAR
    status ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED') DEFAULT 'BOOKED',
    
    -- Fix lỗi 2: Bổ sung các trường tài chính (Sử dụng DECIMAL để không sai số tiền tệ)
    security_deposit DECIMAL(10, 2) DEFAULT 0.00,
    late_fee DECIMAL(10, 2) DEFAULT 0.00,
    damage_fee DECIMAL(10, 2) DEFAULT 0.00,
    
    FOREIGN KEY (car_id) REFERENCES Cars(car_id)
);

-- 3. Bảng Inspections (Biên bản kiểm tra xe)
-- Fix lỗi 3: Tách bảng riêng để quản lý chi tiết hư hỏng
CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT,
    inspector_name VARCHAR(100) NOT NULL,
    
    -- Ràng buộc RESTRICT: Không cho phép xóa hợp đồng nếu đã có biên bản kiểm tra
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id) ON DELETE RESTRICT
);

-- =================================================================
-- VẬN HÀNH VÀ CHÉP LIỆU THỰC TẾ (DML)
-- =================================================================

-- Thêm một xe mẫu vào hệ thống
INSERT INTO Cars (model_name, license_plate) 
VALUES ('Toyota Vios', '30A-123.45');

-- Kịch bản 1: Khách hàng "Nguyen Van A" thuê xe, đóng cọc 10.000.000 VNĐ. Trạng thái ACTIVE.
INSERT INTO Rentals (car_id, customer_name, rent_date, status, security_deposit)
VALUES (1, 'Nguyen Van A', NOW(), 'ACTIVE', 10000000.00);

-- Kịch bản 2: Khách trả xe. Nhân viên kiểm tra phát hiện vỡ đèn pha.
-- Ghi nhận biên bản kiểm tra vào bảng Inspections
INSERT INTO Inspections (rental_id, inspection_date, damage_description, inspector_name)
VALUES (1, NOW(), 'Vỡ đèn pha trái', 'Nhân viên kiểm tra B');

-- Kịch bản 3: Cập nhật hợp đồng, trừ tiền đền bù
UPDATE Rentals
SET status = 'COMPLETED',
    return_date = NOW(),
    late_fee = 0.00,
    damage_fee = 2000000.00
WHERE rental_id = 1;

-- Kịch bản 4: Kế toán thực hiện truy vấn tính số tiền hoàn lại cho khách
SELECT 
    rental_id, 
    customer_name, 
    status,
    security_deposit, 
    late_fee, 
    damage_fee, 
    (security_deposit - late_fee - damage_fee) AS refund_amount
FROM Rentals
WHERE rental_id = 1;