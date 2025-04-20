<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý đặt sân - Sports Field Booking</title>
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
                    <li><a href="/admin/fields">Quản lý sân</a></li>
                    <li><a href="/admin/bookings" class="active">Quản lý đặt sân</a></li>
                    <li><a href="/admin/users">Quản lý người dùng</a></li>
                    <li><a href="/">Về trang chủ</a></li>
                </ul>
            </div>
        </div>

        <div class="admin-content">
            <div class="admin-header">
                <h1>Quản lý đặt sân</h1>
                <div class="admin-user">
                    <span>Xin chào, ${loggedUser}</span>
                    <a href="/logout" class="btn btn-sm btn-secondary">Đăng xuất</a>
                </div>
            </div>

            <c:if test="${param.success eq 'confirmed'}">
                <div class="success-message">Xác nhận đặt sân thành công!</div>
            </c:if>
            <c:if test="${param.success eq 'cancelled'}">
                <div class="success-message">Hủy đặt sân thành công!</div>
            </c:if>
            <c:if test="${param.success eq 'completed'}">
                <div class="success-message">Đánh dấu hoàn thành thành công!</div>
            </c:if>

            <div class="admin-table-container">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Người dùng</th>
                            <th>Sân</th>
                            <th>Thời gian bắt đầu</th>
                            <th>Thời gian kết thúc</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${bookings}" var="booking">
                            <tr>
                                <td>${booking.id}</td>
                                <td>${booking.username}</td>
                                <td>${booking.fieldId}</td>
                                <td><fmt:formatDate value="${booking.startTime}" pattern="dd/MM/yyyy HH:mm" /></td>
                                <td><fmt:formatDate value="${booking.endTime}" pattern="dd/MM/yyyy HH:mm" /></td>
                                <td><fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol=""/> VNĐ</td>
                                <td>
                                    <span class="status ${booking.status eq 'PENDING' ? 'pending' : booking.status eq 'CONFIRMED' ? 'confirmed' : booking.status eq 'COMPLETED' ? 'completed' : 'cancelled'}">
                                        <c:choose>
                                            <c:when test="${booking.status eq 'PENDING'}">Chờ xác nhận</c:when>
                                            <c:when test="${booking.status eq 'CONFIRMED'}">Đã xác nhận</c:when>
                                            <c:when test="${booking.status eq 'COMPLETED'}">Đã hoàn thành</c:when>
                                            <c:when test="${booking.status eq 'CANCELLED'}">Đã hủy</c:when>
                                        </c:choose>
                                    </span>
                                </td>
                                <td class="actions">
                                    <c:if test="${booking.status eq 'PENDING'}">
                                        <form action="/admin/bookings/${booking.id}/confirm" method="post" class="inline-form">
                                            <button type="submit" class="btn btn-sm btn-primary">Xác nhận</button>
                                        </form>
                                        <form action="/admin/bookings/${booking.id}/cancel" method="post" class="inline-form" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đặt sân này?');">
                                            <button type="submit" class="btn btn-sm btn-danger">Hủy</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${booking.status eq 'CONFIRMED'}">
                                        <form action="/admin/bookings/${booking.id}/complete" method="post" class="inline-form">
                                            <button type="submit" class="btn btn-sm btn-primary">Hoàn thành</button>
                                        </form>
                                        <form action="/admin/bookings/${booking.id}/cancel" method="post" class="inline-form" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đặt sân này?');">
                                            <button type="submit" class="btn btn-sm btn-danger">Hủy</button>
                                        </form>
                                    </c:if>
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
