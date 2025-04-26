<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${isNew ? 'Thêm' : 'Sửa'} mã giảm giá - Sports Field Booking</title>
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
        
        .code-input-group {
            display: flex;
            gap: 10px;
        }
        
        .code-input-group .form-control {
            flex: 1;
        }
        
        .code-input-group .btn {
            white-space: nowrap;
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
                <h1>${isNew ? 'Thêm' : 'Sửa'} mã giảm giá</h1>
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

            <c:if test="${param.error eq 'codeExists'}">
                <div class="error-message">Mã giảm giá đã tồn tại! Vui lòng chọn mã khác.</div>
            </c:if>

            <div class="form-container">
                <h2 class="form-title">
                    <i class="fas fa-${isNew ? 'plus' : 'edit'}"></i> 
                    ${isNew ? 'Thêm mã giảm giá mới' : 'Chỉnh sửa mã giảm giá'}
                </h2>

                <form action="/admin/coupons/${isNew ? 'add' : 'edit/'.concat(coupon.id)}" method="post">
                    <c:if test="${isNew}">
                        <div class="form-group">
                            <label for="code" class="form-label">Mã giảm giá <span class="required">*</span></label>
                            <div class="code-input-group">
                                <input type="text" id="code" name="code" class="form-control" value="${randomCode}" required>
                                <a href="/admin/coupons/generate-code" class="btn btn-secondary">
                                    <i class="fas fa-sync-alt"></i> Tạo mã mới
                                </a>
                            </div>
                            <div class="help-text">Mã giảm giá phải là duy nhất</div>
                        </div>
                    </c:if>
                    <c:if test="${!isNew}">
                        <div class="form-group">
                            <label for="code" class="form-label">Mã giảm giá</label>
                            <input type="text" id="code" class="form-control" value="${coupon.code}" readonly>
                            <div class="help-text">Mã giảm giá không thể thay đổi sau khi tạo</div>
                        </div>
                    </c:if>

                    <div class="form-group">
                        <label for="name" class="form-label">Tên mã giảm giá <span class="required">*</span></label>
                        <input type="text" id="name" name="name" class="form-control" value="${coupon.name}" required>
                    </div>

                    <div class="form-group">
                        <label for="description" class="form-label">Mô tả <span class="required">*</span></label>
                        <textarea id="description" name="description" class="form-control" rows="3" required>${coupon.description}</textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label for="type" class="form-label">Loại mã giảm giá <span class="required">*</span></label>
                                <select id="type" name="type" class="form-control" required>
                                    <c:forEach items="${couponTypes}" var="type">
                                        <option value="${type}" ${coupon.type eq type ? 'selected' : ''}>
                                            <c:choose>
                                                <c:when test="${type eq 'PERCENTAGE'}">Giảm theo phần trăm (%)</c:when>
                                                <c:when test="${type eq 'FIXED_AMOUNT'}">Giảm số tiền cố định</c:when>
                                            </c:choose>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-col">
                            <div class="form-group">
                                <label for="value" class="form-label">Giá trị <span class="required">*</span></label>
                                <input type="number" id="value" name="value" class="form-control" value="${coupon.value}" min="0" step="0.01" required>
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
                                <input type="number" id="minBookingValue" name="minBookingValue" class="form-control" value="${coupon.minBookingValue}" min="0" required>
                            </div>
                        </div>
                        <div class="form-col">
                            <div class="form-group">
                                <label for="maxDiscountAmount" class="form-label">Giảm tối đa (VNĐ) <span class="required">*</span></label>
                                <input type="number" id="maxDiscountAmount" name="maxDiscountAmount" class="form-control" value="${coupon.maxDiscountAmount}" min="0" required>
                                <div class="help-text">Áp dụng cho loại giảm theo phần trăm</div>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label for="startDate" class="form-label">Thời gian bắt đầu <span class="required">*</span></label>
                                <input type="datetime-local" id="startDate" name="startDate" class="form-control" 
                                    value="<fmt:formatDate value="${coupon.startDate}" pattern="yyyy-MM-dd'T'HH:mm" />" required>
                            </div>
                        </div>
                        <div class="form-col">
                            <div class="form-group">
                                <label for="endDate" class="form-label">Thời gian kết thúc <span class="required">*</span></label>
                                <input type="datetime-local" id="endDate" name="endDate" class="form-control" 
                                    value="<fmt:formatDate value="${coupon.endDate}" pattern="yyyy-MM-dd'T'HH:mm" />" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-col">
                            <div class="form-group">
                                <label for="maxUsage" class="form-label">Số lần sử dụng tối đa <span class="required">*</span></label>
                                <input type="number" id="maxUsage" name="maxUsage" class="form-control" value="${coupon.maxUsage}" min="0" required>
                                <div class="help-text">Nhập 0 cho không giới hạn</div>
                            </div>
                        </div>
                        <div class="form-col">
                            <div class="form-group">
                                <label for="maxUsagePerUser" class="form-label">Số lần sử dụng tối đa/người <span class="required">*</span></label>
                                <input type="number" id="maxUsagePerUser" name="maxUsagePerUser" class="form-control" value="${coupon.maxUsagePerUser}" min="0" required>
                                <div class="help-text">Nhập 0 cho không giới hạn</div>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="status" class="form-label">Trạng thái <span class="required">*</span></label>
                        <select id="status" name="status" class="form-control" required>
                            <c:forEach items="${couponStatuses}" var="status">
                                <option value="${status}" ${coupon.status eq status ? 'selected' : ''}>
                                    <c:choose>
                                        <c:when test="${status eq 'ACTIVE'}">Đang hoạt động</c:when>
                                        <c:when test="${status eq 'INACTIVE'}">Không hoạt động</c:when>
                                        <c:when test="${status eq 'EXPIRED'}">Đã hết hạn</c:when>
                                    </c:choose>
                                </option>
                            </c:forEach>
                        </select>
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
                        <a href="/admin/coupons" class="btn btn-cancel">Hủy</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-${isNew ? 'plus' : 'save'}"></i> 
                            ${isNew ? 'Thêm mã giảm giá' : 'Lưu thay đổi'}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Update help text based on coupon type
        document.getElementById('type').addEventListener('change', updateValueHelp);
        
        function updateValueHelp() {
            const type = document.getElementById('type').value;
            const valueHelp = document.getElementById('valueHelp');
            
            if (type === 'PERCENTAGE') {
                valueHelp.textContent = 'Nhập phần trăm giảm giá (ví dụ: 10 cho 10%)';
            } else if (type === 'FIXED_AMOUNT') {
                valueHelp.textContent = 'Nhập số tiền giảm giá cố định (VNĐ)';
            }
        }
        
        // Call on page load
        updateValueHelp();
    </script>
</body>
</html>
