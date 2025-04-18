package com.sports.sportsfieldboookingsystem.services;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sports.sportsfieldboookingsystem.models.Review;
import com.sports.sportsfieldboookingsystem.repositories.ReviewRepository;

@Service
public class ReviewService {
    
    @Autowired
    private ReviewRepository reviewRepository;
    
    public List<Review> getAllReviews() {
        return reviewRepository.findAll();
    }
    
    public Optional<Review> getReviewById(Long id) {
        return reviewRepository.findById(id);
    }
    
    public List<Review> getReviewsByUser(String username) {
        return reviewRepository.findByUsername(username);
    }
    
    public List<Review> getReviewsByField(Long fieldId) {
        return reviewRepository.findByFieldId(fieldId);
    }
    
    public Double getAverageRatingForField(Long fieldId) {
        return reviewRepository.getAverageRatingForField(fieldId);
    }
    
    public Review createReview(String username, Long fieldId, Integer rating, String comment) {
        // Validate rating (1-5)
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
        
        Review review = new Review(username, fieldId, rating, comment);
        return reviewRepository.save(review);
    }
    
    public Review updateReview(Long reviewId, Integer rating, String comment) {
        Optional<Review> optionalReview = reviewRepository.findById(reviewId);
        if (!optionalReview.isPresent()) {
            throw new RuntimeException("Review not found");
        }
        
        // Validate rating (1-5)
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
        
        Review review = optionalReview.get();
        review.setRating(rating);
        review.setComment(comment);
        
        return reviewRepository.save(review);
    }
    
    public void deleteReview(Long reviewId) {
        reviewRepository.deleteById(reviewId);
    }
}
