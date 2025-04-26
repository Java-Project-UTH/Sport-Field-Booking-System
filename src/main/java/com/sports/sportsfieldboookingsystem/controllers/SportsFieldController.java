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

    /**
     * Assign default images to fields based on their type if no image is set
     * This is done in-memory and doesn't modify the database
     */
    private void assignDefaultImages(List<SportsField> fields) {
        if (fields == null || fields.isEmpty()) {
            return;
        }

        for (SportsField field : fields) {
            if (field.getImageUrl() == null || field.getImageUrl().isEmpty()) {
                String imageUrl = getDefaultImageForFieldType(field.getFieldType(), field.getId());
                field.setImageUrl(imageUrl);
            }
        }
    }

    /**
     * Get default image URL based on field type
     * Using optimized images for faster loading
     */
    private String getDefaultImageForFieldType(FieldType fieldType, Long fieldId) {
        if (fieldId == null) {
            fieldId = 1L; // Default to 1 if ID is null
        }

        // Use alternating images (1 or 2) based on field ID (odd or even)
        String imageNumber = (fieldId % 2 == 0) ? "1" : "2";

        switch (fieldType) {
            case FOOTBALL:
                return "/images/football" + imageNumber + ".jpg";
            case BASKETBALL:
                return "/images/basketball" + imageNumber + ".jpg";
            case TENNIS:
                return "/images/tennis" + imageNumber + ".jpg";
            case BADMINTON:
                return "/images/badminton" + imageNumber + ".jpg";
            case VOLLEYBALL:
                return "/images/volleyball" + imageNumber + ".jpg";
            case SWIMMING:
                return "/images/swimming" + imageNumber + ".jpg";
            default:
                return "/images/football1.jpg"; // Use a known existing image as default
        }
    }

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

        // Assign default images to fields that don't have images
        assignDefaultImages(fields);

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

        // Assign default image if no image is set
        if (field.getImageUrl() == null || field.getImageUrl().isEmpty()) {
            field.setImageUrl(getDefaultImageForFieldType(field.getFieldType(), field.getId()));
        }

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
