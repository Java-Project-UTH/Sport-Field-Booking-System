package com.sports.sportsfieldboookingsystem.repositories;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.sports.sportsfieldboookingsystem.models.Promotion;
import com.sports.sportsfieldboookingsystem.models.Promotion.PromotionStatus;

@Repository
public interface PromotionRepository extends JpaRepository<Promotion, Long> {
    
    List<Promotion> findByStatus(PromotionStatus status);
    
    @Query("SELECT p FROM Promotion p WHERE p.status = 'ACTIVE' AND p.startDate <= ?1 AND p.endDate >= ?1")
    List<Promotion> findActivePromotions(LocalDateTime currentTime);
    
    @Query("SELECT p FROM Promotion p WHERE p.status = 'ACTIVE' AND p.startDate <= ?1 AND p.endDate >= ?1 AND p.fieldTypes LIKE %?2%")
    List<Promotion> findActivePromotionsByFieldType(LocalDateTime currentTime, String fieldType);
    
    @Query("SELECT p FROM Promotion p WHERE p.status = 'ACTIVE' AND p.startDate <= ?1 AND p.endDate >= ?1 AND p.minBookingValue <= ?2")
    List<Promotion> findActivePromotionsByMinBookingValue(LocalDateTime currentTime, Float bookingValue);
}
