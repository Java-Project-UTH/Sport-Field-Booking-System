<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch sử sử dụng mã giảm giá - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .coupon-info {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .coupon-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .coupon-title {
            font-size: 20px;
            font-weight: 600;
            margin: 0;
            color: #333;
        }
        
        .coupon-code {
            background-color: #e3f2fd;
            color: #1565c0;
            padding: 5px 10px;
            border-radius: 4px;
            font-family: monospace;
            font-weight: 600;
            letter-spacing: 1px;
            font-size: 14px;
        }
        
        .coupon-details {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .detail-item {
            display: flex;
            flex-direction: column;
        }
        
        .detail-label {
            font-size: 12px;
            color: #757575;
            margin-bottom: 5px;
        }
        
        .detail-value {
            font-size: 14px;
            color: #333;
            font-weight: 500;
        }
        
        .usage-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .usage-table th, .usage-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .usage-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #333;
        }
        
        .usage-table tr:last-child td {
            border-bottom: none;
        }
        
        .usage-table tr:hover {
            background-color: #f5f5f5;
        }
        
        .no-data {
            padding: 20px;
            text-align: center;
            color: #757575;
            font-style: italic;
        }
        
        .usage-summary {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .summary-item {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        .summary-value {
            font-size: 24px;
            font-weight: 600;
            color: #333;
        }
        
        .summary-label {
            font-size: 14px;
            color: #757575;
            margin-top: 5px;
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
                    <li><a href="/admin/coupons" class="active">Quản lý mã giảm giá</a></li>
                    <li><a href="/user/profile">Thông tin cá nhân</a></li>
                    <li><a href="/">Về trang chủ</a></li>
                </ul>
            </div>
        </div>

        <div class="admin-content">
            <div class="admin-header">
                <h1>Lịch sử sử dụng mã giảm giá</h1>
                <div class="admin-user">
                    <span>Xin chào, ${loggedUser}</span>
                    <a href="/logout" class="btn btn-sm btn-secondary">Đăng xuất</a>
                </div>
            </div>

            <div class="admin-actions">
                <a href="/admin/coupons" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>

            <div class="coupon-info">
                <div class="coupon-header">
                    <h2 class="coupon-title">${coupon.name}</h2>
                    <div class="coupon-code">${coupon.code}</div>
                </div>
                <div class="coupon-details">
                    <div class="detail-item">
                        <span class="detail-label">Loại mã giảm giá</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${coupon.type eq 'PERCENTAGE'}">Giảm ${coupon.value}%</c:when>
                                <c:when test="${coupon.type eq 'FIXED_AMOUNT'}">Giảm <fmt:formatNumber value="${coupon.value}" type="number" pattern="#,###"/> VNĐ</c:when>
                            </c:choose>
                        </span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Trạng thái</span>
                        <span class="detail-value">${coupon.status}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Thời gian bắt đầu</span>
                        <span class="detail-value"><fmt:formatDate value="${coupon.startDate}" pattern="dd/MM/yyyy HH:mm" /></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Thời gian kết thúc</span>
                        <span class="detail-value"><fmt:formatDate value="${coupon.endDate}" pattern="dd/MM/yyyy HH:mm" /></span>
                    </div>
                </div>
            </div>

            <div class="usage-summary">
                <div class="summary-item">
                    <span class="summary-value">${coupon.usageCount}</span>
                    <span class="summary-label">Đã sử dụng</span>
                </div>
                <div class="summary-item">
                    <span class="summary-value">${coupon.maxUsage == 0 ? '∞' : coupon.maxUsage}</span>
                    <span class="summary-label">Tổng số lần</span>
                </div>
                <div class="summary-item">
                    <span class="summary-value">
                        <c:choose>
                            <c:when test="${coupon.maxUsage == 0}">0%</c:when>
                            <c:otherwise>
                                <fmt:formatNumber value="${(coupon.usageCount / coupon.maxUsage) * 100}" type="number" pattern="#,##0.0"/>%
                            </c:otherwise>
                        </c:choose>
                    </span>
                    <span class="summary-label">Tỷ lệ sử dụng</span>
                </div>
                <div class="summary-item">
                    <span class="summary-value">
                        <c:set var="totalDiscount" value="0" />
                        <c:forEach items="${usageHistory}" var="usage">
                            <c:set var="totalDiscount" value="${totalDiscount + usage.discountAmount}" />
                        </c:forEach>
                        <fmt:formatNumber value="${totalDiscount}" type="number" pattern="#,###"/> VNĐ
                    </span>
                    <span class="summary-label">Tổng giảm giá</span>
                </div>
            </div>

            <h2>Lịch sử sử dụng</h2>

            <c:if test="${empty usageHistory}">
                <div class="no-data">Chưa có lịch sử sử dụng nào.</div>
            </c:if>

            <c:if test="${not empty usageHistory}">
                <table class="usage-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Người dùng</th>
                            <th>ID đặt sân</th>
                            <th>Số tiền giảm</th>
                            <th>Thời gian sử dụng</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${usageHistory}" var="usage">
                            <tr>
                                <td>${usage.id}</td>
                                <td>${usage.username}</td>
                                <td>
                                    <a href="/admin/bookings/${usage.bookingId}" target="_blank">
                                        #${usage.bookingId}
                                    </a>
                                </td>
                                <td><fmt:formatNumber value="${usage.discountAmount}" type="number" pattern="#,###"/> VNĐ</td>
                                <td><fmt:formatDate value="${usage.usedAt}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
    </div>
</body>
</html>
