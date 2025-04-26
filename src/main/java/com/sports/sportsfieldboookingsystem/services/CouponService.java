package com.sports.sportsfieldboookingsystem.services;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sports.sportsfieldboookingsystem.models.Coupon;
import com.sports.sportsfieldboookingsystem.models.CouponUsage;
import com.sports.sportsfieldboookingsystem.models.SportsField;
import com.sports.sportsfieldboookingsystem.models.Coupon.CouponStatus;
import com.sports.sportsfieldboookingsystem.repositories.CouponRepository;
import com.sports.sportsfieldboookingsystem.repositories.CouponUsageRepository;

@Service
public class CouponService {
    
    @Autowired
    private CouponRepository couponRepository;
    
    @Autowired
    private CouponUsageRepository couponUsageRepository;
    
    /**
     * Lấy tất cả mã giảm giá
     */
    public List<Coupon> getAllCoupons() {
        return couponRepository.findAll();
    }
    
    /**
     * Lấy mã giảm giá theo ID
     */
    public Optional<Coupon> getCouponById(Long id) {
        return couponRepository.findById(id);
    }
    
    /**
     * Lấy mã giảm giá theo mã code
     */
    public Optional<Coupon> getCouponByCode(String code) {
        return couponRepository.findByCode(code);
    }
    
    /**
     * Lấy danh sách mã giảm giá đang hoạt động
     */
    public List<Coupon> getActiveCoupons() {
        return couponRepository.findActiveCoupons(LocalDateTime.now());
    }
    
    /**
     * Kiểm tra mã giảm giá có hợp lệ không
     */
    public Optional<Coupon> validateCoupon(String code) {
        return couponRepository.findValidCouponByCode(code, LocalDateTime.now());
    }
    
    /**
     * Kiểm tra mã giảm giá có hợp lệ cho người dùng không
     */
    public boolean isValidForUser(Coupon coupon, String username) {
        // Kiểm tra số lần sử dụng của người dùng
        Integer usageCount = couponUsageRepository.countByUserAndCoupon(coupon.getId(), username);
        return usageCount < coupon.getMaxUsagePerUser();
    }
    
    /**
     * Tạo mã giảm giá mới
     */
    public Coupon createCoupon(Coupon coupon) {
        return couponRepository.save(coupon);
    }
    
    /**
     * Cập nhật mã giảm giá
     */
    public Coupon updateCoupon(Coupon coupon) {
        return couponRepository.save(coupon);
    }
    
    /**
     * Xóa mã giảm giá
     */
    public void deleteCoupon(Long id) {
        couponRepository.deleteById(id);
    }
    
    /**
     * Cập nhật trạng thái mã giảm giá
     */
    public Coupon updateCouponStatus(Long id, CouponStatus status) {
        Optional<Coupon> optionalCoupon = couponRepository.findById(id);
        if (optionalCoupon.isPresent()) {
            Coupon coupon = optionalCoupon.get();
            coupon.setStatus(status);
            return couponRepository.save(coupon);
        }
        return null;
    }
    
    /**
     * Áp dụng mã giảm giá cho đặt sân
     */
    @Transactional
    public Optional<Float> applyCoupon(String code, String username, Long bookingId, Float bookingAmount, SportsField.FieldType fieldType) {
        // Kiểm tra mã giảm giá có hợp lệ không
        Optional<Coupon> optionalCoupon = validateCoupon(code);
        if (!optionalCoupon.isPresent()) {
            return Optional.empty();
        }
        
        Coupon coupon = optionalCoupon.get();
        
        // Kiểm tra loại sân có áp dụng không
        if (coupon.getFieldTypes() != null && !coupon.getFieldTypes().isEmpty() && 
            !coupon.getFieldTypes().contains(fieldType.toString())) {
            return Optional.empty();
        }
        
        // Kiểm tra số lần sử dụng của người dùng
        if (!isValidForUser(coupon, username)) {
            return Optional.empty();
        }
        
        // Tính toán số tiền giảm giá
        Float discountAmount = coupon.calculateDiscount(bookingAmount);
        
        // Tạo bản ghi sử dụng mã giảm giá
        CouponUsage couponUsage = new CouponUsage(coupon.getId(), username, bookingId, discountAmount);
        couponUsageRepository.save(couponUsage);
        
        // Cập nhật số lần sử dụng của mã giảm giá
        coupon.incrementUsageCount();
        couponRepository.save(coupon);
        
        return Optional.of(discountAmount);
    }
    
    /**
     * Lấy lịch sử sử dụng mã giảm giá của người dùng
     */
    public List<CouponUsage> getUserCouponUsage(String username) {
        return couponUsageRepository.findByUsername(username);
    }
    
    /**
     * Lấy lịch sử sử dụng của một mã giảm giá
     */
    public List<CouponUsage> getCouponUsageHistory(Long couponId) {
        return couponUsageRepository.findByCouponId(couponId);
    }
    
    /**
     * Tạo mã giảm giá ngẫu nhiên
     */
    public String generateRandomCouponCode() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 8; i++) {
            int index = (int) (Math.random() * chars.length());
            sb.append(chars.charAt(index));
        }
        return sb.toString();
    }
}
