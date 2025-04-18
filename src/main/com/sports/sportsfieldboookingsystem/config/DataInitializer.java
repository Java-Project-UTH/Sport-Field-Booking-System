package com.sports.sportsfieldboookingsystem.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import com.sports.sportsfieldboookingsystem.handlers.EncryptionHandler;
import com.sports.sportsfieldboookingsystem.models.UserRole;
import com.sports.sportsfieldboookingsystem.models.Users;
import com.sports.sportsfieldboookingsystem.repositories.UserRepository;

/**
 * Lớp này sẽ tự động chạy khi ứng dụng khởi động
 * và tạo các tài khoản admin nếu chúng chưa tồn tại
 */
@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Override
    public void run(String... args) throws Exception {
        // Tạo tài khoản admin nếu chưa tồn tại
        createAdminAccount("admin", "Admin", "admin@example.com", "0123456789");
        
        // Tạo tài khoản admin2 nếu chưa tồn tại
        createAdminAccount("admin2", "Admin 2", "admin2@example.com", "0987654321");
        
        System.out.println("Khởi tạo dữ liệu hoàn tất!");
    }
    
    private void createAdminAccount(String username, String name, String email, String phoneNumber) {
        // Kiểm tra xem tài khoản đã tồn tại chưa
        Users existingUser = userRepository.findByUsername(username);
        
        if (existingUser == null) {
            System.out.println("Đang tạo tài khoản " + username + "...");
            
            // Tạo mật khẩu đã mã hóa (admin123)
            String hashedPassword = EncryptionHandler.encryptPassword("admin123");
            
            // Tạo đối tượng Users mới
            Users adminUser = new Users();
            adminUser.setUsername(username);
            adminUser.setPassword(hashedPassword);
            adminUser.setName(name);
            adminUser.setEmail(email);
            adminUser.setPhone_number(phoneNumber);
            adminUser.setAge(30);
            adminUser.setGender("Nam");
            adminUser.setAddress("TP.HCM");
            adminUser.setRole(UserRole.ADMIN);
            
            // Lưu vào database
            userRepository.save(adminUser);
            
            System.out.println("Đã tạo tài khoản " + username + " thành công!");
        } else {
            // Cập nhật mật khẩu nếu tài khoản đã tồn tại
            System.out.println("Tài khoản " + username + " đã tồn tại, đang cập nhật mật khẩu...");
            
            String hashedPassword = EncryptionHandler.encryptPassword("admin123");
            existingUser.setPassword(hashedPassword);
            userRepository.save(existingUser);
            
            System.out.println("Đã cập nhật mật khẩu cho tài khoản " + username + "!");
        }
    }
}
