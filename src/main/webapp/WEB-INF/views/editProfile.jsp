<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật thông tin cá nhân - Sports Field Booking</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .edit-profile-container {
            max-width: 800px;
            margin: 30px auto;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }

        .edit-profile-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .edit-profile-header h2 {
            margin: 0;
            color: #333;
        }

        .edit-profile-form {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: bold;
            color: #666;
            margin-bottom: 5px;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
        }

        .form-group input:focus, .form-group select:focus {
            border-color: #2196F3;
            outline: none;
            box-shadow: 0 0 0 2px rgba(33, 150, 243, 0.2);
        }

        .form-section {
            margin-bottom: 30px;
        }

        .form-section h3 {
            margin-top: 0;
            margin-bottom: 20px;
            color: #333;
            font-size: 1.2rem;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .form-actions {
            margin-top: 30px;
            display: flex;
            justify-content: flex-end;
            gap: 15px;
        }

        .error-message {
            background-color: #ffebee;
            color: #d32f2f;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .error-message:before {
            content: '\26A0';
            display: inline-block;
            margin-right: 10px;
            font-size: 1.2rem;
        }

        .required-field::after {
            content: " *";
            color: #d32f2f;
        }

        .password-toggle {
            position: relative;
        }

        .password-toggle input {
            padding-right: 40px;
        }

        .password-toggle-icon {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #666;
        }

        @media (max-width: 768px) {
            .edit-profile-form {
                grid-template-columns: 1fr;
            }
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
                <li><a href="/user/profile" class="active">Trang cá nhân</a></li>
            </ul>
            <div class="navbar-account">
                <span>Xin chào, ${user.name}</span> | <a href="/logout">Đăng xuất</a>
            </div>
        </div>

        <div class="edit-profile-container">
            <div class="edit-profile-header">
                <h2>Cập nhật thông tin cá nhân</h2>
                <a href="/user/profile" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Quay lại</a>

            </div>

            <c:if test="${param.error eq 'emailExists'}">
                <div class="error-message">
                    Email đã được sử dụng bởi tài khoản khác. Vui lòng chọn email khác.
                </div>
            </c:if>

            <c:if test="${param.error eq 'wrongPassword'}">
                <div class="error-message">
                    Mật khẩu hiện tại không chính xác.
                </div>
            </c:if>

            <c:if test="${param.error eq 'passwordMismatch'}">
                <div class="error-message">
                    Mật khẩu mới và xác nhận mật khẩu không khớp.
                </div>
            </c:if>

            <form action="/user/update" method="post" enctype="multipart/form-data">
                <div class="form-section">
                    <h3>Thông tin cơ bản</h3>

                    <div class="avatar-upload-container" style="margin-bottom: 20px; text-align: center;">
                        <div style="width: 150px; height: 150px; margin: 0 auto 15px; border-radius: 50%; overflow: hidden; border: 3px solid #eee;">
                            <img id="avatar-preview" src="${empty user.avatarUrl ? '/images/profile-avatar.png' : user.avatarUrl}" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover;">
                        </div>
                        <div class="form-group">
                            <label for="avatar">Thay đổi ảnh đại diện</label>
                            <input type="file" id="avatar" name="avatar" accept="image/*" style="display: block; margin: 10px auto;">
                            <small>Chọn ảnh có kích thước tối đa 5MB</small>
                        </div>
                    </div>

                    <div class="edit-profile-form">
                        <div class="form-group">
                            <label for="username" class="required-field">Tên đăng nhập</label>
                            <input type="text" id="username" value="${user.username}" readonly disabled>
                            <small>Tên đăng nhập không thể thay đổi</small>
                        </div>

                        <div class="form-group">
                            <label for="name" class="required-field">Họ và tên</label>
                            <input type="text" id="name" name="name" value="${user.name}" required>
                        </div>

                        <div class="form-group">
                            <label for="email" class="required-field">Email</label>
                            <input type="email" id="email" name="email" value="${user.email}" required>
                        </div>

                        <div class="form-group">
                            <label for="phone_number" class="required-field">Số điện thoại</label>
                            <input type="tel" id="phone_number" name="phone_number" value="${user.phone_number}" required>
                        </div>

                        <div class="form-group">
                            <label for="age">Tuổi</label>
                            <input type="number" id="age" name="age" value="${user.age}" min="1" max="120">
                        </div>

                        <div class="form-group">
                            <label for="gender">Giới tính</label>
                            <select id="gender" name="gender">
                                <option value="" ${empty user.gender ? 'selected' : ''}>-- Chọn giới tính --</option>
                                <option value="Nam" ${user.gender eq 'Nam' ? 'selected' : ''}>Nam</option>
                                <option value="Nữ" ${user.gender eq 'Nữ' ? 'selected' : ''}>Nữ</option>
                                <option value="Khác" ${user.gender eq 'Khác' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="address">Địa chỉ</label>
                            <input type="text" id="address" name="address" value="${user.address}">
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h3>Đổi mật khẩu</h3>
                    <p>Để trống nếu bạn không muốn thay đổi mật khẩu</p>

                    <div class="edit-profile-form">
                        <div class="form-group">
                            <label for="currentPassword">Mật khẩu hiện tại</label>
                            <div class="password-toggle">
                                <input type="password" id="currentPassword" name="currentPassword">
                                <span class="password-toggle-icon" onclick="togglePassword('currentPassword')">
                                    <i class="fas fa-eye"></i>
                                </span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="newPassword">Mật khẩu mới</label>
                            <div class="password-toggle">
                                <input type="password" id="newPassword" name="newPassword">
                                <span class="password-toggle-icon" onclick="togglePassword('newPassword')">
                                    <i class="fas fa-eye"></i>
                                </span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Xác nhận mật khẩu mới</label>
                            <div class="password-toggle">
                                <input type="password" id="confirmPassword" name="confirmPassword">
                                <span class="password-toggle-icon" onclick="togglePassword('confirmPassword')">
                                    <i class="fas fa-eye"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="/user/profile" class="btn btn-secondary">Hủy</a>
                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                </div>
            </form>
            </div>
        </div>
    </div>

    <script>
        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const icon = input.nextElementSibling.querySelector('i');

            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        // Form validation
        document.querySelector('form').addEventListener('submit', function(event) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const currentPassword = document.getElementById('currentPassword').value;

            if (newPassword || confirmPassword || currentPassword) {
                if (!currentPassword) {
                    event.preventDefault();
                    alert('Vui lòng nhập mật khẩu hiện tại để đổi mật khẩu.');
                    return;
                }

                if (newPassword !== confirmPassword) {
                    event.preventDefault();
                    alert('Mật khẩu mới và xác nhận mật khẩu không khớp.');
                    return;
                }

                if (newPassword.length < 6) {
                    event.preventDefault();
                    alert('Mật khẩu mới phải có ít nhất 6 ký tự.');
                    return;
                }
            }
        });

        // Xem trước ảnh đại diện
        document.getElementById('avatar').addEventListener('change', function(event) {
            const file = event.target.files[0];
            if (file) {
                // Kiểm tra kích thước file (tối đa 5MB)
                if (file.size > 5 * 1024 * 1024) {
                    alert('Kích thước file quá lớn. Vui lòng chọn file nhỏ hơn 5MB.');
                    event.target.value = ''; // Xóa file đã chọn
                    return;
                }

                // Kiểm tra loại file
                if (!file.type.match('image.*')) {
                    alert('Vui lòng chọn file ảnh.');
                    event.target.value = '';
                    return;
                }

                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('avatar-preview').src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        });
    </script>
</body>
</html>
