package com.sports.sportsfieldboookingsystem.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sports.sportsfieldboookingsystem.models.SportsField;
import com.sports.sportsfieldboookingsystem.models.SportsField.FieldType;

@Repository
public interface SportsFieldRepository extends JpaRepository<SportsField, Long> {
    List<SportsField> findByFieldType(FieldType fieldType);
    List<SportsField> findByLocation(String location);
    List<SportsField> findByPricePerHourLessThanEqual(Float price);
    List<SportsField> findByIsIndoor(Boolean isIndoor);
}
