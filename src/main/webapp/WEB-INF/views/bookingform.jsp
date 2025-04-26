<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt sân - ${field.fieldName} - Sports Field Booking</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/sidebar.css">
    <style>
        /* Trang đặt sân */
        .booking-container {
            max-width: 1000px;
            margin: 20px auto;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .booking-header {
            padding: 25px 30px;
            border-bottom: 1px solid #eee;
            background-color: #f8f9fa;
        }

        .booking-form-nav {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-bottom: 20px;
        }

        .nav-links {
            display: flex;
            align-items: center;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            color: #666;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            color: #2196F3;
        }

        .back-link i {
            margin-right: 5px;
        }

        .schedule-link {
            display: inline-flex;
            align-items: center;
            color: #2196F3;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .schedule-link:hover {
            color: #1976D2;
            text-decoration: none;
        }

        .schedule-link i {
            margin-right: 5px;
        }

        .booking-header h2 {
            margin: 10px 0;
            color: #2196F3;
            font-size: 24px;
            font-weight: 600;
        }

        /* Thông báo lỗi */
        .error-message {
            background-color: #ffebee;
            color: #d32f2f;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
            border-left: 4px solid #d32f2f;
            font-weight: 500;
        }

        /* Nội dung đặt sân */
        .booking-content {
            display: flex;
            flex-wrap: wrap;
            padding: 0;
        }

        /* Thông tin sân */
        .booking-field-info {
            flex: 1;
            min-width: 300px;
            padding: 30px;
            background-color: #fafafa;
            border-right: 1px solid #eee;
        }

        .field-image {
            margin-bottom: 20px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .field-image img {
            width: 100%;
            height: auto;
            display: block;
            transition: transform 0.3s ease;
        }

        .field-image img:hover {
            transform: scale(1.03);
        }

        .field-summary h3 {
            margin-top: 0;
            margin-bottom: 15px;
            color: #333;
            font-size: 22px;
            font-weight: 600;
        }

        .field-summary p {
            margin-bottom: 12px;
            color: #555;
            display: flex;
            align-items: center;
        }

        .field-summary p i {
            margin-right: 8px;
            width: 20px;
            text-align: center;
            color: #2196F3;
        }

        .field-price {
            font-weight: 600;
            color: #2196F3 !important;
            font-size: 18px;
        }

        .field-features {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 15px;
        }

        .field-features span {
            display: inline-flex;
            align-items: center;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }

        .feature-indoor {
            background-color: #e3f2fd;
            color: #1976D2;
        }

        .feature-outdoor {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .feature-lighting {
            background-color: #fff8e1;
            color: #f57f17;
        }

        /* Form đặt sân */
        .booking-form {
            flex: 1;
            min-width: 300px;
            padding: 30px;
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

        /* Tóm tắt đặt sân */
        .booking-summary {
            background-color: #f9f9f9;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            border: 1px solid #eee;
        }

        .booking-summary h3 {
            margin-top: 0;
            margin-bottom: 15px;
            color: #333;
            font-size: 18px;
            font-weight: 600;
            position: relative;
            padding-bottom: 10px;
        }

        .booking-summary h3:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 3px;
            background-color: #2196F3;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px dashed #e0e0e0;
        }

        .summary-item:last-child {
            border-bottom: none;
        }

        .summary-item.total {
            font-weight: bold;
            font-size: 1.1em;
            margin-top: 15px;
            padding-top: 10px;
            border-top: 2px solid #e0e0e0;
            color: #2196F3;
        }

        /* Nút đặt sân */
        .btn-primary {
            background-color: #2196F3;
            color: white;
            border: none;
            padding: 14px 20px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
            width: 100%;
            transition: all 0.3s ease;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .btn-primary:hover {
            background-color: #1976D2;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(33, 150, 243, 0.3);
        }

        .btn-primary i {
            margin-right: 8px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .booking-content {
                flex-direction: column;
            }

            .booking-field-info {
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

            <div class="booking-container">
                <div class="booking-header">
                    <div class="booking-form-nav">
                        <div class="nav-links">
                            <a href="/fields/${field.id}" class="back-link"><i class="fas fa-arrow-left"></i> Quay lại thông tin sân</a>
                        </div>
                        <div class="nav-links">
                            <a href="/schedule/field/${field.id}" class="schedule-link"><i class="fas fa-calendar-alt"></i> Xem lịch đặt sân</a>
                        </div>
                    </div>
                    <h2><i class="fas fa-bookmark"></i> Đặt sân ${field.fieldName}</h2>

                    <c:if test="${not empty param.error}">
                        <div class="error-message">
                            <c:choose>
                                <c:when test="${param.error eq 'invalidTimes'}">
                                    <i class="fas fa-exclamation-circle"></i> Thời gian kết thúc phải sau thời gian bắt đầu.
                                </c:when>
                                <c:when test="${param.error eq 'pastTime'}">
                                    <i class="fas fa-exclamation-circle"></i> Không thể đặt sân cho thời gian đã qua.
                                </c:when>
                                <c:when test="${param.error eq 'invalidDateTimeFormat'}">
                                    <i class="fas fa-exclamation-circle"></i> Định dạng ngày giờ không hợp lệ. Vui lòng sử dụng định dạng yyyy-MM-ddTHH:mm.
                                </c:when>
                                <c:when test="${param.error eq 'fieldNotAvailable'}">
                                    <i class="fas fa-exclamation-circle"></i> Sân đã được đặt trong khoảng thời gian này. Vui lòng chọn thời gian khác.
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-exclamation-circle"></i> Lỗi: ${param.error}
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </div>

            <div class="booking-content">
                <div class="booking-field-info">
                    <div class="field-image">
                        <img src="${empty field.imageUrl ? '/images/default-field.jpg' : field.imageUrl}" alt="${field.fieldName}">
                    </div>

                    <div class="field-summary">
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
                        <p class="field-price"><i class="fas fa-tag"></i> <fmt:formatNumber value="${field.pricePerHour}" type="number" pattern="#,###" /> VNĐ/giờ</p>
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
                </div>

                <div class="booking-form">
                    <form action="/bookings/create" method="post" id="bookingForm">
                        <input type="hidden" name="fieldId" value="${field.id}">

                        <div class="form-group">
                            <label for="startDateTime"><i class="far fa-clock"></i> Thời gian bắt đầu:</label>
                            <input type="datetime-local" id="startDateTime" name="startDateTime" value="${startDateTime}" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="endDateTime"><i class="far fa-clock"></i> Thời gian kết thúc:</label>
                            <input type="datetime-local" id="endDateTime" name="endDateTime" value="${endDateTime}" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="numberOfPlayers"><i class="fas fa-users"></i> Số người chơi:</label>
                            <input type="number" id="numberOfPlayers" name="numberOfPlayers" min="1" value="1" class="form-control" required>
                        </div>

                        <div class="form-group">
                            <label for="notes"><i class="fas fa-sticky-note"></i> Ghi chú (không bắt buộc):</label>
                            <textarea id="notes" name="notes" rows="3" class="form-control" placeholder="Nhập yêu cầu đặc biệt hoặc ghi chú khác..."></textarea>
                        </div>

                        <div class="booking-summary">
                            <h3><i class="fas fa-receipt"></i> Tóm tắt đặt sân</h3>
                            <div class="summary-item">
                                <span><i class="fas fa-tag"></i> Giá thuê:</span>
                                <span><fmt:formatNumber value="${field.pricePerHour}" type="number" pattern="#,###" /> VNĐ/giờ</span>
                            </div>
                            <div class="summary-item">
                                <span><i class="fas fa-clock"></i> Thời gian:</span>
                                <span id="bookingDuration">-- giờ</span>
                            </div>
                            <div class="summary-item total">
                                <span><i class="fas fa-money-bill-wave"></i> Tổng tiền:</span>
                                <span id="totalPrice">-- VNĐ</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <button type="submit" class="btn btn-primary btn-large">
                                <i class="fas fa-check-circle"></i> Xác nhận đặt sân
                            </button>
                        </div>

                        <!-- Loading indicator -->
                        <div class="loading-indicator" style="text-align: center; margin-top: 15px; display: none;">
                            <i class="fas fa-spinner fa-spin"></i> Đang xử lý yêu cầu của bạn...
                        </div>

                        <!-- Hidden fallback button that will be shown if JavaScript fails -->
                        <noscript>
                            <div class="form-group" style="margin-top: 15px;">
                                <div class="alert alert-warning">
                                    <i class="fas fa-exclamation-triangle"></i> JavaScript bị vô hiệu hóa. Vui lòng sử dụng nút bên dưới để đặt sân.
                                </div>
                                <button type="submit" class="btn btn-secondary btn-large" formnovalidate>
                                    <i class="fas fa-paper-plane"></i> Gửi form không cần JavaScript
                                </button>
                            </div>
                        </noscript>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script src="/js/script.js"></script>
    <script src="/js/sidebar.js"></script>
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

        // Format date for display
        function formatDateForDisplay(date) {
            const options = {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            };
            return date.toLocaleDateString('vi-VN', options);
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

                // Format total price without decimal part
                const formattedPrice = Math.round(totalPrice).toLocaleString('vi-VN');
                document.getElementById('totalPrice').textContent = formattedPrice + ' VNĐ';

                // Add animation effect
                const totalPriceElement = document.getElementById('totalPrice');
                totalPriceElement.classList.add('price-updated');
                setTimeout(() => {
                    totalPriceElement.classList.remove('price-updated');
                }, 500);
            } catch (error) {
                console.error('Error updating booking summary:', error);
            }
        }

        // Update end time automatically when start time changes
        document.getElementById('startDateTime').addEventListener('change', function() {
            try {
                const startDateTimeStr = this.value;
                if (!startDateTimeStr) return;

                const startDateTime = new Date(startDateTimeStr);
                if (isNaN(startDateTime.getTime())) return;

                // Set end time to start time + 1 hour
                const endDateTime = new Date(startDateTime);
                endDateTime.setHours(endDateTime.getHours() + 1);

                document.getElementById('endDateTime').value = formatDateTimeForInput(endDateTime);
                updateBookingSummary();
            } catch (error) {
                console.error('Error updating end time:', error);
            }
        });

        // Update summary on input change
        document.getElementById('startDateTime').addEventListener('change', updateBookingSummary);
        document.getElementById('endDateTime').addEventListener('change', updateBookingSummary);

        // Initial calculation
        updateBookingSummary();

        // Form validation with better error messages
        document.getElementById('bookingForm').addEventListener('submit', function(event) {
            try {
                // Prevent default form submission to handle it manually
                event.preventDefault();

                const startDateTimeStr = document.getElementById('startDateTime').value;
                const endDateTimeStr = document.getElementById('endDateTime').value;
                const fieldId = document.querySelector('input[name="fieldId"]').value;
                const notes = document.getElementById('notes').value;
                const numberOfPlayers = document.getElementById('numberOfPlayers').value;

                if (!startDateTimeStr || !endDateTimeStr) {
                    showError('Vui lòng nhập đầy đủ thời gian bắt đầu và kết thúc.');
                    return;
                }

                const startDateTime = new Date(startDateTimeStr);
                const endDateTime = new Date(endDateTimeStr);

                if (isNaN(startDateTime.getTime()) || isNaN(endDateTime.getTime())) {
                    showError('Định dạng ngày giờ không hợp lệ.');
                    return;
                }

                if (endDateTime <= startDateTime) {
                    showError('Thời gian kết thúc phải sau thời gian bắt đầu.');
                    return;
                }

                if (startDateTime < now) {
                    showError('Không thể đặt sân cho thời gian đã qua.');
                    return;
                }

                // Add loading state to button
                const submitButton = this.querySelector('button[type="submit"]');
                submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
                submitButton.disabled = true;

                // Show loading overlay
                showLoadingOverlay();

                // Sử dụng FormData thay vì URLSearchParams để xử lý form tốt hơn
                const formData = new FormData(document.getElementById('bookingForm'));

                // Chuyển FormData thành chuỗi URL-encoded
                const urlEncodedData = new URLSearchParams();
                for (const pair of formData.entries()) {
                    urlEncodedData.append(pair[0], pair[1]);
                }

                console.log('Submitting form with data:', Object.fromEntries(urlEncodedData));

                // Send AJAX request
                fetch('/bookings/create', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: urlEncodedData.toString(),
                    credentials: 'same-origin' // Đảm bảo gửi cookie session
                })
                .then(response => {
                    console.log('Response received:', response);
                    console.log('Response status:', response.status);
                    console.log('Response type:', response.type);
                    console.log('Response URL:', response.url);

                    // Kiểm tra nếu response là redirect
                    if (response.redirected) {
                        console.log('Redirecting to:', response.url);
                        window.location.href = response.url;
                        return;
                    }

                    // Kiểm tra nếu response là OK (200)
                    if (response.ok) {
                        return response.text().then(text => {
                            console.log('Response text:', text);

                            // Kiểm tra nếu response chứa HTML của trang bookingConfirmation
                            if (text.includes('bookingConfirmation') || text.includes('Thanh toán đặt sân')) {
                                console.log('Response contains confirmation page, parsing booking ID');

                                // Tìm booking ID trong HTML
                                const bookingIdMatch = text.match(/booking\.id}|booking\.getId\(\)|booking-([0-9]+)|#([0-9]+)/i);
                                if (bookingIdMatch) {
                                    const bookingId = bookingIdMatch[1] || bookingIdMatch[2];
                                    console.log('Found booking ID:', bookingId);
                                    window.location.href = '/payment/' + bookingId + '?isNew=true';
                                    return;
                                }

                                // Tìm URL thanh toán trong HTML
                                const paymentUrlMatch = text.match(/\/payment\/([0-9]+)/);
                                if (paymentUrlMatch && paymentUrlMatch[0]) {
                                    console.log('Found payment URL in response, redirecting to:', paymentUrlMatch[0]);
                                    window.location.href = paymentUrlMatch[0] + '?isNew=true';
                                    return;
                                }

                                // Nếu không tìm thấy ID, chuyển hướng đến trang profile
                                console.log('Could not find booking ID, redirecting to profile');
                                window.location.href = '/user/profile';
                                return;
                            }

                            // Kiểm tra nếu response chứa thông báo lỗi
                            if (text.includes('error=')) {
                                const errorMatch = text.match(/error=([^&]+)/);
                                if (errorMatch && errorMatch[1]) {
                                    const errorMsg = decodeURIComponent(errorMatch[1].replace(/\+/g, ' '));
                                    throw new Error(errorMsg);
                                }
                            }

                            // Nếu không có lỗi và không có redirect, thử gửi form theo cách truyền thống
                            console.log('No error or redirect found, submitting form traditionally');
                            document.getElementById('bookingForm').submit();
                        });
                    } else {
                        // Nếu response không OK, hiển thị lỗi
                        console.error('Server returned error status:', response.status);
                        throw new Error('Server returned error status: ' + response.status);
                    }
                })
                .catch(error => {
                    console.error('Error submitting form:', error);

                    // Hiển thị lỗi trước khi thử cách khác
                    showError(error.message || 'Có lỗi xảy ra khi xử lý form. Đang thử phương pháp khác...');

                    // Thử lại với cách gửi form truyền thống sau 1 giây
                    setTimeout(() => {
                        console.log('Trying traditional form submission after error');
                        try {
                            // Tạo một form mới và gửi
                            const backupForm = document.createElement('form');
                            backupForm.method = 'POST';
                            backupForm.action = '/bookings/create';
                            backupForm.style.display = 'none';

                            // Thêm các trường dữ liệu
                            const addField = (name, value) => {
                                const input = document.createElement('input');
                                input.type = 'hidden';
                                input.name = name;
                                input.value = value;
                                backupForm.appendChild(input);
                            };

                            addField('fieldId', fieldId);
                            addField('startDateTime', startDateTimeStr);
                            addField('endDateTime', endDateTimeStr);
                            addField('notes', notes || '');
                            addField('numberOfPlayers', numberOfPlayers);

                            // Thêm form vào trang và gửi
                            document.body.appendChild(backupForm);
                            backupForm.submit();
                        } catch (backupError) {
                            console.error('Error with backup submission:', backupError);

                            // Nếu cách thứ hai cũng thất bại, thử cách cuối cùng
                            try {
                                const originalForm = document.getElementById('bookingForm');
                                originalForm.removeEventListener('submit', arguments.callee);
                                originalForm.submit();
                            } catch (finalError) {
                                console.error('All submission methods failed:', finalError);
                                showError('Không thể gửi form. Vui lòng tải lại trang và thử lại.');

                                // Reset button state
                                submitButton.innerHTML = '<i class="fas fa-check-circle"></i> Xác nhận đặt sân';
                                submitButton.disabled = false;

                                // Hide loading overlay
                                hideLoadingOverlay();
                            }
                        }
                    }, 1000);
                });

            } catch (error) {
                console.error('Error validating form:', error);

                // Hiển thị lỗi
                showError('Lỗi xảy ra khi xử lý form. Đang thử phương pháp khác...');

                // Thử lại với cách gửi form truyền thống sau 1 giây
                setTimeout(() => {
                    try {
                        // Fall back to traditional form submission if JavaScript validation fails
                        console.log('JavaScript error detected, falling back to traditional form submission');
                        const form = document.getElementById('bookingForm');

                        // Tạo một bản sao của form để tránh vòng lặp sự kiện
                        const clonedForm = form.cloneNode(true);
                        clonedForm.id = 'bookingFormClone';
                        clonedForm.style.display = 'none';
                        document.body.appendChild(clonedForm);

                        // Gửi form đã sao chép
                        clonedForm.submit();
                    } catch (finalError) {
                        console.error('All submission methods failed:', finalError);
                        showError('Không thể gửi form. Vui lòng tải lại trang và thử lại.');

                        // Reset button state
                        const submitButton = document.querySelector('button[type="submit"]');
                        if (submitButton) {
                            submitButton.innerHTML = '<i class="fas fa-check-circle"></i> Xác nhận đặt sân';
                            submitButton.disabled = false;
                        }
                    }
                }, 1000);
            }
        });

        // Better error display with auto-hide
        // Loading overlay functions
        function showLoadingOverlay() {
            // Show inline loading indicator
            const loadingIndicator = document.querySelector('.loading-indicator');
            if (loadingIndicator) {
                loadingIndicator.style.display = 'block';
            }

            // Check if overlay already exists
            let overlay = document.querySelector('.loading-overlay');

            if (!overlay) {
                // Create overlay
                overlay = document.createElement('div');
                overlay.className = 'loading-overlay';

                // Create spinner
                const spinner = document.createElement('div');
                spinner.className = 'loading-spinner';
                spinner.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';

                overlay.appendChild(spinner);
                document.body.appendChild(overlay);
            }

            // Show overlay with a slight delay for better UX
            setTimeout(() => {
                overlay.classList.add('active');
            }, 100);
        }

        function hideLoadingOverlay() {
            // Hide inline loading indicator
            const loadingIndicator = document.querySelector('.loading-indicator');
            if (loadingIndicator) {
                loadingIndicator.style.display = 'none';
            }

            // Hide overlay
            const overlay = document.querySelector('.loading-overlay');
            if (overlay) {
                overlay.classList.remove('active');

                // Remove from DOM after animation completes
                setTimeout(() => {
                    if (overlay.parentNode) {
                        overlay.parentNode.removeChild(overlay);
                    }
                }, 300);
            }
        }

        function showError(message) {
            // Hide loading overlay if it's visible
            hideLoadingOverlay();

            // Check if error element already exists
            let errorElement = document.querySelector('.error-message');

            if (!errorElement) {
                // Create new error element
                errorElement = document.createElement('div');
                errorElement.className = 'error-message';
                const headerElement = document.querySelector('.booking-header');
                headerElement.appendChild(errorElement);
            }

            // Clear any existing timers
            if (errorElement._hideTimer) {
                clearTimeout(errorElement._hideTimer);
            }

            // Set error message
            errorElement.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${message}`;

            // Make sure error is visible
            errorElement.style.display = 'block';
            errorElement.style.opacity = '1';

            // Scroll to error
            errorElement.scrollIntoView({ behavior: 'smooth', block: 'center' });

            // Add animation
            errorElement.classList.add('shake');
            setTimeout(() => {
                errorElement.classList.remove('shake');
            }, 500);

            // Auto-hide error after 10 seconds unless it's a critical error
            if (!message.includes('Không thể gửi form')) {
                errorElement._hideTimer = setTimeout(() => {
                    // Fade out
                    errorElement.style.opacity = '0';
                    setTimeout(() => {
                        errorElement.style.display = 'none';
                    }, 500);
                }, 10000);
            }

            // Add close button
            const closeButton = document.createElement('span');
            closeButton.innerHTML = '&times;';
            closeButton.className = 'error-close';
            closeButton.style.position = 'absolute';
            closeButton.style.right = '10px';
            closeButton.style.top = '10px';
            closeButton.style.cursor = 'pointer';
            closeButton.style.fontSize = '20px';
            closeButton.style.fontWeight = 'bold';
            closeButton.style.color = 'rgba(0,0,0,0.5)';

            // Make sure we don't add multiple close buttons
            const existingCloseButton = errorElement.querySelector('.error-close');
            if (existingCloseButton) {
                existingCloseButton.remove();
            }

            errorElement.appendChild(closeButton);
            closeButton.addEventListener('click', () => {
                errorElement.style.opacity = '0';
                setTimeout(() => {
                    errorElement.style.display = 'none';
                }, 500);
            });
        }
    </script>

    <style>
        /* Animation styles */
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
            20%, 40%, 60%, 80% { transform: translateX(5px); }
        }

        .shake {
            animation: shake 0.5s cubic-bezier(.36,.07,.19,.97) both;
        }

        @keyframes priceUpdate {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); color: #2196F3; }
            100% { transform: scale(1); }
        }

        .price-updated {
            animation: priceUpdate 0.5s ease;
        }

        /* Error message styles */
        .error-message {
            background-color: #ffebee;
            color: #d32f2f;
            padding: 15px 40px 15px 15px;
            border-radius: 8px;
            margin: 15px 0;
            border-left: 4px solid #d32f2f;
            font-weight: 500;
            position: relative;
            transition: opacity 0.5s ease;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .error-message i {
            margin-right: 10px;
        }

        /* Loading overlay */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }

        .loading-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        .loading-spinner {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background-color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .loading-spinner i {
            font-size: 40px;
            color: #2196F3;
            animation: spin 1s infinite linear;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Alert styles */
        .alert {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .alert i {
            margin-right: 10px;
            font-size: 18px;
        }

        .alert-warning {
            background-color: #fff3e0;
            color: #e65100;
            border-left: 4px solid #ff9800;
        }
    </style>
</body>
</html>
