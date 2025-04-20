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
        // Tạo transaction ID ngẫu nhiên
        String transactionId = generateTransactionId();
        
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
        
        return paymentRepository.save(payment);
    }
    
    /**
     * Xử lý thanh toán (giả lập)
     */
    public Payment processPayment(Long paymentId) {
        Optional<Payment> optionalPayment = paymentRepository.findById(paymentId);
        if (!optionalPayment.isPresent()) {
            throw new IllegalArgumentException("Payment not found");
        }
        
        Payment payment = optionalPayment.get();
        
        // Giả lập xử lý thanh toán (thành công 90% thời gian)
        Random random = new Random();
        boolean isSuccessful = random.nextDouble() < 0.9;
        
        if (isSuccessful) {
            payment.setStatus(PaymentStatus.COMPLETED);
            
            // Cập nhật trạng thái đặt sân thành CONFIRMED
            Optional<FieldBooking> optionalBooking = fieldBookingService.getBookingById(payment.getBookingId());
            if (optionalBooking.isPresent()) {
                fieldBookingService.confirmBooking(payment.getBookingId());
            }
        } else {
            payment.setStatus(PaymentStatus.FAILED);
        }
        
        return paymentRepository.save(payment);
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
