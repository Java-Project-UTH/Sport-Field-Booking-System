<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Sports Field Booking</title>
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
            <div class="auth-form register-form">
                <h2>Đăng ký tài khoản</h2>

                <% if (request.getParameter("error") != null) { %>
                    <div class="error-message">
                        <% if (request.getParameter("error").equals("usernameExists")) { %>
                            Tên đăng nhập đã tồn tại. Vui lòng chọn tên khác.
                        <% } else if (request.getParameter("error").equals("emailExists")) { %>
                            Email đã được sử dụng. Vui lòng sử dụng email khác.
                        <% } else { %>
                            Đã xảy ra lỗi. Vui lòng thử lại.
                        <% } %>
                    </div>
                <% } %>

                <form action="/register" method="post" id="registerForm">
                    <div class="form-group">
                        <label for="username">Tên đăng nhập:</label>
                        <input type="text" id="username" name="username" required>
                    </div>

                    <div class="form-group">
                        <label for="password">Mật khẩu:</label>
                        <input type="password" id="password" name="password" required>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Xác nhận mật khẩu:</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>

                    <div class="form-group">
                        <label for="name">Họ và tên:</label>
                        <input type="text" id="name" name="name" required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" required>
                    </div>

                    <div class="form-group">
                        <label for="phone_number">Số điện thoại:</label>
                        <input type="tel" id="phone_number" name="phone_number" required>
                    </div>

                    <div class="form-group">
                        <label for="age">Tuổi:</label>
                        <input type="number" id="age" name="age" min="1" max="120">
                    </div>

                    <div class="form-group">
                        <label for="gender">Giới tính:</label>
                        <select id="gender" name="gender">
                            <option value="">-- Chọn giới tính --</option>
                            <option value="Nam">Nam</option>
                            <option value="Nữ">Nữ</option>
                            <option value="Khác">Khác</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="address">Địa chỉ:</label>
                        <textarea id="address" name="address" rows="3"></textarea>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">Đăng ký</button>
                    </div>
                </form>

                <div class="auth-links">
                    <p>Đã có tài khoản? <a href="/login">Đăng nhập</a></p>
                </div>
            </div>
        </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script src="/js/script.js"></script>
    <script src="/js/sidebar.js"></script>
    <script>
        document.getElementById('registerForm').addEventListener('submit', function(event) {
            var password = document.getElementById('password').value;
            var confirmPassword = document.getElementById('confirmPassword').value;

            if (password !== confirmPassword) {
                event.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
            }
        });
    </script>
</body>
</html>
