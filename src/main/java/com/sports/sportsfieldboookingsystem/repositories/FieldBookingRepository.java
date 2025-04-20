package com.sports.sportsfieldboookingsystem.repositories;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.sports.sportsfieldboookingsystem.models.FieldBooking;
import com.sports.sportsfieldboookingsystem.models.FieldBooking.BookingStatus;

@Repository
public interface FieldBookingRepository extends JpaRepository<FieldBooking, Long> {
    List<FieldBooking> findByUsername(String username);
    List<FieldBooking> findByFieldId(Long fieldId);
    List<FieldBooking> findByStatus(BookingStatus status);

    @Query("SELECT b FROM FieldBooking b WHERE b.fieldId = ?1 AND b.status != 'CANCELLED' AND ((b.startTime <= ?2 AND b.endTime >= ?2) OR (b.startTime <= ?3 AND b.endTime >= ?3) OR (b.startTime >= ?2 AND b.endTime <= ?3))")
    List<FieldBooking> findOverlappingBookings(Long fieldId, LocalDateTime startTime, LocalDateTime endTime);

    List<FieldBooking> findByUsernameAndStatus(String username, BookingStatus status);

    @Query("SELECT b FROM FieldBooking b WHERE b.fieldId = :fieldId AND b.status != 'CANCELLED' AND DATE(b.startTime) = :bookingDate ORDER BY b.startTime")
    List<FieldBooking> findByFieldIdAndDate(@Param("fieldId") Long fieldId, @Param("bookingDate") LocalDate bookingDate);

    @Query("SELECT b FROM FieldBooking b WHERE b.status != 'CANCELLED' AND DATE(b.startTime) = :bookingDate ORDER BY b.fieldId, b.startTime")
    List<FieldBooking> findByDate(@Param("bookingDate") LocalDate bookingDate);
}
