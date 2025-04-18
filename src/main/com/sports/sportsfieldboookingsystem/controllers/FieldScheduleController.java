package com.sports.sportsfieldboookingsystem.controllers;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sports.sportsfieldboookingsystem.handlers.SessionHandler;
import com.sports.sportsfieldboookingsystem.models.FieldBooking;
import com.sports.sportsfieldboookingsystem.models.SportsField;
import com.sports.sportsfieldboookingsystem.services.FieldBookingService;
import com.sports.sportsfieldboookingsystem.services.SportsFieldService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/schedule")
public class FieldScheduleController {
    
    @Autowired
    private FieldBookingService fieldBookingService;
    
    @Autowired
    private SportsFieldService sportsFieldService;
    
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    
    /**
     * Hiển thị lịch đặt sân theo ngày
     */
    @GetMapping("/field/{fieldId}")
    public String getFieldSchedule(
            @PathVariable Long fieldId,
            @RequestParam(required = false) String date,
            HttpSession session,
            Model model) {
        
        String loggedUser = SessionHandler.getUsernameSession(session);
        model.addAttribute("loggedUser", loggedUser);
        
        // Lấy thông tin sân
        Optional<SportsField> optionalField = sportsFieldService.getFieldById(fieldId);
        if (!optionalField.isPresent()) {
            return "redirect:/fields?error=notFound";
        }
        
        SportsField field = optionalField.get();
        model.addAttribute("field", field);
        
        // Xác định ngày cần xem lịch
        LocalDate scheduleDate;
        if (date != null && !date.isEmpty()) {
            try {
                scheduleDate = LocalDate.parse(date, DATE_FORMATTER);
            } catch (Exception e) {
                scheduleDate = LocalDate.now();
            }
        } else {
            scheduleDate = LocalDate.now();
        }
        
        model.addAttribute("scheduleDate", scheduleDate);
        model.addAttribute("formattedDate", scheduleDate.format(DATE_FORMATTER));
        
        // Lấy danh sách đặt sân trong ngày
        List<FieldBooking> bookings = fieldBookingService.getBookingsByFieldAndDate(fieldId, scheduleDate);
        model.addAttribute("bookings", bookings);
        
        // Tạo danh sách các khung giờ (từ 6h sáng đến 22h tối)
        List<Map<String, Object>> timeSlots = new ArrayList<>();
        for (int hour = 6; hour < 22; hour++) {
            Map<String, Object> slot = new HashMap<>();
            slot.put("hour", hour);
            slot.put("formattedHour", String.format("%02d:00", hour));
            slot.put("available", fieldBookingService.isTimeSlotAvailable(fieldId, scheduleDate, hour));
            timeSlots.add(slot);
        }
        
        model.addAttribute("timeSlots", timeSlots);
        
        // Ngày trước và ngày sau để điều hướng
        model.addAttribute("previousDate", scheduleDate.minusDays(1).format(DATE_FORMATTER));
        model.addAttribute("nextDate", scheduleDate.plusDays(1).format(DATE_FORMATTER));
        
        return "fieldSchedule";
    }
    
    /**
     * API để kiểm tra khả dụng của khung giờ
     */
    @GetMapping("/api/availability")
    @ResponseBody
    public Map<String, Object> checkAvailability(
            @RequestParam Long fieldId,
            @RequestParam String date,
            @RequestParam Integer hour) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            LocalDate scheduleDate = LocalDate.parse(date, DATE_FORMATTER);
            boolean available = fieldBookingService.isTimeSlotAvailable(fieldId, scheduleDate, hour);
            
            response.put("available", available);
            response.put("fieldId", fieldId);
            response.put("date", date);
            response.put("hour", hour);
            response.put("success", true);
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
        }
        
        return response;
    }
}
