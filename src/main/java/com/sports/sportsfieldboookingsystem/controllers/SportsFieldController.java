package com.sports.sportsfieldboookingsystem.controllers;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sports.sportsfieldboookingsystem.handlers.SessionHandler;
import com.sports.sportsfieldboookingsystem.models.Review;
import com.sports.sportsfieldboookingsystem.models.SportsField;
import com.sports.sportsfieldboookingsystem.models.SportsField.FieldType;
import com.sports.sportsfieldboookingsystem.services.ReviewService;
import com.sports.sportsfieldboookingsystem.services.SportsFieldService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/fields")
public class SportsFieldController {
    
    @Autowired
    private SportsFieldService sportsFieldService;
    
    @Autowired
    private ReviewService reviewService;
    
    @GetMapping("")
    public String getAllFields(
            @RequestParam(required = false) FieldType type,
            @RequestParam(required = false) String location,
            @RequestParam(required = false) Float maxPrice,
            @RequestParam(required = false) Boolean indoor,
            HttpSession session, 
            Model model) {
        
        String loggedUser = SessionHandler.getUsernameSession(session);
        model.addAttribute("loggedUser", loggedUser);
        
        List<SportsField> fields;
        
        if (type != null) {
            fields = sportsFieldService.getFieldsByType(type);
        } else if (location != null && !location.isEmpty()) {
            fields = sportsFieldService.getFieldsByLocation(location);
        } else if (maxPrice != null) {
            fields = sportsFieldService.getFieldsByMaxPrice(maxPrice);
        } else if (indoor != null) {
            fields = sportsFieldService.getIndoorFields(indoor);
        } else {
            fields = sportsFieldService.getAllFields();
        }
        
        model.addAttribute("fields", fields);
        model.addAttribute("fieldTypes", FieldType.values());
        
        return "fields";
    }
    
    @GetMapping("/{id}")
    public String getFieldDetails(@PathVariable Long id, HttpSession session, Model model) {
        String loggedUser = SessionHandler.getUsernameSession(session);
        model.addAttribute("loggedUser", loggedUser);
        
        Optional<SportsField> optionalField = sportsFieldService.getFieldById(id);
        if (!optionalField.isPresent()) {
            return "redirect:/fields?error=notFound";
        }
        
        SportsField field = optionalField.get();
        model.addAttribute("field", field);
        
        // Get reviews for this field
        List<Review> reviews = reviewService.getReviewsByField(id);
        model.addAttribute("reviews", reviews);
        
        // Get average rating
        Double averageRating = reviewService.getAverageRatingForField(id);
        model.addAttribute("averageRating", averageRating != null ? averageRating : 0.0);
        
        return "fieldDetails";
    }
}
