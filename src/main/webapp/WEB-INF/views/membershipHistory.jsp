<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử gói thành viên - Sports Field Booking</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/sidebar.css">
    <style>
        .history-container {
            padding: 30px;
        }
        
        .history-header {
            margin-bottom: 30px;
        }
        
        .history-header h1 {
            font-size: 28px;
            margin-bottom: 10px;
            color: #333;
        }
        
        .history-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: #fff;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
            overflow: hidden;
        }
        
        .history-table th,
        .history-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .history-table th {
            background-color: #f5f5f5;
            font-weight: bold;
            color: #555;
        }
        
        .history-table tr:hover {
            background-color: #f9f9f9;
        }
        
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-align: center;
        }
        
        .status-active {
            background-color: #E8F5E9;
            color: #2E7D32;
        }
        
        .status-expired {
            background-color: #FFEBEE;
            color: #C62828;
        }
        
        .status-inactive {
            background-color: #ECEFF1;
            color: #546E7A;
        }
        
        .empty-history {
            text-align: center;
            padding: 40px 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
            margin: 20px 0;
        }
        
        .empty-history i {
            font-size: 48px;
            color: #ccc;
            margin-bottom: 20px;
        }
        
        .empty-history h3 {
            margin-bottom: 15px;
            color: #555;
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
                <div class="history-container">
                    <div class="history-header">
                        <h1>Lịch sử gói thành viên</h1>
                        <p>Xem lại các gói thành viên bạn đã đăng ký</p>
                    </div>
                    
                    <c:if test="${empty membershipHistory}">
                        <div class="empty-history">
                            <i class="fas fa-history"></i>
                            <h3>Bạn chưa đăng ký gói thành viên nào</h3>
                            <p>Hãy đăng ký gói thành viên để nhận được nhiều ưu đãi hơn khi đặt sân.</p>
                            <a href="/membership" class="btn btn-primary">Xem các gói thành viên</a>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty membershipHistory}">
                        <table class="history-table">
                            <thead>
                                <tr>
                                    <th>Gói thành viên</th>
                                    <th>Ngày bắt đầu</th>
                                    <th>Ngày kết thúc</th>
                                    <th>Đặt sân đã sử dụng</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${membershipHistory}" var="membership">
                                    <tr>
                                        <td>
                                            <strong>${membership.plan.name}</strong>
                                            <div style="font-size: 12px; color: #666; margin-top: 5px;">
                                                <fmt:formatNumber value="${membership.plan.price}" type="number" pattern="#,###"/> VNĐ
                                            </div>
                                        </td>
                                        <td><fmt:formatDate value="${membership.startDate}" pattern="dd/MM/yyyy" /></td>
                                        <td><fmt:formatDate value="${membership.endDate}" pattern="dd/MM/yyyy" /></td>
                                        <td>${membership.bookingsUsedThisMonth}/${membership.plan.maxBookingsPerMonth}</td>
                                        <td>
                                            <c:set var="now" value="<%= new java.util.Date() %>" />
                                            <c:choose>
                                                <c:when test="${membership.isActive && membership.endDate gt now}">
                                                    <span class="status-badge status-active">Đang hoạt động</span>
                                                </c:when>
                                                <c:when test="${membership.endDate lt now}">
                                                    <span class="status-badge status-expired">Đã hết hạn</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-inactive">Không hoạt động</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        
                        <div style="margin-top: 20px;">
                            <a href="/membership" class="btn btn-primary">Xem các gói thành viên</a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script src="/js/script.js"></script>
    <script src="/js/sidebar.js"></script>
</body>
</html>
