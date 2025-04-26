<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${not empty loggedUser}">
    <!-- Sidebar - Chỉ hiển thị khi đã đăng nhập -->
    <div class="sidebar">
        <div class="sidebar-brand">
            <h2>Sports Field Booking</h2>
        </div>
        <div class="sidebar-menu">
            <ul>
                <li><a href="/"><i class="fas fa-home"></i> Trang chủ</a></li>
                <li><a href="/fields"><i class="fas fa-futbol"></i> Sân thể thao</a></li>
                <li><a href="/user/profile"><i class="fas fa-user"></i> Trang cá nhân</a></li>
                <li><a href="/user/bookings"><i class="fas fa-calendar-check"></i> Đặt sân của tôi</a></li>
                <li><a href="/favorites"><i class="fas fa-heart"></i> Sân yêu thích</a></li>
                <li><a href="/membership"><i class="fas fa-crown"></i> Gói thành viên</a></li>
                <li><a href="#contact"><i class="fas fa-envelope"></i> Liên hệ</a></li>
            </ul>
        </div>
        <div class="sidebar-footer">
            <p>&copy; 2023 Sports Field Booking</p>
        </div>
    </div>

    <!-- Sidebar Overlay (for mobile) -->
    <div class="sidebar-overlay"></div>
</c:if>
