<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách sân thể thao - Sports Field Booking</title>
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
            color: #ccc;
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

        .favorite-icon.active {
            color: #ff5252;
        }

        .field-image {
            position: relative;
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

        <div class="fields-container">
            <div class="fields-sidebar">
                <div class="filter-section">
                    <h3>Tìm kiếm sân</h3>
                    <form action="/fields" method="get" id="filterForm">
                        <div class="form-group">
                            <label for="type">Loại sân:</label>
                            <select id="type" name="type" onchange="this.form.submit()">
                                <option value="">Tất cả loại sân</option>
                                <c:forEach items="${fieldTypes}" var="fieldType">
                                    <option value="${fieldType}" ${param.type eq fieldType ? 'selected' : ''}>
                                        <c:choose>
                                            <c:when test="${fieldType eq 'FOOTBALL'}">Bóng đá</c:when>
                                            <c:when test="${fieldType eq 'BASKETBALL'}">Bóng rổ</c:when>
                                            <c:when test="${fieldType eq 'TENNIS'}">Tennis</c:when>
                                            <c:when test="${fieldType eq 'BADMINTON'}">Cầu lông</c:when>
                                            <c:when test="${fieldType eq 'VOLLEYBALL'}">Bóng chuyền</c:when>
                                            <c:when test="${fieldType eq 'SWIMMING'}">Bơi lội</c:when>
                                            <c:otherwise>${fieldType}</c:otherwise>
                                        </c:choose>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="location">Địa điểm:</label>
                            <input type="text" id="location" name="location" value="${param.location}" placeholder="Nhập địa điểm">
                        </div>

                        <div class="form-group">
                            <label for="maxPrice">Giá tối đa (VNĐ/giờ):</label>
                            <input type="number" id="maxPrice" name="maxPrice" value="${param.maxPrice}" min="0" step="10000" placeholder="Nhập giá tối đa">
                        </div>

                        <div class="form-group">
                            <label>Loại sân:</label>
                            <div class="radio-group">
                                <label>
                                    <input type="radio" name="indoor" value="true" ${param.indoor eq 'true' ? 'checked' : ''}>
                                    Trong nhà
                                </label>
                                <label>
                                    <input type="radio" name="indoor" value="false" ${param.indoor eq 'false' ? 'checked' : ''}>
                                    Ngoài trời
                                </label>
                                <label>
                                    <input type="radio" name="indoor" value="" ${empty param.indoor ? 'checked' : ''}>
                                    Tất cả
                                </label>
                            </div>
                        </div>

                        <div class="form-group">
                            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                            <button type="button" class="btn btn-secondary" id="resetFilter">Đặt lại</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="fields-content">
                <h2>Danh sách sân thể thao</h2>

                <c:if test="${empty fields}">
                    <div class="no-data">
                        Không tìm thấy sân thể thao nào phù hợp với tiêu chí tìm kiếm.
                        <a href="/fields" class="btn btn-primary" style="margin-top: 20px;">
                            <i class="fas fa-sync-alt"></i> Xem tất cả sân
                        </a>
                    </div>
                </c:if>

                <c:if test="${not empty fields}">
                    <div class="fields-grid">
                        <c:forEach items="${fields}" var="field">
                            <div class="field-card">
                                <div class="field-image">
                                    <img src="${empty field.imageUrl ? '/images/football1.jpg' : field.imageUrl}" alt="${field.fieldName}"
                                         loading="lazy" onerror="this.src='/images/football1.jpg'">
                                    <c:if test="${not empty loggedUser}">
                                        <div class="favorite-icon" data-field-id="${field.id}" onclick="toggleFavorite(this, ${field.id})">
                                            <i class="far fa-heart"></i>
                                        </div>
                                    </c:if>
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
        </div>
    </div>

    <!-- JavaScript -->
    <script src="/js/script.js"></script>
    <script src="/js/sidebar.js"></script>
    <script src="/js/image-optimizer.js"></script>
    <script>
        document.getElementById('resetFilter').addEventListener('click', function() {
            document.getElementById('type').value = '';
            document.getElementById('location').value = '';
            document.getElementById('maxPrice').value = '';
            document.querySelectorAll('input[name="indoor"]').forEach(radio => {
                if (radio.value === '') radio.checked = true;
            });
            document.getElementById('filterForm').submit();
        });

        // Check favorite status for each field
        document.addEventListener('DOMContentLoaded', function() {
            const favoriteIcons = document.querySelectorAll('.favorite-icon');
            favoriteIcons.forEach(icon => {
                const fieldId = icon.getAttribute('data-field-id');
                checkFavoriteStatus(icon, fieldId);
            });
        });

        function checkFavoriteStatus(element, fieldId) {
            fetch('/favorites/check/' + fieldId)
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.isFavorite) {
                        element.classList.add('active');
                        element.querySelector('i').classList.remove('far');
                        element.querySelector('i').classList.add('fas');
                    }
                })
                .catch(error => console.error('Error checking favorite status:', error));
        }

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
                    if (data.isFavorite) {
                        // Added to favorites
                        element.classList.add('active');
                        element.querySelector('i').classList.remove('far');
                        element.querySelector('i').classList.add('fas');
                    } else {
                        // Removed from favorites
                        element.classList.remove('active');
                        element.querySelector('i').classList.remove('fas');
                        element.querySelector('i').classList.add('far');
                    }
                } else {
                    alert(data.error || 'Có lỗi xảy ra. Vui lòng thử lại sau.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra. Vui lòng thử lại sau.');
            });

            // Prevent event bubbling
            event.stopPropagation();
            return false;
        }
    </script>
</body>
</html>
