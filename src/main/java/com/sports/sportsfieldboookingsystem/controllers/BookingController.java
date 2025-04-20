package com.sports.sportsfieldboookingsystem.controllers;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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
import com.sports.sportsfieldboookingsystem.models.FieldBooking;
import com.sports.sportsfieldboookingsystem.models.SportsField;
import com.sports.sportsfieldboookingsystem.services.FieldBookingService;
import com.sports.sportsfieldboookingsystem.services.SportsFieldService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/bookings")
public class BookingController {

    @Autowired
    private FieldBookingService fieldBookingService;

    @Autowired
    private SportsFieldService sportsFieldService;

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @GetMapping("/create/{fieldId}")
    public String getBookingForm(
            @PathVariable Long fieldId,
            @RequestParam(required = false) String startDateTime,
            @RequestParam(required = false) String endDateTime,
            HttpSession session,
            Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";

        Optional<SportsField> optionalField = sportsFieldService.getFieldById(fieldId);
        if (!optionalField.isPresent()) {
            return "redirect:/fields?error=notFound";
        }

        SportsField field = optionalField.get();
        model.addAttribute("field", field);
        model.addAttribute("loggedUser", loggedUser);

        // Nếu có tham số thời gian, truyền vào form
        if (startDateTime != null && !startDateTime.isEmpty()) {
            model.addAttribute("startDateTime", startDateTime);
        }

        if (endDateTime != null && !endDateTime.isEmpty()) {
            model.addAttribute("endDateTime", endDateTime);
        }

        return "bookingForm";
    }

    @PostMapping("/create")
    public String createBooking(
            @RequestParam Long fieldId,
            @RequestParam String startDateTime,
            @RequestParam String endDateTime,
            @RequestParam(required = false) String notes,
            @RequestParam(required = false, defaultValue = "1") Integer numberOfPlayers,
            HttpSession session,
            Model model) {

        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";

        try {
            // Kiểm tra định dạng ngày giờ
            LocalDateTime startTime;
            LocalDateTime endTime;
            try {
                startTime = LocalDateTime.parse(startDateTime, DATE_TIME_FORMATTER);
                endTime = LocalDateTime.parse(endDateTime, DATE_TIME_FORMATTER);
            } catch (Exception e) {
                return "redirect:/bookings/create/" + fieldId + "?error=invalidDateTimeFormat";
            }

            // Validate times
            if (startTime.isAfter(endTime)) {
                return "redirect:/bookings/create/" + fieldId + "?error=invalidTimes";
            }

            if (startTime.isBefore(LocalDateTime.now())) {
                return "redirect:/bookings/create/" + fieldId + "?error=pastTime";
            }

            // Kiểm tra xem sân có khả dụng không
            if (!fieldBookingService.isFieldAvailable(fieldId, startTime, endTime)) {
                return "redirect:/bookings/create/" + fieldId + "?error=fieldNotAvailable";
            }

            FieldBooking booking = fieldBookingService.createBooking(
                loggedUser,
                fieldId,
                startTime,
                endTime,
                notes,
                numberOfPlayers
            );

            // Chuyển hướng đến trang thanh toán
            return "redirect:/payment/" + booking.getId() + "?isNew=true";

        } catch (Exception e) {
            // Log lỗi để dễ debug
            System.err.println("Error creating booking: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/bookings/create/" + fieldId + "?error=" + e.getMessage().replace(" ", "+");
        }
    }

    @GetMapping("/{id}")
    public String getBookingDetails(@PathVariable Long id, HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";

        Optional<FieldBooking> optionalBooking = fieldBookingService.getBookingById(id);
        if (!optionalBooking.isPresent()) {
            return "redirect:/user/profile?error=bookingNotFound";
        }

        FieldBooking booking = optionalBooking.get();

        // Check if the booking belongs to the logged-in user
        if (!booking.getUsername().equals(loggedUser)) {
            return "redirect:/user/profile?error=unauthorized";
        }

        model.addAttribute("booking", booking);

        // Get field details
        Optional<SportsField> optionalField = sportsFieldService.getFieldById(booking.getFieldId());
        if (optionalField.isPresent()) {
            model.addAttribute("field", optionalField.get());
        }

        return "bookingDetails";
    }

    @PostMapping("/{id}/cancel")
    public String cancelBooking(@PathVariable Long id, HttpSession session) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";

        Optional<FieldBooking> optionalBooking = fieldBookingService.getBookingById(id);
        if (!optionalBooking.isPresent()) {
            return "redirect:/user/profile?error=bookingNotFound";
        }

        FieldBooking booking = optionalBooking.get();

        // Check if the booking belongs to the logged-in user
        if (!booking.getUsername().equals(loggedUser)) {
            return "redirect:/user/profile?error=unauthorized";
        }

        fieldBookingService.cancelBooking(id);

        return "redirect:/user/profile?success=bookingCancelled";
    }
}
