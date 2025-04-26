<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - Sports Field Booking</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/sidebar.css">
    <style>
        /* Trang thanh toán */
        .payment-container {
            max-width: 1000px;
            margin: 20px auto;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .payment-header {
            padding: 25px 30px;
            border-bottom: 1px solid #eee;
            background-color: #f8f9fa;
        }

        .payment-header h2 {
            margin: 10px 0;
            color: #2196F3;
            font-size: 24px;
            font-weight: 600;
        }

        /* Payment steps */
        .payment-steps {
            display: flex;
            justify-content: space-between;
            margin: 20px 0;
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

        .payment-content {
            display: flex;
            flex-wrap: wrap;
        }

        /* Phần thông tin đặt sân */
        .payment-summary {
            flex: 1;
            min-width: 300px;
            padding: 30px;
            border-right: 1px solid #eee;
            background-color: #fafafa;
        }

        .payment-form {
            flex: 1;
            min-width: 300px;
            padding: 30px;
            background-color: white;
        }

        .payment-summary h3, .payment-form h3 {
            margin-top: 0;
            margin-bottom: 25px;
            color: #333;
            font-size: 20px;
            font-weight: 600;
            position: relative;
            padding-bottom: 10px;
        }

        .payment-summary h3:after, .payment-form h3:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 3px;
            background-color: #2196F3;
        }

        /* Các mục thông tin */
        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px dashed #e0e0e0;
            font-size: 15px;
        }

        .summary-item:last-child {
            border-bottom: none;
        }

        .summary-item span:first-child {
            color: #666;
            font-weight: 500;
        }

        .summary-item span:last-child {
            color: #333;
            font-weight: 500;
        }

        .summary-item.total {
            font-weight: bold;
            font-size: 1.2em;
            margin-top: 25px;
            padding-top: 15px;
            border-top: 2px solid #e0e0e0;
            color: #2196F3;
        }

        .summary-item.total span:last-child {
            color: #2196F3;
            font-size: 1.1em;
        }

        /* Phương thức thanh toán */
        .payment-methods {
            margin-bottom: 30px;
        }

        .payment-method {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            padding: 18px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .payment-method:hover {
            background-color: #f5f5f5;
            border-color: #bdbdbd;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }

        .payment-method.active-method {
            background-color: #e3f2fd;
            border-color: #2196F3;
            border-width: 2px;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(33, 150, 243, 0.2);
        }

        .payment-method input {
            margin-right: 15px;
            transform: scale(1.2);
        }

        /* Thông tin thẻ */
        .card-details {
            margin-top: 25px;
            display: none;
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
            transition: all 0.3s ease;
        }

        .card-details.active {
            display: block;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 15px;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            border-color: #2196F3;
            outline: none;
            box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.1);
        }

        .form-row {
            display: flex;
            gap: 15px;
        }

        .form-row .form-group {
            flex: 1;
        }

        /* Nút thanh toán */
        .btn-block {
            width: 100%;
            padding: 14px;
            font-size: 16px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background-color: #2196F3;
            border: none;
        }

        .btn-primary:hover {
            background-color: #1976D2;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(33, 150, 243, 0.3);
        }

        /* Link quay lại */
        .back-link {
            display: inline-flex;
            align-items: center;
            margin-bottom: 10px;
            color: #666;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            color: #2196F3;
            text-decoration: none;
        }

        .back-link i {
            margin-right: 5px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .payment-content {
                flex-direction: column;
            }

            .payment-summary {
                border-right: none;
                border-bottom: 1px solid #eee;
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

        <div class="payment-container">
            <div class="payment-header">
                <a href="/bookings/${booking.id}" class="back-link"><i class="fas fa-arrow-left"></i> Quay lại chi tiết đặt sân</a>
                <h2><i class="fas fa-credit-card"></i> Thanh toán đặt sân #${booking.id}</h2>

                <div class="payment-steps">
                    <div class="step completed">
                        <div class="step-icon">1</div>
                        <div class="step-label">Chọn sân</div>
                    </div>
                    <div class="step completed">
                        <div class="step-icon">2</div>
                        <div class="step-label">Đặt sân</div>
                    </div>
                    <div class="step active">
                        <div class="step-icon">3</div>
                        <div class="step-label">Thanh toán</div>
                    </div>
                    <div class="step">
                        <div class="step-icon">4</div>
                        <div class="step-label">Hoàn tất</div>
                    </div>
                </div>
            </div>

            <div class="payment-content">
                <div class="payment-summary">
                    <h3><i class="fas fa-info-circle"></i> Thông tin đặt sân</h3>

                    <div class="summary-item">
                        <span><i class="fas fa-futbol"></i> Sân:</span>
                        <span>${field.fieldName}</span>
                    </div>

                    <div class="summary-item">
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

                    <div class="summary-item">
                        <span><i class="fas fa-map-marker-alt"></i> Địa điểm:</span>
                        <span>${field.location}</span>
                    </div>

                    <div class="summary-item">
                        <span><i class="fas fa-clock"></i> Thời gian bắt đầu:</span>
                        <span><fmt:formatDate value="${booking.startTime}" pattern="dd/MM/yyyy HH:mm" /></span>
                    </div>

                    <div class="summary-item">
                        <span><i class="fas fa-clock"></i> Thời gian kết thúc:</span>
                        <span><fmt:formatDate value="${booking.endTime}" pattern="dd/MM/yyyy HH:mm" /></span>
                    </div>

                    <div class="summary-item">
                        <span><i class="fas fa-users"></i> Số người chơi:</span>
                        <span>${booking.numberOfPlayers}</span>
                    </div>

                    <div class="summary-item total">
                        <span><i class="fas fa-money-bill-wave"></i> Tổng tiền:</span>
                        <span><fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol=""/> VNĐ</span>
                    </div>
                </div>

                <div class="payment-form">
                    <h3><i class="fas fa-wallet"></i> Phương thức thanh toán</h3>

                    <form action="/payment/process/${booking.id}" method="post" id="paymentForm">
                        <div class="payment-methods">
                            <label class="payment-method">
                                <input type="radio" name="paymentMethod" value="CREDIT_CARD" checked>
                                <i class="fas fa-credit-card" style="margin-right: 10px; color: #2196F3;"></i> Thẻ tín dụng/ghi nợ
                            </label>

                            <label class="payment-method">
                                <input type="radio" name="paymentMethod" value="BANK_TRANSFER">
                                <i class="fas fa-university" style="margin-right: 10px; color: #4CAF50;"></i> Internet Banking
                            </label>

                            <label class="payment-method">
                                <input type="radio" name="paymentMethod" value="E_WALLET">
                                <i class="fas fa-mobile-alt" style="margin-right: 10px; color: #FF9800;"></i> Ví điện tử (MoMo, ZaloPay, VNPay...)
                            </label>

                            <label class="payment-method">
                                <input type="radio" name="paymentMethod" value="CASH">
                                <i class="fas fa-money-bill-alt" style="margin-right: 10px; color: #4CAF50;"></i> Thanh toán tại sân
                            </label>
                        </div>

                        <div class="card-details active" id="cardDetails">
                            <div class="form-group">
                                <label for="cardNumber"><i class="far fa-credit-card"></i> Số thẻ:</label>
                                <input type="text" id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456" class="form-control">
                            </div>

                            <div class="form-group">
                                <label for="cardHolder"><i class="far fa-user"></i> Tên chủ thẻ:</label>
                                <input type="text" id="cardHolder" name="cardHolder" placeholder="NGUYEN VAN A" class="form-control">
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="expiryDate"><i class="far fa-calendar-alt"></i> Ngày hết hạn:</label>
                                    <input type="text" id="expiryDate" name="expiryDate" placeholder="MM/YY" class="form-control">
                                </div>

                                <div class="form-group">
                                    <label for="cvv"><i class="fas fa-lock"></i> CVV:</label>
                                    <input type="text" id="cvv" name="cvv" placeholder="123" class="form-control">
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <button type="submit" class="btn btn-primary btn-block">
                                <i class="fas fa-check-circle"></i> Hoàn tất thanh toán
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script src="/js/script.js"></script>
    <script src="/js/sidebar.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const paymentMethods = document.querySelectorAll('input[name="paymentMethod"]');
            const cardDetails = document.getElementById('cardDetails');
            const paymentMethodLabels = document.querySelectorAll('.payment-method');

            // Thêm hiệu ứng khi chọn phương thức thanh toán
            paymentMethods.forEach((method, index) => {
                method.addEventListener('change', function() {
                    // Xóa class active khỏi tất cả các phương thức
                    paymentMethodLabels.forEach(label => {
                        label.classList.remove('active-method');
                    });

                    // Thêm class active cho phương thức được chọn
                    this.closest('.payment-method').classList.add('active-method');

                    // Hiển thị/ẩn form thông tin thẻ
                    if (this.value === 'CREDIT_CARD') {
                        cardDetails.classList.add('active');
                        // Animation hiệu ứng
                        cardDetails.style.animation = 'none';
                        setTimeout(() => {
                            cardDetails.style.animation = 'fadeIn 0.5s ease';
                        }, 10);
                    } else {
                        cardDetails.classList.remove('active');
                    }
                });
            });

            // Tự động định dạng số thẻ
            const cardNumberInput = document.getElementById('cardNumber');
            if (cardNumberInput) {
                cardNumberInput.addEventListener('input', function(e) {
                    // Xóa các ký tự không phải số
                    let value = this.value.replace(/\D/g, '');
                    // Thêm khoảng trắng sau mỗi 4 số
                    value = value.replace(/(.{4})/g, '$1 ').trim();
                    // Giới hạn độ dài
                    if (value.length > 19) {
                        value = value.slice(0, 19);
                    }
                    this.value = value;
                });
            }

            // Tự động định dạng ngày hết hạn
            const expiryDateInput = document.getElementById('expiryDate');
            if (expiryDateInput) {
                expiryDateInput.addEventListener('input', function(e) {
                    // Xóa các ký tự không phải số
                    let value = this.value.replace(/\D/g, '');
                    // Thêm dấu / sau 2 số đầu tiên
                    if (value.length >= 2) {
                        value = value.slice(0, 2) + '/' + value.slice(2);
                    }
                    // Giới hạn độ dài
                    if (value.length > 5) {
                        value = value.slice(0, 5);
                    }
                    this.value = value;
                });
            }

            // Giới hạn độ dài CVV
            const cvvInput = document.getElementById('cvv');
            if (cvvInput) {
                cvvInput.addEventListener('input', function(e) {
                    // Xóa các ký tự không phải số
                    let value = this.value.replace(/\D/g, '');
                    // Giới hạn độ dài
                    if (value.length > 3) {
                        value = value.slice(0, 3);
                    }
                    this.value = value;
                });
            }

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

            // Đánh dấu phương thức thanh toán đầu tiên là active
            if (paymentMethodLabels.length > 0) {
                paymentMethodLabels[0].classList.add('active-method');
            }
        });
    </script>
</body>
</html>
