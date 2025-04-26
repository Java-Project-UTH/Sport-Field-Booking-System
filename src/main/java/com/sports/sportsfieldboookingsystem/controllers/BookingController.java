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

        return "bookingform";
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
                System.out.println("Parsing start date time: " + startDateTime);
                startTime = LocalDateTime.parse(startDateTime, DATE_TIME_FORMATTER);
                System.out.println("Parsing end date time: " + endDateTime);
                endTime = LocalDateTime.parse(endDateTime, DATE_TIME_FORMATTER);
                System.out.println("Successfully parsed dates - Start: " + startTime + ", End: " + endTime);
            } catch (Exception e) {
                System.err.println("Error parsing date time: " + e.getMessage());
                e.printStackTrace();
                return "redirect:/bookings/create/" + fieldId + "?error=invalidDateTimeFormat";
            }

            // Validate times
            if (startTime.isAfter(endTime)) {
                return "redirect:/bookings/create/" + fieldId + "?error=invalidTimes";
            }

            // Cho phép đặt sân trong vòng 1 tiếng tới
            LocalDateTime now = LocalDateTime.now();
            System.out.println("Current time: " + now + ", Start time: " + startTime);

            // Chỉ kiểm tra nếu thời gian bắt đầu đã qua (không phải trong tương lai)
            if (startTime.isBefore(now)) {
                System.err.println("Cannot book for past time: start=" + startTime + ", now=" + now);
                return "redirect:/bookings/create/" + fieldId + "?error=pastTime";
            }

            // Kiểm tra xem sân có khả dụng không
            System.out.println("Checking field availability for field ID: " + fieldId + ", Start: " + startTime + ", End: " + endTime);
            boolean isAvailable = fieldBookingService.isFieldAvailable(fieldId, startTime, endTime);
            System.out.println("Field availability result: " + isAvailable);

            if (!isAvailable) {
                System.err.println("Field is not available for the selected time period");
                return "redirect:/bookings/create/" + fieldId + "?error=fieldNotAvailable";
            }

            System.out.println("Creating booking with parameters: username=" + loggedUser + ", fieldId=" + fieldId +
                ", startTime=" + startTime + ", endTime=" + endTime + ", notes=" + notes + ", numberOfPlayers=" + numberOfPlayers);

            FieldBooking booking = fieldBookingService.createBooking(
                loggedUser,
                fieldId,
                startTime,
                endTime,
                notes,
                numberOfPlayers
            );

            System.out.println("Booking created successfully with ID: " + booking.getId());

            // Lấy thông tin sân để hiển thị trong trang xác nhận
            Optional<SportsField> optionalField = sportsFieldService.getFieldById(fieldId);
            if (optionalField.isPresent()) {
                model.addAttribute("field", optionalField.get());
            }

            // Thêm thông tin đặt sân vào model
            model.addAttribute("booking", booking);
            model.addAttribute("loggedUser", loggedUser);

            // Hiển thị trang xác nhận đặt sân
            return "bookingConfirmation";

        } catch (Exception e) {
            // Log lỗi để dễ debug
            System.err.println("Error creating booking: " + e.getMessage());
            e.printStackTrace();

            // Trả về thông báo lỗi cụ thể hơn
            String errorMessage = e.getMessage();
            if (errorMessage == null || errorMessage.isEmpty()) {
                errorMessage = "Unknown error occurred";
            }

            // Giới hạn độ dài của thông báo lỗi để tránh URL quá dài
            if (errorMessage.length() > 100) {
                errorMessage = errorMessage.substring(0, 100) + "...";
            }

            return "redirect:/bookings/create/" + fieldId + "?error=" + errorMessage.replace(" ", "+");
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

    @GetMapping("/confirmation/{id}")
    public String getBookingConfirmation(@PathVariable Long id, HttpSession session, Model model) {
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

        // Get field details
        Optional<SportsField> optionalField = sportsFieldService.getFieldById(booking.getFieldId());
        if (optionalField.isPresent()) {
            model.addAttribute("field", optionalField.get());
        }

        model.addAttribute("booking", booking);
        model.addAttribute("loggedUser", loggedUser);

        return "bookingConfirmation";
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
