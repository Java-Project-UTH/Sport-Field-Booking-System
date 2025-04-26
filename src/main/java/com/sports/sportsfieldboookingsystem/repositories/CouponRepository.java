package com.sports.sportsfieldboookingsystem.repositories;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.sports.sportsfieldboookingsystem.models.Coupon;
import com.sports.sportsfieldboookingsystem.models.Coupon.CouponStatus;

@Repository
public interface CouponRepository extends JpaRepository<Coupon, Long> {
    
    Optional<Coupon> findByCode(String code);
    
    List<Coupon> findByStatus(CouponStatus status);
    
    @Query("SELECT c FROM Coupon c WHERE c.status = 'ACTIVE' AND c.startDate <= ?1 AND c.endDate >= ?1 AND (c.maxUsage = 0 OR c.usageCount < c.maxUsage)")
    List<Coupon> findActiveCoupons(LocalDateTime currentTime);
    
    @Query("SELECT c FROM Coupon c WHERE c.code = ?1 AND c.status = 'ACTIVE' AND c.startDate <= ?2 AND c.endDate >= ?2 AND (c.maxUsage = 0 OR c.usageCount < c.maxUsage)")
    Optional<Coupon> findValidCouponByCode(String code, LocalDateTime currentTime);
    
    @Query("SELECT c FROM Coupon c WHERE c.status = 'ACTIVE' AND c.startDate <= ?1 AND c.endDate >= ?1 AND (c.maxUsage = 0 OR c.usageCount < c.maxUsage) AND c.fieldTypes LIKE %?2%")
    List<Coupon> findActiveCouponsByFieldType(LocalDateTime currentTime, String fieldType);
}
