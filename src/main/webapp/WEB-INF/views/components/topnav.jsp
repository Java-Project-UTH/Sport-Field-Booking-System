<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Top Navbar -->
<div class="top-navbar">
    <div class="left-section">
        <c:if test="${not empty loggedUser}">
            <button class="menu-toggle">
                <i class="fas fa-bars"></i>
            </button>
        </c:if>
        <div class="top-navbar-brand">Sports Field Booking</div>
    </div>
    <div class="top-navbar-actions">
        <c:if test="${empty loggedUser}">
            <a href="/login" class="btn btn-primary"><i class="fas fa-sign-in-alt"></i> Đăng nhập</a>
            <a href="/register" class="btn btn-secondary"><i class="fas fa-user-plus"></i> Đăng ký</a>
        </c:if>
        <c:if test="${not empty loggedUser}">
            <div class="user-info">
                <span><i class="fas fa-user"></i> Xin chào, ${loggedUser}</span>
            </div>
            <a href="/logout" class="btn btn-secondary"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
        </c:if>
    </div>
</div>
