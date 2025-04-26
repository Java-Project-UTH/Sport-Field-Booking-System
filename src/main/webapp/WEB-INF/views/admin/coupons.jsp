<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý mã giảm giá - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .coupon-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            overflow: hidden;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .coupon-card:hover {
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
            transform: translateY(-2px);
        }
        
        .coupon-header {
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #f8f9fa;
        }
        
        .coupon-title {
            font-size: 18px;
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
        
        .coupon-status {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-active {
            background-color: #e8f5e9;
            color: #2e7d32;
        }
        
        .status-inactive {
            background-color: #f5f5f5;
            color: #757575;
        }
        
        .status-expired {
            background-color: #ffebee;
            color: #c62828;
        }
        
        .coupon-body {
            padding: 20px;
        }
        
        .coupon-info {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .info-item {
            display: flex;
            flex-direction: column;
        }
        
        .info-label {
            font-size: 12px;
            color: #757575;
            margin-bottom: 5px;
        }
        
        .info-value {
            font-size: 14px;
            color: #333;
            font-weight: 500;
        }
        
        .coupon-description {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        
        .coupon-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
        }
        
        .filter-section {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 8px;
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: center;
        }
        
        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .filter-label {
            font-weight: 500;
            color: #555;
            white-space: nowrap;
        }
        
        .filter-select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: white;
        }
        
        .usage-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background-color: #f5f5f5;
            color: #333;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
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
                <h1>Quản lý mã giảm giá</h1>
                <div class="admin-user">
                    <span>Xin chào, ${loggedUser}</span>
                    <a href="/logout" class="btn btn-sm btn-secondary">Đăng xuất</a>
                </div>
            </div>

            <c:if test="${param.success eq 'added'}">
                <div class="success-message">Thêm mã giảm giá thành công!</div>
            </c:if>
            <c:if test="${param.success eq 'updated'}">
                <div class="success-message">Cập nhật mã giảm giá thành công!</div>
            </c:if>
            <c:if test="${param.success eq 'deleted'}">
                <div class="success-message">Xóa mã giảm giá thành công!</div>
            </c:if>
            <c:if test="${param.success eq 'statusUpdated'}">
                <div class="success-message">Cập nhật trạng thái mã giảm giá thành công!</div>
            </c:if>
            <c:if test="${param.error eq 'codeExists'}">
                <div class="error-message">Mã giảm giá đã tồn tại!</div>
            </c:if>

            <div class="admin-actions">
                <a href="/admin/coupons/add" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Thêm mã giảm giá mới
                </a>
            </div>

            <div class="filter-section">
                <div class="filter-group">
                    <span class="filter-label">Trạng thái:</span>
                    <select id="statusFilter" class="filter-select">
                        <option value="">Tất cả</option>
                        <option value="ACTIVE">Đang hoạt động</option>
                        <option value="INACTIVE">Không hoạt động</option>
                        <option value="EXPIRED">Đã hết hạn</option>
                    </select>
                </div>
                <div class="filter-group">
                    <span class="filter-label">Loại mã giảm giá:</span>
                    <select id="typeFilter" class="filter-select">
                        <option value="">Tất cả</option>
                        <option value="PERCENTAGE">Giảm theo %</option>
                        <option value="FIXED_AMOUNT">Giảm số tiền cố định</option>
                    </select>
                </div>
            </div>

            <div class="coupons-list">
                <c:if test="${empty coupons}">
                    <div class="no-data">Chưa có mã giảm giá nào.</div>
                </c:if>
                
                <c:forEach items="${coupons}" var="coupon">
                    <div class="coupon-card" data-status="${coupon.status}" data-type="${coupon.type}">
                        <div class="usage-badge">
                            Đã sử dụng: ${coupon.usageCount}/${coupon.maxUsage == 0 ? '∞' : coupon.maxUsage}
                        </div>
                        <div class="coupon-header">
                            <h3 class="coupon-title">${coupon.name}</h3>
                            <div class="coupon-code">${coupon.code}</div>
                            <span class="coupon-status status-${coupon.status.toString().toLowerCase()}">${coupon.status}</span>
                        </div>
                        <div class="coupon-body">
                            <div class="coupon-info">
                                <div class="info-item">
                                    <span class="info-label">Loại mã giảm giá</span>
                                    <span class="info-value">
                                        <c:choose>
                                            <c:when test="${coupon.type eq 'PERCENTAGE'}">Giảm ${coupon.value}%</c:when>
                                            <c:when test="${coupon.type eq 'FIXED_AMOUNT'}">Giảm <fmt:formatNumber value="${coupon.value}" type="number" pattern="#,###"/> VNĐ</c:when>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Giá trị đặt sân tối thiểu</span>
                                    <span class="info-value"><fmt:formatNumber value="${coupon.minBookingValue}" type="number" pattern="#,###"/> VNĐ</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Giảm tối đa</span>
                                    <span class="info-value"><fmt:formatNumber value="${coupon.maxDiscountAmount}" type="number" pattern="#,###"/> VNĐ</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Thời gian bắt đầu</span>
                                    <span class="info-value"><fmt:formatDate value="${coupon.startDate}" pattern="dd/MM/yyyy HH:mm" /></span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Thời gian kết thúc</span>
                                    <span class="info-value"><fmt:formatDate value="${coupon.endDate}" pattern="dd/MM/yyyy HH:mm" /></span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Số lần sử dụng tối đa/người</span>
                                    <span class="info-value">${coupon.maxUsagePerUser == 0 ? 'Không giới hạn' : coupon.maxUsagePerUser}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Loại sân áp dụng</span>
                                    <span class="info-value">${empty coupon.fieldTypes ? 'Tất cả' : coupon.fieldTypes}</span>
                                </div>
                            </div>
                            
                            <div class="coupon-description">
                                <p>${coupon.description}</p>
                            </div>
                            
                            <div class="coupon-actions">
                                <a href="/admin/coupons/${coupon.id}/usage" class="btn btn-sm btn-info">
                                    <i class="fas fa-history"></i> Lịch sử sử dụng
                                </a>
                                <a href="/admin/coupons/edit/${coupon.id}" class="btn btn-sm btn-primary">
                                    <i class="fas fa-edit"></i> Sửa
                                </a>
                                <button class="btn btn-sm btn-danger" onclick="confirmDelete(${coupon.id})">
                                    <i class="fas fa-trash"></i> Xóa
                                </button>
                                <c:if test="${coupon.status ne 'ACTIVE'}">
                                    <form action="/admin/coupons/${coupon.id}/status" method="post" style="display: inline;">
                                        <input type="hidden" name="status" value="ACTIVE">
                                        <button type="submit" class="btn btn-sm btn-success">
                                            <i class="fas fa-check"></i> Kích hoạt
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${coupon.status ne 'INACTIVE'}">
                                    <form action="/admin/coupons/${coupon.id}/status" method="post" style="display: inline;">
                                        <input type="hidden" name="status" value="INACTIVE">
                                        <button type="submit" class="btn btn-sm btn-secondary">
                                            <i class="fas fa-ban"></i> Vô hiệu hóa
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Confirm Delete Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <h3>Xác nhận xóa</h3>
            <p>Bạn có chắc chắn muốn xóa mã giảm giá này không?</p>
            <div class="modal-actions">
                <form id="deleteForm" action="/admin/coupons/delete/" method="post">
                    <button type="submit" class="btn btn-danger">Xóa</button>
                </form>
                <button class="btn btn-secondary" onclick="closeModal()">Hủy</button>
            </div>
        </div>
    </div>

    <script>
        // Filter coupons
        document.getElementById('statusFilter').addEventListener('change', filterCoupons);
        document.getElementById('typeFilter').addEventListener('change', filterCoupons);
        
        function filterCoupons() {
            const statusFilter = document.getElementById('statusFilter').value;
            const typeFilter = document.getElementById('typeFilter').value;
            
            const couponCards = document.querySelectorAll('.coupon-card');
            
            couponCards.forEach(card => {
                const cardStatus = card.getAttribute('data-status');
                const cardType = card.getAttribute('data-type');
                
                let statusMatch = !statusFilter || cardStatus === statusFilter;
                let typeMatch = !typeFilter || cardType === typeFilter;
                
                if (statusMatch && typeMatch) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }
        
        // Delete confirmation
        function confirmDelete(id) {
            const modal = document.getElementById('deleteModal');
            const deleteForm = document.getElementById('deleteForm');
            
            deleteForm.action = `/admin/coupons/delete/${id}`;
            modal.style.display = 'block';
        }
        
        function closeModal() {
            const modal = document.getElementById('deleteModal');
            modal.style.display = 'none';
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('deleteModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }
    </script>
</body>
</html>
