package com.sports.sportsfieldboookingsystem.models;

import java.util.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

@Entity
@Table(name = "loyalty_points")
public class LoyaltyPoint {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String username;
    
    @Column(nullable = false)
    private Integer points; // Số điểm hiện tại
    
    @Column(nullable = false)
    private Integer totalEarnedPoints; // Tổng số điểm đã kiếm được
    
    @Column(nullable = false)
    private Integer totalUsedPoints; // Tổng số điểm đã sử dụng
    
    @Column(nullable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    @Temporal(TemporalType.TIMESTAMP)
    private Date created_at;

    @Column(nullable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updated_at;
    
    // Constructors
    public LoyaltyPoint() {
        this.created_at = new Date();
        this.updated_at = new Date();
        this.points = 0;
        this.totalEarnedPoints = 0;
        this.totalUsedPoints = 0;
    }
    
    public LoyaltyPoint(String username) {
        this.username = username;
        this.points = 0;
        this.totalEarnedPoints = 0;
        this.totalUsedPoints = 0;
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

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Integer getPoints() {
        return points;
    }

    public void setPoints(Integer points) {
        this.points = points;
    }

    public Integer getTotalEarnedPoints() {
        return totalEarnedPoints;
    }

    public void setTotalEarnedPoints(Integer totalEarnedPoints) {
        this.totalEarnedPoints = totalEarnedPoints;
    }

    public Integer getTotalUsedPoints() {
        return totalUsedPoints;
    }

    public void setTotalUsedPoints(Integer totalUsedPoints) {
        this.totalUsedPoints = totalUsedPoints;
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
    
    // Phương thức thêm điểm
    public void addPoints(Integer pointsToAdd) {
        this.points += pointsToAdd;
        this.totalEarnedPoints += pointsToAdd;
        this.updated_at = new Date();
    }
    
    // Phương thức sử dụng điểm
    public boolean usePoints(Integer pointsToUse) {
        if (this.points >= pointsToUse) {
            this.points -= pointsToUse;
            this.totalUsedPoints += pointsToUse;
            this.updated_at = new Date();
            return true;
        }
        return false;
    }
    
    // Phương thức tính cấp độ thành viên dựa trên tổng điểm
    public String getMembershipLevel() {
        if (totalEarnedPoints >= 1000) {
            return "VIP";
        } else if (totalEarnedPoints >= 500) {
            return "Gold";
        } else if (totalEarnedPoints >= 200) {
            return "Silver";
        } else {
            return "Bronze";
        }
    }
    
    // Phương thức tính tỷ lệ giảm giá dựa trên cấp độ thành viên
    public Float getDiscountRate() {
        String level = getMembershipLevel();
        switch (level) {
            case "VIP":
                return 10.0f; // Giảm 10%
            case "Gold":
                return 7.0f; // Giảm 7%
            case "Silver":
                return 5.0f; // Giảm 5%
            case "Bronze":
                return 2.0f; // Giảm 2%
            default:
                return 0.0f;
        }
    }
}
