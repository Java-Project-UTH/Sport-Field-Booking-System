package com.sports.sportsfieldboookingsystem.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.sports.sportsfieldboookingsystem.models.Review;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findByUsername(String username);
    List<Review> findByFieldId(Long fieldId);
    
    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.fieldId = ?1")
    Double getAverageRatingForField(Long fieldId);
}
