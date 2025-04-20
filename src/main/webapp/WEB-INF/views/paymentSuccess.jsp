<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh toán thành công - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        .success-container {
            max-width: 700px;
            margin: 50px auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            text-align: center;
            padding: 40px 20px;
        }

        .success-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            background-color: #4CAF50;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .success-icon:before {
            content: "✓";
            font-size: 40px;
            color: white;
        }

        .success-title {
            font-size: 24px;
            color: #333;
            margin-bottom: 10px;
        }

        .success-message {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
        }

        .booking-details {
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: left;
        }

        .booking-details h3 {
            margin-top: 0;
            margin-bottom: 15px;
            color: #333;
            text-align: center;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px dashed #eee;
        }

        .detail-item:last-child {
            border-bottom: none;
        }

        .detail-item.total {
            font-weight: bold;
            font-size: 1.1em;
            margin-top: 15px;
            padding-top: 10px;
            border-top: 2px solid #eee;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
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

        <div class="success-container">
            <div class="success-icon"></div>
            <h2 class="success-title">Thanh toán thành công!</h2>
            <p class="success-message">Cảm ơn bạn đã đặt sân. Đặt sân của bạn đã được xác nhận.</p>

            <div class="booking-details">
                <h3>Chi tiết đặt sân #${booking.id}</h3>

                <div class="detail-item">
                    <span>Sân:</span>
                    <span>${field.fieldName}</span>
                </div>

                <div class="detail-item">
                    <span>Loại sân:</span>
                    <span>
                        <c:choose>
                            <c:when test="${field.fieldType eq 'FOOTBALL'}">Sân bóng đá</c:when>
                            <c:when test="${field.fieldType eq 'BASKETBALL'}">Sân bóng rổ</c:when>
                            <c:when test="${field.fieldType eq 'TENNIS'}">Sân tennis</c:when>
                            <c:when test="${field.fieldType eq 'BADMINTON'}">Sân cầu lông</c:when>
                            <c:when test="${field.fieldType eq 'VOLLEYBALL'}">Sân bóng chuyền</c:when>
                            <c:when test="${field.fieldType eq 'SWIMMING'}">Hồ bơi</c:when>
                            <c:otherwise>${field.fieldType}</c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="detail-item">
                    <span>Địa điểm:</span>
                    <span>${field.location}</span>
                </div>

                <div class="detail-item">
                    <span>Thời gian bắt đầu:</span>
                    <span><fmt:formatDate value="${booking.startTime}" pattern="dd/MM/yyyy HH:mm" /></span>
                </div>

                <div class="detail-item">
                    <span>Thời gian kết thúc:</span>
                    <span><fmt:formatDate value="${booking.endTime}" pattern="dd/MM/yyyy HH:mm" /></span>
                </div>

                <div class="detail-item">
                    <span>Số người chơi:</span>
                    <span>${booking.numberOfPlayers}</span>
                </div>

                <div class="detail-item total">
                    <span>Tổng tiền:</span>
                    <span><fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol=""/> VNĐ</span>
                </div>
            </div>

            <c:if test="${not empty payment}">
                <div class="booking-details" style="margin-top: 20px;">
                    <h3>Thông tin thanh toán</h3>

                    <div class="detail-item">
                        <span>Mã giao dịch:</span>
                        <span>${payment.transactionId}</span>
                    </div>

                    <div class="detail-item">
                        <span>Phương thức thanh toán:</span>
                        <span>
                            <c:choose>
                                <c:when test="${payment.method eq 'CREDIT_CARD'}">Thẻ tín dụng/ghi nợ</c:when>
                                <c:when test="${payment.method eq 'BANK_TRANSFER'}">Internet Banking</c:when>
                                <c:when test="${payment.method eq 'E_WALLET'}">Ví điện tử</c:when>
                                <c:when test="${payment.method eq 'CASH'}">Thanh toán tại sân</c:when>
                                <c:otherwise>${payment.method}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="detail-item">
                        <span>Thời gian thanh toán:</span>
                        <span><fmt:formatDate value="${payment.paymentTime}" pattern="dd/MM/yyyy HH:mm:ss" /></span>
                    </div>

                    <div class="detail-item">
                        <span>Trạng thái:</span>
                        <span>
                            <c:choose>
                                <c:when test="${payment.status eq 'COMPLETED'}">Thành công</c:when>
                                <c:when test="${payment.status eq 'PENDING'}">Chờ xử lý</c:when>
                                <c:when test="${payment.status eq 'FAILED'}">Thất bại</c:when>
                                <c:when test="${payment.status eq 'REFUNDED'}">Hoàn tiền</c:when>
                                <c:otherwise>${payment.status}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <c:if test="${not empty payment.notes}">
                        <div class="detail-item">
                            <span>Ghi chú:</span>
                            <span>${payment.notes}</span>
                        </div>
                    </c:if>
                </div>
            </c:if>

            <div class="action-buttons">
                <a href="/bookings/${booking.id}" class="btn btn-primary">Xem chi tiết đặt sân</a>
                <a href="/user/profile" class="btn btn-secondary">Về trang cá nhân</a>
            </div>
        </div>
    </div>

    <script src="/js/script.js"></script>
</body>
</html>
