package com.sports.sportsfieldboookingsystem.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "membership_plans")
public class MembershipPlan {
    
    public enum PlanType {
        FREE, STANDARD, PREMIUM
    }
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, unique = true)
    private PlanType planType;
    
    @Column(nullable = false)
    private String name;
    
    @Column(nullable = false)
    private String description;
    
    @Column(nullable = false)
    private Float price;
    
    @Column(nullable = false)
    private Integer durationDays;
    
    @Column(nullable = false)
    private Integer maxBookingsPerMonth;
    
    @Column(nullable = false)
    private Integer maxBookingDaysInAdvance;
    
    @Column(nullable = false)
    private Float discountPercentage;
    
    @Column(nullable = false)
    private Boolean prioritySupport;
    
    @Column(nullable = false)
    private Boolean freeRescheduling;
    
    // Constructors
    public MembershipPlan() {
    }
    
    public MembershipPlan(PlanType planType, String name, String description, Float price, Integer durationDays,
                          Integer maxBookingsPerMonth, Integer maxBookingDaysInAdvance, Float discountPercentage,
                          Boolean prioritySupport, Boolean freeRescheduling) {
        this.planType = planType;
        this.name = name;
        this.description = description;
        this.price = price;
        this.durationDays = durationDays;
        this.maxBookingsPerMonth = maxBookingsPerMonth;
        this.maxBookingDaysInAdvance = maxBookingDaysInAdvance;
        this.discountPercentage = discountPercentage;
        this.prioritySupport = prioritySupport;
        this.freeRescheduling = freeRescheduling;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public PlanType getPlanType() {
        return planType;
    }
    
    public void setPlanType(PlanType planType) {
        this.planType = planType;
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
    
    public Float getPrice() {
        return price;
    }
    
    public void setPrice(Float price) {
        this.price = price;
    }
    
    public Integer getDurationDays() {
        return durationDays;
    }
    
    public void setDurationDays(Integer durationDays) {
        this.durationDays = durationDays;
    }
    
    public Integer getMaxBookingsPerMonth() {
        return maxBookingsPerMonth;
    }
    
    public void setMaxBookingsPerMonth(Integer maxBookingsPerMonth) {
        this.maxBookingsPerMonth = maxBookingsPerMonth;
    }
    
    public Integer getMaxBookingDaysInAdvance() {
        return maxBookingDaysInAdvance;
    }
    
    public void setMaxBookingDaysInAdvance(Integer maxBookingDaysInAdvance) {
        this.maxBookingDaysInAdvance = maxBookingDaysInAdvance;
    }
    
    public Float getDiscountPercentage() {
        return discountPercentage;
    }
    
    public void setDiscountPercentage(Float discountPercentage) {
        this.discountPercentage = discountPercentage;
    }
    
    public Boolean getPrioritySupport() {
        return prioritySupport;
    }
    
    public void setPrioritySupport(Boolean prioritySupport) {
        this.prioritySupport = prioritySupport;
    }
    
    public Boolean getFreeRescheduling() {
        return freeRescheduling;
    }
    
    public void setFreeRescheduling(Boolean freeRescheduling) {
        this.freeRescheduling = freeRescheduling;
    }
}
