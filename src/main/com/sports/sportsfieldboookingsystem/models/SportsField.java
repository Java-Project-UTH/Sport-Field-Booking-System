package com.sports.sportsfieldboookingsystem.models;

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
@Table(name = "sports_fields")
public class SportsField {
    
    public enum FieldType {
        FOOTBALL, BASKETBALL, TENNIS, BADMINTON, VOLLEYBALL, SWIMMING
    }
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String fieldName;
    
    @Column(nullable = false)
    private String location;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private FieldType fieldType;
    
    @Column(nullable = false)
    private Float pricePerHour;
    
    @Column(nullable = false)
    private Boolean isIndoor;
    
    @Column(nullable = false)
    private Boolean hasLighting;
    
    private String description;
    
    private String imageUrl;
    
    @Column(nullable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    @Temporal(TemporalType.TIMESTAMP)
    private Date created_at;

    @Column(nullable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updated_at;

    public SportsField() {
        this.created_at = new Date();
        this.updated_at = new Date();
    }

    public SportsField(String fieldName, String location, FieldType fieldType, Float pricePerHour, Boolean isIndoor,
            Boolean hasLighting, String description, String imageUrl) {
        this.fieldName = fieldName;
        this.location = location;
        this.fieldType = fieldType;
        this.pricePerHour = pricePerHour;
        this.isIndoor = isIndoor;
        this.hasLighting = hasLighting;
        this.description = description;
        this.imageUrl = imageUrl;
        this.created_at = new Date();
        this.updated_at = new Date();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public FieldType getFieldType() {
        return fieldType;
    }

    public void setFieldType(FieldType fieldType) {
        this.fieldType = fieldType;
    }

    public Float getPricePerHour() {
        return pricePerHour;
    }

    public void setPricePerHour(Float pricePerHour) {
        this.pricePerHour = pricePerHour;
    }

    public Boolean getIsIndoor() {
        return isIndoor;
    }

    public void setIsIndoor(Boolean isIndoor) {
        this.isIndoor = isIndoor;
    }

    public Boolean getHasLighting() {
        return hasLighting;
    }

    public void setHasLighting(Boolean hasLighting) {
        this.hasLighting = hasLighting;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
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
}
