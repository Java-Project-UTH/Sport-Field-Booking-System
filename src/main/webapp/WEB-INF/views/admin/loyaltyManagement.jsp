<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý điểm tích lũy - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .users-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .users-table th, .users-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .users-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #333;
        }
        
        .users-table tr:last-child td {
            border-bottom: none;
        }
        
        .users-table tr:hover {
            background-color: #f5f5f5;
        }
        
        .membership-level {
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
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
        
        .search-section {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 8px;
            display: flex;
            gap: 15px;
            align-items: center;
        }
        
        .search-input {
            flex: 1;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .filter-select {
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: white;
        }
        
        .no-data {
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
                <h1>Quản lý điểm tích lũy</h1>
                <div class="admin-user">
                    <span>Xin chào, ${loggedUser}</span>
                    <a href="/logout" class="btn btn-sm btn-secondary">Đăng xuất</a>
                </div>
            </div>

            <c:if test="${param.success eq 'adjusted'}">
                <div class="success-message">Điều chỉnh điểm tích lũy thành công!</div>
            </c:if>
            <c:if test="${param.error eq 'userNotFound'}">
                <div class="error-message">Không tìm thấy người dùng!</div>
            </c:if>

            <div class="search-section">
                <input type="text" id="searchInput" class="search-input" placeholder="Tìm kiếm theo tên người dùng...">
                <select id="levelFilter" class="filter-select">
                    <option value="">Tất cả cấp độ</option>
                    <option value="Bronze">Bronze</option>
                    <option value="Silver">Silver</option>
                    <option value="Gold">Gold</option>
                    <option value="VIP">VIP</option>
                </select>
            </div>

            <c:if test="${empty users}">
                <div class="no-data">Không có dữ liệu người dùng.</div>
            </c:if>

            <c:if test="${not empty users}">
                <table class="users-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên người dùng</th>
                            <th>Email</th>
                            <th>Điểm hiện tại</th>
                            <th>Tổng điểm đã tích</th>
                            <th>Cấp độ thành viên</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${users}" var="user">
                            <tr data-username="${user.username}" data-level="${user.loyaltyPoint != null ? user.loyaltyPoint.getMembershipLevel() : 'Bronze'}">
                                <td>${user.id}</td>
                                <td>${user.username}</td>
                                <td>${user.email}</td>
                                <td>${user.loyaltyPoint != null ? user.loyaltyPoint.points : 0}</td>
                                <td>${user.loyaltyPoint != null ? user.loyaltyPoint.totalEarnedPoints : 0}</td>
                                <td>
                                    <span class="membership-level level-${user.loyaltyPoint != null ? user.loyaltyPoint.getMembershipLevel().toLowerCase() : 'bronze'}">
                                        ${user.loyaltyPoint != null ? user.loyaltyPoint.getMembershipLevel() : 'Bronze'}
                                    </span>
                                </td>
                                <td>
                                    <a href="/loyalty/admin/user/${user.username}" class="btn btn-sm btn-primary">
                                        <i class="fas fa-eye"></i> Chi tiết
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
    </div>

    <script>
        // Search and filter functionality
        document.getElementById('searchInput').addEventListener('input', filterUsers);
        document.getElementById('levelFilter').addEventListener('change', filterUsers);
        
        function filterUsers() {
            const searchValue = document.getElementById('searchInput').value.toLowerCase();
            const levelFilter = document.getElementById('levelFilter').value;
            
            const userRows = document.querySelectorAll('.users-table tbody tr');
            
            userRows.forEach(row => {
                const username = row.getAttribute('data-username').toLowerCase();
                const level = row.getAttribute('data-level');
                
                const usernameMatch = username.includes(searchValue);
                const levelMatch = !levelFilter || level === levelFilter;
                
                if (usernameMatch && levelMatch) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>
