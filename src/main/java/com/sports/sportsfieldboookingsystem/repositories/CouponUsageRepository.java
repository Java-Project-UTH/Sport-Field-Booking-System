package com.sports.sportsfieldboookingsystem.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.sports.sportsfieldboookingsystem.models.CouponUsage;

@Repository
public interface CouponUsageRepository extends JpaRepository<CouponUsage, Long> {
    
    List<CouponUsage> findByUsername(String username);
    
    List<CouponUsage> findByCouponId(Long couponId);
    
    Optional<CouponUsage> findByBookingId(Long bookingId);
    
    @Query("SELECT COUNT(cu) FROM CouponUsage cu WHERE cu.couponId = ?1 AND cu.username = ?2")
    Integer countByUserAndCoupon(Long couponId, String username);
}
