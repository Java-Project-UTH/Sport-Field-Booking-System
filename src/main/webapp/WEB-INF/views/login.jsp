<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Sports Field Booking</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="/css/sidebar.css">
</head>
<body>
    <div class="main-container">
        <!-- Include Sidebar -->
        <jsp:include page="components/sidebar.jsp" />

        <div class="main-content">
            <!-- Include Top Navbar -->
            <jsp:include page="components/topnav.jsp" />

            <div class="container">

        <div class="auth-container">
            <div class="auth-form">
                <h2>Đăng nhập</h2>

                <% if (request.getParameter("error") != null) { %>
                    <div class="error-message">
                        <% if (request.getParameter("error").equals("invalid")) { %>
                            Tên đăng nhập hoặc mật khẩu không đúng.
                        <% } else { %>
                            Đã xảy ra lỗi. Vui lòng thử lại.
                        <% } %>
                    </div>
                <% } %>

                <% if (request.getParameter("registered") != null) { %>
                    <div class="success-message">
                        Đăng ký thành công! Vui lòng đăng nhập.
                    </div>
                <% } %>

                <form action="/login" method="post">
                    <div class="form-group">
                        <label for="username">Tên đăng nhập:</label>
                        <input type="text" id="username" name="username" required>
                    </div>

                    <div class="form-group">
                        <label for="password">Mật khẩu:</label>
                        <input type="password" id="password" name="password" required>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">Đăng nhập</button>
                    </div>
                </form>

                <div class="auth-links">
                    <p>Chưa có tài khoản? <a href="/register">Đăng ký ngay</a></p>
                </div>
            </div>
        </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script src="/js/script.js"></script>
    <script src="/js/sidebar.js"></script>
</body>
</html>
