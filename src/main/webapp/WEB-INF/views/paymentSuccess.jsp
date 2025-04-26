<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thành công - Sports Field Booking</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/sidebar.css">
    <style>
        /* Trang thanh toán thành công */
        .success-container {
            max-width: 800px;
            margin: 30px auto;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            text-align: center;
            padding: 40px 30px;
            position: relative;
            animation: fadeInUp 0.6s ease;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Biểu tượng thành công */
        .success-icon {
            width: 100px;
            height: 100px;
            margin: 0 auto 25px;
            background-color: #4CAF50;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.3);
            animation: scaleIn 0.5s ease 0.3s both;
        }

        @keyframes scaleIn {
            from { transform: scale(0.8); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }

        .success-icon:before {
            content: "\f00c"; /* Font Awesome check icon */
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            font-size: 50px;
            color: white;
        }

        /* Payment steps */
        .payment-steps {
            display: flex;
            justify-content: space-between;
            margin: 30px 0;
            position: relative;
        }

        .payment-steps::before {
            content: '';
            position: absolute;
            top: 15px;
            left: 0;
            right: 0;
            height: 2px;
            background-color: #e0e0e0;
            z-index: 1;
        }

        .step {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            z-index: 2;
        }

        .step-icon {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background-color: #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 8px;
            color: #fff;
            font-weight: 600;
            position: relative;
        }

        .step.active .step-icon {
            background-color: #2196F3;
        }

        .step.completed .step-icon {
            background-color: #4CAF50;
        }

        .step.completed .step-icon::after {
            content: '\f00c';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
        }

        .step-label {
            font-size: 14px;
            color: #757575;
            text-align: center;
        }

        .step.active .step-label {
            color: #2196F3;
            font-weight: 600;
        }

        .step.completed .step-label {
            color: #4CAF50;
            font-weight: 600;
        }

        /* Tiêu đề và thông báo */
        .success-title {
            font-size: 28px;
            color: #333;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .success-message {
            font-size: 18px;
            color: #666;
            margin-bottom: 35px;
            line-height: 1.6;
        }

        /* Chi tiết đặt sân */
        .booking-details {
            background-color: #f9f9f9;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 30px;
            text-align: left;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
            border: 1px solid #eee;
        }

        .booking-details h3 {
            margin-top: 0;
            margin-bottom: 20px;
            color: #2196F3;
            text-align: center;
            font-size: 20px;
            font-weight: 600;
            position: relative;
            padding-bottom: 10px;
        }

        .booking-details h3:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 3px;
            background-color: #2196F3;
        }

        /* Các mục thông tin */
        .detail-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px dashed #e0e0e0;
            font-size: 15px;
        }

        .detail-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .detail-item span:first-child {
            color: #666;
            font-weight: 500;
        }

        .detail-item span:last-child {
            color: #333;
            font-weight: 500;
        }

        .detail-item.total {
            font-weight: bold;
            font-size: 1.2em;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 2px solid #e0e0e0;
            color: #2196F3;
        }

        .detail-item.total span:last-child {
            color: #2196F3;
        }

        /* Nút hành động */
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
        }

        .action-buttons .btn {
            padding: 12px 25px;
            font-weight: 600;
            border-radius: 6px;
            transition: all 0.3s ease;
        }

        .action-buttons .btn-primary {
            background-color: #2196F3;
            color: white;
        }

        .action-buttons .btn-primary:hover {
            background-color: #1976D2;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(33, 150, 243, 0.3);
        }

        .action-buttons .btn-secondary {
            background-color: #f5f5f5;
            color: #333;
            border: 1px solid #ddd;
        }

        .action-buttons .btn-secondary:hover {
            background-color: #e0e0e0;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .success-container {
                padding: 30px 20px;
                margin: 20px auto;
            }

            .action-buttons {
                flex-direction: column;
                gap: 10px;
            }

            .action-buttons .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="main-container">
        <!-- Include Sidebar -->
        <jsp:include page="components/sidebar.jsp" />

        <div class="main-content">
            <!-- Include Top Navbar -->
            <jsp:include page="components/topnav.jsp" />

        <div class="success-container">
            <div class="payment-steps">
                <div class="step completed">
                    <div class="step-icon">1</div>
                    <div class="step-label">Chọn sân</div>
                </div>
                <div class="step completed">
                    <div class="step-icon">2</div>
                    <div class="step-label">Đặt sân</div>
                </div>
                <div class="step completed">
                    <div class="step-icon">3</div>
                    <div class="step-label">Thanh toán</div>
                </div>
                <div class="step completed active">
                    <div class="step-icon">4</div>
                    <div class="step-label">Hoàn tất</div>
                </div>
            </div>

            <div class="success-icon"></div>
            <h2 class="success-title">Thanh toán thành công!</h2>
            <p class="success-message">Cảm ơn bạn đã đặt sân. Đặt sân của bạn đã được xác nhận.</p>

            <div class="booking-details">
                <h3><i class="fas fa-info-circle"></i> Chi tiết đặt sân #${booking.id}</h3>

                <div class="detail-item">
                    <span><i class="fas fa-futbol"></i> Sân:</span>
                    <span>${field.fieldName}</span>
                </div>

                <div class="detail-item">
                    <span><i class="fas fa-tag"></i> Loại sân:</span>
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
                    <span><i class="fas fa-map-marker-alt"></i> Địa điểm:</span>
                    <span>${field.location}</span>
                </div>

                <div class="detail-item">
                    <span><i class="fas fa-clock"></i> Thời gian bắt đầu:</span>
                    <span><fmt:formatDate value="${booking.startTime}" pattern="dd/MM/yyyy HH:mm" /></span>
                </div>

                <div class="detail-item">
                    <span><i class="fas fa-clock"></i> Thời gian kết thúc:</span>
                    <span><fmt:formatDate value="${booking.endTime}" pattern="dd/MM/yyyy HH:mm" /></span>
                </div>

                <div class="detail-item">
                    <span><i class="fas fa-users"></i> Số người chơi:</span>
                    <span>${booking.numberOfPlayers}</span>
                </div>

                <div class="detail-item total">
                    <span><i class="fas fa-money-bill-wave"></i> Tổng tiền:</span>
                    <span><fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol=""/> VNĐ</span>
                </div>
            </div>

            <c:if test="${not empty payment}">
                <div class="booking-details" style="margin-top: 20px;">
                    <h3><i class="fas fa-receipt"></i> Thông tin thanh toán</h3>

                    <div class="detail-item">
                        <span><i class="fas fa-hashtag"></i> Mã giao dịch:</span>
                        <span>${payment.transactionId}</span>
                    </div>

                    <div class="detail-item">
                        <span><i class="fas fa-credit-card"></i> Phương thức thanh toán:</span>
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
                        <span><i class="fas fa-calendar-alt"></i> Thời gian thanh toán:</span>
                        <span><fmt:formatDate value="${payment.paymentTime}" pattern="dd/MM/yyyy HH:mm:ss" /></span>
                    </div>

                    <div class="detail-item">
                        <span><i class="fas fa-check-circle"></i> Trạng thái:</span>
                        <span>
                            <c:choose>
                                <c:when test="${payment.status eq 'COMPLETED'}"><span style="color: #4CAF50;">Thành công</span></c:when>
                                <c:when test="${payment.status eq 'PENDING'}"><span style="color: #FF9800;">Chờ xử lý</span></c:when>
                                <c:when test="${payment.status eq 'FAILED'}"><span style="color: #F44336;">Thất bại</span></c:when>
                                <c:when test="${payment.status eq 'REFUNDED'}"><span style="color: #2196F3;">Hoàn tiền</span></c:when>
                                <c:otherwise>${payment.status}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <c:if test="${not empty payment.notes}">
                        <div class="detail-item">
                            <span><i class="fas fa-sticky-note"></i> Ghi chú:</span>
                            <span>${payment.notes}</span>
                        </div>
                    </c:if>
                </div>
            </c:if>

            <div class="action-buttons">
                <a href="/bookings/${booking.id}" class="btn btn-primary"><i class="fas fa-info-circle"></i> Xem chi tiết đặt sân</a>
                <a href="/user/profile" class="btn btn-secondary"><i class="fas fa-user"></i> Về trang cá nhân</a>
            </div>
        </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script src="/js/script.js"></script>
    <script src="/js/sidebar.js"></script>
</body>
</html>
