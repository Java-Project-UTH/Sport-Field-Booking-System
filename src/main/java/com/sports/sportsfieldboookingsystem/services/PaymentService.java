package com.sports.sportsfieldboookingsystem.services;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sports.sportsfieldboookingsystem.models.FieldBooking;
import com.sports.sportsfieldboookingsystem.models.Payment;
import com.sports.sportsfieldboookingsystem.models.Payment.PaymentMethod;
import com.sports.sportsfieldboookingsystem.models.Payment.PaymentStatus;
import com.sports.sportsfieldboookingsystem.repositories.PaymentRepository;

@Service
public class PaymentService {

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private FieldBookingService fieldBookingService;

    /**
     * Tạo một thanh toán mới
     */
    public Payment createPayment(Long bookingId, Float amount, PaymentMethod method, String notes) {
        System.out.println("Creating payment: bookingId=" + bookingId + ", amount=" + amount + ", method=" + method);

        // Validate input
        if (bookingId == null) {
            System.err.println("Booking ID cannot be null");
            throw new IllegalArgumentException("Booking ID cannot be null");
        }

        if (amount == null || amount <= 0) {
            System.err.println("Amount must be positive");
            throw new IllegalArgumentException("Amount must be positive");
        }

        // Tạo transaction ID ngẫu nhiên
        String transactionId = generateTransactionId();
        System.out.println("Generated transaction ID: " + transactionId);

        // Tạo đối tượng Payment
        Payment payment = new Payment(
            bookingId,
            amount,
            PaymentStatus.PENDING,
            method,
            transactionId,
            LocalDateTime.now(),
            notes
        );

        try {
            Payment savedPayment = paymentRepository.save(payment);
            System.out.println("Payment created with ID: " + savedPayment.getId());
            return savedPayment;
        } catch (Exception e) {
            System.err.println("Error creating payment: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error creating payment: " + e.getMessage(), e);
        }
    }

    /**
     * Xử lý thanh toán (giả lập)
     */
    public Payment processPayment(Long paymentId) {
        System.out.println("Processing payment with ID: " + paymentId);

        Optional<Payment> optionalPayment = paymentRepository.findById(paymentId);
        if (!optionalPayment.isPresent()) {
            System.err.println("Payment not found with ID: " + paymentId);
            throw new IllegalArgumentException("Payment not found");
        }

        Payment payment = optionalPayment.get();
        System.out.println("Found payment: bookingId=" + payment.getBookingId() + ", amount=" + payment.getAmount() + ", method=" + payment.getMethod());

        // Giả lập xử lý thanh toán (thành công 100% thời gian để dễ test)
        boolean isSuccessful = true; // Always successful for testing

        if (isSuccessful) {
            System.out.println("Payment successful, updating status to COMPLETED");
            payment.setStatus(PaymentStatus.COMPLETED);

            // Cập nhật trạng thái đặt sân thành CONFIRMED
            Optional<FieldBooking> optionalBooking = fieldBookingService.getBookingById(payment.getBookingId());
            if (optionalBooking.isPresent()) {
                System.out.println("Updating booking status to CONFIRMED for booking ID: " + payment.getBookingId());
                fieldBookingService.confirmBooking(payment.getBookingId());
            } else {
                System.err.println("Booking not found with ID: " + payment.getBookingId());
            }
        } else {
            System.out.println("Payment failed, updating status to FAILED");
            payment.setStatus(PaymentStatus.FAILED);
        }

        try {
            Payment savedPayment = paymentRepository.save(payment);
            System.out.println("Payment saved with status: " + savedPayment.getStatus());
            return savedPayment;
        } catch (Exception e) {
            System.err.println("Error saving payment: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error saving payment: " + e.getMessage(), e);
        }
    }

    /**
     * Lấy thanh toán theo ID
     */
    public Optional<Payment> getPaymentById(Long paymentId) {
        return paymentRepository.findById(paymentId);
    }

    /**
     * Lấy danh sách thanh toán theo booking ID
     */
    public List<Payment> getPaymentsByBookingId(Long bookingId) {
        return paymentRepository.findByBookingId(bookingId);
    }

    /**
     * Lấy thanh toán mới nhất theo booking ID
     */
    public Optional<Payment> getLatestPaymentByBookingId(Long bookingId) {
        return paymentRepository.findTopByBookingIdOrderByPaymentTimeDesc(bookingId);
    }

    /**
     * Tạo transaction ID ngẫu nhiên
     */
    private String generateTransactionId() {
        return "TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
}
