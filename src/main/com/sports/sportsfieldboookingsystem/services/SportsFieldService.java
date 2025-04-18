package com.sports.sportsfieldboookingsystem.services;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sports.sportsfieldboookingsystem.models.SportsField;
import com.sports.sportsfieldboookingsystem.models.SportsField.FieldType;
import com.sports.sportsfieldboookingsystem.repositories.SportsFieldRepository;

@Service
public class SportsFieldService {
    
    @Autowired
    private SportsFieldRepository sportsFieldRepository;
    
    public List<SportsField> getAllFields() {
        return sportsFieldRepository.findAll();
    }
    
    public Optional<SportsField> getFieldById(Long id) {
        return sportsFieldRepository.findById(id);
    }
    
    public List<SportsField> getFieldsByType(FieldType fieldType) {
        return sportsFieldRepository.findByFieldType(fieldType);
    }
    
    public List<SportsField> getFieldsByLocation(String location) {
        return sportsFieldRepository.findByLocation(location);
    }
    
    public List<SportsField> getFieldsByMaxPrice(Float maxPrice) {
        return sportsFieldRepository.findByPricePerHourLessThanEqual(maxPrice);
    }
    
    public List<SportsField> getIndoorFields(Boolean isIndoor) {
        return sportsFieldRepository.findByIsIndoor(isIndoor);
    }
    
    public SportsField saveField(SportsField field) {
        return sportsFieldRepository.save(field);
    }
    
    public void deleteField(Long id) {
        sportsFieldRepository.deleteById(id);
    }
}
