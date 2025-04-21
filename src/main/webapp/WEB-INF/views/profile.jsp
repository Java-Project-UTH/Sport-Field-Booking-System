<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang cá nhân - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .profile-container {
            max-width: 1200px;
            margin: 30px auto;
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
        }

        .profile-sidebar {
            flex: 0 0 250px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: center;
        }

        .profile-avatar {
            width: 150px;
            height: 150px;
            margin: 0 auto 20px;
            border-radius: 50%;
            overflow: hidden;
            border: 5px solid #f0f0f0;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }

        .profile-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-sidebar h3 {
            margin-bottom: 5px;
            color: #333;
        }

        .profile-role {
            display: inline-block;
            background-color: #2196F3;
            color: white;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            margin-bottom: 20px;
        }

        .profile-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .profile-menu li {
            margin-bottom: 5px;
        }

        .profile-menu a {
            display: block;
            padding: 10px 15px;
            border-radius: 5px;
            text-decoration: none;
            color: #555;
            transition: all 0.3s ease;
        }

        .profile-menu a:hover, .profile-menu a.active {
            background-color: #e3f2fd;
            color: #2196F3;
        }

        .profile-menu a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .profile-content {
            flex: 1;
            min-width: 0;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }

        .profile-section {
            display: none;
        }

        .profile-section.active {
            display: block;
        }

        .profile-section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .profile-section-header h2 {
            margin: 0;
            color: #333;
        }

        .profile-info-details {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .info-group {
            margin-bottom: 15px;
        }

        .info-group label {
            display: block;
            font-weight: bold;
            color: #666;
            margin-bottom: 5px;
        }

        .info-group span {
            color: #333;
        }

        .success-message {
            background-color: #e8f5e9;
            color: #2e7d32;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .success-message:before {
            content: '\2713';
            display: inline-block;
            width: 20px;
            height: 20px;
            background-color: #2e7d32;
            color: white;
            border-radius: 50%;
            text-align: center;
            line-height: 20px;
            margin-right: 10px;
        }

        .booking-list {
            margin-top: 20px;
        }

        .booking-card {
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            border-left: 4px solid #2196F3;
        }

        .booking-card.pending {
            border-left-color: #FFC107;
        }

        .booking-card.completed {
            border-left-color: #4CAF50;
        }

        .booking-card.cancelled {
            border-left-color: #F44336;
        }

        .booking-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .booking-title {
            font-weight: bold;
            color: #333;
        }

        .booking-status {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 0.8rem;
        }

        .booking-status.pending {
            background-color: #FFF9C4;
            color: #FFA000;
        }

        .booking-status.confirmed {
            background-color: #C8E6C9;
            color: #388E3C;
        }

        .booking-status.completed {
            background-color: #BBDEFB;
            color: #1976D2;
        }

        .booking-status.cancelled {
            background-color: #FFCDD2;
            color: #D32F2F;
        }

        .booking-details {
            margin-bottom: 10px;
        }

        .booking-detail {
            display: flex;
            margin-bottom: 5px;
        }

        .booking-detail-label {
            width: 120px;
            color: #666;
        }

        .booking-actions {
            margin-top: 10px;
            display: flex;
            gap: 10px;
        }

        .btn-sm {
            padding: 5px 10px;
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .profile-container {
                flex-direction: column;
            }

            .profile-sidebar {
                flex: 0 0 auto;
                width: 100%;
            }

            .profile-info-details {
                grid-template-columns: 1fr;
            }
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
                <li><a href="/user/profile" class="active">Trang cá nhân</a></li>
            </ul>
            <div class="navbar-account">
                <span>Xin chào, ${user.name}</span> | <a href="/logout">Đăng xuất</a>
            </div>
        </div>

        <div class="profile-container">
            <div class="profile-sidebar">
                <div class="profile-avatar">
                    <img src="${empty user.avatarUrl ? '/images/profile-avatar.png' : user.avatarUrl}" alt="Avatar" onerror="this.src='/images/profile-avatar.png'">
                    <!-- Debug info -->
                    <div style="display: none;">
                        <p>Avatar URL: ${user.avatarUrl}</p>
                    </div>
                </div>
                <h3>${user.name}</h3>
                <div class="profile-role">
                    <c:choose>
                        <c:when test="${user.role eq 'ADMIN'}">Quản trị viên</c:when>
                        <c:otherwise>Người dùng</c:otherwise>
                    </c:choose>
                </div>
                <p>${user.email}</p>
                <ul class="profile-menu">
                    <li><a href="#profile-info" class="active"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
                    <li><a href="#active-bookings"><i class="fas fa-calendar-check"></i> Đặt sân hiện tại</a></li>
                    <li><a href="#pending-bookings"><i class="fas fa-clock"></i> Đặt sân chờ xác nhận</a></li>
                    <li><a href="#completed-bookings"><i class="fas fa-history"></i> Lịch sử đặt sân</a></li>
                    <c:if test="${user.role eq 'ADMIN'}">
                        <li><a href="/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Quản trị</a></li>
                    </c:if>
                </ul>
            </div>

            <div class="profile-content">
                <div id="profile-info" class="profile-section active">
                    <div class="profile-section-header">
                        <h2>Thông tin cá nhân</h2>
                        <a href="/user/edit-profile" class="btn btn-primary btn-sm"><i class="fas fa-edit"></i> Chỉnh sửa</a>
                    </div>

                    <c:if test="${param.success eq 'updated'}">
                        <div class="success-message">
                            Thông tin cá nhân đã được cập nhật thành công!
                        </div>
                    </c:if>

                    <div class="profile-info-details">
                        <div class="info-group">
                            <label>Tên đăng nhập:</label>
                            <span>${user.username}</span>
                        </div>
                        <div class="info-group">
                            <label>Họ và tên:</label>
                            <span>${user.name}</span>
                        </div>
                        <div class="info-group">
                            <label>Email:</label>
                            <span>${user.email}</span>
                        </div>
                        <div class="info-group">
                            <label>Số điện thoại:</label>
                            <span>${user.phone_number}</span>
                        </div>
                        <div class="info-group">
                            <label>Tuổi:</label>
                            <span>${user.age}</span>
                        </div>
                        <div class="info-group">
                            <label>Giới tính:</label>
                            <span>${user.gender}</span>
                        </div>
                        <div class="info-group">
                            <label>Địa chỉ:</label>
                            <span>${user.address}</span>
                        </div>
                    </div>
                    <div class="profile-actions">
                        <button class="btn btn-primary">Cập nhật thông tin</button>
                    </div>
                </div>

                <div id="active-bookings" class="profile-section">
                    <h2>Đặt sân hiện tại</h2>
                    <c:if test="${empty activeBookings}">
                        <p class="no-data">Bạn không có đặt sân nào đang hoạt động.</p>
                    </c:if>
                    <c:if test="${not empty activeBookings}">
                        <div class="bookings-list">
                            <c:forEach items="${activeBookings}" var="booking">
                                <div class="booking-card">
                                    <div class="booking-header">
                                        <h3>Mã đặt sân: #${booking.id}</h3>
                                        <span class="booking-status confirmed">Đã xác nhận</span>
                                    </div>
                                    <div class="booking-details">
                                        <div class="booking-info">
                                            <p><strong>Thời gian:</strong> <fmt:formatDate value="${booking.startTime}" pattern="dd/MM/yyyy HH:mm" /> - <fmt:formatDate value="${booking.endTime}" pattern="HH:mm" /></p>
                                            <p><strong>Tổng tiền:</strong> <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="VNĐ" /></p>
                                            <p><strong>Số người chơi:</strong> ${booking.numberOfPlayers}</p>
                                            <c:if test="${not empty booking.notes}">
                                                <p><strong>Ghi chú:</strong> ${booking.notes}</p>
                                            </c:if>
                                        </div>
                                        <div class="booking-actions">
                                            <a href="/bookings/${booking.id}" class="btn btn-secondary">Chi tiết</a>
                                            <form action="/bookings/${booking.id}/cancel" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đặt sân này?');">
                                                <button type="submit" class="btn btn-danger">Hủy đặt sân</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>

                <div id="pending-bookings" class="profile-section">
                    <h2>Đặt sân chờ xác nhận</h2>
                    <c:if test="${empty pendingBookings}">
                        <p class="no-data">Bạn không có đặt sân nào đang chờ xác nhận.</p>
                    </c:if>
                    <c:if test="${not empty pendingBookings}">
                        <div class="bookings-list">
                            <c:forEach items="${pendingBookings}" var="booking">
                                <div class="booking-card">
                                    <div class="booking-header">
                                        <h3>Mã đặt sân: #${booking.id}</h3>
                                        <span class="booking-status pending">Chờ xác nhận</span>
                                    </div>
                                    <div class="booking-details">
                                        <div class="booking-info">
                                            <p><strong>Thời gian:</strong> <fmt:formatDate value="${booking.startTime}" pattern="dd/MM/yyyy HH:mm" /> - <fmt:formatDate value="${booking.endTime}" pattern="HH:mm" /></p>
                                            <p><strong>Tổng tiền:</strong> <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="VNĐ" /></p>
                                            <p><strong>Số người chơi:</strong> ${booking.numberOfPlayers}</p>
                                            <c:if test="${not empty booking.notes}">
                                                <p><strong>Ghi chú:</strong> ${booking.notes}</p>
                                            </c:if>
                                        </div>
                                        <div class="booking-actions">
                                            <a href="/bookings/${booking.id}" class="btn btn-secondary">Chi tiết</a>
                                            <form action="/bookings/${booking.id}/cancel" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đặt sân này?');">
                                                <button type="submit" class="btn btn-danger">Hủy đặt sân</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>

                <div id="completed-bookings" class="profile-section">
                    <h2>Lịch sử đặt sân</h2>
                    <c:if test="${empty completedBookings}">
                        <p class="no-data">Bạn chưa có lịch sử đặt sân nào.</p>
                    </c:if>
                    <c:if test="${not empty completedBookings}">
                        <div class="bookings-list">
                            <c:forEach items="${completedBookings}" var="booking">
                                <div class="booking-card">
                                    <div class="booking-header">
                                        <h3>Mã đặt sân: #${booking.id}</h3>
                                        <span class="booking-status completed">Đã hoàn thành</span>
                                    </div>
                                    <div class="booking-details">
                                        <div class="booking-info">
                                            <p><strong>Thời gian:</strong> <fmt:formatDate value="${booking.startTime}" pattern="dd/MM/yyyy HH:mm" /> - <fmt:formatDate value="${booking.endTime}" pattern="HH:mm" /></p>
                                            <p><strong>Tổng tiền:</strong> <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="VNĐ" /></p>
                                            <p><strong>Số người chơi:</strong> ${booking.numberOfPlayers}</p>
                                            <c:if test="${not empty booking.notes}">
                                                <p><strong>Ghi chú:</strong> ${booking.notes}</p>
                                            </c:if>
                                        </div>
                                        <div class="booking-actions">
                                            <a href="/bookings/${booking.id}" class="btn btn-secondary">Chi tiết</a>
                                            <a href="/fields/${booking.fieldId}#review-form" class="btn btn-primary">Đánh giá</a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <script src="/js/script.js"></script>
    <script>
        // Tab switching functionality
        document.querySelectorAll('.profile-menu a').forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();

                // Remove active class from all links and sections
                document.querySelectorAll('.profile-menu a').forEach(item => item.classList.remove('active'));
                document.querySelectorAll('.profile-section').forEach(section => section.classList.remove('active'));

                // Add active class to clicked link
                this.classList.add('active');

                // Show corresponding section
                const targetId = this.getAttribute('href').substring(1);
                document.getElementById(targetId).classList.add('active');
            });
        });
    </script>
</body>
</html>
