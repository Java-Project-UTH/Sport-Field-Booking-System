package com.sports.sportsfieldboookingsystem.controllers;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sports.sportsfieldboookingsystem.handlers.SessionHandler;
import com.sports.sportsfieldboookingsystem.models.Review;
import com.sports.sportsfieldboookingsystem.services.ReviewService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/reviews")
public class ReviewController {
    
    @Autowired
    private ReviewService reviewService;
    
    @PostMapping("/create")
    public String createReview(
            @RequestParam Long fieldId,
            @RequestParam Integer rating,
            @RequestParam(required = false) String comment,
            HttpSession session) {
        
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        try {
            reviewService.createReview(loggedUser, fieldId, rating, comment);
            return "redirect:/fields/" + fieldId + "?success=reviewAdded";
        } catch (Exception e) {
            return "redirect:/fields/" + fieldId + "?error=" + e.getMessage();
        }
    }
    
    @PostMapping("/{id}/update")
    public String updateReview(
            @PathVariable Long id,
            @RequestParam Integer rating,
            @RequestParam(required = false) String comment,
            HttpSession session) {
        
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        Optional<Review> optionalReview = reviewService.getReviewById(id);
        if (!optionalReview.isPresent()) {
            return "redirect:/user/profile?error=reviewNotFound";
        }
        
        Review review = optionalReview.get();
        
        // Check if the review belongs to the logged-in user
        if (!review.getUsername().equals(loggedUser)) {
            return "redirect:/user/profile?error=unauthorized";
        }
        
        try {
            reviewService.updateReview(id, rating, comment);
            return "redirect:/fields/" + review.getFieldId() + "?success=reviewUpdated";
        } catch (Exception e) {
            return "redirect:/fields/" + review.getFieldId() + "?error=" + e.getMessage();
        }
    }
    
    @PostMapping("/{id}/delete")
    public String deleteReview(@PathVariable Long id, HttpSession session) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        if (loggedUser == null) return "redirect:/login";
        
        Optional<Review> optionalReview = reviewService.getReviewById(id);
        if (!optionalReview.isPresent()) {
            return "redirect:/user/profile?error=reviewNotFound";
        }
        
        Review review = optionalReview.get();
        
        // Check if the review belongs to the logged-in user
        if (!review.getUsername().equals(loggedUser)) {
            return "redirect:/user/profile?error=unauthorized";
        }
        
        Long fieldId = review.getFieldId();
        reviewService.deleteReview(id);
        
        return "redirect:/fields/" + fieldId + "?success=reviewDeleted";
    }
}
