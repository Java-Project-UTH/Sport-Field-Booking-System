package com.sports.sportsfieldboookingsystem.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sports.sportsfieldboookingsystem.models.Payment;
import com.sports.sportsfieldboookingsystem.models.Payment.PaymentStatus;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    
    List<Payment> findByBookingId(Long bookingId);
    
    Optional<Payment> findTopByBookingIdOrderByPaymentTimeDesc(Long bookingId);
    
    List<Payment> findByStatus(PaymentStatus status);
}
