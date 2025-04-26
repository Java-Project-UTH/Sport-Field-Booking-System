<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${isNew ? 'Thêm' : 'Sửa'} khuyến mãi - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .form-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-top: 20px;
        }
        
        .form-title {
            margin-top: 0;
            margin-bottom: 20px;
            font-size: 24px;
            color: #333;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
        }
        
        .form-group {
            margin-bottom: 20px;
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
        
        .form-control:focus {
            border-color: #2196F3;
            outline: none;
            box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.1);
        }
        
        .form-row {
            display: flex;
            flex-wrap: wrap;
            margin: 0 -10px;
        }
        
        .form-col {
            flex: 1;
            padding: 0 10px;
            min-width: 200px;
        }
        
        .checkbox-group {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 10px;
        }
        
        .checkbox-item {
            display: flex;
            align-items: center;
            margin-right: 15px;
        }
        
        .checkbox-item input[type="checkbox"] {
            margin-right: 5px;
        }
        
        .form-actions {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        
        .btn-cancel {
            background-color: #f5f5f5;
            color: #333;
            border: 1px solid #ddd;
        }
        
        .btn-cancel:hover {
            background-color: #e0e0e0;
        }
        
        .help-text {
            font-size: 12px;
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
                    <li><a href="/admin/promotions" class="active">Quản lý khuyến mãi</a></li>
                    <li><a href="/admin/coupons">Quản lý mã giảm giá</a></li>
                    <li><a href="/user/profile">Thông tin cá nhân</a></li>
                    <li><a href="/">Về trang chủ</a></li>
                </ul>
            </div>
        </div>

        <div class="admin-content">
            <div class="admin-header">
                <h1>${isNew ? 'Thêm' : 'Sửa'} khuyến mãi</h1>
                <div class="admin-user">
                    <span>Xin chào, ${loggedUser}</span>
                    <a href="/logout" class="btn btn-sm btn-secondary">Đăng xuất</a>
                </div>
            </div>

            <div class="admin-actions">
                <a href="/admin/promotions" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>

            <div class="form-container">
                <h2 class="form-title">
                    <i class="fas fa-${isNew ? 'plus' : 'edit'}"></i> 
                    ${isNew ? 'Thêm khuyến mãi mới' : 'Chỉnh sửa khuyến mãi'}
                </h2>

                <form action="/admin/promotions/${isNew ? 'add' : 'edit/'.concat(promotion.id)}" method="post">
                    <div class="form-group">
                        <label for="name" class="form-label">Tên khuyến mãi <span class="required">*</span></label>
                        <input type="text" id="name" name="name" class="form-control" value="${promotion.name}" required>
                    </div>

                    <div class="form-group">
                        <label for="description" class="form-label">Mô tả <span class="required">*</span></label>
                        <textarea id="description" name="description" class="form-control" rows="3" required>${promotion.description}</textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label for="type" class="form-label">Loại khuyến mãi <span class="required">*</span></label>
                                <select id="type" name="type" class="form-control" required>
                                    <c:forEach items="${promotionTypes}" var="type">
                                        <option value="${type}" ${promotion.type eq type ? 'selected' : ''}>
                                            <c:choose>
                                                <c:when test="${type eq 'PERCENTAGE'}">Giảm theo phần trăm (%)</c:when>
                                                <c:when test="${type eq 'FIXED_AMOUNT'}">Giảm số tiền cố định</c:when>
                                                <c:when test="${type eq 'SPECIAL_PRICE'}">Giá đặc biệt</c:when>
                                            </c:choose>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-col">
                            <div class="form-group">
                                <label for="value" class="form-label">Giá trị <span class="required">*</span></label>
                                <input type="number" id="value" name="value" class="form-control" value="${promotion.value}" min="0" step="0.01" required>
                                <div class="help-text">
                                    <span id="valueHelp">Nhập phần trăm giảm giá (ví dụ: 10 cho 10%)</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label for="minBookingValue" class="form-label">Giá trị đặt sân tối thiểu (VNĐ) <span class="required">*</span></label>
                                <input type="number" id="minBookingValue" name="minBookingValue" class="form-control" value="${promotion.minBookingValue}" min="0" required>
                            </div>
                        </div>
                        <div class="form-col">
                            <div class="form-group">
                                <label for="maxDiscountAmount" class="form-label">Giảm tối đa (VNĐ) <span class="required">*</span></label>
                                <input type="number" id="maxDiscountAmount" name="maxDiscountAmount" class="form-control" value="${promotion.maxDiscountAmount}" min="0" required>
                                <div class="help-text">Áp dụng cho loại giảm theo phần trăm</div>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label for="startDate" class="form-label">Thời gian bắt đầu <span class="required">*</span></label>
                                <input type="datetime-local" id="startDate" name="startDate" class="form-control" 
                                    value="<fmt:formatDate value="${promotion.startDate}" pattern="yyyy-MM-dd'T'HH:mm" />" required>
                            </div>
                        </div>
                        <div class="form-col">
                            <div class="form-group">
                                <label for="endDate" class="form-label">Thời gian kết thúc <span class="required">*</span></label>
                                <input type="datetime-local" id="endDate" name="endDate" class="form-control" 
                                    value="<fmt:formatDate value="${promotion.endDate}" pattern="yyyy-MM-dd'T'HH:mm" />" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="status" class="form-label">Trạng thái <span class="required">*</span></label>
                        <select id="status" name="status" class="form-control" required>
                            <c:forEach items="${promotionStatuses}" var="status">
                                <option value="${status}" ${promotion.status eq status ? 'selected' : ''}>
                                    <c:choose>
                                        <c:when test="${status eq 'ACTIVE'}">Đang hoạt động</c:when>
                                        <c:when test="${status eq 'INACTIVE'}">Không hoạt động</c:when>
                                        <c:when test="${status eq 'SCHEDULED'}">Đã lên lịch</c:when>
                                        <c:when test="${status eq 'EXPIRED'}">Đã hết hạn</c:when>
                                    </c:choose>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="imageUrl" class="form-label">URL hình ảnh</label>
                        <input type="text" id="imageUrl" name="imageUrl" class="form-control" value="${promotion.imageUrl}">
                        <div class="help-text">URL hình ảnh khuyến mãi (không bắt buộc)</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Loại sân áp dụng</label>
                        <div class="checkbox-group">
                            <c:forEach items="${fieldTypes}" var="fieldType">
                                <div class="checkbox-item">
                                    <input type="checkbox" id="fieldType_${fieldType}" name="fieldTypes" value="${fieldType}" 
                                        ${selectedFieldTypes.contains(fieldType.toString()) ? 'checked' : ''}>
                                    <label for="fieldType_${fieldType}">
                                        <c:choose>
                                            <c:when test="${fieldType eq 'FOOTBALL'}">Sân bóng đá</c:when>
                                            <c:when test="${fieldType eq 'BASKETBALL'}">Sân bóng rổ</c:when>
                                            <c:when test="${fieldType eq 'TENNIS'}">Sân tennis</c:when>
                                            <c:when test="${fieldType eq 'BADMINTON'}">Sân cầu lông</c:when>
                                            <c:when test="${fieldType eq 'VOLLEYBALL'}">Sân bóng chuyền</c:when>
                                            <c:when test="${fieldType eq 'SWIMMING'}">Hồ bơi</c:when>
                                        </c:choose>
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="help-text">Không chọn loại sân nào sẽ áp dụng cho tất cả các loại sân</div>
                    </div>

                    <div class="form-actions">
                        <a href="/admin/promotions" class="btn btn-cancel">Hủy</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-${isNew ? 'plus' : 'save'}"></i> 
                            ${isNew ? 'Thêm khuyến mãi' : 'Lưu thay đổi'}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Update help text based on promotion type
        document.getElementById('type').addEventListener('change', updateValueHelp);
        
        function updateValueHelp() {
            const type = document.getElementById('type').value;
            const valueHelp = document.getElementById('valueHelp');
            
            if (type === 'PERCENTAGE') {
                valueHelp.textContent = 'Nhập phần trăm giảm giá (ví dụ: 10 cho 10%)';
            } else if (type === 'FIXED_AMOUNT') {
                valueHelp.textContent = 'Nhập số tiền giảm giá cố định (VNĐ)';
            } else if (type === 'SPECIAL_PRICE') {
                valueHelp.textContent = 'Nhập giá đặc biệt (VNĐ)';
            }
        }
        
        // Call on page load
        updateValueHelp();
    </script>
</body>
</html>
