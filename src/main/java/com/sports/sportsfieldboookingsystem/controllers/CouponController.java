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
import com.sports.sportsfieldboookingsystem.models.Coupon;
import com.sports.sportsfieldboookingsystem.models.CouponUsage;
import com.sports.sportsfieldboookingsystem.models.SportsField;
import com.sports.sportsfieldboookingsystem.models.UserRole;
import com.sports.sportsfieldboookingsystem.models.Users;
import com.sports.sportsfieldboookingsystem.models.Coupon.CouponStatus;
import com.sports.sportsfieldboookingsystem.models.Coupon.CouponType;
import com.sports.sportsfieldboookingsystem.models.SportsField.FieldType;
import com.sports.sportsfieldboookingsystem.services.CouponService;
import com.sports.sportsfieldboookingsystem.services.UserServices;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/coupons")
public class CouponController {
    
    @Autowired
    private CouponService couponService;
    
    @Autowired
    private UserServices userServices;
    
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    
    /**
     * Hiển thị trang quản lý mã giảm giá
     */
    @GetMapping("")
    public String getCouponsPage(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        List<Coupon> coupons = couponService.getAllCoupons();
        model.addAttribute("coupons", coupons);
        model.addAttribute("loggedUser", loggedUser);
        
        return "admin/coupons";
    }
    
    /**
     * Hiển thị form thêm mã giảm giá mới
     */
    @GetMapping("/add")
    public String getAddCouponForm(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        // Tạo mã giảm giá ngẫu nhiên
        String randomCode = couponService.generateRandomCouponCode();
        
        model.addAttribute("coupon", new Coupon());
        model.addAttribute("randomCode", randomCode);
        model.addAttribute("couponTypes", CouponType.values());
        model.addAttribute("couponStatuses", CouponStatus.values());
        model.addAttribute("fieldTypes", FieldType.values());
        model.addAttribute("loggedUser", loggedUser);
        model.addAttribute("isNew", true);
        
        return "admin/couponForm";
    }
    
    /**
     * Xử lý thêm mã giảm giá mới
     */
    @PostMapping("/add")
    public String addCoupon(
            @RequestParam String code,
            @RequestParam String name,
            @RequestParam String description,
            @RequestParam CouponType type,
            @RequestParam Float value,
            @RequestParam Float minBookingValue,
            @RequestParam Float maxDiscountAmount,
            @RequestParam String startDate,
            @RequestParam String endDate,
            @RequestParam Integer maxUsage,
            @RequestParam Integer maxUsagePerUser,
            @RequestParam CouponStatus status,
            @RequestParam(required = false) FieldType[] fieldTypes,
            HttpSession session) {
        
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        // Kiểm tra mã giảm giá đã tồn tại chưa
        Optional<Coupon> existingCoupon = couponService.getCouponByCode(code);
        if (existingCoupon.isPresent()) {
            return "redirect:/admin/coupons/add?error=codeExists";
        }
        
        // Chuyển đổi chuỗi ngày thành LocalDateTime
        LocalDateTime startDateTime = LocalDateTime.parse(startDate, DATE_TIME_FORMATTER);
        LocalDateTime endDateTime = LocalDateTime.parse(endDate, DATE_TIME_FORMATTER);
        
        // Xử lý danh sách loại sân
        String fieldTypesStr = "";
        if (fieldTypes != null && fieldTypes.length > 0) {
            StringBuilder sb = new StringBuilder();
            for (FieldType fieldType : fieldTypes) {
                sb.append(fieldType.toString()).append(",");
            }
            fieldTypesStr = sb.toString();
            if (fieldTypesStr.endsWith(",")) {
                fieldTypesStr = fieldTypesStr.substring(0, fieldTypesStr.length() - 1);
            }
        }
        
        // Tạo đối tượng Coupon
        Coupon coupon = new Coupon(
            code,
            name,
            description,
            type,
            value,
            minBookingValue,
            maxDiscountAmount,
            startDateTime,
            endDateTime,
            maxUsage,
            maxUsagePerUser,
            status,
            fieldTypesStr
        );
        
        couponService.createCoupon(coupon);
        
        return "redirect:/admin/coupons?success=added";
    }
    
    /**
     * Hiển thị form chỉnh sửa mã giảm giá
     */
    @GetMapping("/edit/{id}")
    public String getEditCouponForm(@PathVariable Long id, HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        Optional<Coupon> optionalCoupon = couponService.getCouponById(id);
        if (!optionalCoupon.isPresent()) {
            return "redirect:/admin/coupons?error=notFound";
        }
        
        Coupon coupon = optionalCoupon.get();
        
        model.addAttribute("coupon", coupon);
        model.addAttribute("couponTypes", CouponType.values());
        model.addAttribute("couponStatuses", CouponStatus.values());
        model.addAttribute("fieldTypes", FieldType.values());
        model.addAttribute("selectedFieldTypes", coupon.getFieldTypes() != null ? coupon.getFieldTypes().split(",") : new String[0]);
        model.addAttribute("loggedUser", loggedUser);
        model.addAttribute("isNew", false);
        
        return "admin/couponForm";
    }
    
    /**
     * Xử lý cập nhật mã giảm giá
     */
    @PostMapping("/edit/{id}")
    public String updateCoupon(
            @PathVariable Long id,
            @RequestParam String name,
            @RequestParam String description,
            @RequestParam CouponType type,
            @RequestParam Float value,
            @RequestParam Float minBookingValue,
            @RequestParam Float maxDiscountAmount,
            @RequestParam String startDate,
            @RequestParam String endDate,
            @RequestParam Integer maxUsage,
            @RequestParam Integer maxUsagePerUser,
            @RequestParam CouponStatus status,
            @RequestParam(required = false) FieldType[] fieldTypes,
            HttpSession session) {
        
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        Optional<Coupon> optionalCoupon = couponService.getCouponById(id);
        if (!optionalCoupon.isPresent()) {
            return "redirect:/admin/coupons?error=notFound";
        }
        
        Coupon coupon = optionalCoupon.get();
        
        // Chuyển đổi chuỗi ngày thành LocalDateTime
        LocalDateTime startDateTime = LocalDateTime.parse(startDate, DATE_TIME_FORMATTER);
        LocalDateTime endDateTime = LocalDateTime.parse(endDate, DATE_TIME_FORMATTER);
        
        // Xử lý danh sách loại sân
        String fieldTypesStr = "";
        if (fieldTypes != null && fieldTypes.length > 0) {
            StringBuilder sb = new StringBuilder();
            for (FieldType fieldType : fieldTypes) {
                sb.append(fieldType.toString()).append(",");
            }
            fieldTypesStr = sb.toString();
            if (fieldTypesStr.endsWith(",")) {
                fieldTypesStr = fieldTypesStr.substring(0, fieldTypesStr.length() - 1);
            }
        }
        
        // Cập nhật thông tin mã giảm giá
        coupon.setName(name);
        coupon.setDescription(description);
        coupon.setType(type);
        coupon.setValue(value);
        coupon.setMinBookingValue(minBookingValue);
        coupon.setMaxDiscountAmount(maxDiscountAmount);
        coupon.setStartDate(startDateTime);
        coupon.setEndDate(endDateTime);
        coupon.setMaxUsage(maxUsage);
        coupon.setMaxUsagePerUser(maxUsagePerUser);
        coupon.setStatus(status);
        coupon.setFieldTypes(fieldTypesStr);
        
        couponService.updateCoupon(coupon);
        
        return "redirect:/admin/coupons?success=updated";
    }
    
    /**
     * Xử lý xóa mã giảm giá
     */
    @PostMapping("/delete/{id}")
    public String deleteCoupon(@PathVariable Long id, HttpSession session) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        couponService.deleteCoupon(id);
        
        return "redirect:/admin/coupons?success=deleted";
    }
    
    /**
     * Xử lý cập nhật trạng thái mã giảm giá
     */
    @PostMapping("/{id}/status")
    public String updateCouponStatus(
            @PathVariable Long id,
            @RequestParam CouponStatus status,
            HttpSession session) {
        
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        couponService.updateCouponStatus(id, status);
        
        return "redirect:/admin/coupons?success=statusUpdated";
    }
    
    /**
     * Hiển thị lịch sử sử dụng mã giảm giá
     */
    @GetMapping("/{id}/usage")
    public String getCouponUsageHistory(@PathVariable Long id, HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        Optional<Coupon> optionalCoupon = couponService.getCouponById(id);
        if (!optionalCoupon.isPresent()) {
            return "redirect:/admin/coupons?error=notFound";
        }
        
        Coupon coupon = optionalCoupon.get();
        List<CouponUsage> usageHistory = couponService.getCouponUsageHistory(id);
        
        model.addAttribute("coupon", coupon);
        model.addAttribute("usageHistory", usageHistory);
        model.addAttribute("loggedUser", loggedUser);
        
        return "admin/couponUsage";
    }
    
    /**
     * Tạo mã giảm giá ngẫu nhiên
     */
    @GetMapping("/generate-code")
    public String generateRandomCode(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        String randomCode = couponService.generateRandomCouponCode();
        model.addAttribute("randomCode", randomCode);
        
        return "admin/couponForm";
    }
}
