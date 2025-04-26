package com.sports.sportsfieldboookingsystem.models;

import java.time.LocalDateTime;
import java.util.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

@Entity
@Table(name = "promotions")
public class Promotion {
    
    public enum PromotionType {
        PERCENTAGE, // Giảm giá theo phần trăm
        FIXED_AMOUNT, // Giảm giá một số tiền cố định
        SPECIAL_PRICE // Giá đặc biệt
    }
    
    public enum PromotionStatus {
        ACTIVE, // Đang hoạt động
        INACTIVE, // Không hoạt động
        SCHEDULED, // Đã lên lịch
        EXPIRED // Đã hết hạn
    }
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    @Column(nullable = false)
    private String description;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PromotionType type;
    
    @Column(nullable = false)
    private Float value; // Giá trị giảm giá (phần trăm hoặc số tiền cố định)
    
    @Column(nullable = false)
    private Float minBookingValue; // Giá trị đặt sân tối thiểu để áp dụng
    
    @Column(nullable = false)
    private Float maxDiscountAmount; // Số tiền giảm tối đa (cho loại phần trăm)
    
    @Column(nullable = false)
    private LocalDateTime startDate; // Ngày bắt đầu
    
    @Column(nullable = false)
    private LocalDateTime endDate; // Ngày kết thúc
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PromotionStatus status;
    
    @Column(nullable = true)
    private String imageUrl; // URL hình ảnh khuyến mãi
    
    @Column(nullable = true)
    private String fieldTypes; // Các loại sân áp dụng (lưu dạng chuỗi ngăn cách bởi dấu phẩy)
    
    @Column(nullable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    @Temporal(TemporalType.TIMESTAMP)
    private Date created_at;

    @Column(nullable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updated_at;
    
    // Constructors
    public Promotion() {
        this.created_at = new Date();
        this.updated_at = new Date();
    }
    
    public Promotion(String name, String description, PromotionType type, Float value, Float minBookingValue,
            Float maxDiscountAmount, LocalDateTime startDate, LocalDateTime endDate, PromotionStatus status,
            String imageUrl, String fieldTypes) {
        this.name = name;
        this.description = description;
        this.type = type;
        this.value = value;
        this.minBookingValue = minBookingValue;
        this.maxDiscountAmount = maxDiscountAmount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.imageUrl = imageUrl;
        this.fieldTypes = fieldTypes;
        this.created_at = new Date();
        this.updated_at = new Date();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public PromotionType getType() {
        return type;
    }

    public void setType(PromotionType type) {
        this.type = type;
    }

    public Float getValue() {
        return value;
    }

    public void setValue(Float value) {
        this.value = value;
    }

    public Float getMinBookingValue() {
        return minBookingValue;
    }

    public void setMinBookingValue(Float minBookingValue) {
        this.minBookingValue = minBookingValue;
    }

    public Float getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(Float maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }

    public LocalDateTime getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
    }

    public LocalDateTime getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDateTime endDate) {
        this.endDate = endDate;
    }

    public PromotionStatus getStatus() {
        return status;
    }

    public void setStatus(PromotionStatus status) {
        this.status = status;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getFieldTypes() {
        return fieldTypes;
    }

    public void setFieldTypes(String fieldTypes) {
        this.fieldTypes = fieldTypes;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }

    public Date getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(Date updated_at) {
        this.updated_at = updated_at;
    }
    
    // Phương thức tính toán số tiền giảm giá
    public Float calculateDiscount(Float bookingAmount) {
        if (bookingAmount < minBookingValue) {
            return 0.0f; // Không đủ điều kiện áp dụng
        }
        
        Float discount = 0.0f;
        
        switch (type) {
            case PERCENTAGE:
                discount = bookingAmount * value / 100;
                // Giới hạn số tiền giảm tối đa
                if (discount > maxDiscountAmount) {
                    discount = maxDiscountAmount;
                }
                break;
            case FIXED_AMOUNT:
                discount = value;
                break;
            case SPECIAL_PRICE:
                // Giá đặc biệt, giảm giá = giá gốc - giá đặc biệt
                discount = bookingAmount - value;
                if (discount < 0) {
                    discount = 0.0f;
                }
                break;
        }
        
        return discount;
    }
    
    // Phương thức kiểm tra khuyến mãi có đang hoạt động không
    public boolean isActive() {
        LocalDateTime now = LocalDateTime.now();
        return status == PromotionStatus.ACTIVE && 
               now.isAfter(startDate) && 
               now.isBefore(endDate);
    }
}
