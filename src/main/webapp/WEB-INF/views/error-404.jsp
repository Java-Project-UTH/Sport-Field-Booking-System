<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Không tìm thấy trang - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
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
                <h1>404 - Không tìm thấy trang</h1>
                <p class="error-message">Trang bạn đang tìm kiếm không tồn tại hoặc đã bị di chuyển.</p>
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
