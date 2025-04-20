<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt sân - ${field.fieldName} - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        .booking-form-nav {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }

        .schedule-link {
            color: #2196F3;
            text-decoration: none;
        }

        .schedule-link:hover {
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
                <span>Xin chào, ${loggedUser}</span> | <a href="/logout">Đăng xuất</a>
            </div>
        </div>

        <div class="booking-form-container">
            <div class="booking-form-header">
                <div class="booking-form-nav">
                    <a href="/fields/${field.id}" class="back-link">&larr; Quay lại thông tin sân</a>
                    <a href="/schedule/field/${field.id}" class="schedule-link">Xem lịch đặt sân</a>
                </div>
                <h2>Đặt sân ${field.fieldName}</h2>

                <c:if test="${not empty param.error}">
                    <div class="error-message">
                        <c:choose>
                            <c:when test="${param.error eq 'invalidTimes'}">
                                Thời gian kết thúc phải sau thời gian bắt đầu.
                            </c:when>
                            <c:when test="${param.error eq 'pastTime'}">
                                Không thể đặt sân cho thời gian đã qua.
                            </c:when>
                            <c:when test="${param.error eq 'invalidDateTimeFormat'}">
                                Định dạng ngày giờ không hợp lệ. Vui lòng sử dụng định dạng yyyy-MM-ddTHH:mm.
                            </c:when>
                            <c:when test="${param.error eq 'fieldNotAvailable'}">
                                Sân đã được đặt trong khoảng thời gian này. Vui lòng chọn thời gian khác.
                            </c:when>
                            <c:otherwise>
                                Lỗi: ${param.error}
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </div>

            <div class="booking-form-content">
                <div class="booking-field-info">
                    <div class="field-image">
                        <img src="${empty field.imageUrl ? '/images/default-field.jpg' : field.imageUrl}" alt="${field.fieldName}">
                    </div>

                    <div class="field-summary">
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
                            <c:if test="${field.hasLighting}">
                                <span class="feature-lighting">Có đèn chiếu sáng</span>
                            </c:if>
                        </p>
                    </div>
                </div>

                <div class="booking-form">
                    <form action="/bookings/create" method="post" id="bookingForm">
                        <input type="hidden" name="fieldId" value="${field.id}">

                        <div class="form-group">
                            <label for="startDateTime">Thời gian bắt đầu:</label>
                            <input type="datetime-local" id="startDateTime" name="startDateTime" value="${startDateTime}" required>
                        </div>

                        <div class="form-group">
                            <label for="endDateTime">Thời gian kết thúc:</label>
                            <input type="datetime-local" id="endDateTime" name="endDateTime" value="${endDateTime}" required>
                        </div>

                        <div class="form-group">
                            <label for="numberOfPlayers">Số người chơi:</label>
                            <input type="number" id="numberOfPlayers" name="numberOfPlayers" min="1" value="1" required>
                        </div>

                        <div class="form-group">
                            <label for="notes">Ghi chú (không bắt buộc):</label>
                            <textarea id="notes" name="notes" rows="3" placeholder="Nhập yêu cầu đặc biệt hoặc ghi chú khác..."></textarea>
                        </div>

                        <div class="booking-summary">
                            <h3>Tóm tắt đặt sân</h3>
                            <div class="summary-item">
                                <span>Giá thuê:</span>
                                <span><fmt:formatNumber value="${field.pricePerHour}" type="currency" currencySymbol=""/> VNĐ/giờ</span>
                            </div>
                            <div class="summary-item">
                                <span>Thời gian:</span>
                                <span id="bookingDuration">-- giờ</span>
                            </div>
                            <div class="summary-item total">
                                <span>Tổng tiền:</span>
                                <span id="totalPrice">-- VNĐ</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <button type="submit" class="btn btn-primary btn-large">Xác nhận đặt sân</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="/js/script.js"></script>
    <script>
        // Set min datetime for booking (current time + 1 hour, rounded to next hour)
        const now = new Date();
        now.setHours(now.getHours() + 1);
        now.setMinutes(0);
        now.setSeconds(0);
        now.setMilliseconds(0);

        // Format date to yyyy-MM-ddTHH:mm format for input
        function formatDateTimeForInput(date) {
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            const hours = String(date.getHours()).padStart(2, '0');
            const minutes = String(date.getMinutes()).padStart(2, '0');

            return `${year}-${month}-${day}T${hours}:${minutes}`;
        }

        const minDateTimeStr = formatDateTimeForInput(now);
        document.getElementById('startDateTime').min = minDateTimeStr;
        document.getElementById('endDateTime').min = minDateTimeStr;

        // Set default values if not already set
        if (!document.getElementById('startDateTime').value) {
            // Default values: current time + 1 hour for start, + 2 hours for end
            const defaultStart = new Date(now);
            const defaultEnd = new Date(now);
            defaultEnd.setHours(defaultEnd.getHours() + 1);

            document.getElementById('startDateTime').value = formatDateTimeForInput(defaultStart);
            document.getElementById('endDateTime').value = formatDateTimeForInput(defaultEnd);
        }

        // Calculate booking duration and total price
        const pricePerHour = ${field.pricePerHour};

        function updateBookingSummary() {
            try {
                const startDateTimeStr = document.getElementById('startDateTime').value;
                const endDateTimeStr = document.getElementById('endDateTime').value;

                if (!startDateTimeStr || !endDateTimeStr) return;

                const startDateTime = new Date(startDateTimeStr);
                const endDateTime = new Date(endDateTimeStr);

                if (isNaN(startDateTime.getTime()) || isNaN(endDateTime.getTime())) {
                    console.error('Invalid date format');
                    return;
                }

                // Calculate duration in hours
                const durationMs = endDateTime - startDateTime;
                const durationHours = Math.max(1, Math.ceil(durationMs / (1000 * 60 * 60)));

                // Calculate total price
                const totalPrice = durationHours * pricePerHour;

                // Update summary
                document.getElementById('bookingDuration').textContent = durationHours + ' giờ';
                document.getElementById('totalPrice').textContent = totalPrice.toLocaleString() + ' VNĐ';
            } catch (error) {
                console.error('Error updating booking summary:', error);
            }
        }

        // Update summary on input change
        document.getElementById('startDateTime').addEventListener('change', updateBookingSummary);
        document.getElementById('endDateTime').addEventListener('change', updateBookingSummary);

        // Initial calculation
        updateBookingSummary();

        // Form validation
        document.getElementById('bookingForm').addEventListener('submit', function(event) {
            try {
                const startDateTimeStr = document.getElementById('startDateTime').value;
                const endDateTimeStr = document.getElementById('endDateTime').value;

                if (!startDateTimeStr || !endDateTimeStr) {
                    event.preventDefault();
                    alert('Vui lòng nhập đầy đủ thời gian bắt đầu và kết thúc.');
                    return;
                }

                const startDateTime = new Date(startDateTimeStr);
                const endDateTime = new Date(endDateTimeStr);

                if (isNaN(startDateTime.getTime()) || isNaN(endDateTime.getTime())) {
                    event.preventDefault();
                    alert('Định dạng ngày giờ không hợp lệ.');
                    return;
                }

                if (endDateTime <= startDateTime) {
                    event.preventDefault();
                    alert('Thời gian kết thúc phải sau thời gian bắt đầu.');
                    return;
                }

                if (startDateTime < now) {
                    event.preventDefault();
                    alert('Không thể đặt sân cho thời gian đã qua.');
                    return;
                }
            } catch (error) {
                event.preventDefault();
                console.error('Error validating form:', error);
                alert('Có lỗi xảy ra khi xử lý form. Vui lòng thử lại.');
            }
        });
    </script>
</body>
</html>
