<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết điểm tích lũy - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .user-info {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .user-details {
            display: flex;
            align-items: center;
        }
        
        .user-avatar {
            width: 60px;
            height: 60px;
            background-color: #e3f2fd;
            color: #1565c0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-right: 20px;
        }
        
        .user-text h3 {
            margin: 0 0 5px 0;
            font-size: 20px;
            color: #333;
        }
        
        .user-text p {
            margin: 0;
            color: #666;
        }
        
        .loyalty-summary {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .summary-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .summary-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin: 0;
        }
        
        .membership-level {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        
        .level-bronze {
            background-color: #f5f5f5;
            color: #8d6e63;
        }
        
        .level-silver {
            background-color: #f5f5f5;
            color: #757575;
        }
        
        .level-gold {
            background-color: #fff8e1;
            color: #ff8f00;
        }
        
        .level-vip {
            background-color: #e8f5e9;
            color: #2e7d32;
        }
        
        .summary-stats {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .stat-item {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 14px;
            color: #666;
        }
        
        .adjust-points {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .adjust-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin: 0 0 15px 0;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .adjust-form {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: flex-end;
        }
        
        .form-group {
            flex: 1;
            min-width: 200px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }
        
        .form-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .transactions-section {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }
        
        .transactions-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin: 0 0 15px 0;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .transactions-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .transactions-table th, .transactions-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .transactions-table th {
            font-weight: 600;
            color: #333;
            background-color: #f8f9fa;
        }
        
        .transactions-table tr:last-child td {
            border-bottom: none;
        }
        
        .transactions-table tr:hover {
            background-color: #f5f5f5;
        }
        
        .transaction-type {
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .type-earn {
            background-color: #e8f5e9;
            color: #2e7d32;
        }
        
        .type-use {
            background-color: #ffebee;
            color: #c62828;
        }
        
        .type-expire {
            background-color: #f5f5f5;
            color: #757575;
        }
        
        .type-adjust {
            background-color: #e3f2fd;
            color: #1565c0;
        }
        
        .points-value {
            font-weight: 600;
        }
        
        .points-positive {
            color: #2e7d32;
        }
        
        .points-negative {
            color: #c62828;
        }
        
        .no-transactions {
            padding: 20px;
            text-align: center;
            color: #757575;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <div class="admin-sidebar">
            <div class="admin-brand">
                <h2>Admin Panel</h2>
            </div>
            <div class="admin-menu">
                <ul>
                    <li><a href="/admin">Dashboard</a></li>
                    <li><a href="/admin/fields">Quản lý sân</a></li>
                    <li><a href="/admin/bookings">Quản lý đặt sân</a></li>
                    <li><a href="/admin/users">Quản lý người dùng</a></li>
                    <li><a href="/admin/promotions">Quản lý khuyến mãi</a></li>
                    <li><a href="/admin/coupons">Quản lý mã giảm giá</a></li>
                    <li><a href="/loyalty/admin" class="active">Quản lý điểm tích lũy</a></li>
                    <li><a href="/user/profile">Thông tin cá nhân</a></li>
                    <li><a href="/">Về trang chủ</a></li>
                </ul>
            </div>
        </div>

        <div class="admin-content">
            <div class="admin-header">
                <h1>Chi tiết điểm tích lũy</h1>
                <div class="admin-user">
                    <span>Xin chào, ${loggedUser}</span>
                    <a href="/logout" class="btn btn-sm btn-secondary">Đăng xuất</a>
                </div>
            </div>

            <div class="admin-actions">
                <a href="/loyalty/admin" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>

            <c:if test="${param.success eq 'adjusted'}">
                <div class="success-message">Điều chỉnh điểm tích lũy thành công!</div>
            </c:if>

            <div class="user-info">
                <div class="user-details">
                    <div class="user-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="user-text">
                        <h3>${targetUser.username}</h3>
                        <p>${targetUser.email}</p>
                    </div>
                </div>
                <a href="/admin/users/${targetUser.id}" class="btn btn-sm btn-primary">
                    <i class="fas fa-user-edit"></i> Quản lý người dùng
                </a>
            </div>

            <div class="loyalty-summary">
                <div class="summary-header">
                    <h2 class="summary-title">Thông tin điểm tích lũy</h2>
                    <span class="membership-level level-${loyaltyPoint.getMembershipLevel().toLowerCase()}">
                        ${loyaltyPoint.getMembershipLevel()}
                    </span>
                </div>
                <div class="summary-stats">
                    <div class="stat-item">
                        <div class="stat-value">${loyaltyPoint.points}</div>
                        <div class="stat-label">Điểm hiện tại</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">${loyaltyPoint.totalEarnedPoints}</div>
                        <div class="stat-label">Tổng điểm đã tích</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">${loyaltyPoint.totalUsedPoints}</div>
                        <div class="stat-label">Điểm đã sử dụng</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">${loyaltyPoint.getDiscountRate()}%</div>
                        <div class="stat-label">Ưu đãi thành viên</div>
                    </div>
                </div>
            </div>

            <div class="adjust-points">
                <h2 class="adjust-title">Điều chỉnh điểm tích lũy</h2>
                <form action="/loyalty/admin/adjust" method="post" class="adjust-form">
                    <input type="hidden" name="username" value="${targetUser.username}">
                    <div class="form-group">
                        <label for="points" class="form-label">Số điểm <span class="required">*</span></label>
                        <input type="number" id="points" name="points" class="form-control" required>
                        <small class="form-text text-muted">Nhập số dương để thêm điểm, số âm để trừ điểm</small>
                    </div>
                    <div class="form-group">
                        <label for="description" class="form-label">Lý do <span class="required">*</span></label>
                        <input type="text" id="description" name="description" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Cập nhật điểm
                    </button>
                </form>
            </div>

            <div class="transactions-section">
                <h2 class="transactions-title">Lịch sử giao dịch điểm</h2>
                
                <c:if test="${empty transactions}">
                    <div class="no-transactions">Chưa có giao dịch điểm nào.</div>
                </c:if>
                
                <c:if test="${not empty transactions}">
                    <table class="transactions-table">
                        <thead>
                            <tr>
                                <th>Thời gian</th>
                                <th>Loại giao dịch</th>
                                <th>Điểm</th>
                                <th>Mô tả</th>
                                <th>ID đặt sân</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${transactions}" var="transaction">
                                <tr>
                                    <td><fmt:formatDate value="${transaction.transactionDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                    <td>
                                        <span class="transaction-type type-${transaction.type.toString().toLowerCase()}">
                                            <c:choose>
                                                <c:when test="${transaction.type eq 'EARN'}">Tích điểm</c:when>
                                                <c:when test="${transaction.type eq 'USE'}">Sử dụng</c:when>
                                                <c:when test="${transaction.type eq 'EXPIRE'}">Hết hạn</c:when>
                                                <c:when test="${transaction.type eq 'ADJUST'}">Điều chỉnh</c:when>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="points-value ${transaction.type eq 'EARN' || transaction.type eq 'ADJUST' && transaction.points > 0 ? 'points-positive' : 'points-negative'}">
                                            ${transaction.type eq 'EARN' || transaction.type eq 'ADJUST' && transaction.points > 0 ? '+' : '-'}${Math.abs(transaction.points)}
                                        </span>
                                    </td>
                                    <td>${transaction.description}</td>
                                    <td>
                                        <c:if test="${transaction.bookingId != null}">
                                            <a href="/admin/bookings/${transaction.bookingId}">#${transaction.bookingId}</a>
                                        </c:if>
                                        <c:if test="${transaction.bookingId == null}">-</c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>
