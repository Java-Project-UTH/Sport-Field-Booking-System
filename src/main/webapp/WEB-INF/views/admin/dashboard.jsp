<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản trị - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/admin.css">
    <link rel="stylesheet" href="/css/icons.css">
</head>
<body>
    <div class="admin-container">
        <div class="admin-sidebar">
            <div class="admin-brand">
                <h2>Admin Panel</h2>
            </div>
            <div class="admin-menu">
                <ul>
                    <li><a href="/admin" class="active">Dashboard</a></li>
                    <li><a href="/admin/fields">Quản lý sân</a></li>
                    <li><a href="/admin/bookings">Quản lý đặt sân</a></li>
                    <li><a href="/admin/users">Quản lý người dùng</a></li>
                    <li><a href="/">Về trang chủ</a></li>
                </ul>
            </div>
        </div>

        <div class="admin-content">
            <div class="admin-header">
                <h1>Dashboard</h1>
                <div class="admin-user">
                    <span>Xin chào, ${loggedUser}</span>
                    <a href="/logout" class="btn btn-sm btn-secondary">Đăng xuất</a>
                </div>
            </div>

            <div class="dashboard-stats">
                <div class="stat-card">
                    <div class="stat-icon users-icon">
                    </div>
                    <div class="stat-info">
                        <h3>Người dùng</h3>
                        <p class="stat-value">${totalUsers}</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon fields-icon">
                    </div>
                    <div class="stat-info">
                        <h3>Sân thể thao</h3>
                        <p class="stat-value">${totalFields}</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon bookings-icon">
                    </div>
                    <div class="stat-info">
                        <h3>Đặt sân</h3>
                        <p class="stat-value">${totalBookings}</p>
                    </div>
                </div>
            </div>

            <div class="dashboard-actions">
                <div class="action-card">
                    <h3>Quản lý sân thể thao</h3>
                    <p>Thêm, sửa, xóa thông tin sân thể thao</p>
                    <a href="/admin/fields" class="btn btn-primary">Quản lý sân</a>
                </div>

                <div class="action-card">
                    <h3>Quản lý đặt sân</h3>
                    <p>Xác nhận, hủy, hoàn thành các đặt sân</p>
                    <a href="/admin/bookings" class="btn btn-primary">Quản lý đặt sân</a>
                </div>

                <div class="action-card">
                    <h3>Quản lý người dùng</h3>
                    <p>Xem thông tin người dùng trong hệ thống</p>
                    <a href="/admin/users" class="btn btn-primary">Quản lý người dùng</a>
                </div>
            </div>
        </div>
    </div>

    <script src="/js/script.js"></script>
</body>
</html>
