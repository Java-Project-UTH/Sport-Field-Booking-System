-- Bảng lưu trữ sân yêu thích của người dùng
CREATE TABLE IF NOT EXISTS favorites (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    field_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_favorites_user FOREIGN KEY (user_id) REFERENCES users(username) ON DELETE CASCADE,
    CONSTRAINT fk_favorites_field FOREIGN KEY (field_id) REFERENCES sports_fields(id) ON DELETE CASCADE,
    CONSTRAINT uk_favorites_user_field UNIQUE (user_id, field_id)
);

-- Bảng lưu trữ các gói thành viên
CREATE TABLE IF NOT EXISTS membership_plans (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    plan_type VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price FLOAT NOT NULL,
    duration_days INT NOT NULL,
    max_bookings_per_month INT NOT NULL,
    max_booking_days_in_advance INT NOT NULL,
    discount_percentage FLOAT NOT NULL,
    priority_support BOOLEAN NOT NULL,
    free_rescheduling BOOLEAN NOT NULL
);

-- Bảng lưu trữ thông tin gói thành viên của người dùng
CREATE TABLE IF NOT EXISTS user_memberships (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    plan_id BIGINT NOT NULL,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    bookings_used_this_month INT NOT NULL DEFAULT 0,
    payment_reference VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_memberships_user FOREIGN KEY (user_id) REFERENCES users(username) ON DELETE CASCADE,
    CONSTRAINT fk_user_memberships_plan FOREIGN KEY (plan_id) REFERENCES membership_plans(id)
);

-- Dữ liệu mẫu cho các gói thành viên
INSERT INTO membership_plans (plan_type, name, description, price, duration_days, max_bookings_per_month, max_booking_days_in_advance, discount_percentage, priority_support, free_rescheduling)
VALUES 
    ('FREE', 'Gói Miễn Phí', 'Gói cơ bản dành cho người mới bắt đầu', 0, 2147483647, 5, 3, 0, FALSE, FALSE),
    ('STANDARD', 'Gói Tiêu Chuẩn', 'Gói phổ biến với nhiều quyền lợi hơn', 200000, 30, 15, 7, 5, FALSE, TRUE),
    ('PREMIUM', 'Gói Cao Cấp', 'Gói cao cấp với đầy đủ quyền lợi', 500000, 30, 30, 14, 10, TRUE, TRUE)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    description = VALUES(description),
    price = VALUES(price),
    duration_days = VALUES(duration_days),
    max_bookings_per_month = VALUES(max_bookings_per_month),
    max_booking_days_in_advance = VALUES(max_booking_days_in_advance),
    discount_percentage = VALUES(discount_percentage),
    priority_support = VALUES(priority_support),
    free_rescheduling = VALUES(free_rescheduling);

-- Gán gói miễn phí cho tất cả người dùng hiện tại chưa có gói thành viên
INSERT INTO user_memberships (user_id, plan_id, start_date, end_date, is_active, bookings_used_this_month, payment_reference)
SELECT 
    u.username, 
    (SELECT id FROM membership_plans WHERE plan_type = 'FREE'), 
    CURRENT_TIMESTAMP, 
    DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 100 YEAR), 
    TRUE, 
    0, 
    'DEFAULT_FREE_PLAN'
FROM 
    users u
WHERE 
    NOT EXISTS (SELECT 1 FROM user_memberships um WHERE um.user_id = u.username);
