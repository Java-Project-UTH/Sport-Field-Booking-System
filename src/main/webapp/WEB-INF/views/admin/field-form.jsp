<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${empty field ? 'Thêm sân mới' : 'Sửa sân'} - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/admin.css">
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
                    <li><a href="/admin/fields" class="active">Quản lý sân</a></li>
                    <li><a href="/admin/bookings">Quản lý đặt sân</a></li>
                    <li><a href="/admin/users">Quản lý người dùng</a></li>
                    <li><a href="/user/profile">Thông tin cá nhân</a></li>
                    <li><a href="/">Về trang chủ</a></li>
                </ul>
            </div>
        </div>

        <div class="admin-content">
            <div class="admin-header">
                <h1>${empty field ? 'Thêm sân mới' : 'Sửa sân'}</h1>
                <div class="admin-user">
                    <span>Xin chào, ${loggedUser}</span>
                    <a href="/logout" class="btn btn-sm btn-secondary">Đăng xuất</a>
                </div>
            </div>

            <div class="admin-form-container">
                <a href="/admin/fields" class="back-link">&larr; Quay lại danh sách sân</a>

                <form action="${empty field ? '/admin/fields/add' : '/admin/fields/edit/'.concat(field.id)}" method="post" class="admin-form">
                    <div class="form-group">
                        <label for="fieldName">Tên sân:</label>
                        <input type="text" id="fieldName" name="fieldName" value="${field.fieldName}" required>
                    </div>

                    <div class="form-group">
                        <label for="location">Địa điểm:</label>
                        <input type="text" id="location" name="location" value="${field.location}" required>
                    </div>

                    <div class="form-group">
                        <label for="fieldType">Loại sân:</label>
                        <select id="fieldType" name="fieldType" required>
                            <c:forEach items="${fieldTypes}" var="type">
                                <option value="${type}" ${field.fieldType eq type ? 'selected' : ''}>
                                    <c:choose>
                                        <c:when test="${type eq 'FOOTBALL'}">Sân bóng đá</c:when>
                                        <c:when test="${type eq 'BASKETBALL'}">Sân bóng rổ</c:when>
                                        <c:when test="${type eq 'TENNIS'}">Sân tennis</c:when>
                                        <c:when test="${type eq 'BADMINTON'}">Sân cầu lông</c:when>
                                        <c:when test="${type eq 'VOLLEYBALL'}">Sân bóng chuyền</c:when>
                                        <c:when test="${type eq 'SWIMMING'}">Hồ bơi</c:when>
                                        <c:otherwise>${type}</c:otherwise>
                                    </c:choose>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="pricePerHour">Giá thuê/giờ (VNĐ):</label>
                        <input type="number" id="pricePerHour" name="pricePerHour" value="${field.pricePerHour}" min="0" step="10000" required>
                    </div>

                    <div class="form-group">
                        <label>Loại sân:</label>
                        <div class="radio-group">
                            <label>
                                <input type="radio" name="isIndoor" value="true" ${field.isIndoor ? 'checked' : ''}>
                                Trong nhà
                            </label>
                            <label>
                                <input type="radio" name="isIndoor" value="false" ${empty field || !field.isIndoor ? 'checked' : ''}>
                                Ngoài trời
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Đèn chiếu sáng:</label>
                        <div class="radio-group">
                            <label>
                                <input type="radio" name="hasLighting" value="true" ${field.hasLighting ? 'checked' : ''}>
                                Có
                            </label>
                            <label>
                                <input type="radio" name="hasLighting" value="false" ${empty field || !field.hasLighting ? 'checked' : ''}>
                                Không
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="description">Mô tả:</label>
                        <textarea id="description" name="description" rows="4">${field.description}</textarea>
                    </div>

                    <div class="form-group">
                        <label for="imageUrl">URL hình ảnh:</label>
                        <input type="text" id="imageUrl" name="imageUrl" value="${field.imageUrl}">
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">${empty field ? 'Thêm sân' : 'Cập nhật sân'}</button>
                        <a href="/admin/fields" class="btn btn-secondary">Hủy</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="/js/script.js"></script>
</body>
</html>
