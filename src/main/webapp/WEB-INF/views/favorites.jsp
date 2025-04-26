<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sân yêu thích - Sports Field Booking</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/sidebar.css">
    <link rel="stylesheet" href="/css/icons.css">
    <link rel="stylesheet" href="/css/field-images.css">
    <style>
        .favorite-icon {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 24px;
            color: #ff5252;
            cursor: pointer;
            z-index: 10;
            background-color: rgba(255, 255, 255, 0.7);
            border-radius: 50%;
            padding: 5px;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }
        
        .favorite-icon:hover {
            transform: scale(1.1);
        }
        
        .field-image {
            position: relative;
        }
        
        .empty-favorites {
            text-align: center;
            padding: 40px 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
            margin: 20px 0;
        }
        
        .empty-favorites i {
            font-size: 48px;
            color: #ccc;
            margin-bottom: 20px;
        }
        
        .empty-favorites h3 {
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
                <div class="page-header">
                    <h1><i class="fas fa-heart"></i> Sân yêu thích</h1>
                </div>

                <c:if test="${empty fields}">
                    <div class="empty-favorites">
                        <i class="fas fa-heart-broken"></i>
                        <h3>Bạn chưa có sân yêu thích nào</h3>
                        <p>Hãy thêm sân vào danh sách yêu thích để dễ dàng theo dõi và đặt sân.</p>
                        <a href="/fields" class="btn btn-primary">Khám phá sân ngay</a>
                    </div>
                </c:if>

                <c:if test="${not empty fields}">
                    <div class="fields-grid">
                        <c:forEach items="${fields}" var="field">
                            <div class="field-card">
                                <div class="field-image">
                                    <img src="${empty field.imageUrl ? '/images/football1.jpg' : field.imageUrl}" alt="${field.fieldName}" 
                                         loading="lazy" onerror="this.src='/images/football1.jpg'">
                                    <div class="favorite-icon" data-field-id="${field.id}" onclick="toggleFavorite(this, ${field.id})">
                                        <i class="fas fa-heart"></i>
                                    </div>
                                </div>
                                <div class="field-info">
                                    <h3>${field.fieldName}</h3>
                                    <p class="field-type">
                                        <i class="fas fa-futbol"></i>
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
                                    <p class="field-location"><i class="fas fa-map-marker-alt"></i> ${field.location}</p>
                                    <p class="field-price"><i class="fas fa-tag"></i> <fmt:formatNumber value="${field.pricePerHour}" type="number" pattern="#,###"/> VNĐ/giờ</p>
                                    <p class="field-features">
                                        <span class="${field.isIndoor ? 'feature-indoor' : 'feature-outdoor'}">
                                            <i class="fas ${field.isIndoor ? 'fa-home' : 'fa-cloud-sun'}"></i>
                                            ${field.isIndoor ? 'Trong nhà' : 'Ngoài trời'}
                                        </span>
                                        <c:if test="${field.hasLighting}">
                                            <span class="feature-lighting">
                                                <i class="fas fa-lightbulb"></i> Có đèn chiếu sáng
                                            </span>
                                        </c:if>
                                    </p>
                                </div>
                                <div class="field-actions">
                                    <a href="/fields/${field.id}" class="btn btn-secondary"><i class="fas fa-info-circle"></i> Chi tiết</a>
                                    <c:if test="${not empty loggedUser}">
                                        <a href="/bookings/create/${field.id}" class="btn btn-primary"><i class="fas fa-calendar-plus"></i> Đặt sân</a>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script src="/js/script.js"></script>
    <script src="/js/sidebar.js"></script>
    <script src="/js/image-optimizer.js"></script>
    <script>
        function toggleFavorite(element, fieldId) {
            fetch('/favorites/toggle/' + fieldId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Remove from UI if we're on the favorites page
                    const fieldCard = element.closest('.field-card');
                    fieldCard.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                    fieldCard.style.opacity = '0';
                    fieldCard.style.transform = 'scale(0.8)';
                    
                    setTimeout(() => {
                        fieldCard.remove();
                        
                        // Check if there are no more favorites
                        const remainingCards = document.querySelectorAll('.field-card');
                        if (remainingCards.length === 0) {
                            location.reload(); // Reload to show empty state
                        }
                    }, 500);
                } else {
                    alert(data.error || 'Có lỗi xảy ra. Vui lòng thử lại sau.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra. Vui lòng thử lại sau.');
            });
        }
    </script>
</body>
</html>
