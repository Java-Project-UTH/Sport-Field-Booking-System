<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách sân thể thao - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/icons.css">
</head>
<body>
<div class="container">
    <div class="navbar">
        <div class="navbar-brand">Sports Field Booking</div>
        <ul class="navbar-links">
            <li><a href="/">Trang chủ</a></li>
            <li><a href="/fields" class="active">Sân thể thao</a></li>
            <c:if test="${not empty loggedUser}">
                <li><a href="/user/profile">Trang cá nhân</a></li>
            </c:if>
        </ul>
        <div class="navbar-account">
            <c:if test="${empty loggedUser}">
                <a href="/login">Đăng nhập</a> | <a href="/register">Đăng ký</a>
            </c:if>
            <c:if test="${not empty loggedUser}">
                <span>Xin chào, ${loggedUser}</span> | <a href="/logout">Đăng xuất</a>
            </c:if>
        </div>
    </div>

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
                <p class="no-data">Không tìm thấy sân thể thao nào phù hợp với tiêu chí tìm kiếm.</p>
            </c:if>

            <c:if test="${not empty fields}">
                <div class="fields-grid">
                    <c:forEach items="${fields}" var="field">
                        <div class="field-card">
                            <div class="field-image">
                                <img src="${empty field.imageUrl ? '/images/default-field.jpg' : field.imageUrl}" alt="${field.fieldName}">
                            </div>
                            <div class="field-info">
                                <h3>${field.fieldName}</h3>
                                <p class="field-type">
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
                                <p class="field-location"><i class="icon-location"></i> ${field.location}</p>
                                <p class="field-price"><fmt:formatNumber value="${field.pricePerHour}" type="currency" currencySymbol=""/> VNĐ/giờ</p>
                                <p class="field-features">
                                        <span class="${field.isIndoor ? 'feature-indoor' : 'feature-outdoor'}">
                                                ${field.isIndoor ? 'Trong nhà' : 'Ngoài trời'}
                                        </span>
                                    <span class="${field.hasLighting ? 'feature-lighting' : ''}">
                                            ${field.hasLighting ? 'Có đèn chiếu sáng' : ''}
                                    </span>
                                </p>
                            </div>
                            <div class="field-actions">
                                <a href="/fields/${field.id}" class="btn btn-secondary">Chi tiết</a>
                                <c:if test="${not empty loggedUser}">
                                    <a href="/bookings/create/${field.id}" class="btn btn-primary">Đặt sân</a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script src="/js/script.js"></script>
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
</script>
</body>
</html>