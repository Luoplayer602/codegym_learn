-- HỆ THỐNG FLASHMART
CREATE DATABASE IF NOT EXISTS flashmart_db; 
USE flashmart_db;

-- 1. Tạo bảng và chèn dữ liệu mẫu
CREATE TABLE IF NOT EXISTS Customers (customer_id INT PRIMARY KEY, name VARCHAR(50));
CREATE TABLE IF NOT EXISTS Products (product_id INT PRIMARY KEY, product_name VARCHAR(50));
CREATE TABLE IF NOT EXISTS Orders (order_id INT PRIMARY KEY, customer_id INT, product_id INT);

-- Xóa dữ liệu cũ nếu chạy lại script nhiều lần
TRUNCATE TABLE Orders;
TRUNCATE TABLE Customers;
TRUNCATE TABLE Products;

-- Chèn dữ liệu
INSERT INTO Customers VALUES (1, 'Alice'), (2, 'Bob'), (3, 'Charlie'); 
-- Chú ý: Charlie chưa từng mua hàng

INSERT INTO Products VALUES (101, 'Laptop'), (102, 'Mouse'), (103, 'Keyboard'); 
-- Chú ý: Keyboard chưa từng được ai mua

INSERT INTO Orders VALUES (1001, 1, 101), (1002, 1, 102), (1003, 2, 101);

-- ========================================================
-- BÁO CÁO 1 : Báo cáo cho Marketing (Đã sửa lỗi Mất tích Charlie)
-- Dùng LEFT JOIN để lấy tất cả khách hàng (kể cả người chưa mua)
-- ========================================================
SELECT c.customer_id, c.name, COUNT(o.order_id) as total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- ========================================================
-- BÁO CÁO 2 : Báo cáo cho Kho vận (Đã sửa lỗi Không tìm thấy Keyboard)
-- Dùng LEFT JOIN kết hợp IS NULL (Anti-Join) để lấy sản phẩm chưa bán được
-- ========================================================
SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;