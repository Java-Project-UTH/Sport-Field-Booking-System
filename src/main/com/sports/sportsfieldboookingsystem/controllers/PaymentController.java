package com.sports.sportsfieldboookingsystem.controllers;

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
import com.sports.sportsfieldboookingsystem.models.Payment;
import com.sports.sportsfieldboookingsystem.models.Payment.PaymentMethod;
import com.sports.sportsfieldboookingsystem.models.Payment.PaymentStatus;
import com.sports.sportsfieldboookingsystem.models.SportsField;
import com.sports.sportsfieldboookingsystem.services.FieldBookingService;
import com.sports.sportsfieldboookingsystem.services.PaymentService;
import com.sports.sportsfieldboookingsystem.services.SportsFieldService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private FieldBookingService fieldBookingService;

    @Autowired
    private SportsFieldService sportsFieldService;

    @Autowired
    private PaymentService paymentService;

    @GetMapping("/{bookingId}")
    public String getPaymentPage(
            @PathVariable Long bookingId,
            @RequestParam(required = false) String isNew,
            HttpSession session,
            Model model) {
        // Log thông tin debug
        System.out.println("Payment page requested for booking ID: " + bookingId);

        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) {
            System.out.println("User not logged in, redirecting to login");
            return "redirect:/login";
        }
        System.out.println("Logged user: " + loggedUser);

        Optional<FieldBooking> optionalBooking;
        try {
            optionalBooking = fieldBookingService.getBookingById(bookingId);
            if (!optionalBooking.isPresent()) {
                System.out.println("Booking not found: " + bookingId);
                return "redirect:/user/profile?error=bookingNotFound";
            }
            System.out.println("Booking found: " + optionalBooking.get().getId());
        } catch (Exception e) {
            System.err.println("Error in getPaymentPage: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/error?message=" + e.getMessage();
        }

        FieldBooking booking = optionalBooking.get();

        // Check if the booking belongs to the logged-in user
        if (!booking.getUsername().equals(loggedUser)) {
            return "redirect:/user/profile?error=unauthorized";
        }

        // Kiểm tra trạng thái đặt sân
        if (booking.getStatus() == FieldBooking.BookingStatus.CANCELLED) {
            return "redirect:/bookings/" + bookingId + "?error=bookingCancelled";
        }

        if (booking.getStatus() == FieldBooking.BookingStatus.CONFIRMED) {
            return "redirect:/bookings/" + bookingId + "?error=alreadyPaid";
        }

        // Get field details
        Optional<SportsField> optionalField = sportsFieldService.getFieldById(booking.getFieldId());
        if (optionalField.isPresent()) {
            model.addAttribute("field", optionalField.get());
        }

        // Kiểm tra xem đã có thanh toán nào đang chờ xử lý không
        Optional<Payment> optionalPendingPayment = paymentService.getLatestPaymentByBookingId(bookingId);
        if (optionalPendingPayment.isPresent() && optionalPendingPayment.get().getStatus() == PaymentStatus.PENDING) {
            model.addAttribute("pendingPayment", optionalPendingPayment.get());
        }

        model.addAttribute("booking", booking);
        model.addAttribute("loggedUser", loggedUser);
        model.addAttribute("paymentMethods", PaymentMethod.values());

        return "payment";
    }

    @PostMapping("/process/{bookingId}")
    public String processPayment(
            @PathVariable Long bookingId,
            @RequestParam String paymentMethod,
            @RequestParam(required = false) String cardNumber,
            @RequestParam(required = false) String cardHolder,
            @RequestParam(required = false) String expiryDate,
            @RequestParam(required = false) String cvv,
            @RequestParam(required = false) String notes,
            HttpSession session,
            Model model) {

        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";

        try {
            Optional<FieldBooking> optionalBooking = fieldBookingService.getBookingById(bookingId);
            if (!optionalBooking.isPresent()) {
                return "redirect:/user/profile?error=bookingNotFound";
            }

            FieldBooking booking = optionalBooking.get();

            // Check if the booking belongs to the logged-in user
            if (!booking.getUsername().equals(loggedUser)) {
                return "redirect:/user/profile?error=unauthorized";
            }

            // Chuyển đổi chuỗi paymentMethod thành enum PaymentMethod
            PaymentMethod method;
            try {
                method = PaymentMethod.valueOf(paymentMethod);
            } catch (IllegalArgumentException e) {
                method = PaymentMethod.CREDIT_CARD; // Mặc định nếu không hợp lệ
            }

            // Tạo ghi chú từ thông tin thẻ (trong trường hợp thanh toán bằng thẻ)
            StringBuilder paymentNotes = new StringBuilder();
            if (method == PaymentMethod.CREDIT_CARD && cardNumber != null) {
                paymentNotes.append("Card: ").append(maskCardNumber(cardNumber));
                if (cardHolder != null) {
                    paymentNotes.append(", Holder: ").append(cardHolder);
                }
            }

            if (notes != null && !notes.trim().isEmpty()) {
                if (paymentNotes.length() > 0) {
                    paymentNotes.append(", ");
                }
                paymentNotes.append("Notes: ").append(notes);
            }

            // Tạo thanh toán mới
            Payment payment = paymentService.createPayment(
                bookingId,
                booking.getTotalPrice(),
                method,
                paymentNotes.toString()
            );

            // Xử lý thanh toán (giả lập)
            payment = paymentService.processPayment(payment.getId());

            // Kiểm tra kết quả thanh toán
            if (payment.getStatus() == PaymentStatus.COMPLETED) {
                return "redirect:/payment/success/" + bookingId;
            } else {
                return "redirect:/payment/" + bookingId + "?error=paymentFailed";
            }
        } catch (Exception e) {
            return "redirect:/payment/" + bookingId + "?error=" + e.getMessage();
        }
    }

    @GetMapping("/success/{bookingId}")
    public String paymentSuccess(@PathVariable Long bookingId, HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";

        Optional<FieldBooking> optionalBooking = fieldBookingService.getBookingById(bookingId);
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

        // Get payment details
        Optional<Payment> optionalPayment = paymentService.getLatestPaymentByBookingId(bookingId);
        if (optionalPayment.isPresent()) {
            model.addAttribute("payment", optionalPayment.get());
        }

        model.addAttribute("booking", booking);
        model.addAttribute("loggedUser", loggedUser);

        return "paymentSuccess";
    }

    /**
     * Che giấu số thẻ tín dụng để bảo mật
     */
    private String maskCardNumber(String cardNumber) {
        if (cardNumber == null || cardNumber.length() < 4) {
            return cardNumber;
        }

        // Chỉ hiển thị 4 số cuối của thẻ
        String lastFourDigits = cardNumber.substring(cardNumber.length() - 4);
        StringBuilder masked = new StringBuilder();
        for (int i = 0; i < cardNumber.length() - 4; i++) {
            masked.append("*");
        }
        masked.append(lastFourDigits);

        return masked.toString();
    }
}
