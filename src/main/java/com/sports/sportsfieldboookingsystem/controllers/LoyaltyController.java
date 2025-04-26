package com.sports.sportsfieldboookingsystem.controllers;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sports.sportsfieldboookingsystem.handlers.SessionHandler;
import com.sports.sportsfieldboookingsystem.models.LoyaltyPoint;
import com.sports.sportsfieldboookingsystem.models.LoyaltyTransaction;
import com.sports.sportsfieldboookingsystem.models.UserRole;
import com.sports.sportsfieldboookingsystem.models.Users;
import com.sports.sportsfieldboookingsystem.services.LoyaltyPointService;
import com.sports.sportsfieldboookingsystem.services.UserServices;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/loyalty")
public class LoyaltyController {
    
    @Autowired
    private LoyaltyPointService loyaltyPointService;
    
    @Autowired
    private UserServices userServices;
    
    /**
     * Hiển thị trang điểm tích lũy của người dùng
     */
    @GetMapping("")
    public String getLoyaltyPage(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        LoyaltyPoint loyaltyPoint = loyaltyPointService.getOrCreateLoyaltyPoint(loggedUser);
        List<LoyaltyTransaction> transactions = loyaltyPointService.getTransactionHistory(loggedUser);
        
        model.addAttribute("loyaltyPoint", loyaltyPoint);
        model.addAttribute("transactions", transactions);
        model.addAttribute("loggedUser", loggedUser);
        
        return "user/loyalty";
    }
    
    /**
     * Hiển thị trang quản lý điểm tích lũy (admin)
     */
    @GetMapping("/admin")
    public String getAdminLoyaltyPage(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        List<Users> users = userServices.getAllUsers();
        model.addAttribute("users", users);
        model.addAttribute("loggedUser", loggedUser);
        
        return "admin/loyaltyManagement";
    }
    
    /**
     * Hiển thị trang điểm tích lũy của người dùng cụ thể (admin)
     */
    @GetMapping("/admin/user/{username}")
    public String getUserLoyaltyPage(@PathVariable String username, HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        Users targetUser = userServices.findByUsername(username);
        if (targetUser == null) {
            return "redirect:/loyalty/admin?error=userNotFound";
        }
        
        LoyaltyPoint loyaltyPoint = loyaltyPointService.getOrCreateLoyaltyPoint(username);
        List<LoyaltyTransaction> transactions = loyaltyPointService.getTransactionHistory(username);
        
        model.addAttribute("targetUser", targetUser);
        model.addAttribute("loyaltyPoint", loyaltyPoint);
        model.addAttribute("transactions", transactions);
        model.addAttribute("loggedUser", loggedUser);
        
        return "admin/userLoyalty";
    }
    
    /**
     * Xử lý điều chỉnh điểm tích lũy (admin)
     */
    @PostMapping("/admin/adjust")
    public String adjustLoyaltyPoints(
            @RequestParam String username,
            @RequestParam Integer points,
            @RequestParam String description,
            HttpSession session) {
        
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        Users targetUser = userServices.findByUsername(username);
        if (targetUser == null) {
            return "redirect:/loyalty/admin?error=userNotFound";
        }
        
        loyaltyPointService.adjustPoints(username, points, description);
        
        return "redirect:/loyalty/admin/user/" + username + "?success=adjusted";
    }
    
    /**
     * Xử lý sử dụng điểm tích lũy khi đặt sân
     */
    @PostMapping("/use")
    public String usePoints(
            @RequestParam Integer points,
            @RequestParam Long bookingId,
            HttpSession session) {
        
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        boolean success = loyaltyPointService.usePoints(loggedUser, points, bookingId, "Sử dụng điểm cho đặt sân #" + bookingId);
        
        if (success) {
            return "redirect:/payment/" + bookingId + "?success=pointsUsed";
        } else {
            return "redirect:/payment/" + bookingId + "?error=notEnoughPoints";
        }
    }
}
