-- Tạo cơ sở dữ liệu
CREATE DATABASE IF NOT EXISTS sportsfieldboookingsystem;
USE sportsfieldboookingsystem;

-- Tạo bảng users
CREATE TABLE IF NOT EXISTS users (
    username VARCHAR(255) NOT NULL PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone_number VARCHAR(255) NOT NULL,
    age INT,
    gender VARCHAR(255),
    address VARCHAR(255),
    role VARCHAR(10) DEFAULT 'USER' NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL
);

-- Tạo bảng sports_fields
CREATE TABLE IF NOT EXISTS sports_fields (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    field_name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    field_type ENUM('FOOTBALL', 'BASKETBALL', 'TENNIS', 'BADMINTON', 'VOLLEYBALL', 'SWIMMING') NOT NULL,
    price_per_hour FLOAT NOT NULL,
    is_indoor BOOLEAN NOT NULL,
    has_lighting BOOLEAN NOT NULL,
    description TEXT,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL
);

-- Tạo bảng field_bookings
CREATE TABLE IF NOT EXISTS field_bookings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    field_id BIGINT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    total_price FLOAT NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') NOT NULL DEFAULT 'PENDING',
    notes TEXT,
    number_of_players INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (username) REFERENCES users(username),
    FOREIGN KEY (field_id) REFERENCES sports_fields(id)
);

-- Tạo bảng reviews
CREATE TABLE IF NOT EXISTS reviews (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    field_id BIGINT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (username) REFERENCES users(username),
    FOREIGN KEY (field_id) REFERENCES sports_fields(id)
);

-- Thêm dữ liệu mẫu cho bảng sports_fields
INSERT INTO sports_fields (field_name, location, field_type, price_per_hour, is_indoor, has_lighting, description, image_url)
VALUES
('Sân bóng đá Mini Thống Nhất', 'Quận 1, TP.HCM', 'FOOTBALL', 300000, false, true, 'Sân bóng đá mini 5 người với mặt cỏ nhân tạo chất lượng cao', '/images1/football1.jpg'),
('Sân Tennis Phú Nhuận', 'Quận Phú Nhuận, TP.HCM', 'TENNIS', 200000, false, true, 'Sân tennis tiêu chuẩn quốc tế với mặt sân cứng', '/images1/tennis1.jpg'),
('Sân Cầu Lông Rạch Miễu', 'Quận Phú Nhuận, TP.HCM', 'BADMINTON', 100000, true, true, 'Sân cầu lông trong nhà với 4 sân tiêu chuẩn', '/images1/badminton1.jpg'),
('Sân Bóng Rổ Tân Bình', 'Quận Tân Bình, TP.HCM', 'BASKETBALL', 250000, false, true, 'Sân bóng rổ ngoài trời với mặt sân cao su đặc biệt', '/images1/basketball1.jpg'),
('Sân Bóng Chuyền Bình Thạnh', 'Quận Bình Thạnh, TP.HCM', 'VOLLEYBALL', 150000, false, true, 'Sân bóng chuyền tiêu chuẩn với cát biển sạch', '/images1/volleyball1.jpg'),
('Hồ Bơi Lam Sơn', 'Quận 5, TP.HCM', 'SWIMMING', 80000, true, false, 'Hồ bơi trong nhà với nước ấm và hệ thống lọc hiện đại', '/images1/swimming1.jpg'),
('Sân bóng đá Thành Phát', 'Quận 7, TP.HCM', 'FOOTBALL', 350000, false, true, 'Sân bóng đá 7 người với mặt cỏ nhân tạo và hệ thống đèn chiếu sáng hiện đại', '/images1/football2.jpg'),
('Sân Tennis Hoa Lư', 'Quận 1, TP.HCM', 'TENNIS', 250000, false, true, 'Sân tennis lịch sử với mặt sân đất nện', '/images1/tennis2.jpg'),
('Sân Cầu Lông Thăng Long', 'Quận 10, TP.HCM', 'BADMINTON', 120000, true, true, 'Sân cầu lông trong nhà với 6 sân tiêu chuẩn và điều hòa', '/images1/badminton2.jpg'),
('Sân Bóng Rổ Phú Mỹ Hưng', 'Quận 7, TP.HCM', 'BASKETBALL', 300000, true, true, 'Sân bóng rổ trong nhà với mặt sân gỗ cao cấp', '/images1/basketball2.jpg'),
('Sân Bóng Chuyền Quận 3', 'Quận 3, TP.HCM', 'VOLLEYBALL', 180000, false, true, 'Sân bóng chuyền ngoài trời với cát biển cao cấp', '/images1/volleyball2.jpg'),
('Hồ Bơi Phú Mỹ Hưng', 'Quận 7, TP.HCM', 'SWIMMING', 120000, true, true, 'Hồ bơi Olympic với 8 làn bơi và hệ thống lọc hiện đại', '/images1/swimming2.jpg'),
('Sân Pickleball Thủ Đức', 'TP. Thủ Đức, TP.HCM', 'TENNIS', 150000, true, true, 'Sân Pickleball tiêu chuẩn quốc tế với mặt sân chuyên dụng', '/images1/pickleball1.jpg'),
('Sân Pickleball Quận 2', 'Quận 2, TP.HCM', 'TENNIS', 180000, true, true, 'Sân Pickleball trong nhà với 4 sân tiêu chuẩn', '/images1/pickleball2.jpg');


-- tài khoản admin có sẳn trong datainitializer rồi nên không cần add nữa


# -- Tạo tài khoản admin mẫu (mật khẩu: admin123) nếu chưa tồn tại
# INSERT INTO users (username, password, name, email, phone_number, age, gender, address, role)
# SELECT 'admin', '$2a$10$3NOQGqlV8RRQrj5nDUd6suNkX5.fzO7t3UYfC4Zl.MjFk0mnd6AG2', 'Admin', 'admin@example.com', '0123456789', 30, 'Nam', 'TP.HCM', 'ADMIN'
# FROM dual
# WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin');
#
# -- Tạo tài khoản admin2 mẫu (mật khẩu: admin123) nếu chưa tồn tại
# INSERT INTO users (username, password, name, email, phone_number, age, gender, address, role)
# SELECT 'admin2', '$2a$10$3NOQGqlV8RRQrj5nDUd6suNkX5.fzO7t3UYfC4Zl.MjFk0mnd6AG2', 'Admin 2', 'admin2@example.com', '0987654321', 28, 'Nam', 'TP.HCM', 'ADMIN'
# FROM dual
# WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin2');
