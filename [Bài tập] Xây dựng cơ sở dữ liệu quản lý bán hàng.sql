-- 1. Tạo cơ sở dữ liệu
CREATE DATABASE IF NOT EXISTS QuanLyBanHang;

-- 2. Chọn cơ sở dữ liệu để thao tác
USE QuanLyBanHang;

-- 3. Tạo bảng Customer (Khách hàng)
CREATE TABLE Customer (
    cID INT AUTO_INCREMENT PRIMARY KEY,
    cName VARCHAR(50) NOT NULL,
    cAge INT
);

-- 4. Tạo bảng Order (Hóa đơn)
-- Lưu ý: Từ khóa 'Order' là một từ khóa hệ thống trong SQL, nên dùng backtick (`) để bao quanh tên bảng
CREATE TABLE `Order` (
    oID INT AUTO_INCREMENT PRIMARY KEY,
    cID INT NOT NULL,
    oDate DATETIME NOT NULL,
    oTotalPrice DECIMAL(10, 2),
    FOREIGN KEY (cID) REFERENCES Customer(cID)
);

-- 5. Tạo bảng Product (Sản phẩm)
CREATE TABLE Product (
    pID INT AUTO_INCREMENT PRIMARY KEY,
    pName VARCHAR(100) NOT NULL,
    pPrice DECIMAL(10, 2) NOT NULL
);

-- 6. Tạo bảng OrderDetail (Chi tiết hóa đơn)
CREATE TABLE OrderDetail (
    oID INT,
    pID INT,
    odQTY INT NOT NULL CHECK (odQTY > 0),
    PRIMARY KEY (oID, pID),
    FOREIGN KEY (oID) REFERENCES `Order`(oID),
    FOREIGN KEY (pID) REFERENCES Product(pID)
);