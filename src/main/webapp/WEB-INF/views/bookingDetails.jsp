<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đặt sân #${booking.id} - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        .booking-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .booking-actions .btn {
            margin: 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="navbar">
            <div class="navbar-brand">Sports Field Booking</div>
            <ul class="navbar-links">
                <li><a href="/">Trang chủ</a></li>
                <li><a href="/fields">Sân thể thao</a></li>
                <li><a href="/user/profile">Trang cá nhân</a></li>
            </ul>
            <div class="navbar-account">
                <span>Xin chào, ${booking.username}</span> | <a href="/logout">Đăng xuất</a>
            </div>
        </div>

        <div class="booking-details-container">
            <div class="booking-details-header">
                <a href="/user/profile" class="back-link">&larr; Quay lại trang cá nhân</a>
                <h2>Chi tiết đặt sân #${booking.id}</h2>

                <c:if test="${param.success eq 'created'}">
                    <div class="success-message">Đặt sân thành công! Vui lòng chờ xác nhận.</div>
                </c:if>
            </div>

            <div class="booking-details-content">
                <div class="booking-status-bar">
                    <div class="booking-status ${booking.status eq 'PENDING' ? 'pending' : booking.status eq 'CONFIRMED' ? 'confirmed' : booking.status eq 'COMPLETED' ? 'completed' : 'cancelled'}">
                        <span class="status-label">Trạng thái:</span>
                        <span class="status-value">
                            <c:choose>
                                <c:when test="${booking.status eq 'PENDING'}">Chờ xác nhận</c:when>
                                <c:when test="${booking.status eq 'CONFIRMED'}">Đã xác nhận</c:when>
                                <c:when test="${booking.status eq 'COMPLETED'}">Đã hoàn thành</c:when>
                                <c:when test="${booking.status eq 'CANCELLED'}">Đã hủy</c:when>
                            </c:choose>
                        </span>
                    </div>

                    <div class="booking-actions">
                        <c:if test="${booking.status eq 'PENDING'}">
                            <a href="/payment/${booking.id}" class="btn btn-primary">Thanh toán ngay</a>
                        </c:if>

                        <c:if test="${booking.status eq 'PENDING' || booking.status eq 'CONFIRMED'}">
                            <form action="/bookings/${booking.id}/cancel" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đặt sân này?');">
                                <button type="submit" class="btn btn-danger">Hủy đặt sân</button>
                            </form>
                        </c:if>
                    </div>
                </div>

                <div class="booking-details-main">
                    <div class="booking-field-info">
                        <h3>Thông tin sân</h3>
                        <c:if test="${not empty field}">
                            <div class="field-card horizontal">
                                <div class="field-image">
                                    <img src="${empty field.imageUrl ? '/images/default-field.jpg' : field.imageUrl}" alt="${field.fieldName}">
                                </div>
                                <div class="field-info">
                                    <h4>${field.fieldName}</h4>
                                    <p class="field-type">
                                        <c:choose>
                                            <c:when test="${field.fieldType eq 'FOOTBALL'}">Sân bóng đá</c:when>
                                            <c:when test="${field.fieldType eq 'BASKETBALL'}">Sân bóng rổ</c:when>
                                            <c:when test="${field.fieldType eq 'TENNIS'}">Sân tennis</c:when>
                                            <c:when test="${field.fieldType eq 'BADMINTON'}">Sân cầu lông</c:when>
                                            <c:when test="${field.fieldType eq 'VOLLEYBALL'}">Sân bóng chuyền</c:when>
                                            <c:when test="${field.fieldType eq 'SWIMMING'}">Hồ bơi</c:when>
                                            <c:otherwise>${field.fieldType}</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <p class="field-location"><i class="icon-location"></i> ${field.location}</p>
                                    <p class="field-features">
                                        <span class="${field.isIndoor ? 'feature-indoor' : 'feature-outdoor'}">
                                            ${field.isIndoor ? 'Trong nhà' : 'Ngoài trời'}
                                        </span>
                                        <c:if test="${field.hasLighting}">
                                            <span class="feature-lighting">Có đèn chiếu sáng</span>
                                        </c:if>
                                    </p>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <div class="booking-info-details">
                        <h3>Thông tin đặt sân</h3>
                        <div class="info-group">
                            <label>Mã đặt sân:</label>
                            <span>#${booking.id}</span>
                        </div>
                        <div class="info-group">
                            <label>Thời gian bắt đầu:</label>
                            <span><fmt:formatDate value="${booking.startTime}" pattern="dd/MM/yyyy HH:mm" /></span>
                        </div>
                        <div class="info-group">
                            <label>Thời gian kết thúc:</label>
                            <span><fmt:formatDate value="${booking.endTime}" pattern="dd/MM/yyyy HH:mm" /></span>
                        </div>
                        <div class="info-group">
                            <label>Số người chơi:</label>
                            <span>${booking.numberOfPlayers}</span>
                        </div>
                        <div class="info-group">
                            <label>Tổng tiền:</label>
                            <span><fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol=""/> VNĐ</span>
                        </div>
                        <c:if test="${not empty booking.notes}">
                            <div class="info-group">
                                <label>Ghi chú:</label>
                                <span>${booking.notes}</span>
                            </div>
                        </c:if>
                        <div class="info-group">
                            <label>Ngày đặt:</label>
                            <span><fmt:formatDate value="${booking.created_at}" pattern="dd/MM/yyyy HH:mm" /></span>
                        </div>
                    </div>
                </div>

                <c:if test="${booking.status eq 'COMPLETED'}">
                    <div class="booking-review-section">
                        <h3>Đánh giá sân</h3>
                        <p>Bạn đã sử dụng sân này? Hãy chia sẻ trải nghiệm của bạn!</p>
                        <a href="/fields/${booking.fieldId}#review-form" class="btn btn-primary">Viết đánh giá</a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="/js/script.js"></script>
</body>
</html>
