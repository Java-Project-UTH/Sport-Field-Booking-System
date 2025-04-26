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
@Table(name = "coupons")
public class Coupon {
    
    public enum CouponType {
        PERCENTAGE, // Giảm giá theo phần trăm
        FIXED_AMOUNT // Giảm giá một số tiền cố định
    }
    
    public enum CouponStatus {
        ACTIVE, // Đang hoạt động
        INACTIVE, // Không hoạt động
        EXPIRED // Đã hết hạn
    }
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String code; // Mã coupon
    
    @Column(nullable = false)
    private String name;
    
    @Column(nullable = false)
    private String description;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private CouponType type;
    
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
    
    @Column(nullable = false)
    private Integer maxUsage; // Số lần sử dụng tối đa
    
    @Column(nullable = false)
    private Integer usageCount; // Số lần đã sử dụng
    
    @Column(nullable = false)
    private Integer maxUsagePerUser; // Số lần sử dụng tối đa cho mỗi người dùng
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private CouponStatus status;
    
    @Column(nullable = true)
    private String fieldTypes; // Các loại sân áp dụng (lưu dạng chuỗi ngăn cách bởi dấu phẩy)
    
    @Column(nullable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    @Temporal(TemporalType.TIMESTAMP)
    private Date created_at;

    @Column(nullable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updated_at;
    
    // Constructors
    public Coupon() {
        this.created_at = new Date();
        this.updated_at = new Date();
        this.usageCount = 0;
    }
    
    public Coupon(String code, String name, String description, CouponType type, Float value, Float minBookingValue,
            Float maxDiscountAmount, LocalDateTime startDate, LocalDateTime endDate, Integer maxUsage,
            Integer maxUsagePerUser, CouponStatus status, String fieldTypes) {
        this.code = code;
        this.name = name;
        this.description = description;
        this.type = type;
        this.value = value;
        this.minBookingValue = minBookingValue;
        this.maxDiscountAmount = maxDiscountAmount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.maxUsage = maxUsage;
        this.usageCount = 0;
        this.maxUsagePerUser = maxUsagePerUser;
        this.status = status;
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

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
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

    public CouponType getType() {
        return type;
    }

    public void setType(CouponType type) {
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

    public Integer getMaxUsage() {
        return maxUsage;
    }

    public void setMaxUsage(Integer maxUsage) {
        this.maxUsage = maxUsage;
    }

    public Integer getUsageCount() {
        return usageCount;
    }

    public void setUsageCount(Integer usageCount) {
        this.usageCount = usageCount;
    }

    public Integer getMaxUsagePerUser() {
        return maxUsagePerUser;
    }

    public void setMaxUsagePerUser(Integer maxUsagePerUser) {
        this.maxUsagePerUser = maxUsagePerUser;
    }

    public CouponStatus getStatus() {
        return status;
    }

    public void setStatus(CouponStatus status) {
        this.status = status;
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
    
    // Phương thức tăng số lần sử dụng
    public void incrementUsageCount() {
        this.usageCount++;
    }
    
    // Phương thức kiểm tra coupon có thể sử dụng không
    public boolean isValid() {
        LocalDateTime now = LocalDateTime.now();
        return status == CouponStatus.ACTIVE && 
               now.isAfter(startDate) && 
               now.isBefore(endDate) &&
               (maxUsage == 0 || usageCount < maxUsage);
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
        }
        
        return discount;
    }
}
