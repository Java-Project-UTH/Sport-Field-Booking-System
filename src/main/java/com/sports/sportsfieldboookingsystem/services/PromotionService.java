package com.sports.sportsfieldboookingsystem.services;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sports.sportsfieldboookingsystem.models.Promotion;
import com.sports.sportsfieldboookingsystem.models.SportsField;
import com.sports.sportsfieldboookingsystem.models.Promotion.PromotionStatus;
import com.sports.sportsfieldboookingsystem.repositories.PromotionRepository;

@Service
public class PromotionService {
    
    @Autowired
    private PromotionRepository promotionRepository;
    
    /**
     * Lấy tất cả khuyến mãi
     */
    public List<Promotion> getAllPromotions() {
        return promotionRepository.findAll();
    }
    
    /**
     * Lấy khuyến mãi theo ID
     */
    public Optional<Promotion> getPromotionById(Long id) {
        return promotionRepository.findById(id);
    }
    
    /**
     * Lấy danh sách khuyến mãi đang hoạt động
     */
    public List<Promotion> getActivePromotions() {
        return promotionRepository.findActivePromotions(LocalDateTime.now());
    }
    
    /**
     * Lấy danh sách khuyến mãi đang hoạt động theo loại sân
     */
    public List<Promotion> getActivePromotionsByFieldType(SportsField.FieldType fieldType) {
        return promotionRepository.findActivePromotionsByFieldType(LocalDateTime.now(), fieldType.toString());
    }
    
    /**
     * Lấy danh sách khuyến mãi đang hoạt động theo giá trị đặt sân
     */
    public List<Promotion> getActivePromotionsByBookingValue(Float bookingValue) {
        return promotionRepository.findActivePromotionsByMinBookingValue(LocalDateTime.now(), bookingValue);
    }
    
    /**
     * Tạo khuyến mãi mới
     */
    public Promotion createPromotion(Promotion promotion) {
        return promotionRepository.save(promotion);
    }
    
    /**
     * Cập nhật khuyến mãi
     */
    public Promotion updatePromotion(Promotion promotion) {
        return promotionRepository.save(promotion);
    }
    
    /**
     * Xóa khuyến mãi
     */
    public void deletePromotion(Long id) {
        promotionRepository.deleteById(id);
    }
    
    /**
     * Cập nhật trạng thái khuyến mãi
     */
    public Promotion updatePromotionStatus(Long id, PromotionStatus status) {
        Optional<Promotion> optionalPromotion = promotionRepository.findById(id);
        if (optionalPromotion.isPresent()) {
            Promotion promotion = optionalPromotion.get();
            promotion.setStatus(status);
            return promotionRepository.save(promotion);
        }
        return null;
    }
    
    /**
     * Tính toán giảm giá tốt nhất cho đặt sân
     */
    public Float calculateBestDiscount(Float bookingAmount, SportsField.FieldType fieldType) {
        List<Promotion> activePromotions = getActivePromotionsByFieldType(fieldType);
        
        Float maxDiscount = 0.0f;
        
        for (Promotion promotion : activePromotions) {
            if (bookingAmount >= promotion.getMinBookingValue()) {
                Float discount = promotion.calculateDiscount(bookingAmount);
                if (discount > maxDiscount) {
                    maxDiscount = discount;
                }
            }
        }
        
        return maxDiscount;
    }
    
    /**
     * Tìm khuyến mãi tốt nhất cho đặt sân
     */
    public Optional<Promotion> findBestPromotion(Float bookingAmount, SportsField.FieldType fieldType) {
        List<Promotion> activePromotions = getActivePromotionsByFieldType(fieldType);
        
        Float maxDiscount = 0.0f;
        Promotion bestPromotion = null;
        
        for (Promotion promotion : activePromotions) {
            if (bookingAmount >= promotion.getMinBookingValue()) {
                Float discount = promotion.calculateDiscount(bookingAmount);
                if (discount > maxDiscount) {
                    maxDiscount = discount;
                    bestPromotion = promotion;
                }
            }
        }
        
        return Optional.ofNullable(bestPromotion);
    }
}
