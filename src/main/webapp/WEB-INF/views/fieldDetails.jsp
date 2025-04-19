<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${field.fieldName} - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
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

    <div class="field-details-container">
        <div class="field-details-header">
            <a href="/fields" class="back-link">&larr; Quay lại danh sách sân</a>

            <c:if test="${param.success eq 'reviewAdded'}">
                <div class="success-message">Cảm ơn bạn đã đánh giá sân!</div>
            </c:if>
            <c:if test="${param.success eq 'reviewUpdated'}">
                <div class="success-message">Đánh giá của bạn đã được cập nhật!</div>
            </c:if>
            <c:if test="${param.success eq 'reviewDeleted'}">
                <div class="success-message">Đánh giá đã được xóa!</div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="error-message">${param.error}</div>
            </c:if>
        </div>

        <div class="field-details-content">
            <div class="field-details-main">
                <div class="field-details-image">
                    <img src="${empty field.imageUrl ? '/images/default-field.jpg' : field.imageUrl}" alt="${field.fieldName}">
                </div>

                <div class="field-details-info">
                    <h1>${field.fieldName}</h1>
                    <div class="field-rating">
                        <div class="stars">
                            <c:forEach begin="1" end="5" var="i">
                                <span class="star ${i <= averageRating ? 'filled' : ''}">★</span>
                            </c:forEach>
                        </div>
                        <span class="rating-value">${averageRating}/5</span>
                        <span class="review-count">(${reviews.size()} đánh giá)</span>
                    </div>

                    <div class="field-details-meta">
                        <p class="field-type">
                            <strong>Loại sân:</strong>
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
                        <p class="field-location"><strong>Địa điểm:</strong> ${field.location}</p>
                        <p class="field-price"><strong>Giá thuê:</strong> <fmt:formatNumber value="${field.pricePerHour}" type="currency" currencySymbol=""/> VNĐ/giờ</p>
                        <p class="field-features">
                            <strong>Đặc điểm:</strong>
                            <span class="${field.isIndoor ? 'feature-indoor' : 'feature-outdoor'}">
                                ${field.isIndoor ? 'Trong nhà' : 'Ngoài trời'}
                            </span>
                            <c:if test="${field.hasLighting}">
                                <span class="feature-lighting">Có đèn chiếu sáng</span>
                            </c:if>
                        </p>
                    </div>

                    <c:if test="${not empty field.description}">
                        <div class="field-description">
                            <h3>Mô tả</h3>
                            <p>${field.description}</p>
                        </div>
                    </c:if>

                    <div class="field-details-actions">
                        <c:if test="${not empty loggedUser}">
                            <a href="/bookings/create/${field.id}" class="btn btn-primary btn-large">Đặt sân ngay</a>
                            <a href="/schedule/field/${field.id}" class="btn btn-secondary">Xem lịch đặt sân</a>
                        </c:if>
                        <c:if test="${empty loggedUser}">
                            <a href="/login?redirect=/fields/${field.id}" class="btn btn-primary">Đăng nhập để đặt sân</a>
                            <a href="/schedule/field/${field.id}" class="btn btn-secondary">Xem lịch đặt sân</a>
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="field-reviews-section">
                <h2>Đánh giá từ người dùng</h2>

                <c:if test="${empty reviews}">
                    <p class="no-data">Chưa có đánh giá nào cho sân này.</p>
                </c:if>

                <c:if test="${not empty reviews}">
                    <div class="reviews-list">
                        <c:forEach items="${reviews}" var="review">
                            <div class="review-card">
                                <div class="review-header">
                                    <div class="review-user">${review.username}</div>
                                    <div class="review-date"><fmt:formatDate value="${review.created_at}" pattern="dd/MM/yyyy" /></div>
                                </div>
                                <div class="review-rating">
                                    <c:forEach begin="1" end="5" var="i">
                                        <span class="star ${i <= review.rating ? 'filled' : ''}">★</span>
                                    </c:forEach>
                                </div>
                                <c:if test="${not empty review.comment}">
                                    <div class="review-comment">${review.comment}</div>
                                </c:if>

                                <c:if test="${loggedUser eq review.username}">
                                    <div class="review-actions">
                                        <button class="btn btn-secondary btn-sm edit-review-btn" data-review-id="${review.id}" data-rating="${review.rating}" data-comment="${review.comment}">Sửa</button>
                                        <form action="/reviews/${review.id}/delete" method="post" class="inline-form" onsubmit="return confirm('Bạn có chắc chắn muốn xóa đánh giá này?');">
                                            <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <c:if test="${not empty loggedUser}">
                    <div id="review-form" class="review-form">
                        <h3>Viết đánh giá của bạn</h3>
                        <form action="/reviews/create" method="post" id="createReviewForm">
                            <input type="hidden" name="fieldId" value="${field.id}">

                            <div class="form-group">
                                <label>Đánh giá:</label>
                                <div class="rating-input">
                                    <c:forEach begin="1" end="5" var="i">
                                        <input type="radio" id="star${i}" name="rating" value="${i}" required>
                                        <label for="star${i}">★</label>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="comment">Nhận xét (không bắt buộc):</label>
                                <textarea id="comment" name="comment" rows="4" placeholder="Chia sẻ trải nghiệm của bạn về sân này..."></textarea>
                            </div>

                            <div class="form-group">
                                <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                            </div>
                        </form>
                    </div>

                    <div id="edit-review-modal" class="modal">
                        <div class="modal-content">
                            <span class="close">&times;</span>
                            <h3>Chỉnh sửa đánh giá</h3>
                            <form action="" method="post" id="editReviewForm">
                                <div class="form-group">
                                    <label>Đánh giá:</label>
                                    <div class="rating-input edit-rating">
                                        <c:forEach begin="1" end="5" var="i">
                                            <input type="radio" id="edit-star${i}" name="rating" value="${i}" required>
                                            <label for="edit-star${i}">★</label>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="edit-comment">Nhận xét (không bắt buộc):</label>
                                    <textarea id="edit-comment" name="comment" rows="4"></textarea>
                                </div>

                                <div class="form-group">
                                    <button type="submit" class="btn btn-primary">Cập nhật đánh giá</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script src="/js/script.js"></script>
<script>
    // Edit review modal functionality
    const modal = document.getElementById('edit-review-modal');
    const editButtons = document.querySelectorAll('.edit-review-btn');
    const closeBtn = document.querySelector('.close');
    const editForm = document.getElementById('editReviewForm');

    editButtons.forEach(button => {
        button.addEventListener('click', function() {
            const reviewId = this.getAttribute('data-review-id');
            const rating = this.getAttribute('data-rating');
            const comment = this.getAttribute('data-comment');

            // Set form action
            editForm.action = `/reviews/${reviewId}/update`;

            // Set rating
            document.querySelector(`#edit-star${rating}`).checked = true;

            // Set comment
            document.getElementById('edit-comment').value = comment || '';

            // Show modal
            modal.style.display = 'block';
        });
    });

    closeBtn.addEventListener('click', function() {
        modal.style.display = 'none';
    });

    window.addEventListener('click', function(event) {
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    });
</script>
</body>
</html>