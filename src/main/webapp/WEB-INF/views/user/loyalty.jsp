<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Điểm tích lũy - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .loyalty-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .loyalty-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .loyalty-title {
            font-size: 28px;
            color: #333;
            margin-bottom: 10px;
        }
        
        .loyalty-subtitle {
            font-size: 16px;
            color: #666;
        }
        
        .loyalty-card {
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            color: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
        }
        
        .loyalty-card::before {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            z-index: 0;
        }
        
        .loyalty-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            position: relative;
            z-index: 1;
        }
        
        .loyalty-card-title {
            font-size: 24px;
            font-weight: 600;
        }
        
        .loyalty-card-level {
            font-size: 18px;
            font-weight: 600;
            padding: 5px 15px;
            background-color: rgba(255, 255, 255, 0.2);
            border-radius: 20px;
        }
        
        .loyalty-card-points {
            font-size: 48px;
            font-weight: 700;
            margin: 20px 0;
            position: relative;
            z-index: 1;
        }
        
        .loyalty-card-info {
            display: flex;
            justify-content: space-between;
            position: relative;
            z-index: 1;
        }
        
        .loyalty-card-item {
            text-align: center;
        }
        
        .loyalty-card-label {
            font-size: 14px;
            opacity: 0.8;
            margin-bottom: 5px;
        }
        
        .loyalty-card-value {
            font-size: 18px;
            font-weight: 600;
        }
        
        .loyalty-progress {
            margin-top: 20px;
            position: relative;
            z-index: 1;
        }
        
        .loyalty-progress-bar {
            height: 10px;
            background-color: rgba(255, 255, 255, 0.2);
            border-radius: 5px;
            overflow: hidden;
            margin-bottom: 10px;
        }
        
        .loyalty-progress-fill {
            height: 100%;
            background-color: rgba(255, 255, 255, 0.8);
            border-radius: 5px;
        }
        
        .loyalty-progress-labels {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            opacity: 0.8;
        }
        
        .loyalty-benefits {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        .loyalty-benefits-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .benefits-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 15px;
        }
        
        .benefit-item {
            display: flex;
            align-items: center;
            padding: 10px;
            border-radius: 8px;
            background-color: #f9f9f9;
        }
        
        .benefit-icon {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #e3f2fd;
            color: #1565c0;
            border-radius: 50%;
            margin-right: 15px;
            flex-shrink: 0;
        }
        
        .benefit-text {
            font-size: 14px;
            color: #333;
        }
        
        .transactions-section {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        .transactions-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .transactions-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .transactions-table th, .transactions-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .transactions-table th {
            font-weight: 600;
            color: #333;
            background-color: #f8f9fa;
        }
        
        .transactions-table tr:last-child td {
            border-bottom: none;
        }
        
        .transactions-table tr:hover {
            background-color: #f5f5f5;
        }
        
        .transaction-type {
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .type-earn {
            background-color: #e8f5e9;
            color: #2e7d32;
        }
        
        .type-use {
            background-color: #ffebee;
            color: #c62828;
        }
        
        .type-expire {
            background-color: #f5f5f5;
            color: #757575;
        }
        
        .type-adjust {
            background-color: #e3f2fd;
            color: #1565c0;
        }
        
        .points-value {
            font-weight: 600;
        }
        
        .points-positive {
            color: #2e7d32;
        }
        
        .points-negative {
            color: #c62828;
        }
        
        .no-transactions {
            padding: 20px;
            text-align: center;
            color: #757575;
            font-style: italic;
        }
    </style>
</head>
<body>
    <jsp:include page="../components/navbar.jsp" />
    
    <div class="loyalty-container">
        <div class="loyalty-header">
            <h1 class="loyalty-title">Điểm tích lũy của bạn</h1>
            <p class="loyalty-subtitle">Tích điểm với mỗi lần đặt sân và nhận nhiều ưu đãi hấp dẫn</p>
        </div>
        
        <div class="loyalty-card">
            <div class="loyalty-card-header">
                <div class="loyalty-card-title">Thẻ thành viên</div>
                <div class="loyalty-card-level">${loyaltyPoint.getMembershipLevel()}</div>
            </div>
            
            <div class="loyalty-card-points">
                ${loyaltyPoint.points} <span style="font-size: 24px;">điểm</span>
            </div>
            
            <div class="loyalty-card-info">
                <div class="loyalty-card-item">
                    <div class="loyalty-card-label">Tổng điểm đã tích</div>
                    <div class="loyalty-card-value">${loyaltyPoint.totalEarnedPoints}</div>
                </div>
                <div class="loyalty-card-item">
                    <div class="loyalty-card-label">Điểm đã sử dụng</div>
                    <div class="loyalty-card-value">${loyaltyPoint.totalUsedPoints}</div>
                </div>
                <div class="loyalty-card-item">
                    <div class="loyalty-card-label">Ưu đãi thành viên</div>
                    <div class="loyalty-card-value">Giảm ${loyaltyPoint.getDiscountRate()}%</div>
                </div>
            </div>
            
            <div class="loyalty-progress">
                <div class="loyalty-progress-bar">
                    <c:choose>
                        <c:when test="${loyaltyPoint.totalEarnedPoints >= 1000}">
                            <div class="loyalty-progress-fill" style="width: 100%"></div>
                        </c:when>
                        <c:when test="${loyaltyPoint.totalEarnedPoints >= 500}">
                            <div class="loyalty-progress-fill" style="width: 75%"></div>
                        </c:when>
                        <c:when test="${loyaltyPoint.totalEarnedPoints >= 200}">
                            <div class="loyalty-progress-fill" style="width: 50%"></div>
                        </c:when>
                        <c:otherwise>
                            <div class="loyalty-progress-fill" style="width: ${loyaltyPoint.totalEarnedPoints / 200 * 50}%"></div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="loyalty-progress-labels">
                    <div>Bronze</div>
                    <div>Silver (200)</div>
                    <div>Gold (500)</div>
                    <div>VIP (1000)</div>
                </div>
            </div>
        </div>
        
        <div class="loyalty-benefits">
            <h2 class="loyalty-benefits-title">Quyền lợi thành viên</h2>
            <div class="benefits-list">
                <div class="benefit-item">
                    <div class="benefit-icon">
                        <i class="fas fa-percent"></i>
                    </div>
                    <div class="benefit-text">
                        <strong>Bronze:</strong> Giảm 2% cho mỗi lần đặt sân
                    </div>
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon">
                        <i class="fas fa-percent"></i>
                    </div>
                    <div class="benefit-text">
                        <strong>Silver:</strong> Giảm 5% cho mỗi lần đặt sân
                    </div>
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon">
                        <i class="fas fa-percent"></i>
                    </div>
                    <div class="benefit-text">
                        <strong>Gold:</strong> Giảm 7% cho mỗi lần đặt sân
                    </div>
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon">
                        <i class="fas fa-percent"></i>
                    </div>
                    <div class="benefit-text">
                        <strong>VIP:</strong> Giảm 10% cho mỗi lần đặt sân
                    </div>
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon">
                        <i class="fas fa-exchange-alt"></i>
                    </div>
                    <div class="benefit-text">
                        Đổi điểm để giảm giá: 1 điểm = 1,000 VNĐ
                    </div>
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon">
                        <i class="fas fa-gift"></i>
                    </div>
                    <div class="benefit-text">
                        Nhận mã giảm giá độc quyền cho thành viên
                    </div>
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon">
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                    <div class="benefit-text">
                        Ưu tiên đặt sân vào giờ cao điểm
                    </div>
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <div class="benefit-text">
                        Tích điểm với mỗi 10,000 VNĐ = 1 điểm
                    </div>
                </div>
            </div>
        </div>
        
        <div class="transactions-section">
            <h2 class="transactions-title">Lịch sử giao dịch điểm</h2>
            
            <c:if test="${empty transactions}">
                <div class="no-transactions">Chưa có giao dịch điểm nào.</div>
            </c:if>
            
            <c:if test="${not empty transactions}">
                <table class="transactions-table">
                    <thead>
                        <tr>
                            <th>Thời gian</th>
                            <th>Loại giao dịch</th>
                            <th>Điểm</th>
                            <th>Mô tả</th>
                            <th>ID đặt sân</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${transactions}" var="transaction">
                            <tr>
                                <td><fmt:formatDate value="${transaction.transactionDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                <td>
                                    <span class="transaction-type type-${transaction.type.toString().toLowerCase()}">
                                        <c:choose>
                                            <c:when test="${transaction.type eq 'EARN'}">Tích điểm</c:when>
                                            <c:when test="${transaction.type eq 'USE'}">Sử dụng</c:when>
                                            <c:when test="${transaction.type eq 'EXPIRE'}">Hết hạn</c:when>
                                            <c:when test="${transaction.type eq 'ADJUST'}">Điều chỉnh</c:when>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <span class="points-value ${transaction.type eq 'EARN' || transaction.type eq 'ADJUST' && transaction.points > 0 ? 'points-positive' : 'points-negative'}">
                                        ${transaction.type eq 'EARN' || transaction.type eq 'ADJUST' && transaction.points > 0 ? '+' : '-'}${Math.abs(transaction.points)}
                                    </span>
                                </td>
                                <td>${transaction.description}</td>
                                <td>
                                    <c:if test="${transaction.bookingId != null}">
                                        <a href="/bookings/${transaction.bookingId}">#${transaction.bookingId}</a>
                                    </c:if>
                                    <c:if test="${transaction.bookingId == null}">-</c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
    </div>
    
    <jsp:include page="../components/footer.jsp" />
</body>
</html>
