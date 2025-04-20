<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sports Field Booking System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --primary-color: #2196F3;
            --secondary-color: #4CAF50;
            --dark-color: #1A237E;
            --light-color: #E3F2FD;
            --accent-color: #FF9800;
            --text-color: #333;
            --light-text: #fff;
            --border-radius: 8px;
            --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f5f5f5;
            color: var(--text-color);
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Navbar Styles */
        .navbar {
            background-color: var(--primary-color);
            color: var(--light-text);
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .navbar-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar-brand {
            font-size: 1.5rem;
            font-weight: bold;
            text-decoration: none;
            color: var(--light-text);
        }

        .navbar-links {
            display: flex;
            list-style: none;
        }

        .navbar-links li {
            margin-left: 1.5rem;
        }

        .navbar-links a {
            color: var(--light-text);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }

        .navbar-links a:hover {
            color: var(--light-color);
        }

        .navbar-account {
            display: flex;
            align-items: center;
        }

        .navbar-account a {
            color: var(--light-text);
            text-decoration: none;
            margin-left: 1rem;
            transition: var(--transition);
        }

        .navbar-account a:hover {
            color: var(--light-color);
        }

        /* Hero Section */
        .hero {
            background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), url('/images/hero-bg.jpg');
            background-size: cover;
            background-position: center;
            color: var(--light-text);
            padding: 100px 0;
            text-align: center;
        }

        .hero-content {
            max-width: 800px;
            margin: 0 auto;
        }

        .hero h1 {
            font-size: 3rem;
            margin-bottom: 1.5rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }

        .hero p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
        }

        .btn {
            display: inline-block;
            padding: 12px 30px;
            background-color: var(--secondary-color);
            color: var(--light-text);
            border: none;
            border-radius: var(--border-radius);
            text-decoration: none;
            font-weight: bold;
            cursor: pointer;
            transition: var(--transition);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn:hover {
            background-color: #388E3C;
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }

        .btn-primary {
            background-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: #1976D2;
        }

        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
        }

        /* Features Section */
        .features {
            padding: 80px 0;
            background-color: #fff;
        }

        .section-title {
            text-align: center;
            margin-bottom: 50px;
            position: relative;
        }

        .section-title h2 {
            font-size: 2.5rem;
            color: var(--dark-color);
            margin-bottom: 15px;
        }

        .section-title p {
            font-size: 1.1rem;
            color: #666;
            max-width: 700px;
            margin: 0 auto;
        }

        .section-title::after {
            content: '';
            display: block;
            width: 80px;
            height: 4px;
            background-color: var(--primary-color);
            margin: 15px auto 0;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 50px;
        }

        .feature-card {
            background-color: #fff;
            border-radius: var(--border-radius);
            padding: 30px;
            box-shadow: var(--box-shadow);
            transition: var(--transition);
            text-align: center;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }

        .feature-icon {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 20px;
        }

        .feature-card h3 {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: var(--dark-color);
        }

        /* Services Section */
        .services {
            padding: 80px 0;
            background-color: var(--light-color);
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
        }

        .service-card {
            background-color: #fff;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--box-shadow);
            transition: var(--transition);
        }

        .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
        }

        .service-image {
            height: 200px;
            overflow: hidden;
        }

        .service-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: var(--transition);
        }

        .service-card:hover .service-image img {
            transform: scale(1.1);
        }

        .service-content {
            padding: 20px;
        }

        .service-content h3 {
            font-size: 1.3rem;
            margin-bottom: 10px;
            color: var(--dark-color);
        }

        .service-content p {
            color: #666;
            margin-bottom: 15px;
        }

        /* CTA Section */
        .cta {
            background: linear-gradient(to right, var(--primary-color), var(--dark-color));
            color: var(--light-text);
            padding: 80px 0;
            text-align: center;
        }

        .cta h2 {
            font-size: 2.5rem;
            margin-bottom: 20px;
        }

        .cta p {
            font-size: 1.2rem;
            margin-bottom: 30px;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Footer */
        .footer {
            background-color: #333;
            color: #fff;
            padding: 60px 0 20px;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            margin-bottom: 40px;
        }

        .footer-column h3 {
            font-size: 1.3rem;
            margin-bottom: 20px;
            color: var(--primary-color);
        }

        .footer-links {
            list-style: none;
        }

        .footer-links li {
            margin-bottom: 10px;
        }

        .footer-links a {
            color: #ccc;
            text-decoration: none;
            transition: var(--transition);
        }

        .footer-links a:hover {
            color: var(--primary-color);
        }

        .social-links {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .social-links a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            color: #fff;
            font-size: 1.2rem;
            transition: var(--transition);
        }

        .social-links a:hover {
            background-color: var(--primary-color);
            transform: translateY(-3px);
        }

        .footer-bottom {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 0.9rem;
            color: #999;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .navbar-content {
                flex-direction: column;
                padding: 10px 0;
            }

            .navbar-links {
                margin: 15px 0;
            }

            .hero h1 {
                font-size: 2.2rem;
            }

            .btn-group {
                flex-direction: column;
                align-items: center;
            }

            .section-title h2 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="container navbar-content">
            <a href="/" class="navbar-brand">Sports Field Booking</a>
            <ul class="navbar-links">
                <li><a href="/fields">Sân thể thao</a></li>
                <li><a href="#features">Tính năng</a></li>
                <li><a href="#services">Dịch vụ</a></li>
                <li><a href="#contact">Liên hệ</a></li>
            </ul>
            <div class="navbar-account">
                <c:if test="${empty loggedUser}">
                    <a href="/login"><i class="fas fa-sign-in-alt"></i> Đăng nhập</a>
                    <a href="/register"><i class="fas fa-user-plus"></i> Đăng ký</a>
                </c:if>
                <c:if test="${not empty loggedUser}">
                    <span><i class="fas fa-user"></i> Xin chào, ${loggedUser}</span>
                    <a href="/user/profile"><i class="fas fa-user-circle"></i> Trang cá nhân</a>
                    <a href="/logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
                </c:if>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <div class="container hero-content">
            <h1>Đặt sân thể thao dễ dàng và nhanh chóng</h1>
            <p>Hệ thống đặt sân thể thao trực tuyến giúp bạn tìm kiếm và đặt sân phù hợp với nhu cầu của mình một cách dễ dàng và tiện lợi.</p>
            <div class="btn-group">
                <a href="/fields" class="btn btn-primary"><i class="fas fa-search"></i> Tìm sân ngay</a>
                <a href="/register" class="btn"><i class="fas fa-user-plus"></i> Đăng ký tài khoản</a>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features" id="features">
        <div class="container">
            <div class="section-title">
                <h2>Tại sao chọn chúng tôi?</h2>
                <p>Chúng tôi cung cấp nền tảng đặt sân thể thao hiện đại với nhiều tính năng hữu ích</p>
            </div>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <h3>Tìm kiếm dễ dàng</h3>
                    <p>Tìm kiếm sân thể thao theo loại, địa điểm, giá cả và các tiện ích đi kèm một cách nhanh chóng.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="far fa-calendar-alt"></i>
                    </div>
                    <h3>Đặt sân linh hoạt</h3>
                    <p>Đặt sân theo ngày, giờ phù hợp với lịch trình của bạn, có thể đặt trước nhiều ngày.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <h3>Đánh giá thực tế</h3>
                    <p>Xem đánh giá từ người dùng khác để lựa chọn sân phù hợp nhất với nhu cầu của bạn.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <h3>Tiết kiệm thời gian</h3>
                    <p>Không cần gọi điện hay đến tận nơi để đặt sân, tất cả có thể thực hiện trực tuyến.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Services Section -->
    <section class="services" id="services">
        <div class="container">
            <div class="section-title">
                <h2>Dịch vụ của chúng tôi</h2>
                <p>Chúng tôi cung cấp đa dạng các loại sân thể thao để đáp ứng nhu cầu của bạn</p>
            </div>
            <div class="services-grid">
                <div class="service-card">
                    <div class="service-image">
                        <img src="/images1/football1.jpg" alt="Sân bóng đá">
                    </div>
                    <div class="service-content">
                        <h3>Sân bóng đá</h3>
                        <p>Đa dạng các loại sân bóng đá từ 5 người đến 11 người, sân cỏ nhân tạo chất lượng cao.</p>
                        <a href="/fields?type=FOOTBALL" class="btn btn-primary">Xem sân</a>
                    </div>
                </div>
                <div class="service-card">
                    <div class="service-image">
                        <img src="/images1/tennis1.jpg" alt="Sân tennis">
                    </div>
                    <div class="service-content">
                        <h3>Sân tennis</h3>
                        <p>Sân tennis tiêu chuẩn quốc tế với nhiều loại mặt sân khác nhau để lựa chọn.</p>
                        <a href="/fields?type=TENNIS" class="btn btn-primary">Xem sân</a>
                    </div>
                </div>
                <div class="service-card">
                    <div class="service-image">
                        <img src="/images1/badminton1.jpg" alt="Sân cầu lông">
                    </div>
                    <div class="service-content">
                        <h3>Sân cầu lông</h3>
                        <p>Sân cầu lông trong nhà với ánh sáng tốt, mặt sân chất lượng cao và dịch vụ hoàn hảo.</p>
                        <a href="/fields?type=BADMINTON" class="btn btn-primary">Xem sân</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta">
        <div class="container">
            <h2>Bắt đầu đặt sân ngay hôm nay</h2>
            <p>Đăng ký tài khoản miễn phí và trải nghiệm dịch vụ đặt sân thể thao tốt nhất của chúng tôi.</p>
            <a href="/register" class="btn">Đăng ký ngay</a>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer" id="contact">
        <div class="container">
            <div class="footer-content">
                <div class="footer-column">
                    <h3>Sports Field Booking</h3>
                    <p>Hệ thống đặt sân thể thao trực tuyến hàng đầu Việt Nam, giúp bạn dễ dàng tìm kiếm và đặt sân phù hợp với nhu cầu của mình.</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>
                <div class="footer-column">
                    <h3>Liên kết nhanh</h3>
                    <ul class="footer-links">
                        <li><a href="/">Trang chủ</a></li>
                        <li><a href="/fields">Sân thể thao</a></li>
                        <li><a href="#features">Tính năng</a></li>
                        <li><a href="#services">Dịch vụ</a></li>
                        <li><a href="/login">Đăng nhập</a></li>
                        <li><a href="/register">Đăng ký</a></li>
                    </ul>
                </div>
                <div class="footer-column">
                    <h3>Dịch vụ</h3>
                    <ul class="footer-links">
                        <li><a href="/fields?type=FOOTBALL">Sân bóng đá</a></li>
                        <li><a href="/fields?type=TENNIS">Sân tennis</a></li>
                        <li><a href="/fields?type=BADMINTON">Sân cầu lông</a></li>
                        <li><a href="/fields?type=BASKETBALL">Sân bóng rổ</a></li>
                        <li><a href="/fields?type=VOLLEYBALL">Sân bóng chuyền</a></li>
                    </ul>
                </div>
                <div class="footer-column">
                    <h3>Liên hệ</h3>
                    <ul class="footer-links">
                        <li><i class="fas fa-map-marker-alt"></i> 123 Đường ABC, Quận 1, TP.HCM</li>
                        <li><i class="fas fa-phone"></i> (028) 1234 5678</li>
                        <li><i class="fas fa-envelope"></i> info@sportsbooking.com</li>
                        <li><i class="fas fa-clock"></i> Thứ 2 - Chủ nhật: 8:00 - 22:00</li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 Sports Field Booking System. All Rights Reserved.</p>
            </div>
        </div>
    </footer>
</body>
</html>
