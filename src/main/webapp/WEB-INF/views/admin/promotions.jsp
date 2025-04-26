<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý khuyến mãi - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .promotion-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .promotion-card:hover {
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
            transform: translateY(-2px);
        }
        
        .promotion-header {
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .promotion-title {
            font-size: 18px;
            font-weight: 600;
            margin: 0;
            color: #333;
        }
        
        .promotion-status {
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
        
        .status-scheduled {
            background-color: #e3f2fd;
            color: #1565c0;
        }
        
        .status-expired {
            background-color: #ffebee;
            color: #c62828;
        }
        
        .promotion-body {
            padding: 20px;
        }
        
        .promotion-info {
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
        
        .promotion-description {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        
        .promotion-actions {
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
                    <li><a href="/admin/promotions" class="active">Quản lý khuyến mãi</a></li>
                    <li><a href="/admin/coupons">Quản lý mã giảm giá</a></li>
                    <li><a href="/user/profile">Thông tin cá nhân</a></li>
                    <li><a href="/">Về trang chủ</a></li>
                </ul>
            </div>
        </div>

        <div class="admin-content">
            <div class="admin-header">
                <h1>Quản lý khuyến mãi</h1>
                <div class="admin-user">
                    <span>Xin chào, ${loggedUser}</span>
                    <a href="/logout" class="btn btn-sm btn-secondary">Đăng xuất</a>
                </div>
            </div>

            <c:if test="${param.success eq 'added'}">
                <div class="success-message">Thêm khuyến mãi thành công!</div>
            </c:if>
            <c:if test="${param.success eq 'updated'}">
                <div class="success-message">Cập nhật khuyến mãi thành công!</div>
            </c:if>
            <c:if test="${param.success eq 'deleted'}">
                <div class="success-message">Xóa khuyến mãi thành công!</div>
            </c:if>
            <c:if test="${param.success eq 'statusUpdated'}">
                <div class="success-message">Cập nhật trạng thái khuyến mãi thành công!</div>
            </c:if>

            <div class="admin-actions">
                <a href="/admin/promotions/add" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Thêm khuyến mãi mới
                </a>
            </div>

            <div class="filter-section">
                <div class="filter-group">
                    <span class="filter-label">Trạng thái:</span>
                    <select id="statusFilter" class="filter-select">
                        <option value="">Tất cả</option>
                        <option value="ACTIVE">Đang hoạt động</option>
                        <option value="INACTIVE">Không hoạt động</option>
                        <option value="SCHEDULED">Đã lên lịch</option>
                        <option value="EXPIRED">Đã hết hạn</option>
                    </select>
                </div>
                <div class="filter-group">
                    <span class="filter-label">Loại khuyến mãi:</span>
                    <select id="typeFilter" class="filter-select">
                        <option value="">Tất cả</option>
                        <option value="PERCENTAGE">Giảm theo %</option>
                        <option value="FIXED_AMOUNT">Giảm số tiền cố định</option>
                        <option value="SPECIAL_PRICE">Giá đặc biệt</option>
                    </select>
                </div>
            </div>

            <div class="promotions-list">
                <c:if test="${empty promotions}">
                    <div class="no-data">Chưa có khuyến mãi nào.</div>
                </c:if>
                
                <c:forEach items="${promotions}" var="promotion">
                    <div class="promotion-card" data-status="${promotion.status}" data-type="${promotion.type}">
                        <div class="promotion-header">
                            <h3 class="promotion-title">${promotion.name}</h3>
                            <span class="promotion-status status-${promotion.status.toString().toLowerCase()}">${promotion.status}</span>
                        </div>
                        <div class="promotion-body">
                            <div class="promotion-info">
                                <div class="info-item">
                                    <span class="info-label">Loại khuyến mãi</span>
                                    <span class="info-value">
                                        <c:choose>
                                            <c:when test="${promotion.type eq 'PERCENTAGE'}">Giảm ${promotion.value}%</c:when>
                                            <c:when test="${promotion.type eq 'FIXED_AMOUNT'}">Giảm <fmt:formatNumber value="${promotion.value}" type="number" pattern="#,###"/> VNĐ</c:when>
                                            <c:when test="${promotion.type eq 'SPECIAL_PRICE'}">Giá đặc biệt: <fmt:formatNumber value="${promotion.value}" type="number" pattern="#,###"/> VNĐ</c:when>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Giá trị đặt sân tối thiểu</span>
                                    <span class="info-value"><fmt:formatNumber value="${promotion.minBookingValue}" type="number" pattern="#,###"/> VNĐ</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Giảm tối đa</span>
                                    <span class="info-value"><fmt:formatNumber value="${promotion.maxDiscountAmount}" type="number" pattern="#,###"/> VNĐ</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Thời gian bắt đầu</span>
                                    <span class="info-value"><fmt:formatDate value="${promotion.startDate}" pattern="dd/MM/yyyy HH:mm" /></span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Thời gian kết thúc</span>
                                    <span class="info-value"><fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy HH:mm" /></span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Loại sân áp dụng</span>
                                    <span class="info-value">${empty promotion.fieldTypes ? 'Tất cả' : promotion.fieldTypes}</span>
                                </div>
                            </div>
                            
                            <div class="promotion-description">
                                <p>${promotion.description}</p>
                            </div>
                            
                            <div class="promotion-actions">
                                <a href="/admin/promotions/edit/${promotion.id}" class="btn btn-sm btn-primary">
                                    <i class="fas fa-edit"></i> Sửa
                                </a>
                                <button class="btn btn-sm btn-danger" onclick="confirmDelete(${promotion.id})">
                                    <i class="fas fa-trash"></i> Xóa
                                </button>
                                <c:if test="${promotion.status ne 'ACTIVE'}">
                                    <form action="/admin/promotions/${promotion.id}/status" method="post" style="display: inline;">
                                        <input type="hidden" name="status" value="ACTIVE">
                                        <button type="submit" class="btn btn-sm btn-success">
                                            <i class="fas fa-check"></i> Kích hoạt
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${promotion.status ne 'INACTIVE'}">
                                    <form action="/admin/promotions/${promotion.id}/status" method="post" style="display: inline;">
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
            <p>Bạn có chắc chắn muốn xóa khuyến mãi này không?</p>
            <div class="modal-actions">
                <form id="deleteForm" action="/admin/promotions/delete/" method="post">
                    <button type="submit" class="btn btn-danger">Xóa</button>
                </form>
                <button class="btn btn-secondary" onclick="closeModal()">Hủy</button>
            </div>
        </div>
    </div>

    <script>
        // Filter promotions
        document.getElementById('statusFilter').addEventListener('change', filterPromotions);
        document.getElementById('typeFilter').addEventListener('change', filterPromotions);
        
        function filterPromotions() {
            const statusFilter = document.getElementById('statusFilter').value;
            const typeFilter = document.getElementById('typeFilter').value;
            
            const promotionCards = document.querySelectorAll('.promotion-card');
            
            promotionCards.forEach(card => {
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
            
            deleteForm.action = `/admin/promotions/delete/${id}`;
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
