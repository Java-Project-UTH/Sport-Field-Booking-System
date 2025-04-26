<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gói thành viên - Sports Field Booking</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/sidebar.css">
    <style>
        .membership-container {
            padding: 30px;
        }
        
        .membership-header {
            margin-bottom: 30px;
            text-align: center;
        }
        
        .membership-header h1 {
            font-size: 32px;
            margin-bottom: 10px;
            color: #333;
        }
        
        .membership-header p {
            font-size: 16px;
            color: #666;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .membership-plans {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 30px;
            margin-top: 40px;
        }
        
        .plan-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            width: 300px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
        }
        
        .plan-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }
        
        .plan-header {
            padding: 20px;
            text-align: center;
            color: #fff;
        }
        
        .plan-free .plan-header {
            background-color: #4CAF50;
        }
        
        .plan-standard .plan-header {
            background-color: #2196F3;
        }
        
        .plan-premium .plan-header {
            background-color: #9C27B0;
        }
        
        .plan-name {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .plan-price {
            font-size: 36px;
            font-weight: bold;
            margin: 15px 0;
        }
        
        .plan-price .currency {
            font-size: 20px;
            vertical-align: super;
        }
        
        .plan-price .period {
            font-size: 14px;
            font-weight: normal;
        }
        
        .plan-features {
            padding: 20px;
        }
        
        .feature-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            font-size: 14px;
        }
        
        .feature-item i {
            margin-right: 10px;
            color: #4CAF50;
            font-size: 16px;
            width: 20px;
            text-align: center;
        }
        
        .feature-item.not-included i {
            color: #ccc;
        }
        
        .feature-item.not-included {
            color: #999;
        }
        
        .plan-footer {
            padding: 20px;
            text-align: center;
        }
        
        .btn-subscribe {
            display: inline-block;
            padding: 12px 30px;
            background-color: #4CAF50;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
            text-decoration: none;
            width: 100%;
        }
        
        .plan-free .btn-subscribe {
            background-color: #4CAF50;
        }
        
        .plan-standard .btn-subscribe {
            background-color: #2196F3;
        }
        
        .plan-premium .btn-subscribe {
            background-color: #9C27B0;
        }
        
        .btn-subscribe:hover {
            opacity: 0.9;
        }
        
        .current-plan-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: #FF5722;
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .current-membership {
            background-color: #f9f9f9;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        .current-membership h2 {
            margin-top: 0;
            color: #333;
            font-size: 24px;
            margin-bottom: 15px;
        }
        
        .membership-details {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        
        .membership-detail {
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
        
        .membership-actions {
            margin-top: 20px;
        }
        
        .membership-actions a {
            margin-right: 10px;
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
                <div class="membership-container">
                    <div class="membership-header">
                        <h1>Gói thành viên</h1>
                        <p>Nâng cấp tài khoản của bạn để nhận được nhiều ưu đãi hơn khi đặt sân.</p>
                    </div>
                    
                    <c:if test="${not empty param.success}">
                        <div class="success-message">
                            <c:choose>
                                <c:when test="${param.success eq 'subscribed'}">
                                    <i class="fas fa-check-circle"></i> Đăng ký gói thành viên thành công!
                                </c:when>
                                <c:when test="${param.success eq 'plansInitialized'}">
                                    <i class="fas fa-check-circle"></i> Khởi tạo gói thành viên thành công!
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-check-circle"></i> Thao tác thành công!
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty param.error}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i> Lỗi: ${param.error}
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty currentMembership}">
                        <div class="current-membership">
                            <h2>Gói thành viên hiện tại của bạn</h2>
                            <div class="membership-details">
                                <div class="membership-detail">
                                    <div class="detail-label">Gói:</div>
                                    <div class="detail-value">${currentMembership.plan.name}</div>
                                </div>
                                <div class="membership-detail">
                                    <div class="detail-label">Ngày bắt đầu:</div>
                                    <div class="detail-value"><fmt:formatDate value="${currentMembership.startDate}" pattern="dd/MM/yyyy" /></div>
                                </div>
                                <div class="membership-detail">
                                    <div class="detail-label">Ngày kết thúc:</div>
                                    <div class="detail-value"><fmt:formatDate value="${currentMembership.endDate}" pattern="dd/MM/yyyy" /></div>
                                </div>
                                <div class="membership-detail">
                                    <div class="detail-label">Đặt sân còn lại:</div>
                                    <div class="detail-value">${currentMembership.plan.maxBookingsPerMonth - currentMembership.bookingsUsedThisMonth}/${currentMembership.plan.maxBookingsPerMonth}</div>
                                </div>
                            </div>
                            <div class="membership-actions">
                                <a href="/membership/history" class="btn btn-secondary">Xem lịch sử gói thành viên</a>
                            </div>
                        </div>
                    </c:if>
                    
                    <div class="membership-plans">
                        <c:forEach items="${plans}" var="plan">
                            <div class="plan-card plan-${plan.planType.toString().toLowerCase()}">
                                <c:if test="${not empty currentMembership && currentMembership.plan.id eq plan.id}">
                                    <div class="current-plan-badge">Gói hiện tại</div>
                                </c:if>
                                <div class="plan-header">
                                    <div class="plan-name">${plan.name}</div>
                                    <div class="plan-price">
                                        <c:choose>
                                            <c:when test="${plan.price eq 0}">
                                                Miễn phí
                                            </c:when>
                                            <c:otherwise>
                                                <span class="currency">₫</span><fmt:formatNumber value="${plan.price}" type="number" pattern="#,###"/>
                                                <span class="period">/${plan.durationDays} ngày</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="plan-features">
                                    <div class="feature-item">
                                        <i class="fas fa-calendar-check"></i>
                                        <span>${plan.maxBookingsPerMonth} lượt đặt sân/tháng</span>
                                    </div>
                                    <div class="feature-item">
                                        <i class="fas fa-calendar-alt"></i>
                                        <span>Đặt trước tối đa ${plan.maxBookingDaysInAdvance} ngày</span>
                                    </div>
                                    <div class="feature-item ${plan.discountPercentage > 0 ? '' : 'not-included'}">
                                        <i class="fas ${plan.discountPercentage > 0 ? 'fa-percent' : 'fa-times'}"></i>
                                        <span>
                                            <c:choose>
                                                <c:when test="${plan.discountPercentage > 0}">
                                                    Giảm giá ${plan.discountPercentage}%
                                                </c:when>
                                                <c:otherwise>
                                                    Không có giảm giá
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="feature-item ${plan.prioritySupport ? '' : 'not-included'}">
                                        <i class="fas ${plan.prioritySupport ? 'fa-headset' : 'fa-times'}"></i>
                                        <span>
                                            <c:choose>
                                                <c:when test="${plan.prioritySupport}">
                                                    Hỗ trợ ưu tiên
                                                </c:when>
                                                <c:otherwise>
                                                    Không có hỗ trợ ưu tiên
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="feature-item ${plan.freeRescheduling ? '' : 'not-included'}">
                                        <i class="fas ${plan.freeRescheduling ? 'fa-exchange-alt' : 'fa-times'}"></i>
                                        <span>
                                            <c:choose>
                                                <c:when test="${plan.freeRescheduling}">
                                                    Đổi lịch miễn phí
                                                </c:when>
                                                <c:otherwise>
                                                    Không được đổi lịch miễn phí
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                                <div class="plan-footer">
                                    <c:choose>
                                        <c:when test="${not empty currentMembership && currentMembership.plan.id eq plan.id}">
                                            <button class="btn-subscribe" disabled>Gói hiện tại</button>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="/membership/subscribe/${plan.id}" class="btn-subscribe">Đăng ký ngay</a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
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
