<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý sân - Sports Field Booking</title>
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
                <h1>Quản lý sân thể thao</h1>
                <div class="admin-user">
                    <span>Xin chào, ${loggedUser}</span>
                    <a href="/logout" class="btn btn-sm btn-secondary">Đăng xuất</a>
                </div>
            </div>

            <c:if test="${param.success eq 'added'}">
                <div class="success-message">Thêm sân thành công!</div>
            </c:if>
            <c:if test="${param.success eq 'updated'}">
                <div class="success-message">Cập nhật sân thành công!</div>
            </c:if>
            <c:if test="${param.success eq 'deleted'}">
                <div class="success-message">Xóa sân thành công!</div>
            </c:if>

            <c:if test="${param.error eq 'notFound'}">
                <div class="error-message">Không tìm thấy sân!</div>
            </c:if>

            <div class="admin-actions">
                <a href="/admin/fields/add" class="btn btn-primary">Thêm sân mới</a>
            </div>

            <div class="admin-table-container">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên sân</th>
                            <th>Loại sân</th>
                            <th>Địa điểm</th>
                            <th>Giá/giờ</th>
                            <th>Trong nhà</th>
                            <th>Đèn</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${fields}" var="field">
                            <tr>
                                <td>${field.id}</td>
                                <td>${field.fieldName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${field.fieldType eq 'FOOTBALL'}">Sân bóng đá</c:when>
                                        <c:when test="${field.fieldType eq 'BASKETBALL'}">Sân bóng rổ</c:when>
                                        <c:when test="${field.fieldType eq 'TENNIS'}">Sân tennis</c:when>
                                        <c:when test="${field.fieldType eq 'BADMINTON'}">Sân cầu lông</c:when>
                                        <c:when test="${field.fieldType eq 'VOLLEYBALL'}">Sân bóng chuyền</c:when>
                                        <c:when test="${field.fieldType eq 'SWIMMING'}">Hồ bơi</c:when>
                                        <c:otherwise>${field.fieldType}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${field.location}</td>
                                <td><fmt:formatNumber value="${field.pricePerHour}" type="currency" currencySymbol=""/> VNĐ</td>
                                <td>${field.isIndoor ? 'Có' : 'Không'}</td>
                                <td>${field.hasLighting ? 'Có' : 'Không'}</td>
                                <td class="actions">
                                    <a href="/admin/fields/edit/${field.id}" class="btn btn-sm btn-secondary">Sửa</a>
                                    <form action="/admin/fields/delete/${field.id}" method="post" class="inline-form" onsubmit="return confirm('Bạn có chắc chắn muốn xóa sân này?');">
                                        <button type="submit" class="btn btn-sm btn-danger">Xóa</button>
                                    </form>
                                    <a href="/fields/${field.id}" class="btn btn-sm btn-primary" target="_blank">Xem</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="/js/script.js"></script>
</body>
</html>
