package com.sports.sportsfieldboookingsystem.controllers;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sports.sportsfieldboookingsystem.handlers.SessionHandler;
import com.sports.sportsfieldboookingsystem.models.Promotion;
import com.sports.sportsfieldboookingsystem.models.SportsField;
import com.sports.sportsfieldboookingsystem.models.UserRole;
import com.sports.sportsfieldboookingsystem.models.Users;
import com.sports.sportsfieldboookingsystem.models.Promotion.PromotionStatus;
import com.sports.sportsfieldboookingsystem.models.Promotion.PromotionType;
import com.sports.sportsfieldboookingsystem.models.SportsField.FieldType;
import com.sports.sportsfieldboookingsystem.services.PromotionService;
import com.sports.sportsfieldboookingsystem.services.UserServices;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/promotions")
public class PromotionController {
    
    @Autowired
    private PromotionService promotionService;
    
    @Autowired
    private UserServices userServices;
    
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    
    /**
     * Hiển thị trang quản lý khuyến mãi
     */
    @GetMapping("")
    public String getPromotionsPage(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        List<Promotion> promotions = promotionService.getAllPromotions();
        model.addAttribute("promotions", promotions);
        model.addAttribute("loggedUser", loggedUser);
        
        return "admin/promotions";
    }
    
    /**
     * Hiển thị form thêm khuyến mãi mới
     */
    @GetMapping("/add")
    public String getAddPromotionForm(HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        model.addAttribute("promotion", new Promotion());
        model.addAttribute("promotionTypes", PromotionType.values());
        model.addAttribute("promotionStatuses", PromotionStatus.values());
        model.addAttribute("fieldTypes", FieldType.values());
        model.addAttribute("loggedUser", loggedUser);
        model.addAttribute("isNew", true);
        
        return "admin/promotionForm";
    }
    
    /**
     * Xử lý thêm khuyến mãi mới
     */
    @PostMapping("/add")
    public String addPromotion(
            @RequestParam String name,
            @RequestParam String description,
            @RequestParam PromotionType type,
            @RequestParam Float value,
            @RequestParam Float minBookingValue,
            @RequestParam Float maxDiscountAmount,
            @RequestParam String startDate,
            @RequestParam String endDate,
            @RequestParam PromotionStatus status,
            @RequestParam(required = false) String imageUrl,
            @RequestParam(required = false) FieldType[] fieldTypes,
            HttpSession session) {
        
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
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
        
        // Tạo đối tượng Promotion
        Promotion promotion = new Promotion(
            name,
            description,
            type,
            value,
            minBookingValue,
            maxDiscountAmount,
            startDateTime,
            endDateTime,
            status,
            imageUrl,
            fieldTypesStr
        );
        
        promotionService.createPromotion(promotion);
        
        return "redirect:/admin/promotions?success=added";
    }
    
    /**
     * Hiển thị form chỉnh sửa khuyến mãi
     */
    @GetMapping("/edit/{id}")
    public String getEditPromotionForm(@PathVariable Long id, HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        Optional<Promotion> optionalPromotion = promotionService.getPromotionById(id);
        if (!optionalPromotion.isPresent()) {
            return "redirect:/admin/promotions?error=notFound";
        }
        
        Promotion promotion = optionalPromotion.get();
        
        model.addAttribute("promotion", promotion);
        model.addAttribute("promotionTypes", PromotionType.values());
        model.addAttribute("promotionStatuses", PromotionStatus.values());
        model.addAttribute("fieldTypes", FieldType.values());
        model.addAttribute("selectedFieldTypes", promotion.getFieldTypes() != null ? promotion.getFieldTypes().split(",") : new String[0]);
        model.addAttribute("loggedUser", loggedUser);
        model.addAttribute("isNew", false);
        
        return "admin/promotionForm";
    }
    
    /**
     * Xử lý cập nhật khuyến mãi
     */
    @PostMapping("/edit/{id}")
    public String updatePromotion(
            @PathVariable Long id,
            @RequestParam String name,
            @RequestParam String description,
            @RequestParam PromotionType type,
            @RequestParam Float value,
            @RequestParam Float minBookingValue,
            @RequestParam Float maxDiscountAmount,
            @RequestParam String startDate,
            @RequestParam String endDate,
            @RequestParam PromotionStatus status,
            @RequestParam(required = false) String imageUrl,
            @RequestParam(required = false) FieldType[] fieldTypes,
            HttpSession session) {
        
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        Optional<Promotion> optionalPromotion = promotionService.getPromotionById(id);
        if (!optionalPromotion.isPresent()) {
            return "redirect:/admin/promotions?error=notFound";
        }
        
        Promotion promotion = optionalPromotion.get();
        
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
        
        // Cập nhật thông tin khuyến mãi
        promotion.setName(name);
        promotion.setDescription(description);
        promotion.setType(type);
        promotion.setValue(value);
        promotion.setMinBookingValue(minBookingValue);
        promotion.setMaxDiscountAmount(maxDiscountAmount);
        promotion.setStartDate(startDateTime);
        promotion.setEndDate(endDateTime);
        promotion.setStatus(status);
        promotion.setImageUrl(imageUrl);
        promotion.setFieldTypes(fieldTypesStr);
        
        promotionService.updatePromotion(promotion);
        
        return "redirect:/admin/promotions?success=updated";
    }
    
    /**
     * Xử lý xóa khuyến mãi
     */
    @PostMapping("/delete/{id}")
    public String deletePromotion(@PathVariable Long id, HttpSession session) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        promotionService.deletePromotion(id);
        
        return "redirect:/admin/promotions?success=deleted";
    }
    
    /**
     * Xử lý cập nhật trạng thái khuyến mãi
     */
    @PostMapping("/{id}/status")
    public String updatePromotionStatus(
            @PathVariable Long id,
            @RequestParam PromotionStatus status,
            HttpSession session) {
        
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        // Kiểm tra quyền admin
        Users user = userServices.findByUsername(loggedUser);
        if (user == null || user.getRole() != UserRole.ADMIN) {
            return "redirect:/";
        }
        
        promotionService.updatePromotionStatus(id, status);
        
        return "redirect:/admin/promotions?success=statusUpdated";
    }
}
