<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký gói ${plan.name} - Sports Field Booking</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/sidebar.css">
    <style>
        .subscription-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 30px;
        }
        
        .subscription-header {
            margin-bottom: 30px;
            text-align: center;
        }
        
        .subscription-header h1 {
            font-size: 28px;
            margin-bottom: 10px;
            color: #333;
        }
        
        .plan-summary {
            background-color: #f9f9f9;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        .plan-summary h2 {
            margin-top: 0;
            color: #333;
            font-size: 24px;
            margin-bottom: 15px;
        }
        
        .plan-details {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        
        .plan-detail {
            flex: 1;
            min-width: 200px;
        }
        
        .detail-label {
            font-weight: bold;
            color: #666;
            margin-bottom: 5px;
        }
        
        .detail-value {
            font-size: 18px;
            color: #333;
        }
        
        .payment-form {
            background-color: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        .payment-form h2 {
            margin-top: 0;
            color: #333;
            font-size: 24px;
            margin-bottom: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }
        
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        
        .payment-methods {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .payment-method {
            flex: 1;
            min-width: 120px;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .payment-method:hover {
            border-color: #2196F3;
        }
        
        .payment-method.selected {
            border-color: #2196F3;
            background-color: #E3F2FD;
        }
        
        .payment-method i {
            font-size: 24px;
            margin-bottom: 10px;
            color: #555;
        }
        
        .payment-method.selected i {
            color: #2196F3;
        }
        
        .payment-method-name {
            font-weight: bold;
        }
        
        .form-actions {
            margin-top: 30px;
            display: flex;
            justify-content: space-between;
        }
        
        .btn-subscribe {
            padding: 12px 30px;
            background-color: #4CAF50;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        
        .btn-subscribe:hover {
            background-color: #45a049;
        }
        
        .free-plan-notice {
            background-color: #E8F5E9;
            border-left: 4px solid #4CAF50;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        
        .free-plan-notice h3 {
            margin-top: 0;
            color: #2E7D32;
        }
        
        .free-plan-notice p {
            margin-bottom: 0;
            color: #388E3C;
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

            <div class="container">
                <div class="subscription-container">
                    <div class="subscription-header">
                        <h1>Đăng ký gói ${plan.name}</h1>
                        <p>Hoàn tất đăng ký gói thành viên của bạn</p>
                    </div>
                    
                    <c:if test="${not empty param.error}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i> Lỗi: ${param.error}
                        </div>
                    </c:if>
                    
                    <div class="plan-summary">
                        <h2>Thông tin gói</h2>
                        <div class="plan-details">
                            <div class="plan-detail">
                                <div class="detail-label">Tên gói:</div>
                                <div class="detail-value">${plan.name}</div>
                            </div>
                            <div class="plan-detail">
                                <div class="detail-label">Giá:</div>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${plan.price eq 0}">
                                            Miễn phí
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${plan.price}" type="number" pattern="#,###"/> VNĐ
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="plan-detail">
                                <div class="detail-label">Thời hạn:</div>
                                <div class="detail-value">
                                    <c:choose>
                                        <c:when test="${plan.durationDays eq 2147483647}">
                                            Không giới hạn
                                        </c:when>
                                        <c:otherwise>
                                            ${plan.durationDays} ngày
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="plan-detail">
                                <div class="detail-label">Số lượt đặt sân:</div>
                                <div class="detail-value">${plan.maxBookingsPerMonth} lượt/tháng</div>
                            </div>
                        </div>
                    </div>
                    
                    <form action="/membership/subscribe/${plan.id}" method="post" class="payment-form">
                        <c:choose>
                            <c:when test="${plan.price eq 0}">
                                <div class="free-plan-notice">
                                    <h3><i class="fas fa-gift"></i> Gói miễn phí</h3>
                                    <p>Bạn đang đăng ký gói miễn phí. Nhấn nút "Đăng ký ngay" để kích hoạt gói.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <h2>Thông tin thanh toán</h2>
                                
                                <div class="form-group">
                                    <label>Phương thức thanh toán:</label>
                                    <div class="payment-methods">
                                        <div class="payment-method" data-method="credit_card" onclick="selectPaymentMethod(this)">
                                            <i class="fas fa-credit-card"></i>
                                            <div class="payment-method-name">Thẻ tín dụng</div>
                                        </div>
                                        <div class="payment-method" data-method="bank_transfer" onclick="selectPaymentMethod(this)">
                                            <i class="fas fa-university"></i>
                                            <div class="payment-method-name">Chuyển khoản</div>
                                        </div>
                                        <div class="payment-method" data-method="momo" onclick="selectPaymentMethod(this)">
                                            <i class="fas fa-wallet"></i>
                                            <div class="payment-method-name">Ví MoMo</div>
                                        </div>
                                    </div>
                                    <input type="hidden" name="paymentMethod" id="paymentMethod" required>
                                </div>
                                
                                <div id="creditCardForm" class="payment-details" style="display: none;">
                                    <div class="form-group">
                                        <label for="cardNumber">Số thẻ:</label>
                                        <input type="text" id="cardNumber" placeholder="1234 5678 9012 3456">
                                    </div>
                                    <div class="form-group">
                                        <label for="cardName">Tên chủ thẻ:</label>
                                        <input type="text" id="cardName" placeholder="NGUYEN VAN A">
                                    </div>
                                    <div class="form-group" style="display: flex; gap: 15px;">
                                        <div style="flex: 1;">
                                            <label for="expiryDate">Ngày hết hạn:</label>
                                            <input type="text" id="expiryDate" placeholder="MM/YY">
                                        </div>
                                        <div style="flex: 1;">
                                            <label for="cvv">CVV:</label>
                                            <input type="text" id="cvv" placeholder="123">
                                        </div>
                                    </div>
                                </div>
                                
                                <div id="bankTransferForm" class="payment-details" style="display: none;">
                                    <div class="form-group">
                                        <p>Vui lòng chuyển khoản đến tài khoản sau:</p>
                                        <ul style="margin-left: 20px;">
                                            <li>Ngân hàng: Vietcombank</li>
                                            <li>Số tài khoản: 1234567890</li>
                                            <li>Chủ tài khoản: CÔNG TY SPORTS FIELD BOOKING</li>
                                            <li>Nội dung: ${loggedUser}_${plan.name}</li>
                                        </ul>
                                    </div>
                                    <div class="form-group">
                                        <label for="transferReference">Mã giao dịch:</label>
                                        <input type="text" id="transferReference" name="paymentReference" placeholder="Nhập mã giao dịch của bạn">
                                    </div>
                                </div>
                                
                                <div id="momoForm" class="payment-details" style="display: none;">
                                    <div class="form-group">
                                        <p>Vui lòng quét mã QR hoặc chuyển tiền đến số điện thoại:</p>
                                        <div style="text-align: center; margin: 20px 0;">
                                            <div style="font-size: 24px; font-weight: bold; color: #ae2070;">0987654321</div>
                                            <div style="margin-top: 10px;">CÔNG TY SPORTS FIELD BOOKING</div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="momoReference">Mã giao dịch MoMo:</label>
                                        <input type="text" id="momoReference" name="paymentReference" placeholder="Nhập mã giao dịch MoMo">
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        
                        <div class="form-actions">
                            <a href="/membership" class="btn btn-secondary">Quay lại</a>
                            <button type="submit" class="btn-subscribe">Đăng ký ngay</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script src="/js/script.js"></script>
    <script src="/js/sidebar.js"></script>
    <script>
        function selectPaymentMethod(element) {
            // Remove selected class from all payment methods
            document.querySelectorAll('.payment-method').forEach(method => {
                method.classList.remove('selected');
            });
            
            // Add selected class to clicked method
            element.classList.add('selected');
            
            // Set hidden input value
            const method = element.getAttribute('data-method');
            document.getElementById('paymentMethod').value = method;
            
            // Hide all payment detail forms
            document.querySelectorAll('.payment-details').forEach(form => {
                form.style.display = 'none';
            });
            
            // Show selected payment form
            if (method === 'credit_card') {
                document.getElementById('creditCardForm').style.display = 'block';
            } else if (method === 'bank_transfer') {
                document.getElementById('bankTransferForm').style.display = 'block';
            } else if (method === 'momo') {
                document.getElementById('momoForm').style.display = 'block';
            }
        }
    </script>
</body>
</html>
