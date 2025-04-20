<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lỗi - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        .error-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .error-content {
            text-align: center;
        }

        .error-content h1 {
            color: #e53935;
            margin-bottom: 20px;
        }

        .error-message {
            font-size: 18px;
            color: #555;
            margin-bottom: 30px;
        }

        .error-details {
            text-align: left;
            background-color: #f5f5f5;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 30px;
        }

        .error-details p {
            font-weight: bold;
            margin-bottom: 10px;
        }

        .error-details ul {
            padding-left: 20px;
        }

        .error-details li {
            margin-bottom: 8px;
        }

        .error-actions {
            display: flex;
            justify-content: center;
            gap: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="navbar">
            <div class="navbar-brand">Sports Field Booking</div>
            <ul class="navbar-links">
                <li><a href="/">Trang chủ</a></li>
                <li><a href="/fields">Sân thể thao</a></li>
            </ul>
            <div class="navbar-account">
                <c:if test="${empty loggedUser}">
                    <a href="/login">Đăng nhập</a> | <a href="/register">Đăng ký</a>
                </c:if>
                <c:if test="${not empty loggedUser}">
                    <span>Xin chào, ${loggedUser}</span> | <a href="/logout">Đăng xuất</a>
                </c:if>
            </div>
        </div>

        <div class="error-container">
            <div class="error-content">
                <h1>Đã xảy ra lỗi</h1>
                <p class="error-message">${errorMessage != null ? errorMessage : 'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại sau.'}</p>

                <div class="error-details">
                    <p>Nếu bạn đang cố gắng đặt sân, vui lòng kiểm tra:</p>
                    <ul>
                        <li>Thời gian bắt đầu phải sau thời điểm hiện tại</li>
                        <li>Thời gian kết thúc phải sau thời gian bắt đầu</li>
                        <li>Sân có thể đã được đặt trong khoảng thời gian bạn chọn</li>
                        <li>Định dạng ngày giờ phải hợp lệ</li>
                    </ul>
                </div>

                <div class="error-actions">
                    <a href="javascript:history.back()" class="btn btn-secondary">Quay lại</a>
                    <a href="/" class="btn btn-primary">Về trang chủ</a>
                </div>
            </div>
        </div>
    </div>

    <script src="/js/script.js"></script>
</body>
</html>
