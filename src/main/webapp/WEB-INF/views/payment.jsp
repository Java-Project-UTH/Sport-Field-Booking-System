<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh toán - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        .payment-container {
            max-width: 900px;
            margin: 30px auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .payment-header {
            padding: 20px;
            border-bottom: 1px solid #eee;
        }

        .payment-header h2 {
            margin: 10px 0;
            color: #333;
        }

        .payment-content {
            display: flex;
            flex-wrap: wrap;
        }

        .payment-summary {
            flex: 1;
            min-width: 300px;
            padding: 20px;
            border-right: 1px solid #eee;
        }

        .payment-form {
            flex: 1;
            min-width: 300px;
            padding: 20px;
        }

        .payment-summary h3, .payment-form h3 {
            margin-top: 0;
            margin-bottom: 20px;
            color: #333;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px dashed #eee;
        }

        .summary-item:last-child {
            border-bottom: none;
        }

        .summary-item.total {
            font-weight: bold;
            font-size: 1.1em;
            margin-top: 20px;
            padding-top: 10px;
            border-top: 2px solid #eee;
        }

        .payment-methods {
            margin-bottom: 20px;
        }

        .payment-method {
            display: block;
            margin-bottom: 10px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
        }

        .payment-method:hover {
            background-color: #f9f9f9;
        }

        .payment-method input {
            margin-right: 10px;
        }

        .card-details {
            margin-top: 20px;
            display: none;
        }

        .card-details.active {
            display: block;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-row {
            display: flex;
            gap: 10px;
        }

        .form-row .form-group {
            flex: 1;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 10px;
            color: #666;
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
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

    <div class="payment-container">
        <div class="payment-header">
            <a href="/bookings/${booking.id}" class="back-link">&larr; Quay lại chi tiết đặt sân</a>
            <h2>Thanh toán đặt sân #${booking.id}</h2>
        </div>

        <div class="payment-content">
            <div class="payment-summary">
                <h3>Thông tin đặt sân</h3>

                <div class="summary-item">
                    <span>Sân:</span>
                    <span>${field.fieldName}</span>
                </div>

                <div class="summary-item">
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

                <div class="summary-item">
                    <span>Địa điểm:</span>
                    <span>${field.location}</span>
                </div>

                <div class="summary-item">
                    <span>Thời gian bắt đầu:</span>
                    <span><fmt:formatDate value="${booking.startTime}" pattern="dd/MM/yyyy HH:mm" /></span>
                </div>

                <div class="summary-item">
                    <span>Thời gian kết thúc:</span>
                    <span><fmt:formatDate value="${booking.endTime}" pattern="dd/MM/yyyy HH:mm" /></span>
                </div>

                <div class="summary-item">
                    <span>Số người chơi:</span>
                    <span>${booking.numberOfPlayers}</span>
                </div>

                <div class="summary-item total">
                    <span>Tổng tiền:</span>
                    <span><fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol=""/> VNĐ</span>
                </div>
            </div>

            <div class="payment-form">
                <h3>Phương thức thanh toán</h3>

                <form action="/payment/process/${booking.id}" method="post" id="paymentForm">
                    <div class="payment-methods">
                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="CREDIT_CARD" checked> Thẻ tín dụng/ghi nợ
                        </label>

                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="BANK_TRANSFER"> Internet Banking
                        </label>

                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="E_WALLET"> Ví điện tử (MoMo, ZaloPay, VNPay...)
                        </label>

                        <label class="payment-method">
                            <input type="radio" name="paymentMethod" value="CASH"> Thanh toán tại sân
                        </label>
                    </div>

                    <div class="card-details active" id="cardDetails">
                        <div class="form-group">
                            <label for="cardNumber">Số thẻ:</label>
                            <input type="text" id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456" class="form-control">
                        </div>

                        <div class="form-group">
                            <label for="cardHolder">Tên chủ thẻ:</label>
                            <input type="text" id="cardHolder" name="cardHolder" placeholder="NGUYEN VAN A" class="form-control">
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="expiryDate">Ngày hết hạn:</label>
                                <input type="text" id="expiryDate" name="expiryDate" placeholder="MM/YY" class="form-control">
                            </div>

                            <div class="form-group">
                                <label for="cvv">CVV:</label>
                                <input type="text" id="cvv" name="cvv" placeholder="123" class="form-control">
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary btn-block">Thanh toán</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="/js/script.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const paymentMethods = document.querySelectorAll('input[name="paymentMethod"]');
        const cardDetails = document.getElementById('cardDetails');

        paymentMethods.forEach(method => {
            method.addEventListener('change', function() {
                if (this.value === 'CREDIT_CARD') {
                    cardDetails.classList.add('active');
                } else {
                    cardDetails.classList.remove('active');
                }
            });
        });

        // Form validation
        document.getElementById('paymentForm').addEventListener('submit', function(event) {
            const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;

            if (paymentMethod === 'CREDIT_CARD') {
                const cardNumber = document.getElementById('cardNumber').value;
                const cardHolder = document.getElementById('cardHolder').value;
                const expiryDate = document.getElementById('expiryDate').value;
                const cvv = document.getElementById('cvv').value;

                if (!cardNumber || !cardHolder || !expiryDate || !cvv) {
                    event.preventDefault();
                    alert('Vui lòng điền đầy đủ thông tin thẻ.');
                }
            }
        });
    });
</script>
</body>
</html>
