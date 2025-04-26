package com.sports.sportsfieldboookingsystem.controllers;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.sports.sportsfieldboookingsystem.handlers.EncryptionHandler;
import com.sports.sportsfieldboookingsystem.handlers.SessionHandler;
import com.sports.sportsfieldboookingsystem.models.FieldBooking;
import com.sports.sportsfieldboookingsystem.models.Users;
import com.sports.sportsfieldboookingsystem.models.FieldBooking.BookingStatus;
import com.sports.sportsfieldboookingsystem.services.FieldBookingService;
import com.sports.sportsfieldboookingsystem.services.UserServices;

import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserServices userServices;

    @Autowired
    private FieldBookingService fieldBookingService;

    @GetMapping("/profile")
    public String getUserProfile(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null)
            return "redirect:/login";

        Users user = userServices.findByUsername(loggedUser);
        System.out.println("User profile loaded: " + loggedUser);
        System.out.println("Avatar URL: " + (user.getAvatarUrl() != null ? user.getAvatarUrl() : "null"));
        System.out.println("User role: " + user.getRole());
        model.addAttribute("user", user);

        try {
            // Get user's active bookings
            List<FieldBooking> activeBookings = fieldBookingService.getUserBookingsByStatus(loggedUser, BookingStatus.CONFIRMED);
            model.addAttribute("activeBookings", activeBookings);
            System.out.println("Active bookings: " + activeBookings.size());

            // Get user's pending bookings
            List<FieldBooking> pendingBookings = fieldBookingService.getUserBookingsByStatus(loggedUser, BookingStatus.PENDING);
            model.addAttribute("pendingBookings", pendingBookings);
            System.out.println("Pending bookings: " + pendingBookings.size());

            // Get user's completed bookings
            List<FieldBooking> completedBookings = fieldBookingService.getUserBookingsByStatus(loggedUser, BookingStatus.COMPLETED);
            model.addAttribute("completedBookings", completedBookings);
            System.out.println("Completed bookings: " + completedBookings.size());
        } catch (Exception e) {
            System.err.println("Error loading bookings: " + e.getMessage());
            e.printStackTrace();
            // Provide empty lists in case of error
            model.addAttribute("activeBookings", java.util.Collections.emptyList());
            model.addAttribute("pendingBookings", java.util.Collections.emptyList());
            model.addAttribute("completedBookings", java.util.Collections.emptyList());
        }

        return "profile";
    }

    @GetMapping("/edit-profile")
    public String getEditProfilePage(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null)
            return "redirect:/login";

        Users user = userServices.findByUsername(loggedUser);
        model.addAttribute("user", user);

        return "editProfile";
    }

    @PostMapping("/update")
    public String updateUserProfile(
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String phone_number,
            @RequestParam(required = false) Integer age,
            @RequestParam(required = false) String gender,
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String currentPassword,
            @RequestParam(required = false) String newPassword,
            @RequestParam(required = false) String confirmPassword,
            @RequestParam(required = false) MultipartFile avatar,
            HttpSession session) {

        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null)
            return "redirect:/login";

        Users user = userServices.findByUsername(loggedUser);
        if (user == null) {
            return "redirect:/login";
        }

        // Kiểm tra email đã tồn tại chưa (nếu email thay đổi)
        if (!email.equals(user.getEmail())) {
            Users existingUser = userServices.findByEmail(email);
            if (existingUser != null) {
                return "redirect:/user/edit-profile?error=emailExists";
            }
        }

        // Cập nhật thông tin cơ bản
        user.setName(name);
        user.setEmail(email);
        user.setPhone_number(phone_number);
        user.setAge(age);
        user.setGender(gender);
        user.setAddress(address);

        // Xử lý đổi mật khẩu nếu có
        if (currentPassword != null && !currentPassword.isEmpty()) {
            // Kiểm tra mật khẩu hiện tại
            if (!userServices.verifyPassword(loggedUser, currentPassword)) {
                return "redirect:/user/edit-profile?error=wrongPassword";
            }

            // Kiểm tra mật khẩu mới và xác nhận mật khẩu
            if (!newPassword.equals(confirmPassword)) {
                return "redirect:/user/edit-profile?error=passwordMismatch";
            }

            // Cập nhật mật khẩu mới
            String hashedPassword = EncryptionHandler.encryptPassword(newPassword);
            user.setPassword(hashedPassword);
        }

        // Xử lý tải lên ảnh đại diện nếu có
        if (avatar != null && !avatar.isEmpty()) {
            try {
                // Tạo thư mục lưu trữ ảnh nếu chưa tồn tại
                String uploadDir = "src/main/resources/static/images/avatars";
                Path uploadPath = Paths.get(uploadDir);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }

                // Tạo tên file duy nhất
                String originalFilename = avatar.getOriginalFilename();
                String fileExtension = "";
                if (originalFilename != null && originalFilename.contains(".")) {
                    fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
                }
                String filename = loggedUser + "_" + System.currentTimeMillis() + fileExtension;

                // Lưu file
                Path filePath = uploadPath.resolve(filename);
                Files.copy(avatar.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

                // Cập nhật đường dẫn ảnh trong cơ sở dữ liệu
                user.setAvatarUrl("/images/avatars/" + filename);

                System.out.println("Avatar uploaded successfully: " + filename);
                System.out.println("Avatar URL set to: " + user.getAvatarUrl());

            } catch (IOException e) {
                System.err.println("Error uploading avatar: " + e.getMessage());
                e.printStackTrace();
                // Tiếp tục cập nhật thông tin người dùng ngay cả khi tải ảnh lên thất bại
            }
        }

        // Lưu thông tin người dùng
        userServices.updateUser(user);

        return "redirect:/user/profile?success=updated";
    }
}
