package com.sports.sportsfieldboookingsystem.models;

import java.util.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

@Entity
@Table(name = "user_memberships")
public class UserMembership {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private Users user;
    
    @ManyToOne
    @JoinColumn(name = "plan_id", nullable = false)
    private MembershipPlan plan;
    
    @Column(nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date startDate;
    
    @Column(nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date endDate;
    
    @Column(nullable = false)
    private Boolean isActive;
    
    @Column(nullable = false)
    private Integer bookingsUsedThisMonth;
    
    @Column
    private String paymentReference;
    
    @Column(nullable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    
    // Constructors
    public UserMembership() {
        this.createdAt = new Date();
        this.bookingsUsedThisMonth = 0;
        this.isActive = true;
    }
    
    public UserMembership(Users user, MembershipPlan plan, Date startDate, Date endDate) {
        this.user = user;
        this.plan = plan;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = true;
        this.bookingsUsedThisMonth = 0;
        this.createdAt = new Date();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Users getUser() {
        return user;
    }
    
    public void setUser(Users user) {
        this.user = user;
    }
    
    public MembershipPlan getPlan() {
        return plan;
    }
    
    public void setPlan(MembershipPlan plan) {
        this.plan = plan;
    }
    
    public Date getStartDate() {
        return startDate;
    }
    
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }
    
    public Date getEndDate() {
        return endDate;
    }
    
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    public Boolean getIsActive() {
        return isActive;
    }
    
    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
    
    public Integer getBookingsUsedThisMonth() {
        return bookingsUsedThisMonth;
    }
    
    public void setBookingsUsedThisMonth(Integer bookingsUsedThisMonth) {
        this.bookingsUsedThisMonth = bookingsUsedThisMonth;
    }
    
    public String getPaymentReference() {
        return paymentReference;
    }
    
    public void setPaymentReference(String paymentReference) {
        this.paymentReference = paymentReference;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    // Helper methods
    public boolean isExpired() {
        return new Date().after(endDate);
    }
    
    public boolean canMakeBooking() {
        return isActive && !isExpired() && (bookingsUsedThisMonth < plan.getMaxBookingsPerMonth());
    }
    
    public int getRemainingBookings() {
        return plan.getMaxBookingsPerMonth() - bookingsUsedThisMonth;
    }
    
    public void incrementBookingsUsed() {
        this.bookingsUsedThisMonth++;
    }
}
