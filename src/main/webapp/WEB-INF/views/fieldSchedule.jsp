<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch đặt sân - ${field.fieldName} - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        .schedule-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }

        .schedule-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .schedule-navigation {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .schedule-date-selector {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .schedule-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
            margin-top: 20px;
        }

        .time-slot {
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            text-align: center;
            transition: all 0.3s ease;
        }

        .time-slot.available {
            background-color: #e8f5e9;
            cursor: pointer;
        }

        .time-slot.available:hover {
            background-color: #c8e6c9;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .time-slot.unavailable {
            background-color: #ffebee;
            color: #888;
            position: relative;
        }

        .time-slot.unavailable::after {
            content: "Đã đặt";
            position: absolute;
            bottom: 5px;
            left: 0;
            right: 0;
            font-size: 12px;
            color: #d32f2f;
        }

        .time-slot-hour {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .booking-info {
            margin-top: 30px;
            border-top: 1px solid #ddd;
            padding-top: 20px;
        }

        .booking-list {
            margin-top: 15px;
        }

        .booking-item {
            background-color: #f5f5f5;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 10px;
        }

        .booking-time {
            font-weight: bold;
            color: #2196F3;
        }

        .booking-user {
            color: #555;
            font-style: italic;
        }

        .booking-status {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 12px;
            margin-left: 10px;
        }

        .status-pending {
            background-color: #FFF9C4;
            color: #FFA000;
        }

        .status-confirmed {
            background-color: #C8E6C9;
            color: #388E3C;
        }

        .status-cancelled {
            background-color: #FFCDD2;
            color: #D32F2F;
        }

        .status-completed {
            background-color: #BBDEFB;
            color: #1976D2;
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
            <c:if test="${not empty loggedUser}">
                <li><a href="/user/profile">Trang cá nhân</a></li>
            </c:if>
        </ul>
        <div class="navbar-account">
            <c:choose>
                <c:when test="${not empty loggedUser}">
                    <span>Xin chào, ${loggedUser}</span> | <a href="/logout">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a href="/login">Đăng nhập</a> | <a href="/register">Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="schedule-container">
        <div class="schedule-header">
            <a href="/fields/${field.id}" class="back-link">&larr; Quay lại thông tin sân</a>
            <h2>Lịch đặt sân ${field.fieldName}</h2>
        </div>

        <div class="schedule-navigation">
            <a href="/schedule/field/${field.id}?date=${previousDate}" class="btn btn-secondary">&larr; Ngày trước</a>

            <div class="schedule-date-selector">
                <form action="/schedule/field/${field.id}" method="get" id="dateForm">
                    <input type="date" name="date" value="${formattedDate}" onchange="this.form.submit()">
                </form>
            </div>

            <a href="/schedule/field/${field.id}?date=${nextDate}" class="btn btn-secondary">Ngày sau &rarr;</a>
        </div>

        <div class="schedule-grid">
            <c:forEach items="${timeSlots}" var="slot">
                <div class="time-slot ${slot.available ? 'available' : 'unavailable'}">
                    <div class="time-slot-hour">${slot.formattedHour}</div>
                    <c:if test="${slot.available && not empty loggedUser}">
                        <a href="/bookings/create/${field.id}?startDateTime=${formattedDate}T${slot.hour}:00&endDateTime=${formattedDate}T${slot.hour + 1}:00"
                           class="btn btn-primary btn-sm">Đặt sân</a>
                    </c:if>
                </div>
            </c:forEach>
        </div>

        <c:if test="${not empty bookings}">
            <div class="booking-info">
                <h3>Danh sách đặt sân trong ngày</h3>
                <div class="booking-list">
                    <c:forEach items="${bookings}" var="booking">
                        <div class="booking-item">
                            <div class="booking-time">
                                <fmt:parseDate value="${booking.startTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedStartTime" type="both" />
                                <fmt:parseDate value="${booking.endTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedEndTime" type="both" />
                                <fmt:formatDate value="${parsedStartTime}" pattern="HH:mm" /> - <fmt:formatDate value="${parsedEndTime}" pattern="HH:mm" />
                            </div>
                            <div class="booking-user">
                                <c:choose>
                                    <c:when test="${booking.username eq loggedUser}">
                                        Người đặt: Bạn
                                    </c:when>
                                    <c:otherwise>
                                        Đã có người đặt
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <c:if test="${booking.username eq loggedUser}">
                                    <span class="booking-status status-${booking.status.toString().toLowerCase()}">
                                        <c:choose>
                                            <c:when test="${booking.status eq 'PENDING'}">Chờ xác nhận</c:when>
                                            <c:when test="${booking.status eq 'CONFIRMED'}">Đã xác nhận</c:when>
                                            <c:when test="${booking.status eq 'CANCELLED'}">Đã hủy</c:when>
                                            <c:when test="${booking.status eq 'COMPLETED'}">Đã hoàn thành</c:when>
                                        </c:choose>
                                    </span>
                                <a href="/bookings/${booking.id}" class="btn btn-secondary btn-sm">Chi tiết</a>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Highlight current date
        const today = new Date().toISOString().split('T')[0];
        if ('${formattedDate}' === today) {
            document.querySelector('.schedule-date-selector').classList.add('today');
        }
    });
</script>
</body>
</html>