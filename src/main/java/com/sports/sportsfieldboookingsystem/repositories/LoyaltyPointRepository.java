package com.sports.sportsfieldboookingsystem.repositories;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sports.sportsfieldboookingsystem.models.LoyaltyPoint;

@Repository
public interface LoyaltyPointRepository extends JpaRepository<LoyaltyPoint, Long> {
    
    Optional<LoyaltyPoint> findByUsername(String username);
}
